require 'rubygems'
require 'sinatra'
require 'sequel'
require 'haml'

DB = Sequel.sqlite('crawl.sqlite')

photos = DB[:photos]
num_photos = photos.count
random = Random.new

get '/show/:count' do
	select = []
	while true
		pick = random.rand(num_photos)
		select << pick unless select.include? pick
		break if select.count >= params[:count].to_i
	end

	@urls = photos.filter(:id => select).all 
		
	haml :show
end

#a{:href => "http://www.reddit.com/r/photography/comments/1646jk/the_rphotography_your_best_shot_2012_voting_thread/" + url[:permalink]} #{url[:id]}

__END__

@@ layout
%html
  = yield

@@ show
	
#header
	%h1 r/photography gimpy photo viewer
	%p New images will be select on each load of the page.
#main
	%table{:align => "center"}
		%tbody
			%tr
				%td{:align => "center"}
					Number of photos to show
					%a{:href => "/show/1"} 1
					%a{:href => "/show/2"} 2
					%a{:href => "/show/5"} 5
					||
					%a{:href => "javascript:location.reload(true);"} Refresh
			- @urls.each do |url|
				%tr
					%td{:align => "center"} 
						%img{:src => "/images/" + url[:permalink] + ".jpg"}
						%br
						%a{} Downvote
						||
						%a{} Upvote
						%br
						%hr
						%br
