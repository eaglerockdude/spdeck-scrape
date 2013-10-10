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
        puts "cool! we got #{presentations.length} presentations"
    end

    # dumps the query results into a hash, presentations = { 'pres title' => 'pres_link.html' }
    # not called explicitly, lives in query scrape wrapper
    def single_results_page_scrape(i)
        doc = Nokogiri::HTML(open "#{url}search?page=#{i}&q=#{query}")
        doc.css('h3.title').each do |presentation|
            pres_link = presentation.css('a').attr('href').text
            pres_title = presentation.text.strip
            author_name = presentation.parent.css('a').last.text
            good_words = ["awesome", "great", "amazing", "really cool", "tops", "mind-blowing", "super", "glittering", "thought-provoking", "glorious", "sweet", "classy","really great", "fun", ""]
            puts "grabbed a #{good_words[rand(0..10)]} presentation by #{author_name}"
            self.presentations[pres_title] = pres_link
        end
    end

    # wrapper to run the single page scraper for all links
    def scrape_all
        views_hash = presentations.collect do |title, link|
            pres_page_scrape(title, link)
        end
    end

    # grab data from one page
    # returns
    # note: this is a time consuming process -- have to open each page (but necessary because the views data isn't stored on the query pages)
    def pres_page_scrape(title, pres_link)
        # want to grab views, author, date
        # worry about returning it into something later
        pres_page = Nokogiri::HTML(open("https://speakerdeck.com#{pres_link}"))
        views = pres_page.css('li.views').text.scan(/\d+/).join.to_i
        puts "#{title} has #{views} views!"
    
    end
# https://speakerdeck.com/lvrug/introduction-to-tdd-jason-arhart






end


scraper = SpeakerdeckScraper.new("https://speakerdeck.com/", "ruby")
scraper.query_results_scrape(5)
scraper.scrape_all
#pp scraper.presentations

# initialize a scraper with a website and a query






