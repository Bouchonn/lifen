require "json"
require 'active_support'
require 'active_support/core_ext'

class RevenueGenerator
	COM_PRICE = 0.1
	COLOR_PRICE = 0.18
	EXTRA_PAGE_PRICE = 0.07
	EXPRESS_DELIVERY_PRICE = 0.6

	## run with :
	### ruby -r './app.rb' -e 'RevenueGenerator.run'
	def self.run(data)
		self.generate_data if data && get_data(data)
	end

	def self.get_data(data= {})
		@practitioners = data.dig('practitioners')
		@communications = data.dig('communications')
		@dates = @communications.map {|c| c['sent_at'][0, 10] if c['sent_at']}.uniq.compact unless @communications.blank?
		!(@practitioners.blank? || @communications.blank?)
	end

	def self.generate_data
		{ 
			'totals' =>
				@dates.map  do |date|
					daily_formatted_revenue(date)
				end
		}
	end

	def self.daily_formatted_revenue(date)
		return nil unless date
		{
			'sent_on' => date,
			'total' => daily_revenue(date)
		}
	end

	def self.daily_revenue(date)
		return 0.0 unless date
		communications = @communications.select{|communication| communication['sent_at'].index(date)}
		communications.map { |communication| communication_price communication}.sum.round(2)
	end

	def self.communication_price(communication)
		practitioner = @practitioners.find{|practitioner| practitioner.dig('id') == communication.dig('practitioner_id')}
		COM_PRICE + 
		COLOR_PRICE * color(communication) +
		EXTRA_PAGE_PRICE * extra_pages(communication) +
		EXPRESS_DELIVERY_PRICE * express_delivery(practitioner)
	end

	def self.color(communication)
		communication.try(:dig, 'color') ? 1 : 0
	end

	def self.extra_pages(communication)
		[(communication.try(:dig, 'pages_number') || 1) - 1 , 0].max
	end

	def self.express_delivery(practitioner)
		practitioner.try(:dig, 'express_delivery') ? 1 : 0
	end

end
