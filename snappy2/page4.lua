-----------------------------------------------------------------------------------------
--
-- title.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

--------------------------------------------
local pageText,helperSpeech,helperText,bg,pageTextBackground,cardinal
local flake,wind,removeFlake,makeSnow,spawnSnowFlake


function scene:create( event )



	local sceneGroup = self.view

	bg = display.newImageRect( sceneGroup, "images/snowy1.png", display.contentWidth, display.contentHeight )
	bg.anchorX = 0
	bg.anchorY = 0
	bg.x, bg.y = 0, 0
	sceneGroup:insert(bg)

	local snappy_cold = display.newImageRect("images/snappy_cold.png",175,228)
	snappy_cold.x,snappy_cold.y = display.contentWidth/2,display.contentHeight-50
	sceneGroup:insert(snappy_cold)


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
				   text = "But Snappy knew that although Owl's Bank is a safe place to store his valuables, he still only got two small seeds for each nut that he deposited in the bank. Worried, he thought that by getting only two seeds for each nut, it would take years to add up enough to pay for a nest. Snappy asked, “Is there any place else I could put my nuts to earn more seeds, so that I can earn more seeds more quickly?”",  
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
	Runtime:addEventListener("enterFrame",makeSnow)

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
		Runtime:removeEventListener("enterFrame", makeSnow)       
    			
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

function removeFlake(target)
        target:removeSelf()
        target = nil
end

function spawnSnowFlake()
        flake = display.newCircle(0,0,2)
        flake.x = math.random(display.contentWidth)
        flake.y = -2
        wind = math.random(80) - 40
        transition.to(flake,{time=math.random(3000) + 3000, y = display.contentHeight + 2, x = flake.x + wind, onComplete=removeFlake})
end

function makeSnow(event)
      if math.random(10) == 1 then -- adjust speed here by making the random number higher or lower
            spawnSnowFlake()
      end
      return true
end



---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )


-----------------------------------------------------------------------------------------

return scene