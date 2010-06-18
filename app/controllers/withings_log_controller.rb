class WithingsLogController < ApplicationController
  def index
    @logs = WithingsLog.find_all_by_userid(@user.withings_uid, :order => 'created_at ASC')
    @withings_logs = Withings.find_all_by_userid(@user.withings_uid, :order => 'created_at ASC')

    respond_to do |format|
      format.html
    end
  end

end
