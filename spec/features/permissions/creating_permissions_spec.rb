require 'rails_helper'

RSpec.feature "Creating Permissions", type: :feature do
  let(:user) {
    role = create(:role, :admin)
    create(:user, role: role)
  }

  before(:example) do
    login(user.email, user.password)
  end

  scenario 'Create permission', js: true do
    visit '/permissions/new'

    fill_in t('activerecord.attributes.permission.name'), with: 'Crear usuarios'
    fill_in t('activerecord.attributes.permission.description'), with: 'Permite crear usuarios'
    find(:select, 'permission_controller').find(:option, 'Permissions').select_option
    find(:select, 'permission_action').find(:option, 'index').select_option

    expect {
      click_button t('helpers.submit.submit', model: t('permissions.form.resource'))
    }.to change(Permission, :count).by(1)

    expect(page).to have_content('Crear usuarios')
  end

  scenario "Doesn't create permission", js: true do
    create(:permission)

    visit '/permissions/new'

    fill_in t('activerecord.attributes.permission.name'), with: 'Crear permiso'
    fill_in t('activerecord.attributes.permission.description'), with: 'Permite editar permiso'
    find(:select, 'permission_controller').find(:option, 'Permissions').select_option
    find(:select, 'permission_action').find(:option, 'index').select_option

    click_button t('helpers.submit.submit', model: t('permissions.form.resource'))

    expect(page).to have_content(t('errors.messages.taken'))
  end
end
