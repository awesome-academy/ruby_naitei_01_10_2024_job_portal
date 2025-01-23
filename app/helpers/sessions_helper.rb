module SessionsHelper
  def log_in user
    session[:user_id] = user.id
  end

  def unread_notifications
    current_user.notifications.unread.count
  end

  def log_out
    reset_session
    @current_user = nil
  end

  def current_user? user
    user == current_user
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
