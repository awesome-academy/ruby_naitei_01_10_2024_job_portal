module ApplicationHelper
  include Pagy::Frontend

  def locations_options
    locations.map{|loc| [t(loc[:key]), loc[:value]]}
  end

  def active_link_to path
    "active text-light fw-bold bg-primary" if request.path == path
  end

  def seen_background_color notification
    "bg-light" if notification.is_read
  end
end
