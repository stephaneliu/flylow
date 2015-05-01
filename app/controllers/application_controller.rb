# Global controller for application
class ApplicationController < ActionController::Base
  protect_from_forgery

  check_authorization unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    session[:return_to] = request.fullpath

    if current_user
      redirect_to root_path, alert: exception.message
    else
      redirect_to :new_user_session, alert: 'You must sign in to access this resource'
    end
  end

  def after_sign_in_path_for(*)
    return_to = session[:return_to] || root_path
    session[:return_to] = nil
    return_to
  end

  def authorize_public_area!
    authorize! :use, :public_areas
  end
end
