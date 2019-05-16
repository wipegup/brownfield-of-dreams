# Service helper to connect and parse Github API data
class GitHubService
  def initialize(token)
    @token = token
  end

  def json(body)
    JSON.parse(body, symbolize_names: true)
  end
  def retrieve(url_end)
    response = conn.get('user/' + url_end)
    json(response.body)
  end

  def user_info(handle)
    response = conn.get('users/' + handle)
    json(response.body)
  end

  def conn
    Faraday.new('https://api.github.com/') do |f|
      f.adapter Faraday.default_adapter
      f.params['access_token'] = @token
    end
  end
end
