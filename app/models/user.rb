class User < ActiveRecord::Base
  has_many :weights
  has_many :system_messages, :as => :messageable


  # Include default devise modules. Others available are:
  # :http_authenticatable, :token_authenticatable, :confirmable, :lockable, :timeoutable and :activatable
  devise :registerable, :database_authenticatable, :recoverable, :confirmable,
         :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :dob, :height,
    :sex, :withings_userid, :withings_publickey, :steps, :withings_email_alerts

  def age
    age = Date.today.year - dob.year
    age -= 1 if Date.today < dob + age.years

    return age
  end

  def self.create_month_message(level, header, message)

    User.all.each do |usr|
      msg = SystemMessage.new(:header => header, :message => message)
      msg.expires = Time.now + 1.month
      msg.level = level
      msg.dismissable = true
      msg.messageable = usr
      msg.save!
    end
  end
end
