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
#main
	%table
		%tbody
			- @urls.each do |url|
				%tr
					%td 
						%img {src="

