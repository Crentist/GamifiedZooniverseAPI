class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  def index
    @users = User.all
    json_response(@users)
  end

  def create
    if ((@user = User.find_by(handle: (params[:handle]))))
      json_response(@user, :ok)
    else
      @user = User.create!(user_params)
      json_response(@user, :created)
    end
  end

  def show
    json_response(@user)
  end

  def update
    @user.update(user_params)
    head :no_content
  end

  def destroy
    @user.destroy
    head :no_content
  end

  def projectCollaboration
    @user = User.find(params[:user_id])
    collaboration = @user.collaborations.find_by(project_id: params[:project_id])
    json_response(collaboration, :ok)
  end

  private

  def user_params
    params.permit(:handle, :password, :password_confirmation)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
