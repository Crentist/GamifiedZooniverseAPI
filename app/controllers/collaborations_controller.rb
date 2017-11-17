class CollaborationsController < ApplicationController
  before_action :set_collaboration, only: [:show, :update, :destroy]

  def index
    @collaborations = Collaboration.all
    json_response(@collaborations)
  end

  def show
    byebug
    json_response(@collaboration)
  end

  def create
    @collaboration = Collaboration.create!(collaboration_params)
    @collaboration.points = 0
    @collaboration.save!
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
    tasksValues = { "simpleQuestion" => 5, "drawing" => 10 } #Esto a un archivo de config
    @collaboration = Collaboration.find(params[:collaboration_id])
    params[:tasks].each { |tarea| @collaboration.points += tasksValues[tarea]}
    @collaboration.save!
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
