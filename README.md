#spdeck-scrape: Simple SpeakerDeck Scraper

This is a simple gem designed to scrape data from SpeakerDeck.com. This is the first gem I have ever built! I wrote it to practice scraping websites and to learn how to build gems. 

SpeakerDeck.com does not natively allow sorting presenations according to views, so this gem allows you to grab the views data and port it into a database or straight to barebones HTML, sorted in descending order.

This gem is still a work in progress!

###Installation
`gem install spdeck-scrape`


###Usage
spdeck-scrape can be used from the command line and also in Ruby scripts. 

From the command line: 
```bash
$ spdeck-scrape [query | range | l or s display]
```
In a Ruby script:

-   initialize a new `SpeakerdeckScraper` object specifying the desired query. It defaults to Ruby. 

```ruby
spd-ruby = SpeakerdeckScraper.new("rails")
# grabs the titles, authors, views, and links
```
-   set the number of query results pages to pull
```ruby
spd-ruby.query_results_scrape(10)
# pulls the first 10 pages
```
-   initiate the scrape
```ruby
spd-ruby.scrape_all
```
-   extract the data to basic HTML
```ruby
spd-ruby.html_gen
# will create a file called 'spd-ruby.html' in the working directory with a table of the results sorted by views descending
```



###Classes

SpeakerdeckScraper
Presentations
SPDatabase
SPHTMLGen

###Methods

