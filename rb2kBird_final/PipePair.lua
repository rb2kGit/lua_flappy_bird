--[[This is a class that contains two other objects in it. Imagine a rectabgle with to rectangles (the pipes) inside of it.]]
PipePair = Class{}

--Initialize the size of the gap that will be inbetween the top and lower pipes.
local GAP_HEIGHT = 90

function PipePair:init(y) --Take in a randomly generated Y location for the pipes that was calculated from main.
    --Initiliaze the pipes past the end of the screen.
    self.x = VIRTUAL_WIDTH + 5

    --Initialize the y of the pipe pairs. This is for the top pipe! The gap is what determines the vertical shift of the second pipe.
    self.y = y

    --[[In the init two pipes from the pipe class will be instantiated in a table that contains 2 keys. One set to top and one set to bottom. 
    Depending on this orentation setting the pipe rendering will be done according to the render method in the pipe objects.]]
    self.pipePairs_table = {
        ['upper'] = Pipe('top', self.y),
        ['lower'] = Pipe('bottom', self.y + PIPE_HEIGHT + GAP_HEIGHT)
    }

    --[[Set wether this pipe pair is ready to be removed from the scene. It is good practice to not remove things from tables while
    iterating over the table itself. It will affect the indexes.]]
    self.remove = false

    --[[Sets wether or not the pipes have been scored on. This is what will be used for score checking.]]
    self.scored = false
end

function PipePair:update(dt)
    --Handle the removal of the pipe pairs from the scene if they go off of the screen or just simply update them with movement.
    if self.x > -PIPE_WIDTH then --If the pipe pairs are to the left of the screen bound update them with movement.
        self.x = self.x - PIPE_SCROLL * dt
        self.pipePairs_table['lower'].x = self.x
        self.pipePairs_table['upper'].x = self.x
    else
        self.remove = true --If the pipe pairs are not to the left of the screen bound then remove them.
    end
end

function PipePair:render()
    --Iterate over the pipe pairs table and call each pipe's render function.
    for i, pipe in pairs(self.pipePairs_table) do
        pipe:render()
    end
end