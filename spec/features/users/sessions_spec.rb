require 'rails_helper'

RSpec.feature 'Sessions', type: :feature do
  before(:example) do
    @user = create(:user)
  end

  scenario 'logs user in', js: true do
    visit '/'
    fill_in t('helpers.email'), with: @user.email
    fill_in t('helpers.password'), with: @user.password

    click_button t('users.sessions.new.login')

    expect(page).to have_current_path(authenticated_root_path)
  end

  scenario 'logs non existent user in', js: true do
    visit '/'
    fill_in t('helpers.email'), with: 'other_email@example.com'
    fill_in t('helpers.password'), with: 'password'

    click_button t('users.sessions.new.login')

    expect(page).to_not have_current_path(authenticated_root_path)
  end

  scenario 'logs unconfirmed user in', js: true do
    @user.update_column('confirmed_at', nil)

    visit '/'
    fill_in t('helpers.email'), with: @user.email
    fill_in t('helpers.password'), with: @user.password

    click_button t('users.sessions.new.login')

    expect(page).to_not have_current_path(authenticated_root_path)
  end

  scenario 'logs user in with invalid password', js: true do
    visit '/'
    fill_in t('helpers.email'), with: @user.email
    fill_in t('helpers.password'), with: 'invalid'

    click_button t('users.sessions.new.login')

    expect(page).to_not have_current_path(authenticated_root_path)
  end
end
