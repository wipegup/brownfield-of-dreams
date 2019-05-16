require 'rails_helper'

describe 'Logged in user', :vcr do
  before :each do
    @user = create(:user)

    allow_any_instance_of(ApplicationController)
      .to receive(:current_user).and_return(@user)
    allow(@user).to receive(:github_token).and_return(ENV['GH_USER_TOKEN'])
    allow(@user).to receive(:github_uid).and_return(true)

    visit dashboard_path

    click_on 'Invite a Friend to Join'
  end

  it 'can email invitations to friends' do
    expect(current_path).to eq('/invite')

    fill_in 'github_username', with: 'milevy1'
    click_on 'Send Invite'

    ## Try out using `ActionMailer::Base.deliveries` for testing?
    expect(current_path).to eq(dashboard_path)
    expect(page).to have_content('Successfully sent invite!')
  end

  it 'shows error message if user does not have an email available' do
    fill_in 'github_username', with: 'wipegup'
    click_on 'Send Invite'

    msg = "The Github user you selected does not have an email \
address associated with their account."
    expect(page).to have_content(msg)
  end
end
