class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  def index
    @users = User.all
    json_response(@users)
  end

  def create
    if ((@user = User.find_by(zooniverseHandle: (params[:zooniverseHandle]))))
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
    byebug
    json_response(collaboration, :ok)
  end

  private

  def user_params
    # whitelist params
    params.permit(:zooniverseHandle)
  end

  def set_user
    #byebug
    @user = User.find(params[:id])
  end
end
