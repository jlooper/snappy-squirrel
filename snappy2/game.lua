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



--Initial Settings
display.setStatusBar(display.HiddenStatusBar) --Hide status bar from the beginning



--Global score vars
_G.overallScore = 0
_G.target = 3
-- Global tileIconSheet, made global to save us loading and removing it each game!
_G.tileIconSheet = graphics.newImageSheet("game_images/tiles.png", {height = 30, width = 30, numFrames = 8, sheetContentWidth = 240, sheetContentHeight = 30})




--Import storyboard etc
local composer = require "composer"
local scene = composer.newScene()

composer.purgeOnSceneChange = true --So it automatically purges for us.
local sqlite3 = require("sqlite3")  --For loading and saving into our database



--Loads sounds. Done here so that we don't have to keep on creating and disposing of them!
local sounds = {}
sounds["select"] = audio.loadSound("game_sounds/select.mp3")
sounds["pop"] = audio.loadSound("game_sounds/pop.mp3")

function playSound(name) --Just pass a name to it. e.g. "select"
	audio.play(sounds[name])
end



--Create a database for holding the top score.
--You could easily edit this to add more levels and more highscores.
local dbPath = system.pathForFile("fruit_scores.db3", system.DocumentsDirectory)
local db = sqlite3.open(dbPath)
local tablesetup = [[ 
		CREATE TABLE scores (id INTEGER PRIMARY KEY, score INTEGER, level INTEGER);
		CREATE TABLE levels (id INTEGER PRIMARY KEY, score INTEGER, level INTEGER);
		INSERT INTO scores VALUES (NULL, 0, 0);
		INSERT INTO levels VALUES (NULL, 0, 0);
	]]
db:exec(tablesetup) --Create it now.
db:close() --Then close the database

function scene:create( event )

end


function scene:show( event )
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
		

	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
		--Now change scene to go to the menu.
		composer.gotoScene( "menu", "fade", 400 )

		
	end
end

function scene:hide( event )
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
    			
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
end

function scene:destroy( event )


	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.

end




---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )


-----------------------------------------------------------------------------------------

return scene