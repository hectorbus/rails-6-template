require 'rails_helper'

RSpec.describe 'User requested', type: :request do
  let(:role){
    create(:role)
  }

  let (:user) {
    create(:user, role: role)
  }

  before(:example) do
    sign_in(user)
  end

  describe 'GET /users' do
    it 'returns a success response' do
      create(:permissions_role, role: role, permission: create(:permission, :users))
      get user_registrations_path
      expect(response).to have_http_status(200)
    end

  # Descomentar cuando esté listo el feature de implementación de policies
    it 'returns a not found response' do
      get user_registrations_path
      expect(response).to have_http_status(404)
    end
  end

end
