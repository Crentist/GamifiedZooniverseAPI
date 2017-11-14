require 'rails_helper'

RSpec.describe 'User', type: :request do

  let!(:user) {FactoryGirl.create(:user)}
  let!(:user_with_collaborations) {FactoryGirl.create(:user_with_5_collaborations)}
  let!(:user_id) {user.id}
  let!(:user_with_collaborations_id) {user_with_collaborations.id}
  let!(:user_with_2_owned_projects) {FactoryGirl.create(:user_with_2_owned_projects)}

  describe 'GET /users/:id' do

    context 'when the user exists and has no collaborations and no owned projects' do
      before { get "/users/#{user_id}" }
      it 'returns the user' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(user_id)
      end

      it 'returns an empty collaborations field' do
        expect(json['collaborations'].size).to eq(0)
      end

      it 'returns an empty owned projects field' do
        expect(json['owned_projects'].size).to eq(0)
      end

      it 'returns status code 200 (ok)' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the user exists and has collaborations' do
      before { get "/users/#{user_with_collaborations_id}"}

      it 'returns the user and its collaborations' do
        expect(json['id']).to eq(user_with_collaborations_id)
        expect(json['collaborations'].size).to eq(5)
        expect(json['collaborations'].first['points']).not_to be_nil #Sólo chequear el primero, no tiene sentido iterar para chequear que todos tengan la misma estructura
        expect(json['collaborations'].first['project_id']).not_to be_nil
      end
    end

    context 'when the user exists and owns a project' do
      before { get "/users/#{user_with_2_owned_projects.id}"}

      it "returns the user and his owned project/s" do
        #byebug
        expect(json['id']).to eq(user_with_2_owned_projects.id)
        expect(json['owned_projects'].size).to eq(2)
        expect(json['owned_projects'].first['name']).not_to be_nil
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

    context 'when the request is valid' do
      before { post "/users", params: {zooniverseHandle: 'jondoe22'}}

      it 'creates a user' do
        expect(json['zooniverseHandle']).to eq('jondoe22')
      end

      it 'returns status code 201 (created)' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the user already exists' do
      let!(:existingUser) { FactoryGirl.create(:user, zooniverseHandle: 'jondoe33') }
      before { post "/users", params: {zooniverseHandle: 'jondoe33'}}

      it "returns the existing user" do
        expect(json).not_to be_empty
        expect(json['id']).not_to be_nil
        expect(json['zooniverseHandle']).not_to be_nil
      end

    end

    context 'when the request is invalid' do
      before { post '/users', params: { points: 50 } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(json['message']).to match(/zooniverseHandle can't be blank/)
      end
    end

  end

  describe 'GET /users/:user_id/collaboration/:collaboration_id/collaboration' do
    let!(:project_id) {user_with_collaborations.collaborations.first.project.id}
    before { get "/users/#{user_with_collaborations_id}/collaboration/#{project_id}" }

    context "when a user collaborates in a project" do
      it "returns the appropriate collaboration" do
        expect(json).not_to be_empty
        byebug
      end
    end
  end
end
