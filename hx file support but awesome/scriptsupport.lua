-- hscriptName = 'uncomment if you want a custom path'
-- colors n stuff usefull!!
--_G stuff to exclude from updating the lua script variables
baseLua = {}
for k,v in pairs(_G) do
  table.insert(baseLua, k)
end
--the code
function onCreate()
  luaDebugMode = true;
  local rh = runHaxeCode
  rh("setVar('luaVarHolder', null);")
  runHaxeCode = function(code, vars, globalDefine)
    if not vars then
      return rh(code)
    else
      local addedCode = ''
      setProperty('luaVarHolder', vars)
      for k,v in pairs(vars) do
        addedCode = addedCode..(globalDefine and "" or 'var ')..k.." = getVar('luaVarHolder')."..k..";\n"
      end
      rh(addedCode..'\n'..code)
      setProperty('luaVarHolder', nil)
    end
  end
  local callbackDefine = {}
  for i,callback in pairs(callbacks) do
    callbackDefine[callback] = 'NULL'
  end
  runHaxeCode([[
    var whatever:String = '';
  ]], callbackDefine, true)
  local wasNil = false
  if hscriptName == nil then
    wasNil = true
    local idiotName = scriptName:split('/')
    hscriptName = idiotName[#idiotName]:split('.')[1]
  end
  addHaxeLibrary('FunkinLua')
  addHaxeLibrary('Type')
  addHaxeLibrary('Reflect')
  addHaxeLibrary('Lua_helper', 'llua')
  local luaFuncs = runHaxeCode([[
    return [for(i in Lua_helper.callbacks.keys()) i];
  ]])
  for i,luaFunc in pairs(luaFuncs) do
    runHaxeCode(luaFunc..' = Lua_helper.callbacks.get("'..luaFunc..'");')
  end
  runHaxeCode([[
    //cause flxcolor no work cringe!!
    Colors = {
      TRANSPARENT: 0x00000000,
      WHITE: 0xFFFFFFFF,
      GRAY: 0xFF808080,
      BLACK: 0xFF000000,

      GREEN: 0xFF008000,
      LIME: 0xFF00FF00,
      YELLOW: 0xFFFFFF00,
      ORANGE: 0xFFFFA500,
      RED: 0xFFFF0000,
      PURPLE: 0xFF800080,
      BLUE: 0xFF0000FF,
      BROWN: 0xFF8B4513,
      PINK: 0xFFFFC0CB,
      MAGENTA: 0xFFFF00FF,
      CYAN: 0xFF00FFFF
    }
    pastCreatePost = false;
  ]])
  local code = getTextFromFile(wasNil and 'hscript/'..hscriptName..'.hx' or hscriptName) --get the code file
  local lines = {} --split everything into lines to detect import lines
  for i,line in pairs(code:split('\n')) do
    if not stringStartsWith(line, 'import ') then --check for imports
      table.insert(lines, line)
    else
      local nospace = line:split()[2]:gsub(';', '') --get rid of spaces and colons
      local stuff = nospace:split('.') --get the actual modules and packages
      local ok;
      if #stuff > 1 then --see if its in a package
        ok = {}
        for i=1,#stuff-1 do
          table.insert(ok, stuff[i])
        end
      end
      addHaxeLibrary(stuff[#stuff], (ok and table.concat(ok, '.') or nil)) --finally add it

      --check if the lib you just added is actually useable
      if runHaxeCode([[
        return ]]..stuff[#stuff]..[[ == null;
      ]]) then
        callOnHaxe('luaError', {'Unknown library/Inaccessible library: ' .. stuff[#stuff] .. ' (from: '..nospace..')'})
      end
      table.insert(lines, '') --so the error messages line up
    end
  end
  runHaxeCode(table.concat(lines, '\n')) --reconnect the lines without the imports
  updateLuaVars()
end
function callOnHaxe(name, args)
  return runHaxeCode([[
    var func = ]]..name..[[;
    if(func != null && func != 'NULL')
      return Reflect.callMethod(null, func, args);
  ]], {args = args})
end
function setOnHaxe(who, what)
  runHaxeCode([[
    ]]..who..[[ = what;
  ]], {what = what})
end
function updateLuaVars()
  for k,v in pairs(_G) do
    local has = false
    for i,o in pairs(baseLua) do
      if o == k then
        has = true
      end
    end
    if not has and type(v) ~= 'function' then
      if type(v) == 'table' then
        local function removeFunctions(inp)
          for k,v in pairs(inp) do
            if type(v) == 'table' then
              inp[k] = removeFunctions(v)
            elseif type(v) == 'function' then
              inp[k] = nil
            end
          end
          return inp
        end
        v = removeFunctions(v)
      end
      setOnHaxe(k, v)
    end
  end
end
--stuff i copy and pasted from other stuff
function string.split(self, sep)
    local inputstr = self
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end
function onCreatePost(...)
  runHaxeCode([[
    //get the lua instance
    for(thing in game.luaArray)
    {
      var scriptName:String = "]]..scriptName:gsub('"', '\\"')..[[";
      if(thing.scriptName == scriptName)
      {
        luaInstance = thing;
      }
    }
    pastCreatePost = true;
  ]])
end
function onUpdate(...) 
  --update lua vars and stuff
  updateLuaVars()
end

--tests to see if a variable exists
function varExists(var)
  local ok = luaDebugMode
  luaDebugMode = false --disables errors from appearing
  local exists = runHaxeCode([[
    var test = ]]..var..[[;
    return true;
  ]])
  luaDebugMode = ok
  return exists
end

--this appends every callback to also call on haxe, dont touch this basically lol
callbacks = {
  'onCreate', 'onCreatePost', 'onTweenCompleted', 'onTimerCompleted', 'onCustomSubstateCreate', 'onCustomSubstateCreatePost', 'onCustomSubstateUpdate', 'onCustomSubstateUpdatePost',
  'onGameOverStart', 'onGameOverConfirm',  'onGameOver', 'onStartCountdown', 'onCountdownStarted', 'onUpdateScore', 'onNextDialogue', 'onSkipDialogue', 'onSongStart', 'onResume', 'onPause', 
  'onSpawnNote', 'onUpdate', 'onUpdatePost', 'onEvent', 'eventEarlyTrigger', 'onMoveCamera', 'onKeyPress', 'onKeyRelease', 'noteMiss', 'noteMissPress', 'onGhostTap', 'opponentNoteHit', 'goodNoteHit', 'onStepHit', 
  'onBeatHit', 'onSectionHit', 'onRecalculateRating'
}
for i,func in pairs(callbacks) do
  local old = _G[func] --get the orig function
  _G[func] = function(...) --... = args
    if old then --check if there was an orig function
      old(...)
    end
    return callOnHaxe(func, {{...}})
  end
end
