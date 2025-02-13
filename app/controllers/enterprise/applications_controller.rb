class Enterprise::ApplicationsController < ApplicationController
  layout "enterprise"
  include NotificationsHelper
  load_and_authorize_resource

  def index
    authorize! :read, current_user.company_id
    @applications = @applications.order(created_at: :desc)
    @pagy, @applications = pagy(@applications, limit: Settings.apply.page_size)
  end

  def show
    @interview_process = InterviewProcess.new
  end

  def update_status
    if @application.update(status: params[:status])
      handle_update_success(@application, params[:status])
    else
      flash[:danger] = t("flash.application.update_error")
      render :show
    end
  end

  private

  def handle_update_success application, status
    create_notification_for_applicant(
      application,
      "notifications.application_status_updated",
      "notifications.application_status_updated_content",
      {job: application.job.title, status: status.capitalize}
    )
    flash[:success] = t("flash.application.update_success")
    redirect_to enterprise_application_path(application)
  end
end
