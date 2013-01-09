require 'rubygems'
require 'snoo'
require 'sequel'

##
# usage: ruby crawl.rb username password

DB = Sequel.sqlite('crawl.sqlite')

begin 
	puts "Attempting to create 'photos' table."
	DB.create_table :photos do
		primary_key :id
		String 	:permalink
		String 	:image
		String  :modhash
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
a, b = reddit.get_comments(subreddit: "photography", link_id: "1646jk", depth: 2, limit: 1000).parsed_response

puts "Parsing data and inserting into crawl.sqlite"
b["data"]["children"].each do |thread|
	photos.insert(
		:image => thread["data"]["body"].strip, 
		:permalink => thread["data"]["id"],
		:modhash => thread["data"]["modhash"]
	) unless thread["data"]["body"] =~ /deleted/
end
puts "Ran to completion"