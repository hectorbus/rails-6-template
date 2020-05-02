# == Schema Information
#
# Table name: audits
#
#  id              :bigint           not null, primary key
#  action          :string
#  associated_type :string
#  auditable_name  :string
#  auditable_type  :string
#  audited_changes :text
#  comment         :string
#  remote_address  :string
#  request_uuid    :string
#  user_full_name  :string
#  user_role_key   :string
#  user_type       :string
#  username        :string
#  version         :integer          default(0)
#  created_at      :datetime
#  associated_id   :integer
#  auditable_id    :integer
#  user_id         :integer
#
# Indexes
#
#  associated_index              (associated_type,associated_id)
#  auditable_index               (auditable_type,auditable_id,version)
#  index_audits_on_created_at    (created_at)
#  index_audits_on_request_uuid  (request_uuid)
#  user_index                    (user_id,user_type)
#

class Audit < Audited::Audit
  define_model_callbacks :set_audit_user, only: [:after]

  before_create :set_permission_role_names, :set_auditable_name
  after_set_audit_user :set_audit_user_info

  attr_accessor :current_user

  def logbook_title
    render_partial_logbook('logbook_title')
  end

  def logbook_icon
    render_partial_logbook('icon_action')
  end

  def logbook_table
    render_partial_logbook('details_table')
  end

  def self.convert_to_json(logbooks, current_user)
    logbooks.each { |logbook| logbook.current_user = current_user }.
                          to_json(methods: [:logbook_title,
                                            :logbook_icon,
                                            :logbook_table,
                                            :logbook_date_created])
  end

  def logbook_date_created
    [I18n.l(self.created_at, format: :timeline), I18n.l(self.created_at, format: :timeline_day)]
  end

  private

  def render_partial_logbook(partial)
    user ||= current_user
    ApplicationController.renderer.render(partial: "audit/#{partial}",
      locals: { logbook: self, user: user })
  end

  def set_audit_user
    run_callbacks :set_audit_user do
      super
    end
  end

  def set_audit_user_info
    user = User.find_by(id: self.user_id)
    self.user_full_name = user&.full_name
    self.user_role_key = user&.role_key
  end

  def set_auditable_name
    self.auditable_name = self.audited_changes['name']&.last if self.action.eql? 'update'
    self.auditable_name = self.auditable_name || case self.auditable_type
    when 'User'
      User.find_by(id: self.auditable_id)&.full_name
    when 'PermissionsRole'
      Role.find_by(id: self.audited_changes['role_id'])&.name
    else
      self.auditable_type.constantize.find_by(id: self.auditable_id).try(:name)
    end
  end

  def set_permission_role_names
    if self.auditable_type.eql? 'PermissionsRole'
      role_name = Role.find_by(id: self.audited_changes['role_id'])&.name
      permission_name = Permission.find_by(id: self.audited_changes['permission_id'])&.name

      self.audited_changes.merge!({'role_name' => role_name, 'permission_name' => permission_name})
    end
  end
end
