class JobsController < ApplicationController
  def index
    jobs = filter_jobs_by_work_type
    jobs = filter_jobs_by_location(jobs) if params[:location].present?
    jobs = filter_jobs_by_keyword(jobs) if params[:keyword].present?

    @pagy, @jobs = pagy(jobs, limit: Settings.jobs.page_size)
  end

  private

  def filter_jobs_by_work_type
    if params[:work_type].present?
      Job.filter_by_work_type(params[:work_type])
    else
      Job.all
    end
  end

  def filter_jobs_by_location jobs
    return filter_others_only jobs if others_location_only?

    filtered_jobs = []
    if params[:location].include?("others")
      filtered_jobs += jobs.filter_others_location
      other_locations = params[:location] - %w(others)
      if other_locations.present?
        filtered_jobs += jobs.filter_by_location(other_locations)
      end
    else
      filtered_jobs += jobs.filter_by_location(params[:location])
    end
    Job.where(id: filtered_jobs.map(&:id).uniq)
  end

  def others_location_only?
    params[:location].is_a?(String) && params[:location] == "others"
  end

  def filter_others_only jobs
    jobs.filter_others_location
  end

  def filter_jobs_by_keyword jobs
    params[:keyword].present? ? jobs.search_by_keyword(params[:keyword]) : jobs
  end
end
