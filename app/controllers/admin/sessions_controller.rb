class Admin::SessionsController < Devise::SessionsController
  layout "auth"
  def new; end

  def create
    user = User.find_by(email: params[:email], role: :admin)
    if user&.valid_password?(params[:password])
      sign_in(user)
      flash[:success] = t("devise.sessions.signed_in")
      redirect_to admin_root_path
    else
      flash.now[:danger] = t("devise.failure.invalid")
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    sign_out(current_user)
    flash[:success] = t("devise.sessions.signed_out")
    redirect_to new_admin_user_session_path
  end
end
