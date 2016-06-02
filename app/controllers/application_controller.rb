class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_devise_permitted_parameters, if: :devise_controller?

  protected

  def configure_devise_permitted_parameters
    permited_params = [:email, :password, :password_confirmation, :name, :surname]

    if params[:action] == 'update'
      devise_parameter_sanitizer.for(:account_update) { |u|
        u.permit(permited_params << :current_password)
      }
    elsif params[:action] == 'create'
      devise_parameter_sanitizer.for(:sign_up) { |u|
        u.permit(permited_params) 
      }
    end
  end
end