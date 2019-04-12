# rspec app_spec.rb

require 'rspec'

require_relative './app.rb'

RSpec.describe 'Revenue Generator', type: :model do
	let(:data)          { JSON.parse(File.read('data.json')) }
	let(:output)        { JSON.parse(File.read('output.json')) }
	let(:corrupted_data){
							{
								"practitioners" =>
								[
							    	{
								      "id" => 1,
								      "first_name" => "Gregory",
								      "last_name" => "House",
								      "express_delivery" => true
								    }
							  	]
							}
						}
  	def self.described_class
  		RevenueGenerator
	end

	describe '.run' do
		it 'returns expected data' do
			expect(described_class.run(data)).to eq(output)
		end
		it 'returns nil if no input or bad input provided' do
			expect(described_class.run(nil)).to eq(nil)
			expect(described_class.run({})).to eq(nil)
			expect(described_class.run(corrupted_data)).to eq(nil)
		end
	end

	describe '.get_data' do
		it 'returns true if data contains providers and communications, false if not' do
			expect(described_class.get_data(data)).to eq(true)
			expect(described_class.get_data(corrupted_data)).to eq(false)
			expect(described_class.get_data).to eq(false)
		end
	end

	describe '.color' do
		colored_communication = {"id" => 1,"practitioner_id" => 1,"pages_number" => 1,"color" => true,"sent_at" => "2019-03-01 10:00:00"} 
		uncolored_communication = {"id" => 1,"practitioner_id" => 1,"pages_number" => 1,"color" => false,"sent_at" => "2019-03-01 10:00:00"} 
		empty_communication = {}
		
		it 'returns 1 if communication is colored' do
			expect(described_class.color(colored_communication)).to eq(1)
		end
		it 'returns 0 if communication is not colored' do
			expect(described_class.color(uncolored_communication)).to eq(0)
		end
		it 'returns 0 if no communication provided or empty communication provided' do
			expect(described_class.color(nil)).to eq(0)
			expect(described_class.color(empty_communication)).to eq(0)
		end
	end

	describe '.extra_pages' do
		no_page_communication = {"id" => 1,"practitioner_id" => 1,"pages_number" => 0,"color" => true,"sent_at" => "2019-03-01 10:00:00"} 
		one_page_communication = {"id" => 1,"practitioner_id" => 1,"pages_number" => 1,"color" => true,"sent_at" => "2019-03-01 10:00:00"} 
		three_pages_communication = {"id" => 1,"practitioner_id" => 1,"pages_number" => 3,"color" => true,"sent_at" => "2019-03-01 10:00:00"} 
		empty_communication = {}
		
		it 'returns pages number of communication minus 1. Can t be under 0' do
			expect(described_class.extra_pages(no_page_communication)).to eq(0)
			expect(described_class.extra_pages(one_page_communication)).to eq(0)
			expect(described_class.extra_pages(three_pages_communication)).to eq(2)
		end
		it 'returns 0 if no communication provided or empty communication provided' do
			expect(described_class.extra_pages(nil)).to eq(0)
			expect(described_class.extra_pages(empty_communication)).to eq(0)
		end
	end

	describe '.express_delivery' do
		practitioner_express = {"id" => 1,"first_name" => "Gregory","last_name" => "House","express_delivery" => true} 
		practitioner = {"id" => 1,"first_name" => "Gregory","last_name" => "House","express_delivery" => false} 

		it 'returns 1 if practitioner has express delivery' do
			expect(described_class.express_delivery(practitioner_express)).to eq(1)
		end
		it 'returns 0 if practitioner has no express delivery' do
			expect(described_class.express_delivery(practitioner)).to eq(0)
		end
		it 'returns 0 if no practitioner provided or empty practitioner provided' do
			expect(described_class.express_delivery(nil)).to eq(0)
			expect(described_class.express_delivery({})).to eq(0)
		end

	end



end