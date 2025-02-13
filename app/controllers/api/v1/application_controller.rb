class Api::V1::ApplicationController < ActionController::API
  include Pagy::Backend
  before_action :authenticate_request!

  attr_reader :current_user

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from StandardError, with: :internal_server_error

  private

  def authenticate_request!
    header = request.headers["Authorization"]
    if header.present?
      token = header.split(" ").last
      begin
        decoded = JsonWebToken.decode(token)
        @current_user = User.find(decoded[:user_id])
      rescue ActiveRecord::RecordNotFound
        render json: {error: I18n.t("errors.user_not_found")},
               status: :unauthorized
      rescue JWT::DecodeError
        render json: {error: I18n.t("errors.invalid_token")},
               status: :unauthorized
      end
    else
      render json: {error: I18n.t("errors.missing_token")},
             status: :unauthorized
    end
  end

  def record_not_found _exception
    render json: {error: I18n.t("errors.record_not_found")},
           status: :not_found
  end

  def internal_server_error exception
    logger.error exception.message
    logger.error exception.backtrace.join("\n")
    render json: {error: I18n.t("errors.internal_server_error")},
           status: :internal_server_error
  end
end
