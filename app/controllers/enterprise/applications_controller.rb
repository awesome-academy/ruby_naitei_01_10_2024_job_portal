class Enterprise::ApplicationsController < ApplicationController
  layout "enterprise"
  before_action :load_application, only: [:show, :update_status]

  def index
    applications = current_user.company.applications.order(created_at: :desc)
    @pagy, @applications = pagy(applications, limit: Settings.apply.page_size)
  end

  def show
    @interview_process = InterviewProcess.new
  end

  def update_status
    if @application.update(status: params[:status])
      flash[:success] = t("flash.application.update_success")
      redirect_to enterprise_application_path(@application)
    else
      flash[:danger] = t("flash.application.update_error")
      render :show
    end
  end

  private

  def load_application
    @application = current_user.company.applications
                               .includes(:interview_processes)
                               .find_by(id: params[:id])
    return if @application.present?

    flash[:danger] = t "enterprise.applications.not_found"
    redirect_to enterprise_applications_path
  end
end
