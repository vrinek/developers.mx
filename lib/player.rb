@player = Thread.new do
  sleep 5
  
  @mp3s.each do |mp3|
    @played = false

    until @played
      if File.exists?(mp3[:filename])
        puts "PLAYING - #{mp3[:num]}. #{mp3[:name]}"
        growl_track("playing", @album_name, mp3[:name])
        
        system "afplay -v #{@opts[:volume] * 0.01} '#{mp3[:filename]}'"
        @played = true
      else
        debug "Can't find #{mp3[:name]} yet, sleeping..."
        sleep 5
      end
    end
  end
end
