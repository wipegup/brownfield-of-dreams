require 'rails_helper'

describe 'A registered user with bookmarks' do
  it 'can add videos to their bookmarks' do
    user = create(:user)

    allow_any_instance_of(ApplicationController)
      .to receive(:current_user).and_return(user)

    tutorial1 = create(:tutorial)
    tutorial2 = create(:tutorial)

    video1 = create(:video, tutorial: tutorial1)
    video2 = create(:video, tutorial: tutorial2)
    video3 = create(:video, tutorial: tutorial2)

    # Create bookmarked videos for user
    create(:user_video, user: user, video: video1)
    create(:user_video, user: user, video: video2)
    create(:user_video, user: user, video: video3)

    visit dashboard_path

    expect(page).to have_css('.bookmarked-video', count: 3)

    bookmarked_videos = page.all('.bookmarked-video')

    expect(bookmarked_videos[0]).to have_link(video1.title)
    expect(bookmarked_videos[1]).to have_link(video2.title)
    expect(bookmarked_videos[2]).to have_link(video3.title)
  end
end
