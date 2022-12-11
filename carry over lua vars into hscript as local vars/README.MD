# IS THAT TITLE CLEAR ENOUGH?!?!??!?!?

this is pretty cool code

example:
```lua
function onCreatePost()
  local vars = {
    testVar = {myStuff = {'this is GREAT and AWESOME', 124}},
    pleasePutBfXHere = 53,
    andHeSaid = '"WHAT no way", and then died'
  }
  debugPrint(runHaxeCode([[
    game.boyfriend.x = pleasePutBfXHere;
    return testVar.myStuff;
  ]], vars))
end
```