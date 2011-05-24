#!/usr/bin/env ruby

require 'open-uri'
require 'fileutils'
require 'lib/growl.rb'
require 'lib/options.rb'

p @opts if @opts[:debug]
FileUtils.makedirs(@opts[:dir])

def system(command)
  debug command
  super command
end

@puts_mutex = Mutex.new
def puts(string)
  @puts_mutex.synchronize do
    super(string)
  end
end

def debug(string)
  puts string if @opts[:debug]
end

unless ARGV[0]
  require 'lib/homepage.rb'

  puts "\nPlease enter the name of the album you want to listen to:"
  album = gets.strip
else
  album = ARGV[0].strip
  puts "Album: #{album}"
end

album_url = "http://designers.mx/#{album}/"
album_html = open(album_url).read

@album_name = album_html[/<title>(.*?)( \- Designers\.MX)?<\/title>/, 1]
playlist = album_html[%r[Playlist\("\d+", \[([^\]]+)\]]m, 1]

@mp3s = playlist.scan(/\{\s*name\:\s*"([^"]+)",\s*htmlname\:\s*"([^"]+)",\s*mp3:\s*"([^"]+)"\s*\}/m)
@mp3s.map! do |name, html, url|
  num = html[/^\d+/]
  filename = "#{@opts[:dir]}#{album}/#{num.to_s.rjust(2, '0')}. #{name.gsub(/\//, "-").gsub(/[\!\'"\$]/, "-")}.mp3"
  
  {
    :name => name,
    :html => html,
    :url => url,
    :num => num,
    :filename => filename
  }
end

if @opts[:debug]
  @mp3s.each do |mp3|
    mp3.each do |k, v|
      puts k.to_s.rjust(10) + ' : ' + v.to_s
    end
    puts "status".rjust(10) + " : #{File.exists?(mp3[:filename]) ? 'LOCAL' : 'REMOTE'}"
    puts "\n"
  end
end

raise "No mp3s found..." if @mp3s.empty?

FileUtils.makedirs(@mp3s[0][:filename].sub(/\/[^\/]+\.mp3$/, '/'))

require 'lib/downloader.rb' unless @opts[:'no-download']
require 'lib/player.rb' unless @opts[:'no-play']

@downloader.join if @downloader
@player.join if @player
