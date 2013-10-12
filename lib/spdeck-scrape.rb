require_relative './spdeck-scrape/spdeck-scraper-class.rb'

# this file is loaded and run when 'spdeck-scrape' is required in a script

# test code

scraper = SpeakerdeckScraper.new("https://speakerdeck.com/", "ruby")
scraper.query_results_scrape(3)
scraper.scrape_all
File.open('spd-ruby-raw', 'w') do |file|
    file.write(scraper.presentations)
end


scraper.html_gen

scraper2 = SpeakerdeckScraper.new("https://speakerdeck.com/", "json")
scraper2.query_results_scrape(2)
scraper2.scrape_all
File.open('spd-json-raw', 'w') do |file|
    file.write(scraper.presentations)
end

scraper2.html_gen

system("open spd-ruby.html spd-json.html")

# initialize a scraper with a website and a query