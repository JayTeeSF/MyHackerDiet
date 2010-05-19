class Weight < ActiveRecord::Base
  belongs_to :person


  def bmi
    if person.height == nil
      return 0

    return ((avg_weight * 703) / (person.height**2)).round(2)
  end

  def rmr
    if person.height == nil || person.age == nil
      return 0

    return ((9.99 * (avg_weight/2.2)) + (6.25 * (person.height * 2.54)) - (4.92 * person.age) + 5).round(2)
  end

  def tdee
    return (rmr * 1.2).round(2)
  end
end
