local api = {}

sr = fs.open("api.txt", "r")
API_URL = sr.readLine()
sr.close()

function api.call(pc_id, file)
    -- pc_id must be int or nil
    -- file must be e.g. /test.lua or nil
    local url = API_URL
    if pc_id ~= nil then
        url = url .. pc_id
    end
    if file ~= nil then
        url = url .. file
    end
    return http.get(url)
end

function api.get_list_pcs_id()
    local pc_id_list = {}
    local response = api.call()
    while true do
        local line = response.readLine()
        if line == nil then
            break
        end
        if string.match(line, "<a href=\"") then
            if not string.match(line, "<h1>") then
                table.insert(pc_id_list, tonumber(string.match(line, "%d+")))
            end
        end
    end
    return pc_id_list
end
return api