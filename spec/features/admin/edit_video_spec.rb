require 'rails_helper'

describe 'An Admin' do
  before :each do
    @video = create(:video)
    @admin = create(:admin)
    allow_any_instance_of(ApplicationController)
      .to receive(:current_user).and_return(@admin)
  end

  it 'can edit and update video attributes' do
    updated_video_params = attributes_for(:video)
    visit edit_admin_video_path(@video)

    expect(page).to have_field('Title', with: @video.title)
    expect(page).to have_field('Description', with: @video.description)
    expect(page).to have_field('Thumbnail', with: @video.thumbnail)

    fill_in 'Title', with: updated_video_params[:title]
    fill_in 'Description', with: updated_video_params[:description]
    fill_in 'Thumbnail', with: updated_video_params[:thumbnail]

    click_button 'Update Video'

    expect(current_path).to eq(edit_admin_tutorial_path(@video.tutorial_id))

    expect(page).to have_content("Video Updated!")
    expect(page).to have_content(updated_video_params[:title])
    expect(page).not_to have_content(@video.title)
  end
end
