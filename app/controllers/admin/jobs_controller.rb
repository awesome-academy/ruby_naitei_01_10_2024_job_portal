class Admin::JobsController < ApplicationController
  load_and_authorize_resource

  def update
    if @job.update(status: params[:status])
      flash[:success] = t "flash.jobs.update_success"
      redirect_to admin_root_path
    else
      render "admin/dashboard/index"
    end
  end
end
