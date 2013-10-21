# in progress
Gem::Specification.new do |s|
  s.name        = 'spdeck-scrape'
  s.executables << 'spdeck-scrape'
  s.version     = '0.0.62'
  s.date        = '2013-10-11'
  s.summary     = "Simple scraper for SpeakerDeck"
  s.description = "Generate data organized by viewcount for a database or webpages about presentations posted on SpeakerDeck (SpeakerDeck.com)"
  s.author      = "Joe O'Conor"
  s.email       = 'joe.oconor@gmail.com'
  s.files       = `git ls-files`.split("\n")
  s.homepage    =
    'http://rubygems.org/gems/spdeck-scrape'
  s.license       = 'MIT'
  s.require_path = 'lib'
  s.add_runtime_dependency 'nokogiri', ['>= 1.6.0']
  s.post_install_message = <<-JNO
  You have installed spdeck-scrape! See the README at https://github.com/jnoconor/spdeck-scrape for more information.
  JNO
end
