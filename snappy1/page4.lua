-----------------------------------------------------------------------------------------
--
-- title.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

--------------------------------------------
local pageText,helperSpeech,helperText,bg,pageTextBackground


function scene:create( event )
	local sceneGroup = self.view

	bg = display.newImageRect( sceneGroup, "images/birch_forest4.png", display.contentWidth, display.contentHeight )
	bg.anchorX = 0
	bg.anchorY = 0
	bg.x, bg.y = 0, 0
	sceneGroup:insert(bg)

	local auntPip = display.newImageRect("images/auntie-pip.png",187,269)
	auntPip.x,auntPip.y = 100,display.contentHeight
	sceneGroup:insert(auntPip)




	local paint = {
	    type = "image",
	    filename = "images/parchment.png"
	}


	pageTextBackground = display.newRect( 0, 0, display.contentWidth, 50 )
	pageTextBackground:setFillColor( 0.5 )
	pageTextBackground.fill = paint
	sceneGroup:insert( pageTextBackground )

local tweenOptions =
				{
					frames = require("images.butterfly.resting").frames,
				}

				-- The new sprite API
				local sheet = graphics.newImageSheet( "images/butterfly/resting.png", tweenOptions )
				local spriteOptions = { name="resting", start=1, count=42, time=8000 }
				resting_sprite = display.newSprite( sheet, spriteOptions )
				resting_sprite.x,resting_sprite.y = display.contentWidth/2+150,display.contentHeight/2-40
				resting_sprite:play()

	
	

	local options = 
				{
				   text = "Auntie Pip told Snappy that the forest has lots of good places to store his property.  “If you want them back within the next year or so, they'll have to be where we can find them easily but will be held safe from other Forest creatures.  I'd suggest Owl's Forest Bank.  You can put them in his safe box where he can watch them all the time.  Lots of animals store their things with Owl. He is awake all night and during the day he has several salamanders who watch what is held in the bank.”",     
				    width = display.contentWidth-50,    --required for multi-line and alignment
				    font = "Times",   
				    fontSize = 12 
				}
	local helperOptions = {
				text = "Have you ever been inside a bank? What are other ways to visit a bank?",     
				fontSize = 14,
				width = 100,
				font="Times"
	}

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
		display.remove(resting_sprite)
		resting_sprite = nil
				
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