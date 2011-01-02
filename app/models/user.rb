class User < ActiveRecord::Base
  has_many :weights
  has_many :system_messages, :as => :messageable
  before_save :update_publicid

  # Include default devise modules. Others available are:
  # :http_authenticatable, :token_authenticatable, :confirmable, :lockable, :timeoutable and :activatable
  devise :registerable, :database_authenticatable, :recoverable, :confirmable,
         :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :dob, :height,
    :sex, :withings_userid, :withings_publickey, :steps, :withings_email_alerts,
    :public, :public_id

  def age
    age = Date.today.year - dob.year
    age -= 1 if Date.today < dob + age.years

    return age
  end

  def self.create_month_message(level, message)

    User.all.each do |usr|
      msg = SystemMessage.new(:level => level, :message => message, :dismissable => true)
      msg.expires = Time.now + 1.month
      msg.messageable = usr
      msg.save!
    end
  end

  def weight_graphs
    respond_to do |format|
      format.mobile do
        @graph_week_big = graph_code( 'Last Week', 1.week.ago, '800x300' )
        @graph_two_weeks_big = graph_code( 'Last 2 Weeks', 2.weeks.ago, '800x300' )
        @graph_two_months_big = graph_code( 'Last 2 Months', 2.months.ago, '800x300' )
        @graph_three_months_big = graph_code( 'Last 3 Months', 3.months.ago, '800x300' )
      end
    end
  end

  def graph_code( title, show_days, graph_size )
    weights = Weight.find(:all, :conditions => ["user_id = ?", id], :order => 'rec_date ASC')   # get all the weights, not just this page
    weightDates = ''
    weightValues_below = ''
    weightValues_above = ''
    min = 1000;
    max = 0;

    weightedDates = ''
    weighted_weights = []

    weights.each_with_index do |c,index|
      unless c.rec_date == nil || c.weight == nil then
        weighted_weights.push(c.weight.round);
        if weighted_weights.length > 20 then weighted_weights.shift end #remove first weight when over limit

        if c.rec_date.to_date >= show_days.to_date then
          # For each weight keep a running string for each of the lines (below average, average, above average)
          # our strings will each end with an extra comma, which will need to be chopped when appended to the full
          # google chart string
          unless index % 2 == 0
            weightDates  << '|' + c.rec_date.to_date.day.to_s
            weightedDates << c.avg_weight.to_s + ','
          end
          
          if c.weight < c.avg_weight then
            weightValues_below << c.weight.to_s + ','
            weightValues_above << c.avg_weight.to_s  + ','
          else
            weightValues_above << c.weight.to_s + ','
            weightValues_below << c.avg_weight.to_s + ','
          end

          # Set the minimum and maximum values for the chart (actual weight)
          if c.weight.round < min then min = c.weight.round end
          if c.weight.round > max then max = c.weight.round end
           
          # Set the minimum and maximum values for the chart (avg weight)
          if c.avg_weight.round < min then min = c.avg_weight.round end
          if c.avg_weight.round > max then max = c.avg_weight.round end
        end
      end
    end

    # minimum should be less than all the weights
    min = min - 1

    manchart = "http://chart.apis.google.com/chart?cht=lc&chtt=#{title.gsub(' ', '+')}&chs=#{graph_size}&chd=t:"
    manchart_suffix = "&chco=4d89f9,c6d9fd&chds=#{min},#{max}&chbh=20&chxt=x,y&chxl=1:|#{min}|#{max-((max-min)/2)}|#{max}|0:"
    manchart_areafill = '&chm=b,0000FF,0,-1,10.0|b,80C65A,0,1,0|b,FF0000,1,2,0'

    url = manchart + weightValues_below.chop() + '|' + weightedDates.chop() + '|' + weightValues_above.chop() + manchart_suffix + weightDates + manchart_areafill

    return url
  end

  def update_publicid
    digest_str = "YOUR_DIGEST_HERE"
    self.public_id = Digest::MD5.hexdigest(digest_str)[0..5]
  end
end
