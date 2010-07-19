class Weight < ActiveRecord::Base
  belongs_to :user
  before_save :fill_weight_gaps

  def bmi
    begin
      return ((avg_weight * 703) / (user.height**2)).round(2)
    rescue
      return 0
    end
  end

  def rmr
    begin
      return ((9.99 * (avg_weight/2.2)) + (6.25 * (user.height * 2.54)) - (4.92 * user.age) + 5).round(2)
    rescue
      return 0
    end
  end

  def tdee
    return (rmr * 1.2).round(2)
  end

  def fill_weight_gaps
    max_rec = Weight.find_by_user_id(user_id, :limit => 1, :order => 'rec_date DESC')

    if max_rec == nil || (max_rec.rec_date - rec_date).abs == 1
      return
    end

    weight_diff = weight - max_rec.weight
    days_between = (rec_date - max_rec.rec_date).to_i
    weight_per_day = (weight_diff / days_between).to_f

    (1..(days_between-1)).each do |day|
      filler = Weight.new
      filler.user_id = user_id
      filler.rec_date = max_rec.rec_date + day
      filler.weight = max_rec.weight + (weight_per_day * day)
      filler.manual = 0
      filler.send(:create_without_callbacks)
      filler.calc_avg_weight
    end

  end

  def calc_avg_weight
    datapool = Weight.find_all_by_user_id(user_id, :limit => 20, :conditions => ["rec_date <= ?", rec_date], :order => 'rec_date DESC')
    self[:avg_weight] = averageweight datapool
    self.send(:update_without_callbacks)
  end

  private

  def averageweight(weights)
    total = 0

    return 0 if weights.length == 0

    weights.each do |weight|
      total += weight.weight
    end

    total = total / weights.length
    total = total * 100
    total = total.round()

    return total / 100;
  end

end
