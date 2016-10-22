class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

private

  # Confirms a logged-in user.
  def logged_in_user
    unless current_user
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

   # Checks if user is already logged-in
  def already_logged_in?
    if current_user
      redirect_to root_path
    end
  end

  #Verifies user is owner of resource
  def authorized?(resource)
    if resource.class == Event
      redirect_to root_path unless current_user && current_user.id == resource.user_id
    elsif resource.class == User
      redirect_to root_path unless current_user && current_user.id == resource.id
    end
  end
end
