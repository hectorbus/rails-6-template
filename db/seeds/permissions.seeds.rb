after :initialize_permissions do
  # Disable auditing
  Permission.auditing_enabled = false

  p '==> creating permissions'
  Permission.create!([
    {name: 'Mostrar bitácora detallada', description: 'Permite visualizar registros de bitácora detallada.', action: 'logbook_detail_table', controller: 'Audits' },
    {name: 'Mostrar bitácora en timeline', description: 'Permite visualizar registros de bitácora en timeline.', action: 'logbook_timeline', controller: 'Audits' },
    {name: 'Actualizar Permiso', description: 'Permite actualizar un permiso. ', action: 'update', controller: 'Permissions' },
    {name: 'Crear Permiso', description: 'Permite crear permisos.', action: 'create', controller: 'Permissions' },
    {name: 'Destruir Permiso', description: 'Permite destruir un permiso.', action: 'destroy', controller: 'Permissions' },
    {name: 'Editar Permiso', description: 'Permite visualizar la vista editar permiso.', action: 'edit', controller: 'Permissions' },
    {name: 'Generar Semillas', description: 'Permite generar las semillas de los permisos y sus relaciones.', action: 'generate_seeds', controller: 'Permissions' },
    {name: 'Mostrar Detalles De Un Permiso', description: 'Permite mostrar los detalles de un permiso.', action: 'show', controller: 'Permissions' },
    {name: 'Mostrar Listado De Permisos', description: 'Permite mostrar un listado de los permisos.', action: 'index', controller: 'Permissions' },
    {name: 'Nuevo Permiso', description: 'Permite visualizar la vista nuevo permiso.', action: 'new', controller: 'Permissions' },
    {name: 'Obtener Controladores Y Acciones', description: 'Permite obtener los controladores y acciones para generar los permisos.', action: 'get_controller_actions', controller: 'Permissions' },
    {name: 'Actualizar Rol', description: 'Permite actualizar un rol.', action: 'update', controller: 'Roles' },
    {name: 'Asignar O Desasignar Permisos A Un Rol', description: 'Permite asignar o desasingnar un permiso a un rol.', action: 'permission', controller: 'Roles' },
    {name: 'Crear Rol', description: 'Permite crear roles.', action: 'create', controller: 'Roles' },
    {name: 'Destruir Rol', description: 'Permite destruir un rol.', action: 'destroy', controller: 'Roles' },
    {name: 'Editar Rol', description: 'Permite visualizar la vista editar rol.', action: 'edit', controller: 'Roles' },
    {name: 'Mostrar Listado De Roles', description: 'Permite mostrar un listado de los roles.', action: 'index', controller: 'Roles' },
    {name: 'Mostrar Permisos Asignados A Un Rol', description: 'Permite visualizar la vista para asignar permisos a un rol.', action: 'permissions', controller: 'Roles' },
    {name: 'Nuevo Rol', description: 'Permite visualizar la vista nuevo rol.', action: 'new', controller: 'Roles' },
    {name: 'Actualizar Perfil de Usuario', description: 'Permite actualizar propio perfil.', action: 'update', controller: 'Users::Registrations' },
    {name: 'Actualizar Usuario', description: 'Permite actualizar un usuario.', action: 'update_user', controller: 'Users::Registrations' },
    {name: 'Cambiar Contraseña De Un Usuario', description: 'Permite visualizar la vista cambiar contraseña de un usuario.', action: 'change_user_password', controller: 'Users::Registrations' },
    {name: 'Cambiar Contraseña Propia', description: 'Permite visualizar la vista cambiar contraseña propia.', action: 'change_password', controller: 'Users::Registrations' },
    {name: 'Crear Usuario', description: 'Permite crear un usuario.', action: 'create_user', controller: 'Users::Registrations' },
    {name: 'Editar Perfil de Usuario', description: 'Permite visualizar editar propio perfil.', action: 'edit', controller: 'Users::Registrations' },
    {name: 'Editar Un Usuario', description: 'Permite visualizar la vista editar de un usuario.', action: 'edit_user', controller: 'Users::Registrations' },
    {name: 'Eliminar Usuario', description: 'Permite destruir un usuario.', action: 'destroy', controller: 'Users::Registrations' },
    {name: 'Guardar Contraseña De Un Usuario', description: 'Permite guardar la contraseña de un usuario.', action: 'save_user_password', controller: 'Users::Registrations' },
    {name: 'Guardar Contraseña Propia', description: 'Permite guardar la contraseña propia.', action: 'save_password', controller: 'Users::Registrations' },
    {name: 'Mostrar Listado De Usuarios', description: 'Permite mostrar un listado de los usuarios.', action: 'index', controller: 'Users::Registrations' },
    {name: 'Mostrar Perfil de Usuario', description: 'Permite mostrar el perfil de un usuario.', action: 'show', controller: 'Users::Registrations' },
    {name: 'Nuevo Usuario', description: 'Permite visualizar la vista nuevo usuario.', action: 'new_user', controller: 'Users::Registrations' },
  ])
end
