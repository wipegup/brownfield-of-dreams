# frozen_string_literal: true

class Admin::TutorialsController < Admin::BaseController
  def edit
    @tutorial = Tutorial.find(params[:id])
  end

  def create
    @tutorial = Tutorial.new(tutorial_params)
    if @tutorial.save
      flash[:info] = 'Successfully created tutorial'
      redirect_to tutorial_path(@tutorial)
    else
      flash[:error] = 'Fill out Form Completely'
      render :new
    end
  end

  def destroy
    tutorial = Tutorial.find(params[:id])
    title = tutorial.title
    tutorial.destroy
    flash[:info] = "#{title} destroyed"
    redirect_to admin_dashboard_path
  end

  def new
    @tutorial = Tutorial.new
  end

  def update
    tutorial = Tutorial.find(params[:id])
    if tutorial.update(tutorial_tag_params)
      flash[:success] = "#{tutorial.title} tagged!"
    end
    redirect_to edit_admin_tutorial_path(tutorial)
  end

  private

  def tutorial_tag_params
    params.require(:tutorial).permit(:tag_list)
  end

  def tutorial_params
    params.require(:tutorial).permit(:title, :description, :thumbnail)
  end
end
