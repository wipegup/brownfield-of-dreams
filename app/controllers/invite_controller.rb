class InviteController < ApplicationController
  def new; end

  def create
    service = GitHubService.new(current_user.github_token)
                           .user_info(params[:github_username])
    invitee_email = service[:email]
    invitee_name = service[:name]

    if invitee_email
      FriendInviteMailer.invite(current_user,
                                invitee_email,
                                invitee_name).deliver_now
      flash[:notice] = 'Successfully sent invite!'
    else
      flash[:notice] = "The Github user you selected does not have an \
email address associated with their account."
    end
    redirect_to dashboard_path
  end
end
