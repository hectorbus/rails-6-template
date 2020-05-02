require 'rails_helper'

RSpec.feature 'Destroying Permissions', type: :feature do
  let(:user) do
    role = create(:role, :admin)
    create(:user, role: role)
  end

  before(:example) do
    login(user.email, user.password)
  end

  scenario 'destroys permission', js: true do
    permission = create(:permission)

    visit '/permissions'

    expect do
      find(".btn-outline-danger[data-resource-id='#{permission.id}']").click
      within '.swal-modal' do
        find('.swal-button--confirm').click
      end
      wait_for_ajax
    end.to change(Permission, :count).by(-1)
  end
end
