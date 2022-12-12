function doTween(Object, Values, Duration, Options)
  local function quickError(txt)
    runHaxeCode('game.addTextToDebug("doTween: " + "'..txt:gsub('"', '\\"')..'", 0xFFFF0000);')
  end
  if not notfirst then
    notfirst = true
    addHaxeLibrary('FunkinLua')
    runHaxeCode([[
      function getProperty(variable:String)
      {
        var result:Dynamic = null;
              var killMe:Array<String> = variable.split('.');
              if(killMe.length > 1)
                  result = FunkinLua.getVarInArray(FunkinLua.getPropertyLoopThingWhatever(killMe), killMe[killMe.length-1]);
              else
                  result = FunkinLua.getVarInArray(FunkinLua.getInstance(), variable);
          
              return result;
      }
    ]])
  end
  local tweenNum, Options = tweenNum or 0, Options or {}
  if Options.onComplete then
    local coolTag = Object..'_TWEEN'..tweenNum
    local callBack = Options.onComplete
    runTimer(coolTag, Duration)
    local a = onTimerCompleted
    onTimerCompleted = function(tag)
      if a then
        a()
      end
      if tag == coolTag then
        callBack()
      end
    end
    Options.onComplete = nil
  end
  if Options.onStart then
    local coolTag = Object..'_TWEEN_ONSTART'..tweenNum
    local callBack = Options.onStart
    runTimer(coolTag, Options.startDelay or 0)
    local a = onTimerCompleted
    onTimerCompleted = function(tag)
      if a then
        a()
      end
      if tag == coolTag then
        callBack()
      end
    end
    Options.onStart = nil
  end
  local excludeFromStringing = {'ease'}
  local function fixType(inp)
    local cool = {
      string = function()
        return '"' .. inp:gsub('"', '\\"') .. '"'
      end,
      number = function() return tostring(inp) end,
      table = function()
        local hasStr = false
        for k,v in pairs(inp) do
          if type(k) == 'string' then
            hasStr = true
          end
        end
        for k,v in pairs(inp) do
          if type(k) == 'number' and hasStr then
            debugPrint('mixed table and array!', inp)
            return;
          end
        end
        if hasStr then
          local final = {}
          for k,v in pairs(inp) do
            local dotStuff = stringSplit(k, '.')
            if #dotStuff > 1 then
              local guys = {}
              for i=1,#dotStuff-1 do
                table.insert(guys, dotStuff[i])
              end
              local ok = {}
              ok[dotStuff[#dotStuff]] = v
              doTween(Object.. '.' ..table.concat(guys, '.'), ok, Duration, Options)
            else
              local theThing = fixType(v)
              for i,thing in pairs(excludeFromStringing) do
                if thing == k then
                  theThing = v
                  if k == 'ease' then
                    theThing = 'FlxEase.' .. theThing
                  end
                end
              end
              table.insert(final, k..': '..theThing)
            end
          end
          return '{'..table.concat(final, ',')..'}'
        else
          local final = {}
          for k,v in pairs(inp) do
            table.insert(final, fixType(v))
          end
          return '['..table.concat(final, ',')..']'
        end
      end
    }
    if cool[type(inp)] then
      return cool[type(inp)]()
    end
    return tostring(inp)
  end
  --check for null object references
  if getProperty(Object) == nil then --if the object doesn't exist
    quickError('Object not found: '..Object)
    return;
  end
  local valueLength = 0
  for k,v in pairs(Values) do
    if getProperty(Object..'.'..k) == Object..'.'..k or not getProperty(Object..'.'..k) then --if a value doesn't exist
      quickError('Null object value: '..k)
      Values[k] = nil
    elseif type(getProperty(Object..'.'..k)) ~= 'number' then
      quickError('Object value not a number: '..k)
    else
      valueLength = valueLength + 1
    end
  end
  if valueLength == 0 then --if theres no values at all
    quickError('No values found!')
    return;
  end
  local swag = {Values, Duration, Options}
  for i,thing in pairs(swag) do
    swag[i] = fixType(thing)
  end
  runHaxeCode([[
    
    var obj = getProperty(]]..fixType(Object)..[[);
    if(['game', 'instance', 'playstate'].contains(]]..fixType(Object:lower())..[[))
      obj = game;
    
    game.modchartTweens.set(]]..fixType(Object..'_TWEEN'..tweenNum)..[[, FlxTween.tween(obj, ]]..table.concat(swag, ',')..[[));
    
  ]])
  if not Options.dontIncrease then
    tweenNum = tweenNum + 1
  end
end
doTween.lua
5 KB
