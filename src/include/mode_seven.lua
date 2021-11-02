--[[

  @ File              mode_seven.lua
  @ Path              /src/include/
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

-- This instance

local self = {

    enableGroundLimit = true,

    -- This instance's camera

    camera = {
        position  = { x = 0, y = 0, z = 10 },
        screen    = {
            width     = love.graphics.getWidth(),
            height    = love.graphics.getHeight(),
            horizon   = (love.graphics.getHeight() / 2),
            scanLines = 1
        },
        rotation  = 0,
        pitch     = 0,
    },

    -- This instance's map

    map = {
        position = { x = 0, y = 0 },
        width,
        length,
        image = {
            data,
            width,
            height,
            scale = { x, y }
        }
    }

}

function self.init(args)

    --[[

        Possible arguments:

        - Screen   : screenWidth, screenHeight, screenHorizon
        - Map      : mapImageData, mapWidth, mapLength, mapImageScaleX,
                     mapImageScaleY

    --]]

    -- Initial camera's defaults and configs

    args.screenWidth   = args.screenWidth   or love.graphics.getWidth()
    args.screenHeight  = args.screenHeight  or love.graphics.getHeight()
    args.screenHorizon = args.screenHorizon or args.screenHeight / 2

    self.camera.screen.width   = args.screenWidth
    self.camera.screen.height  = args.screenHeight
    self.camera.screen.horizon = args.screenHorizon

    -- Initial map's config and defaults

    args.mapWidth       = args.mapWidth       or args.mapImageData:getWidth()
    args.mapLength      = args.mapLength      or args.mapImageData:getHeight()
    args.mapImageScaleX = args.mapImageScaleX or 1
    args.mapImageScaleY = args.mapImageScaleY or 1

    self.map.image.data    = args.mapImageData
    self.map.width         = args.mapWidth
    self.map.length        = args.mapLength
    self.map.image.scale.x = args.mapImageScaleX
    self.map.image.scale.y = args.mapImageScaleY

    -- Autoconfigs

    self.map.image.width   = args.mapImageData:getWidth()
    self.map.image.height  = args.mapImageData:getHeight()

end

function self.camera.update(args)

    --[[

        Possible arguments:

        - Position : positionX, positionY, positionZ,
        - Screen   : screenWidth, screenHeight, screenHorizon, screenScanLines
        - Others   : rotation, pitch

    --]]

    -- Camera's position configs and defaults

    args.positionX = args.positionX or self.camera.position.x
    args.positionY = args.positionY or self.camera.position.y
    args.positionZ = args.positionZ or self.camera.position.z

    self.camera.position.x = args.positionX
    self.camera.position.y = args.positionY
    self.camera.position.z = args.positionZ

    if args.positionZ <= 1 and self.enableGroundLimit then

        self.camera.position.z = 1

    end

    -- Camera's other configs and defaults

    args.rotation = args.rotation or self.camera.rotation
    args.pitch    = args.pitch    or self.camera.pitch

    self.camera.rotation        = args.rotation % 360
    self.camera.pitch           = args.pitch

    -- Camera's screen configs and defaults

    args.screenWidth     = args.screenWidth     or self.camera.screen.width
    args.screenHeight    = args.screenHeight    or self.camera.screen.height
    args.screenHorizon   = args.screenHorizon   or self.camera.screen.height / 2
    args.screenScanLines = args.screenScanLines or 1

    self.camera.screen.width     = args.screenWidth
    self.camera.screen.height    = args.screenHeight
    self.camera.screen.horizon   = args.screenHorizon + self.camera.pitch
    self.camera.screen.scanLines = args.screenScanLines

end

function self.map.update(args)

    --[[

        Possible arguments:

        - Position : positionX, positionY
        - Size     : width, length
        - Image    : imageData, imageWidth, imageHeight,
                     imageScaleX, imageScaleY

    --]]

    -- Map's position configs and defaults

    args.positionX = args.positionX or self.map.position.x
    args.positionY = args.positionY or self.map.position.y

    self.map.position.x = args.positionX
    self.map.position.y = args.positionY

    -- Map's size configs and defaults

    args.width  = args.width  or self.map.width
    args.length = args.length or self.map.length

    self.map.width  = args.width
    self.map.length = args.length

    -- Map's image configs and defaults

    args.imageData   = args.imageData   or self.map.image.data
    args.imageWidth  = args.imageWidth  or self.map.image.width
    args.imageHeight = args.imageHeight or self.map.image.height
    args.imageScaleX = args.imageScaleX or self.map.image.scale.x
    args.imageScaleY = args.imageScaleY or self.map.image.scale.y

    self.map.image.data    = args.imageData
    self.map.image.width   = args.imageWidth
    self.map.image.height  = args.imageHeight
    self.map.image.scale.x = args.imageScaleX
    self.map.image.scale.y = args.imageScaleY

end

function self.draw()

    -- We want to start from screen's horizon to bottom,
    -- decreasing after every loop. This get the effect's
    -- explanation a little friendly using the Z's gradient
    -- as an example.
    -- This approach follows @tigrou's Mode 7 explanation below
    -- https://gamedev.stackexchange.com/a/28764

    local position = { x, y }

    local rotation = {

        sin = math.sin(math.rad(self.camera.rotation - 45)),
        cos = math.cos(math.rad(self.camera.rotation - 45))

    }

    local projection = { x, y, z }

    for screenY = self.camera.screen.horizon,
                  self.camera.screen.height,
                  self.camera.screen.scanLines
                  do

        -- Z's projection

        projection.z = self.camera.screen.horizon - screenY
        if projection.z == 0 then projection.z = projection.z + 1 end

        for screenX = 0, self.camera.screen.width, 1 do

            -- X's and Y's positions

            position.x = self.camera.screen.width - screenX
            position.y = self.camera.screen.width - screenX

            -- X's and Y's rotation

            projection.x = position.x * rotation.cos - screenX * rotation.sin
            projection.y = position.y * rotation.sin + screenX * rotation.cos

            -- X's and Y's world projections

            projection.x = projection.x / projection.z * self.camera.position.z
            projection.y = projection.y / projection.z * self.camera.position.z

            -- Movement

            projection.x = projection.x + self.camera.position.x
            projection.y = projection.y + self.camera.position.y

            -- Texture scaling

            projection.x = projection.x * self.map.image.scale.x
            projection.y = projection.y * self.map.image.scale.y

            -- We are going to draw the world's projected
            -- coordinates (projection.x, projection.y) only
            -- if they are inside map's range. With this,
            -- we'll able to avoid the "infinite map" effect.

            if (projection.x > 0 and projection.x < self.map.width)
            and (projection.y > 0 and projection.y < self.map.length)
            then

                -- Because (projection.x, projection.y) are actually
                -- world's coordinates, we need to limit their range
                -- to the image's dimension's range.

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
