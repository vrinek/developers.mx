require 'open-uri'
BASE_DIR = "#{`echo ~`.strip}/Desktop/Designer.MX/"
albums = {:downloaded => `ls '#{BASE_DIR}'`.split("\n")}

require 'homepage.rb'

puts "\nPlease enter the name of the album you want to listen to:"
album = gets.strip

# raise 'hell'

# album = 'concentrate'
html = open("http://designers.mx/#{album}/").read

playlist = html[%r[Playlist\("\d+", \[([^\]]+)\]]m, 1]
mp3s = playlist.scan(/\{\s*name\:\s*"([^"]+)",\s*htmlname\:\s*"([^"]+)",\s*mp3:\s*"([^"]+)"\s*\}/m)
mp3s.map! do |name, html, url|
  {
    :name => name,
    :html => html,
    :url => url,
    :num => (num = html[/^\d+/]),
    :filename => "#{BASE_DIR}#{album}/#{num.to_s.rjust(2, '0')}. #{name}.mp3"
  }
end

FileUtils.makedirs(mp3s[0][:filename].sub(/\/[^\/]+\.mp3$/, '/'))

downloader = Thread.new do
  mp3s.each do |mp3|
    unless File.exists?(mp3[:filename])
      mp3.each do |k,v|
        puts k.to_s.rjust(12) + " : " + v.to_s
      end
      puts "\n"

      system "wget -nv '#{mp3[:url]}' -O '#{mp3[:filename].sub(/['\/]/, "")}'"
      raise "MP3 was not downloaded" unless File.exists?(mp3[:filename])
    end
  end
end

player = Thread.new do
  sleep 5
  
  mp3s.each do |mp3|
    @played = false

    until @played
      if File.exists?(mp3[:filename])
        puts "PLAYING - #{mp3[:num]}. #{mp3[:name]}"
        system "afplay '#{mp3[:filename].sub(/['\/]/, "")}'"
        @played = true
      else
        puts "Can't find #{mp3[:name]} yet, sleeping..."
        sleep 5
      end
    end
  end
end

downloader.join
player.join
