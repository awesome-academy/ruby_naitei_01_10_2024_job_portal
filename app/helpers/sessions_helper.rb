module SessionsHelper
  def log_in user
    session[:user_id] = user.id
  end

  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by id: user_id
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by id: user_id
      if user&.authenticated? :remember, cookies[:remember_token]
        log_in user
        @current_user = user
      end
    end
  end

  def unread_notifications
    current_user.notifications.unread.count
  end

  def logged_in?
    current_user.present?
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
