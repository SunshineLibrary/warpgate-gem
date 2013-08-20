Gem::Specification.new do |s|
    s.name        = 'warpgate'
    s.version     = '0.1.0'
    s.date        = '2013-08-20'
    s.summary     = "Warpgate"
    s.description = "A ruby dispatcher for warpgate job processing service"
    s.authors     = ["Sunshine Library"]
    s.email       = 'dev-ft@sunshine-library.org'
    s.platform    = Gem::Platform::RUBY
    s.required_ruby_version     = ">= 1.9"
    s.required_rubygems_version = ">= 1.3.6"

    s.files        = Dir.glob("lib/**/*")
    s.require_path = 'lib'

    s.homepage    = 'https://github.com/SunshineLibrary/warpgate-gem'
    s.license     = 'MIT'

    s.add_dependency("bunny", ["~> 0.10.2"])
end
