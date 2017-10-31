require 'rails_helper'

RSpec.describe 'Badge', type: :request do
  let(:badge) { FactoryGirl.create :badge, name: 'Primer colaboración', description: 'Lograste tu primer colaboración en el proyecto'}
  let(:badge_granted) { FactoryGirl.create :badge, name: 'Primer colaboración', description: 'Lograste tu primer colaboración en el proyecto'}

  describe 'GET /badges/:id' do


    context 'when the badge exists and hasnt been granted' do
      before { get "/badges/#{badge.id}" }
      it 'returns the badge' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(badge.id)
        expect(json['name']).to eq('Primer colaboración')
        expect(json['description']).to eq('Lograste tu primer colaboración en el proyecto')
        expect(json['collaborators'].size).to eq(0)
      end
    end

    context 'when the badge exists and has been granted three times in a project' do
      before { get "/badges/#{badge_granted.id}/project/#{project.id}" }
      it 'returns the badge' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(badge_granted.id)
        expect(json['name']).to eq('Primer colaboración')
        expect(json['description']).to eq('Lograste tu primer colaboración en el proyecto')
        expect(json['collaborators'].size).to eq(3)
      end
    end
  end

  #POSTear una badge. Generales. Con el criterio en un json
  ##Asignarle proyectos que pueden usarla
  ##Asignar una badge a un usuario de las diferentes formas posibles
end