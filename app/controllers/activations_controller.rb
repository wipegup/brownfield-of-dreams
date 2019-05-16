class ActivationsController < ApplicationController
  def update
    activation = Activation.find_by(email_code: params[:email_code])

    if activation
      activation.status = true
      activation.save
      flash[:notice] = 'Thank you! Your account is now activated.'
    else
      flash[:notice] = 'Sorry, invalid activation code entered.'
    end
  end
end
