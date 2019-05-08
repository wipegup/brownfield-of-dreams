require 'rails_helper'

describe 'An Admin can create a new tutorial' do
  scenario 'Creating a new tutorial' do
    admin = create(:admin)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

    visit new_admin_tutorial_path

    fill_in 'tutorial[title]', with: 'Steph Curry Skills'
    fill_in 'tutorial[description]', with: 'How to miss a wide open layup at the end of a close game.'
    fill_in 'tutorial[thumbnail]', with: 'steph_curry_face_palm.jpg'
    click_on 'Save'

    tutorial = Tutorial.last

    expect(current_path).to eq(edit_admin_tutorial_path(tutorial))

    expect(page).to have_content('Steph Curry Skills')
  end
end
