class Api::V1::BookmarksController < ApplicationController
  skip_before_action :verify_authenticity_token
  def create
    user_video = UserVideo.new(user_video_params)
    if current_user.user_videos.find_by(video_id: user_video.video_id)
      puts 'already here'
      flash[:error] = 'Already in your bookmarks'
    elsif user_video.save
      flash[:success] = 'Bookmark added to your dashboard!'
    end

    render json: {message: "what's up"}

  end

  private

  def user_video_params
    params.permit(:user_id, :video_id)
  end
end
