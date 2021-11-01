--local __GLOBALCONFS = require "config/global"
--local graph         = require "lib/utils"

local modeSevenLib = require "include/mode_seven"
local graph = require "include/utils"
local screenW = 800
local screenH = 600
local debugar = 1

player = {

    x = 0,
    y = 0,
    z = 10,
    pitch = 0,
    scanLines = 3,
    angle = 180

}

local mapFile = love.image.newImageData("assets/map_1.png")

function love.load()

	love.window.setMode(screenW, screenH, {

        resizable	= false,
		fullscreen	= false,
		vsync		= false,
		minwidth	= 128,
		minheight	= 128

	})

    --love.window.setTitle("Floppalístico")

	modeSevenLib.init(screenW, screenH, 512, 512, mapFile)

end

function love.update(dt)

    -- Movimentos básicos

	player.angle = player.angle % 360

	--love.window.setTitle(player.angle % 400)
    love.window.setTitle("X: " .. player.x .. " Y: " .. player.y .. " A: " .. player.angle)

    if love.keyboard.isDown("w") then
        --player.x = player.x - (300 * math.cos(math.rad(player.angle))) * dt
        --player.y = player.y - (300 * math.sin(math.rad(player.angle))) * dt
        player.y = player.y + 100 * dt
	end

    if love.keyboard.isDown("s") then
        --player.x = player.x + (300 * math.cos(math.rad(player.angle))) * dt
        --player.y = player.y + (300 * math.sin(math.rad(player.angle))) * dt
        player.y = player.y - 100 * dt
	end

	if love.keyboard.isDown("a") then
		--player.angle = player.angle - 100 * dt
        player.x = player.x - 100 * dt
	end

    if love.keyboard.isDown("d") then
        --player.angle = player.angle + 100 * dt
        player.x = player.x + 100 * dt
	end

    -- Altura Z

    if love.keyboard.isDown("lshift") then
		player.z = player.z + 100 * dt
	end

    if love.keyboard.isDown("lctrl") then
		player.z = player.z - 100 * dt
	end

    -- Angulo visão

    if love.keyboard.isDown("q") then
		player.angle = player.angle - 50 * dt
	end

    if love.keyboard.isDown("e") then
		player.angle = player.angle + 50 * dt
	end

    -- FOV

    if love.keyboard.isDown("z") then
		player.pitch = player.pitch + 100 * dt
	end
	if love.keyboard.isDown("x") then
		player.pitch = player.pitch - 100 * dt
	end

    -- Scan Lines

    if love.keyboard.isDown("c") then
		player.scanLines = player.scanLines + 1
	end
	if love.keyboard.isDown("v") and player.scanLines > 1 then
		player.scanLines = player.scanLines - 1
	end

    if love.keyboard.isDown("f") then
		debugar = debugar + 1 * dt
	end
	if love.keyboard.isDown("g") and player.scanLines > 1 then
		debugar = debugar - 1 * dt
	end

    modeSevenLib.camera.setPosition(player.x, player.y, player.z)
    modeSevenLib.camera.setRotation(player.angle)
    modeSevenLib.camera.setPitch(player.pitch)
    modeSevenLib.camera.setHorizon(screenH/2)
    modeSevenLib.camera.setScanLines(player.scanLines)
    modeSevenLib.camera.setZoom(1)

end


function love.draw()

	modeSevenLib.draw3(debugar)

end
