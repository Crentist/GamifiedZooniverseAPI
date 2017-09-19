require 'rails_helper'

RSpec.describe User, type: :model do

  it { should validate_presence_of(:zooniverseHandle) }

  describe 'GET /user/:id' do
    before { get "/user/#{user_id}" }

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
        expect(response.body).to match(/Couldn't find user/)
      end
    end
  end

  describe 'POST /user' do
    let(:valid_attributes) { { zooniverseHandle: 'jondoe33'} }
    let(:existingUser) { FactoryGirl.build(:user, zooniverseHandle: 'jondoe33') }

    context 'when the request is valid' do
      before { post "/user", params: {zooniverseHandle: 'jondoe22'}}

      it 'creates a user' do
        expect(json['zooniverseHandle']).to eq('jondoe33')
      end

      it 'returns 201' do
        expect(response).to have_http_status(201)
      end
    end
  end

end
