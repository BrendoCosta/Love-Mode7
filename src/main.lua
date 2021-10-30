--local __GLOBALCONFS = require "config/global"
--local graph         = require "lib/utils"
local modeSevenLib = require "include/mode_seven"
local graph = require "include/utils"
local screenW = 800
local screenH = 600
player = {

    x = 0,
    y = 0,
    z = 10,
    pitch = 0,
    scanLines = 1,
    angle = 0

}

vec = {

    x = {100},
    y = {100},
    z = {10}

}

local imagedata = love.image.newImageData("assets/map_1.png")

function love.load()

	-- @ Main engine configurations

	love.window.setMode(screenW, screenH, {

        resizable	= false,
		fullscreen	= false,
		vsync		= false,
		minwidth	= 128,
		minheight	= 128

	})

    --love.window.setTitle("Floppalístico")

	modeSevenLib.init(screenW, screenH, 512, 512, imagedata)

end
local nx = 0
local ny = 0
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
function vec:update(ox, oy, px, py, angle)

    --nx = ox + math.cos(angle) * (px - ox) - math.sin(angle) * (py - oy)
    --ny = oy + math.sin(angle) * (px - ox) + math.cos(angle) * (py - oy)

    --for i = 0, nx do
    --    vec.x[i] = (player.x + i)
    --end
    --for i = 0, ny do
    --    vec.y[i] = (player.y + i)
    --end

end
function love.update(dt)

    -- Movimentos básicos

	--player.angle = player.angle % 360

	--love.window.setTitle(player.angle % 400)
    love.window.setTitle("X: " .. player.x .. " Y: " .. player.y .. " A: " .. player.angle)

    if love.keyboard.isDown("w") then
        player.x = player.x + (100 * math.cos(player.angle * math.pi / 180)) * dt
        player.y = player.y + (100 * math.sin(player.angle * math.pi / 180)) * dt
	end

    if love.keyboard.isDown("s") then
        player.x = player.x - (100 * math.cos(player.angle * math.pi / 180)) * dt
        player.y = player.y - (100 * math.sin(player.angle * math.pi / 180)) * dt
	end

	if love.keyboard.isDown("a") then
		player.angle = player.angle - 100 * dt
	end

    if love.keyboard.isDown("d") then
        player.angle = player.angle + 100 * dt
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

	modeSevenLib.update(player.x,
						player.y,
						player.z,
						player.angle,
						1,
                        1000,
						player.pitch,
						screenH/2,
						player.scanLines)

end

--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------

function love.draw()

	modeSevenLib.draw()
    ----------------------------------------------------------------------------
    graph.setHexColor("FF0000", 1)
    love.graphics.points(player.x % 100, player.y % 100)

    --vec:update(player.x, player.y, player.x+100, player.y, math.rad(player.angle))

    --graph.setHexColor("FF0000", 1)
    --love.graphics.points(nx, ny)
end
