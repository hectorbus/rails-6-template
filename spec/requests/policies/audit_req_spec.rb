require 'rails_helper'

RSpec.describe 'Audit requested', type: :request do
  let(:role){
    create(:role)
  }

  let (:user) {
    create(:user, role: role)
  }

  before(:example) do
    sign_in(user)
  end

  describe 'GET /logbook' do
    it 'returns a success response' do
      create(:permissions_role, role: role, permission: create(:permission, :logbooks))
      get logbook_timeline_path
      expect(response).to have_http_status(200)
    end

    it 'returns a not found response' do
      get logbook_timeline_path
      expect(response).to have_http_status(404)
    end
  end

end
