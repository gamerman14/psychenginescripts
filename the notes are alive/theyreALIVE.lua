--stuff you can change
movementSpeed = {5, 10} --min, max
rotationSpeed = {1, 5} --min, max ALSO

--the scriptyyyy

movement = {
  STATIC = 0, --not moving
  MOVING = 1, --moving in the current direction
  ROTATING = 2, --rotating in a random direction
  MOVING_ROTATING = 3 --moving + rotating
}
directions = { --if you cant under stand this...... its okay :))))
  LEFT = 0,
  RIGHT = 1
}
angleOffsets = { --offsets cause notse are different directions if you havent noticed yet
  180,
  90,
  -90,
  0
}
notes = {}
function onCreatePost()
  luaDebugMode = true
  for i=1,4 do
    local dumbOffset = angleOffsets[i % 4] or 0
    notes[i] = {
      movement = movement.STATIC,
      direction = getRandomInt(0, 1),
      speed = 1,
      rotSpeed = 1,
      newMovement = function()
        notes[i].speed = getRandomFloat(movementSpeed[0], movementSpeed[1])
        notes[i].rotSpeed = getRandomFloat(rotationSpeed[0], rotationSpeed[1])
        notes[i].movement = getRandomInt(0, 3)
      end,
      setProperty = function(who, what)
        setPropertyFromGroup('strumLineNotes', i-1, who, what)
      end,
      getProperty = function(who)
        return getPropertyFromGroup('strumLineNotes', i-1, who)
      end,
      movementCountdown = 9999,
      angleOffset = dumbOffset
    }
  end
end
function onSongStart()
  for i,note in pairs(notes) do
    note.movementCountdown = 1
  end
end
whatToDo = {
  [movement.STATIC] = function(note) 
    
  end,
  [movement.MOVING] = function(note)
    local meAngle = (note.getProperty('angle') + note.angleOffset)
    while meAngle >= 360 do --the first time while has ever been used in a psych engine script for something other than crashing the game
      meAngle = meAngle - 360
    end
    while meAngle < 0 do
      meAngle = meAngle + 360
    end
    meAngle = meAngle * math.pi/180
    note.setProperty('x', note.getProperty('x') + math.cos(meAngle) * note.speed)
    note.setProperty('y', note.getProperty('y') + math.sin(meAngle) * note.speed)
    if note.getProperty('x') > screenWidth then
      note.setProperty('x', 0)
    elseif note.getProperty('x') < 0 then
      note.setProperty('x', screenWidth)
    end
    if note.getProperty('y') > screenHeight then
      note.setProperty('y', 0)
    elseif note.getProperty('y') < 0 then
      note.setProperty('y', screenHeight)
    end
  end,
  [movement.ROTATING] = function(note)
    note.setProperty('angle', note.getProperty('angle') + ((note.direction == directions.LEFT) and -note.rotSpeed or note.rotSpeed))
  end,
  [movement.MOVING_ROTATING] = function(note)
    whatToDo[movement.MOVING](note)
    whatToDo[movement.ROTATING](note)
  end
}
function onUpdate(e)
  for i,note in pairs(notes) do
    note.movementCountdown = note.movementCountdown - 1
    if note.movementCountdown <= 0 then
      note.newMovement()
      note.movementCountdown = 100    
    end
    if whatToDo[note.movement] then
      whatToDo[note.movement](note)
    end
  end
end