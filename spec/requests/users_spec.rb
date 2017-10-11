require 'rails_helper'

RSpec.describe 'User', type: :request do

  #let!(:users) { create_list(:user, 10) }
  let(:user) {FactoryGirl.create(:user)}
  let(:user_with_collaborations) {FactoryGirl.create(:user_with_5_collaborations)}
  let(:user_id) {user.id}
  let(:user_with_collaborations_id) {user_with_collaborations.id}

  describe 'GET /users/:id' do

    context 'when the user exists and has no collaborations' do
      before { get "/users/#{user_id}" }
      it 'returns the user' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(user_id)
      end

      it 'returns an empty collaborations field' do
        expect(json['collaborations'].size).to eq(0)
      end

      it 'returns status code 200 (ok)' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the user exists and has collaborations' do
      before { get "/users/#{user_with_collaborations_id}"}

      it 'returns the user and its collaborations' do
        byebug
        expect(json['id']).to eq(user_with_collaborations_id)
        expect(json['collaborations'].size).to eq(5)
        expect(json['collaborations'].first['points']).not_to be_nil #Sólo chequear el primero, no tiene sentido iterar para chequear que todos tengan la misma estructura
        expect(json['collaborations'].first['project_id']).not_to be_nil
      end
    end

    context 'when it does not exist' do
      before { get "/users/#{user_id}" }
      let(:user_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find [Uu]ser/)
      end
    end
  end

  describe 'POST /users' do
    let(:existingUser) { FactoryGirl.build(:user, zooniverseHandle: 'jondoe33') }

    context 'when the request is valid' do
      before { post "/users", params: {zooniverseHandle: 'jondoe22'}}

      it 'creates a user' do
        expect(json['zooniverseHandle']).to eq('jondoe22')
      end

      it 'returns status code 201 (created)' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/users', params: { points: 50 } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body).to match(/Validation failed: Zooniversehandle can't be blank/) #El campo real es 'zooniverseHandle', pero el coso de las excepciones lo devuelve así por alguna razón
      end
    end

  end
end
