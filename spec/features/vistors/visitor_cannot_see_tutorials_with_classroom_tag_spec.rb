require 'rails_helper'

describe 'vister' do
  it 'cannot see "classroom" tutorials' do
    non_class_tutorials = create_list(:tutorial, 2)
    class_tutorials = create_list(:tutorial, 2, classroom: true)

    visit root_path

    expect(page).to have_content(non_class_tutorials[0].title)
    expect(page).not_to have_content(class_tutorials[0].title)
  end
end
