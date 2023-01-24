function onCreate()
  fixRH()
end
function fixRH()
  local rh = runHaxeCode
  rh("setVar('luaVarHolder', null);")
  runHaxeCode = function(code, vars)
    if not vars then
      return rh(code)
    else
      setProperty('luaVarHolder', vars)
      for k,v in pairs(vars) do
        vars[k] = "var "..k.." = getVar('luaVarHolder')."..k..";"
      end
      rh(table.concat(vars, '\n')..'\n'..code)
      setProperty('luaVarHolder', nil)
    end
  end
end
