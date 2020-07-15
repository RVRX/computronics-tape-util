--WIP, copy functionality between two cassette tapes.--
--NOT FUNCTIONAL, THIS IS A WORK IN PROGRESS--

local tape1, tape2 = peripheral.find("tape_drive") --get both

--display findings
write("Found ")

	--tape 1
if tape1.getLabel() ~= nil then
	write(tape1.getLabel)
else write("unnamed tape")
end
write(" (" .. tape1.getSize() .. ")")

write(" AND ")

	--tape 2
if tape2.getLabel() ~= nil then
	write(tape2.getLabel)
else write("unnamed tape")
end
write(" (" .. tape2.getSize() .. ")")
write("\n")


-- Scan in user input
local function userSelectTape()
	write("which tape would you like to have the content pasted on (The unselected one will be copied from)?\nEnter '1' or '2'")
	local selectedTape = read()
	print("You chose: tape ", selectedTape) --weird way of concat.
	return selectedTape
end

-- Interpret User Input
local function copyTape(selectedTape)
	--rewind both
	tape1.seek(-tape1.getSize())
	tape2.seek(-tape2.getSize())

	-- get smallest
	local smallest = nil
	if tape1.getSize() > tape2.getSize() then
		smallest = tape2.getSize()
	else smallest = tape2.getSize
	end

	local copyContent = nil

	if tonumber(selectedTape) == 1 then -- copy from tape 1 to tape 2
		for i=1,smallest do
			-- copyContent = tape1.read()
			-- tape2.write(copyContent)
			tape2.write(tape1.read()) --read/write
			--seek to next position
			tape1.seek(1)
			tape2.seek(1)
		end
	elseif tonumber(selectedTape) == 2 then --copy from tape 2 to tape 1
		for i=1,smallest do
			tape1.write(tape2.read()) --read/write
			--seek to next byte
			tape1.seek(1)
			tape2.seek(1)
		end
	else
		return error
	end
end


--Initilizing:
local function StartCopy()
	copyTape(userSelectTape())
end

--[[
ask user which one they want to copy from/to

seek to start of both,
loop
	read first byte of one,
	copy to write as byte of other,
	seek forward 1
end (at end of tape or song?)

Bugs/TODO:
	error checking if one tape is larger than other.
]]