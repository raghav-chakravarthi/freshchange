class UsersController < ApplicationController
	def create
		user = User.new(name: params[:name], email: params[:email], account_id: params[:account_id], admin: false, has_access: true, password: 'password', account_id: params[:account_id])
		if user.save!
			flash[:success] = 'The user has been added to your account.'
			redirect_to users_path
		else
			flash[:failure] = 'Error while creating the user for your account. Please try again later'
			redirect_to users_path
		end
	end

	def index
		@users = []
		User.all.each do |user|
			@users.push(user) if user.account.email == current_user.email
		end
	end

	def destroy
		user = User.find(params[:id])
		if user.destroy
			flash[:success] = 'The User has been deleted successfully'
		else
			flash[:failure] = 'Error while deleting the User'
		end
		redirect_to users_path
	end

	def change_password

	end

	def update
		user = User.find(params[:user_id])
		if params[:new] != params[:new_confirm]
			flash[:failure] = 'Passwords do not match'
		else
			user.password = params[:new].first
			user.save!
			flash[:success] = 'The password was reset successfully'
		end
		redirect_to root_path
	end
end
