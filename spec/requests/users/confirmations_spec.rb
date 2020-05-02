require 'rails_helper'

RSpec.describe 'Confirmations', type: :request do
  describe 'GET /confirmation/new' do
    it 'returns a success response' do
      get new_user_confirmation_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /confirmation' do
    context 'with valid user email' do
      it 'redirects to login page' do
        user = create(:user, confirmed_at: nil)
        post user_confirmation_path, params: {user: {email: user.email}}
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'with already confirmed user' do
      it 'returns a success response (to display the :new template)' do
        user = create(:user)
        user.confirm
        post user_confirmation_path, params: {user: {email: user.email}}
        expect(response).to have_http_status(200)
      end
    end

    context 'with non existent user email' do
      it 'returns a success response (to display the :new template)' do
        post user_confirmation_path,  params: {user: {email: 'non-existent@example.com'}}
        expect(response).to have_http_status(200)
      end
    end
  end
end
