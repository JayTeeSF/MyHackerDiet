class WithingsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def log
    @wlog = WithingsLog.new

    @wlog.userid = params[:userid]
    @wlog.sdate = Time.at(params[:startdate].to_i)
    @wlog.edate = Time.at(params[:enddate].to_i)

    @wlog.save
    
    user = Person.find_by_withings_uid(@wlog.userid)
    email_user = 'jon@digital-drip.com'

    if user != nil then
      email_user = user.email
      Emailer.deliver_contact(email_user, @wlog, "MyHackerDiet Event for User #{@wlog.userid}")
      Withings.get_withings_single_date(@wlog.userid, user.withings_publickey, @wlog.sdate, @wlog.edate)
    end

  end

  def import
    Withings.import_withings(@user.withings_uid, @user.withings_publickey)
  end
end
