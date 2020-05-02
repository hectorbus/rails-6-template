require 'rails_helper'

RSpec.feature 'User unauthorized', type: :feature do
  let(:user) {
    role = create(:role)
    create(:user, :default, role: role)
  }

  before(:example) do
    login(user.email, user.password)
  end

  scenario 'redirected to not found page', js: true do
    visit '/users/'

    expect(page).to have_content("The page you were looking for doesn't exist.")
  end
end
