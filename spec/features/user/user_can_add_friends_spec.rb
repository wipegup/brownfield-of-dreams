require 'rails_helper'

describe 'A registered user', :vcr do
  before :each do
    @user = create(:github_user)
    @future_friend = create(:user, github_uid: '1234')

    # allow_any_instance_of(ApplicationController)
    #   .to receive(:current_user).and_return(@user)

    # allow(@user).to receive(:github_token).and_return(ENV['GH_USER_TOKEN'])
    # allow(@user).to receive(:github_uid).and_return(true)
    #
    # allow_any_instance_of(GithubUser)
    #   .to receive(:has_account?).and_return(true)
    #
    # allow_any_instance_of(GithubUser)
    #   .to receive(:github_uid).and_return('1234')

    @followers_with_account = create_list(:github_user, 2)
    @followings_with_account = create_list(:github_user, 2)
    @users_without_github = create_list(:user, 3)
    @github_followers_without_account =
      [{ login: 'NoAccount1', html_url: 'www.google.com', id: 123_456 },
       { login: 'NoAccount2', html_url: 'www.google.com', id: 123_457 }]

    @github_followings_without_account =
      [{ login: 'NoAccount3', html_url: 'www.google.com', id: 123_458 },
       { login: 'NoAccount4', html_url: 'www.google.com', id: 123_459 }]

    @followers_with_account_info = @followers_with_account.map do |f|
      { login: f.first_name,
        html_url: 'www.google.com',
        id: f.github_uid,
        user_id: f.id }
    end

    @followers = @followers_with_account_info + @github_followers_without_account

    @followings_with_account_info = @followings_with_account.map do |f|
      { login: f.first_name,
        html_url: 'www.google.com',
        id: f.github_uid,
        user_id: f.id }
    end

    @followings = @followings_with_account_info + @github_followings_without_account

    allow_any_instance_of(UserInformationFacade)
      .to receive(:followers)
      .and_return(@followers.map { |f| GithubUser.new(f) })

    allow_any_instance_of(UserInformationFacade)
      .to receive(:followings)
      .and_return(@followings.map { |f| GithubUser.new(f) })

    allow_any_instance_of(UserInformationFacade)
      .to receive(:top_repos)
      .and_return([])

    # Put below in helper method
    visit '/'
    click_on 'Sign In'
    fill_in 'session[email]', with: @user.email
    fill_in 'session[password]', with: @user.password

    click_on 'Log In'

    visit dashboard_path
  end

  it 'links show up next to followers that have accounts in our system' do
    within('#github-followers') do
      followers = all('.follower-link')
      followers.each do |f|
        if f.text.include?('NoAccount')
          expect(f).not_to have_link('Add as Friend')
        else
          expect(f).to have_link('Add as Friend')
        end
      end
    end
  end

  it 'links show up next to followings that have accounts in our database' do
    within('#github-following') do
      followers = all('.follower-link')
      followers.each do |f|
        if f.text.include?('NoAccount')
          expect(f).not_to have_link('Add as Friend')
        else
          expect(f).to have_link('Add as Friend')
        end
      end
    end
  end

  it 'shows all of the users that I have friended' do
    future_friends = [@followers_with_account[0], @followings_with_account[0]]
    within("#follower-link-#{future_friends[0].github_uid}") do
      click_on 'Add as Friend'
    end

    within("#following-link-#{future_friends[1].github_uid}") do
      click_on 'Add as Friend'
    end
    @user = @user.reload
    within('#friends') do
      future_friends.each do |friend|
        expect(page).to have_content(friend.first_name)
        expect(page).to have_content(friend.last_name)
      end
    end
  end

  it 'shows error messages if adding a friend fails' do
    page.driver.post friendships_path, github_uid: 9999
    click_on 'redirected'
    expect(page).to have_content('No Friend Created')
  end

  it 'Adding friend removes add friend link' do
    expect(@user.friends.count).to eq(0)
    friend_name = ''
    within(first('.follower-link')) do
      friend_name = page.text.split(' ')[0]
      click_on 'Add as Friend'
    end

    expect(current_path).to eq(dashboard_path)
    expect(page).not_to have_content("#{friend_name} Add as Friend")
    expect(page).to have_content("#{friend_name} is a Friend")
    @user.reload
    expect(@user.friends.count).to eq(1)
  end
end
