require 'rails_helper'

RSpec.describe 'Project', type: :request do

  let!(:project) { FactoryGirl.create :project_with_15_collaborations, name: 'Recorriendo La Plata'}
  let(:project_id) {project.id}
  let(:collaborator) { FactoryGirl.create :collaborator, zooniverseHandle: 'Teste Ador'}
  let(:collaborator_id) {collaborator.id}
  let(:collaboration) { FactoryGirl.create(:collaboration, points: 0)}
  let(:collaboration_id) {collaboration.id}
  let(:collaboration_with_points) { FactoryGirl.create(:collaboration, points: 10, user: collaborator, project: project)}
  let(:collaboration_with_points_id) {collaboration_with_points.id}

  describe 'GET /projects/:id' do
    before { get "/projects/#{project_id}" }

    context 'when the project exists' do
      it 'returns the project along with its collaborators' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(project_id)
        expect(json['name']).to eq('Recorriendo La Plata')
        collaborators = json['collaborators']
        expect(collaborators.size).to eq(15)
      end

      it 'collaborators should have id, zooniverseHandle and points' do
        collaborators = json['collaborators']
        firstCollaborator = collaborators.first
        expect(firstCollaborator['id']).not_to be_nil
        expect(firstCollaborator['zooniverseHandle']).not_to be_nil
        expect(firstCollaborator['points']).not_to be_nil
      end

      it 'returns status code 200 (ok)' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the project does not exist' do
      let(:project_id) {333}

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end

  end

  describe 'POST /projects' do
    before { post "/projects", params: {name: "Recorriendo La Plata"} }

    context "when the request is valid" do
      it "creates and returns the project" do
        expect(json).not_to be_empty
        expect(json['id']).not_to eq(1) #Porque es el id del proyecto que ya existe que se crea al principio del test
        expect(json['name']).to eq("Recorriendo La Plata")
        expect(json['collaborators']).to be_empty
      end

      it 'returns status code 201 (created)' do
        expect(response).to have_http_status(201)
      end
    end

    context "when the request is invalid (wrong param name)" do
      it "returns status code 422 (unprocessable entity)" do
        post "/projects", params: {nombre: "Recorriendo La Plata"}
        expect(response).to have_http_status(422)
      end
    end
  end

  describe 'POST /projects/:project_id/collaborations' do
    before { post "/projects/#{project_id}/collaborations", params: { user_id: collaborator_id, project_id: project_id, points: 0 }}

    context "when a project is updated adding a new collaboration" do
      it "creates and returns the collaboration" do
        expect(json).not_to be_empty
        expect(json['id']).not_to be_nil
        expect(json['user_id']).to eq(collaborator_id)
        expect(json['project_id']).to eq(project_id)
        expect(json['points']).to eq(0)
      end

      it "returns status code 201 (created)" do
        expect(response).to have_http_status(201)
      end

    end
  end

  describe 'POST /projects/:project_id/collaborations/:collaboration_id/increment' do
    before { post "/projects/#{project_id}/collaborations/#{collaboration_with_points_id}/increment", params: { value: 10 }}

    context "when updating a collaboration with a point value to increment" do
      it "increments the previous point value and returns the collaboration" do
        expect(json).not_to be_empty
        expect(json['id']).to eq(collaboration_with_points_id)
        expect(json['user_id']).to eq(collaborator_id)
        expect(json['project_id']).to eq(project_id)
        expect(json['points']).to eq(20)
      end

      it "the model actually reflects the change" do
        updated_collaboration = Collaboration.find(collaboration_with_points_id)
        expect(updated_collaboration.points).to eq(20)
      end

      it 'returns status code 202 (accepted)' do
        expect(response).to have_http_status(202)
      end
    end
  end
end