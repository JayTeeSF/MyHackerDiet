class Withings < ActiveRecord::Base

  def self.authorized?(withings_userid, withings_publickey)
    m = WiScale.new(:userid => withings_userid, :publickey => withings_publickey)

    return false if withings_userid == nil || withings_publickey == nil
    return false if withings_userid == "" || withings_publickey == ""
    return false if m.get_by_userid.class == Fixnum
    return true
  end

  def self.import_withings(uid, withings_userid, withings_publickey)
    m = WiScale.new(:userid => withings_userid, :publickey => withings_publickey).get_meas
    parse_withings( uid, withings_userid, m )
  end

  def self.get_withings_single_date(uid, withings_userid, withings_publickey, sdate, edate)
    m = WiScale.new(:userid => withings_userid, :publickey => withings_publickey).get_meas(:startdate => sdate.to_i, :enddate => edate.to_i)
    parse_withings( uid, withings_userid, m )
  end


  private

  def self.parse_withings( uid, userid, measures_full )
    data_points = []

    measures_full.measures.each do |measures|
      last_meas = measures.measures[0]

      wipoint = Withings.new
      wipoint.userid = userid

      wipoint.rec_date = Time.at(measures.date)

      measures.measures.each do |last_meas|
        type = last_meas['type'].to_i
        value = (last_meas['value'].to_i * (10 ** last_meas['unit'])).to_f

        if type == 6
          wipoint.bodyfat = value.round(1)
        elsif type == 1
          wipoint.weight = (value * 2.20462262).round(1)   # Convert kg to lb
        end
      end

      unless wipoint.weight == nil and wipoint.bodyfat == nil then
        data_points << wipoint
        wipoint.save
      end
    end

    recdates = Withings.find_all_by_userid(userid).collect{ |p| p.rec_date.to_date }

    # Insert weight records if they dont already exist
    recdates.reverse.each do |recdate|
      weights = Weight.find(:all, :conditions => ["user_id = ? and rec_date = ?", uid, recdate], :order => 'rec_date ASC')
      total_manual = 0

      begin
        if !weights || weights.size == 0 then
          total_manual = 0
        else
          total_manual = weights.collect { |w| w.manual }
        end
      rescue
        total_manual = 0
      end

      #TODO remove outliers
      logged = Withings.find(:all, :conditions => ["userid = ? and rec_date between ? and ?", userid, recdate, (recdate+1)])

      if total_manual == 0 && logged.size > 0 then
        logger.info "Averaging #{recdate} with #{logged.size} withings records"

        # Remove the existing records and add a new [averaged] one
        # This has the caveat of removing all records, so we assume
        # that there should be just one.  No manual records are removed, however
        weights.each do |w| w.destroy end

        avg_weight = Withings.average(:weight, :conditions => [ "userid = ? and rec_date between ? and ?", uid, recdate, recdate+1 ]).to_f
        avg_bodyfat = Withings.average(:bodyfat, :conditions => [ "userid = ? and rec_date between ? and ?", uid, recdate, recdate+1 ]).to_f

        w = Weight.new
        w.rec_date = recdate
        w.user_id = uid
        w.weight = avg_weight.round(2)
        w.bodyfat = avg_bodyfat.round(2)
        w.manual = false
        w.save
        w.calc_avg_weight
      end
    end

  end
end
