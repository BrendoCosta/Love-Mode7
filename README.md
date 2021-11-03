# Love-Mode7

This is a implementation of the SNES's "Mode 7" graphical mode written in Lua with the LÖVE engine. Here, we are rendering the entire effect with the CPU, so there's no pixel shaders. The effect is also a quite simple, and once the game engine you're working has a way to read the pixels colors of an image and draw them on screen, you can port it to everything you want.

**NOTE:** Sadly, I can't release the Mario's Kart map together with the source code since is a copyrighted image, but you can [download it from here](https://mkpc.malahieude.net/images/maps/map1.png) and set the effect config to use it.

## Some basic controls (for `main.lua`)

**Camera's movement:** `W`, `A`, `S`, `D`  
**Camera's height:** `LEFT SHIFT` and `LEFT CTRL`  
**Camera's pitch:** `Z` and `X`  
**Change renderering's vertical lines count:** `C` and `V`

## Screenshots

<p align="center">
    <img src="https://i.imgur.com/TmYSlkQ.png">
    <img src="https://i.imgur.com/c8ELhgb.png">
    <img src="https://i.imgur.com/A3526g3.png">
</p>
