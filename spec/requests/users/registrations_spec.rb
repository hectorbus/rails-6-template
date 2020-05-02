require 'rails_helper'

RSpec.describe 'Registrations', type: :request do
  let (:user) {
    @role = create(:role, :admin)
    create(:user, role: @role)
  }

  before(:example) do
    sign_in(user)
  end

  describe 'GET /users' do
    it 'returns a success response' do
      get user_registrations_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /users/new_user' do
    it 'returns a success response' do
      get new_user_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /users' do
    context 'with valid parameters' do
      it 'creates a new user' do
        expect{post create_user_path, params: {user: attributes_for(:user, email: 'email@example.com').merge!(role_id: @role.id)}
        }.to change(User, :count).by(1)
      end

      it 'redirects to users list' do
        post create_user_path, params: {user: attributes_for(:user, email: 'email@example.com').merge!(role_id: @role.id)}
        expect(response).to redirect_to(user_registrations_path)
      end
    end

    context 'with invalid parameters' do
      it 'doesn\'t create a new user' do
        expect{post create_user_path, params: {user: attributes_for(:user, email: nil) }
        }.to_not change(User, :count)
      end

      it 'returns a success response (renders new template)' do
        post create_user_path, params: {user: attributes_for(:user, email: nil) }
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'GET /users/:id/edit' do
    it 'returns a success response' do
      get edit_user_path(user)
      expect(response).to have_http_status(200)
    end
  end

  describe 'PUT /users/:id' do
    before(:example) do
      @user = create(:user, email: 'email@example.com')
    end

    context 'with valid parameters' do
      it 'redirects to the users list ' do
        put update_user_path(@user.id), params: { user: { first_name: 'Samantha' } }
        expect(response).to redirect_to(user_registrations_path)
      end

      it 'attaches the uploaded file' do
        file = fixture_file_upload(Rails.root.join('spec', 'factories', 'images', 'user.png'), 'image/png')
        put update_user_path(@user.id), params: {user: { avatar: file }}
        expect(response).to redirect_to(user_registrations_path)
      end
    end

    context 'with invalid parameters' do
      it 'returns a success response (renders edit template)' do
        put update_user_path(@user.id), params: { user: { email: nil } }
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'GET /users/edit' do
    it 'returns a success response' do
      get edit_profile_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'PUT /users' do
    it 'redirects to the user profile' do
      put update_profile_path, params: { user: { email: 'email@example.com' } }
      expect(response).to redirect_to(edit_profile_path)
    end
  end

  describe 'GET /users/change_password' do
    it 'returns a success response' do
      get change_password_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'PUT /save_password' do
    it 'redirects to user profile' do
      put save_password_path, params: {
          user: { current_password: user.password,
                  password: 'newpassword',
                  password_confirmation: 'newpassword'}}
      expect(response).to redirect_to(edit_profile_path)
    end
  end

  describe 'DELETE /users/:id' do
    context 'user is current user' do
      it 'does not delete user' do
        expect{ delete destroy_user_registration_path(user.id)}.to_not change(User, :count)
      end
    end

    context 'user is not current user' do
      it 'deletes user' do
        user = create(:user, email: 'email@example.com')
        expect{ delete destroy_user_registration_path(user.id)}.to change(User, :count)
      end

      it 'redirects to the users list' do
        user = create(:user, email: 'email@example.com')
        delete destroy_user_registration_path(user.id)
        expect(response).to redirect_to(user_registrations_path)
      end
    end
  end

  describe 'GET /users/:id/change_user_password' do
    it 'returns a success response' do
      user = create(:user, :default, role: create(:role))
      get change_user_password_path(user)
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /users/:id/save_user_password' do
    it 'returns a success response' do
      user = create(:user, :default, role: create(:role))
      put save_user_password_path(user),  params: {
          user: { password: 'newpassword',
                  password_confirmation: 'newpassword'}}
      expect(response).to redirect_to(edit_user_path(user))
    end
  end
end
