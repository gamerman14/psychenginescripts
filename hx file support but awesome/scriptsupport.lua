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
  local wasNil = false
  if hscriptName == nil then
    wasNil = true
    local idiotName = scriptName:split('/')
    hscriptName = idiotName[#idiotName]:split('.')[1]
  end
  addHaxeLibrary('FunkinLua')
  addHaxeLibrary('Type')
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
    onCreate = null; //this makes it so the script doesn't require an onCreate function
    pastCreatePost = false;
    function debugPrint(?txt1, ?txt2, ?txt3, ?txt4, ?txt5)
    {
      var cool = [for(thing in [txt1, txt2, txt3, txt4, txt5]) if(thing != null) thing];
      if(cool.length > 0)
        game.addTextToDebug(cool.join(', '), Colors.WHITE);
      else
        luaError('(debugPrint) All variables null!');
    }
    function luaError(txt:String)
      game.addTextToDebug(txt, Colors.RED);
    
    //these have extended functions because its haxe to haxe instead of haxe to lua
    function setProperty(variable:String, value:Dynamic):Bool
    {
      if(getProperty(variable, true) == null)
        return;
      var killMe:Array<String> = variable.split('.');
			if(killMe.length > 1) {
				FunkinLua.setVarInArray(FunkinLua.getPropertyLoopThingWhatever(killMe), killMe[killMe.length-1], value);
				return true;
			}
			FunkinLua.setVarInArray(FunkinLua.getInstance(), variable, value);
			return true;
    }
    function getProperty(variable:String, ?fromSetProperty:Bool):Dynamic
    {
      var result:Dynamic = null;
			var killMe:Array<String> = variable.split('.');
			if(killMe.length > 1)
				result = FunkinLua.getVarInArray(FunkinLua.getPropertyLoopThingWhatever(killMe), killMe[killMe.length-1]);
			else
				result = FunkinLua.getVarInArray(FunkinLua.getInstance(), variable);
      
      if(result == null)
        luaError((fromSetProperty ? '(setProperty) ' : '(getProperty) ') + 'Cannot find variable: ' + variable);
			return result;
    }
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
  if args then
    for i,arg in pairs(args) do
      args[i] = fixType(arg)
    end
  end
  return runHaxeCode([[
    var func = ]]..name..[[;
    if(func != null)
      func(]]..((args and #args > 0) and table.concat(args, ', ') or '')..[[);
  ]])
end
function setOnHaxe(who, what)
  runHaxeCode([[
    ]]..who..[[ = ]]..fixType(what)..[[;
  ]])
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
function fixType(inp)
  cool = {
    ['string'] = function()
      return '"' .. inp:gsub('"', '\\"') .. '"'
    end,
    ['number'] = function() return tostring(inp) end,
    ['table'] = function()
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
          table.insert(final, k..': '..fixType(v))
        end
        return '{\n'..table.concat(final, ',\n')..'}'
      else
        local final = {}
        for k,v in pairs(inp) do
          table.insert(final, fixType(v))
        end
        return '[\n'..table.concat(final, ',\n')..']'
      end
    end
  }
  if cool[type(inp)] then
    return cool[type(inp)]()
  end
  return tostring(inp)
end
--every single callOnLuas made to callOnHaxe (in order of appearence from atoms perspective)
--also i looked at the way the og hx file support did it and im so stupid why am i so stupid oh my god
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
    //these are basically as limited as the lua varients cause its haxe -> lua -> haxe
    //you shouldn't need to use these if you are using haxe code in the first place though
    function getPropertyFromClass(classVar:String, variable:String)
      return luaInstance.call('getPropertyFromClass', [classVar, variable]);
    function setPropertyFromClass(classVar:String, variable:String, value:Dynamic)
      return luaInstance.call('setPropertyFromClass', [classVar, variable, value]);
    
    pastCreatePost = true;
  ]])
   -- return callOnHaxe('onCreatePost', {...}) 
end
function onUpdate(...) 
  --update lua vars and stuff
  updateLuaVars()
  -- return callOnHaxe('onUpdate', {...})
end

--this appends every callback to also call on haxe, dont touch this basically lol
for i,func in pairs({
  'onCreate', 'onCreatePost',
  'onTweenCompleted', 'onTimerCompleted',
  'onCustomSubstateCreate', 'onCustomSubstateCreatePost', 'onCustomSubstateUpdate', 'onCustomSubstateUpdatePost',
  'onGameOverStart', 'onGameOverConfirm',  'onGameOver',
  'onStartCountdown', 'onCountdownStarted',
  'onUpdateScore',
  'onNextDialogue', 'onSkipDialogue',
  'onSongStart',
  'onResume', 'onPause',
  'onSpawnNote',
  'onUpdate', 'onUpdatePost',
  'onEvent', 'eventEarlyTrigger',
  'onMoveCamera',
  'onKeyPress', 'onKeyRelease',
  'noteMiss', 'noteMissPress', 'onGhostTap',
  'opponentNoteHit', 'goodNoteHit',
  'onStepHit', 'onBeatHit', 'onSectionHit',
  'onRecalculateRating'
}) do
  local old = _G[func] --get the orig function
  _G[func] = function(...) --... = args
    if old then --check if there was an orig function
      old(...)
    end
    return callOnHaxe(func, {{...}})
  end
end
