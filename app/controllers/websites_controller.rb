require 'nokogiri'
require 'open-uri'

class WebsitesController < ApplicationController
	before_action :authenticate_user!
	def landing_page
		@websites = []
		if current_user.admin
			Website.all.each do |website| @websites.push(website) end
		else
			@websites = []
			Website.all.each do |website|
				@websites.push(website) if website.user == current_user
			end
		end
	end

	def create
		begin
			user = User.find_by_email(params[:subscriber_email])
			website = Website.new(url: params[:url], user_id: user.id, friendly_name: params[:friendly_name])
			url = (website.url[0..3] != 'https') ? 'https://' + website.url : website.url
			website.content = "yes" if Nokogiri::HTML(open(url).read).to_html
			website.old_time = Time.now
			curl_response = `curl -X GET   "https://api.builtwith.com/free1/api.json?KEY=c0e34101-94db-4c57-8700-492d5014e079&LOOKUP=#{website.url}"`
	    	json_reponse = JSON.parse(curl_response)
	    	analytics = ""
	    	json_reponse['groups'].each do |e|
	  			analytics = e if e["name"] == 'analytics'
			end
			all_analytics_used = []
			analytics['categories'].each do |category|
	 			all_analytics_used.push(category['name'].to_s)
			end
			website.analytics = all_analytics_used
			website.report_one = Time.now
			website.priority = true
			if website.save!
				screenshot = Gastly.screenshot(url, timeout: 3000)
	          	image = screenshot.capture
	          	image.save("public/assets/screenshots/#{website.id}.png")
	          	image.save("public/assets/screenshots/#{website.id}_initial.png")
	          	image.save("public/assets/screenshots/#{website.id}_report_one.png")
	          	# ImageOptimizer.new("public/assets/screenshots/#{website.id}.png", level: 1).optimize
	          	# ImageOptimizer.new("public/assets/screenshots/#{website.id}_initial.png", level: 1).optimize
	          	# ImageOptimizer.new("public/assets/screenshots/#{website.id}_report_one.png", level: 1).optimize
				flash[:success] = 'The URL has been added successfully'
				redirect_to root_path
			else
				flash[:error] = 'Error while adding the URL'
				redirect_to root_path
			end
		rescue
			flash[:error] = "Error! Please enter the URL as www.example.com"
			redirect_to root_path
		end
	end

	def update
		begin
		 	website = Website.find(params[:id].to_i)
		 	if website.priority
		 		website.update_attributes!(priority: false)
		 		flash[:success] = "Website paused from tracking. You can continue tracking anytime"
		 	else
		 		website.update_attributes!(priority: true)
		 		flash[:success] = "Website tracking resumed"
		 	end
		 	redirect_to root_path
		rescue
		 	flash[:error] = "Error in action. Please try again after sometime"
		 	redirect_to root_path
		end
	end

	def destroy
		website = Website.find(params[:id])
		if website.destroy
			flash[:success] = "The URL has been deleted successfully"
			File.delete("public/assets/screenshots/#{website.id}.png") if File.file?("public/assets/screenshots/#{website.id}.png")
			File.delete("public/assets/screenshots/#{website.id}_change.png") if File.file?("public/assets/screenshots/#{website.id}_change.png")
			File.delete("public/assets/screenshots/#{website.id}_diff.png") if File.file?("public/assets/screenshots/#{website.id}_diff.png")
			File.delete("public/assets/screenshots/#{website.id}_initial.png") if File.file?("public/assets/screenshots/#{website.id}_initial.png")
			File.delete("public/assets/screenshots/#{website.id}_report_one.png") if File.file?("public/assets/screenshots/#{website.id}_report_one.png")
			File.delete("public/assets/screenshots/#{website.id}_report_two.png") if File.file?("public/assets/screenshots/#{website.id}_report_two.png")
			File.delete("public/assets/screenshots/#{website.id}_report_three.png") if File.file?("public/assets/screenshots/#{website.id}_report_three.png")

			redirect_to root_path
		else
			flash[:error] = "Error while deleting the URL"
			redirect_to root_path
		end
	end

	def show
		@website = Website.find(params[:id])
		if @website.was_updated
			flash[:success] = "The website - #{@website.url} seems to have changed atleast once"
		else
			flash[:success] = "No change in website - #{@website.url}"
		end
	end
end
