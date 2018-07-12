require 'nokogiri'
require 'open-uri'

class WebsitesController < ApplicationController
	def landing_page

	end

	def create
		subscriber = Subscriber.find_by_email(params[:subscriber_email])
		website = Website.new(url: params[:url], subscriber_id: subscriber.id)
		url = (website.url[0..3] != 'http') ? "http://" + website.url : website.url
		website.content = Nokogiri::HTML(open(url).read).to_html
		if website.save!
			Gastly.capture(url, "public/assets/screenshots/#{website.id}.png")
			flash[:success] = "The URL has been added successfully"
			redirect_to root_path
		else
			flash[:error] = "Error while adding the URL"
			redirect_to root_path
		end
	end

	def index
		@websites = Website.all
	end

	def update
		website = Website.find(params[:id].to_i)
		if params[:url].present?
			website.url = params[:url]
			url = (website.url[0..3] != 'http') ? "http://" + website.url : website.url
			Gastly.capture(url, "public/assets/screenshots/#{website.id}.png")
			if website.save!
				flash[:success] = "Update successful"
			else
				flash[:success] = "Error while updating"
			end
		end
		if params[:email].present?
			website.subscriber = Subscriber.find_by_email(params[:email])
			if !website.subscriber.present?
				flash[:error] = "Subscriber not found" 
				redirect_to websites_path
			end
		end
	end

	def destroy
		website = Website.find(params[:id])
		if website.destroy
			flash[:success] = "The URL has been deleted successfully"
			File.delete("public/assets/screenshots/#{website.id}.png")
			File.delete("public/assets/screenshots/#{website.id}_change.png")
			File.delete("public/assets/screenshots/#{website.id}_diff.png")
			redirect_to websites_path
		else
			flash[:error] = "Error while deleting the URL"
			redirect_to websites_path
		end
	end
end
