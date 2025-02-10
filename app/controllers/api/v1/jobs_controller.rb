class Api::V1::JobsController < ApplicationController
  protect_from_forgery with: :null_session

  before_action :set_job, only: [:show, :update, :destroy]

  def index
    jobs = Job.all
    render json: jobs, each_serializer: JobSerializer
  end

  def show
    render json: @job, serializer: JobSerializer
  end

  def create
    job = Job.new(job_params)
    if job.save
      render json: job, serializer: JobSerializer, status: :created
    else
      render json: {errors: job.errors.full_messages},
             status: :unprocessable_entity
    end
  end

  def update
    if @job.update(job_params)
      render json: @job, serializer: JobSerializer
    else
      render json: {errors: @job.errors.full_messages},
             status: :unprocessable_entity
    end
  end

  def destroy
    @job.destroy
    head :no_content
  end

  private

  def set_job
    @job = Job.find_by(id: params[:id])
    return if @job

    render json: {error: I18n.t("jobs.job_not_found")},
           status: :not_found
  end

  def job_params
    params.require(:job).permit(
      :title,
      :description,
      :experience_level,
      :work_type,
      :salary_range,
      :location,
      :status,
      :company_id,
      required_skills: [:key, :value]
    )
  end
end
