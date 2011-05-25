# Designers.MX CLI downloader/player

**version** 0.2

Right now it depends on OSX, will not run on anything else as it is.

### What it does
1. Fetches the album names on the front page of [Designers.MX](http://designers.mx)
2. Asks you to pick one
3. Downloads it and plays it

### What it doesn't do (yet)
* Won't display the actual album names (only the path)
* Won't let you pause/play and skip songs (ctrl-C to do that)
* Might leave the music playing after you interrupt the script (use `killall afplay` to stop the music)
* Won't import anything in iTunes
* Won't create a playlist (.m3u file)

## Installation
1. Download the code from the big **Download** button on top.
2. Un-zip the file.
3. Run it like as described below.

## Usage

Simplest usage (it will download a list of albums and ask which one to play):

    ./listen.rb

Download and play a specific album:

    ./listen.rb album_name

### More options:

Displays all the available options and defaults:

    ./listen.rb --help
  
Sets the volume to 20%:

    ./listen.rb --volume 20

Sets the base directory where all mp3s are going to be downloaded:

    ./listen.rb --dir ~/Music/Designer.MX

Download music but don't play:

    ./listen.rb --no-play

Play music but don't download (only useful on downloaded albums):

    ./listen.rb --no-download

## Command-line dependencies

* `wget` - Downloads the mp3s. I am not sure but I guess this is installed by default.
* `afplay` - Plays music. This is installed by default on OSX.
* `growlnotify` _(optional)_ - Informs you of what's happening. You will find it in the main .dmg of [Growl](http://growl.info).

## Contact info

The project is hosted on [Github](https://github.com/vrinek/developers.mx). Bug reports, feature requests and other feedback should be directed there.
