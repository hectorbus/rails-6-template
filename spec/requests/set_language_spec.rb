require 'rails_helper'

RSpec.describe 'SetLanguage', type: :request do

  describe 'GET /set_language/english' do
    it 'redirects to back' do
      get set_language_english_path
      expect(response).to have_http_status(302)
    end
  end

  describe 'GET /set_language/spanish' do
    it 'redirects to back' do
      get set_language_spanish_path
      expect(response).to have_http_status(302)
    end
  end
end
