PlayState = Class{__includes = BaseState} --This is how to inheirit from another class. Here we are inhereiting the empty functions.

--[[The PlayState is where all the play logic is located]]
--Set the speed of the pipe scroll.
PIPE_SCROLL = 60

--Initialize the height and width of the pipes, that will be globally accessible.
PIPE_HEIGHT = 288
PIPE_WIDTH = 70

function PlayState:init()
    --[[Create an instance of the Bird class.]]
    self.bird = Bird{}
    --[[Create a table to hold the pipe pairs that we will spawn.]]
    self.pipePairs_table = {}
    --[[Create a pipe spawn timer variable.]]
    self.pipeTimer = 0
    --[[Create a score variable.]]
    self.score = 0

    --[[Initialize a variable that will be used to keep track of where the last Y value between pairs of pipes was spawned. This will be used to determine
    how to crate the gap between the next pair of pipes.]]
    self.lastY = -PIPE_HEIGHT + math.random(80) + 20
end

function PlayState:update(dt)
    --[[Update the pipeTimer variable by adding delta time to it. Delta time will return a decimal because it counts according to framerate,
    1/60th of a second (60 fps). This means that if a pipe is to be spawned after two seconds we will keep adding to the pipeTimer until
    it reaches the whole number 2. Then spawn a pipe and reset the timer back to 0.]]
    self.pipeTimer = self.pipeTimer + dt

    if self.pipeTimer > 2 then
        local y = math.max(-PIPE_HEIGHT + 20, --If the greater number is 10 pixels more than the bottom of the screen (-PIPe_HEIGHT) return this
                            math.min(self.lastY + math.random(-20, 20) --If the greater number is a random number between -20 and 20 from the last Y return this
                                , VIRTUAL_HEIGHT - 70 - PIPE_HEIGHT)) --OR if the greater number is 90 pixels up from the bottom of the screen.

        self.lastY = y --Set the last Y to the Y of this current pipe pair.

        table.insert(self.pipePairs_table, PipePair(y)) --Insert the new pipe pairs into the table.
        
        self.pipeTimer = 0 -- Reset the pipe spawn timer.

        --[[Loop through the pipes and increase the score if the pipe pairs have moved to the left of the bird. Making sure to ignore the
        pipes if they have already been scored on.]]
        for i, pair in pairs(self.pipePairs_table) do --If the pipe has already been scored on, the score update will be skipped.
            if not pair.scored then
                if pair.x + PIPE_WIDTH < self.bird.x then
                    self.score = self.score + 1
                    pair.scored = true
                    sounds['score']:play()
                end
            end 
        end
    end
    
    --We call the update function that is located in our bird class.
    self.bird:update(dt)

    --[[We will need to update all the pipes in our pipe table using an iterative loop. We will also do collison detection here.
    In order to iterate over a table Lua gives you a function called pairs.]]
    for i, pair in pairs(self.pipePairs_table) do
        pair:update(dt)
        
        for j, pipe in pairs(pair.pipePairs_table) do
            if self.bird:collides(pipe) then
                sounds['explosion']:play()
                sounds['hurt']:play()

                gStateMachine:change('score', {
                    score = self.score
                })
            end
        end

        if pair.x < -PIPE_WIDTH then
            pair.remove = true
        end
    end

    --[[Remove the pipe pairs.]]
    for i, pair in pairs(self.pipePairs_table) do
        if pair.remove then
            table.remove(self.pipePairs_table, i)
        end
    end

    --[[Reset if we hit the ground.]]
    if self.bird.y > VIRTUAL_HEIGHT -15 then
        sounds['explosion']:play()
        sounds['hurt']:play()

        gStateMachine:change('score' ,{
            score = self.score
        })
    end
end

function PlayState:render()
    --Draw the pipes from the table here in order to layer them in between the background and the ground.
    for i, pair in pairs(self.pipePairs_table) do
        pair:render()
    end

    --Draw the bird
    self.bird:render()

    --[[Render the score in the top left corner of the screen.]]
    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)
end