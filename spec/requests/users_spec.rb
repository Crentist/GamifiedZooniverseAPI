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

  describe 'register a user at POST /register' do

    context 'when the request is valid' do
      before { 
        post "/register",
        params: {
          user: {
            handle: 'jondoe22',
            email: 'email@example.org',
            password: "somepass"
          }
        },
        as: :json
      }

      it 'creates a user' do
        expect(json['user']['handle']).to eq('jondoe22')
        expect(json['user']['token']).not_to be_nil
      end

      it 'returns status code 200 (ok)' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the request is invalid' do
      before { post '/register', params: { points: 50 }, as: :json }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(json["errors"]["handle"].first).to match(/handle can't be blank/)
        expect(json["errors"]["email"].first).to match(/can't be blank/)
        expect(json["errors"]["password"].first).to match(/can't be blank/)
      end
    end

  end

  describe 'GET /users/:user_id/collaboration/:collaboration_id/collaboration' do
    let!(:project_id) {user_with_collaborations.collaborations.first.project.id}
    let!(:collaboration_id) {user_with_collaborations.collaborations.first.id}
    before { get "/users/#{user_with_collaborations_id}/collaboration/#{project_id}" }

    context "when a user collaborates in a project" do
      it "returns the appropriate collaboration" do
        expect(json).not_to be_empty
        expect(json["id"]).to eq(collaboration_id)
      end
    end
  end

  describe 'link the user to a new site username' do

    context 'user exists and username hasnt been added for that site and params are valid' do
      before {
        post "/users/#{user_id}/site_username",
        params: {
          site: "zooniverse.org",
          username: "lukewarm"
        }
      }

      it 'adds the username and returns the users usernames sites' do
        # {
        #   "sites_usernames": {
        #     "zooniverse.org": [
        #       "lukewarm"
        #     ]
        #   }
        # }

        expect(json).not_to be_empty
        expect(json['sites_usernames']).not_to be_nil
        expect(json['sites_usernames']['zooniverse.org']).to include("lukewarm")
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'another username is added for an existing site' do
      let!(:user_with_sites_usernames) do 
        FactoryGirl.create(
          :user,
          sitesUsernames: 
          {
            'zooniverse.org' => ['lukewarm']
          }.to_s
        )
      end

      before {
        post "/users/#{user_with_sites_usernames.id}/site_username",
        params: {
          site: "zooniverse.org",
          username: "marineer"
        }
      }   

      it 'adds the username and returns the users usernames sites' do
        expect(json).not_to be_empty
        expect(json['sites_usernames']).not_to be_nil
        expect(json['sites_usernames']['zooniverse.org']).to include("lukewarm")
        expect(json['sites_usernames']['zooniverse.org']).to include("marineer")

      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end

    end

    context 'an existing username for a site is added' do
      let!(:user_with_sites_usernames) do 
        FactoryGirl.create(
          :user,
          sitesUsernames: 
          {
            'universe.org' => ['lukewarm']
          }.to_s
        )
      end

      before {
        post "/users/#{user_with_sites_usernames.id}/site_username",
        params: {
          site: "universe.org",
          username: "lukewarm"
        }
      }   

      it 'returns an error message' do
        expect(json).not_to be_empty
        expect(json['error']).to eq('El username ya existe para el sitio indicado')
      end

      it 'returns status code 422 (unprocessable entity)' do
        expect(response).to have_http_status(422)
      end 

    end    

    context 'another username is added for a different site' do
      let!(:user_with_sites_usernames) do 
        FactoryGirl.create(
          :user,
          sitesUsernames: 
          {
            'universe.org' => ['lukewarm']
          }.to_s
        )
      end

      before {
        post "/users/#{user_with_sites_usernames.id}/site_username",
        params: {
          site: "zooniverse.org",
          username: "marineer"
        }
      }   

      it 'adds the username and returns the users usernames sites' do
        expect(json).not_to be_empty
        expect(json['sites_usernames']).not_to be_nil
        expect(json['sites_usernames']['universe.org']).to include("lukewarm")
        expect(json['sites_usernames']['zooniverse.org']).to include("marineer")

      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end

    end  

    context 'a param is missing' do
      let!(:user_with_sites_usernames) do 
        FactoryGirl.create(
          :user,
          sitesUsernames: 
          {
            'universe.org' => ['lukewarm']
          }.to_s
        )
      end

      before {
        post "/users/#{user_with_sites_usernames.id}/site_username",
        params: {
          username: "marineer"
        }
      }   

      it 'returns an error message' do
        expect(json).not_to be_empty
        expect(json['error']).to eq('Nombre de sitio o username no presentes')
      end

      it 'returns status code 422 (unprocessable entity)' do
        expect(response).to have_http_status(422)
      end  
      
    end

    context 'get the users sites usernames' do
      let!(:user_with_sites_usernames) do 
        FactoryGirl.create(
          :user,
          sitesUsernames: 
          {
            'universe.org' => ['lukewarm'],
            'zooniverse.org' => ['marineer']
          }.to_s
        )
      end

      before {
        get "/users/#{user_with_sites_usernames.id}/sites_usernames"
      }   

      it 'returns the users usernames sites' do
        expect(json).not_to be_empty
        expect(json['sites_usernames']).not_to be_nil
        expect(json['sites_usernames']['universe.org']).to include("lukewarm")
        expect(json['sites_usernames']['zooniverse.org']).to include("marineer")
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end
end
