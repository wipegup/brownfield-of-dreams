class GithubUser
  attr_reader :name, :link, :github_uid, :user_id
  def initialize(data)
    @name = data[:login]
    @link = data[:html_url]
    @github_uid = data[:id]
    @user_id = User.find_by(github_uid: data[:id])
  end

  def has_account?
    user_id ? true : false
  end
end
