require 'rails_helper'

RSpec.describe "Roles", type: :request do
  let (:user) {
    role = create(:role, :admin)
    create(:user, role: role)
  }

  before(:example) do
    sign_in(user)
  end

  describe 'GET /roles' do
    it 'returns a success response' do
      get roles_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /roles/new' do
    it 'returns a success response' do
      get new_role_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /roles/:id/edit' do
    it 'returns a success response' do
      role = create(:role)
      get edit_role_path(role)
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /roles' do
    context 'with valid params' do
      it 'creates a new Role' do
        expect {
          post roles_path, params: { role: attributes_for(:role) }
        }.to change(Role, :count).by(1)
      end

      it 'redirects to the created role' do
        post roles_path, params: { role: attributes_for(:role) }
        expect(response).to redirect_to(roles_path)
      end
    end

    context 'with invalid params' do
      %w(name description scope).each do |attribute|
        it "doesn't create new role with #{attribute} nil" do
          expect {
            eval("post roles_path, params: { role: attributes_for(:role, #{attribute}: nil) }")
          }.to_not change(Role, :count)
        end
      end
    end

    context 'with duplicated values' do
      it "doesn't create new role with duplicated key" do
        create(:role)
        expect {
          post roles_path, params: { role: attributes_for(:role, name: 'Admin', description: 'Administrador del sistema.', scope: 'total') }
        }.to_not change(Role, :count)
      end
    end
  end

  describe 'PUT /roles' do
    before :example do
      @role = create(:role)
    end

    context 'with invalid params' do
      %w(name description scope).each do |attribute|
        it "doesn't create new role with #{attribute} nil" do
          expect {
            eval("put role_path(#{@role.id}), params: { role: attributes_for(:role, #{attribute}: nil) }")
          }.to_not change(Role, :count)
        end
      end
    end
  end

  describe 'DELETE /roles' do
    before :example do
      @role = create(:role)
    end

    it 'destroys the requested role' do
      expect {
        delete role_path(@role)
      }.to change(Role, :count).by(-1)
    end

    it 'redirects to the roles list' do
      delete role_path(@role)
      expect(response).to redirect_to(roles_path)
    end
  end

  describe 'PUT /roles/:id/permission/:permission_id' do
    before :example do
      @role = create(:role)
      @permission = create(:permission)
    end

    it 'assign permission to role' do
      put role_permission_path(@role.id, @permission.id)

      expect(response).to have_http_status(200)
    end

    it 'has one permission assigned to role' do
      expect {
        put role_permission_path(@role.id, @permission.id)
      }.to change(@role.permissions, :count).by(1)
    end

    it 'remove permission from role' do
      put role_permission_path(@role.id, @permission.id)

      expect {
        put role_permission_path(@role.id, @permission.id)
      }.to change(@role.permissions, :count).by(-1)
    end

    it 'gets error not found' do
      put role_permission_path(@role.id, 500)

      expect(response).to have_http_status(404)
    end
  end
end
