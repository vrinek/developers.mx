@downloader = Thread.new do
  @mp3s.each do |mp3|
    unless File.exists?(mp3[:filename])
      mp3.each do |k,v|
        debug k.to_s.rjust(12) + " : " + v.to_s
      end
      debug "\n"
      growl_track("downloading", @album_name, mp3[:name])
      puts "DOWNLOADING - #{mp3[:name]}"

      system "wget -q \"#{mp3[:url]}\" -O \"#{mp3[:filename]}\""
      raise "MP3 was not downloaded" unless File.exists?(mp3[:filename])
    end
  end
  
  puts "Done downloading :)"
end
