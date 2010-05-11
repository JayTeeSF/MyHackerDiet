Class AvgWeight
  attr_reader :date
  attr_reader :weight
  attr_reader :avg_weight

  def initialize(date, weight, avg_weight)
    @date = date
    @weight = weight;
    @avg_weight = avg_weight;
  end
end

