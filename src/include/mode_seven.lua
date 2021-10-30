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

        positionX       = 0,  -- X position
        positionY       = 0,  -- Y position
        positionZ       = 0,  -- Z position
        rotationSin     = 0,  -- Rotation angle's sin
        rotationCos     = 0,  -- Rotation angle's cos
        zoom            = 0,  -- Zoom
        fov             = 0,  -- FOV
        pitch           = 0,  -- Pitch
        horizon         = 0,  -- Horizon
        scanLines       = 0   -- Scan lines

    },

    -- This instance's variables

    screenWidth,
    screenHeight,
    mapWidth,
    mapLength,

    -- Imagedata's variables

    imageData,
    imageWidth,
    imageHeight,
    textureXscale,
    textureYscale

}

--------------------------------------------------------------------------------
-- @ Method         self.init()
-- @ Description    Create a class's instance camera variables. It must be
--                  called inside love.load() method.
--------------------------------------------------------------------------------

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

    self.textureXscale  = _screenWidth
    self.textureYscale  = _screenHeight

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

--------------------------------------------------------------------------------
-- @ Method         self.draw()
-- @ Description    Do all the mode seven effect. It must be called
--                  inside love.draw() method.
--------------------------------------------------------------------------------

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

-- Return instance

return self
