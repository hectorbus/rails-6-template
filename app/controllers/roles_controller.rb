class RolesController < ApplicationController
  before_action :set_role, only: %i[edit update destroy permissions permission]

  add_breadcrumb proc { I18n.t('breadcrumbs.roles') }, :roles_path

  # GET /roles
  # GET /roles.json
  def index
    @search_roles = Role.ransack(params[:q])
    @roles = @search_roles.result.paginate(page: params[:page], per_page: get_pagination).order('name ASC')
  end

  # GET /roles/new
  def new
    add_breadcrumb I18n.t('helpers.new'), :new_role_path
    @role = Role.new
  end

  # GET /roles/1/edit
  def edit
    add_breadcrumb I18n.t('helpers.edit'), :edit_role_path
  end

  # POST /roles
  # POST /roles.json
  def create
    @role = Role.new(role_params)

    respond_to do |format|
      if @role.save
        format.html { redirect_to roles_url, notice: t('notifications_masc.success.resource.created',
                                                       resource: t('roles.form.resource')) }
        format.json { render :show, status: :created, location: @role }
      else
        format.html { render :new }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /roles/1
  # PATCH/PUT /roles/1.json
  def update
    respond_to do |format|
      if @role.update(role_params)
        format.html { redirect_to roles_url, notice: t('notifications_masc.success.resource.updated',
                                                       resource: t('roles.form.resource')) }
        format.json { render :show, status: :ok, location: @role }
      else
        format.html { render :edit }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /roles/1
  # DELETE /roles/1.json
  def destroy
    @role.destroy
    respond_to do |format|
      format.html { redirect_to roles_url, notice: t('notifications_masc.success.resource.destroyed',
                                                     resource: t('roles.form.resource')) }
      format.json { head :no_content }
    end
  end

  def permissions
    add_breadcrumb I18n.t('breadcrumbs.permissions_for', permission_name: @role.name), :role_permissions_path
    @permissions = Permission.order('controller').group_by { |t| t.controller }
  end

  def permission
    @permission = Permission.find_by(id: params[:permission_id])
    return render json: { status: :not_found }, status: 404 if @permission.nil?

    if @role.permission_ids.include?(@permission.id)
      @role.permissions.delete(@permission)
      status = :removed
    else
      @role.permissions << @permission
      status = :assigned
    end
    render json: { status: status, permission: @permission }
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_role
    @role = Role.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def role_params
    params.require(:role).permit(:name, :key, :description, :scope)
  end

end
