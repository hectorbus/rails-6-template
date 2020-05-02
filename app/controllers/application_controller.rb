class ApplicationController < ActionController::Base

  protect_from_forgery prepend: true, with: :exception

  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :authenticate_user!, :is_authorized, :set_locale

  # Checks whether a user can make a specific action on the system.
  def authorize_with(record, query = nil)
    query ||= params[:action].to_s
    @_pundit_policy_authorized = true

    if record.split('::').size > 1
      klass = ActiveSupport::Inflector.deconstantize(record).classify.constantize
      policy = policy(klass)
    else
      policy = policy(record.classify.constantize)
    end

    unless policy.public_send('general_policy', record, query)
      raise NotAuthorizedError.new(query: query, record: record, policy: policy)
    end

    true
  end

  def conditional_scope(user, scope, method, condition = nil, identifier = nil)
    policy = scope.to_s + 'Policy'
    policy.constantize::ConditionalScope.new(user, scope, condition, identifier).send(method)
  end

  private

  # Verifies the user permissions before performing an action.
  def is_authorized
    controller = ActiveSupport::Inflector.camelize(params[:controller])

    unless Rails.configuration.x.controller_exceptions.include? controller.split(':').last.singularize
      return true if current_user.admin?
      authorize_with controller, params[:action].to_s
    end
  end

  # If the user doesn't have permission to perform an action is redirected.
  def user_not_authorized
    return respond_with_404_page if request.get?
    respond_with_redirect
  end

  def respond_with_404_page
    respond_to do |format|
      format.html { render file: Rails.root.join('public', '404.html'), layout: false, status: 404 }
      format.json { render json: {message: I18n.t('pundit.default')}, status: 403 }
      format.js { render js: "toastr.warning('#{I18n.t('pundit.default')}')", status: 403 }
    end
  end

  def respond_with_redirect
    flash[:warning] = I18n.t('pundit.default')
    redirect_to(request.referrer || authenticated_root_path || unauthenticated_root_path)
  end

  def set_locale
    I18n.locale = session[:locale] || I18n.default_locale
    session[:locale] = I18n.locale
  end

  def get_pagination
    if params[:per_page]
      @per_page = params[:per_page].to_i > 500 ? 500 : params[:per_page]
    else
      @per_page = 25
    end
  end
end
