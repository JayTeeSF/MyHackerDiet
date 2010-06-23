class WithingsLogController < ApplicationController
  def index
    @logs = WithingsLog.find_all_by_userid(current_user.user_option.withings_userid, :order => 'sdate DESC')
    @withings_logs = Withings.find_all_by_userid(current_user.user_option.withings_userid, :order => 'rec_date DESC')

    respond_to do |format|
      format.html
    end
  end

end
