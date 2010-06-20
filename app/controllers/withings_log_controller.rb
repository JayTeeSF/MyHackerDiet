class WithingsLogController < ApplicationController
  def index
    @logs = WithingsLog.find_all_by_userid(@user.withings_uid, :order => 'sdate DESC')
    @withings_logs = Withings.find_all_by_userid(@user.withings_uid, :order => 'rec_date DESC')

    respond_to do |format|
      format.html
    end
  end

end
