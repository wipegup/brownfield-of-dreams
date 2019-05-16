class UsersController < ApplicationController
  def show
    render locals: {
      facade: UserInformationFacade.new(current_user)
    }
  end

  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)
    if @user.save
      email_code = @user.generate_activation
      ActivationMailer.activation(@user, email_code).deliver_now

      session[:user_id] = @user.id
      flash[:notice] = "Logged in as #{@user.email}"
      redirect_to dashboard_path
    else
      flash[:error] = 'E-mail already in use'
      render :new
    end
  end

  def activate
    activation = Activation.find_by(email_code: params[:email_code])

    if activation
      activation.status = true
      activation.save
      flash[:notice] = 'Thank you! Your account is now activated.'
    else
      flash[:notice] = 'Sorry, invalid activation code entered.'
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :password)
  end
end
