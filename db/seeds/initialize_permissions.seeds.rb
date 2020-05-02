p '==> initialize permissions'

# Delete all permissions_roles
PermissionsRole.delete_all

# Delete all permissions
Permission.delete_all

# Reset sequence
ApplicationRecord.connection.reset_pk_sequence!('permissions')
