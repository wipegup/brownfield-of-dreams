class FriendshipsController < ApplicationController
  def create
    new_friend = User.find_by(github_uid: params[:github_uid])

    current_user.friendships.create(friend_id: new_friend.id)

    # binding.pry
    redirect_to dashboard_path
  end
end
