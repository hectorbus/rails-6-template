require 'rails_helper'

RSpec.feature 'Audit logbook_timeline', type: :feature do
  let(:user) {
    role = create(:role, :admin)
    create(:user, role: role)
  }

  let(:default) {
    role = create(:role)
    permission = create(:permission, :logbooks)
    create(:permissions_role, role: role, permission: permission)
    create(:user, :default, role: role)
  }

  let(:role) {
    create(:role)
  }

  scenario 'owner user can only see his records', js: true do
    login(default.email, default.password)

    visit '/logbook'

    expect(page).to have_css('.m-timeline-2__items', count: 1)
    expect(find('h5')).to have_content('Iniciaste sesión.')
  end

  scenario 'total user can see all records', js: true do
    login(user.email, user.password)

    visit '/logbook'

    expect(page).to have_css('.m-timeline-2__item.m--margin-top-30', count: 3)
    within '.m-timeline-2__item.m--margin-top-30', match: :first do
      expect(find('h5')).to have_content('Iniciaste sesión.')
    end
  end
end
