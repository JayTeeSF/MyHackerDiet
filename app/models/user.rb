class User < ActiveRecord::Base
  has_many :weights

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
end
