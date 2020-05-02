class AuditsController < ApplicationController

  def logbook_timeline
    add_breadcrumb t('breadcrumbs.timeline'), :logbook_timeline_path
    @logbooks = policy_scope(Audit).paginate(page: params[:page], per_page: 20).order(created_at: :desc)
    @last_page = @logbooks.total_pages
    @logbooks_json = Audit.convert_to_json(@logbooks, current_user)
    render 'audit/logbook_index'
  end

  def logbook_detail_table
    add_breadcrumb t('breadcrumbs.detailed'), :logbook_detail_table_path
    @search_logbooks =  policy_scope(Audit).ransack(params[:q])
    @logbooks = @search_logbooks.result.paginate(page: params[:page], per_page: get_pagination).order('created_at desc')
    render 'audit/logbook_detail_table'
  end

  def get_more_logbooks
    logbooks = policy_scope(Audit).paginate(page: params[:page], per_page: 20).order(created_at: :desc)
    logbooks_json = Audit.convert_to_json(logbooks, current_user)
    render json: {logbooks: logbooks_json, last_page: logbooks.total_pages}
  end
end
