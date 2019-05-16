class FriendInviteMailer < ApplicationMailer
  def invite(current_user, invitee_email, invitee_name)
    @inviter_name = current_user.first_name
    @invitee_name = invitee_name
    @invitee_email = invitee_email

    mail(to: invitee_email,
         subject: "#{@inviter_name} wants you to join Brownfield of Dreams!")
  end
end
