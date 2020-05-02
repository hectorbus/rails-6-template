p '==> creating roles'

# Disable auditing
Role.auditing_enabled = false

# Delete all roles
Role.delete_all

# Reset sequence
ApplicationRecord.connection.reset_pk_sequence!('roles')


Role.create!([
  {name: 'Admin', key: 'admin', description: 'Rol super administrador.', scope: 'total'},
  {name: 'Default', key: 'default', description: 'Rol default del sistema.', scope: 'owner'}
])
