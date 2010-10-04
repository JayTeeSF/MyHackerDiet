class StaticController < ApplicationController
  def about
  end

  def home
    if current_user

      # Weight summary information
      begin
        @current_weight = Weight.find_by_user_id(current_user.id, :order => 'rec_date DESC')
        @one_week_ago_weight = Weight.find_by_user_id( 1, :conditions => ["rec_date >= '#{7.days.ago}'"] )

        @last_weighin_days = (Date.today - @current_weight.rec_date).to_i
        @current_diff = (@current_weight.avg_weight - @one_week_ago_weight.avg_weight).to_f
      rescue
        @current_weight = 0
        @one_week_ago_weight = 0
        @last_weighin_days = 0
        @current_diff = 0
      end

      # Step summary information
      begin
        @steps_7_days = Step.average(:steps, :conditions => ['user_id = ?', current_user.id], :limit => 7, :order => 'rec_date DESC')

        steps_months_sql = "select year(rec_date) as year, month(rec_date) as month, sum(steps) as steps, sum(mod_steps) as mod_steps, sum(mod_min) as mod_min from steps where user_id = #{current_user.id} and month(rec_date) is not null group by year(rec_date), month(rec_date) limit 365"
        @steps_months = Step.connection.select_all(steps_months_sql)
      rescue
        @steps_7_days = 0
        @steps_months = 0
      end

      render :home_user
    end
  end

end

