-------------------------------------------------------------------------
--T and G Apps Ltd.
--Created by Joseph Stevens
--www.tandgapps.co.uk
--joe@tandgapps.co.uk

--CoronaSDK version 2013.1179 was used for this template.

--You are not allowed to publish this template to the Appstore as it is. 
--You need to work on it, improve it and replace the graphics. 

--For questions and/or bugs found, please contact me using our contact
--form on http://www.tandgapps.co.uk/contact-us/
-------------------------------------------------------------------------



--Start off by requiring storyboard and creating a scene.
local composer = require( "composer" )
local scene = composer.newScene()

--Setup the display groups we want, made in createScene
local uiBackGroup
local uiFrontGroup
local targetLabelsGroup
local tileGridGroup
local particleGroup

local xMin = display.screenOriginX  --Cross platform vars, handy for positioning etc!
local yMin = display.screenOriginY+20
local xMax = display.contentWidth - display.screenOriginX
local yMax = display.contentHeight - display.screenOriginY
local xWidth = xMax-xMin --The total width
local yHeight = yMax-yMin --The total height
local _W = display.contentWidth
local _H = display.contentHeight

local menuButtonText = display.newImageRect("images/home.png", 30,30)
menuButtonText.anchorX = 0
menuButtonText.anchorY = 0
menuButtonText.x = 0; menuButtonText.y = 0;
    

-- Import classes
local tile = require("tile")
local particle = require("particle")

print(_W)


-- Tile dragging variables
local isDraggingTile = false
local touchStartX = 0
local touchStartY = 0
local touchTileIndex = 0
local tileDragDirection = 0  -- 0 = North, 1 = East, 2 = South, 3 = West

--Other control vars and timers.
local tiles = {} --Holds the tiles
local difficulty = 8
local particles = {}
local totalTiles = {}
local timeLeft = 100
local totalTimeLeft = 100
local mainTimer
local secondTimer
local noticeTimer
local testBoard = {}
local shouldCheckMoves = false
local isGameover = false
local makePopSound = false

--Set up sprites...
local backgroundImage
local scoreLabel
local targetTotalLabel
local targetLabel = {}
local timerBar
local statusNoticeLabel
local gameBorder
local borderBackground
local targetFruits
local tileMask
local targetFruitsBackground
local targetBackground
local scoreBackground
local timerBackground


-----------------------------------------------
--*** Functions ***
-----------------------------------------------
-- Hides the text currently in the center of the screen
local function hideStatusMessage ()
    statusNoticeLabel:removeSelf()
    statusNoticeLabel = nil
end

 

-- Restart the level
local function resetLevel (statusNotice, doRefill)
    -- Show a notice in the middle of the screen
    statusNoticeLabel = display.newText(statusNotice, 0, 0, native.systemFontBold, 16)
    statusNoticeLabel.x = _W / 2
    statusNoticeLabel.y = 200
    statusNoticeLabel:setFillColor(0, 0, 0)
    uiFrontGroup:insert(statusNoticeLabel)
    -- Hide all tiles
    for i = 1, 64 do
        if tiles[i] ~= nil then
            tiles[i].tileImage.isVisible = false
        end
    end
    -- Refill board
    if doRefill then
        -- Hide the notice in the center of the screen in three seconds
        noticeTimer = timer.performWithDelay(3000, hideStatusMessage)
        for i = 1, 64 do
            local isNotRow = true
            local tileType = 0
            if tiles[i] ~= nil then
                tiles[i].tileImage:removeSelf()
            end
            repeat
                tileType = math.random(1, difficulty)
                isNotRow = true
                -- Try a different tile if the current tile makes 3 in a row
                if (i - 1) % 8 > 1 then
                    if tileType == tiles[i - 1].tileType and tileType == tiles[i - 2].tileType then
                        isNotRow = false
                    end
                end
                if math.floor((i - 1) / 8) > 1 then
                    if tileType == tiles[i - 8].tileType and tileType == tiles[i - 16].tileType then
                        isNotRow = false
                    end
                end
            until isNotRow
            tiles[i] = tile.new(tileType, i)
            tileGridGroup:insert(tiles[i].tileImage)
            --push over the tiles
            --reposition for ipad, otherwise set to zero esp for nook
          
            if _W > 320 then
                tileGridGroup.x=20
            else
                tileGridGroup.x = 0
            end
        end
    end
end

-- Go back to the menu when the main menu button is pressed
    local function backToMenu (event)
        if event.phase == "ended" then
            playSound("select")
            composer.gotoScene( "menu", "fade", 400 )
        end
        return true
    end

menuButtonText:addEventListener("touch",backToMenu)

-- Returns true if a line of 3 or more tiles was found
local function checkLines ()
    for i = 1, 64 do
        if (i - 1) % 8 > 1 then
            if tiles[i].tileType == tiles[i - 1].tileType and tiles[i].tileType == tiles[i - 2].tileType then
                return true
            end
        end
        if math.floor((i - 1) / 8) > 1 then
            if tiles[i].tileType == tiles[i - 8].tileType and tiles[i].tileType == tiles[i - 16].tileType then
                return true
            end
        end
    end
    return false
end

-- Remove tiles and make other tiles fall
local function updateGravity ()
    -- Make current visible tiles fall
    for i = 56, 1, -1 do
        local vIndex = i + 8
        local fallingHeight = 0
        if not tiles[i].willBePopped then
            while tiles[vIndex].willBePopped do
                fallingHeight = fallingHeight + 1
                vIndex = vIndex + 8
                if vIndex > 64 then
                    break
                end
            end
            vIndex = vIndex - 8
            tiles[vIndex].tileOffsetY = fallingHeight * 40
            tiles[i].willBePopped = true
            tiles[vIndex].willBePopped = false
            tiles[vIndex]:setTileType(tiles[i].tileType)
        end
    end

    -- Replace empty tiles
    for i = 64, 1, -1 do
        if tiles[i].willBePopped then
            local vIndex = i - 8
            local fallingHeight = 1
            if vIndex > 8 then
                while tiles[vIndex].willBePopped do
                    fallingHeight = fallingHeight + 1
                    vIndex = vIndex - 8
                    if vIndex < 1 then
                        break
                    end
                end
            end
            vIndex = i
            while tiles[vIndex].willBePopped do
                tiles[vIndex].tileOffsetY = fallingHeight * 40
                tiles[vIndex].willBePopped = false
                tiles[vIndex]:setTileType(math.random(1,difficulty))
                vIndex = vIndex - 8
                if vIndex < 1 then
                    break
                end
            end
        end
    end

    -- Check if level is complete
    local levelComplete = true
    for i = 1, difficulty do
        if totalTiles[i] < target then
            levelComplete = false
            break
        end
    end

    if levelComplete then
        local levelUpScore = 1000 * target
        target = target + 1
        for i = 1, difficulty do
            totalTiles[i] = 0
        end
        resetLevel("Level Up!  Score +" .. levelUpScore, true)
        overallScore = overallScore + levelUpScore
        totalTimeLeft = totalTimeLeft + 10
        timeLeft = timeLeft + 100
        if timeLeft > totalTimeLeft then
            timeLeft = totalTimeLeft
        end
    end
end

-- Make matching lines of tiles pop and add to the player's score
local function scoreLines ()
    local scoreThisMove = 0
    for i = 1, 64 do
        -- Check if there's a horizontal line of three or more matching tiles
        if (i - 1) % 8 < 6 then
            if tiles[i].tileType == tiles[i + 1].tileType and tiles[i].tileType == tiles[i + 2].tileType then
                local hIndex = i + 1
                makePopSound = true
                if scoreThisMove == 0 then
                    scoreThisMove = 5
                end
                while tiles[i].tileType == tiles[hIndex].tileType and not tiles[hIndex].hasBeenCheckedH do
                    scoreThisMove = scoreThisMove * 5
                    tiles[hIndex].hasBeenCheckedH = true
                    if not tiles[hIndex].willBePopped then
                        table.insert(particles, particle.new(tiles[hIndex].tileType, tiles[hIndex].tileImage.x, tiles[hIndex].tileImage.y))
                        totalTiles[tiles[hIndex].tileType] = totalTiles[tiles[hIndex].tileType] + 1
                    end
                    tiles[hIndex].willBePopped = true
                    if (hIndex - 1) % 8 == 7 then
                        break
                    end
                    hIndex = hIndex + 1
                end
                tiles[i].hasBeenCheckedH = true
                if not tiles[i].willBePopped then
                    table.insert(particles, particle.new(tiles[i].tileType, tiles[i].tileImage.x, tiles[i].tileImage.y))
                    totalTiles[tiles[i].tileType] = totalTiles[tiles[i].tileType] + 1
                end
                tiles[i].willBePopped = true
            end
        end
        -- Check if there's a vertical line of three or more matching tiles
        if math.floor((i - 1) / 8) < 6 then
            if tiles[i].tileType == tiles[i + 8].tileType and tiles[i].tileType == tiles[i + 16].tileType then
                local vIndex = i + 8
                makePopSound = true
                if scoreThisMove == 0 then
                    scoreThisMove = 5
                end
                while tiles[i].tileType == tiles[vIndex].tileType and not tiles[vIndex].hasBeenCheckedV do
                    scoreThisMove = scoreThisMove * 5
                    tiles[vIndex].hasBeenCheckedV = true
                    if not tiles[vIndex].willBePopped then
                        table.insert(particles, particle.new(tiles[vIndex].tileType, tiles[vIndex].tileImage.x, tiles[vIndex].tileImage.y))
                        totalTiles[tiles[vIndex].tileType] = totalTiles[tiles[vIndex].tileType] + 1
                    end
                    tiles[vIndex].willBePopped = true
                    if vIndex > 56 then
                        break
                    end
                    vIndex = vIndex + 8
                end
                tiles[i].hasBeenCheckedH = true
                if not tiles[i].willBePopped then
                    table.insert(particles, particle.new(tiles[i].tileType, tiles[i].tileImage.x, tiles[i].tileImage.y))
                    totalTiles[tiles[i].tileType] = totalTiles[tiles[i].tileType] + 1
                end
                tiles[i].willBePopped = true
            end
        end
    end

    -- Reset the hasBeenChecked values of each tile
    for i = 1, 64 do
        tiles[i].hasBeenCheckedV = false
        tiles[i].hasBeenCheckedH = false
    end

    -- Add to the player's score and update the board's gravity
    overallScore = overallScore + scoreThisMove
    updateGravity()
end

-- Check the temporary test board to see if a move has been made
local function checkTestBoard ()
    for i = 1, 64 do
        -- Check for a horizontal line of three
        if (i - 1) % 8 < 6 then
            if testBoard[i] == testBoard[i+1] and testBoard[i] == testBoard[i+2] then
                return true
            end
        end
        -- Check for a vertical line of three
        if i < 49 then
            if testBoard[i] == testBoard[i+8] and testBoard[i] == testBoard[i+16] then
                return true
            end
        end
    end
    return false
end

-- Check if there are any moves available
local function checkAllMoves ()
    -- Create a temporary board which we can use to try possible moves on
    for i = 1, 64 do
        testBoard[i] = tiles[i].tileType
    end

    --Go through every tile moving the tile horizontally, and then vertically
    for i = 1, 64 do
        local tempSwapTileType
        tempSwapTileType = testBoard[i]
        -- Swap tiles horizontally
        if (i - 1) % 8 ~= 7 then
            testBoard[i] = testBoard[i + 1]
            testBoard[i + 1] = tempSwapTileType
            if checkTestBoard() then
                return true
            end
            testBoard[i + 1] = testBoard[i]
            testBoard[i] = tempSwapTileType
        end
        -- Swap tiles vertically
        if i < 57 then
            testBoard[i] = testBoard[i + 8]
            testBoard[i + 8] = tempSwapTileType
            if checkTestBoard() then
                return true
            end
            testBoard[i + 8] = testBoard[i]
            testBoard[i] = tempSwapTileType
        end
    end
    return false
end

-- Main game tick - Run every .02 of a second
local function gameTick (event)
    local moveTilesBack = false
    local shouldCheckTiles = true

    -- Run every tile's update() function
    for i = 1, 64 do
        tiles[i]:update()
        if tiles[i].fallingHeight ~= 0 or tiles[i].tileOffsetX ~= 0 or tiles[i].tileOffsetY ~= 0 or tiles[i].willBePopped then
            shouldCheckTiles = false
            shouldCheckMoves = true
        end
    end

    -- If nothing is moving right now, check for matches
    if shouldCheckTiles then
        moveTilesBack = not checkLines()

        -- If no tile matches were found and a tile was moved, move the tile back
        if moveTilesBack then
            for i = 1, 64 do
                local thisTileType = tiles[i].tileType
                if tiles[i].shouldMoveBack and tiles[i].moveBackDirection == 0 then
                    tiles[i]:setTileType(tiles[i - 8].tileType)
                    tiles[i - 8]:setTileType(thisTileType)
                    tiles[i].tileOffsetY = 40
                    tiles[i - 8].tileOffsetY = -40
                    tiles[i].shouldMoveBack = false
                    tiles[i - 8].shouldMoveBack = false
                    tiles[i].moveBackDirection = 0
                    tiles[i - 8].moveBackDirection = 0
                elseif tiles[i].shouldMoveBack and tiles[i].moveBackDirection == 3 then
                    tiles[i]:setTileType(tiles[i - 1].tileType)
                    tiles[i - 1]:setTileType(thisTileType)
                    tiles[i].tileOffsetX = 40
                    tiles[i - 1].tileOffsetX = -40
                    tiles[i].shouldMoveBack = false
                    tiles[i - 1].shouldMoveBack = false
                    tiles[i].moveBackDirection = 0
                    tiles[i - 1].moveBackDirection = 0
                end
            end
        else
            -- A line of three or more was found, reset shouldMoveBack and give the player some points for matching tiles
            for i = 1, 64 do
                if tiles[i].shouldMoveBack then
                    tiles[i].shouldMoveBack = false
                    tiles[i].moveBackDirection = 0
                end
            end
            scoreLines()

            -- Check if there are any more moves available
            if shouldCheckMoves then
                shouldCheckMoves = false
                if not checkAllMoves() then
                    -- No more moves available
                    local noMoreMoveScore = 2000 * target
                    resetLevel("No more moves!  Score +" .. noMoreMoveScore, true)
                    overallScore = overallScore + noMoreMoveScore
                    timeLeft = timeLeft + 20
                    if timeLeft > totalTimeLeft then
                        timeLeft = totalTimeLeft
                    end
                end
            end
        end
    end

    -- Update particles
    for i = #particles, 1, -1 do
        particles[i]:update()
        -- Remove a particle if it isn't alive any more
        if not particles[i].isAlive then
            table.remove(particles, i)
            i = i - 1
        end
    end

    -- Update UI
    scoreLabel.text = "Score: " .. overallScore
    targetTotalLabel.text = "Target: " .. target
    for i = 1, difficulty do
        targetLabel[i].text = totalTiles[i]
        if totalTiles[i] >= target then
            targetLabel[i].alpha = 0.3
        else
            targetLabel[i].alpha = 1
        end
    end

    -- Add any newly created particles and tiles to their groups
    for i = 1, 64 do
        tileGridGroup:insert(tiles[i].tileImage)
    end

    for i = 1, #particles do
        tileGridGroup:insert(particles[i].particleImage)
    end

    if makePopSound then
        makePopSound = false
        playSound("pop")
    end
end

-- Move a tile in a direction
local function dragTile (tileIndex, dragDirection)
    local thisTileType = tiles[tileIndex].tileType
    if dragDirection == 0 then
        tiles[tileIndex]:setTileType(tiles[tileIndex - 8].tileType)
        tiles[tileIndex - 8]:setTileType(thisTileType)
        tiles[tileIndex].tileOffsetY = 40
        tiles[tileIndex - 8].tileOffsetY = -40
        tiles[tileIndex].shouldMoveBack = true
        tiles[tileIndex - 8].shouldMoveBack = true
        tiles[tileIndex].moveBackDirection = 0
        tiles[tileIndex - 8].moveBackDirection = 2
    elseif dragDirection == 2 then
        dragTile(tileIndex + 8, 0)
    elseif dragDirection == 3 then
        tiles[tileIndex]:setTileType(tiles[tileIndex - 1].tileType)
        tiles[tileIndex - 1]:setTileType(thisTileType)
        tiles[tileIndex].tileOffsetX = 40
        tiles[tileIndex - 1].tileOffsetX = -40
        tiles[tileIndex].shouldMoveBack = true
        tiles[tileIndex - 1].shouldMoveBack = true
        tiles[tileIndex].moveBackDirection = 3
        tiles[tileIndex - 1].moveBackDirection = 1
    elseif dragDirection == 1 then
        dragTile(tileIndex + 1, 3)
    end
end

-- Run when the user touches the screen
local function onObjectTouch (event)
    if event.phase == "began" then
        -- Don't allow touches if something is happening or the game is over
        for i = 1, 64 do
            if tiles[i].fallingHeight ~= 0 or tiles[i].tileOffsetX ~= 0 or tiles[i].tileOffsetY ~= 0 or tiles[i].willBePopped or isGameover then
                return true
            end
        end

        -- If the touch is within the screen, record the touches position
        if event.y > 100 and event.y < 420 then
            touchStartX = event.x
            touchStartY = event.y
            touchTileIndex = math.floor((touchStartY - 100) / 40) * 8 + math.floor(touchStartX / 40) % 8 + 1
            isDraggingTile = true
        end
    elseif event.phase == "ended" then
        if isDraggingTile then
            local dragDistanceX = event.x - touchStartX
            local dragDistanceY = event.y - touchStartY
            local isLeft = false
            local isUp = false

            isDraggingTile = false

            -- Only accept drags over 20 pixels
            if dragDistanceY < 20 and dragDistanceY > -20 and dragDistanceX < 20 and dragDistanceX > -20 then
                return true
            end

            -- Work out which direction the user dragged
            if dragDistanceY < 0 then
                isUp = true
            elseif dragDistanceY > 0 then
                isUp = false
            end

            if dragDistanceX < 0 then
                isLeft = true
            elseif dragDistanceX > 0 then
                isLeft = false
            end

            -- Work out which direction the user dragged the furthest
            if dragDistanceX < 0 then
                dragDistanceX = -dragDistanceX
            end

            if dragDistanceY < 0 then
                dragDistanceY = -dragDistanceY
            end

            if dragDistanceY > dragDistanceX then
                if isUp then
                    tileDragDirection = 0
                else
                    tileDragDirection = 2
                end
            else
                if isLeft then
                    tileDragDirection = 3
                else
                    tileDragDirection = 1
                end
            end

            -- Don't allow tiles on the edge of the board to be dragged offscreen
            if (touchTileIndex < 9 and tileDragDirection == 0) or
               ((touchTileIndex - 1) % 8 == 7 and tileDragDirection == 1) or
               (touchTileIndex > 56 and tileDragDirection == 2) or
               ((touchTileIndex - 1) % 8 == 0 and tileDragDirection == 3) then
                return true
            end

            -- Begin dragging the tile
            dragTile (touchTileIndex, tileDragDirection)
        end
    end
    return true
end

-- Count down time remaining
local function secondTimerTick(event)
    if timeLeft ~= 0 then
        timeLeft = timeLeft - 1
        timerBar.width = xWidth * (timeLeft/totalTimeLeft)
        timerBar.x = xMin + timerBar.width / 2
    else
        -- If the time is over then stop the game
        if not isGameover then
            isGameover = true
            timer.cancel(mainTimer); mainTimer = nil
            timer.cancel(secondTimer); secondTimer = nil
            composer.gotoScene( "gameover", "fade", 400 )
        end
    end
end



-----------------------------------------------
-- *** STORYBOARD SCENE EVENT FUNCTIONS ***
------------------------------------------------
-- Called when the scene's view does not exist:
-- Create all your display objects here.
function scene:create( event )
    print( "Game: createScene event")
    local screenGroup = self.view

    print( "Game: enterScene event" )

    -- Completely remove the previous scene/all scenes.
    -- Handy in this case where we want to keep everything simple.
    --composer.removeAll()

    --Start out timers etc now -- Add event listener also
    mainTimer = timer.performWithDelay(20, gameTick, 0)
    secondTimer = timer.performWithDelay(1000, secondTimerTick, 0)
    Runtime:addEventListener("touch", onObjectTouch)

    --Now make our display groups
    --In this case we insert them later on after the objects have been inserted.
   	uiBackGroup = display.newGroup()
	uiFrontGroup = display.newGroup()
	targetLabelsGroup = display.newGroup()
	tileGridGroup = display.newGroup()
	particleGroup = display.newGroup()


    ------------
    -- DISPLAY OBJECTS
    ------------
   

	scoreLabel = display.newText("Score: 0", 0, 0, native.systemFontBold, 16)
	scoreLabel.x = _W / 2
	scoreLabel.y = yMax - 12
	scoreLabel:setFillColor(0, 0, 0)

     local paint = {
        type = "image",
        filename = "game_images/bg.png"
    }

    backgroundImage = display.newRoundedRect (0, 0, _W-15, _H-30, 3)
    backgroundImage.fill = paint
    backgroundImage.x = _W/ 2
    backgroundImage.y = scoreLabel.y+10    

	targetTotalLabel = display.newText("Target: 3", 0, 0, native.systemFontBold, 16)
	targetTotalLabel.x = _W / 2
	targetTotalLabel.y = 85
	targetTotalLabel:setFillColor(0, 0, 0)

	for i = 1, difficulty do
        targetLabel[i] = display.newText("0", 0, 0, native.systemFontBold, 16)
        --edit per screen width
        if _W > 320 then
            targetLabel[i].x = 40 + i * 30
        else
            targetLabel[i].x = 25 + i * 30
        end
        targetLabel[i].y = yMin + 15
        targetLabel[i]:setFillColor(0, 0, 0)
        targetLabelsGroup:insert(targetLabel[i])
        targetLabel[i].alpha = 1
        totalTiles[i] = 0
    end

	timerBar = display.newRect(_W*0.5, 440, xWidth, 10)
    timerBar:setFillColor(72/255, 153/255, 61/255)
    timerBar.y = scoreLabel.y-20

	timerBackground = display.newRect(_W*0.5, 440, xWidth, 10)
    timerBackground.y = timerBar.y

	
	borderBackground = display.newImageRect("game_images/border.png", 360, 570)
	borderBackground.x = _W / 2
	borderBackground.y = _H 
    
	targetFruits = display.newImageRect("game_images/tiles.png", 237, 30)
	targetFruits.x = _W / 2 - 0.5
	targetFruits.y = yMin + 45
	
	targetFruitsBackground = display.newRoundedRect(0, 0, 300, 75, 3)
	targetFruitsBackground.x = _W / 2
	targetFruitsBackground.y = yMin + 65
	targetFruitsBackground.alpha = 0.8

	targetBackground = display.newRoundedRect(0, 0, 300, 30, 3)
	targetBackground.x = _W / 2
	targetBackground.y = 81
	targetBackground.alpha = 0.8

	scoreBackground = display.newRect(0, 0, 300, 20)
	scoreBackground.x = _W / 2
	scoreBackground.y = yMax - 10
	scoreBackground.alpha = 0.8

	-- Add the UI to groups
	uiBackGroup:insert(borderBackground)
	uiBackGroup:insert(backgroundImage)
	uiBackGroup:insert(timerBackground)
	uiFrontGroup:insert(targetFruitsBackground)
	uiFrontGroup:insert(targetBackground)
	uiFrontGroup:insert(scoreBackground)
	uiFrontGroup:insert(targetTotalLabel)
	uiFrontGroup:insert(targetLabelsGroup)
	uiFrontGroup:insert(timerBar)
	uiFrontGroup:insert(targetFruits)
	uiFrontGroup:insert(scoreLabel)
    uiFrontGroup:insert(menuButtonText)
	screenGroup:insert(borderBackground)
	screenGroup:insert(uiBackGroup)
	screenGroup:insert(tileGridGroup)
	screenGroup:insert(uiFrontGroup)
	--screenGroup:insert(gameBorder)

	-- Create an array of random tiles
	math.randomseed(os.time())
	resetLevel("Start!", true)
	overallScore = 0
	target = 3
end



-- Called immediately after scene has moved onscreen:
-- Start timers/transitions etc.
function scene:enter( event )
    --[[print( "Game: enterScene event" )

    -- Completely remove the previous scene/all scenes.
    -- Handy in this case where we want to keep everything simple.
    composer.removeAll()

    --Start out timers etc now -- Add event listener also
	mainTimer = timer.performWithDelay(20, gameTick, 0)
	secondTimer = timer.performWithDelay(1000, secondTimerTick, 0)
	Runtime:addEventListener("touch", onObjectTouch)]]
end



-- Called when scene is about to move offscreen:
-- Cancel Timers/Transitions and Runtime Listeners etc.
function scene:exit( event )
    print( "Game: exitScene event" )
    Runtime:removeEventListener("touch", onObjectTouch);
	if mainTimer then timer.cancel(mainTimer); mainTimer = nil; end
	if secondTimer then timer.cancel(secondTimer); secondTimer = nil; end
	if noticeTimer then timer.cancel(noticeTimer); noticeTimer = nil; end
end



--Called prior to the removal of scene's "view" (display group)
function scene:destroy( event )
    print( "Game: destroying view" )
end




-----------------------------------------------
-- Add the story board event listeners
-----------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "enter", scene )
scene:addEventListener( "exit", scene )
scene:addEventListener( "destroy", scene )



--Return the scene to storyboard.
return scene




	
