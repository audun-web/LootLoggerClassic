
-- starter databasen

LootLoggerClassicDB = LootLoggerClassicDB or {}
LootLoggerClassicDB.loot = LootLoggerClassicDB.loot or {}


-- funksjon som henter informasjon om item og spiller og lagrer i databasen
local function AddLootEntry(itemLink, quantity)

    local time = date("%H:%M:%S")
    local today = date("%Y-%m-%d")
    local zone = GetZoneText()

    local entry = {
        item = itemLink,
        quantity = quantity,
        time = time,
        date = today,
        zone = zone
    }

    table.insert(LootLoggerClassicDB.loot, entry)

    print("Loot logged:", itemLink, "x"..quantity)

end


function GetTotalItemsLooted()

    local total = 0

    for i, entry in ipairs(LootLoggerClassicDB.loot) do
        total = total + (entry.quantity or 1) -- legger til en eller total menge items lootet in i total
    end

    return total
end

LootLoggerClassic_AddLootEntry = AddLootEntry