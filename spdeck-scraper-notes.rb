require 'nokogiri'
require 'open-uri'

require 'pry'

#scrape the presentation URLs from these pages
# https://speakerdeck.com/p/all



# iterate using this construct

# https://speakerdeck.com/p/all?page=2
# step 2: integrate a top search for a given query
# links = []
# or presentations = { author => [pres_link] }


# this just grabs all the presentations and their links
    # will need to iterate over these to get the views #.css('li.views')
presentations = {}
for i in 2..5

    query = "ruby"
    # iterate through x number of pages from the search: ruby branch of the site
    doc = Nokogiri::HTML(open "https://speakerdeck.com/search?page=#{i}&q=#{query}")

    # on each page, grab each of the 15 authors' names, authors' page links, and the presentation links
    # I'm thinking that this might be too much work -- each page is going to have the author data on it, so maybe it's best to just grab the link data by itself 
    # ie the author data is implied in the link data
    doc.css('h3.title').each do |presentation|
        pres_link = presentation.css('a').attr('href').text
        pres_title = presentation.text.strip
        author_name = presentation.parent.css('a').last.text
        # author_page_link = presentation.parent.css('a').last.attr('href')
        # pres_date = presentation.parent.css('p').children.first.text.strip.split("by").join.strip # oh god please let there be a way to refactor
        # links[author_name] = [pres_link]
        good_words = ["awesome", "great", "amazing", "really cool", "tops", "mind-blowing", "super", "glittering", "thought-provoking", "glorious", "sweet"]
        puts "grabbed a #{good_words[rand(0..10)]} presentation by #{author_name}"
        presentations[pres_title] = pres_link
    end

    # stuff that data into a data structure
    # this builds a hash of presentation links keyed from their titles

end



binding.pry


# code graveyard
# pres_link << doc.css('h3.title').attr('href')
#     author_page_link << doc.css('p.date a').attr('href')
#     author_name << doc.css('p.date a').text
    

