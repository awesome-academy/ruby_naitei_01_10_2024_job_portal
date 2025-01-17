class JobsController < ApplicationController
  def index
    @q = Job.active.ransack(params[:q])
    @pagy, @jobs = pagy(@q.result(distinct: true),
                        limit: Settings.jobs.page_size)
  end

  def show
    @job = Job.find_by id: params[:id]

    if @job.nil?
      flash[:danger] = t "jobs.job_not_found"
      redirect_to root_path
    else
      @related_jobs = Job.related_jobs(@job)
    end
  end
end
