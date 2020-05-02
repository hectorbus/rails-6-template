require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  before(:example) do
    @user = create(:user)
  end

  describe 'GET /sign_in' do
    it 'returns a success response' do
      get new_user_session_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /sign_in' do
    context 'with existent user params' do
      context 'a confirmed user' do
        it 'signs user in' do
          sign_in @user
          get authenticated_root_path
          expect(controller.current_user).to eq(@user)
        end
      end

      context 'an unconfirmed user' do
        it 'doesn\'t sign user in' do
          @user.confirmed_at = nil
          sign_in @user
          get authenticated_root_path
          expect(response).to redirect_to(new_user_session_path)
        end
      end

      context 'with wrong password' do
        it 'doesn\'t sign user in' do
          post new_user_session_path, params: {user: {email: @user.email, password: 'wrong_password'}}
          expect(controller.current_user).to be_nil
        end
      end
    end

    context 'with unexistent user params' do
      it 'doesn\'t signs user in' do
        post new_user_session_path, params: {user: {email: 'some_email@example.com', password: 'password'}}
        expect(controller.current_user).to be_nil
      end
    end
  end

  describe 'DELETE /sign_out' do
    it 'signs user out' do
      sign_in @user

      sign_out @user
      get authenticated_root_path
      expect(controller.current_user).to be_nil
    end
  end
end
