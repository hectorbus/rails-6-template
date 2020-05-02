require 'rails_helper'

RSpec.describe 'Passwords', type: :request do
  describe 'GET /password/new' do
    it 'returns a success response' do
      get new_user_password_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /password' do
    context 'with valid params' do
      it 'redirects to login page' do
        user = create(:user)
        user.confirm
        post user_password_path, params: {user: {email: user.email} }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'with invalid params' do
      it 'displays new password template' do
        post user_password_path, params: {user: {email: 'other_email@example.com'}}
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'GET /password/edit' do
    context 'with valid reset password token' do
      it 'returns a success response' do
        user = create(:user)
        user.confirm
        reset_password_token = user.send_reset_password_instructions
        get "#{edit_user_password_path}?reset_password_token=#{reset_password_token}"
        expect(response).to have_http_status(200)
      end
    end

    context 'with empty reset password token' do
      it 'redirects to login page' do
        get edit_user_password_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'with invalid reset password token' do
      it 'returns a success response (to display the edit template)' do
        get "#{edit_user_password_path}?reset_password_token=token"
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'PUT /password' do
    before(:example) do
      @user = build(:user)
      @user.confirm
    end

    context 'with valid params' do
      it 'redirects to login page' do
        reset_password_token = @user.send_reset_password_instructions
        put user_password_path, params:
            {user:
                 {reset_password_token: reset_password_token,
                  password: 'new_password',
                  password_confirmation: 'new_password'}}
        expect(response).to redirect_to(authenticated_root_path)
      end
    end

    context 'with invalid password' do
      it 'returns a success response (to display the :edit password template)' do
        reset_password_token = @user.send_reset_password_instructions
        put user_password_path, params:
            {user:
                 {reset_password_token: reset_password_token,
                  password: 'new',
                  password_confirmation: 'new'}}
        expect(response).to have_http_status(200)
      end
    end

    context 'with invalid password confirmation' do
      it 'returns a success response (to display the :edit template)' do
        reset_password_token = @user.send_reset_password_instructions
        put user_password_path, params:
            {user:
                 {reset_password_token: reset_password_token,
                  password: 'password',
                  password_confirmation: 'different_password'}}
        expect(response).to have_http_status(200)
      end
    end

    context 'with invalid token' do
      it 'returns a success response (to display the :edit template)' do
        put user_password_path, params:
            {user:
                 {reset_password_token: 'invalid token',
                  password: 'new',
                  password_confirmation: 'new'}}
        expect(response).to have_http_status(200)
      end
    end
  end
end
