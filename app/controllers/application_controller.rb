class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  include ActiveStorage::SetCurrent

  before_action :set_i18n_locale_from_params

  private

  def set_i18n_locale_from_params
    return unless params[:locale].present?

    if I18n.available_locales.map(&:to_s).include?(params[:locale])
      I18n.locale = params[:locale]
    else
      flash.now[:notice] = "#{params[:locale]} translation not available"
      logger.error(flash.now[:notice])
    end
  end
end
