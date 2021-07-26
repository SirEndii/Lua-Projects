---
--- Made for the Advanced Peripherals documentation
--- Created by Srendi.
--- DateTime: 25.04.2021 20:44
--- Link: https://docs.srendi.de/peripherals/colony_integrator/
---


colony = peripheral.find("colonyIntegrator")
mon = peripheral.wrap("left")
 
function centerText(text, line, txtback, txtcolor, pos)
    monX, monY = mon.getSize()
    mon.setBackgroundColor(txtback)
    mon.setTextColor(txtcolor)
    length = string.len(text)
    dif = math.floor(monX-length)
    x = math.floor(dif/2)
    
    if pos == "head" then
        mon.setCursorPos(x+1, line)
        mon.write(text)
    elseif pos == "left" then
        mon.setCursorPos(2, line)
        mon.write(text) 
    elseif pos == "right" then
        mon.setCursorPos(monX-length, line)
        mon.write(text)
    end
end
 
function prepareMonitor() 
    mon.clear()
    mon.setTextScale(0.5)
    centerText("Citizens", 1, colors.black, colors.white, "head")
end
 
function printCitizens()
    row = 3
    useLeft = true
    for k, v in ipairs(colony.getCitizens()) do
        if row > 40 then
            useLeft = false
            row = 3
        end
        
        gender = ""
        if v.gender == "male" then
            gender = "M"
        else
            gender = "F"
        end
        
        if useLeft then
            centerText(v.name.. " - ".. gender, row, colors.black, colors.white, "left")        
        else
            centerText(v.name.. " - ".. gender, row, colors.black, colors.white, "right")
        end
        row = row+1
    end
end
 
prepareMonitor()
 
while true do
    printCitizens()
    sleep(10)
end
