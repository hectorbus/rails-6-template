after :permissions, :roles do
  # Disable auditing
  PermissionsRole.auditing_enabled = false

  p '==> creating permissions_roles'
  PermissionsRole.create!([
    {role_id: Role.find_by_key('default').id, permission_id: Permission.find_by_name('Mostrar bitácora detallada').id},
    {role_id: Role.find_by_key('default').id, permission_id: Permission.find_by_name('Mostrar bitácora en timeline').id},
    {role_id: Role.find_by_key('default').id, permission_id: Permission.find_by_name('Actualizar Perfil de Usuario').id},
    {role_id: Role.find_by_key('default').id, permission_id: Permission.find_by_name('Cambiar Contraseña Propia').id},
    {role_id: Role.find_by_key('default').id, permission_id: Permission.find_by_name('Editar Perfil de Usuario').id},
    {role_id: Role.find_by_key('default').id, permission_id: Permission.find_by_name('Guardar Contraseña Propia').id},
  ])
end
