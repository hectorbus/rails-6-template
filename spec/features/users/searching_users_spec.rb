require 'rails_helper'

RSpec.feature 'Searching Users', type: :feature do
  let(:user) {
    role = create(:role, :admin)
    create(:user, role: role)
  }

  before(:example) do
    login(user.email, user.password)
  end

  context 'having results' do
    scenario 'with accent', js: true do
      role = create(:role)
      create(:user, :with_accent, email: 'user1@email.com', role: role)
      create(:user, :without_accent, email: 'user2@example.com', role: role)

      visit '/users'

      fill_in 'q_email_or_first_name_or_last_name_cont', with: 'Raúl'
      find(:css, '#searchInUsers').click

      expect(page).to have_content('Raúl')
      expect(page).to have_content('Raul')
    end

    scenario 'without accent', js: true do
      visit '/users'

      fill_in 'q_email_or_first_name_or_last_name_cont', with: user.email
      find(:css, '#searchInUsers').click

      expect(page).to have_content(user.email)
    end
  end

  scenario 'not having results', js: true do
    visit '/users'

    fill_in 'q_email_or_first_name_or_last_name_cont', with: 'Another User'
    find(:css, '#searchInUsers').click

    expect(page).to have_content(t('helpers.no_results', resource: 'Another User'))
  end
end
