require 'rails_helper'

describe 'A registered user', :vcr do
  before :each do
    @user = create(:github_user)
    @future_friend = create(:user, github_uid: '1234')

    allow_any_instance_of(ApplicationController)
      .to receive(:current_user).and_return(@user)

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
      @users_without_GH = create_list(:user, 3)
      @github_followers_without_account =
        [{login: "NoAccount1", html_url: "www.google.com", github_uid: 123456},
         {login: "NoAccount2", html_url: "www.google.com", github_uid: 123457}]

      @github_followings_without_account =
       [{login: "NoAccount3", html_url: "www.google.com", github_uid: 123458},
        {login: "NoAccount4", html_url: "www.google.com", github_uid: 123459}]

      @followers_with_account_info = @followers_with_account.map do |f|
        {login:f.first_name, html_url: "www.google.com", github_uid:f.github_uid, user_id:f.id}
      end

      @followers = @followers_with_account_info + @github_followers_without_account

      @followings_with_account_info = @followings_with_account.map do |f|
        {login:f.first_name, html_url: "www.google.com", github_uid:f.github_uid, user_id:f.id}
      end

      @followings = @followings_with_account_info + @github_followings_without_account

      allow_any_instance_of(UserInformationFacade)
        .to receive(:followers)
        .and_return(@followers.map{ |f| GithubUser.new(f)})

      allow_any_instance_of(UserInformationFacade)
        .to receive(:followings)
        .and_return(@followings.map{ |f| GithubUser.new(f)})

      allow_any_instance_of(UserInformationFacade)
        .to receive(:top_repos)
        .and_return([])

    visit dashboard_path
  end

  it 'links show up next to followers that have accounts in our system' do
    within ('#github-followers') do
      followers = all('.follower-link')
      followers.each do |f|
        if f.text.include?("NoAccount")
          expect(f).not_to have_link("Add as Friend")
        else
          expect(f).to have_link("Add as Friend")
        end
      end
    end
  end

  it 'links show up next to followings that have accounts in our database' do
    within ('#github-following') do
      followers = all('.follower-link')
      followers.each do |f|
        if f.text.include?("NoAccount")
          expect(f).not_to have_link("Add as Friend")
        else
          expect(f).to have_link("Add as Friend")
        end
      end
    end
  end

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
