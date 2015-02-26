class User < ActiveRecord::Base

  has_secure_password

  validates :username, presence: true, uniqueness: true
  validates :password, length: {minimum: 5}

end