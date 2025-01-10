class TranslationsController < ApplicationController
  def show
    locale = params[:locale] || I18n.default_locale
    file_path = Rails.root.join("app", "javascript", "translation",
                                "#{locale}.json")

    if File.exist?(file_path)
      render json: JSON.parse(File.read(file_path))
    else
      render json: {error: t("errors.locales_not_supported")},
             status: :not_found
    end
  end
end
