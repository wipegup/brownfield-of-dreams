# frozen_string_literal: true

require 'spec_helper'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)

abort('The Rails env is running in production mode!') if Rails.env.production?
require 'rspec/rails'
require 'vcr'
require 'webmock/rspec'

VCR.configure do |config|
  config.ignore_localhost = true
  config.cassette_library_dir = 'spec/cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!
  config.filter_sensitive_data('<YOUTUBE_API_KEY>') { ENV['YOUTUBE_API_KEY'] }
  config.filter_sensitive_data('<GH_USER_TOKEN>') { ENV['GH_USER_TOKEN'] }
  config.filter_sensitive_data('<GITHUB_CLIENT_ID>') { ENV['GITHUB_CLIENT_ID'] }
  config.filter_sensitive_data('<GITHUB_CLIENT_SECRET>') { ENV['GITHUB_CLIENT_SECRET'] }

  config.ignore_hosts(
    'chromedriver.storage.googleapis.com',
    'github.com/mozilla/geckodriver/releases',
    'selenium-release.storage.googleapis.com',
    'developer.microsoft.com/en-us/microsoft-edge/tools/webdriver'
  )
end

ActiveRecord::Migration.maintain_test_schema!

Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.javascript_driver = :selenium_chrome

Capybara.configure do |config|
  config.default_max_wait_time = 5
end

SimpleCov.start 'rails'

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.include FactoryBot::Syntax::Methods

  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!
end
