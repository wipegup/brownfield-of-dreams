require 'rails_helper'

describe 'A registered user',:vcr do
  before :each do
    @user = create(:user)

    allow_any_instance_of(ApplicationController)
      .to receive(:current_user).and_return(@user)
    allow(@user).to receive(:token).and_return(ENV['GH_USER_TOKEN'])
    visit dashboard_path
  end

  it 'can see five repos'do

    within('#github-repos') do
      expect(page).to have_css('.repo-link', count: 5)
      within(first('.repo-link')) do
        expect(page).to have_selector('a')
      end
    end
  end

  it 'can see all followers' do

    within('#github-followers') do
      expect(page).to have_css('.follower-link')
      within(first('.follower-link')) do
        expect(page).to have_selector('a')
      end
    end
  end

  it 'can see all following' do
    within('#github-following') do
      expect(page).to have_css('.following-link')
      within(first('.following-link')) do
        expect(page).to have_selector('a')
      end
    end
  end
end
