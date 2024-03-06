---
--- Made for the Advanced Peripherals documentation - Can be used in production
--- Created by Srendi - https://github.com/SirEndii
--- DateTime: 18.12.2022 04:00
--- Link: https://docs.intelligence-modding.de/1.18/peripherals/me_bridge/
--- Modified by Samamstar
--- DateTime: 23.5.2023 03:00 MDT
---

label = "Automatic"

me = peripheral.find("meBridge") --MeBridge
mon = peripheral.find("monitor") --Monitor

--List of the items which should be checked
--Display Name - Technical Name - Minimum Amount
meItems = {
    [1] = {"Oak Planks", "minecraft:oak_planks", "180"},
    [2] = {"Diorite", "minecraft:polished_diorite", "100"},
    [3] = {"Wind Generator", "mekanismgenerators:wind_generator", "20"},
    [4] = {"Glass", "minecraft:glass", "500"},
    [5] = {"Stick", "minecraft:stick", "100"}
}

function checkMe(checkName, name, low)
    --Get item info from system
    meItem = me.getItem({name = checkName})
    --Typically caused by typo in item name
    if not meItem then
      print("Failed to locate meItem " .. checkName)
      return
    end
    if not meItem.amount then
        size = 0
    else
        size = tostring(meItem.amount)
    end
    ItemName = meItem.name
    row = row + 1
    CenterT(name, row, colors.black, colors.lightGray, "left", false)
    --Number of items in the system lower than the minimum amount?
    if tonumber(size) < tonumber(low) then
        --Craft us some delicious items
        CenterT(size .. "/" .. low, row, colors.black, colors.red, "right", true)
        --If the items is already being crafted - don't start a new crafting job
        if not me.isItemCrafting({name = checkName}) then
            --Prepare the table for "craftItem"
            craftedItem = {name = checkName, count = low - size}
            me.craftItem(craftedItem)
            print("Crafting some delicious " .. checkName .. " " .. craftedItem.count .. " times")
        end
    else
        --Everything is fine. Print the amount in green
        CenterT(size .. "/" .. low, row, colors.black, colors.green, "right", true)
    end
end

function checkTable()
    row = 2
    --Loop through our me items and check if they need to be crafted
    for i = 1, #meItems do
        checkName = meItems[i][2]
        name = meItems[i][1]
        low = meItems[i][3]
        checkMe(checkName, name, low)
    end
end

function prepareMonitor()
    mon.clear()
    CenterT(label, 1, colors.black, colors.white, "head", false)
end

--A util method to print text centered on the monitor
function CenterT(text, line, txtback, txtcolor, pos, clear)
    monX, monY = mon.getSize()
    mon.setTextColor(txtcolor)
    length = string.len(text)
    dif = math.floor(monX - length)
    x = math.floor(dif / 2)

    if pos == "head" then
        mon.setCursorPos(x + 1, line)
        mon.write(text)
    elseif pos == "left" then
        if clear then
            clearBox(2, 2 + length, line, line)
        end
        mon.setCursorPos(2, line)
        mon.write(text)
    elseif pos == "right" then
        if clear then
            clearBox(monX - length - 8, monX, line, line)
        end
        mon.setCursorPos(monX - length, line)
        mon.write(text)
    end
end

--Clear a specific area, prevents flickering
function clearBox(xMin, xMax, yMin, yMax)
    mon.setBackgroundColor(colors.black)
    for xPos = xMin, xMax, 1 do
        for yPos = yMin, yMax do
            mon.setCursorPos(xPos, yPos)
            mon.write(" ")
        end
    end
end

prepareMonitor()

while true do
    checkTable()
    --Update every 3 seconds
    sleep(1)
end
