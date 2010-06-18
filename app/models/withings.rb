class Withings < ActiveRecord::Base

  def self.import_withings(userid, publickey)
    m = WiScale.new(:userid => userid, :publickey => publickey).get_meas
    parse_withings( userid, m )
  end

  def self.get_withings_single_date(userid, publickey, sdate, edate)
    m = WiScale.new(:userid => userid, :publickey => publickey).get_meas(:startdate => sdate.to_i, :enddate => edate.to_i)
    parse_withings( userid, m )
  end


  private

  def self.parse_withings( userid, measures_full )
    data_points = []

    measures_full.measures.each do |measures|
      last_meas = measures.measures[0]
      measures.measures.each do |last_meas|

        wipoint = Withings.new
        wipoint.userid = userid

        wipoint.rec_date = Time.at(measures.date)
        type = last_meas['type'].to_i
        value = (last_meas['value'].to_i * (10 ** last_meas['unit'])).to_f

        if type == 6
          wipoint.bodyfat = value.round(1)
        elsif type == 1
          wipoint.weight = (value * 2.20462262).round(1)   # Convert kg to lb
        end

        unless wipoint.weight == nil and wipoint.bodyfat == nil then
          data_points << wipoint
          wipoint.save
        end
      end
    end


    # Combine like-records
    recdates = data_points.collect { |p| p.rec_date }
    recdates.each do |recdate|
    
      logs = Withings.find_all_by_rec_date(recdate)

      if logs.size == 2 then
        pa = logs[0]
        pb = logs[1]

        if pa.rec_date == pb.rec_date && pa.bodyfat == nil and pb.weight == nil and pb.bodyfat != nil then
          pa.bodyfat = pb.bodyfat
          pa.save!
          pb.destroy
        end
      end
    end

    recdates = Withings.find_all_by_userid(userid).collect{ |p| p.rec_date.to_date }

    # Insert weight records if they dont already exist
    recdates.each do |recdate|
      weights = Weight.find(:all, :conditions => ["person_id = ? and rec_date = ?", 1, recdate], :order => 'rec_date ASC')

      #TODO remove outliers
      logged = Withings.find(:all, :conditions => ["rec_date between ? and ?", recdate, (recdate+1)])

      if weights.size == 0 && logged.size > 0 then
        avg_weight = Withings.average(:weight, :conditions => [ "rec_date between ? and ?", recdate, recdate+1 ]).to_f
        avg_bodyfat = Withings.average(:bodyfat, :conditions => [ "rec_date between ? and ?", recdate, recdate+1 ]).to_f

        w = Weight.new
        w.rec_date = recdate
        w.person_id = 1
        w.weight = avg_weight.round(2)
        w.bodyfat = avg_bodyfat.round(2)
        w.calc_avg_weight
        w.manual = false
        w.save
      end
    end

  end
end
