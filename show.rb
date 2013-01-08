require 'rubygems'
require 'sinatra'
require 'sequel'

DB = Sequel.sqlite('crawl.sqlite')

photos = DB[:photos]
num_photos = photos.count
random = Random.new


get '/show/:count' do
	
	
	select = []
	while true
		pick = random.rand(num_photos)
		select << pick unless select.include? pick
		break if select.count > params[:count].to_i
	end

	@urls = photos.filter(:id => select).all 
		
	haml :show
end

__END__

@@ layout
%html
  = yield

@@ show
#header
	%h1 r/photography gimpy photo viewer
	%p Hit refresh(f5 to load new pictures. You can change the number of pictures shown at a time by change the the number in the url, ie. /show/100 to show 100 on the same page.
#main
	%table{:align => "center"}
		%tbody
			- @urls.each do |url|
				%tr
					%td{:align => "center"} 
						%img{:src => url[:image]}
						%br
						%a{:href => url[:permalink]} #{url[:id]}

