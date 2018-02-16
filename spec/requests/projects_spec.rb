require 'rails_helper'

RSpec.describe 'Project', type: :request do

  let(:owner) { FactoryGirl.create :owner, handle: 'Administratorrr'}
  let!(:project) { FactoryGirl.create :project_with_15_collaborations, name: 'Recorriendo La Plata', owner: owner}
  let(:project_id) {project.id}
  let(:collaborator) { FactoryGirl.create :collaborator, handle: 'Teste Ador'}
  let(:collaborator_id) {collaborator.id}
  let(:collaboration) { FactoryGirl.create(:collaboration, points: 0)}
  let(:collaboration_id) {collaboration.id}
  let(:collaboration_with_points) { FactoryGirl.create(:collaboration, points: 10, classification_count: 99, user: collaborator, project: project)}
  let(:collaboration_with_points_id) {collaboration_with_points.id}
  let!(:generic_badge) {FactoryGirl.create(:badge, name: "100 clasificaciones", description: "Alcanzaste las 100 clasificaciones!", criteria: JSON.generate({"classification_count"=>100}))}


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

      it 'collaborators should have id, handle and points' do
        collaborators = json['collaborators']
        firstCollaborator = collaborators.first
        expect(firstCollaborator['id']).not_to be_nil
        expect(firstCollaborator['handle']).not_to be_nil
        expect(firstCollaborator['points']).not_to be_nil
      end

      it 'returns its owner along with its data' do
        responseOwner = json['owner']
        expect(responseOwner['id']).to eq (owner.id)
        expect(responseOwner['handle']).to eq("Administratorrr")
      end

      it 'returns status code 200 (ok)' do
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
    context "when the request is valid" do
      before { post "/projects", params: {name: "Recorriendo Buenos Aires"} }

      it "creates and returns the project" do
        expect(json).not_to be_empty
        expect(json['id']).not_to eq(project_id)
        expect(json['name']).to eq("Recorriendo Buenos Aires")
        expect(json['collaborators']).to be_empty
      end

      it 'returns status code 201 (created)' do
        expect(response).to have_http_status(201)
      end
    end

    context "when the request is invalid (missing params)" do
      before { post "/projects", params: {} }

      it "returns a validation error" do
        expect(json['message']).to match(/Project name can't be blank/i) #La i indica que es case-insensitive
      end

      it "returns status code 422 (unprocessable entity)" do
        expect(response).to have_http_status(422)
      end
    end

    context "when the name of the project is taken" do
      before { post "/projects", params: {name: "Recorriendo La Plata", user_id: collaborator_id} }

      it "returns the existing project" do
        expect(json).not_to be_empty
        expect(json['id']).not_to be_nil
        expect(json['collaborators']).not_to be_nil
        expect(json['name']).to eq('Recorriendo La Plata')
      end

      it "returns status code 200 (ok)" do
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'POST /projects/:project_id/collaborations' do
    before { post "/projects/#{project_id}/collaborations", params: { user_id: collaborator_id, project_id: project_id}}

    context "when a project is updated adding a new collaboration" do
      it "creates and returns the collaboration" do
        expect(json).not_to be_empty
        expect(json['id']).not_to be_nil
        expect(json['user_id']).to eq(collaborator_id)
        expect(json['project_id']).to eq(project_id)
        expect(json['points']).to eq(0)
      end

      it "the model actually reflects the change" do
        updated_collaboration = Collaboration.find(json['id'])
        expect(updated_collaboration).not_to be_nil
      end

      it "returns status code 201 (created)" do
        expect(response).to have_http_status(201)
      end

    end

  end


  #Cambiar esto para que reciba un listado de tareas en lugar de los puntos directamente (por ej: {'tasks' : ['drawing', 'drawing', 'simpleQuestion']})
  describe 'POST /projects/:project_id/collaborations/:collaboration_id/increment' do
    before { post "/projects/#{project_id}/collaborations/#{collaboration_with_points_id}/increment", params: { tasks: ['drawing','drawing','simpleQuestion'] }}

    context "when updating a collaboration with a point value to increment" do
      it "increments the previous point value and returns the collaboration" do
        expect(json).not_to be_empty
        expect(json['id']).to eq(collaboration_with_points_id)
        expect(json['user_id']).to eq(collaborator_id)
        expect(json['project_id']).to eq(project_id)
        expect(json['points']).to eq(35)
      end

      it "the model actually reflects the change" do
        updated_collaboration = Collaboration.find(collaboration_with_points_id)
        expect(updated_collaboration.points).to eq(35)
      end

      it 'returns status code 202 (accepted)' do
        expect(response).to have_http_status(202)
      end
    end

    context "when meeting a badge criteria for 100 classifications" do
      it "issues the appropriate badge (100 overall classifications)" do
        updated_collaborator = User.find(collaborator_id)
        expect(updated_collaborator.badges.size).to eq(1)
        expect(updated_collaborator.has_badge(generic_badge.id)).to be true
      end
    end

    #Y posiblemente también hacer un request de usuario para que me devuelva la badge. Pero acá no iría

    #Y también para una badge específica al proyecto

  end

  describe 'PUT /projects/:project_id' do
    let(:projectWithNoOwner) { FactoryGirl.create :project, name: "I turned myself into a project, Morty!"}
    before { put "/projects/#{projectWithNoOwner.id}", params: { user_id: owner.id}}

    context "when a project is updated adding its owner" do
      it "adds the user as the project owner and returns the project" do
        expect(json['id']).to eq(projectWithNoOwner.id)
        responseOwner = json['owner']
        expect(responseOwner['id']).to eq (owner.id)
        expect(responseOwner['handle']).to eq("Administratorrr")
      end

      it "the model actually reflects the change" do
        updated_project = Project.find(projectWithNoOwner.id)
        expect(updated_project.owner.id).to eq(owner.id)
      end

      it "returns status code 202 (accepted)" do
        expect(response).to have_http_status(202)
      end
    end
  end

  #Agregar usuario como dueño de un proyecto (PUT?)
  #
end