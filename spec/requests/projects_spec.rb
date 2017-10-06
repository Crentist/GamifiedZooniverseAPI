require 'rails_helper'

RSpec.describe 'Project', type: :request do

  let!(:project) { FactoryGirl.create :project_with_15_collaborations, name: 'Recorriendo La Plata'}
  let(:project_id) {project.id}
  let(:collaboration) { FactoryGirl.create(:collaboration)}

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

      it 'returns status code 200' do
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
    before { post "/projects", params: {name: "Recorriendo La Plata"}}

    context "when the request is valid" do
      it "creates and returns the project" do
        expect(json).not_to be_empty
        expect(json['id']).not_to eq(1) #Porque es el id del proyecto que ya existe que se crea al principio del test
        expect(json['name']).to eq("Recorriendo La Plata")
        expect(json['collaborators']).to be_empty
      end
    end

    it 'returns status code 201 (created)' do
      expect(response).to have_http_status(201)
    end
  end

  describe 'PUT /projects/:project_id' do
    before { put "/projects/#{project_id}", params: {collaboration: :collaboration}}

    context "when a project is updated adding a new collaboration" do
      
    end
  end
end