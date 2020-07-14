--[[Modified version tape.write() fcn from ln 5-71
Modifications are simply commented out lines.
This stops the write fcn from rewinind the tape
between each write call]]
local tape = peripheral.find("tape_drive")
if not tape then
	print("This program requires a tape drive to run.")
	return
end

--add usage? "ColesTapeThing -help" list params/args?

local function writeTapeModified(relPath)
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

-- numParts arg
local args = { ... } -- i guess this gets args? just copying what i see in other APIs in programs dir
local numParts = args[1] --assuming not zero indexing, but 0 might be something else?
local url = args[2] -- where url is web directory contaiing files. must inlcude final "/"

--iterator
local i = 1

--Main Loop
while i <= tonumber(numParts) do
	--wget file
	shell.run("wget", "" .. url .. i .. ".dfpwm", "../temp_dl.dfpwm") -- including first "" cause not sure if I can concatonate without string

	--write to tape (modified)
	writeTapeModified("../temp_dl.dfpwm") -- still requires y/n confirmation, will that work?
										  -- assuming this is how u call local fcn?
										  -- will fcn in fcn eat the y/n echo?

	--remove temp
	shell.run("rm", "../temp_dl.dfpwm")

	--i++
	i = i + 1
end

tape.rewind()

-- Yes this is messy, I'm just guessing the syntax of what I only just now learned is called LUA not "ComputerCraft Language".
-- Might refactor later, but it gets the job done.
-- add sleeps while it dl's and rms stuff?
