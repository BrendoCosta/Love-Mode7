--[[

  @ File              mode_seven.lua
  @ Path              /src/include/
  @ Author            Brendo Costa <brendocosta@id.uff.br>
  @ Description       Nintendo SNES's "mode seven" Love2d implementation
  @ Updated           Oct 27, 2021

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

-- This instance

local self = {

    -- This instance's camera

    camera = {

        position  = { x = 0, y = 0, z = 10 },
        width     = love.graphics.getWidth(),
        height    = love.graphics.getHeight(),
        horizon   = (love.graphics.getHeight() / 2),
        rotation  = 0,
        zoom      = 1,
        fov       = (love.graphics.getHeight() / 2),
        pitch     = 0,
        scanLines = 1

    },

    map = {

        position = { x = 0, y = 0 },
        width    = 512,
        length   = 512,

        image    = {

            data,
            width,
            height,
            scale = { x = 1, y = 1 }

        }

    },

    enableGroundLimit = true

}

function self.init(width, height, mapWidth, mapLength, imageData)

    self.camera.width     = width
    self.camera.height    = height
    self.camera.horizon   = height / 2

    self.map.width        = mapWidth
    self.map.length       = mapLength
    self.map.image.data   = imageData
    self.map.image.width  = imageData:getWidth() - 1
    self.map.image.height = imageData:getHeight() - 1

end





--------------------------------------------------------------------------------





--------------------------------------------------------------------------------

function self.camera.setPosition(x, y, z)

    self.camera.position.x = x or self.camera.position.x
    self.camera.position.y = y or self.camera.position.y
    self.camera.position.z = z or self.camera.position.z

    if self.camera.position.z <= 1 and self.enableGroundLimit then

        self.camera.position.z = 1

    end

end

function self.camera.setSize(width, height)

    self.camera.width = width or self.camera.width
    self.camera.height = height or self.camera.height

end

function self.camera.setHorizon(height)

    self.camera.horizon = height + self.camera.pitch

end

function self.camera.setRotation(angle)

    self.camera.rotation = angle

end

function self.camera.setZoom(level)

    self.camera.zoom = level

end

function self.camera.setFov(fov)

    self.camera.fov = fov

end

function self.camera.setPitch(pitch)

    self.camera.pitch = pitch

end

function self.camera.setScanLines(linesCount)

    self.camera.scanLines = linesCount

end

--------------------------------------------------------------------------------











--[[
function self.newCamera(width, height, x, y, z, horizon,
    rotation, zoom, fov, pitch, scanLines)

    -- Property             Params      Defaults

    self.camera.width       = width     or love.graphics.getWidth()
    self.camera.height      = height    or love.graphics.getHeight()

    self.camera.position.x  = x         or 0
    self.camera.position.y  = y         or 0
    self.camera.position.z  = z         or 0

    self.camera.horizon     = horizon   or (love.graphics.getHeight() / 2)
    self.camera.rotation    = rotation  or 0
    self.camera.zoom        = zoom      or 1
    self.camera.fov         = fov       or self.camera.horizon
    self.camera.pitch       = pitch     or 0
    self.camera.scanLines   = scanLines or 1

end















--]]

--------------------------------------------------------------------------------
--[[
function self.init(_screenWidth, _screenHeight, _mapWidth, _mapLength, _imageData)

    self.screenWidth    = _screenWidth
    self.screenHeight   = _screenHeight

    self.mapWidth       = _mapWidth
    self.mapLength      = _mapLength

    self.imageData      = _imageData
    self.imageWidth     = _imageData:getWidth() - 1
    self.imageHeight    = _imageData:getHeight() - 1

    -- Usually you will want keep the screen
    -- dimensions as the texture's scales values,
    -- although you can adjust it.

    self.textureXscale  = 1
    self.textureYscale  = 1

end

--------------------------------------------------------------------------------
-- @ Method         self.update()
-- @ Description    Update instance's camera variables. It must be called
--                  inside love.update() method.
--------------------------------------------------------------------------------

function self.update(_positionX, _positionY, _positionZ, _rotationAngle,
                     _zoom, _fov, _pitch, _horizon, _scanLines)

    self.camera.positionX       = (_positionX + self.mapLength)
    self.camera.positionY       = (_positionY + self.mapWidth)
    self.camera.positionZ       = _positionZ
    self.camera.rotationSin     = math.sin(math.rad(_rotationAngle))
    self.camera.rotationCos     = math.cos(math.rad(_rotationAngle))
    self.camera.zoom            = _zoom
    self.camera.fov             = _fov
    self.camera.pitch           = _pitch
    self.camera.horizon         = _horizon + _pitch
    self.camera.scanLines       = _scanLines

end
--]]
--------------------------------------------------------------------------------
-- @ Method         self.draw()
-- @ Description    Do all the mode seven effect. It must be called
--                  inside love.draw() method.
--------------------------------------------------------------------------------
--[[
function self.draw()

    local x, y, z
    local distance, ratio
    local rx, ry, px, py, pixelX, pixelY

    for y = self.camera.horizon, self.screenHeight, self.camera.scanLines do

        z = y - self.camera.horizon

        if z == 0 then z = z + 1 end

        -- Tip: distance = (self.camera.positionZ * self.textureYscale) / z
        --                   + self.camera.horizon
        -- make a cool "earth flying" effect.
        distance = (self.camera.positionZ * self.textureYscale) / z
        ratio    = distance / self.textureXscale

        rx = -self.camera.rotationSin * ratio
        ry = self.camera.rotationCos * ratio

        px = self.camera.positionX + distance * self.camera.rotationCos
             * self.camera.zoom - self.screenWidth / 2 * rx

        py = self.camera.positionY + distance * self.camera.rotationSin
             * self.camera.zoom - self.screenWidth / 2 * ry

        for x = 0, self.screenWidth, 1 do
            if (math.abs(px * -1) < self.mapWidth)
            and (math.abs(py * -1) < self.mapLength)
            then
                pixelX = math.floor(math.abs(px % self.imageWidth))
                pixelY = math.floor(math.abs(py % self.imageHeight))

                local r, g, b = self.imageData:getPixel(pixelX, pixelY)
                love.graphics.setColor(r, g, b)

                love.graphics.points(x, y)

                px = px + rx
                py = py + ry
            end

        end

    end

end
--]]

function self.draw3(debugar)

    -- We want to start from image's bottom to horizon,
    -- decreasing after every loop. This get the effect's
    -- explanation a little friendly using the Z's gradient
    -- as an example.
    --
    -- NOTE: Changing the code to "for y = self.camera.horizon,
    --                               self.screenHeight,
    --                               self.camera.scanLines do"
    -- And "projection.z = self.camera.horizon - y"
    -- Will lead us to same results.
    --
    -- This approach follows @tigrou's Mode 7 explanation below
    -- https://gamedev.stackexchange.com/a/28764

    -- Working rotation:
    -- position.x = (screenX + self.camera.width / 2) * rotation.cos - (screenX) * rotation.sin
    -- position.y = fov * rotation.sin + (screenX) * rotation.cos

    local position = { x, y }

    local rotation = {

        sin = math.sin(math.rad(self.camera.rotation)),
        cos = math.cos(math.rad(self.camera.rotation))

    }

    local projection = { x, y, z }

    for screenY = self.camera.horizon, self.camera.height, self.camera.scanLines do

        -- Adjusts

        fov = self.camera.horizon

        -- Z's projection

        projection.z = self.camera.horizon - screenY
        if projection.z == 0 then projection.z = projection.z + 1 end

        for screenX = 0, self.camera.width, 1 do

            -- X's and Y's positions

            position.x = (self.camera.width - screenX)
            position.y = (self.camera.width - screenX)

            -- Adjusts

            projection.x = (position.x) * rotation.sin + screenX * rotation.cos
            projection.y = (position.y - self.camera.pitch) * rotation.cos - screenX * rotation.sin

            -- X's and Y's world projections

            projection.x = projection.x * self.camera.position.z / projection.z
            projection.y = projection.y * self.camera.position.z / projection.z

            -- Movement

            projection.x = projection.x + self.camera.position.x
            projection.y = projection.y + self.camera.position.y

            -- Rotation

            --projection.x = projection.x * rotation.cos - projection.y * rotation.sin
            --projection.y = projection.x * rotation.sin + projection.y * rotation.cos

            -- Texture scaling

            projection.x = projection.x * self.map.image.scale.x
            projection.y = projection.y * self.map.image.scale.y

            -- If the world's projected coordinate (projection.x, projection.y) are inside
            -- maps range, we can display it on screen. This avoid the
            -- "infinite map" effect.

            if (projection.x > 0 and projection.x < self.map.width)
            and (projection.y > 0 and projection.y < self.map.length)
            then

                -- Because (projection.x, projection.y) are actually world's coordinates, we need
                -- to limit their range to the image's dimension's range.

                projection.x = projection.x % self.map.image.width
                projection.y = projection.y % self.map.image.height

                -- Get the pixel's color inside image's range
                -- and set it as the drawing color.

                local r, g, b = self.map.image.data:getPixel(projection.x, projection.y)
                love.graphics.setColor(r, g, b)

                -- Draw it on screen

                love.graphics.points(screenX, screenY)

            end

        end

    end

end

-- Return instance

return self
