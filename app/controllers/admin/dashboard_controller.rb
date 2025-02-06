class Admin::DashboardController < ApplicationController
  layout "admin"
  def index
    redirect_to new_admin_user_session_path unless user_signed_in?
    @jobs = Job.pending
  end
end
