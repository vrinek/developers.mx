#!/usr/bin/env ruby

require 'open-uri'
require 'growl.rb'
BASE_DIR = "#{`echo ~`.strip}/Desktop/Designer.MX/"
DEBUG = false

def sh(command)
  debug command
  system command
end

unless ARGV[0]
  require 'homepage.rb'
  puts "\nPlease enter the name of the album you want to listen to:"
  album = gets.strip
else
  album = ARGV[0].strip
end

@puts_mutex = Mutex.new
def puts(string)
  @puts_mutex.synchronize do
    super(string.to_s)
  end
end

def debug(string)
  puts string if DEBUG
end

album_url = "http://designers.mx/#{album}/"
html = open(album_url).read

playlist = html[%r[Playlist\("\d+", \[([^\]]+)\]]m, 1]
mp3s = playlist.scan(/\{\s*name\:\s*"([^"]+)",\s*htmlname\:\s*"([^"]+)",\s*mp3:\s*"([^"]+)"\s*\}/m)
mp3s.map! do |name, html, url|
  num = html[/^\d+/]
  filename = "#{BASE_DIR}#{album}/#{num.to_s.rjust(2, '0')}. #{name.gsub(/\//, "-").gsub(/[\!\'"\$]/, "-")}.mp3"
  
  {
    :name => name,
    :html => html,
    :url => url,
    :num => num,
    :filename => filename
  }
end

if mp3s.empty?
  sh "open #{album_url}"
  raise "No mp3s found..."
end

FileUtils.makedirs(mp3s[0][:filename].sub(/\/[^\/]+\.mp3$/, '/'))

downloader = Thread.new do
  mp3s.each do |mp3|
    unless File.exists?(mp3[:filename])
      mp3.each do |k,v|
        debug k.to_s.rjust(12) + " : " + v.to_s
      end
      growl_track("downloading", album, mp3[:name])
      debug "\n"
      puts "DOWNLOADING - #{mp3[:name]}"

      sh "wget -q \"#{mp3[:url]}\" -O \"#{mp3[:filename]}\""
      raise "MP3 was not downloaded" unless File.exists?(mp3[:filename])
    end
  end
  
  puts "Done downloading :)"
end

player = Thread.new do
  sleep 5
  
  mp3s.each do |mp3|
    @played = false

    until @played
      if File.exists?(mp3[:filename])
        puts "PLAYING - #{mp3[:num]}. #{mp3[:name]}"
        growl_track("playing", album, mp3[:name])
        
        sh "afplay -v 0.4 '#{mp3[:filename]}'"
        @played = true
      else
        debug "Can't find #{mp3[:name]} yet, sleeping..."
        sleep 5
      end
    end
  end
end

downloader.join
player.join
