class Enterprise::JobsController < ApplicationController
  layout "enterprise"
  load_and_authorize_resource(&:with_deleted)

  def index
    @jobs = current_user.company.jobs.with_deleted.order(created_at: :desc)
  end

  def new
    @job = current_user.company.jobs.new
  end

  def create
    update_params = job_params.merge(required_skills: transform_skills)
    @job = current_user.company.jobs.new(update_params)
    if @job.save
      flash[:success] = t "flash.jobs.save_success"
      redirect_to enterprise_jobs_path
    else
      flash.now[:danger] = t "flash.jobs.save_error"
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    update_params = job_params.merge(required_skills: transform_skills)
    if @job.update(update_params)
      flash[:success] = t "flash.jobs.update_success"
      redirect_to enterprise_job_path(id: @job.id)
    else
      flash.now[:danger] = t "flash.jobs.update_error"
      render :edit
    end
  end

  def destroy
    @job.destroy
    flash[:success] = t "flash.jobs.delete_success"
    redirect_to enterprise_jobs_path
  end

  private

  def job_params
    params.require(:job).permit(Job::PERMITTED_PARAMS)
  end

  def transform_skills
    params[:job][:required_skills]&.map do |skill|
      [skill[:key], skill[:value]]
    end.to_h || {}
  end
end
