require 'rails_helper'

describe 'An Admin' do
  it 'can add a tutorial if all information present', :js do
    admin = create(:admin)
    new_tutorial_attrs = attributes_for(:tutorial)

    allow_any_instance_of(ApplicationController)
      .to receive(:current_user).and_return(admin)

    visit admin_dashboard_path
    click_on 'New Tutorial'

    expect(current_path).to eq(new_admin_tutorial_path)

    fill_in 'tutorial[description]', with: new_tutorial_attrs[:description]
    fill_in 'tutorial[thumbnail]', with: new_tutorial_attrs[:thumbnail]

    click_on 'Save'

    expect(page).to have_content('Fill out Form Completely')
    fill_in 'tutorial[title]', with: new_tutorial_attrs[:title]
    fill_in 'tutorial[description]', with: new_tutorial_attrs[:description]
    fill_in 'tutorial[thumbnail]', with: new_tutorial_attrs[:thumbnail]

    click_on 'Save'

    expect(current_path).to eq(admin_dashboard_path)
    expect(page).to have_content(new_tutorial_attrs[:title])
  end
end
