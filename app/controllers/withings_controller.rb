class WithingsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def log
    withings_userid = params[:userid]
    withings_startdate = params[:startdate]
    withings_enddate = params[:enddate]
    Emailer.deliver_contact('jon@digital-drip.com', "MyHackerDiet Event for User #{withings_userid}", "#{withings_userid} - #{withings_startdate} -> #{withings_enddate}")
  end
end
