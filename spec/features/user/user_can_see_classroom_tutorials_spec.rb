# frozen_string_literal: true

require 'rails_helper'

describe 'Logged in user' do
  it 'can see "classroom" tutorials' do
    user = create(:user)
    allow_any_instance_of(ApplicationController)
      .to receive(:current_user).and_return(user)
    non_class_tutorials = create_list(:tutorial, 2)
    class_tutorials = create_list(:tutorial, 2, classroom: true)

    visit root_path

    expect(page).to have_content(non_class_tutorials[0].title)
    expect(page).to have_content(class_tutorials[0].title)
  end
end
