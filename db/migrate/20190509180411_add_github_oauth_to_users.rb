class AddGithubOauthToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :github_token, :string
    add_column :users, :github_uid, :integer
  end
end
