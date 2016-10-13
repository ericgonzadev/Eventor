class SessionsController < ApplicationController
	before_action :already_logged_in?, only: [:new, :create]

  def new
  end

  def create
  	user = User.find_by(email: params[:session][:email].downcase)
  	if user && user.authenticate(params[:session][:password])
  		log_in user
  		redirect_to user
  	else
      flash.now[:danger] = 'Invalid Email or Password'
  		render :new
  	end
  end

  def destroy
  	log_out
  	redirect_to root_path
  end
end
