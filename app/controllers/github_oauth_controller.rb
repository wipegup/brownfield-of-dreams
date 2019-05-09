class GithubOauthController < ApplicationController
  def create
    auth = request.env['omniauth.auth']

    current_user.github_uid = auth['uid']
    current_user.github_token = auth['credentials']['token']
    current_user.save

    redirect_to dashboard_path
  end
end
