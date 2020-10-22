Bird = Class{}

local GRAVITY = 10
local ANTI_GRAVITY = -3

--The initializing constructor for each instance of this class.
function Bird:init()
    --The image that this object will render.
    self.image = love.graphics.newImage('bird.png')
    --The dimensions of the object, dependant on the dimension of the image taken using image:functions.
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    --The position on the screen where we want to render the image.
    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)
    --The velocity of the object.
    self.deltaY = 0
end

--[[AABB collision detection will be used to handle collision. In order to do this, the collision function will take in a pipie that contains
all of the global x and y values.]]
function Bird:collides(pipe)
    --AABB collision handling. +2 and -4 were used in order to shrink the apparent size of the bird in order to make collision a bit easier on the user.
    if (self.x + 2) + (self.width - 4) >= pipe.x and self.x + 2 <= pipe.x + PIPE_WIDTH then
        if (self.y + 2) + (self.height - 4) >= pipe.y and self.y + 2 <= pipe.y + PIPE_HEIGHT then
            return true
        end
    end
end

--The update function for this object.
function Bird:update(dt)
    --[[Update the velocity by incrementing it each update. This simulates how things fall incrementally faster
    over time because of gravity.]]--
    self.deltaY = self.deltaY + GRAVITY * dt

    --Apply the input handling logic created in main by checking the table.
    if love.keyboard.wasPressed('space') then
        self.deltaY = ANTI_GRAVITY
        sounds['jump']:play()
    end

    --Apply the updated velocity to the objects position.
    self.y = self.y + self.deltaY
end

--The render function for this object.
function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end