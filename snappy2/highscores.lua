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


-- Set up our variables
local xMin = display.screenOriginX 
local yMin = display.screenOriginY
local xMax = display.contentWidth - display.screenOriginX
local yMax = display.contentHeight - display.screenOriginY
local xWidth = xMax-xMin --The total width
local yHeight = yMax-yMin --The total height
local _W = display.contentWidth
local _H = display.contentHeight

local showLevels = false;




-----------------------------------------------
-- *** STORYBOARD SCENE EVENT FUNCTIONS ***
------------------------------------------------
-- Called when the scene's view does not exist:
-- Create all your display objects here.
function scene:create( event )
    print( "Highscores: createScene event")
    local screenGroup = self.view

    --Now make our display groups and insert them into the screengroup.
    local bgGroup = display.newGroup()
    local tabGroup = display.newGroup()
    local scoreTableGroup = display.newGroup()
   	screenGroup:insert(bgGroup)
    screenGroup:insert(tabGroup)
    screenGroup:insert(scoreTableGroup)

    
    ------------
    -- DISPLAY OBJECTS
    ------------
    --Create the main UI
	local backgroundImage = display.newImageRect("game_images/menu_bg.png", 360, 570)
	local scoresButtonText = display.newText("sort scores", 0, 0, native.systemFontBold, 16)
	local scoresButton = display.newRoundedRect(0, 0, 100, 30, 3)
	local levelsButtonText = display.newText("sort levels", 0, 0, native.systemFontBold, 16)
	local levelsButton = display.newRoundedRect(0, 0, 100, 30, 3)
	local chartBackground = display.newRoundedRect (0, 0, _W-50, _H-200, 3)
	local menuButtonText = display.newImageRect("game_images/mainmenu.png", 228, 36)
	local tableColumnScore = display.newText("Score", 0, 0, native.systemFontBold, 16)
	local tableColumnLevel = display.newText("Level", 0, 0, native.systemFontBold, 16)
	local highscoreTitle = display.newImageRect("game_images/highscores.png", 256, 36)


    -- Go back to the menu when the main menu button is pressed
	local function backToMenu (event)
		if event.phase == "ended" then
			playSound("select")
			composer.gotoScene( "menu", "fade", 400 )
		end
		return true
	end

	-- Update the table of scores
	local function updateUI ()
		-- Open the SQLite database
		local dbPath = system.pathForFile("fruit_scores.db3", system.DocumentsDirectory)
		local db = sqlite3.open(dbPath)

		-- Clear the table
		for i = 1, 20, 2 do
			scoreTableGroup[i].text = "0"
			scoreTableGroup[i].x = 33 + scoreTableGroup[i].width / 2
			scoreTableGroup[i + 1].text = "0"
			scoreTableGroup[i + 1].x = 290 - scoreTableGroup[i + 1].width / 2
		end

		-- Display the scores for the currently selected tab
		if showLevels then
			scoresButton.alpha = 0.3
			scoresButtonText.alpha = 0.3
			levelsButton.alpha = 1
			levelsButtonText.alpha = 1

			-- Get the scores from the database
			local scoreIndex = 1
			for row in db:nrows("SELECT * FROM levels ORDER BY level DESC") do
				scoreTableGroup[scoreIndex].text = row.score
				scoreTableGroup[scoreIndex].x = 33 + scoreTableGroup[scoreIndex].width / 2
				scoreTableGroup[scoreIndex + 1].text = row.level
				scoreTableGroup[scoreIndex + 1].x = 290 - scoreTableGroup[scoreIndex + 1].width / 2
				scoreIndex = scoreIndex + 2
		    end
		else
			scoresButton.alpha = 1
			scoresButtonText.alpha = 1
			levelsButton.alpha = 0.3
			levelsButtonText.alpha = 0.3

			-- Get the scores from the database
			local scoreIndex = 1
			for row in db:nrows("SELECT * FROM scores ORDER BY score DESC") do
				scoreTableGroup[scoreIndex].text = row.score
				scoreTableGroup[scoreIndex].x = 33 + scoreTableGroup[scoreIndex].width / 2
				scoreTableGroup[scoreIndex + 1].text = row.level
				scoreTableGroup[scoreIndex + 1].x = 290 - scoreTableGroup[scoreIndex + 1].width / 2
				scoreIndex = scoreIndex + 2
		    end
		end
		db:close()
	end

	-- Change the score table to show highest scores
	local function scoresOnTouch(event)
		if event.phase == "ended" then
			playSound("select")
			showLevels = false
			updateUI()
		end
		return true
	end

	-- Change the score table to show the highest levels
	local function levelsOnTouch(event)
		if event.phase == "ended" then
			playSound("select")
			showLevels = true
			updateUI()
		end
		return true
	end

	-----------------------------------------------
	--*** Init ***
	-----------------------------------------------
	-- Set up the UI
	backgroundImage.x = _W/2
	backgroundImage.y = _H

	scoresButtonText:setFillColor(0, 0, 0)
	scoresButtonText.x = _W/2-80
	scoresButtonText.y = yMin + 90
	scoresButtonText.alpha = 0.3

	scoresButton.strokeWidth = 1;
	scoresButton:setFillColor (1, 1, 1)
	scoresButton:setStrokeColor (0, 0, 0)
	scoresButton.x = _W/2-80
	scoresButton.y = yMin + 95
	scoresButton.alpha = 0.3

	levelsButtonText:setFillColor(0, 0, 0)
	levelsButtonText.x = _W/2+80
	levelsButtonText.y = scoresButtonText.y
	levelsButtonText.alpha = 0.3

	levelsButton.strokeWidth = 1;
	levelsButton:setFillColor (1, 1, 1)
	levelsButton:setStrokeColor (0, 0, 0)
	levelsButton.x = _W/2+80
	levelsButton.y = scoresButton.y
	levelsButton.alpha = 0.3

	chartBackground.strokeWidth = 1;
	chartBackground:setFillColor (1, 1, 1)
	chartBackground:setStrokeColor (0, 0, 0)
	chartBackground.x = _W / 2
	chartBackground.y = _H-80

	menuButtonText.x = _W / 2
	menuButtonText.y = yMax - 30

	highscoreTitle.x = _W / 2
	highscoreTitle.y = yMin + 60


	-- Add the UI to the local group
	bgGroup:insert(backgroundImage)
	tabGroup:insert(scoresButton)
	tabGroup:insert(levelsButton)
	tabGroup:insert(chartBackground)
	tabGroup:insert(scoresButtonText)
	tabGroup:insert(levelsButtonText)
	screenGroup:insert(menuButtonText)
	screenGroup:insert(highscoreTitle)


	-- Create the table of scores
	tableColumnScore.x = 33 + tableColumnScore.width / 2
	tableColumnScore.y = yMin + 115
	tableColumnScore:setFillColor(1,1,1)
	tableColumnLevel.x = 290 - tableColumnLevel.width / 2
	tableColumnLevel.y = tableColumnScore.y
	tableColumnLevel:setFillColor(1,1,1)
	screenGroup:insert(tableColumnScore)
	screenGroup:insert(tableColumnLevel)

	for i = 1, 10 do 
		local tableRowScore = display.newText("0", 0, 0, native.systemFontBold, 16)
		tableRowScore.x = 33 + tableRowScore.width / 2
		tableRowScore.y = i * 28 + 115 + yMin
		tableRowScore:setFillColor(0, 0, 0)
		local tableRowLevel = display.newText("0", 0, 0, native.systemFontBold, 16)
		tableRowLevel.x = 290 - tableRowLevel.width / 2
		tableRowLevel.y = tableRowScore.y
		tableRowLevel:setFillColor(0, 0, 0)
		scoreTableGroup:insert(tableRowScore)
		scoreTableGroup:insert(tableRowLevel)
	end


	-- Add event listeners and timers
	menuButtonText:addEventListener("touch", backToMenu)
	levelsButton:addEventListener("touch", levelsOnTouch)
	scoresButton:addEventListener("touch", scoresOnTouch)


	-- Populate the high score table for the first time
	updateUI()
end



-- Called immediately after scene has moved onscreen:
-- Start timers/transitions etc.
function scene:enter( event )
    print( "Higscores: enterScene event" )

    -- Completely remove the previous scene/all scenes.
    -- Handy in this case where we want to keep everything simple.
    composer.removeAll()
end



-- Called when scene is about to move offscreen:
-- Cancel Timers/Transitions and Runtime Listeners etc.
function scene:exit( event )
    print( "Higscores: exitScene event" )
end



--Called prior to the removal of scene's "view" (display group)
function scene:destroy( event )
    print( "Higscores: destroying view" )
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



