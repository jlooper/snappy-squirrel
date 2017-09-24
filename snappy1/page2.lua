-----------------------------------------------------------------------------------------
--
-- title.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

--------------------------------------------
local pageText,helperSpeech,helperText,bg,pageTextBackground,chipmunk,chipmunk2


function scene:create( event )
	local sceneGroup = self.view

	bg = display.newImageRect( sceneGroup, "images/birch_forest2.png", display.contentWidth, display.contentHeight )
	bg.anchorX = 0
	bg.anchorY = 0
	bg.x, bg.y = 0, 0
	sceneGroup:insert(bg)

	chipmunk = display.newImageRect(sceneGroup,"images/chipmunk.png",104,175 )
	chipmunk.x,chipmunk.y = 280,display.contentHeight-50
	sceneGroup:insert( chipmunk )
	
	chipmunk2 = display.newImageRect(sceneGroup,"images/chipmunk.png",104,175 )
	chipmunk2.x,chipmunk2.y = 200,display.contentHeight-150
	chipmunk2.xScale = -1 
	chipmunk2.yScale = .85
	sceneGroup:insert( chipmunk2 )


	local options = 
				{
				   text = "Sometimes the Deer brothers trampled them and broke the nut shells. Often the naughty Chipmunk family stole them. Sometimes, Snappy couldn’t quite remember where he put the piles of nuts.  Still, Snappy had been working for a long time and had saved many nuts.  They would taste so good all winter when the ground is covered with snow.",     
				    width = display.contentWidth-50,    --required for multi-line and alignment
				    font = "Times",   
				    fontSize = 12 
				}
	local helperOptions = {
				   text = "Where do you store your valuable things? How do you make sure they are safe?",     
				   fontSize = 14,
				   width = 100,
				   font="Times"
				}

	
local tweenOptions =
				{
					frames = require("images.butterfly.butterfly_top").frames,
				}

				-- The new sprite API
				local sheet = graphics.newImageSheet( "images/butterfly/butterfly_top.png", tweenOptions )
				local spriteOptions = { name="butterfly_top", start=1, count=87, time=15000 }
				butterfly_top_sprite = display.newSprite( sheet, spriteOptions )
				butterfly_top_sprite.x,butterfly_top_sprite.y = display.contentWidth/2+200,display.contentHeight/2
			butterfly_top_sprite:play()

			helperText = display.newText(helperOptions)
			sceneGroup:insert( helperText )

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

	
	

	local paint = {
	    type = "image",
	    filename = "images/parchment.png"
	}


	pageTextBackground = display.newRect( 0, 0, display.contentWidth, 50 )
	pageTextBackground:setFillColor( 0.5 )
	pageTextBackground.fill = paint

	pageTextBackground.x = display.contentWidth/2
	pageTextBackground.y = 0
	sceneGroup:insert( pageTextBackground )


	pageText = display.newText(options)
	pageText:setFillColor(.69,.31,.09)
	sceneGroup:insert( pageText )

	pageText.x = display.contentWidth/2
	pageText.y = display.contentHeight * 0.20
	
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
		display.remove(butterfly_top_sprite)
		butterfly_top_sprite = nil
				
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