require 'rails_helper'

RSpec.feature "Destroying Roles", type: :feature do
  let(:user) {
    role = create(:role, :admin)
    create(:user, role: role)
  }

  before(:example) do
    login(user.email, user.password)
  end

  scenario 'destroys role', js: true do
    role = create(:role)

    visit '/roles'

    expect  {
      find(".btn-outline-danger[data-resource-id='#{role.id}']").click
      within '.swal-modal' do
        find(:css, '.swal-button--confirm').click
      end
      wait_for_ajax
    }.to change(Role, :count).by(-1)
  end
end
