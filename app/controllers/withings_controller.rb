class WithingsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def log
    @wlog = WithingsLog.new

    @wlog.userid = params[:userid]
    @wlog.sdate = Time.at(params[:startdate].to_i)
    @wlog.edate = Time.at(params[:enddate].to_i)

    @wlog.save
    Emailer.deliver_contact('jon@digital-drip.com', "MyHackerDiet Event for User #{@wlog.userid}", "#{@wlog.userid} - #{@wlog.sdate} -> #{@wlog.edate}")
    
    user = Person.find_by_withings_uid(@wlog.userid)
    if user != nil then
      Withings.get_withings_single_date(@wlog.userid, user.withings_publickey, @wlog.sdate.to_i, @wlog.edate.to_i)
    end
  end
end
