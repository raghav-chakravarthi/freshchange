class Website < ApplicationRecord
	belongs_to :subscriber

	def self.db
		Rails.logger.info "Starting DB"
		web = Website.create(url: "aaaa", content: "aaaaa", subscriber: Subscriber.first)
		web.save!
	end
end
