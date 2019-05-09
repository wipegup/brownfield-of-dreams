# frozen_string_literal: true

# Parses data from github API retrieving repo data

class Repo
  attr_reader :name, :link
  def initialize(data)
    @name = data[:name]
    @link = data[:html_url]
  end
end
