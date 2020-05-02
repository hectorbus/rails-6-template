require 'rails_helper'

RSpec.feature 'Confirmations', type: :feature do
  before(:example) do
    @user = build(:user)
    visit '/'
    click_link 'm_login_signup'
  end

  scenario 'sends confirmation instructions email', js: true do
    @user.confirmed_at = nil
    @user.save

    fill_in t('helpers.email'), with: @user.email
    click_button t('helpers.send')

    expect(page).to have_content(t('devise.confirmations.send_instructions'))
  end

  scenario 'sends confirmation instructions email to already confirmed user', js: true do
    @user.save

    fill_in t('helpers.email'), with: @user.email
    click_button t('helpers.send')

    expect(page).to have_content(t('errors.messages.already_confirmed'))
  end

  scenario 'sends confirmation instructions to non registered user', js: true do
    fill_in t('helpers.email'), with: 'other_email@example.com'
    click_button t('helpers.send')

    expect(page).to have_content(t('errors.messages.not_found'))
  end
end
