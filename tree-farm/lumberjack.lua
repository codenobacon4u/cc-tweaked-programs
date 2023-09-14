local treeTags = "minecraft:logs"
local saplingTags = "minecraft:saplings"
local fuelLimitMin = 2
local fuelLimitMax = 16
local fuelSlot = 1
local logSlot = 2
local saplingSlot = 3
local bonemealSlot = 4

function blockEquals(dir, tag)
    local isBlock, data = turtle.inspect()
    if dir == "up" then
        isBlock, data = turtle.inspectUp()
    end
    if isBlock then 
        --print(data.tags[tag])
        if (data.tags[tag] ~= nil) then
            return true
        end
    end
    return false
end

-- Call this when facing the tree direction
function waitForLog()
    while (blockEquals("", treeTags) == false ) do
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
    print("Wait over")
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
    while (turtle.detectUp() and blockEquals("up", treeTags) == true) do
        turtle.digUp()
        turtle.suckUp()
        turtle.up()
        y = y + 1
    end
    while y > 0 do
        turtle.down()
        y = y - 1
    end
    sleep(2)
    turtle.suck()
    turtle.back()
    turtle.turnRight()
    turtle.turnRight()
    turtle.select(logSlot)
    turtle.drop()
    turtle.turnRight()
    turtle.select(saplingSlot)
    turtle.drop()
    turtle.turnRight()
end

-- main loop
while true do
    refuel()
    if (blockEquals("", saplingTags) == false) then
        print("Planting Sapling!")
        turtle.select(saplingSlot)
        if (turtle.getItemCount() == 0) then
            turtle.turnLeft()
            turtle.suck()
            turtle.turnRight()
        end
        turtle.place()
    end
    print("Waiting for tree to grow")
    waitForLog()
    print("Tree grown, farming...")
    minePass()
    print("Farming complete!")
  end
