# doTween YEAH!!!

works like in haxe

# update 1

![](https://cdn.discordapp.com/attachments/1049476175690477628/1049476175954726932/image.png)

https://cdn.discordapp.com/attachments/1049476175690477628/1049476176441245757/2022-12-05_19-03-17.mp4

https://cdn.discordapp.com/attachments/1049476175690477628/1049476768119148634/2022-12-05_19-05-46.mp4

example:
```lua
function onCreatePost()
  doTween('boyfriendGroup', {x = 20, y = 0, ['scale.y'] = 0.5}, 2, {ease = 'cubeInOut', onComplete = function()
    debugPrint('it done')
  end})
end
```

#update 2

ok i UPDATED it so you can tween playstate vars now

https://cdn.discordapp.com/attachments/1049476175690477628/1049481253231018035/2022-12-05_19-23-32.mp4

```lua
function onCreatePost()
  setProperty('camZooming', true)
  doTween('game', {defaultCamZoom = 2}, 2, {ease = 'cubeInOut', onComplete = function()
    debugPrint('it done')
  end})
end
```

#update 3

small update

```lua
function onCreatePost()
  doTween('boyfriend', {x = 20, y = 0, ['scale.y'] = 0.5, NOTAREALVALUE = 12 --[[values that dont exist wont crash the game anymore]]}, 2, {ease = 'cubeInOut', 
    onStart = function() --onStart now respects startDelay
      debugPrint('hi')
    end,
    startDelay = 1
  })
  doTween('stuopid') --this prints an error too
end
```