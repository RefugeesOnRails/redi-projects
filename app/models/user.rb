class User < ActiveRecord::Base
  has_many :projects
  has_many :votes

  before_validation :ensure_has_auth_token

  validates_uniqueness_of :name, :auth

  def self.find_authenticated_user auth_token
    User.find_by_auth(auth_token)
  end

  def ensure_has_auth_token
    return if self.auth
    self.auth = random_new_auth_token
  end

private
  def random_new_auth_token
    while true do
      token = (0...8).map { ('a'..'z').to_a[rand(26)] }.join
      return token if User.where(auth: token).count == 0
    end
  end
end
