function update_pastebin()
    -- PASTEBIN --
    local startup_link = "gERMbWFV"
    local config_link = "SsijQ8Pw"
    local utils_link = "q420mMBY"

    -- CHECK DEPENDENCY FILES --
    if fs.exists("startup") then
        fs.delete("startup")
    end

    if fs.exists("config") then
        fs.delete("config")
    end

    if fs.exists("utils") then
        fs.delete("utils")
    end
    -- GET PASTEBIN --
    shell.run("pastebin get "..startup_link.." startup")
    shell.run("pastebin get "..config_link.." config")
    shell.run("pastebin get "..utils_link.." utils")
end

-- IMPORT DEPS --
function update_import()
    config = require("config")
    utils = require("utils")
end

local version, client_list, limits, peripheral_number, i, name
local event, side, channel, replyChannel, message, distance

-- SETUP CONFIG -- 
function setup_config()
    version, client_list, limits, peripheral_number = config.get_clients()
end

update_pastebin()
update_import()

m = peripheral.find("monitor")
names = peripheral.getNames()
detectors = {}
mX, mY = m.getSize()
local total_client = config.load_total()

utils.clear(m)
m.setTextScale(1)

function scan_network()
    for i, name in pairs(names) do
        if string.find(name, "energyDetector_") then
            number = tonumber(string.match(name, "%d+"))
            client_found = false
            detector = peripheral.wrap(name)
            for j, client in pairs(client_list) do
                if number == peripheral_number[client] then
                    detectors[client] = detector
                    client_found = true
                    detector.setTransferRateLimit(limits[client])
                end
            end
            if client_found == false then
                detector.setTransferRateLimit(0)
            end
        else if name == "top" then
            modem = peripheral.find("modem") or error("No modem attached", 0)
            modem.open(66)
        else if name == "left" then
            printer = peripheral.find("printer") or error("No printer attached", 0)
            modem.open(68)
        end
        end
        end
    end
end

function check_data()
    local counter = 0
    while true do
        current_line = 1
        utils.draw_text(m, 1,current_line, "Client -> Live Conso    |         Conso %age         |   Limits   | Total", colors.gray, colors.lightBlue, mX)
        for i, client in pairs(client_list) do
            current_line = current_line+2
            if detectors[client] == nil then
                energy_flow = 0
                energy_limit = 0
            else
                energy_flow = detectors[client].getTransferRate()
                energy_limit = detectors[client].getTransferRateLimit()
            end

            total_client[client] = total_client[client] + energy_flow

            percent = math.floor((energy_flow/energy_limit)*100)
            utils.progress_bar(m,mX/2-9,current_line,mX/4, energy_flow, energy_limit, utils.get_percent_color(percent), colors.gray)

            local multiplier = ""
            multiplier, energy_flow = utils.get_rf_flow(energy_flow)
            local display = client .. " -> " .. energy_flow .. " "..multiplier
            utils.draw_text(m, 1, current_line, display, config.get_client_color(client), colors.black, mX/2-14)
            utils.draw_text(m, mX/2-16,current_line, "| "..percent.."%", colors.white, colors.black, 4)

            multiplier, energy_limit = utils.get_rf_flow(energy_limit)
            display = "| "..energy_limit.." "..multiplier
            utils.draw_text(m, (mX/2-9)+(mX/4)+2, current_line, display, colors.white, colors.black, 11)
            
            multiplier, energy_total = utils.get_rf_flow(total_client[client])
            display = "| "..energy_total.." "..multiplier
            utils.draw_text(m, (mX/2-9)+(mX/4)+15, current_line, display, colors.white, colors.black, 20)
        end
        counter = counter + 1
        if counter == 20 then
            total_client = config.update_total(total_client)
            counter = 0
        end
    end
end

function pull_events()
    repeat
        event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
    until channel == 66
    update_pastebin()
    update_import()
    total_client = config.update_total(total_client)
end

function pull_event_print()
    repeat
        event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
    until channel == 68
    total_client = config.update_total(total_client)
    
    ink = printer.getInkLevel()
    paper = printer.getPaperLevel()
    if ink > 0 and paper > 0 then
        printer.newPage()
        printer.setCursorPos(1,1)
        printer.write("Conso par client EDF.")
        printer.setPageTitle("CONSO EDF - CONFIDENTIEL")
        for i, client in pairs(client_list) do
            printer.setCursorPos(1,i+2)
            printer.write(client..": "..total_client[client].."RF")
        end
        printer.endPage()
    else
        print("Cannot print")
    end
end

setup_config()
scan_network()
term.clear()
term.setCursorPos(1,1)
term.setTextColor(colors.red)
term.write("Currently running EDF V"..version)
term.setCursorPos(1,2)
parallel.waitForAny(check_data, pull_events, pull_event_print)
shell.run("reboot")
