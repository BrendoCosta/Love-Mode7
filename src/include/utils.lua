-- @ Filename    : utils.lua
-- @ Date        : September 18, 2021

-- @ Description : Provide some utility functions for love.graphics.
-- @ Using       : local someVariableName = require "<path to this file>/utils"
--                 someVariableName.someFunctionOfThisFile()

-- @ Author      : Brendo Costa <brendocosta@id.uff.br>
--                 https://github.com/BrendoCosta

-- @ Licence     : MIT Licence
--
--                 Copyright (c) 2011 Brendo Costa
--
--                 Permission is hereby granted, free of charge, to any person obtaining a
--                 copy of this software and associated documentation files (the
--                 "Software"), to deal in the Software without restriction, including
--                 without limitation the rights to use, copy, modify, merge, publish,
--                 distribute, sublicense, and/or sell copies of the Software, and to
--                 permit persons to whom the Software is furnished to do so, subject to
--                 the following conditions:
--
--                 The above copyright notice and this permission notice shall be included
--                 in all copies or substantial portions of the Software.
--
--                 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
--                 OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
--                 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
--                 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
--                 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
--                 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
--                 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


local self = {}

-- @ setHexColor
-- @ Sets a hexadecimal color string input as drawing color.
-- @ If "alpha" is not defined at function call then let "alpha" = 1

function self.setHexColor(color, alpha)

    local alpha = alpha or 1

    local red   = (tonumber(string.sub(color, 1, 2), 16)) / 255
    local green = (tonumber(string.sub(color, 3, 4), 16)) / 255
    local blue  = (tonumber(string.sub(color, 5, 6), 16)) / 255

    return love.graphics.setColor(red, green, blue, alpha)

end

-- @ pixel
-- @ Draws a pixel at (x, y)

function self.pixel(x, y)

    return love.graphics.rectangle("fill", x, y, 1, 1)

end

-- @ cubicBezier
-- @ Draws a cubic Bezier curve from (x1, y1) to (x4, y4) with "p" points between them.
-- @ If "p" is not defined at function call then let "p" = 1000
-- @ Warning: high "p" values may slow down performance significatilly.

function self.cubicBezier(x1, y1, x2, y2, x3, y3, x4, y4, p)
    
    local p = p or 1000
    
    for i = 0, (p + 1), 1 do 
        
        local t = i / p
        local a = math.pow((1 - t), 3)
        local b = math.pow((3 * t * (1 - t)), 2)
        local c = math.pow((3 * t), 2) * (1 - t)
        local d = math.pow(t, 3)

        local x = math.floor(a * x1 + b * x2 + c * x3 + d * x4)
        local y = math.floor(a * y1 + b * y2 + c * y3 + d * y4)

        self.pixel(x, y)
        
    end
    
    return
    
end

return self