class RegistrationsController < Devise::RegistrationsController 
  prepend_before_action :check_captcha, only: [:create] 
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


  private
  def check_captcha
    if verify_recaptcha
      flash.delete :recaptcha_error
    else
      self.resource = resource_class.new sign_up_params
      respond_with_navigational(resource) { render :new }
    end 
  end
end
