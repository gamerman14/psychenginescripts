--requires zcamerafix!!!!!!!!!!!!!!!!!!!!!!! it does!!!!!!!!!!!!!!!!! it does!!!!!!!!!!!!

--vars:
--[[
variables:

screenRes : screen resolution of users screen, used like this: screenRes.width, screenRes.height
oldPos : original position of the window before the song started, used like this: oldPos.x, oldPos.y
camScale : the scale of the "window" / general camera scaling
cams : table of cams, example:

  cams.camHUD.angle = 25
  cams.camGame:setPosition(41, 52)

camList : list of all cams
windowList : list of cams that look like the window
keyedColor : color thats keyed out and is also the color of the borders


functions:

centerWindow : centers the window
resetWindowSize : resets the windows size to 1280x720, used when the lua file is destroyed
setObjectCamera : works the same as before, but you can also put 'camOut' to put the object outside of the 'window' or camBorder to make cool borders if you want ig


]]
keyedColor = '0xFF030303'
elapsedTime = 0
forceCamZoomingOff = true
--1.5 scale is fullscreen
camScale = 1
camList = {'camGame', 'camHUD', 'camOther', 'camBorder', 'camPause', 'camOut'}
windowList = {'camGame', 'camHUD', 'camOther', 'camBorder', 'camPause'}
cams = {}
for i,cam in pairs(camList) do
  cams[cam] = {
    angle = 0,
    scale = 1,
    x = 0,
    y = 0,
    setPos = function(self, x, y)
      self.x = x or self.x
      self.y  = y or self.y
    end,
    addPos = function(self, x, y)
      self.x = self.x + (x or 0)
      self.y = self.y + (y or 0)
    end,
    setProperty = function(self, ok, cool)
      setProperty(cam..'.'..ok, cool)
    end,
    copyProperties = function(self, props)
      for i,prop in pairs(props) do
        self:setProperty(prop, self[prop])
      end
    end
  }
end

function onCreatePostPost() --after all the stuff is done
  --example modchart
  -- setObjectCamera('dadGroup', 'out')
  -- setObjectCamera('boyfriendGroup', 'out')
end
function onUpdatePost()
  -- example modchart
  -- for i,cam in pairs(windowList) do
  --   cams[cam]:setPos(math.cos(elapsedTime) * screenRes.width/12, math.sin(elapsedTime * 2) * screenRes.height/12)
  --   cams[cam].angle = math.sin(elapsedTime * 3) * 5
  --   cams[cam].scale = (math.sin(elapsedTime * 7) + 4) * 0.2
  -- end
  -- cams.camOut.angle = math.sin(elapsedTime) * 25
  -- cams.camOut.scale = (math.sin(elapsedTime * 7) + 4) * 0.1
end

function onCreate()
  addLuaScript('zcamerafix')
  addHaxeLibrary('Std')
  addHaxeLibrary('CustomFadeTransition')
  addHaxeLibrary('Math')
  addHaxeLibrary('CoolUtil')
  for i,lib in pairs({'FlxCamera', 'FlxG'}) do
    addHaxeLibrary(lib, 'flixel')
  end
  setTransparency(getColorFromHex(keyedColor)) --info about colors in C https://learn.microsoft.com/en-us/windows/win32/gdi/colorref
  
  local a = setObjectCamera
  setObjectCamera = function(obj, cam)
    if runHaxeCode([[return ['out', 'camout', 'outcam'].contains(']]..string.lower(cam)..[[');]]) then
      runHaxeCode([[
        var shit = game.getLuaObject(']]..obj..[[');
        if(shit == null)
          shit = game.]]..obj..[[;
        if(shit != null)
          shit.cameras = [camOut];
        return true;
      ]])
      return;
    end
    if runHaxeCode([[return ['border', 'camborder', 'bordercam'].contains(']]..string.lower(cam)..[[');]]) then
      runHaxeCode([[
        var shit = game.getLuaObject(']]..obj..[[');
        if(shit == null)
          shit = game.]]..obj..[[;
        if(shit != null)
          shit.cameras = [camBorder];
        return true;
      ]])
      return;
    end
    a(obj, cam)
  end
end
function centerWindow()
  setProperty('fakeWindow.x', screenRes.width/6)
  setProperty('fakeWindow.y', screenRes.height/6)
end
function resetWindowSize()
  setPropertyFromClass('openfl.Lib', 'application.window.width', 1280)
  setPropertyFromClass('openfl.Lib', 'application.window.height', 720)
end
function setWindowSize(width, height)
  setPropertyFromClass('openfl.Lib', 'application.window.width', width)
  setPropertyFromClass('openfl.Lib', 'application.window.height', height)
end
function getWindowWidth()
  return getPropertyFromClass('openfl.lib', 'application.window.width')
end
function getWindowHeight()
  return getPropertyFromClass('openfl.lib', 'application.window.height')
end
screenRes = {}
oldPos = {}
function onCreatePost()
  luaDebugMode = true
  runHaxeCode([[
    //camera for the [direction]Side sprites
    camBorder = new FlxCamera();
    camBorder.bgColor = 0x00;
    FlxG.cameras.add(camBorder, false);
    game.variables.set('camBorder', camBorder);
  
    //new camera for stuff outside the "window"
    camOut = new FlxCamera();
    camOut.bgColor = 0x00;
    FlxG.cameras.add(camOut, false);
    game.variables.set('camOut', camOut);

    //cause the pause screen shows up on the newest camera for soem reason
    camPause = new FlxCamera();
    camPause.bgColor = 0x00;
    FlxG.cameras.add(camPause, false);
    CustomFadeTransition.nextCamera = camPause;
    game.variables.set('camPause', camPause);
  ]])

  makeLuaSprite('leftSide', '', -5000, -2500)
  makeGraphic('leftSide', 5000, 5000, keyedColor)
  setObjectCamera('leftSide', 'camBorder')
  addLuaSprite('leftSide', true)

  makeLuaSprite('topSide', '', -2500, -5000)
  makeGraphic('topSide', 5000, 5000, keyedColor)
  setObjectCamera('topSide', 'camBorder')
  addLuaSprite('topSide', true)

  makeLuaSprite('rightSide', '', 1280, -2500)
  makeGraphic('rightSide', 5000, 5000, keyedColor)
  setObjectCamera('rightSide', 'camBorder')
  addLuaSprite('rightSide', true)

  makeLuaSprite('downSide', '', -2500, 720)
  makeGraphic('downSide', 5000, 5000, keyedColor)
  setObjectCamera('downSide', 'camBorder')
  addLuaSprite('downSide', true)

  oldPos = {x = getPropertyFromClass('openfl.Lib','application.window.x'), y = getPropertyFromClass('openfl.Lib','application.window.y')}
  setPropertyFromClass('flixel.FlxG', 'fullscreen', true)
  screenRes = {width = getPropertyFromClass('openfl.Lib','application.window.width'), height = getPropertyFromClass('openfl.Lib','application.window.height')}
  setPropertyFromClass('flixel.FlxG', 'fullscreen', false)

  setPropertyFromClass('openfl.Lib', 'application.window.width', 1920)
  setPropertyFromClass('openfl.Lib', 'application.window.height', 1080)

  setPropertyFromClass('openfl.Lib','application.window.x', 0)
  setPropertyFromClass('openfl.Lib','application.window.y', 0)
  
  onCreatePostPost()
end

function onUpdate(elapsed)
  elapsedTime = elapsedTime + elapsed
  setProperty('camZooming', false)
  for i,camName in pairs(windowList) do
    local cam = cams[camName]
    if not forceCamZoomingOff then
      if (camName ~= 'camGame' and cam ~= 'camHUD') then
        cam:setProperty('zoom', camScale * (2/3) * cam.scale)
      end
    else
      cam:setProperty('zoom', camScale * (2/3) * cam.scale)
    end
  end
  if not forceCamZoomingOff then
    cams.camGame:setProperty('zoom', (lerp(getProperty'defaultCamZoom' * camScale * (2/3) * cams.camGame.scale, getProperty'camGame.zoom', boundTo(1 - (elapsed * 3.125 * getProperty'camZoomingDecay' * getProperty'playbackRate'), 0, 1))))
    cams.camHUD:setProperty('zoom', (lerp(camScale * (2/3) * cams.camHUD.scale, getProperty'camHUD.zoom', boundTo(1 - (elapsed * 3.125 * getProperty'camZoomingDecay' * getProperty'playbackRate'), 0, 1))))
  end
  for i,cam in pairs(cams) do
    cam:copyProperties({'x', 'y', 'angle'})
  end
end
function opponentNoteHit()
  camZooming = true
end
function goodNoteHit()
  camZooming = true
end
function onSectionHit()
  if camZooming and getProperty('camGame.zoom') < 1.35 and cameraZoomOnBeat and not forceCamZoomingOff then
    setProperty('camGame.zoom', getProperty('camGame.zoom') + 0.015 * camScale * (2/3) * cams.camGame.scale)
    setProperty('camHUD.zoom', getProperty('camHUD.zoom') + 0.03 * camScale * (2/3) * cams.camHUD.scale)
  end
end
function boundTo(value, min, max)
  return math.max(min, math.min(max, value))
end
function lerp(from,to,i)return from+(to-from)*i end
function onDestroy()
  resetWindowSize()

  setPropertyFromClass('openfl.Lib','application.window.x', oldPos.x)
  setPropertyFromClass('openfl.Lib','application.window.y', oldPos.y)
  setTransparency(-2384567) 
end
--dont ask me about this shit i have no idea what like any of it means lol

ffi = require "ffi"

ffi.cdef [[
    typedef int BOOL;
		typedef int BYTE;
		typedef int LONG;
		typedef LONG DWORD;
		typedef DWORD COLORREF;
    typedef unsigned long HANDLE;
    typedef HANDLE HWND;
    typedef int bInvert;

		HWND GetActiveWindow(void);

		LONG SetWindowLongA(HWND hWnd, int nIndex, LONG dwNewLong);

    HWND SetLayeredWindowAttributes(HWND hwnd, COLORREF crKey, BYTE bAlpha, DWORD dwFlags);

		DWORD GetLastError();
]]
function setTransparency(color)
	local win = ffi.C.GetActiveWindow()


	if win == nil then
		debugPrint('Error finding window!!! idiot!!!!')
		debugPrint('cool code: '..tostring(ffi.C.GetLastError()))
	end
	if ffi.C.SetWindowLongA(win, -20, 0x00080000) == 0 then
		debugPrint('error setting window to be layed WTF DFOES THAT EVBEN MEAN LMAOOO!!! IM NOT NO NERD!')
		debugPrint('cool code: '..tostring(ffi.C.GetLastError()))
	end
	if ffi.C.SetLayeredWindowAttributes(win, color, 0, 0x00000001) == 0 then
		debugPrint('error setting color key or whatever')
		debugPrint('cool code: '..tostring(ffi.C.GetLastError()))
	end
end