Pipe = Class{}

--[[Create an image variable for the pipes because they will be spawning infinately. It is much better to
referance a variable infinitely rather than allocate the same image to memory for each pipe that
will be instantiated.]]
local PIPE_IMAGE = love.graphics.newImage('pipe.png')

PIPE_SCROLL = 60

--Initialize the height and width of the pipes, that will be globally accessible.
PIPE_HEIGHT = 288
PIPE_WIDTH = 70

function Pipe:init(orientation, y)
    --[[initialize the x for each pipe to just off the screen]]
    self.x = VIRTUAL_WIDTH
    --[[Initialize the y for each pipe as y, which we will get from the pipe pairs class.]]
    self.y = y
    --Use the getWidth() function in the newImage class to set the width of the pipe to the image width.)
    self.width = PIPE_IMAGE:getWidth()
    self.height = PIPE_HEIGHT

    --[[Initialize the object with an orientation passed in from PipePairs. This will allow the code to determine wether or not to flip the sprite
    for the upper pipes.]]
    self.orientation = orientation
end

function Pipe:update(dt)
    --Nothing in the update function because PipePairs will update the pipes.
end

function Pipe:render()
    --Draw the pipie image as usual except new parameters will be used in order to invert the sprites for use as the top pipes.
    --graphics.draw(image, x location, (if y location is set to 'top' then shift y by the pipe's own height because it will flip), rotation, X scale, Y scale
    love.graphics.draw(PIPE_IMAGE, self.x, (self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y), 0, 1, (self.orientation == 'top' and -1 or 1))
end