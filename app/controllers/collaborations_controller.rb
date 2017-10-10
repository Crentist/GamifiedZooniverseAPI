class CollaborationsController < ApplicationController
  before_action :set_collaboration, only: [:show, :update, :destroy, :increment]

  # GET /todos/:todo_id/items
  def index
    @collaborations = Collaboration.all
    json_response(@collaborations)
  end

  # GET /todos/:todo_id/items/:id
  def show
    json_response(@collaboration)
  end

  # POST /todos/:todo_id/items
  def create
    @collaboration = Collaboration.create!(collaboration_params)
    json_response(@collaboration, :created)
  end

  # PUT /todos/:todo_id/items/:id
  def update
    @collaboration.update(item_params)
    head :no_content
  end

  # DELETE /todos/:todo_id/items/:id
  def destroy
    @collaboration.destroy
    head :no_content
  end

  def increment
    #byebug
    @collaboration.points += update_points_params[:value].to_i
    @collaboration.save!
    json_response(@collaboration, :accepted)
  end

  private

  def collaboration_params
    params.permit(:project_id, :user_id, :points)
  end

  def update_points_params
    params.permit(:value)
  end

  def set_collaboration
    @collaboration = Collaboration.find(params[:collaboration_id])
  end
end
