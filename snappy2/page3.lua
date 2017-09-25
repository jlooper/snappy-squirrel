-----------------------------------------------------------------------------------------
--
-- title.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

--------------------------------------------
local pageText,helperSpeech,helperText,bg,pageTextBackground,cardinal


function scene:create( event )



	local sceneGroup = self.view

	bg = display.newImageRect( sceneGroup, "images/nestbg.png", display.contentWidth, display.contentHeight )
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

	local auntPip = display.newImageRect("images/auntie-pip.png",187,269)
	auntPip.x,auntPip.y = 100,display.contentHeight-60
	sceneGroup:insert(auntPip)


	local options = 
				{
				   text = "Snappy had already stored many nuts with Owl’s Forest Bank and was earning interest on them when Owl gave him seeds in return for the nuts. But Auntie Pip said that he can save still more. “If you make a plan to only eat a small portion of the nuts you find and store the rest for the future, you will own more nuts, earn more interest, and you’ll be able to buy a nest soon. You must save for the future,” said Auntie, smiling and looking at the walls of her own snug nest.",  
				   fontSize = 12,
				   width = display.contentWidth-50,
				   font="Times"
				}

	local helperOptions = {
				   text = "Are you saving your money for something now?",     
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

  
  cardinal = display.newImageRect( "images/cardinal.png",100,100 )
  cardinal.x, cardinal.y = display.contentWidth-50, display.contentHeight
  cardinal:addEventListener("touch",toggleSpeech)
  sceneGroup:insert( cardinal )

  helperSpeech = display.newImageRect("images/helper-speech.png", 148,136 )
  helperSpeech.x,helperSpeech.y = cardinal.x-110,cardinal.y-80
  helperSpeech.isVisible = false
  sceneGroup:insert( helperSpeech )

  helperText = display.newText( helperOptions )
  helperText:setFillColor(.91,.17,.05)
  helperText.width = 100
  helperText.x = helperSpeech.x
  helperText.y = helperSpeech.y-helperSpeech.height/2+helperText.height/2     
  helperText.isVisible = false
  sceneGroup:insert( helperText )

  

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