# == Schema Information
#
# Table name: permissions_roles
#
#  id            :bigint           not null, primary key
#  permission_id :bigint
#  role_id       :bigint
#
# Indexes
#
#  index_permissions_roles_on_permission_id  (permission_id)
#  index_permissions_roles_on_role_id        (role_id)
#
# Foreign Keys
#
#  fk_rails_...  (permission_id => permissions.id)
#  fk_rails_...  (role_id => roles.id)
#

class PermissionsRole < ApplicationRecord
  belongs_to :permission
  belongs_to :role

  audited associated_with: :role
  audited associated_with: :permission

  delegate :key, to: :role, prefix: true
  delegate :name, to: :permission, prefix: true

end
