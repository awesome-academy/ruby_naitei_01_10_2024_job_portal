class Users::RegistrationsController < Devise::RegistrationsController
  layout "auth"
  before_action :configure_sign_up_params

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up,
                                      keys: [:full_name, :phone, :role])
  end

  def after_sign_up_path_for resource
    stored_location_for(resource) || root_path
  end
end
