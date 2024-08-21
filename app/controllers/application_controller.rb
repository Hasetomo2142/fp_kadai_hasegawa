# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # Plannerモデル用のストロングパラメータ
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name description]) if resource_class == Planner
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name description]) if resource_class == Planner

    # Clientモデル用のストロングパラメータ
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name]) if resource_class == Client
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name]) if resource_class == Client
  end
end
