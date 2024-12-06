class CompaniesController < ApplicationController
  def index
    @page = current_page
    @companies = paginated_companies

    return if @page == 1

    respond_to(&:turbo_stream)
  end

  def current_page
    params[:page].to_i.positive? ? params[:page].to_i : 1
  end

  def paginated_companies
    Company
      .search(params[:query])
      .limit(Settings.company.page_size)
      .offset(Settings.company.page_size * (current_page - 1))
  end
end
