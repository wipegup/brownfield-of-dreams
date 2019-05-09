# frozen_string_literal: true

class GithubUser
  attr_reader :name, :link
  def initialize(data)
    @name = data[:login]
    @link = data[:html_url]
  end
end
