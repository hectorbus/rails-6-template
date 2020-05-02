original_host = Rails.application.config.action_mailer.default_url_options[:host]
original_port = Rails.application.config.action_mailer.default_url_options[:port]

RSpec.shared_context 'default_url_options' do
  before do
    Rails.application.config.action_mailer.default_url_options[:host] = Capybara.current_session.server.host
    Rails.application.config.action_mailer.default_url_options[:port] = Capybara.current_session.server.port
  end

  after do
    Rails.application.config.action_mailer.default_url_options[:host] = original_host
    Rails.application.config.action_mailer.default_url_options[:port] = original_port
  end
end