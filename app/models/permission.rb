# == Schema Information
#
# Table name: permissions
#
#  id          :bigint           not null, primary key
#  action      :string
#  controller  :string
#  description :string
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Permission < ApplicationRecord

  has_many :permissions_roles
  has_many :roles, through: :permissions_roles, dependent: :destroy

  audited except: [:created_at, :updated_at]
  has_associated_audits

  validates_presence_of :name, :description, :action, :controller
  validates_uniqueness_of :name, :description
  validates :action, uniqueness: { scope: :controller }

  ransacker :name, type: :string do
    Arel.sql("unaccent(\"name\")")
  end

  ransacker :action, type: :string do
    Arel.sql("unaccent(\"action\")")
  end

  ransacker :controller, type: :string do
    Arel.sql("unaccent(\"controller\")")
  end

  def self.print_permissions_seeds
    string = "after :initialize_permissions do\n"
    string += "  # Disable auditing\n  Permission.auditing_enabled = false\n\n"
    string += "  p '==> creating permissions'\n  Permission.create!([\n"
    permissions = Permission.order('permissions.controller, permissions.name')
    file_root = "#{Rails.root}/db/seeds/permissions.seeds.rb"

    permissions.each do |permission|
      string += "    {name: '#{permission.name}', description: '#{permission.description}', action: '#{permission.action}', controller: '#{permission.controller}' },\n"
    end
    string += "  ])\nend\n"

    File.open(file_root, 'w') { |file| file.puts string }
    self.print_roles_permissions_seeds
  end

  def self.print_roles_permissions_seeds
    string = "after :permissions do\n"
    string += "  # Disable auditing\n  PermissionsRole.auditing_enabled = false\n\n"
    string += "  p '==> creating permissions_roles'\n  PermissionsRole.create!([\n"
    permissions_roles = PermissionsRole.joins(:permission, :role).order('roles.id, permissions.controller, permissions.name')
    file_name = "#{Rails.root}/db/seeds/roles_permissions.seeds.rb"

    permissions_roles.each do |permissions_role|
      string += "    {role_id: Role.find_by_key('#{permissions_role.role_key}').id, permission_id: Permission.find_by_name('#{permissions_role.permission_name}').id},\n"
    end
    string += "  ])\nend\n"

    File.open(file_name, 'w') { |file| file.puts string }
  end

end
