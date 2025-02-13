class Api::V1::JobsController < Api::V1::ApplicationController
  before_action :set_job, only: [:show, :update, :destroy]

  def index
    per_page = determine_per_page
    q = Job.active.ransack(params[:q])
    @pagy, jobs = pagy(q.result(distinct: true), limit: per_page)
    set_header @pagy
    render json: jobs, each_serializer: JobSerializer, status: :ok
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
    render json: {message: I18n.t("jobs.deleted_success")}, status: :ok
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

  def determine_per_page
    if params[:per_page].present?
      params[:per_page].to_i
    else
      Settings.jobs.page_size
    end
  end

  def set_header pagy
    response.headers["X-Total-Count"]   = pagy.count.to_s
    response.headers["X-Total-Pages"]   = pagy.pages.to_s
    response.headers["X-Current-Page"]  = pagy.page.to_s
  end
end
