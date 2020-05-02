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

FactoryBot.define do
  factory :permissions_role do
    role
    permission
  end
end
