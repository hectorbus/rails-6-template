require "rails_helper"

RSpec.describe SetLanguageController, type: :routing do
  describe 'routing' do
    it 'routes to #spanish' do
      expect(get: '/set_language/spanish').to route_to('set_language#spanish')
    end

    it 'routes to #english' do
      expect(get: '/set_language/english').to route_to('set_language#english')
    end
  end
end
