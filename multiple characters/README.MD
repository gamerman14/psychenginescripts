# Mutliple characters in lua

adds functions for multiple characters
example:

```lua
function onCreatePost()
  makeChar('bfclone', 'dad', 300, 0, 'bfclone note') --tag, char, x, y, notetype for singing
  setProperty('bfclone.alpha', 0.5) --you can setProperty stuff too
  addChar('bfclone', true)
  
  makeChar('woah', 'spooky', -100) --multiple chars also (and they can just be dancing fellas too)
  addChar('woah', true)
  
  makeChar('anotherBF', 'bf', 700, 0, '', true) --setting the notetype to '' makes it so every non-notetype note will go to the extra char
  addChar('anotherBF')
end
```

make sure to put this at the BOTTOM of your lua script!

https://cdn.discordapp.com/attachments/1050996146035753070/1050996147679928330/2022-12-09_23-38-01.mp4

https://cdn.discordapp.com/attachments/1050996146035753070/1051194767712731176/2022-12-10_12-52-28.mp4

https://cdn.discordapp.com/attachments/1050996146035753070/1051209484976013453/2022-12-10_13-45-55.mp4