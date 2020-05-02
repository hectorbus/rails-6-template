require 'rails_helper'

RSpec.feature 'Users index', type: :feature do
  let(:user) {
    role = create(:role, :admin)
    create(:user, role: role)
  }

  let(:role){
    create(:role)
  }

  before(:example) do
    login(user.email, user.password)
  end

  # Descomentar cuando esté listo el feature de implementación de policies
  scenario 'current user not in users list', js: true do
    create(:user, :default, role: role)

    visit '/users/'

    expect(find('table')).to have_no_content('admin@example.com')
  end

  scenario 'owner user can only see same role users', js: true do
    permission = create(:permission, :users)
    user_default = create(:user, :default, role: role)
    create(:user, :default2, role: role)
    create(:permissions_role, role: role, permission: permission)

    logout(:user)
    login(user_default.email, user_default.password)

    visit '/users/'

    expect(find('table')).to have_content('default2@example.com')
    expect(find('table')).to have_no_content('admin@example.com')
  end
end
