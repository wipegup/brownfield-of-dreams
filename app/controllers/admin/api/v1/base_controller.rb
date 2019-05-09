# frozen_string_literal: true

class Admin::Api::V1::BaseController < ActionController::API
  before_action :require_admin!

  def require_admin!
    four_oh_four unless current_user&.admin?
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def four_oh_four
    render status: 404, file: "#{Rails.root}/public/404.html"
  end
end
