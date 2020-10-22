CountdownState = Class{__includes = BaseState}

--[[Create a variable to set the amount of time between countdowns.]]
COUNTDOWN_TIME = 1

function CountdownState:init()
    self.count = 3
    self.timer = 0
end

--[[The update function in this state will keep track of how much time has passed and decreases the timer
each 1 second (according to COUNTDOWN_TIME). When the timer is at zero, transition to the play state.]]
function CountdownState:update(dt)
    self.timer = self.timer + dt

    --
    if self.timer > COUNTDOWN_TIME then
        self.timer = self.timer % COUNTDOWN_TIME
        self.count = self.count - 1

        if self.count == 0 then
            gStateMachine:change('play')
        end
    end
end

function CountdownState:render()
    love.graphics.setFont(hugeFont)
    love.graphics.printf(tostring(self.count), 0, 120, VIRTUAL_WIDTH, 'center')
end