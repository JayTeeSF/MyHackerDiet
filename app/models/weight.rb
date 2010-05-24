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
end
