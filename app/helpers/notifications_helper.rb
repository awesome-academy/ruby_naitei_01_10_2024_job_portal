module NotificationsHelper
  def create_notification_for_applicant application, title, content, params = {}
    Notification.create(
      user_id: application.user_id,
      title:,
      content:,
      params:,
      is_read: false
    )
  end
end
