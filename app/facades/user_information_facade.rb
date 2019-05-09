# frozen_string_literal: true

# Collects data for a user for passing to user#show ('/dashboard')
class UserInformationFacade
  def initialize(current_user)
    @current_user = current_user
  end

  def bookmarked_videos
    @current_user.videos.order(:tutorial_id, :position)
  end

  def top_repos
    git_repo_data.take(5).map do |repo_data|
      Repo.new(repo_data)
    end
  end

  def followers
    git_follower_data.map do |follower_data|
      GithubUser.new(follower_data)
    end
  end

  def followings
    git_following_data.map do |following_data|
      GithubUser.new(following_data)
    end
  end

  private

  def git_follower_data
    @git_follower_data ||= github_service.retrieve('followers')
  end

  def git_following_data
    @git_following_data ||= github_service.retrieve('following')
  end

  def git_repo_data
    @git_repo_data ||= github_service.retrieve('repos')
  end

  def github_service
    @github_service ||= GitHubService.new(@current_user.github_token)
  end
end
