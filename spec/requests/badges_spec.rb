require 'rails_helper'

RSpec.describe 'Badge', type: :request do
  let(:badge) { FactoryGirl.create :badge, name: 'Primer proyecto', description: 'Lograste tu primer colaboración en tu primer proyecto!'}
  let(:generic_badge_granted) { FactoryGirl.create :generic_badge_granted, name: 'Primer proyecto', description: 'Lograste tu primer colaboración en tu primer proyecto!'}

  describe 'GET /badges/:id' do

    context 'when the badge exists and hasnt been granted' do
      before { get "/badges/#{badge.id}" }
      it 'returns the badge' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(badge.id)
        expect(json['name']).to eq('Primer proyecto')
        expect(json['description']).to eq('Lograste tu primer colaboración en tu primer proyecto!')
        expect(json['users'].size).to eq(0)
      end
    end

    context 'when the badge exists and has been granted three times' do
      before { get "/badges/#{generic_badge_granted.id}" }
      it 'returns the badge' do
        expect(json).not_to be_empty
        byebug
        expect(json['id']).to eq(generic_badge_granted.id)
        expect(json['name']).to eq('Primer proyecto')
        expect(json['description']).to eq('Lograste tu primer colaboración en tu primer proyecto!')
        expect(json['users'].size).to eq(3)
      end
    end
  end

  #POSTear una badge. Generales. Con el criterio en un json
  ##Asignarle proyectos que pueden usarla
  ##Asignar una badge a un usuario de las diferentes formas posibles
end