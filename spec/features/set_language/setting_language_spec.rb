require 'rails_helper'

RSpec.feature 'Changing language', type: :feature do
  let(:user) {
    role = create(:role, :admin)
    create(:user, role: role)
  }

  before(:example) do
    login(user.email, user.password)
  end

  scenario 'Change language to english', js: true do
    page.driver.browser.manage.window.resize_to(1500, 500)
    visit '/set_language/english'

    find(:css, '#icon-set-language').click
    find(:css, '.m-dropdown__wrapper').find(:css, '.m-dropdown__inner').find(:css, '.m-dropdown__body').find(:css, '.m-nav__link').click

    expect(page).to have_content('Usuarios')
  end

  scenario 'Change language to spanish', js: true do
    visit '/set_language/spanish'

    find(:css, '#icon-set-language').click
    find(:css, '.m-dropdown__wrapper').find(:css, '.m-dropdown__inner').find(:css, '.m-dropdown__body').find(:css, '.m-nav__link').click

    expect(page).to have_content('Users')
  end
end
