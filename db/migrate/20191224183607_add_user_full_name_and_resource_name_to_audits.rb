class AddUserFullNameAndResourceNameToAudits < ActiveRecord::Migration[6.0]
  def change
    add_column :audits, :user_full_name, :string
    add_column :audits, :auditable_name, :string
    add_column :audits, :user_role_key, :string
  end
end
