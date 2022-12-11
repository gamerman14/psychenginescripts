function scaleChar(char, x, y)
  x = x or 1
  y = y or x
  if not scaleChar_init then
    addHaxeLibrary('FunkinLua')
    addHaxeLibrary('Character')
    runHaxeCode([[
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
      function getProperty(variable:String):Dynamic
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
    scaleChar_init = true
  end
  runHaxeCode([[
    var char:String = "]]..char:gsub('"', '\\"')..[[";
    var scale:Array<Float> = ]]..('[' .. table.concat({x, y}, ',') .. ']')..[[;
    
    var dummyChar = new Character(0, 0, getProperty(char + '.curCharacter'));
    var offsets:Map<String, Array<Dynamic>> = dummyChar.animOffsets;
    dummyChar.kill();
    dummyChar.destroy();
    
    for(offset in offsets)
    {
      offset[0] *= scale[0];
      offset[1] *= scale[1];
    }
    
    setProperty(char + '.animOffsets', offsets);
    setProperty(char + '.scale.x', scale[0]);
    setProperty(char + '.scale.y', scale[1]);
  ]])
end