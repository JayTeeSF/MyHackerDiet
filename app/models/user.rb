class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :http_authenticatable, :token_authenticatable, :confirmable, :lockable, :timeoutable and :activatable
  devise :registerable, :database_authenticatable, :recoverable,
         :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :dob, :height, :sex, :withings_userid, :withings_publickey

  has_one :user_option

  def age
    age = Date.today.year - dob.year
    age -= 1 if Date.today < dob + age.years

    return age
  end
end
