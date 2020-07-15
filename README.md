# A Computronics Cassette Tape Utility (for server players)
For the Minecraft mod, Computronics/CC:Tweaked. 
A group of utilites for Computronics Cassette Tapes, with focus on utilites that work on Minecraft servers.  
Current Included Utilities are:   
* Download tutility for writing batches of files to a single cassette,
* Looping a cassette from start to finish of song (not entire cassette), with automatic detection for song ending.

## Getting the Program On Your CC Computer
Copy [tape-dl.lua](https://raw.githubusercontent.com/RVRX/computronics-tape-util/master/tape-util.lua) code to pastebin, 
then **navigate to a floppy disk (still debugging if this is necessary)**, and enter:  

``pastebin get [pastebin url] tape-util``, to download the program.  
Or Alternatively, 
``wget https://raw.githubusercontent.com/RVRX/computronics-tape-util/master/tape-util.lua ./tape-util``
## Usage
general usage can be seen by typing ``tape-util``
### Downloader
Downloads multiple tracks from a web directory and writes them to the cassette. The Intention is to have the tracks be just big enough to fit on the CC machine.
<details>
	<summary>Click for further details</summary>
	The general process is a loop of:   
	   1. wget-ting the file   
	   2. writing it to the tape, with a modified version of the default "tape write". This modification prevents it from rewinding, and removes the user confirmation.   
	   3. removing the file.   
	   4. repeat.
</details> 

#### setup/prerequisites
In either order:  
* Convert music file to .wav (I used [LameXP](https://github.com/lordmulder/LameXP)).
* Split into 1 minute pieces (I used [mp3splt-gtk](http://mp3splt.sourceforge.net/mp3splt_page/home.php) [but requires splitting before .wav convert]).  

Then, Use [LionRay](https://github.com/gamax92/LionRay) to convert those to .dfpwm 
(Note: LionRay doesn't appear to have any batch converting, must be done one-by-one). Name them "1.dfpwm", "2.dfpwm", etc..
Upload segments somewhere with direct file downloading/access (I used my web server).

#### running

Run the Program with
``tape-util dl [# files] [Directory URL]``. Directory URL must contain the ending forward-slash.   

### Song Looper
The song looper utility searches your cassette for the end of the song, then loops only up until that point, thereby skipping any dead/unwritten space at the end of a cassette.
<details>
	<summary>Click for further details</summary>
	Searching for the end of the track is done by looking for tape.read() locations that output 0. Once one is found, it searches the next few (10) locations, to see if these are also 0. The problem with only searching for 0 once, is that this is sometimes a quiet part of the song, noise, or a place where a track was spliced in, or otherwise. It /is/ only a 6000 of a second afterall (i think?).
	The Loop is simple, and just rewinds, starts, then sleeps for the track lengths amount of time. On wake, it repeats this. It saves the end location, so it does not need to search again. I might make a config file that will save it between program instances/runs in the future.
</details>   

#### running
``tape-util loop``


## Planned Additions and Footnotes
known issues:  
tape-util dl, does not rewind at start.  
tape-util dl, should say when it rewinds at end, that the program is finished.  
findTapeEnd, timeout protection might not be necessary anymore, adding bloat.  
looper(), could do with some cleaner prints. can screen be cleared?  

Planned Additions:  
looper(), needs accuracy argument! will be very slow on larger cassettes to find length. This would allow you to say how accurate you want to be with your initial search for the end of the track.  
looper(), could do with an argument where the user can specify the end of the track manually for know song lengths.  
looper(), make a save to config option that would allow you to save the track endings for labeled cassettes, so that the program can be restarted with no initilizing required.   
Maybe make a quicker algo for finding song end. Thinking of maybe doing half-splices, and looking forward if not at end, looking back if past end. Or maybe some actual search algo.
