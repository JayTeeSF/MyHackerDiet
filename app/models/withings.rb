class Withings < ActiveRecord::Base

  def self.import_withings(userid, publickey)
    m = WiScale.new(:userid => userid, :publickey => publickey).get_meas

    m.measures.each do |measures|
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

        wipoint.save
      end
    end
  end

  def self.get_withings_single_date(userid, publickey, sdate, edate)
    m = WiScale.new(:userid => userid, :publickey => publickey).get_meas(:startdate => sdate, :enddate => edate)
    data_points = []

    m.measures.each do |measures|
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

        data_points << wipoint
        wipoint.save
      end
    end

    return data_points
  end
end
