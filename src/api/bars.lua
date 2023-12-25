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
        print("bar: " .. name)
        fill(data)
    end
end

function set(name, key, val)
    if not bar[name] then
        return
    end
    bar[name][key] = val
end

function drawLine(x, y, length, color)
    local oldBgColor = monitor.getBackgroundColor() -- Get the current background color
    monitor.setBackgroundColor(color)               -- Set the background color to the color
    for i = x, (length + x) do                      -- Start a loop starting at x and ending when x gets to x + length
        monitor.setCursorPos(i, y)                  -- Set the cursor position to i, y
        monitor.write(" ")                          -- Write that color to the screen
    end
    monitor.setBackgroundColor(oldBgColor)          -- Reset the background color
end

function fill(data)
    local minX = data["xmin"]
    local minY = data["ymin"]
    local maxX = data["xmax"]
    local maxY = data["ymax"]
    local current = (data["cur"] * 100) / data["max"]
    local mode = data["typ"]
    local emptyColor = data["clempty"]
    local fillColor = data["clfill"]
    print("current: " .. current)
    local totalLength = maxX - minX
    local fillLength = math.floor((totalLength * current) / 100)

    if mode == "hor" then
        -- Horizontal mode
        -- Draw the empty part
        drawLine(minX, minY, totalLength, emptyColor)

        -- Draw the filled part
        drawLine(minX, minY, fillLength, fillColor)
    elseif mode == "ver" then
        -- Vertical mode
        -- Calculate the total height and the filled height
        local totalHeight = maxY - minY
        local fillHeight = math.floor((totalHeight * current) / 100)

        -- Draw the empty part
        for y = minY, maxY do
            drawLine(minX, y, totalLength, emptyColor)
        end

        -- Draw the filled part
        if current > 0 then
            for y = minY, (fillHeight + minY) do
                drawLine(minX, y, totalLength, fillColor)
            end
        end
    end
end
