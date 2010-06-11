class Weight < ActiveRecord::Base
  belongs_to :person


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
    weights = Weight.find_all_by_person_id(person_id, :limit => 20, :order => 'rec_date DESC')   # get all the weights, not just this page
    p weights
    avg_weight  = 0

    avg_weight = averageweight(weights)
    return avg_weight
  end


  def averageweight(weights)
    total = 0

    weights.each do |weight|
      total += weight.weight
    end

    total = total / weights.length
    total = total * 100
    total = total.round()

    return total / 100;
  end

end
