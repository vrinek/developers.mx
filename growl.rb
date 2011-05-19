def growl_track(action, mix, track)
  options = {
    :name => 'Designer.MX CLI ruby script',
    :message => "#{action} \"#{track}\" from mix \"#{mix}\"",
    :title => "Designer.MX"
  }
  growl options
end

def growl(opts = {})
  growlnotify = `which growlnotify`.chomp

  unless growlnotify == ''
    options = "-w"
    options << " -n '#{opts[:name]}'" if opts[:name]

    if opts[:image]
      image_path = File.expand_path('~/.watchr_images/'+opts[:image]+'.png')

      if File.exists?(image_path)
        options << " --image '#{image_path}'"
      end
    end

    options << " -m '#{opts[:message]}'" if opts[:message]
    options << " '#{opts[:title]}'" if opts[:title]
    options << " -p '#{opts[:severity]}'" if opts[:severity]
    
    system %(#{growlnotify} #{options} &)
  end
end
