function onCreate()
  local rh = runHaxeCode
  runHaxeCode = function(code, vars)
    if vars then
      local theStuff = ''
      local function fixType(inp)
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
        else
          debugPrint('unsupported type!', type(inp), inp)
          return fixType('kys')
        end
       end
      for k,v in pairs(vars) do
        if type(k) == 'string' then
          theStuff = theStuff..'\n var '..k..' = '..fixType(v)..';\n'
        end
      end
      return rh(theStuff..'\n'..code)
    end
    return rh(code)
  end
end