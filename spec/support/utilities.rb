# Use internationalization with rspec
def t(*args)
  I18n.translate!(*args)
end
