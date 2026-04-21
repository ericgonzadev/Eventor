module SessionsHelper
  # Logs in the user.
  def log_in(user)
    session[:user_id] = user.id
  end

  # Returns current user (if any). Returns nil and clears a stale session
  # if the referenced user no longer exists.
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
      log_out if @current_user.nil?
    end
    @current_user
  end

  # Logs out the current user
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end
