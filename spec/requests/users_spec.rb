require 'rails_helper'

RSpec.describe 'User', type: :request do

  let!(:users) { create_list(:user, 10) }
  let(:user_id) {users.first.id}
  let(:points) { 4 }
  let(:fauxParam) { Object.new }

  describe 'GET /users/:id' do
    before { get "/users/#{user_id}" }

    context 'when the it exists' do
      it 'returns the user' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(user_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when it does not exist' do
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
    let(:valid_attributes) { { zooniverseHandle: 'jondoe33'} }
    let(:existingUser) { FactoryGirl.build(:user, zooniverseHandle: 'jondoe33') }

    context 'when the request is valid' do
      before { post "/users", params: {zooniverseHandle: 'jondoe22'}}

      it 'creates a user' do
        expect(json['zooniverseHandle']).to eq('jondoe22')
      end

      it 'returns 201' do
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
