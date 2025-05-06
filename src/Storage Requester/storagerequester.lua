---
--- Made for the Advanced Peripherals documentation - Can be used in production
--- Created by Srendi - https://github.com/SirEndii
--- Link: https://docs.advanced-peripherals.de/0.7-bridges/guides/storage_system_functions/
---

label = "Requester"

bridge = peripheral.find("me_bridge") or peripheral.find("rs_bridge") --Bridge
mon = peripheral.find("monitor") --Monitor

--List of the resources which should be checked
--Display Name - Resource Name - Minimum Amount
resources = {
    {name = "Mek Hydrogen", rn =  "mekanism:hydrogen", min = 6000, type = "chemical"},
    {name = "Stick", rn = "minecraft:stick", min = 100, type = "item"},
    {name = "Stone", rn = "minecraft:stone", min = 64, type = "item"},
    {name = "Sign", rn = "minecraft:oak_sign", min = 64, type = "item"},
    {name = "Planks", rn = "minecraft:oak_planks", min = 128, type = "item"}
}

function checkMe(toCraft)
    --Get item info from system
    isCraftable = bridge.isCraftable({name = toCraft.rn, type = toCraft.type})
    --Typically caused by typo in item name
    if not isCraftable then
        print("Is not craftable " .. toCraft.rn)
        return
    end

    local resource = nil

    if toCraft.type == "item" then
        resource = bridge.getItem({name = toCraft.rn, type = toCraft.type})
    elseif toCraft.type == "fluid" then
        resource = bridge.getFluid({name = toCraft.rn, type = toCraft.type})
    elseif toCraft.type == "chemical" then
        resource = bridge.getChemical({name = toCraft.rn, type = toCraft.type})
    end

    if not resource then
        size = 0
    else
        size = resource.count
    end
    row = row + 1
    local currentlyCrafting = 0
    local isCrafting = bridge.isCrafting({name = toCraft.rn, type = toCraft.type})

    if isCrafting then
        for k, v in ipairs(bridge.getCraftingTasks()) do
            local crafting = v.resource
            if crafting.name == toCraft.rn then
                -- This means that the crafted amount couldn't be calculated
                if (v.crafted == -1) then
                    currentlyCrafting = currentlyCrafting + v.quantity
                else 
                    currentlyCrafting = currentlyCrafting + (v.quantity - v.crafted)
                end
            end
        end
    end

    centerT(toCraft.name, row, 0, colors.lightGray, "left", false, 0)
    --Number of items in the system lower than the minimum amount?
    if size < toCraft.min then
        --Craft us some delicious items
        printResource(size, toCraft.min, row, currentlyCrafting)
        --If the items is already being crafted - don't start a new crafting job
        if not isCrafting then
            --Prepare the table for "craftItem"
            local filter = {name = toCraft.rn, count = toCraft.min - size}
            if toCraft.type == "item" then
                bridge.craftItem(filter)
            elseif toCraft.type == "fluid" then
                bridge.craftFluid(filter)
            elseif toCraft.type == "chemical" then
                bridge.craftChemical(filter)
            end
            print("Crafting some delicious " .. toCraft.rn .. " " .. filter.count .. " times")
        end
    else
        --Everything is fine. Print the amount in green
        printResource(size, toCraft.min, row, currentlyCrafting)
    end
end

function checkTable()
    --Loop through our bridge items and check if they need to be crafted
    row = 4
    for i = 1, #resources do
        checkMe(resources[i])
    end
end

function prepareMonitor()
    mon.clear()
    monX, monY = mon.getSize()
    centerT(label, 1, 0, colors.white, "head", false, 0)

    drawBox(2, monX - 1, 3, monY -1, "To Craft", colors.gray, colors.lightGray)
end

--A util method to print text centered on the monitor
function centerT(text, line, xOffset, txtcolor, pos, clear, extraClearChars)
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
            clearBox(2, 4 + extraClearChars + length + xOffset, line, line)
        end
        mon.setCursorPos(4 + xOffset, line)
        mon.write(text)
    elseif pos == "right" then
        if clear then
            clearBox(monX - extraClearChars - length + xOffset, monX - 2, line, line)
        end
        mon.setCursorPos(monX - length - 2 + xOffset, line)
        mon.write(text)
    end
end

function printResource(size, min, row, currentlyCrafting) 
    if size < min and currentlyCrafting <= 0 then
        centerT(tostring(size) .. "/" .. tostring(min), row, 0, colors.red, "right", true, 8)
    elseif size < min and currentlyCrafting > 0 then
        centerT(tostring(size) .. "/" .. tostring(min), row, -(string.len(tostring(currentlyCrafting))+2), colors.red, "right", true, 6)
        centerT(" +" .. tostring(currentlyCrafting), row, 0, colors.blue, "right", true, 0)
    elseif size >= min and currentlyCrafting <= 0 then
        centerT(tostring(size) .. "/" .. tostring(min), row, 0, colors.green, "right", true, 8)
    elseif size >= min and currentlyCrafting > 0 then
        centerT(tostring(size) .. "/" .. tostring(min), row, -(string.len(tostring(currentlyCrafting))+2), colors.green, "right", true, 6)
        centerT(" +" .. tostring(currentlyCrafting), row, 0, colors.blue, "right", true, 0)
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

function drawBox(xMin, xMax, yMin, yMax, title, bcolor, tcolor)
    mon.setBackgroundColor(bcolor)
    for xPos = xMin, xMax, 1 do
        mon.setCursorPos(xPos, yMin)
        mon.write(" ")
    end
    for yPos = yMin, yMax, 1 do
        mon.setCursorPos(xMin, yPos)
        mon.write(" ")
        mon.setCursorPos(xMax, yPos)
        mon.write(" ")

    end
    for xPos = xMin, xMax, 1 do
        mon.setCursorPos(xPos, yMax)
        mon.write(" ")
    end
    mon.setCursorPos(xMin+2, yMin)
    mon.setBackgroundColor(colors.black)
    mon.setTextColor(tcolor)
    mon.write(" ")
    mon.write(title)
    mon.write(" ")
    mon.setTextColor(colors.white)
end

prepareMonitor()

while true do
    checkTable()
    sleep(1)
end
