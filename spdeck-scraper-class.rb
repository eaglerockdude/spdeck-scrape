require 'nokogiri'
require 'open-uri'
require 'pp'
require 'pry'

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
        single_results_page_scrape(SD_QUERY_FIRST_PAGE)
        (2..range).collect do |i|
            single_results_page_scrape(i)
        end
        puts "cool! we got #{presentations.length} presentations"
    end

    # dumps the query results into a hash, presentations = { 'pres title' => 'pres_link.html' }
    # not called explicitly, lives in query scrape wrapper
    def single_results_page_scrape(i)
        doc = Nokogiri::HTML(open "#{url}search?page=#{i}&q=#{query}")
        doc.css('div.talk').each do |presentation|
            # ensures a unique key in the hash
            pres_id = presentation.attr('data-id')
            
            pres_link = presentation.css('h3.title a').attr('href').text
            
            # these two variables are unnececssary but provide a nice interface while the code is executing
            pres_title = presentation.css('h3.title').text.strip
            author_name = presentation.parent.css('h3.title a').last.text
            good_words = ["awesome", "great", "amazing", "really cool", "tops", "mind-blowing", "super", "glittering", "thought-provoking", "glorious", "sweet", "classy","really great", "fun", "strong", "robust", "healthy", "fine", "superior", "quality", "thoughful", "intelligent", "clever", "genius","incredible", "smart", "beautiful", "handsome", "pulchritudinous", "elegant", "bespoke", "crazy", "satisfying"]
            puts "grabbed a #{good_words[rand(good_words.length)]} presentation #{pres_title} by #{author_name}"
            sleep(0.1) # 
            self.presentations[pres_id] = pres_link 
        end
    end

    # wrapper to run the single page scraper for all links
    def scrape_all
        self.presentations.each do |id, link|
            pres_page_scrape(id, link)
        end
        dump(self.presentations)
        binding.pry
    end

    # grab data from one page
    # returns
    # note: this is a time consuming process -- have to open each page (but necessary because the views data isn't stored on the query pages)
    def pres_page_scrape(id, pres_link)
        # want to grab views, author, date
        # worry about returning it into something later
        pres_page = Nokogiri::HTML(open("https://speakerdeck.com#{pres_link}"))
        views = pres_page.css('li.views').text.scan(/\d+/).join.to_i
        title = pres_page.css('div#content header h1').text
        author = pres_page.css('div#content header h2 a').text
        author_link = pres_page.css('div#content header h2 a').attr('href').text
        presentations[id] = { 
            :title => title,
            :link => pres_link,
            :author => author,
            :views => views, 
            :author_link => author_link
            }
        puts "#{presentations[id][:title]} has #{views} views!"
    end

    def dump(pres_hash)


    end


end


scraper = SpeakerdeckScraper.new("https://speakerdeck.com/", "ruby")
scraper.query_results_scrape(2)
scraper.scrape_all
#pp scraper.presentations

# initialize a scraper with a website and a query


# to do's: 
    # implement a timer for the process
    # develop HTML generator
    # dumper method?
    # I don't understand how I'm grabbing the first page of query results, but I am.... figure this out
# is there a way to track bandwidth used in nokogiri calls?






