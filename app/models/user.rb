class User < ActiveRecord::Base

  has_secure_password

  validates :username, presence: true, uniqueness: true, length: {minimum: 3, maximum: 15}
  validates :password, length: {minimum: 5}

end