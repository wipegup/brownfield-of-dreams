require 'rails_helper'

describe 'A registered user can add their Github', :vcr do
  before :each do
    @user = create(:user)

    allow_any_instance_of(ApplicationController)
      .to receive(:current_user).and_return(@user)

    @uid = '12345'
    @token = ENV['GH_USER_TOKEN']

    visit dashboard_path
  end

  it 'can add github account via OAuth' do
    # OmniAuth mock setup
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
      uid: @uid,
      credentials: {
        token: @token
      }
    )
    Rails.application.env_config['omniauth.auth'] =
      OmniAuth.config.mock_auth[:github]

    expect(@user.github_uid).to be_nil
    expect(@user.github_token).to be_nil

    click_on 'Connect to Github'
    expect(current_path).to eq(dashboard_path)

    @user.reload
    expect(@user.github_uid).to eq(@uid.to_i)
    expect(@user.github_token).to eq(@token)

    # Cleanup
    OmniAuth.config.mock_auth[:github] = nil
  end
end
