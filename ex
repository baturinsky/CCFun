local tArgs = { ... }

function sign(num)   
  return not num and 0 or num>0 and 1 or -1
end  

function printArray(arr)
  if arr then
    for i,v in pairs(arr) do
      write(i .. "=" .. v .. " ")
    end
  end
  print("")
end

local goto, checkOverflow, dig, turn, advance

local planMatrix
local max
local min
local size
local excavating = false
local slot={junk={}, ignore={}, fuel={}}

function designate(n, type)
  print("Designate "..n.." as "..type)
  slot[n].designation = type
  table.insert(slot[type],n)
end

function plan(block)
    local ind = (block.x or 0)*100000000 + (block.y or 0)*10000 + (block.z or 0)
    planMatrix[ind] = planMatrix[ind] or {}
    return planMatrix[ind]
end


--[[
if #tArgs ~= 1 then
	print( "Usage= excavate <diameter>" )
	return
end
]]
	
up={name="up", dig=turtle.digUp, move=turtle.up, detect=turtle.detectUp, place=turtle.placeUp, attack=turtle.attackUp, dy}
forward={name="forward", dig=turtle.dig, move=turtle.forward, detect=turtle.detect, place=turtle.place, attack=turtle.attack}
down={name="down",dig=turtle.digDown, move=turtle.down, detect=turtle.detectDown, place=turtle.placeDown, attack=turtle.attackDown}

fwd = worward

local at = {x=0,y=0,z=0}
local d = {x=0,z=1}

forward.at = function()  
  return {x=at.x+d.x, y=at.y, z=at.z+d.z}
end

up.at = function()
  return {x=at.x, y=at.y+1, z=at.z}
end

down.at = function()
  return {x=at.x, y=at.y-1, z=at.z}
end

function shouldDig(block)
  if not min or not max then
    return true
  end
  return block.x>=min.x and block.x<=max.x and block.y>=min.y and block.y<=max.y and block.z>=min.z and block.z<=max.z
end

function left()
	turtle.turnLeft()
	d.x, d.z = -d.z, d.x
end

function right()
	turtle.turnRight()
  d.x, d.z = d.z, -d.x
end

function turn(to)
  x,z = sign(to.x), sign(to.z)
  if x == d.x and z == d.z then 
    return
  elseif x == -d.x and z == -d.z then
    left()
    left()
  elseif z ~= 0 then
    if z == -d.x then right() else left() end
  elseif x ~= 0 then
    if x == d.z then right() else left() end 
  end   
end 

function refuel()
  for i,n in ipairs(slot.fuel) do
    turtle.select(n)
    if turtle.refuel(1) then
      turtle.select(1)
      return true
    end
  end
  turtle.select(1)
  return false
end

function distanceToBase()
  return math.abs(at.x) + math.abs(at.y) + math.abs(at.z)
end

function checkFuel()
  if turtle.getFuelLevel()<10 then
    while not refuel() do
      print("Need fuel...")
      if not slot[1].designation then
        designate(1,"fuel")
      end
      sleep(3)
    end
  end
end

function move(dir)
  checkFuel()
  if dir.move() then
    at = dir.at()
    return true
  else
    return false
  end
end

function disposeJunk()
  for i,n in ipairs(slot.junk) do
    if turtle.getItemCount(n) >60 then
      turtle.select(n)
      turtle.drop(turtle.getItemCount(n)-1)
    end
  end
end

function dig(dir)
  local result = true
  if shouldDig(dir.at()) then
    turtle.select(5)
    result = dir.dig()
    disposeJunk()
    checkOverflow()
    return result
  end  
end

function advance(dir, steps)
  if steps == nil then 
    steps = 1 
  end  
  for step = 1,steps do
    while not move(dir) do
      if dir.detect() then
        if not dig(dir) then
          print("oops")
          return false
        end
      elseif not dir.attack() then
        sleep(0.5)
      end
    end	
  end
end 

function goto(to) 
  to = {x=to.x or 0,y=to.y or 0,z=to.z or 0}
  if to.y>at.y then
    advance(up, to.y-at.y)
  elseif to.y<at.y then
    advance(down, at.y-to.y)
  end
  
  if to.x ~= at.x then
    turn({x=to.x-at.x})
    advance(forward, math.abs(to.x-at.x))
  end  
  if to.z ~= at.z then
    turn({z=to.z-at.z})
    advance(forward, math.abs(to.z-at.z))
  end
end

function moveDir(to)
  if to.y then
    advance(to.y>0 and up or down, math.abs(to.y))
  else
    turn(to)
    advance(forward, math.abs(to.x or to.z))
  end
end

function dropLoot()
  local stoppedAt = {x=at.x, y=at.y, z=at.z}
  goto({})
  turn({z=-1})
  for n=1,16 do
    turtle.select(n)
    if slot[n].designation then
      if slot[n].designation ~= "fuel" then
        turtle.drop(turtle.getItemCount(n)-1)
      end
    else
      turtle.drop()
    end
  end
  turtle.select(1)
  goto(stoppedAt)
  return true
end

function checkOverflow()
  if not excavating then
    return
  end
  if turtle.getItemCount(16)==0 then
    return false
  end  
  excavating = false
  dropLoot()
  excavating = true
  return true
end

function makePlan()  
  planMatrix = {}
  local layer1 = max.y - (math.fmod(size.y,3)==0 and 1 or 0)
  local evenLayer = true
  local y = layer1
  local widthIsEven = math.fmod(size.x,2)==0
  if(layer1<max.y) then
    plan({y=max.y}).dir={y=-1}
  end
  while y>=min.y do
    for x=min.x,max.x do
      local zDir = (evenLayer == (math.fmod(x-min.x, 2)==0)) and 1 or -1
      for z=min.z,max.z do
        plan({x=x,y=y,z=z}).dir = {z=zDir}
      end      
      plan({x=x,y=y,z=(zDir==1 and max.z or min.z)}).dir = {x=evenLayer and 1 or -1}
    end
    local finishAt = {}
    finishAt.x = evenLayer and max.x or min.x
    finishAt.z = widthIsEven and min.z or (evenLayer and max.z or min.z)    
    finishAt.y = y
    
    if(y-2>=min.y) then
      for descent=0,2 do
        --printArray({x=finishAt.x,y=finishAt.y-descent, z=finishAt.z})
        plan({x=finishAt.x,y=finishAt.y-descent, z=finishAt.z}).dir = {y=-1}
      end
    else
      plan(finishAt).dir = nil
    end
    y = y - 3
    evenLayer = not evenLayer
  end
end

function digAround()
  dig(up)
  dig(down)
end

function main()
  arg = {}

  local command = tArgs[1] or ""

  for argbit in string.gmatch(command, '%a[%d-]*') do
    argletter = string.sub(argbit,1,1)
    argnum = string.sub(argbit,2)
    arg[argletter] = tonumber(argnum)
  end

  local commands = {
    back = function() turn({z=-1}) end,
    right = function() turn({x=1}) end,
    left = function() turn({x=-1}) end,
    fuel = function() print("Fuel: " .. turtle.getFuelLevel()) end,
  }

  for n=1,16 do
    slot[n] = {}
    if turtle.getItemCount(n) > 0 then
      turtle.select(n)
      if n<=4 then      
        if turtle.getItemCount(n)>1 then
          designate(n,"fuel")
        end
      elseif n<=8 then
        designate(n,"junk")
      --elseif n<=12 then
      --  designate(n,"skip")
      end
    end
  end  
  
  if commands[command] then
    commands[command]()
  elseif arg.x or arg.y or arg.z then
    goto(arg)
  else
    print("Fuel: " .. turtle.getFuelLevel())

    max = {x=(arg.r or 1) - 1, y=(arg.u or 1) - 1, z=(arg.f or 1) - 1}
    min = {x=-(arg.l or 1) + 1, y=-(arg.d or 1) + 1, z=-(arg.b or 1) + 1}
    size = {x=max.x-min.x+1, y=max.y-min.y+1, z=max.z-min.z+1}

    excavating = true
    makePlan()  
    goto({x=min.x, z=min.z, y=max.y})
    digAround()
    while(plan(at).dir) do
      moveDir(plan(at).dir)
      digAround()
    end
    print("End plan")
    goto({})
    dropLoot()
  end
end

main()