class SessionsController < ApplicationController
  layout "auth"

  def new; end

  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      reset_session
      log_in user
      flash[:success] = t "flash.login.success"
      redirect_to root_path
    else
      flash.now[:danger] = t "flash.login.error"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end
end
