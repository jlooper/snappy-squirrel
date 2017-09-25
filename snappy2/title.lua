-----------------------------------------------------------------------------------------
--
-- title.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local widget = require("widget")

--------------------------------------------

-- forward declaration
local background,title,parents

tweenTime = 500
currPage = 1


function scene:create( event )
	local sceneGroup = self.view

local sound
local click = audio.loadSound("audio/click.mp3")

local function playClick()
  sound = audio.play( click )
end
	
	background = display.newImageRect( sceneGroup, "images/titlebg.png", display.contentWidth,display.contentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x, background.y = 0, 0


	local snappypeek = display.newImageRect( sceneGroup, "images/snappy_peek.png", 95,121)
	snappypeek.x = display.contentWidth/2
	snappypeek.y = display.contentHeight/2

	title = display.newImageRect( sceneGroup, "images/title.png", 300,70 )
	title.x, title.y = display.contentWidth/2, 80

	
	local function goToParents(event)
		if event.phase == "ended" then
			playClick()
			composer.gotoScene("parentalgate","slideLeft",800)			
		end
	end

	local function goToPlay(event)
		if event.phase == "ended" then
			playClick()
			composer.gotoScene( "game", "slideLeft", 800 )		
			return true
		end
	end

	parents = display.newImageRect( sceneGroup, "images/parents.png",99,99 )
	parents.x, parents.y = display.contentWidth-45,45
	parents:addEventListener("touch",goToParents)



	local function read( event )

	    if ( "ended" == event.phase ) then
	    playClick()
	        native.setActivityIndicator( true )
	        composer.gotoScene( "page1", "fade", 200 )
	        require "com.ladeezfirstmedia.app.Nav"
			nav = Nav:new()
		
			return true
	    end
	end

	
	local btnRead = widget.newButton
		{
		    width = 100,
		    height = 38,
		    defaultFile = "images/read.png",
		    overFile = "images/read.png",
		    label = "",
		    onEvent = read
		}

	btnRead.x = display.contentWidth/2 - 80
	btnRead.y = display.contentHeight - (display.contentHeight*0.1)	
	
	
	local btnPlay = widget.newButton
		{
		    width = 100,
		    height = 38,
		    defaultFile = "images/play.png",
		    overFile = "images/play.png",
		    label = "",
		    onEvent = goToPlay
		}
	
	btnPlay.x = display.contentWidth/2 + 80
	btnPlay.y = display.contentHeight - (display.contentHeight*0.1)	
	
	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	sceneGroup:insert( snappypeek )
	sceneGroup:insert(title)
	sceneGroup:insert( parents )
	
	sceneGroup:insert( btnPlay )
	sceneGroup:insert( btnRead )
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
		
		
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)

				
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
end

function scene:destroy( event )
	local sceneGroup = self.view
	
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