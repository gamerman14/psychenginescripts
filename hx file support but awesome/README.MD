# WHAT IS THIS? YOSHI ENGINE???

to use this make an hx file called the same thing as your lua file and put them in the same place

#update 1

![](https://cdn.discordapp.com/attachments/1048009388872433714/1048009390000701440/2022-12-01_17-54-45.mp4)

this is possible too
![](https://cdn.discordapp.com/attachments/1048009388872433714/1048011777302089759/image.png)

example hscript:
```haxe
import Std;
import Math; //you can import stuff like REAL haxe!!! also why do you ghave to improt math whyyyy

var myCoolVar:String = 'hahahahhaha'; 
var cool:Int = 0; //you can reuse vars
var testSprite:FlxSprite;
function onCreate()
{
  debugPrint(cool); //yeah
  cool++;
  debugPrint(cool);
  
  testSprite = new FlxSprite(100, 100);
  testSprite.loadGraphic(Paths.image('funkay'));
  testSprite.scale.set(0.25, 0.25);
  game.add(testSprite);
}
function onBeatHit()
{
  debugPrint(curBeat); //any lua var is shared with any haxe var (but not every haxe var is shared with every lua var)
  //also lua vars are read only unless you do setOnLuas or do stuff with luaInstance
}
function onCreatePost()
{
  luaInstance.set('theHaxeVar', 'WHAT!! no way!'); //the luaInstance variable is the FunkinLua of the main script
  //this variable is only set after onCreate because of reasons
}
var elapsedTime:Float = 0;
function onUpdate(elapsed:Float)
{
  elapsedTime += elapsed;
  game.boyfriendGroup.x += Math.sin(elapsedTime);
  testSprite.angle += Math.sin(elapsedTime);
}
```

#update 2

small update check it:
```haxe
import not.a.real.module; //this will give the error: Unknown library/Inaccessible library: module (from: not.a.real.module)

function onCreate()
{
  debugPrint(scriptName); //lua vars are now set from onCreate (also onCreate is no longer a required function)
  
  luaError('this is an error'); //makes scary red text
  
  debugPrint(null); //will give an error saying that all values are null
}
function onCreatePost()
{
  setProperty('dad.color', Colors.RED); //setProperty and colors object that stores basic colors
  debugPrint(getProperty('dad.color')); //getProperty too
  
  debugPrint(getProperty('iconP1')); //you can get haxe objects with getProperty too
}
```

#update 3

made hx files load from their lua files names