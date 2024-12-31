class ApplicationsController < ApplicationController
  def create
    existing_application = Application.find_by(
      job_id: params[:job_id], user_id: current_user.id
    )

    if existing_application
      handle_existing_application(existing_application)
      return
    end

    create_new_application
  end

  def update
    @application = Application.find(params[:id])
    if @application.update(status: params[:status])
      flash[:success] = t "flash.application.update_success"
      redirect_to application_path(id: @application.id)
    else
      flash[:danger] = t "flash.application.update_error"
      render :show
    end
  end

  def show
    @application = Application.includes(:interview_processes).find(params[:id])
  end

  private

  def create_application_with_existing_cv
    @application.cv_file.attach(current_user.user_profile.cv_file.blob)
    save_application
  end

  def create_application_with_new_cv
    @application.cv_file.attach(params[:cv_file])
    save_application
  end

  def save_application
    if @application.save
      create_notification_for_enterprise(@application)
      flash[:success] = t "flash.application.success"
      redirect_to job_path(id: @application.job.id)
    else
      flash.now[:danger] = t "flash.application.error"
      render "jobs/show"
    end
  end

  def application_params
    params.permit(:job_id, :cv_file, :use_existing_cv, :status)
  end

  def handle_existing_application existing_application
    if existing_application.status != "canceled"
      flash[:danger] = t "flash.already_applied"
      redirect_to jobs_path
    else
      existing_application.update(status: :pending, cv_file: params[:cv_file])
      flash[:success] = t "flash.reapply_success"
      redirect_to job_path(id: existing_application.job.id)
    end
  end

  def create_new_application
    @application = Application.new(filtered_application_params)
    @application.user = current_user
    @application.status = :pending

    if params[:use_existing_cv] == "true"
      create_application_with_existing_cv
    else
      create_application_with_new_cv
    end
  end

  def filtered_application_params
    application_params.except(:use_existing_cv)
  end

  def create_notification_for_enterprise application
    enterprise_users = application.job.company.users
    enterprise_users.each do |user|
      Notification.create!(
        user:,
        title: t("notifications.new_application"),
        content: t("notifications.new_application_content",
                   user: current_user.full_name, job: application.job.title),
        is_read: false
      )
    end
  end
end
