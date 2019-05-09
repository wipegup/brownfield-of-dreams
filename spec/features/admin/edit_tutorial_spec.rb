require 'rails_helper'

describe 'An Admin' do
  before :each do
    @tutorial = create(:tutorial)
    @admin = create(:admin)
    allow_any_instance_of(ApplicationController)
      .to receive(:current_user).and_return(@admin)
  end

  before :each, editable_tutorial: true do
    @videos = create_list(:sequenced_video, 3, tutorial: @tutorial)
  end

  describe 'can edit a tutorial' do
    scenario 'by adding a video', :js, :vcr do
      visit edit_admin_tutorial_path(@tutorial)

      click_on 'Add Video'

      fill_in 'video[title]', with: 'How to tie your shoes.'
      fill_in 'video[description]', with: 'Over, under, around and through'
      fill_in 'video[video_id]', with: 'J7ikFUlkP_k'
      click_on 'Create Video'

      expect(current_path).to eq(edit_admin_tutorial_path(@tutorial))

      within(first('.video')) do
        expect(page).to have_content('How to tie your shoes.')
      end
    end

    scenario 'by going to edit video attributes page', :editable_tutorial do
      visit edit_admin_tutorial_path(@tutorial)

      within('#video-list') do
        @video_id = first('div', class: 'video')['data-id']
        within(first('div', class: 'video')) do
          click_on 'Edit'
        end
      end

      expect(current_path).to eq(edit_admin_video_path(Video.find(@video_id)))
    end

    scenario 'by deleting video from the tutorial', :editable_tutorial do
      visit edit_admin_tutorial_path(@tutorial)

      within('#video-list') do
        video_id = first('div', class: 'video')['data-id']
        @video_info = Video.find(video_id)
        within(first('div', class: 'video')) do
          click_on 'Delete'
        end
      end

      expect(current_path).to eq(edit_admin_tutorial_path(@tutorial))
      within('#video-list') do
        expect(page).not_to have_content(@video_info.title)
      end
    end

    scenario 'by deleting the tutorial', :editable_tutorial do
      visit admin_dashboard_path
      within(first('.admin-tutorial-card')) do
        click_on 'Delete'
      end

      expect(Video.count).to eq(0)
      expect(Tutorial.count).to eq(0)

      expect(current_path).to eq(admin_dashboard_path)
      expect(page).not_to have_content(@tutorial.title)
    end

    scenario 'by moving videos around by dragging them'
  end
end
