Mayo78
#7878

💜 Rodney, Just a lua Scripter 💙 — 12/05/2022 7:07 PM
By the looks of it
🤨 guh? — 12/05/2022 7:08 PM
Also you can tween x and y at the same time
💜 Rodney, Just a lua Scripter 💙 — 12/05/2022 7:08 PM
@Mayo78 will you do noteTween?
:OldShadowTroll: :OldShadowTroll: :OldShadowTroll:
lua person :) (ping for help) — 12/05/2022 7:08 PM
i already did that lol
i have a file with a bunch of custom note tweens cuz i was bored and didn't wanna do math
💜 Rodney, Just a lua Scripter 💙 — 12/05/2022 7:08 PM
lmao
Mayo78
OP
 — 12/05/2022 7:09 PM
wait let me adjust it so that you can tween playstate variables
💜 Rodney, Just a lua Scripter 💙 — 12/05/2022 7:09 PM
Oo0
Health Tween Event is about to become obsolete (maybe)!
lua person :) (ping for help) — 12/05/2022 7:10 PM
maybe
💜 Rodney, Just a lua Scripter 💙 — 12/05/2022 7:10 PM
I said that already
lua person :) (ping for help) — 12/05/2022 7:11 PM
yes
i know
Mayo78
OP
 — 12/05/2022 7:22 PM
ok i UPDATED it so you can tween playstate vars now
function onCreatePost()
  setProperty('camZooming', true)
  doTween('game', {defaultCamZoom = 2}, 2, {ease = 'cubeInOut', onComplete = function()
    debugPrint('it done')
  end})
end
💜 Rodney, Just a lua Scripter 💙 — 12/05/2022 7:33 PM
Did you really just edit the message? That's actually pretty efficient! 
#Blue✦Colorsin | — 12/05/2022 7:42 PM
reminds me of a script that cherry made
💜 Rodney, Just a lua Scripter 💙 — 12/05/2022 7:44 PM
Didn't Cherry make the same thing as a pr? 
#Blue✦Colorsin | — 12/05/2022 7:44 PM
yeah
wait
basicly the same thing lmao 
https://discord.com/channels/922849922175340586/1032734364926218241/1032734364926218241
💜 Rodney, Just a lua Scripter 💙 — 12/05/2022 7:46 PM
What about lua vars?
:OldShadowTroll: :OldShadowTroll: :OldShadowTroll: :OldShadowTroll: :OldShadowTroll:
#Blue✦Colorsin | — 12/05/2022 7:47 PM
yeah when 
tween(game.defaultCamZoom, 2 ease.cubeInOut)
Mayo78
OP
 — 12/05/2022 7:50 PM
thats CRINGE and is in more than one function
#Blue✦Colorsin | — 12/05/2022 7:51 PM
you're cringe lmao
Mayo78
OP
 — 12/05/2022 7:51 PM
function onCreatePost()
  runHaxeCode([[
    var luaTween = new FlxSprite();
    setVar('luaTween', luaTween);
  ]])
  doTween('luaTween', {x = 6}, 2, {ease = 'cubeInOut', onComplete = function()
    debugPrint('it done')
    followThing = false
  end, onStart = function()
    followThing = true
  end})
end
theVar = 0
function onUpdate()
  if followThing then
    theVar = getProperty 'luaTween.x'
  end
end
 
💜 Rodney, Just a lua Scripter 💙 — 12/05/2022 8:01 PM
Oh... ok then.
Tiny Games — 12/05/2022 8:30 PM
doTween :keoiki:
uhhhhhhhhh — 12/05/2022 11:11 PM
How  do it? :>
!                   JustJasonLol — 12/06/2022 9:03 AM
He’s shadow Mario but better 💪
CoolingTool — 12/06/2022 10:06 AM
the goat
DragShot — 12/06/2022 5:57 PM
Very nice
:pok:
💜 Rodney, Just a lua Scripter 💙 — 12/07/2022 1:21 PM
One star left!
lua person :) (ping for help) — 12/07/2022 2:03 PM
i forgot to give star emoji one sec
done
🤨 guh? — 12/07/2022 9:10 PM
would this work with the hue of a object bc its run haxe code
lua person :) (ping for help) — 12/07/2022 9:40 PM
ok i'm definately stealing the thing where you can run a function on timer completed
huh
that seems surprisingly easy for some reason
thought it would be harder
Mayo78
OP
 — 12/09/2022 5:09 PM
small update
function onCreatePost()
  doTween('boyfriend', {x = 20, y = 0, ['scale.y'] = 0.5, NOTAREALVALUE = 12 --[[values that dont exist wont crash the game anymore]]}, 2, {ease = 'cubeInOut', 
    onStart = function() --onStart now respects startDelay
      debugPrint('hi')
    end,
    startDelay = 1
  })
  doTween('stuopid') --this prints an error too
end
function doTween(Object, Values, Duration, Options)
  local function quickError(txt)
    runHaxeCode('game.addTextToDebug("doTween: " + "'..txt:gsub('"', '\\"')..'", 0xFFFF0000);')
  end
  if not notfirst then
    notfirst = true
Expand
doTween.lua
5 KB
Mayo78
 changed the post title: 
doTween function (small update 1)
 — 12/09/2022 5:09 PM
lua person :) (ping for help) — 12/09/2022 5:13 PM
i like how the whole ass 150 lines script is just one function 
Mayo78
OP
 — 12/09/2022 5:14 PM
over half of it is just the fixtype function
lua person :) (ping for help) — 12/09/2022 5:14 PM
fr?
Mayo78
OP
 — 12/09/2022 5:14 PM
yea
lua person :) (ping for help) — 12/09/2022 5:14 PM
best file name ever to save this in
Image
it's true tho
﻿
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