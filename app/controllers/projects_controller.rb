class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :update, :destroy, :ranking]

  skip_before_action :authenticate_user

  def index
    @projects = Project.all
    json_response(@projects)
  end

  def create
    if ((@project = Project.find_by(name: (params[:name]))))
      json_response(@project, :ok)
    else
      @project = Project.create!(project_params)
      json_response(@project, :created)
    end
  end

  def show
    json_response(@project)
  end

  def update
    @project.update(project_params)
    json_response(@project, :accepted)
  end

  def destroy
    @project.destroy
    head :no_content
  end

  def ranking
    json_response(@project.scoreboard(user_id: params[:user_id]))
  end

  private

  def project_params
    params.permit(:name, :user_id)
  end

  def set_project
    @project = Project.find(params[:id])
  end
end
