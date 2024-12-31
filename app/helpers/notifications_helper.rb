module NotificationsHelper
  def create_notification_for_applicant application, title, content
    Notification.create(
      user_id: application.user_id,
      title:,
      content:,
      is_read: false
    )
  end
end
