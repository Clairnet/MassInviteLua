local js = panorama.open()
local FriendsAPI = js.FriendsListAPI
local partyAPI = js.PartyBrowserAPI
local collectedSteamIDS = {}
local function table_contains(tbl, val)
    for i=1,#tbl do
        if tbl[i] == val then
            return true
        end
    end
    return false
end
local refresh = false
local function refresh_nearbies()
    client.delay_call(5, refresh_nearbies)
    if not refresh then 
        return
    end
        partyAPI.Refresh();
        local lobbies = partyAPI.GetResultsCount();
        for i=1, partyAPI.GetResultsCount() do
            local xuid = partyAPI.GetXuidByIndex(i-1)
            if not table_contains(collectedSteamIDS, xuid) then
                table.insert(collectedSteamIDS, xuid)
                js["$"].Msg("Adding ".. xuid .." to the collection.");
            end
        end
        js["$"].Msg("Mass invite collection: " .. #collectedSteamIDS)
end
refresh_nearbies()
local auto_refresh_nearbies = ui.new_checkbox("lua", "a", "Auto refresh nearbies")
ui.set_callback(auto_refresh_nearbies, function(self)
    refresh = ui.get(self)
end)
ui.new_button("lua", "a", "Refresh nearbies", function()

        partyAPI.Refresh();
        local lobbies = partyAPI.GetResultsCount();
        for i=1, partyAPI.GetResultsCount() do
            local xuid = partyAPI.GetXuidByIndex(i-1)
            if not table_contains(collectedSteamIDS, xuid) then
                table.insert(collectedSteamIDS, xuid)
                js["$"].Msg("Adding ".. xuid .." to the collection.");
            end
        end
        js["$"].Msg("Mass invite collection: " .. #collectedSteamIDS) 
end)
ui.new_button("lua", "a", "Mass invite nearbies", function()
    
    for i=0,#collectedSteamIDS do    
        FriendsAPI.ActionInviteFriend(collectedSteamIDS[i], "");
    end
end)
ui.new_button("lua", "a", "Print invite collection", function()
    
        js["$"].Msg(collectedSteamIDS);
    
end)
ui.new_button("lua", "a", "Invite all friends", function()
    local friends = FriendsAPI.GetCount();
    for id = 0,friends,1 do
        local xuid = FriendsAPI.GetXuidByIndex(id)
        FriendsAPI.ActionInviteFriend(xuid, "")
        id = id + 1
    end
end)
