# Service helper to connect and parse Github API data
class GitHubService
  def initialize(token)
    @token = token
  end

  def retrieve(url_end)
    response = conn.get(url_end)
    JSON.parse(response.body, symbolize_names: true)
  end

  def conn
    Faraday.new('https://api.github.com/user/') do |f|
      f.adapter Faraday.default_adapter
      f.params['access_token'] = @token
    end
  end
end
