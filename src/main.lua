--[[

  @ File              main.lua
  @ Path              /src/
  @ Author            Brendo Costa <brendocosta@id.uff.br>
  @ Description       Nintendo SNES's "mode seven" Love2d implementation
  @ Updated           Nov 1, 2021

  ------------------------------------------------------------------------------

  MIT License

  Copyright (c) 2021 Brendo Costa

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.

--]]

-- Global configuration

local modeSevenLib = require "include/mode_seven"
local windowWidth  = 800
local windowHeight = 600

-- Set "enableRotationTest = true" for the auto rotating example

local enableRotationTest = true
local autorotationAngle  = 0

-- Player / Controllable Camera
-- With "x = 256" and "y = 256" we'll start at map's center,
-- assuming a 512x512 map size.

local player = {

    x = 256,
    y = 256,
    z = 20,
    pitch = 0,
    angle = 0,
    scanLines = 1

}

function love.load()

    -- Window configuration

    love.window.setTitle("Mode 7 Test")

	love.window.setMode(windowWidth, windowHeight, {

        resizable	= false,
		fullscreen	= false,
		vsync		= false,
		minwidth	= 128,
		minheight	= 128

	})

    -- Mode 7 configuration

    modeSevenLib.init({

        screenWidth  = windowWidth,
        screenHeight = windowHeight,
        mapImageData = love.image.newImageData("assets/test.png"),
        mapWidth     = 512,
        mapLength    = 512

    })

    -- For auto rotating example

    if enableRotationTest then

        player.x = -120
        player.y = -120
        player.z = 120
        player.pitch = -120

    end

end

function love.update(dt)

    -- Basic movement

    if love.keyboard.isDown("w") then

        player.x = player.x - (100 * math.cos(math.rad(player.angle))) * dt
        player.y = player.y - (100 * math.sin(math.rad(player.angle))) * dt

	end

    if love.keyboard.isDown("s") then

        player.x = player.x + (100 * math.cos(math.rad(player.angle))) * dt
        player.y = player.y + (100 * math.sin(math.rad(player.angle))) * dt

	end

	if love.keyboard.isDown("a") then

		player.angle = player.angle - 100 * dt

	end

    if love.keyboard.isDown("d") then

        player.angle = player.angle + 100 * dt

	end

    if love.keyboard.isDown("lshift") then

		player.z = player.z + 100 * dt

	end

    if love.keyboard.isDown("lctrl") then

		if player.z > 10 then player.z = player.z - 100 * dt end

	end

    -- View's pitch

    if love.keyboard.isDown("z") then

		player.pitch = player.pitch - 100 * dt

	end

    if love.keyboard.isDown("x") then

        player.pitch = player.pitch + 100 * dt

	end

    -- Renderer's scan lines

    if love.keyboard.isDown("c") then

		player.scanLines = player.scanLines + 1

	end

    if love.keyboard.isDown("v") and player.scanLines > 1 then

		player.scanLines = player.scanLines - 1

	end

    -- For autorotating example

    if enableRotationTest then

        -- Assuming the 512x512 map size

        mapCenterX = 256
        mapCenterY = 256

        autorotationAngle = (autorotationAngle + 1 * ( (1 / 3600) % 1) * math.cos(mapCenterX) ) % 1

        newX = math.cos(math.rad(autorotationAngle)) * (player.x - 256) - math.sin(math.rad(autorotationAngle)) * (player.y - 256) + 256
        newY = math.sin(math.rad(autorotationAngle)) * (player.x - 256) + math.cos(math.rad(autorotationAngle)) * (player.y - 256) + 256

        player.x = newX
        player.y = newY

        player.angle = ( math.atan2(256 - newY, 256 - newX) * (180 / math.pi) + 180)

    end

    modeSevenLib.camera.update({

        positionX = player.x,
        positionY = player.y,
        positionZ = player.z,
        rotation  = player.angle,
        pitch     = player.pitch,
        screenScanLines = player.scanLines,

    })

end


function love.draw()

    -- A blue background...

    love.graphics.clear(155/256, 2411/256, 216/256)

    -- Do the mode 7 !!

    modeSevenLib.draw()

end
