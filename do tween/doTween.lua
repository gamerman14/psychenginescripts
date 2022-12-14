function doTween(Object, Values, Duration, Options)
  Options.startDelay = Options.startDelay or 0
  local function quickError(txt)
    runHaxeCode('game.addTextToDebug("doTween: " + "'..txt:gsub('"', '\\"')..'", 0xFFFF0000);')
  end
  local rh = runHaxeCode
  rh("setVar('luaVarHolder', null);")
  runHaxeCode = function(code, vars)
    if not vars then
      return rh(code)
    else
      local addedCode = ''
      setProperty('luaVarHolder', vars)
      for k,v in pairs(vars) do
        addedCode = addedCode.."var "..k.." = getVar('luaVarHolder')."..k..";\n"
      end
      rh(addedCode..'\n'..code)
      setProperty('luaVarHolder', nil)
    end
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
  local coolTag = Object..'_TWEEN'..tweenNum
  if Options.onComplete then
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
    runTimer(coolTag, Options.startDelay)
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
  -- local swag = {Values, Duration, Options}
  -- for i,thing in pairs(swag) do
  --   swag[i] = fixType(thing)
  -- end
  runHaxeCode([[
    var obj = getProperty(Object);
    if(['game', 'instance', 'playstate'].contains(ObjectLower))
      obj = game;
      
    if(Options != null && Options.ease != null)
      Options.ease = FlxEase.]]..Options.ease..[[;
    
    game.modchartTweens.set(tweenTag, FlxTween.tween(obj, Values, Duration, Options));
    
  ]], {
    Object = Object,
    ObjectLower = Object:lower(),
    Values = Values,
    Duration = Duration,
    Options = Options,
    tweenTag = coolTag
  })
end