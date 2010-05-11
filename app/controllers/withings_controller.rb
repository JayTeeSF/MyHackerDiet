class WithingsController < ApplicationController
  def log
    @withings_userid = params[:userid]
    @withings_startdate = params[:startdate]
    @withings_enddate = params[:enddate]
    Emailer.deliver_contact('jon@digital-drip.com', "MyHackerDiet Event for User #{@withings_user}", "#{@withings_userid} - #{@withings_startdate}")
  end
end
