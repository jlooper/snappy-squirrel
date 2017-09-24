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

	bg = display.newImageRect( sceneGroup, "images/birch_forest7.png", display.contentWidth, display.contentHeight )
	bg.anchorX = 0
	bg.anchorY = 0
	bg.x, bg.y = 0, 0
	sceneGroup:insert(bg)

	local SPGroup = display.newImageRect(sceneGroup,"images/SPGroup.png",135,142)
	SPGroup.x,SPGroup.y = 100,display.contentHeight
	sceneGroup:insert(SPGroup)

	local foxTail = display.newImageRect(sceneGroup,"images/fox-talk.png",282,223)
	foxTail.x,foxTail.y = display.contentWidth-15,display.contentHeight-30
	foxTail.xScale = -1
	sceneGroup:insert(foxTail)


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
					frames = require("images.butterfly.fluttering").frames,
				}

				-- The new sprite API
				local sheet = graphics.newImageSheet( "images/butterfly/fluttering.png", tweenOptions )
				local spriteOptions = { name="fluttering", start=1, count=20, time=2000 }
				fluttering_sprite2 = display.newSprite( sheet, spriteOptions )
				fluttering_sprite2.x,fluttering_sprite2.y = 0,display.contentHeight/2
				fluttering_sprite2.xScale=-1
				transition.from( fluttering_sprite2, { time=8500, x=(0), x=(display.contentWidth/2+150), y=(100), onComplete=listener } )				

				fluttering_sprite2:play()
			

	local options = 
				{
				   text = "Mr. Fox walked away in a huff. Auntie Pip looked kindly at Snappy. “Many banks want you to deposit your property with them so that they can use it to buy other things, but you have to be careful. Owl is a good banker and won’t take advantage of you. He will give you only two pine nuts for each acorn, but you can get your acorns back any time and you get your pine nuts right away.”",     
				    width = display.contentWidth-50,    --required for multi-line and alignment
				    font = "Times",   
				    fontSize = 12 
				}
	local helperOptions = {
				text = "What other kinds of business practices would a bank offer to attract customers?",     
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
		display.remove(fluttering_sprite2)
		fluttering_sprite2 = nil
				
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