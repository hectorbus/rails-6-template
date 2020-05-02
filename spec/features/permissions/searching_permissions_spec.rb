require 'rails_helper'

RSpec.feature 'Searching Permissions', type: :feature do
  let(:user) {
    role = create(:role, :admin)
    create(:user, role: role)
  }

  before(:example) do
    login(user.email, user.password)
  end

  context 'having results' do
    scenario 'with accent', js: true do
      create(:permission, :with_accent)
      create(:permission, :without_accent)

      visit '/permissions'

      fill_in 'q_name_or_description_or_action_or_controller_cont', with: 'puntuación'
      find(:css, '.m-portlet__nav-link.btn.btn-brand.m-btn.m-btn--icon.m-btn--icon-only.m-btn--pill.rounded-circle').click

      expect(page).to have_content('puntuación')
      expect(page).to have_content('puntuacion')
    end

    scenario 'without accent', js: true do
      create(:permission)

      visit '/permissions'

      fill_in 'q_name_or_description_or_action_or_controller_cont', with: 'Crear permiso'
      find(:css, '.m-portlet__nav-link.btn.btn-brand.m-btn.m-btn--icon.m-btn--icon-only.m-btn--pill.rounded-circle').click

      expect(page).to have_content('Permite crear permiso')
    end
  end

  scenario 'not having results', js: true do
    create(:permission)

    visit '/permissions'

    fill_in 'q_name_or_description_or_action_or_controller_cont', with: 'Borrar'
    find(:css, '.m-portlet__nav-link.btn.btn-brand.m-btn.m-btn--icon.m-btn--icon-only.m-btn--pill.rounded-circle').click

    expect(page).to have_content(t('helpers.no_results', resource: 'Borrar'))
  end
end
