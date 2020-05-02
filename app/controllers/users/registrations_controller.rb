# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :set_user, only: [:show, :edit_user, :update_user, :destroy, :change_user_password, :save_user_password]
  before_action :set_current_user, only: [:edit, :update, :change_password, :save_password]

  add_breadcrumb proc { I18n.t('breadcrumbs.users') }, :user_registrations_path

  # GET /users
  def index
    @search_users = policy_scope(User).ransack(params[:q])
    @users = @search_users.result.paginate(page: params[:page], per_page: get_pagination).order('id DESC')
  end

  # GET /users/new_user
  def new_user
    add_breadcrumb I18n.t('helpers.new'), :new_user_path
    @user = User.new
  end

  # POST /users
  # POST /users.json
  def create_user
    @user = User.new(sign_up_params)
    @user.avatar = (params['missing.png'])
    respond_to do |format|
      if @user.save
        format.html { redirect_to user_registrations_path, notice: t('notifications_masc.success.resource.created',
                                                                     resource: t('users.registrations.new_user.resource')) }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new_user }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    add_breadcrumb @user.full_name, :user_path
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /users/edit
  def edit
    add_breadcrumb I18n.t('helpers.edit'), :edit_profile_path
    super
  end

  # PUT /users
  def update
    respond_to do |format|
      if @user.update_without_password(account_update_params)
        format.html { redirect_to edit_profile_path, notice: t('notifications_masc.success.resource.updated',
                                                                     resource: t('users.registrations.new_user.resource')) }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /users/1/edit
  def edit_user
    add_breadcrumb I18n.t('helpers.edit'), :edit_user_path
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update_user
    respond_to do |format|
      if @user.update(account_update_params)
        format.html { redirect_to user_registrations_path, notice: t('notifications_masc.success.resource.updated',
                                                                     resource: t('users.registrations.new_user.resource')) }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :edit_user }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def save_user_password
    respond_to do |format|
      if @user.update(account_update_params)
        format.html { redirect_to edit_user_path(@user), notice: t('notifications_fem.success.resource.updated',
                                                           resource: t('users.registrations.change_password.resource')) }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :change_user_password }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def change_password
    add_breadcrumb I18n.t('breadcrumbs.change_password'), :change_password_path
  end

  def save_password
    respond_to do |format|
      if @user.update_with_password(profile_update_params) #&& @user.without_auditing { @user.update(account_update_params) }
        bypass_sign_in(@user)
        format.html { redirect_to edit_profile_path, notice: t('notifications_fem.success.resource.updated',
                                                              resource: t('users.registrations.change_password.resource')) }
        format.json { head :no_content }
      else
        format.html { render :change_password }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users
  def destroy
    unless @user.eql? current_user
      @user.remove_avatar!
      @user.save
      @user.destroy
      respond_to do |format|
        format.html { redirect_to user_registrations_url }
        format.json { head :no_content }
      end
    end
  end

  #GET /users/:id
  def change_user_password
    add_breadcrumb I18n.t('breadcrumbs.change_password'), :change_user_password_path
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  def set_current_user
    @user = User.find(current_user.id)
  end

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name, :role_id, :avatar)
  end

  def account_update_params
    params.require(:user).permit(:email, :first_name, :last_name, :role_id, :password, :password_confirmation, :avatar)
  end

  def profile_update_params
    params.require(:user).permit(:email, :current_password, :password, :password_confirmation, :first_name, :last_name, :avatar)
  end

  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
