class GithubUser
  attr_reader :name, :link, :github_uid, :user_id
  def initialize(data)
    @name = data[:login]
    @link = data[:html_url]
    @github_uid = data[:id]
    @user_id = if User.find_by(github_uid: @github_uid)
                 User.find_by(github_uid: @github_uid)[:id]
               end
  end

  def friend?(user_id)
    Friendship.find_by(user_id: @user_id, friend_id: user_id) ||
      Friendship.find_by(user_id: user_id, friend_id: @user_id)
  end
end
