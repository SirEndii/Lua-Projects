---
--- Made for the Advanced Peripherals documentation - Can be used in production
--- Created by Srendi - https://github.com/SirEndii
--- DateTime: 24.12.2023 (No)
--- Link: tbd
---

mon = peripheral.find("monitor")
me = peripheral.find("meBridge")

data = {
    drives = 0,
    totalBytes = 0,
    usedBytes = 0,
    totalCells = 0,
}

local label = "ME Drives"

local monX, monY

os.loadAPI("medrives/api/bars.lua")

function prepare()
    mon.clear()
    monX, monY = mon.getSize()
    if monX < 38 or monY < 25 then
        error("Monitor is too small, we need a size of 39x and 26y minimum.")
    end
    mon.setPaletteColor(colors.red, 0xba2525)
    mon.setBackgroundColor(colors.black)
    mon.setCursorPos((monX/2)-(#label/2),1)
    mon.setTextScale(1)
    mon.write(label)
    mon.setCursorPos(1,1)
    drawBox(2, monX - 1, 3, monY - 10, "Drives", colors.gray, colors.lightGray)
    drawBox(2, monX - 1, monY - 8, monY - 1, "Stats", colors.gray, colors.lightGray)
    addBars()
end

function addBars()
    drives = me.listDrives()
    data.drives = #drives
    for i=1, #drives do
        x = 3*i
        full = drives[i].totalBytes
        print(full)
        print(drives[i].usedBytes)
        bars.add(""..i,"ver", full, drives[i].usedBytes, 1+x, 5, 1, monY - 16, colors.red, colors.green)
        mon.setCursorPos(x+1, monY - 11)
        --mon.write(string.format(i))
        data.totalBytes = data.totalBytes + drives[i].totalBytes
        data.usedBytes = data.usedBytes + drives[i].usedBytes
        data.totalCells = data.totalCells + #drives[i].cells
    end
    bars.construct(mon)
    bars.screen()
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

function clear(xMin,xMax, yMin, yMax)
    mon.setBackgroundColor(colors.black)
    for xPos = xMin, xMax, 1 do
        for yPos = yMin, yMax, 1 do
            mon.setCursorPos(xPos, yPos)
            mon.write(" ")
        end
    end
end

function getUsage()
    return (data.usedBytes * 100) / data.totalBytes
end

function comma_value(n) -- credit http://richard.warburton.it
    local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
    return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end

function roundToDecimal(num, decimalPlaces)
    local mult = 10^(decimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

function updateStats()
    newDrives = me.listDrives()
    data.totalBytes = 0;
    data.usedBytes = 0;
    data.totalCells = 0;

    if newDrives == nil then
        data.drives = 0
        print("The given table is nil, but why?")
        return
    end

    if newDrives == nil or #newDrives == 0 then
        clear(3,monX - 3,4,monY - 12)
        mon.setCursorPos(4, 5);
        mon.write("Zero drives are better than -1 drives I guess")
    else 
        for i=1, #newDrives do
            data.totalBytes = data.totalBytes + newDrives[i].totalBytes
            data.usedBytes = data.usedBytes + newDrives[i].usedBytes
            data.totalCells = data.totalCells + #newDrives[i].cells

            bars.set(""..i,"cur", newDrives[i].usedBytes)
            bars.set(""..i,"max", newDrives[i].totalBytes)
        end
    end
    bars.screen()

    clear(3,monX - 3,monY - 5,monY - 2)
    print("Drives: ".. data.drives)
    mon.setCursorPos(4,monY-6)
    mon.write("Drives: ".. data.drives)
    mon.setCursorPos(4,monY-5)
    mon.write("Full: ".. roundToDecimal(getUsage(), 2) .."%")
    mon.setCursorPos(4,monY-4)
    mon.write("Cells: ".. data.totalCells)
    mon.setCursorPos(4,monY-3)
    mon.write("Bytes(Total|Used):")
    mon.setCursorPos(23,monY-3)
    mon.write(comma_value(data.totalBytes) .." | ".. comma_value(data.usedBytes))

    if data.drives ~= #newDrives then
        clear(3,monX - 3,4,monY - 12)
        mon.setCursorPos(4, 5);
        mon.write("Found new Drive... Rebooting")
        shell.run("reboot")
    end
end

prepare()

while true do
    updateStats()
    sleep(0.5)
end
