class User < ApplicationRecord
  has_many :user_videos
  has_many :videos, through: :user_videos
  has_many :friendships
  has_many :friends, through: :friendships

  validates :email, uniqueness: true, presence: true
  validates_presence_of :password, on: :create
  validates_presence_of :first_name
  enum role: %i[default admin]
  has_secure_password

  def not_friends_with(github_uid)
    friends.find_by(github_uid: github_uid) ? false : true
  end
end
