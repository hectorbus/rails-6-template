require 'rails_helper'

RSpec.feature 'Passwords', type: :feature do
  before(:example) do
    @user = create(:user)
    visit '/'
    click_link 'm_login_forget_password'
  end

  scenario 'sends password reset instructions email', js: true do
    fill_in t('helpers.email'), with: @user.email
    click_button t('helpers.send')

    expect(page).to have_content(t('devise.passwords.send_instructions'))
  end

  scenario 'sends password reset instructions email to non registered user', js: true do
    fill_in t('helpers.email'), with: 'other_email@example.com'
    click_button t('helpers.send')

    expect(page).to have_content(t('errors.messages.not_found'))
  end

  scenario 'displays change password page', js: true do
    fill_in t('helpers.email'), with: @user.email
    click_button t('helpers.send')

    open_email(@user.email)
    current_email.click_link t'users.mailer.reset_password_instructions.change_password'

    expect(page).to have_current_path(/#{edit_user_password_path}*/)
  end

  scenario 'changes password', js: true do
    @user.update_attribute('confirmed_at', nil)
    fill_in t('helpers.email'), with: @user.email
    click_button t('helpers.send')

    open_email(@user.email)
    current_email.click_link t'users.mailer.reset_password_instructions.change_password'

    fill_in t('users.passwords.edit.new_password'), with: 'newpassword'
    fill_in t('users.passwords.edit.password_confirmation'), with: 'newpassword'

    click_button t('helpers.send')

    expect(page).to have_current_path(new_user_session_path)
  end

  scenario 'changes password with invalid password', js: true do
    fill_in t('helpers.email'), with: @user.email
    click_button t('helpers.send')

    open_email(@user.email)
    current_email.click_link t'users.mailer.reset_password_instructions.change_password'

    fill_in t('users.passwords.edit.new_password'), with: '1234'
    fill_in t('users.passwords.edit.password_confirmation'), with: '1234'

    click_button t('helpers.send')

    expect(page).to have_current_path(user_password_path)
  end
end
