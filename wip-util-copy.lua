--WIP, copy functionality between two cassette tapes.--

local tape1, tape2 = peripheral.find("tape_drive") --get both
print("Found " .. tape1.getLabel() .. "(" .. tape1.getSize() .. ")" .. " and " .. tape2.getLabel() .. " (" .. tape2.getSize() .. ")")

--[[
ask user which one they want to copy from/to

seek to start of both,
loop
	read first byte of one,
	copy to write as byte of other,
	seek forward 1
end (at end of tape or song?)
]]