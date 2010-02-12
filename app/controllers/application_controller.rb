# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  #helper :all # include all helpers, all the time
  #protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password


  helper :all # include all helpers, all the time

  before_filter :maintain_session_and_user
  before_filter :prepare_for_mobile

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '3ef815416f775098fe977004015c6193'

  def ensure_login
    unless @user
      flash[:notice] = "Please login to continue"
      redirect_to(new_session_path)
    end
  end

  def ensure_logout
    if @user
      flash[:notice] = "You must logout before you can login or register"
      redirect_to(root_url)
    end
  end

  private

  def maintain_session_and_user
    if session[:id]
      if @application_session = Session.find_by_id(session[:id])
        # Check if apache mod_proxy header exists for user IP address
        # if not, fallback to using the direct path
        ip = request.env["HTTP_X_FORWARDED_FOR"] || request.remote_addr
        
        @application_session.update_attributes(:ip_address => ip, :path => request.path_info)
        @user = @application_session.person
      else
        session[:id] = nil
        redirect_to(root_url)
      end
    end
  end

  def mobile_device?
    if session[:mobile_param]
      session[:mobile_param] == "1"
    else
      request.user_agent =~ /Mobile|webOS/
    end
  end
  helper_method :mobile_device?

  def prepare_for_mobile
    session[:mobile_param] = params[:mobile] if params[:mobile]
    request.format = :mobile if mobile_device?
  end

end

