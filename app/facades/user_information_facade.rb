# Collects data for a user for passing to user#show ('/dashboard')
class UserInformationFacade
  def initialize(current_user)
    @current_user = current_user
  end

  def top_repos
    git_repo_data.take(5).map do |repo_data|
      Repo.new(repo_data)
    end
  end

  private
  
    def git_repo_data
      @git_repo_data ||= github_service.get_repos
    end

    def github_service
      @github_service ||= GitHubService.new(@current_user.token)
    end
end
