require 'rails_helper'

RSpec.describe 'Project', type: :request do

  #let!(:project) { FactoryGirl.create :project, name: 'Recorriendo La Plata' }
  let!(:project) { FactoryGirl.create :project_with_5_collaborators, name: 'Recorriendo La Plata'}
  let(:project_id) {project.id}

  describe 'GET /projects/:id' do
    before { get "/projects/#{project_id}" }

    context 'when the project exists' do
      it 'returns the project' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(project_id)
        expect(json['name']).to eq('Recorriendo La Plata')
        collaborators = json['collaborators']
        expect(collaborators.size).to eq(5)
      end

      it 'collaborators should have id, zooniverseHandle and points' do
        collaborators = json['collaborators']
        expect(collaborators['id']).to exist
        expect(collaborators['zooniverseHandle']).to exist
        expect(collaborators['points']).to exist
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

  end
end