-- Bars API - (c) monster010

-- This program is made by monster010 - pastebin: mWcHuiKX
local monitor
local bar = {}
 
function construct(montor)
    monitor = montor
end
 
function getBars()
    return bar
end
 
function add(name, typ, maxval, curval, x, y, width, height, clfill, clempty)
    if not clfill then clfill = colors.green end
    if not clempty then clempty = colors.gray end
 
    bar[name] = {}
    bar[name]["typ"] = typ
    bar[name]["max"] = maxval
    bar[name]["cur"] = curval
    bar[name]["xmin"] = x
    bar[name]["ymin"] = y
    bar[name]["xmax"] = x + width - 1
    bar[name]["ymax"] = y + height - 1
    bar[name]["clfill"] = clfill
    bar[name]["clempty"] = clempty
end
 
function clear()
    bars = {}
end
 
function screen()
    for name, data in pairs(bar) do
        fill(name, data)
    end
end
 
function set(name, key, val)
    bar[name][key] = val
end
 
function fill(name, data)
    if data["typ"] == "hor" then
        local val = data["ymin"]
        local fill = math.floor((data["xmax"] - data["xmin"]) * (data["cur"] / data["max"]))
        
        monitor.setBackgroundColor(data["clfill"])
 
        for x = data["xmin"], data["xmax"] do
            local num = math.floor(x - data["xmin"])
            monitor.setCursorPos(x, val)
 
            if (num > fill) then
                monitor.setBackgroundColor(data["clempty"])
            end
 
            monitor.write(" ")
        end
    elseif data["typ"] == "ver" then
        local val = data["xmin"]
        local fill = math.floor((data["ymax"] - data["ymin"]) * (data["cur"] / data["max"]))
 
        monitor.setBackgroundColor(data["clfill"])
 
        for y = data["ymin"], data["ymax"] do
            local num = math.floor(y - data["ymin"])
            monitor.setCursorPos(val, y)
 
            if (num > fill) then
                monitor.setBackgroundColor(data["clempty"])
            end
 
            monitor.write(" ")
        end
    end
 
    monitor.setBackgroundColor(colors.black)
end
