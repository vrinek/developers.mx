require 'trollop.rb'

@opts = Trollop::options do
  version "developers.mx 0.2 (c) 2011 Kostas Karachalios"
  banner <<-EOS
Usage:
  ./listen.rb [options] [album_path]
where [options] are:
EOS

  opt :volume, "Music volume", :default => 40
  opt :debug, "Debug mode"
  opt :dir, "Base directory", :default => "~/Desktop/Designer.MX/"
  opt :"no-play", "Don't play, only download", :default => false
  opt :"no-download", "Don't download, only play", :default => false
end

Trollop::die :volume, "must be non-negative" if @opts[:volume] < 0

@opts[:dir].sub!(/^\~/, `echo ~`.strip)
