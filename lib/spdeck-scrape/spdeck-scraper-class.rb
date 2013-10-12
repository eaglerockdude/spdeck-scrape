require 'nokogiri'
require 'open-uri'
require 'pp'
require 'pry'

class SpeakerdeckScraper

    attr_reader :query, :page_object, :presentations, :url
    attr_accessor :start_time, :end_time
    
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
        doc = Nokogiri::HTML(open "#{self.url}search?page=#{i}&q=#{query}")
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
    # note: this is a time consuming process -- have to open each page (but necessary because the views data isn't stored on the query pages)
    def pres_page_scrape(id, pres_link)
        pres_page = Nokogiri::HTML(open("https://speakerdeck.com#{pres_link}"))
        
        presentations[id] = { 
            :title => pres_title(pres_page),
            :link => pres_link,
            :date => pres_date(pres_page),
            :author => pres_author(pres_page),
            :author_link => pres_author_link(pres_page),
            :category => pres_category(pres_page), 
            :views => pres_views(pres_page)
            }

        puts "#{presentations[id][:title]} has #{presentations[id][:views]} views!"
    end

    def pres_views(pres_page)
        pres_page.css('li.views').text.scan(/\d+/).join.to_i
    end

    def pres_title(pres_page)
        pres_page.css('div#content header h1').text

    end

    def pres_author(pres_page)
        pres_page.css('div#content header h2 a').text
    end

    def pres_author_link(pres_page)
        pres_page.css('div#content header h2 a').attr('href').text
    end

    def pres_date(pres_page)
        pres_page.css('div#talk-details mark').first.text.strip
    end

    def pres_category(pres_page)
        pres_page.css('div#talk-details mark a').text
    end



    #presentations.to_a will be:
    #[id = {title, link, author, views, author_link}, id2 = {title2, link2, author2, views2, author_link}, ...]

    #presentation  = {
    # 'idijsdasdfljk' => {
    #     :title => 'string',
    #     :link => 'url string',
    #     :author => 'name',
    #     :views => integer,
    #     :author_link => 'url string'
    #     }
    # }


    def html_gen
        # take data and sort it by views descending
        sorted_array = self.presentations.values.sort_by do |pres_hash| 
            pres_hash[:views]
        end.reverse

        File.open("spd-#{query}.html", "w") do |file|
            file.write( <<-HTML
                <html>
                <head>
                </head>
                <body>
                <h1>speakerdeck presentations - #{query}</h1>
                <h4>this site was generated in #{self.end_time - self.start_time} seconds (last queried at #{self.start_time})
                    <table class="tablesorter" border="1">
                    <tr>
                        <th>title</th>
                        <th>date</th>
                        <th>category</th>
                        <th>author</th>
                        <th>views</th>
                    </tr>
            HTML
            )
            sorted_array.each do |content_hash|
                link = "#{SD_DOMAIN}#{content_hash[:link]}"
                author_link = "#{SD_DOMAIN}#{content_hash[:author_link]}"
                file.write ( <<-HTML
                    <tr>
                        <td><a href=#{link}>#{content_hash[:title]}</a></td>
                        <td>#{content_hash[:date]}</td>
                        <td><a href="https://speakerdeck.com/c/#{content_hash[:category].downcase}">#{content_hash[:category]}</a></td>
                        <td><a href=#{author_link}>#{content_hash[:author]}</a></td>
                        <td>#{content_hash[:views]}</td>
                    </tr>  
                    HTML
                )
            end
            file.write(<<-HTML
                </table>
                </body>
                </html>
                HTML
                )
        end
    end

# class end    
end


scraper = SpeakerdeckScraper.new("https://speakerdeck.com/", "ruby")
scraper.query_results_scrape(2)
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








