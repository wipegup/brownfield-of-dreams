require 'rails_helper'

describe 'A registered user' do
  it 'can see five repos', :vcr do
    user = create(:user)

    allow_any_instance_of(ApplicationController)
      .to receive(:current_user).and_return(user)
    allow(user).to receive(:token).and_return(ENV['GH_USER_TOKEN'])

    visit dashboard_path

    within('#github-repos') do
      expect(page).to have_css('.repo-link', count: 5)
      within(first('.repo-link')) do
        expect(page).to have_selector('a')
      end
    end
  end
end
