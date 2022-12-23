# scale a character (works with hscript chars)

scales a character that can be accessed through getProperty and its offsets

example:
```lua
eT = 0
function onUpdate(e)
  eT = eT + e
  scaleChar('dad', math.sin(eT) + 1.5, math.cos(eT) + 1.5)
end
```

![](https://cdn.discordapp.com/attachments/1050549504505548882/1050549505503797378/image.png)

https://cdn.discordapp.com/attachments/1050549504505548882/1050549506510426262/2022-12-08_18-05-44.mp4