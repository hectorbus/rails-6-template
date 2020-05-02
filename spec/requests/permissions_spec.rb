require 'rails_helper'

RSpec.describe 'Permissions', type: :request do
  let (:user) {
    role = create(:role, :admin)
    create(:user, role: role)
  }

  before(:example) do
    sign_in(user)
  end

  describe 'GET /permissions' do
    it 'returns a success response' do
      get permissions_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /permissions/new' do
    it 'returns a success response' do
      get new_permission_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /permissions/:id/edit' do
    it 'returns a success response' do
      permission = create(:permission)
      get edit_permission_path(permission)
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /permissions' do
    context 'with valid params' do
      it 'creates a new Permission' do
        expect {
          post permissions_path, params: { permission: attributes_for(:permission) }
        }.to change(Permission, :count).by(1)
      end

      it 'redirects to the created permission' do
        post permissions_path, params: { permission: attributes_for(:permission) }
        expect(response).to redirect_to(permissions_path)
      end
    end

    context 'with invalid params' do
      %w(name description controller action ).each do |attribute|
        it "doesn't create new permission with #{attribute} nil" do
          expect {
            eval("post permissions_path, params: { permission: attributes_for(:permission, #{attribute}: nil) }")
          }.to_not change(Permission, :count)
        end
      end
    end

    context 'with duplicated values' do
      before :each do
        create(:permission)
      end

      it "doesn't create new permission with duplicated name" do
        expect {
          post permissions_path, params: { permission: attributes_for(:permission, description: 'Permite editar usuarios', action: 'edit', controller: 'users/registrations') }
        }.to_not change(Permission, :count)
      end

      it "doesn't create new permission with duplicated description" do
        expect {
          post permissions_path, params: { permission: attributes_for(:permission, name: 'Crear usuarios', action: 'edit', controller: 'users/registrations') }
        }.to_not change(Permission, :count)
      end

      it "doesn't create new permission with duplicated combination of action and controller" do
        expect {
          post permissions_path, params: { permission: attributes_for(:permission, name: 'Crear usuarios', description: 'Permite editar usuarios') }
        }.to_not change(Permission, :count)
      end
    end
  end

  describe 'PUT /permissions' do
    before :example do
      @permission = create(:permission)
    end

    context 'with invalid params' do
      %w(name description controller action ).each do |attribute|
        it "doesn't create new permission with #{attribute} nil" do
          expect {
            eval("put permission_path(#{@permission.id}), params: { permission: attributes_for(:permission, #{attribute}: nil) }")
          }.to_not change(Permission, :count)
        end
      end
    end
  end

  describe 'DELETE /permissions' do
    before :example do
      @permission = create(:permission)
    end

    it 'destroys the requested permission' do
      expect {
        delete permission_path(@permission)
      }.to change(Permission, :count).by(-1)
    end

    it 'redirects to the permissions list' do
      delete permission_path(@permission.id)
      expect(response).to redirect_to(permissions_path)
    end
  end

  describe 'GET /permissions/get_controller_actions' do
    it 'get list of actions' do
      get get_controller_actions_path, params: { resource: 'Permission' }
      expect(JSON.parse(response.body).class).to eq(Array)
    end

    it 'returns a success response' do
      get get_controller_actions_path, params: { resource: 'Permission' }
      expect(response).to have_http_status(200)
    end
  end

end
