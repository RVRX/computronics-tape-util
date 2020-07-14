--Program for looping tracks

local tape = peripheral.find("tape_drive")
if not tape then
	print("This program requires a tape drive to run.")
	return
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

	local accuracy = 10
	print("Using accuracy of " .. accuracy)

	local tapeSize = tape.getSize()
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
		sleep(endLoc/6000)
	end

	--play tape until 
end


--[[

A 4 minute tape is 1,440,000 units
240 seconds is 1,440,000

A 6 minute tape is 2,160,000 units
360 seconds is 2,160,000 units

Therefore, 1 second is 6000 UNITS

add a config file for know cassettes

]]