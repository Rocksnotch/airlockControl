-- local variables
local channelLocal
local configName = "userConfig.lua"
local programName = "MineCo Industries Airlock Control V1.0"
local modem = peripheral.wrap("back")

--channel stuff
local varList = {}

-- main program

local function clearScreen()
    term.clear()
    term.setCursorPos(1,1)
    term.setTextColor(colors.orange)
    print(programName)
    term.setTextColor(colors.white)
    term.setCursorPos(1,3)
end

if fs.exists(configName) ~= true then
    clearScreen()
    write("Enter channel to Broadcast to (numbers only): ")
    channelLocal = read()

    varList.channelLocal = channelLocal

    local output = textutils.serialise(varList)
    local config = fs.open(configName, "w")
    config.write(output)
    config.close()
end

local startCheck = fs.open(configName, "r")
local input = startCheck.readAll()
startCheck.close()
local vars = textutils.unserialise(input)

while true do

    clearScreen()
    write("Cycle Airlock? (Y/N): ")
    input = read()

    if input == "Y" or input == "y" then
        print("Cycling...")
        modem.transmit(vars.channelLocal, vars.channelLocal, "cycle")
        sleep(3)
    elseif input == "N" or input == "n" then
        print("Understood. Resetting.")
        sleep(3)
    end
end