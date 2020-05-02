require 'rails_helper'

RSpec.feature 'Editing Permissions', type: :feature do
  let(:user) {
    role = create(:role, :admin)
    create(:user, role: role)
  }

  before(:example) do
    login(user.email, user.password)
  end

  scenario 'edit permission', js: true do
    permission = create(:permission)

    visit "/permissions/#{permission.id}/edit"

    fill_in t('activerecord.attributes.permission.name'), with: 'Editar permiso'

    click_button t('helpers.submit.submit', model: t('permissions.form.resource'))

    expect(page).to have_content('Editar permiso')
  end

  scenario "doesn't edit permission", js: true do
    create(:permission)
    permission = create(:permission, name: 'Editar permiso', description: 'Permite editar permiso', action: 'edit')

    visit "/permissions/#{permission.id}/edit"

    fill_in t('activerecord.attributes.permission.name'), with: 'Crear permiso'

    click_button t('helpers.submit.submit', model: t('permissions.form.resource'))

    expect(page).to have_content('Ya ha sido tomado')
  end
end
