---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Srendi.
--- DateTime: 01.05.2021 23:47
---

-- Some shit I worked on in the past
-- Does not have any usage currently

function wrapPs(peripheralName)
    periTab={}
    sideTab={}
    if peripheralName==nil then
        print("Could not find".. peripheralName)
    end
    local peripherals = peripheral.getNames()
    local i2 = 1
    for i =1, #peripherals do
        if peripheral.getType(peripherals[i])==peripheralName then
            periTab[i2]=peripheral.wrap(peripherals[i])
            sideTab[i2]=peripherals[i]
            i2=i2+1
        end
    end
    if periTab~={} then
        return periTab,sideTab
    else
        return nil
    end
end

computers = wrapPs("computer")

computerList = {
    me = {name="mecpu", label="Me CPUs", computer=nil}
}

monitor = peripheral.wrap("top")

local label = "Cliff OS"
local monX, monY

function prepareComputers()
    for k, v in pairs(computers) do
        for k1, v1 in pairs(computerList) do
            if v.getLabel() == v1.name then
                print(v1.label)
                v1.computer = v
            end
        end
    end
end

function prepareMonitor()
    monitor.clear()
    monX, monY = monitor.getSize()
    monitor.setTextColor(colors.white)
    monitor.setBackgroundColor(colors.black)
    monitor.setCursorPos((monX/2)-(#label/2),1)
    monitor.setTextScale(1)
    monitor.write(label)
    monitor.setCursorPos(1,1)
end

function clear(xMin,xMax, yMin, yMax)
    monitor.setBackgroundColor(colors.black)
    for xPos = xMin, xMax, 1 do
        for yPos = yMin, yMax, 1 do
            monitor.setCursorPos(xPos, yPos)
            monitor.write(" ")
        end
    end
end

prepareComputers()
prepareMonitor()

while true do
    sleep(0.5)
    table.sort(computerList)
    for k, v in pairs(computerList) do
        --local k, v = computerList[i], computerList[i]
        local y = 3*1
        print(k, v)
        clear(1, monX, 3, monY)
        monitor.setTextColor(colors.white)
        monitor.setCursorPos(3, y)
        monitor.write(v.label ..".. ")
        if computer == nil then
            monitor.setTextColor(colors.red)
            monitor.write("Could not found")
        else
            monitor.setTextColor(v.computer.isOn() and colors.green or colors.red)
            monitor.write(v.computer.isOn() and "Online" or "Offline")
        end
    end
end