class PermissionsController < ApplicationController
  before_action :set_permission, only: %i[show edit update destroy]

  add_breadcrumb proc { I18n.t('breadcrumbs.permissions') }, :permissions_path

  # GET /permissions
  # GET /permissions.json
  def index
    @search_permissions = Permission.ransack(params[:q])
    @permissions = @search_permissions.result.paginate(page: params[:page], per_page: get_pagination).order('name ASC')
  end

  # GET /permissions/1
  # GET /permissions/1.json
  def show
  end

  # GET /permissions/new
  def new
    add_breadcrumb I18n.t('helpers.new'), :new_permission_path
    @permission = Permission.new
    @controllers = get_controllers
    @actions = []
  end

  # GET /permissions/1/edit
  def edit
    add_breadcrumb I18n.t('helpers.edit'), :edit_permission_path
    @controllers = get_controllers
    @actions = Controller.new(params[:resource]).actions
  end

  # POST /permissions
  # POST /permissions.json
  def create
    @permission = Permission.new(permission_params)

    respond_to do |format|
      if @permission.save
        format.html { redirect_to permissions_url, notice: t('notifications_masc.success.resource.created',
                                                             resource: t('permissions.form.resource')) }
        format.json { render :show, status: :created, location: @permission }
      else
        @controllers = get_controllers
        controller = params[:permission][:controller]&.split('Controller')&.first&.to_s
        @actions = Controller.new(controller).actions

        format.html { render :new }
        format.json { render json: @permission.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /permissions/1
  # PATCH/PUT /permissions/1.json
  def update
    respond_to do |format|
      if @permission.update(permission_params)
        format.html { redirect_to permissions_url, notice: t('notifications_masc.success.resource.updated',
                                                             resource: t('permissions.form.resource')) }
        format.json { render :show, status: :ok, location: @permission }
      else
        @controllers = get_controllers
        controller = params[:permission][:controller]&.split('Controller')&.first&.to_s
        @actions = Controller.new(controller).actions

        format.html { render :edit }
        format.json { render json: @permission.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /permissions/1
  # DELETE /permissions/1.json
  def destroy
    @permission.destroy
    respond_to do |format|
      format.html { redirect_to permissions_url, notice: t('notifications_masc.success.resource.destroyed',
                                                           resource: t('permissions.form.resource')) }
      format.json { head :no_content }
    end
  end

  def get_controller_actions
    @actions = Controller.new(params[:resource]).actions

    render json: @actions.map{|e| [e, e]}.to_json
  end

  def generate_seeds
    respond_to do |format|
      Permission.print_permissions_seeds
      format.json { render :index, status: :ok }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_permission
      @permission = Permission.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def permission_params
      params.require(:permission).permit(:name, :description, :action, :controller)
    end

    # Get a list of all application controllers.
    def get_controllers
      @controllers = Controller.all
    end

    class Controller
      attr_reader :name

      def initialize(name)
        @name = name
      end

      def actions
        return [] if name.nil? or name.blank?
        begin
          exceptions = %w()
          (name + 'Controller').constantize.instance_methods(false).sort.map { |action| action.to_s } - exceptions
        rescue
          return []
        end
      end

      def self.all
        generic_controllers = Dir[Rails.root.join('app/controllers/*_controller.rb')]
                                  .map { |path| (path.match(/(\w+)_controller.rb/); $1.capitalize).camelize }

        devise_controllers = Dir[Rails.root.join('app/controllers/users/*_controller.rb')]
                                 .map { |path| 'Users::' + (path.match(/(\w+)_controller.rb/); $1.capitalize).camelize }

        generic_controllers + devise_controllers - ['Application']
      end
    end
end
