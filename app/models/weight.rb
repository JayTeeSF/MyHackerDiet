class Weight < ActiveRecord::Base
  belongs_to :person
  #before_save :calc_avg_weight

  def bmi
    begin
      return ((avg_weight * 703) / (person.height**2)).round(2)
    rescue
      return 0
    end
  end

  def rmr
    begin
      return ((9.99 * (avg_weight/2.2)) + (6.25 * (person.height * 2.54)) - (4.92 * person.age) + 5).round(2)
    rescue
      return 0
    end
  end

  def tdee
    return (rmr * 1.2).round(2)
  end

  def calc_avg_weight
    datapool = Weight.find_all_by_person_id(person_id, :limit => 20, :conditions => ["rec_date <= ?", rec_date], :order => 'rec_date DESC')
    self[:avg_weight] = averageweight datapool
    self.save
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
