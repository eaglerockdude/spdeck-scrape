#spdeck-scrape: Simple SpeakerDeck Scraper

This is a simple gem designed to scrape data from SpeakerDeck.com. This is the first gem I have ever built! I wrote it to practice scraping websites and to learn how to build gems. 

SpeakerDeck.com does not natively allow sorting presenations according to views, so this gem allows you to grab the views data and port it into a database or straight to barebones HTML, sorted in descending order.

This gem is still a work in progress!

###Installation
`gem install spdeck-scrape`


###Usage
spdeck-scrape can be used from the command line and also in Ruby scripts. 

Initialize a new `SpeakerdeckScraper` object specifying the desired query. It defaults to Ruby. 

```ruby
spruby = SpeakerdeckScraper.new("rails")
# grabs the titles, authors, views, and links
```

You can call do the following to extract the data to HTML.
```ruby
spruby.html_gen
```


###Classes

SpeakerdeckScraper
Presentations
SPDatabase
SPHTMLGen

###Methods

