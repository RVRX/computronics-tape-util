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
	

local function findTapeEnd( ... )

	local tapeSize = tape.getSize()
	tape.seek(-tapeSize) -- rewind tape
	local runningEnd = 0

	for i=0,tapeSize do --for every piece of the tape
	
		os.queueEvent("randomEvent") -- timeout
		os.pullEvent()				 -- prevention


		tape.seek(100) --seek forward one unit
		if tape.read() ~= 0 then --if current location is not a zero
			runningEnd = i --Update Running runningEnd var
			print("End Candidate: " .. runningEnd)
		elseif seekNCheckMultiple() then --check a few spots away to see if zero as well
			return runningEnd
		--else return runningEnd --otherwise, (if 0) return runningEnd
		end --end if
	end

end


print(findTapeEnd())