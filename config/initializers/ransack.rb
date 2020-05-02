Ransack.configure do |config|
  config.add_predicate 'cont',
      arel_predicate: 'matches',
      formatter: proc { |s| ActiveSupport::Inflector.transliterate("%#{s}%") },
      validator: proc { |s| s.present? },
      compounds: true,
      type: :string
end
