m = peripheral.wrap("top")
while true do
    local event, side, xPos, yPos = os.pullEvent("monitor_touch")

    if xPos then 
        local modem = peripheral.find("modem") or error("No modem attached", 0)
        -- Send our message
        modem.transmit(66, 1, "Update")
    end
end