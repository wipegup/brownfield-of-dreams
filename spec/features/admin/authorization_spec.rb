require 'rails_helper'

describe 'Admin authorization' do
  scenario 'Unregistered users cannot access Admin paths' do
    visit admin_dashboard_path

    expect(page.status_code).to eq(404)
  end

  scenario 'Registered users cannot access Admin paths' do
    user = create(:user)
    allow_any_instance_of(ApplicationController)
      .to receive(:current_user).and_return(user)

    visit admin_dashboard_path

    expect(page.status_code).to eq(404)
  end  
end
