class CollaborationsController < ApplicationController
  before_action :set_collaboration, only: [:show, :update, :destroy]

  skip_before_action :authenticate_user #scope: :user ???

  def index
    @collaborations = Collaboration.all
    json_response(@collaborations)
  end

  def show
    json_response(@collaboration)
  end

  def create
    @collaboration = Collaboration.create!(collaboration_params) do
      |c| c.points = 0
    end
    json_response(@collaboration, :created)
  end

  def update
    @collaboration.update(item_params)
    head :no_content
  end

  def destroy
    @collaboration.destroy
    head :no_content
  end

  def increment
    @collaboration = Collaboration.find(params[:collaboration_id])
    @collaboration.increment(params[:tasks])
    json_response(@collaboration, :accepted)
  end

  private

  def collaboration_params
    params.permit(:project_id, :user_id)
  end


  def set_collaboration
    @collaboration = Collaboration.find(params[:collaboration_id])
  end
end
