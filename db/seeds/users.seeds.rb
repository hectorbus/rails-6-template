after :roles do
  p '==> creating users'

  # Disable auditing
  User.auditing_enabled = false

  # Delete all roles
  User.delete_all

  # Reset sequence
  ActiveRecord::Base.connection.reset_pk_sequence!('users')

  # Create users
  User.create(email: 'admin@example.com', password: 'password', first_name: 'Admin', last_name: 'System User',
              confirmed_at: Time.now, role_id: Role.find_by_key('admin').id)

  User.create(email: 'default@example.mx', password: 'password', first_name: 'Default', last_name: 'System User',
              confirmed_at: Time.now, role_id: Role.find_by_key('default').id)
end
