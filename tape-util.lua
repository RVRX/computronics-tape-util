--[[ A Utility Program for Computronics Cassette Tapes.
Provides:
	- automatic tape writing from web location
	- automatic tape looping
	- More in future updates
]]

local args = { ... }

--tape check
local tape = peripheral.find("tape_drive")
if not tape then
  print("This program requires a tape drive to run.")
  return
end

local function helpText()
	print("Usage:")
	print(" - 'tape-util' to display this help text")
	print(" - 'tape-util loop' to loop a cassette tape")
  	print(" - 'tape-util dl [num files] [web dir]' to write web directory to tape")
  	print(" - 'tape-util dl' to display full download utility help text")
  	return
end

local function helpTextDl()
	print("Usage:")
  	print(" - 'tape-util dl' to display this help text")
  	print(" - 'tape-util dl [num files] [web dir]' to write web directory to tape")
  	print("directory url must contain ending forward-slash.\nFiles must be named their order number .dfpwm, ex:\n'1.dfpwm', '2.dfpwm', etc")
end

--add helpText for loop util, when more features are added.





--TAPE LOOP CONTENT------------
--Program for looping tracks

local tape = peripheral.find("tape_drive")
if not tape then
-- 	print("This program requires a tape drive to run.")
-- 	return
end

--Returns true if position 1 away is zero
local function seekNCheck()
	--seek 1 and check
	tape.seek(1)
	print("Seeking 1...")
	if tape.read() == 0 then
		return true
	else return false
	end
end

--Checks multiple bits into distance to make sure it is actual end of track, and not just a quiet(?) part
local function seekNCheckMultiple()
	for i=1,10 do
		if seekNCheck() == false then
			return false
		end
	end
	return true
end
	
-- this could be made into a more efficient algo?
local function findTapeEnd( ... )

	local accuracy = 100
	print("Using accuracy of " .. accuracy)

	local tapeSize = tape.getSize()
	print("Tape has size of: " .. tapeSize)
	tape.seek(-tapeSize) -- rewind tape
	local runningEnd = 0

	for i=0,tapeSize do --for every piece of the tape
	
		os.queueEvent("randomEvent") -- timeout
		os.pullEvent()				 -- prevention


		tape.seek(accuracy) --seek forward one unit (One takes too long, bigger values not as accurate)
		if tape.read() ~= 0 then --if current location is not a zero
			runningEnd = i*accuracy --Update Running runningEnd var. i * accuracy gets current location in tape
			print("End Candidate: " .. runningEnd)
		elseif seekNCheckMultiple() then --check a few spots away to see if zero as well
			return runningEnd
		--else return runningEnd --otherwise, (if 0) return runningEnd
		end --end if
	end

end

--Main Function
local function looper( ... )
	print("Initializing...")
	--find tape end
	print("Locating end of song...")
	local endLoc = findTapeEnd()
	print("End of song at position " .. endLoc .. ", or " .. endLoc/6000 .. " seconds in\n")

	print("Starting Loop! Hold Ctrl+T to Terminate")
	while true do
		tape.seek(-tape.getSize())
		tape.play()
		print("... Playing")
		sleep(endLoc/6000)
		print("Song Ended, Restarting...")
	end

	--play tape until 
end

--END TAPE LOOP CONTENT---------------------------------





--START TAPE DL CONTENT--------------------------------
local function writeTapeModified(relPath)
	--check for tape drive
	local tape = peripheral.find("tape_drive")
	if not tape then
		print("This program requires a tape drive to run.")
		return
	end
  local file, msg, _, y, success
  local block = 8192 --How much to read at a time

  -- if not confirm("Are you sure you want to write to this tape?") then return end
  tape.stop()
  --tape.seek(-tape.getSize()) --MODIFIED this part has been removed to stop seeking back to start between writes
  tape.stop() --Just making sure

  local path = shell.resolve(relPath)
  local bytery = 0 --For the progress indicator
  local filesize = fs.getSize(path)
  print("Path: " .. path)
  file, msg = fs.open(path, "rb")
  if not fs.exists(path) then msg = "file not found" end
  if not file then
    printError("Failed to open file " .. relPath .. (msg and ": " .. tostring(msg)) or "")
    return
  end

  print("Writing...")

  _, y = term.getCursorPos()

  if filesize > tape.getSize() then
    term.setCursorPos(1, y)
    printError("Error: File is too large for tape, shortening file")
    _, y = term.getCursorPos()
    filesize = tape.getSize()
  end

  repeat
    local bytes = {}
    for i = 1, block do
      local byte = file.read()
      if not byte then break end
      bytes[#bytes + 1] = byte
    end
    if #bytes > 0 then
      if not tape.isReady() then
        io.stderr:write("\nError: Tape was removed during writing.\n")
        file.close()
        return
      end
      term.setCursorPos(1, y)
      bytery = bytery + #bytes
      term.write("Read " .. tostring(math.min(bytery, filesize)) .. " of " .. tostring(filesize) .. " bytes...")
      for i = 1, #bytes do
        tape.write(bytes[i])
      end
      sleep(0)
    end
  until not bytes or #bytes <= 0 or bytery > filesize
  file.close()
  tape.stop()
  --tape.seek(-tape.getSize()) --MODIFIED same reaosn as above...
  tape.stop() --Just making sure
  print("\nDone.")
end

local function tapeDl(numParts,url)
	--check for tape drive.
	local tape = peripheral.find("tape_drive")
	if not tape then
		print("This program requires a tape drive to run.")
		return
	end

	local i = 1 --iterator

	--Main Loop
	while i <= tonumber(numParts) do
		shell.run("wget", "" .. url .. i .. ".dfpwm", "../temp_dl.dfpwm") --wget file
		writeTapeModified("../temp_dl.dfpwm") --write to tape
		shell.run("rm", "../temp_dl.dfpwm") -- rm temp file
		i = i + 1 -- i++
	end
	tape.seek(-tape.getSize()) --rewind tape
end
--END TAPE DL CONTENT----------------------------------






if args[1] == "loop" then
	looper()
elseif args[1] == "dl" then
	if args[2] ~= nil then
		print("running tapeDl")
		tapeDl(args[2],args[3])
	else helpTextDl()
	end
else
	helpText()
end


--[[ known issues:
tape-util dl, does not rewind at start.
tape-util dl, should say when it rewinds at end, that the program is finished.
findTapeEnd, timeout protection might not be necessary anymore, adding bloat.
looper(), could do with some cleaner prints. can screen be cleared?
looper(), needs accuracy argument! will be very slow on larger cassettes to find length

]]
