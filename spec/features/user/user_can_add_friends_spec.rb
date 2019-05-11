require 'rails_helper'

describe 'A registered user', :vcr do
  before :each do
    @user = create(:user)
    @future_friend = create(:user, github_uid: '1234')

    allow_any_instance_of(ApplicationController)
      .to receive(:current_user).and_return(@user)
    allow(@user).to receive(:github_token).and_return(ENV['GH_USER_TOKEN'])
    allow(@user).to receive(:github_uid).and_return(true)

    allow_any_instance_of(GithubUser)
      .to receive(:has_account?).and_return(true)

    allow_any_instance_of(GithubUser)
      .to receive(:github_uid).and_return('1234')

    visit dashboard_path
  end

  it 'links show up next to followers that have accounts in our system'
  it 'links show up next to followings that have accounts in our database'
  it 'links do not show up next to followers or followings if they are not in our database'
  it 'shows all of the users that I have friended'
  it 'shows error messages if adding a friend fails'

  it 'can see add followers as friends if they have an account' do
    expect(@user.friends.count).to eq(0)

    within(first('.follower-link')) do
      click_on "Add as Friend"
    end

    expect(current_path).to eq(dashboard_path)
    @user.reload
    expect(@user.friends.count).to eq(1)
  end
end
