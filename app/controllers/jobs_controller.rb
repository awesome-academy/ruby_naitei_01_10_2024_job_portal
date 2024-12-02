class JobsController < ApplicationController
  def index
    jobs = Job.filter_by_work_type(params[:work_type])
    @pagy, @jobs = pagy(jobs, limit: Settings.jobs.page_size)
  end
end
