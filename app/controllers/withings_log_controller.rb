class WithingsLogController < ApplicationController
  def index
    @logs = WithingsLog.find_all_by_userid(@user.withings_uid)
    @withings_logs = Withings.find_all_by_userid(@user.withings_uid)

    respond_to do |format|
      format.html
    end
  end

end
