class User < ActiveRecord::Base
  geocoded_by :ip_address

  has_secure_password validations: false

  validates :username, presence: true, uniqueness: true, length: {minimum: 3, maximum: 15}
  validates :password, length: {minimum: 5}, presence: true, on: :create
  validates :password, length: {minimum: 5}, allow_blank: true, on: :update

  after_validation :geocode


end