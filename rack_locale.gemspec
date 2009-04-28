Gem::Specification.new do |s|
  s.name = 'rack_locale'
  s.version = '0.0.1'
  s.summary = %{Better i18n for your Rack apps.}
  s.description = %{Better i18n for your Rack apps. Uses the same translation backend as Rails.}
  s.rubyforge_project = "rack_i18n"
  s.date = %q{2009-04-28}
  s.author = "Norman Clarke"
  s.email = "norman@rubysouth.com"
  s.homepage = "http://github.com/rubysouth/rack-locale"
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.files = ["lib/rack_locale.rb", "README.rdoc", "LICENSE", "Rakefile", "test/rack_locale_test.rb"]
  s.require_paths = ['lib']
  s.has_rdoc = true
end