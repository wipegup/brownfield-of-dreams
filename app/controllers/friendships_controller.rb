class FriendshipsController < ApplicationController
  def create
    new_friend = User.find_by(github_uid: params[:github_uid])
    if new_friend
      current_user.friendships.create(friend_id: new_friend.id)
    else
      flash[:info] = "No Friend Created"
    end

    redirect_to dashboard_path
  end
end
