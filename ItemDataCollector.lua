-- Define global variable for SavedVariables
ItemDataCollectorDB = {}

-- Table to store collected item data
local collectedItems = {}

-- Function to parse item stats from tooltips
local function GetItemStats(itemID)
    -- Create a fresh tooltip each time to avoid any lingering old data
    local tooltip = CreateFrame("GameTooltip", "ItemDataCollectorTooltip" .. itemID, nil, "GameTooltipTemplate")
    tooltip:SetOwner(UIParent, "ANCHOR_NONE")

    -- Clear lines to ensure no leftover data
    tooltip:ClearLines()

    -- Set the item hyperlink to the tooltip
    tooltip:SetHyperlink("item:" .. itemID)

    -- Create a table to store stats
    local stats = {}
    local lineIndex = 1

    -- Loop through all lines in the tooltip
    for i = 2, tooltip:NumLines() do
        -- Fetch left and right line texts safely
        local leftLineObj = _G["ItemDataCollectorTooltip" .. itemID .. "TextLeft" .. i]
        local rightLineObj = _G["ItemDataCollectorTooltip" .. itemID .. "TextRight" .. i]

        local leftLine = leftLineObj and leftLineObj:GetText() or ""
        local rightLine = rightLineObj and rightLineObj:GetText() or ""

        -- Store lines if they are not empty, incrementing the line index consistently
        if leftLine and leftLine ~= "" then
            stats["Line" .. lineIndex] = leftLine
            lineIndex = lineIndex + 1
        end

        if rightLine and rightLine ~= "" then
            stats["Line" .. lineIndex] = rightLine
            lineIndex = lineIndex + 1
        end
    end

    -- Clean up by hiding the tooltip
    tooltip:Hide()

    return stats
end

-- Function to check if an item is already logged
local function IsItemLogged(itemID)
    return ItemDataCollectorDB[itemID] ~= nil
end

-- Function to log item data
local function LogItemData(itemID, source)
    if not IsItemLogged(itemID) then
        -- Fetch item information
        local itemName, itemLink, quality, iLevel, reqLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(itemID)

        -- Only log items with rarity greater than 0 (excluding poor-quality items)
        if itemName and quality > 0 then
            --print("Logging item from " .. source .. ": " .. itemID .. ", " .. itemName)
            local itemStats = GetItemStats(itemID)

            local itemData = {
                entry = itemID,
                name = itemName,
                Quality = quality,
                ItemLevel = iLevel,
                RequiredLevel = reqLevel,
                class = itemType,
                subclass = itemSubType,
                maxCount = itemStackCount,
                InventoryType = itemEquipLoc,
                texture = itemTexture,
                SellPrice = itemSellPrice,
                stats = itemStats,
            }

            -- Add item data to SavedVariables
            ItemDataCollectorDB[itemID] = itemData
        end
    end
end

-- Function to save the collected data
local function SaveCollectedData()
    --print("Saving collected items to SavedVariables.")

    -- Print out or log the saved items for debugging purposes
    for id, item in pairs(ItemDataCollectorDB) do
        print(id, item.name)
    end
end

-- Event handler for collecting item data
local function OnEvent(self, event, ...)
    if event == "PLAYER_LOGIN" then
        if not ItemDataCollectorDB then
            ItemDataCollectorDB = {}
        end
    elseif event == "BAG_UPDATE" then
        -- Iterate through player's bags to find items
        for bag = 0, 4 do
            for slot = 1, GetContainerNumSlots(bag) do
                local itemID = GetContainerItemID(bag, slot)
                if itemID then
                    LogItemData(itemID, "bag")  -- Log item data from bags
                end
            end
        end
    end
end

-- Function to handle tooltip item logging
local function OnTooltipSetItem(tooltip, ...)
    local name, link = tooltip:GetItem()
    if link then
        local itemID = tonumber(link:match("item:(%d+):"))
        if itemID then
            --print("Hovering over item: " .. itemID)
            LogItemData(itemID, "tooltip")
        end
    end
end

-- Hooking GameTooltip to log items on hover
GameTooltip:HookScript("OnTooltipSetItem", OnTooltipSetItem)

-- Hook to handle item clicks in chat
local function OnSetHyperlink(link, text, button, chatFrame)
    local itemID = tonumber(link:match("item:(%d+):"))
    if itemID then
        --print("Clicked on chat item: " .. itemID)
        LogItemData(itemID, "chat")
    end
end

-- Hooking chat frame to log items on click
hooksecurefunc("SetItemRef", OnSetHyperlink)

-- Create frame and register events
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("BAG_UPDATE")
frame:SetScript("OnEvent", OnEvent)

-- Using slash command for manual saving
SLASH_ITEMDATACOLLECTOR1 = "/saveitems"
SlashCmdList["ITEMDATACOLLECTOR"] = SaveCollectedData
