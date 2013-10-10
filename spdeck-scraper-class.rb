require 'nokogiri'
require 'open-uri'
require 'pp'
require 'pry'

class SpeakerdeckScraper

    attr_reader :url, :query, :page_object, :presentations, :start_time, :end_time
    
    SD_QUERY_FIRST_PAGE = "https://speakerdeck.com/search?q=ruby"
    SD_DOMAIN = "https://speakerdeck.com"
    
    def initialize(url, query = 'ruby')
        @url = url
        @query = query
        @page_object = ''
        @presentations = {}
        @start_time = Time.now
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
            sleep(0.05) # FHI: for human interface
            self.presentations[pres_id] = pres_link 
        end
    end

    # wrapper to run the single page scraper for all links
    def scrape_all
        self.presentations.each do |id, link|
            pres_page_scrape(id, link)
        end
        self.end_time = Time.now
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

    #presentations.to_a will be:
    #[[id, title, link, author, views, author_link],[id2, title2, link2, author2, views2, author_link], ...]


    def html_gen
        File.open("spd-#{query}.html", "w") do |file|
           file.write( <<-HTML
                <html>
                <header>
                </header>
                <body>
                <h1>speakerdeck presentations - #{query}</h1>
                <h3>this site was generated in #{end_time -start_time} seconds</h3>
                    <table border="1">
                    <tr>
                        <th>TITLE</th>
                        <th>author</th>
                        <th>views!!!!</th>
                    </tr>
            HTML
            )
            self.presentations.each do |id, content_hash|
                file.write ( <<-HTML
                    <tr>
                        <td><a href=#{SD_DOMAIN}/#{content_hash[:link]>#{content_hash[:title]}</a></td>
                        <td><a href=#{SD_DOMAIN}/#{content_hash[:author_link]>#{content_hash[:author]}</a></td>
                        <td>#{content_hash[:views]}</td>
                    </tr>  
                    HTML
                )
            end
        end
    end

# class end    
end


scraper = SpeakerdeckScraper.new("https://speakerdeck.com/", "ruby")
scraper.query_results_scrape(5)
scraper.scrape_all
#pp scraper.presentations

scraper.html_gen

scraper2 = SpeakerdeckScraper.new("https://speakerdeck.com/", "json")
scraper2.query_results_scrape(5)
scraper2.scrape_all

scraper2.html_gen

# initialize a scraper with a website and a query


# to do's: 
    # implement a timer for the process
    # develop HTML generator
    # dumper method?
    # I don't understand how I'm grabbing the first page of query results, but I am.... figure this out
    # how do I sort the data?
    # add a database?
    # add links for authors and presentations
    # put it up a website
    # implement a defense against a query that doesn't return enough results for the range
    # stats and comparisons of views for different queries (implement something that learns about common queries...? pretty advanced)

# is there a way to track bandwidth used in nokogiri calls?






