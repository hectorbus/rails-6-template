module ControllerHelpers

  def login(email, password)
    visit unauthenticated_root_path
    fill_in t('helpers.email'), with: email
    fill_in t('helpers.password'), with: password
    click_button t('users.sessions.new.login')
  end

end
