--Using push for a virtual resolution.
push = require 'push'

--Require classes.
Class = require 'class'
require 'Bird'
require 'Pipe'
require 'PipePair' --Use a class that is made up of two pipes to control pipe spawning and movement.
--[[All the classes with the stae machine code.]]
require 'StateMachine'
require 'states/BaseState'
require 'states/PlayState'
require 'states/TitleScreenState'
require 'states/ScoreState'
require 'states/CountdownState'

--Initialize window variables.
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

--Initialize virtual resolution variables.
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

--[[Initialize local variables for the images that we are going to load. A local variable is one that is confined to it's scope.
In this case it cannot be accessed outside of this file.]]
local background = love.graphics.newImage('background.png')
local ground = love.graphics.newImage('ground.png')

--[[Initialize variables that will be used to handle scrolling.]]
--Initialize a background and ground scroll starting points on the x-axis.
local backgroundScroll = 0
local groundScroll = 0
--Initialize scrolling speeds.
local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60
--Create a looping point. A position on the x-axis that will trigger a reset.
local BACKGROUND_LOOPING_POINT = 413

--Initialize a variable to mange scrolling.
local scrolling = true

--Functions
--Keypressed function called everytime a key is pressed.
function love.keypressed(key)
    --Here we are storing the key that was pressed into the table that we created in load.
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
end

--[[A function created in the Lua keyboard function to test wether or not a key was pressed last frame. This will be used in conjunction with the
keypressed function in order to test for inputs.]]
function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

--Resize function designed to defer the resize handling to push.
function love.resize(w, h)
    push:resize(w, h)
end


function love.load()
    --Set a title for our app window.
    love.window.setTitle('rb2k F-Bird')

    --Initialize the display filter that we are going to use.
    love.graphics.setDefaultFilter('nearest', 'nearest')

    --Initialize push to set up our virtual resolution.
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    --[[Initialize fonts.]]
    smallFont = love.graphics.newFont('font.ttf', 8)
    mediumFont = love.graphics.newFont('flappy.ttf', 14)
    flappyFont = love.graphics.newFont('flappy.ttf', 28)
    hugeFont = love.graphics.newFont('flappy.ttf', 56)
    love.graphics.setFont(flappyFont)

    --[[Set up a table for audio.]]
    sounds = {
        ['jump'] = love.audio.newSource('jump.wav', 'static'),
        ['explosion'] = love.audio.newSource('explosion.wav', 'static'),
        ['hurt'] = love.audio.newSource('hurt.wav', 'static'),
        ['score'] = love.audio.newSource('score.wav', 'static'),
        ['music'] = love.audio.newSource('marios_way.mp3', 'static')
    }

    --[[Start playing the music on init.]]
    sounds['music']:setLooping(true)
    sounds['music']:play()

    --[[Initialize the state machine with state-returning functions.]]
    gStateMachine = StateMachine{
        ['title'] = function() return TitleScreenState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end,
        ['countdown'] = function() return CountdownState() end,
    }
    gStateMachine:change('title')

    --Seed the random function that we will be using to spawn pipes.
    math.randomseed(os.time())

    --[[Part of input handling for this game. Defining a new table in the Lua keyboard function. This table will be used to keep
    track of the keys that were pressed last frame. Once the next frame's update function executes, it will update the game
    baed on that key press. In this case, jumping.]]
    love.keyboard.keysPressed = {}
end

function love.update(dt)
    --Here we create the scrolling effect by looping the image back x = 0 once it reaches the scroll point.
    --The way we do this is modulo the scroll point to the backgroundScroll position until it produce a 0. Which means it will set to 0.
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
    --The way we do this with the foreground image is modulo the front image to the screen width. Since it does not need to be seemless.
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH

    --[[Update the game using the state machine. The state machine will defer the update to the update method
    of the current state.]]
    gStateMachine:update(dt)

    --Reset the input handling table that we created.
    love.keyboard.keysPressed = {}
end

function love.draw()
    --Updated push function to start and finish drawing.
    push:start()

    --Draw the background first and then ground on top.
    love.graphics.draw(background, -backgroundScroll, 0)
    gStateMachine:render()
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)
    
    push:finish()
end
