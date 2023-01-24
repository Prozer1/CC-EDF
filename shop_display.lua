function update_pastebin()
    -- PASTEBIN --
    local startup_link = "pJ7f9J9v"
    local utils_link = "q420mMBY"

    -- CHECK DEPENDENCY FILES --
    if fs.exists("startup") then
        fs.delete("startup")
    end
    if fs.exists("utils") then
        fs.delete("utils")
    end
    -- GET PASTEBIN --
    shell.run("pastebin get "..startup_link.." startup")
    shell.run("pastebin get "..utils_link.." utils")
end

-- IMPORT DEPS --
function update_import()
    utils = require("utils")
end

function scan_network()
    block_reader = peripheral.find("blockReader") or error("No block Reader attached", 0)
    modem = peripheral.find("modem") or error("No modem attached", 0)
    modem.open(66)
end

function new_sales(amount)
    local file = "sales.txt"
    local sales = utils.load_file(file)
    if amount == nil then
        amount = 1
    end
    if sales["total_sold"] == nil then
        sales["total_sold"] = 0
    end
    sales["total_sold"] = sales["total_sold"] + amount
    utils.update_file(file, sales)
end

function update_current_content(new_current)
    local file = "current.txt"
    local current_db = utils.load_file(file)
    current_db["current"] = new_current
    utils.update_file(file, current_db)
end

function pull_events()
    repeat
        event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
    until channel == 66
    update_pastebin()
    update_import()
end

function main()
    local current = 0
    while true do
        local read_data = tonumber(block_reader.getBlockData()["inv_nr"])
        if current > read_data then
            new_sales(current - read_data)
        end
        update_current_content(read_data)
        sleep(1)
        current = read_data
        mon.clearLine()
        utils.draw_text(mon, mX/2, mY/2, current, colors.white, colors.black)
    end
end

local version = 1.2
update_pastebin()
update_import()

mon = peripheral.find("monitor") or error("No monitor attached", 0)
mX, mY = mon.getSize()
mon.setTextScale(1)
utils.clear(mon)

scan_network()
term.clear()
term.setCursorPos(1,1)
term.setTextColor(colors.red)
term.write("Currently running Shop Display v"..version)
term.setCursorPos(1,2)
parallel.waitForAny(main, pull_events)
shell.run("reboot")