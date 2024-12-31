class NotificationsController < ApplicationController
  def mark_all_as_read
    current_user.notifications.update_all(is_read: true)
    redirect_to request.referer || root_path
  end

  def mark_as_read
    @notification = current_user.notifications.find(params[:id])
    @notification.update(is_read: true)
    redirect_to request.referer || root_path
  end
end
