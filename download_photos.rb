require 'open-uri'
require 'sequel'

def download_set(photo_set)
	photo_set.each{ |url|
		puts "Downloading image: #{url[:permalink]}\n"
		download url
	}
end

def download(url)
	open(url[:image]){ |f|
		File.open("/public/images/" + url[:permalink] + ".jpg","wb") do |file|
			file.puts f.read
		end
	}
end

DB = Sequel.sqlite('crawl.sqlite')
photos = DB[:photos]
# photos.all.each_slice(100).to_a.each{ |url_array|
	# Thread.new { download_set url_array }
# }
download_set photos.all