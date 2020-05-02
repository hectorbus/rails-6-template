require 'rails_helper'

RSpec.describe "Audits", type: :request do
  let (:user) {
    role = create(:role, :admin)
    create(:user, role: role)
  }

  before(:example) do
    sign_in(user)
  end

  describe 'GET /logbook' do
    it 'returns a success response' do
      get logbook_timeline_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /logbook/details' do
    it 'returns a success response' do
      get logbook_detail_table_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /logbooks' do
    it 'returns a success response' do
      get get_more_logbooks_path
      expect(response).to have_http_status(200)
    end

    it 'returns an Array of objects' do
      get get_more_logbooks_path
      expect(JSON.parse(JSON.parse(response.body)['logbooks']).class).to eq(Array)
    end
  end

end
