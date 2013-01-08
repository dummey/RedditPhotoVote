require 'rubygems'
require 'snoo'
require 'sequel'

##
# usage: ruby crawl.rb username password
  
# connect to an in-memory database
DB = Sequel.sqlite('crawl.sqlite')

begin 
	puts "Attempting to create 'photos' table."
	DB.create_table :photos do
		primary_key :id
		String 	:permalink
		String 	:image
		index 	:permalink
		unique  :image
	end
rescue
	puts "'photos' table already exists"
	#table is already there
end

photos = DB[:photos]

reddit = Snoo::Client.new
reddit.log_in ARGV[0], ARGV[1]

puts "Crawling data from reddit."
a, b = reddit.get_comments(subreddit: "photography", link_id: "1646jk", depth: 2, limit: 1200).parsed_response

puts "Parsing data and inserting into crawl.sqlite"
b["data"]["children"].each do |thread|
	plink = "http://www.reddit.com/r/photography/comments/1646jk/the_rphotography_your_best_shot_2012_voting_thread/"
	photos.insert(
		:image => thread["data"]["body"], 
		:permalink => plink + thread["data"]["id"]
	) unless thread["data"]["body"] =~ /deleted/
end
puts "Ran to completion"