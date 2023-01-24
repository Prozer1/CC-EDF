local api = {}

sr = fs.open("api.txt", "r")
API_URL = sr.readLine()
sr.close()

function api.call(pc_id, file) do
    -- pc_id must be int or nil
    -- file must be e.g. /test.lua or nil
    local url = API_URL
    if pc_id not nil then
        url = url .. pc_id
    end
    if file not nil then
        url = url .. file
    end
    return http.get(url)
end

function api.get_list_pcs_id() do
    local pc_id_list = {}
    local response = api.call()
    for i, item in pairs(response) then
        local line = response.readLine()
        if string.match(line, "<a href=\"") then
            if not string.match(line, "<h1>") then
                table.insert(pc_id_list, tonumber(string.match(line, "%d+")))
            end
        end
    end
    return pc_id_list
end

return api