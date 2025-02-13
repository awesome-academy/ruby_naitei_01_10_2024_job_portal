class Api::V1::SessionsController < Devise::SessionsController
  require Rails.root.join("lib/json_web_token")
  skip_before_action :verify_authenticity_token, raise: false

  respond_to :json

  def create
    self.resource = warden.authenticate
    if resource
      token = JsonWebToken.encode(user_id: resource.id)
      render json: {
               token:,
               user: resource,
               message: I18n.t("devise.sessions.signed_in")
             },
             status: :ok
    else
      render json: {error: I18n.t("devise.sessions.invalid_login")},
             status: :unauthorized
    end
  end

  def destroy
    sign_out(resource_name)
    render json: {message: I18n.t("devise.sessions.signed_out")}, status: :ok
  end
end
