-----------------------------------------------------------------------------------------
--
-- title.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

--------------------------------------------
local pageText,helperSpeech,helperText,bg,pageTextBackground,full_flight_sprite


function scene:create( event )



	local sceneGroup = self.view

	bg = display.newImageRect( sceneGroup, "images/birch_forest1.png", display.contentWidth, display.contentHeight )
	bg.anchorX = 0
	bg.anchorY = 0
	bg.x, bg.y = 0, 0
	sceneGroup:insert(bg)

	local paint = {
	    type = "image",
	    filename = "images/parchment.png"
	}


	pageTextBackground = display.newRect( 0, 0, display.contentWidth, 50 )
	pageTextBackground:setFillColor( 0.5 )
	pageTextBackground.fill = paint
	sceneGroup:insert( pageTextBackground )


	local options = 
				{
				   text = "Snappy was a busy, happy squirrel.  All day long in the fall he searched through the leaves on the forest floor for tasty nuts to store for the long winter.  He squeaked with excitement each time he found a nut and quickly buried it where he was sure he’d find it in the coming months.  He had to hide them because other animals wanted to eat them, too.",     
				   fontSize = 12,
				   width = display.contentWidth-50,
				   font="Times"
				}

	local helperOptions = {
				   text = "What kinds of valuable things do you like to save? Money? Items to trade?",     
				   fontSize = 14,
				   width = 100,
				   font="Times",
				}

	pageText = display.newText(options)
	pageText:setFillColor(.69,.31,.09)
	sceneGroup:insert( pageText )

	pageText.x = display.contentWidth/2
	pageText.y = display.contentHeight * 0.20

	pageTextBackground.isVisible = true
	pageTextBackground.x = display.contentWidth/2
	pageTextBackground.y = 0
	pageTextBackground.height = pageText.height+35

	local textBGTween = transition.to( pageTextBackground, { time=tweenTime*0.5, alpha=1.0,y=pageText.height+20 } )			
	local textTween = transition.to( pageText, { time=tweenTime*0.5, alpha=1.0,y=pageText.height+10 } )
			


	local tweenOptions =
				{
					frames = require("images.butterfly.full_flight").frames,
				}

				-- The new sprite API
				local sheet = graphics.newImageSheet( "images/butterfly/full_flight.png", tweenOptions )
				local spriteOptions = { name="full_flight", start=1, count=12, time=800 }
				full_flight_sprite = display.newSprite( sheet, spriteOptions )
				full_flight_sprite.x,full_flight_sprite.y = 0,display.contentHeight/2-30
				full_flight_sprite:play()
				transition.to( full_flight_sprite, { time=8500, x=(0), x=(display.contentWidth+30), y=(50), onComplete=listener } )

  local function toggleSpeech(event)
    if event.phase == "ended" then
      if helperSpeech.isVisible == false then
        helperSpeech.isVisible = true
      else
        helperSpeech.isVisible = false
      end

      if helperText.isVisible == false then
          helperText.isVisible = true

        else
          helperText.isVisible = false
          
        end
      
    end
  end

  local ladybug = display.newImageRect( "images/ladybug.png", 50,50 )
  ladybug.x, ladybug.y = display.contentWidth-25, display.contentHeight-5
  ladybug:addEventListener("touch",toggleSpeech)
  sceneGroup:insert( ladybug )

  helperSpeech = display.newImageRect("images/helper-speech.png", 148,136 )
  helperSpeech.x,helperSpeech.y = ladybug.x-110,ladybug.y-50
  helperSpeech.isVisible = false
  sceneGroup:insert( helperSpeech )

  helperText = display.newText( helperOptions )
  helperText:setFillColor(.91,.17,.05)
  helperText.width = 100
  helperText.x = helperSpeech.x
  helperText.y = helperSpeech.y-helperSpeech.height/2+helperText.height/2     
  helperText.isVisible = false
  sceneGroup:insert( helperText )

	local snappyRight = display.newImageRect(sceneGroup,"images/snappy.png", 237,256 )
	snappyRight.x,snappyRight.y = 50,display.contentHeight+50
	snappyRight.xScale = -1
	sceneGroup:insert(snappyRight)

	

end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then

		native.setActivityIndicator( false )
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
		display.remove(full_flight_sprite)
		full_flight_sprite = nil

				
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