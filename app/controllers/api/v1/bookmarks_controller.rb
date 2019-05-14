class Api::V1::BookmarksController < ApplicationController
  skip_before_action :verify_authenticity_token
  def create
    binding.pry

  end
end
