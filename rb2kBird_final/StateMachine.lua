StateMachine = Class{}

--[[Initialize the state machine to be empty.]]
function StateMachine:init(states)
    self.empty = {
        render = function() end,
        update = function() end,
        enter = function() end, 
        exit = function() end
    }

    self.states = states or {} --Set the state NAME of the state machine to the state it was instantiated with or an empty table.
    self.current = self.empty --Set the current state to an empty state.
end

--[[A function designed to handle the changing of states withing the state machine.]]
function StateMachine:change(stateName, enterParams)
    assert(self.states[stateName]) --The state must exist.
    self.current:exit() --Call the exit function from the current state (The default will be the "empty" state.).
    self.current = self.states[stateName]() --Set the current state to state with the [key] that matches the stateName string.
    self.current:enter(enterParams) --Call the enter function of the current state using the parameters from the call.
end

--[[The update function of that state machine. This will refer the updating dutites to the update logic of the current state.]]
function StateMachine:update(dt)
    self.current:update(dt)
end

--[[The render function of the state machine. This will refer the render duties to the render logic of the current state.]]
function StateMachine:render()
    self.current:render()
end