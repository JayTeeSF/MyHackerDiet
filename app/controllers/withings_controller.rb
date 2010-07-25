class WithingsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [ :log ]

  def log
    @wlog = WithingsLog.new

    @wlog.userid = params[:userid]
    @wlog.sdate = Time.at(params[:startdate].to_i)
    @wlog.edate = Time.at(params[:enddate].to_i)

    @wlog.save
    
    begin
      user = User.find_by_withings_userid(@wlog.userid)
      email_user = user.email
    rescue
      logger.error "Unable to find a user for withings event for userid: #{@wlog.userid} from #{@wlog.sdate} to #{@wlog.edate}"
      email_user = 'jon@digital-drip.com'
    end

    if user != nil then
      if user.withings_email_alerts
        logger.info "Emailing #{email_user} about withings event for #{@wlog.userid}"
        email_user = user.email
        Emailer.deliver_contact(email_user, @wlog, "MyHackerDiet Event for User #{@wlog.userid}")
      end

      logger.info "Retrieving withings data for user #{user.id} from #{@wlog.sdate} to #{@wlog.edate}"
      Withings.get_withings_single_date(user.id, @wlog.userid, user.withings_publickey, @wlog.sdate, @wlog.edate)
    end

  end

  def import
    if current_user.withings_userid == nil || current_user.withings_userid == '' || current_user.withings_publickey == nil || current_user.withings_publickey == ''
      flash[:notice] = 'You have not specified your Withings UID and Publickey.'
      redirect_to root_url
    else
      Withings.import_withings(current_user.id, current_user.withings_userid, current_user.withings_publickey)
      flash[:info] = 'Withings measurements successfully imported'
      redirect_to(weights_url)
    end
  end

  def check_status
    withings_userid = params[:user][:withings_userid]
    withings_publickey = params[:user][:withings_publickey]
    
    @scale = WiScale.new(:userid => withings_userid, :publickey => withings_publickey)

    if @scale.user_update(1) == 0
      @status = 1
    else
      @status = 0
    end

    render :partial => 'withings_status'
  end
end
