local utils = {}
function utils.clear(m)
    m.setBackgroundColor(colors.black)
    m.clear()
    m.setCursorPos(1,1)
end

function utils.draw_text(m, x, y, text, text_color, bg_color, length)
    text = tostring(text)
    if length == nil then length = #text end
    m.setBackgroundColor(bg_color)
    m.setCursorPos(x,y)
    m.setTextColor(bg_color)
    m.write(string.rep(" ", length))
    m.setCursorPos(x,y)
    m.setTextColor(text_color)
    m.write(text)
end

function utils.draw_line(m, x, y, length, color)
    m.setBackgroundColor(colors.black)
    m.setCursorPos(x,y)
    m.write(string.rep(" ", length))
    m.setBackgroundColor(color)
    m.setCursorPos(x,y)
    m.write(string.rep(" ", length))
end

function utils.progress_bar(m, x, y, length, minVal, maxVal, bar_color, bg_color)
    utils.draw_line(m, x, y, length+10, colors.black) --backgoround bar
    utils.draw_line(m, x, y, length, bg_color) --backgoround bar
    local barSize = math.floor((minVal/maxVal) * length) 
    utils.draw_line(m, x, y, barSize, bar_color) --progress so far
end

function utils.get_percent_color(percent)
    if percent < 25 then
        return colors.lime
    else if percent < 50 then
        return colors.yellow
    else if percent < 75 then 
        return colors.orange
    else if percent <= 100 then
        return colors.red
    else return colors.gray
    end
    end
    end
    end
end

function utils.load_file(file)
    local content = {}
    sr = fs.open(file, "r")
    if sr == nil then
        sw = fs.open(file, "w")
        sw.close()
    else
        local key, val = nil, nil
        repeat
            data_from_file = sr.readLine()
            if data_from_file ~= nil then
                if string.match(data_from_file, "key:") then
                    key = utils.split(data_from_file, ":")[2]
                else if string.match(data_from_file, "val:") then
                    val = utils.split(data_from_file, ":")[2]
                end
                end
                if key ~= nil and val ~= nil then
                    content[key] = val
                    key, val = nil, nil
                end
            end

        until data_from_file==nil
        sr.close()
    end
    return content
end

function utils.update_file(file, key_val_table)
    sw = fs.open(file, "w")
    for key, val in pairs(key_val_table) do
        sw.writeLine("key:"..tostring(key))
        sw.writeLine("val:"..tostring(val))
    end
    sw.close()
    return ""
end

function utils.split (inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end

function utils.get_rf_flow(energy_flow)
 
    if energy_flow < 1000 then
    return "RF/t", energy_flow
    else if energy_flow < 1000000 then
    return "kRF/t", utils.round(energy_flow/1000,1)
    else if energy_flow < 1000000000 then 
    return "MRF/t", utils.round(energy_flow/1000000,1)
    else if energy_flow < 1000000000000 then 
    return "GRF/t", utils.round(energy_flow/1000000000,1)
    else if energy_flow < 1000000000000000 then 
    return "TRF/t", utils.round(energy_flow/1000000000000,1)
    else return "PRF/t", utils.round(energy_flow/1000000000000000,1)
    end
    end
    end
    end
    end
end

function utils.round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
  end

return utils