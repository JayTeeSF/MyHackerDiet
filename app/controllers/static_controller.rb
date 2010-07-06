class StaticController < ApplicationController
  def about
  end

  def home
    if current_user
      @current_weight = Weight.find_by_user_id(current_user.id, :order => 'rec_date DESC')
      @day_before_weight = Weight.find_by_user_id(current_user.id, :conditions => ['rec_date < ?', @current_weight.rec_date], :order => 'rec_date DESC')

      @last_weighin_days = (Date.today - @current_weight.rec_date).to_i
      @current_diff = (@current_weight.avg_weight - @day_before_weight.avg_weight).to_f

      @steps_7_days = Step.average(:steps, :conditions => ['user_id = ?', current_user.id], :limit => 7, :order => 'rec_date DESC')

      steps_months_sql = 'select strftime("%m", rec_date) as month, sum(steps) as steps, sum(mod_steps) as mod_steps from steps group by strftime("%m", rec_date) limit 365'
      @steps_months = ActiveRecord::Base.connection.execute(steps_months_sql)

      render :home_user
    end
  end

end

