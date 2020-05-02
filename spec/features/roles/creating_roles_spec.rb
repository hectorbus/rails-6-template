require 'rails_helper'

RSpec.feature 'Creating Roles', type: :feature do
 let(:user) {
   role = create(:role, :admin)
   create(:user, role: role)
 }

 before(:example) do
   login(user.email, user.password)
 end

 scenario 'Create role', js: true do
   visit '/roles/new'

   fill_in t('activerecord.attributes.role.name'), with: 'Admin'
   fill_in t('activerecord.attributes.role.key'), with: 'admin'
   find(:css, '.dropdown').click
   find(:css, '.dropdown').find(:css, '.dropdown-menu.inner.show').find('span', text: 'Total').click
   fill_in t('activerecord.attributes.role.description'), with: 'Usuario Admin.'

   expect {
     click_button t('helpers.submit.submit', model: t('roles.form.resource'))
   }.to change(Role, :count).by(1)

   expect(page).to have_content('Admin')
 end

 scenario "Doesn't create role", js: true do
   create(:role)

   visit '/roles/new'

   fill_in t('activerecord.attributes.role.name'), with: 'Admin'
   fill_in t('activerecord.attributes.role.key'), with: 'admin'
   # find(:select, 'role_scope').find(:option, 'Total').select_option
   find(:css, '.dropdown').click
   find(:css, '.dropdown').find(:css, '.dropdown-menu.inner.show').find('span', text: 'Total').click
   fill_in t('activerecord.attributes.role.description'), with: 'Usuario Admin.'

   click_button t('helpers.submit.submit', model: t('roles.form.resource'))

   expect(page).to have_content(t('errors.messages.taken'))
 end

end
