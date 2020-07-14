# A Computronics Cassette Tape Writer (for players on servers)
For the Minecraft mod, Computronics/CC:Tweaked. 
An easy* way to write longer songs onto a computronics cassette on MC servers (and possibly locally).

\**Yes, you do still have to yt-2-mp3 them, split them to 1-min chunks, convert them to .wav, convert to .dfpwm, upload them. 
I'm simply too far in now to google if there is anyother way to do this.*

## Usage
### setup
In either order:  
* Convert music file to .wav (I used [LameXP](https://github.com/lordmulder/LameXP)).
* Split into 1 minute pieces (I used [mp3splt-gtk](http://mp3splt.sourceforge.net/mp3splt_page/home.php) [but requires splitting before .wav convert]).  

Then, Use [LionRay](https://github.com/gamax92/LionRay) to convert those to .dfpwm 
(Note: LionRay doesn't appear to have any batch converting, must be done one-by-one). Name them "1.dfpwm", "2.dfpwm", etc..
Upload segments somewhere with direct file downloading/access (I used my web server).

### running
Copy [tape-dl.lua](https://github.com/RVRX/computronics-tape-write/blob/master/tape-dl.lua) code to pastebin, 
then **navigate to a floppy disk**, and enter:  

``pastebin get [pastebin url] tape-dl``, to download the program.  

Run the Program with
``tape-dl [# files] [Directory URL]``. Directory URL must contain the ending forward-slash.   




## WIP Notes
Quick and dirty implementation, will update this readme if I clean it up
