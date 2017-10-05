require 'rails_helper'

RSpec.describe 'Project', type: :request do

  #let!(:project) { FactoryGirl.create :project, name: 'Recorriendo La Plata' }
  let!(:project) { FactoryGirl.create :project_with_15_collaborations, name: 'Recorriendo La Plata'}
  let(:project_id) {project.id}


  describe 'GET /projects/:id' do
    before { get "/projects/#{project_id}" }

    context 'when the project exists' do
      it 'returns the project' do
        expect(json).not_to be_empty
        #byebug
        expect(json['id']).to eq(project_id)
        expect(json['name']).to eq('Recorriendo La Plata')
        collaborators = json['users']
        expect(collaborators.size).to eq(15)
      end

      it 'collaborators should have id, zooniverseHandle and points' do
        collaborators = json['users']
        byebug
        firstCollaborator = collaborators.first
        expect(firstCollaborator['id']).not_to be_nil
        expect(firstCollaborator['zooniverseHandle']).not_to be_nil
        expect(firstCollaborator['points']).not_to be_nil
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

  end
end