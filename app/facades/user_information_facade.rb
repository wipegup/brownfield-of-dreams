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
      @_repo_data ||= github_service.get_repos
    end

    def github_service
      @_service ||= GitHubService.new(@current_user.token)
    end

end
