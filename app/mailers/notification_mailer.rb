class NotificationMailer < ApplicationMailer
	default from: 'freshchange@freshworks.com'

	def send_mail(email, url, id)
		@website = Website.find(id)
		# path = File.join Rails.root, 'public', 'assets', 'screenshots'
		# attachments.inline['old.png'] = File.read(File.join(path, "#{website.id}.png"))
		attachments.inline['old.png'] = File.read("public/assets/screenshots/#{@website.id}.png")
		attachments.inline['diff.png'] = File.read("public/assets/screenshots/#{@website.id}_diff.png") if File.file?("public/assets/screenshots/#{@website.id}_diff.png")

		# @diff = diff
		@subscriber = User.find_by_email(email)
		@id = @website.id
		mail(to: email, subject: "The web page #{url} seems to have changed, please look")
	end
end
