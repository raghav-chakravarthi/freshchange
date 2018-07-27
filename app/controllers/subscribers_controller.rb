class SubscribersController < ApplicationController
	def create
		begin
			user = User.new(name: params[:name], email: params[:email], account_id: params[:account_id], admin: false, has_access: true, password: 'password', account_id: params[:account_id])
			if user.save!
				flash[:success] = 'The user has been added to your account. Please inform the user to change the password and start monitoring websites.'
				redirect_to root_path
			else
				flash[:failure] = 'Error while creating the user for your account. Please try again later'
				redirect_to root_path
			end
		rescue
			flash[:error] = 'Error! Please enter a valid email'
     		redirect_to root_path
		end
	end
end
