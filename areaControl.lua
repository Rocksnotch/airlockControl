--Local variables that don't change

local interior = colors.blue
local exterior = colors.red
local modem = peripheral.wrap("back")
local configName = "areaConfig.lua"
local side = "left"
local airlockName

--varibles to file

local doorInterior = true
local doorExterior = false
local doorStatus = "Exterior"
local activeColors = interior
local channelLocal

local varList = {}
varList.doorInterior = doorInterior
varList.doorExterior = doorExterior
varList.activeColors = activeColors
varList.doorStatus = doorStatus

--main program

local function cycleDoors()
    local doorCheck = fs.open(configName, "r")
    local input = doorCheck.readAll()
    doorCheck.close()
    local vars = textutils.unserialise(input)

    if (vars.doorInterior == true) and (vars.doorExterior == false) then
        print("Cycling to Exterior.")
        vars.activeColors = vars.activeColors - interior
        rs.setBundledOutput(side, vars.activeColors)
        sleep(3)
        vars.activeColors = vars.activeColors + exterior
        rs.setBundledOutput(side, vars.activeColors)
        vars.doorInterior = false
        vars.doorExterior = true
        local editVars = textutils.serialise(vars)
        config = fs.open(configName, "w")
        config.write(editVars)
        config.close()
    elseif (vars.doorInterior == false) and (vars.doorExterior == true) then
        print("Cycling to Interior.")
        vars.activeColors = vars.activeColors - exterior
        rs.setBundledOutput(side, vars.activeColors)
        sleep(3)
        vars.activeColors = vars.activeColors + interior
        rs.setBundledOutput(side, vars.activeColors)
        vars.doorInterior = true
        vars.doorExterior = false
        local editVars = textutils.serialise(vars)
        config = fs.open(configName, "w")
        config.write(editVars)
        config.close()
    end
end

if fs.exists(configName) ~= true then

    term.clear()
    term.setCursorPos(1,1)
    term.setTextColor(colors.orange)
    print("MineCo Industries Airlock Controller V2.0")
    term.setTextColor(colors.white)
    term.setCursorPos(1,3)
    write("Please enter airlock channel (number only): ")
    channelLocal = read()

    varList.channelLocal = channelLocal

    local output = textutils.serialise(varList)
    local config = fs.open(configName, "w")
    config.write(output)
    config.close()
end

term.clear()
term.setCursorPos(1,1)
term.setTextColor(colors.orange)
print("MineCo Industries Airlock Controller V2.0")
term.setTextColor(colors.white)
term.setCursorPos(1,3)

local startCheck = fs.open(configName, "r")
local input = startCheck.readAll()
startCheck.close()
local vars = textutils.unserialise(input)

rs.setBundledOutput(side, vars.activeColors)

while true do
    local event, modSide, sendChan, repChan, msg, dist = os.pullEvent("modem_message")

    if (msg == "cycle") and (sendChan == channelLocal) then
        cycleDoors()
    end
end