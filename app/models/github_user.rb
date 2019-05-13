class GithubUser
  attr_reader :name, :link, :github_uid, :user_id
  def initialize(data)
    @name = data[:login]
    @link = data[:html_url]
    @github_uid = data[:id]
    if User.find_by(github_uid: @github_uid)
      @user_id = User.find_by(github_uid: @github_uid)[:id]
    else
      @user_id = nil
    end
  end

  def friend?(user_id)
    Friendship.find_by(user_id: @user_id, friend_id: user_id) ||
    Friendship.find_by(user_id: user_id, friend_id: @user_id)
  end

  # def has_account?
  #   user_id ? true : false
  # end
end
