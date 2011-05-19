albums = {:downloaded => `ls '#{BASE_DIR}'`.split("\n")}

puts "fetching album list from homepage..."
homepage = open("http://designers.mx/").read

cover_album_div = homepage[%r[<div id\="home-album">\s*(\s*<div>\s*<a href="[^"]+">.*?</a>\s*</div>\s*)+</div>]m]
albums[:top] = cover_album_div.scan(/href="\/([^"]+)"/).flatten

more_albums = homepage.scan(%r[<li class="(one|two|three|four|last)"><a href="/([^"]+)">.*?</a>(</span>)?</li>]).transpose[1]
albums[:recent] = more_albums[0,10]
albums[:popular] = more_albums[10,10]

puts "\nDownloaded albums:"
puts albums[:downloaded].map{|a| "\t#{a}"}
puts "\n5 TOP albums:"
puts albums[:top].map{|a| "\t#{a}"}
puts "\n10 most recent albums:"
puts albums[:recent].map{|a| "\t#{a}"}
puts "\n10 most popular albums:"
puts albums[:recent].map{|a| "\t#{a}"}
