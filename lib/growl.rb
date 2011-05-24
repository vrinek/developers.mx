@growlnotify_path = `which growlnotify`.chomp

unless @growlnotify_path == ''
  def growl_track(action, mix, track)
    options = {
      :name => 'Designer.MX CLI ruby script',
      :message => "#{mix}\n#{track}",
      :title => "Designer.MX - #{action}"
    }
    growl options
  end

  def growl(opts = {})
    options = "-w"
    options << " -n \"#{opts[:name]}\""
    options << " -m \"#{opts[:message]}\""
    options << " \"#{opts[:title]}\""

    system %(#{@growlnotify_path} #{options} &)
  end
else
  def growl_track(*args); end
end