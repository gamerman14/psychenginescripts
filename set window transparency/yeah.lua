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
function onCreate()
    setTransparency(COLOR_HERE) --info about colors in C https://learn.microsoft.com/en-us/windows/win32/gdi/colorref
end
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