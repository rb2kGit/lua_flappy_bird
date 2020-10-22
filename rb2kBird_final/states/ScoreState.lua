ScoreState = Class{__includes = BaseState}

--[[When the score state is entered, set the score value to that of the score value from the params
that are passed in.]]
function ScoreState:enter(params)
    self.score = params.score
end

function ScoreState:update(dt)
    --Return to the play state when the user pressed enter.
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function ScoreState:render()
    --All that is done in this state is the rendering of the instructions along with the score.
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Oof, ya dead fam.', 0, 54, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: '.. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')

    love.graphics.printf('Please press enter to play agian.', 0, 160, VIRTUAL_WIDTH, 'center')
end
