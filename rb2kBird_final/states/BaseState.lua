BaseState = Class{}

--[[This is the State class in which the various state classes will inhereit their methods. This is done so that the StateMachine class can call these
methods without having to define empty methods when the state is set to empty]]

function BaseState:init() end
function BaseState:enter() end
function BaseState:exit() end
function BaseState:update(dt) end
function BaseState:render() end