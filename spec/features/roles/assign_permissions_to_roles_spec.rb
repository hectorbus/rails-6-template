require 'rails_helper'

RSpec.feature 'Assign Permissions to Roles', type: :feature do
  let(:user) {
    role = create(:role, :admin)
    create(:user, role: role)
  }
  let(:role) { create(:role) }

  before(:example) do
    login(user.email, user.password)
  end

  scenario 'assign permission to role', js: true do
    create(:permission)
    visit "/roles/#{role.id}/permissions"

    checkbox = first(:css, '.switch-input', visible: false)
    find(:css, '.m-switch').click
    wait_for_ajax
    expect(checkbox).to be_checked
  end

  scenario 'remove permission from role', js: true do
    create(:permission)
    visit "/roles/#{role.id}/permissions"

    checkbox = first(:css, '.switch-input', visible: false)
    find(:css, '.m-switch').click
    wait_for_ajax

    find(:css, '.m-switch').click
    wait_for_ajax
    expect(checkbox).not_to be_checked
  end
end
