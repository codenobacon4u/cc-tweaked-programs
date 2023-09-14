local treeTags = { ["minecraft:logs"] = true }
local saplingTags = { ["minecraft:samplings"] = true }
local fuelLimitMin = 2
local fuelLimitMax = 16
local fuelSlot = 0
local logSlot = 1
local saplingSlot = 2
local bonemealSlot = 2

function blockEquals(tags)
    local isBlock, data = turtle.inspect()
    if isBlock then
        for t in tags do
            if (data.tags[t] ~= nil) then
                return true
            end
        end
    end
    return false
end

-- Call this when facing the tree direction
function waitForLog()
    while (!blockEquals(treeTags)) do
        --maybe apply bonemeal if possible?
        turtle.select(bonemealSlot)
        if (turtle.getItemCount(bonemealSlot) ~= 0) then
            turtle.place()
        else
            turtle.turnRight()
            turtle.suck()
            turtle.turnLeft()
            turtle.place()
        end
        sleep(1)
    end
end

function refuel()
    turtle.select(fuelSlot)
    if (turtle.getItemCount() == 0) then
        print("Getting more fuel")
        turtle.suckDown()
    end
    if (turtle.getFuelLevel() < fuelLimitMin) then
        print("Refueling")
        turtle.refuel(fuelLimitMax - turtle.getFuelLevel())
    end
end

function minePass()
    local y = 0
    turtle.select(logSlot)
    turtle.dig()
    turtle.forward()
    turtle.suck()
    while (turtle.detectUp() and blockEquals(treeTags)) do
        turtle.digUp()
        turtle.suckUp()
        turtle.up()
        y = y + 1
    end
    while y > 0 do
        turtle.down()
        y = y - 1
    end
    turtle.back()
    turtle.turnRight()
    turtle.turnRight()
    turtle.select(logSlot)
    turtle.drop()
    turtle.select(saplingSlot)
    turtle.dropUp()
    turtle.turnRight()
    turtle.turnRight()
end

-- main loop
while true do
    refuel()
    if (!blockEquals(saplingTags)) then
        print("Planting Sapling!")
        turtle.select(saplingSlot)
        turtle.place()
    end
    print("Waiting for tree to grow")
    waitForLog()
    print("Tree grown, farming...")
    minePass()
    print("Farming complete!")
end
