class Reminder < ActiveRecord::Base
	belongs_to :client

	validates :description , presence: true


	def owner
		client
	end
	def target_priority=(value)
    	insert_at(value.to_i)
  	end
end
