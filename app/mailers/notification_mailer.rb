class NotificationMailer < ApplicationMailer
	default from: 'freshchange@freshworks.com'

	def send_mail(email, url, id)
		@website = Website.find(id)

		attachments.inline['old.png'] = File.read("public/assets/screenshots/#{@website.id}.png")
		attachments.inline['diff.png'] = File.read("public/assets/screenshots/#{@website.id}_diff.png") if File.file?("public/assets/screenshots/#{@website.id}_diff.png")

		@subscriber = User.find_by_email(email)
		@id = @website.id
		mail(to: email, subject: "The web page #{url} seems to have changed, please look")
	end
end
