require 'test_helper'

class WeightTest < ActiveSupport::TestCase
  test "average no previous" do
    w = Weight.new
    w.rec_date = "2010-01-01".to_date
    w.user_id = 100
    w.weight = 100
    w.save

    w.calc_avg_weight

    assert_equal w.weight, w.avg_weight
  end

  test "two weights" do
    w1 = Weight.new
    w2 = Weight.new
    w1.user_id = 100
    w2.user_id = 100
    w1.rec_date = "2010-01-01".to_date
    w2.rec_date = "2010-01-02".to_date
    w1.weight = 100
    w2.weight = 200
    w1.save
    w2.save

    w1.calc_avg_weight
    w2.calc_avg_weight

    assert_equal 150, w2.avg_weight
  end

  test "two weights_decimal" do
    w1 = Weight.new
    w2 = Weight.new
    w1.user_id = 100
    w2.user_id = 100
    w1.rec_date = "2010-01-01".to_date
    w2.rec_date = "2010-01-02".to_date
    w1.weight = 100
    w2.weight = 101
    w1.save
    w2.save

    w1.calc_avg_weight
    w2.calc_avg_weight

    assert_equal 100.5, w2.avg_weight.to_f
  end
end
