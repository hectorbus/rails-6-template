require 'rails_helper'

RSpec.feature 'Editing Roles', type: :feature do
  let(:user) {
    role = create(:role, :admin)
    create(:user, role: role)
  }

  before(:example) do
    login(user.email, user.password)
  end

  scenario 'edit role', js: true do
    role = create(:role)

    visit "/roles/#{role.id}/edit"

    fill_in t('activerecord.attributes.role.name'), with: 'Admin'

    click_button t('helpers.submit.submit', model: t('roles.form.resource'))

    expect(page).to have_content('Admin')
  end

  scenario "doesn't edit rol", js: true do
    create(:role)
    role = create(:role, name: 'Admin', description: 'Usuario Admin.', scope: 0, key: 'admin')

    visit "/roles/#{role.id}/edit"

    fill_in t('activerecord.attributes.role.key'), with: 'admin'

    click_button t('helpers.submit.submit', model: t('roles.form.resource'))

    expect(page).to have_content(t('errors.messages.taken'))
  end

end
