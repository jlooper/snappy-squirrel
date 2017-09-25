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


-- Set up our variables and groups ***
local menuTouchGroup --Made in the storyboard functions.
local menuBackgroundGroup

local xMin = display.screenOriginX 
local yMin = display.screenOriginY
local xMax = display.contentWidth - display.screenOriginX
local yMax = display.contentHeight - display.screenOriginY
local xWidth = xMax-xMin --The total width
local yHeight = yMax-yMin --The total height
local _W = display.contentWidth
local _H = display.contentHeight
local menuTouchGroupTimer
local menuLogoTransition


--Predecalre the images etc
local menuLogo
local menuBackground
local playText
local highscoreText



-----------------------------------------------
-- *** STORYBOARD SCENE EVENT FUNCTIONS ***
------------------------------------------------
-- Called when the scene's view does not exist:
-- Create all your display objects here.
function scene:create( event )
    print( "Menu: createScene event")
    local screenGroup = self.view

    ------------
    -- DISPLAY OBJECTS
    ------------
    menuLogo = display.newImageRect("game_images/logo.png", 304, 104)
	menuBackground = display.newImageRect("game_images/menu_bg.png", 360, 570)
	playText = display.newImageRect("game_images/start.png", 240, 36)
	highscoreText = display.newImageRect("game_images/highscores.png", 256, 36)

	local function exitNow(event)
		if event.phase == "ended" then
			composer.gotoScene( "title", "fade", 800 )	
		end
		return true
	end

	--Top left exit button
	local exitButton = display.newImageRect("images/home.png",50,50)
	exitButton.anchorX = 0
	exitButton.anchorY = 0
	exitButton.x = 0; exitButton.y = 0;
	exitButton:addEventListener("touch", exitNow)



    --Now make our display groups and insert them into the screengroup.
    menuTouchGroup = display.newGroup()
    menuBackgroundGroup = display.newGroup()
    menuBackground.x = display.contentWidth/2
	menuBackground.y = display.contentHeight
	menuBackgroundGroup:insert(menuBackground);
	
    screenGroup:insert(menuBackgroundGroup)
    screenGroup:insert(menuTouchGroup)
    screenGroup:insert(exitButton)

    
    
	local function menuTick (event)
		menuLogo.y = math.sin(event.count / 10) * 10 + yMin + 150
	end
	local function animateLogo ()
		menuTouchGroupTimer = timer.performWithDelay(20, menuTick, 0)
	end
	menuLogoTransition = transition.to(menuLogo, {time=1000, y=yMin + 150, transition=easing.outQuad, onComplete=animateLogo})
	


	--
	
	playText.x = _W / 2
	playText.y = yMax - 160
	
	highscoreText.x = _W / 2
	highscoreText.y = yMax - 80

	menuLogo.x = _W / 2
	menuLogo.y = yMin - 100

	menuTouchGroup:insert(menuLogo)
	menuTouchGroup:insert(playText)
	menuTouchGroup:insert(highscoreText)


	-- Add create enough tiles to fill the screen
	for i = 1, 126 do
		local newTile = display.newImageRect(tileIconSheet, math.random(1, 8), 30, 30)
		newTile.x = xMin + (i - 1) % 9 * 40 + 20
		newTile.y = yMin + math.floor((i - 1) / 9) * 40 + 20
		newTile.alpha = 0.3
		menuBackgroundGroup:insert(newTile)
	end

	local function onStartGameTouch (event)
		if event.phase == "ended" then
		print("touch")
			playSound("select")
			composer.gotoScene( "game_home", "fade", 400 )
		end
		return true
	end

	-- When the user presses highscore
	local function onHighscoreGameTouch (event)
		if event.phase == "ended" then
			playSound("select")
			composer.gotoScene( "highscores", "fade", 400 )
		end
		return true
	end
	playText:addEventListener("touch", onStartGameTouch)
	highscoreText:addEventListener("touch", onHighscoreGameTouch)
end



-- Called immediately after scene has moved onscreen:
-- Start timers/transitions etc.
function scene:enter( event )
    print( "Menu: enterScene event" )

    -- Completely remove the previous scene/all scenes.
    -- Handy in this case where we want to keep everything simple.
    composer.removeAll()


    -- Slide the logo into the screen
	-- Animate the logo
	--[[local function menuTick (event)
		menuLogo.y = math.sin(event.count / 10) * 10 + yMin + 100
	end
	local function animateLogo ()
		menuTouchGroupTimer = timer.performWithDelay(20, menuTick, 0)
	end
	menuLogoTransition = transition.to(menuLogo, {time=1000, y=yMin + 100, transition=easing.outQuad, onComplete=animateLogo})
	]]


	-- Set up touch events
	-- When the user presses start game
	
end



-- Called when scene is about to move offscreen:
-- Cancel Timers/Transitions and Runtime Listeners etc.
function scene:exit( event )
    print( "Menu: exitScene event" )
    if menuTouchGroupTimer ~= nil then 
   	 	timer.cancel(menuTouchGroupTimer); menuTouchGroupTimer = nil
   	end
   	if menuLogoTransition ~= nil then 
   		transition.cancel(menuLogoTransition); menuLogoTransition = nil
   	end
end



--Called prior to the removal of scene's "view" (display group)
function scene:destroy( event )
    print( "Menu: destroying view" )
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
