require 'rails_helper'

RSpec.feature 'Searching Roles', type: :feature do
  let(:user) {
    role = create(:role, :admin)
    create(:user, role: role)
  }

  before(:example) do
    login(user.email, user.password)
  end

  context 'having results' do
    scenario 'with accent', js: true do
      create(:role, :with_accent)
      create(:role, :without_accent)

      visit '/roles'

      fill_in 'name_or_key_cont_search', with: 'administración'
      find(:css, '.m-portlet__nav-link.btn.btn-brand.m-btn.m-btn--icon.m-btn--icon-only.m-btn--pill.rounded-circle').click

      expect(page).to have_content('administración')
      expect(page).to have_content('administracion')
    end

    scenario 'without accent', js: true do
      create(:role)

      visit '/roles'

      fill_in 'name_or_key_cont_search', with: 'admin'
      find(:css, '.m-portlet__nav-link.btn.btn-brand.m-btn.m-btn--icon.m-btn--icon-only.m-btn--pill.rounded-circle').click

      expect(page).to have_content('Super administrador del sistema.')
    end
  end

  scenario 'not having results', js: true do
    create(:role)

    visit '/roles'

    fill_in 'name_or_key_cont_search', with: 'admin'
    find(:css, '.m-portlet__nav-link.btn.btn-brand.m-btn.m-btn--icon.m-btn--icon-only.m-btn--pill.rounded-circle').click

    expect(page).to have_content(t('helpers.no_results', resource: 'admin'))
  end
end
