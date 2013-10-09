require 'nokogiri'
require 'open-uri'
require 'pp'


class SpeakerdeckScraper

    attr_reader :url, :query, :page_object, :presentations
    
    SD_QUERY_FIRST_PAGE = "https://speakerdeck.com/search?q=ruby"
    
    def initialize(url, query = 'ruby')
        @url = url
        @query = query
        @page_object = ''
        @presentations = {}
    end

    def query_results_scrape(range)
        (2..range).collect do |i|
            single_results_page_scrape(i)
        end
        single_results_page_scrape(SD_QUERY_FIRST_PAGE)
    end

    def single_results_page_scrape(i)
        doc = Nokogiri::HTML(open "#{url}search?page=#{i}&q=#{query}")
        # will need to iterate over these to get the views #.css('li.views')
        doc.css('h3.title').each do |presentation|
            pres_link = presentation.css('a').attr('href').text
            pres_title = presentation.text.strip
            author_name = presentation.parent.css('a').last.text
            good_words = ["awesome", "great", "amazing", "really cool", "tops", "mind-blowing", "super", "glittering", "thought-provoking", "glorious", "sweet"]
            puts "grabbed a #{good_words[rand(0..10)]} presentation by #{author_name}"
            self.presentations[pres_title] = pres_link
        end
    end

end


scraper = SpeakerdeckScraper.new("https://speakerdeck.com/", "ruby")
scraper.query_results_scrape(5)

pp scraper.presentations

# initialize a scraper with a website and a query






