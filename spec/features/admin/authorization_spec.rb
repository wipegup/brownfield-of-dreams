require 'rails_helper'

describe 'Admin authorization' do
  scenario 'Non admin users cannot access Admin paths' do
    user = create(:user)
    allow_any_instance_of(ApplicationController)
      .to receive(:current_user).and_return(user)

    expect{ visit admin_dashboard_path }
      .to raise_error(ActionController::RoutingError)
  end
end
