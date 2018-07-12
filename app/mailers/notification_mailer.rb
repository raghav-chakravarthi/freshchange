class NotificationMailer < ApplicationMailer
	default from: "from@example.com"

	def send_mail(email, url, diff)
		website = Website.find_by_url(url)
		# path = File.join Rails.root, 'public', 'assets', 'screenshots'
		# attachments.inline['old.png'] = File.read(File.join(path, "#{website.id}.png"))
		attachments.inline['old.png'] = File.read("public/assets/screenshots/#{website.id}.png")
		attachments.inline['new.png'] = File.read("public/assets/screenshots/#{website.id}_change.png")
		attachments.inline['diff.png'] = File.read("public/assets/screenshots/#{website.id}_diff.png")

		@diff = diff
		@subscriber = Subscriber.find_by_email(email)
		@id = website.id
		mail(to: email, subject: "The web page #{url} seems to have changed, please look")
	end
end
