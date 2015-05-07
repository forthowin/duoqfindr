class User < ActiveRecord::Base
  acts_as_messageable

  geocoded_by :ip_address

  has_secure_password validations: false

  validates :username, presence: true, uniqueness: true, length: { minimum: 2 }
  validates :password, length: { minimum: 5 }, presence: true, on: :create
  validates :password, length: { minimum: 5 }, allow_blank: true, on: :update
  validates :email, presence: true

  after_validation :geocode
  before_save :generate_slug!

  def to_param
    self.slug
  end

  def generate_token!
    update_column(:account_token, SecureRandom.hex(5))
  end

  def generate_slug!
    the_slug = to_slug(self.username)
    slug = User.find_by slug: the_slug
    count = 2
    while slug and slug != self
    the_slug = append_suffix(the_slug, count)
    slug = self.class.find_by slug: the_slug
      count += 1
    end
    self.slug = the_slug.downcase
  end

  def append_suffix(str, count)
    if str.split('-').last.to_i != 0
      return str.split('-').slic(0...-1).join('-') + '-' + count.to_s
    else
      return str + '-' + count.to_s
    end
  end

  def to_slug(name)
    str = name.strip
    str.gsub!(/\s*[^A-Za-z0-9]\s*/, '-')
    str.gsub!(/-+/,'-')
    str.downcase
  end
end
