require 'nokogiri'
require 'open-uri'

class WebsitesController < ApplicationController
	def landing_page

	end

	def create
		subscriber = Subscriber.find_by_email(params[:subscriber_email])
		website = Website.new(url: params[:url], subscriber_id: subscriber.id)
		if website.save!
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

	def destroy
		website = Website.find(params[:id])
		if website.destroy
			flash[:success] = "The URL has been deleted successfully"
			redirect_to websites_path
		else
			flash[:error] = "Error while deleting the URL"
			redirect_to websites_path
		end
	end

	def web_compare
		Website.all.each do |website|
			url = (website.url[0..3] != 'http') ? "http://" + website.url : website.url  
			byebug
			doc = Nokogiri::HTML(open(url).read)
			if website.content != doc.to_s
				website.content = doc.to_s
				website.save!
			end
		end
		redirect_to root_path
	end
end
