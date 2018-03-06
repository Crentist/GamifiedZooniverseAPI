class UsersController < ApplicationController
  before_action :set_user,
                only: [:show, :update, :destroy]

  before_action :set_user_by_user_id,
                only: [
                        :projectCollaboration,
                        :sitesUsernames,
                        :siteUsername
                      ]

  skip_before_action :authenticate_user

  def index
    @users = User.all
    json_response(@users)
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
    collaboration = @user.collaborations.find_by(project_id: params[:project_id])
    json_response(collaboration, :ok)
  end

  # GET
  def sitesUsername
    user = User.find(params[:user_id])
    sitesUsernames = @user.sitesUsernames

  end

  # POST
  def siteUsername
    if params["site"] && params["username"]
      if @user.add_site_username(params["site"], params["username"])
        json_response({sites_usernames: @user.get_sites_usernames}, :created)
      else
        json_response(cannot_add_error, :ok)
      end
    else
      json_response(no_params_error, :unprocessable_entity)
    end
  end

  private

  def user_params
    params.permit(:handle)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def set_user_by_user_id
    @user = User.find(params[:user_id])
  end

  def no_params_error
    {
      error: "Nombre de sitio o username no presentes"
    }
  end

  def cannot_add_error
    {
      error: "No se pudo agregar el username al sitio"
    }
  end
end
