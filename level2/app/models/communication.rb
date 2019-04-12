class Communication < ApplicationRecord
  belongs_to :practitioner

  def as_json(options = nil)
    {
      first_name: practitioner.first_name,
      last_name: practitioner.last_name,
      sent_at: sent_at
    }
  end

  def self.all_as_json(options = nil)
  	all.includes(:practitioner).map do |communication|
  		communication.as_json
  	end
  end

end
