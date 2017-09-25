
local composer = require("composer")
local scene = composer.newScene()

local widget = require("widget")

local _W = display.contentWidth
local _H = display.contentHeight 

local text,answerField

function scene:create( event )
	local sceneGroup = self.view

local sound
local click = audio.loadSound("audio/click.mp3")
local function playClick()
  sound = audio.play( click )
end
	
	

	local function goHome(event)
	    if ( "ended" == event.phase ) then

	    playClick()
	    audio.stop()

	        currPage = 0
	        composer.gotoScene( "title", "slideLeft", 800 ) 
	    end
	  end


  
	  home = display.newImageRect("images/home.png",40,38 )
	  home.x, home.y = display.contentWidth/2, 400
	  home:addEventListener("touch",goHome)

	sceneGroup:insert( home )

 local function fieldHandler( event )

        if ( "submitted" == event.phase ) then

            native.setKeyboardFocus( nil )

        elseif ( "ended" == event.phase ) then
                                
            native.setKeyboardFocus( nil )              
                        
        end   

    end

 
    local back = display.newRoundedRect( 0, 0, display.contentWidth,display.contentHeight,5)
    back:setFillColor(231, 76, 60)--alizarin
    back.strokeWidth=10
    back:setStrokeColor(192, 57, 43)--pomegranate
    self.view:insert( back )
  
    local text = display.newText("Hello! In order to access this section, which opens a web page, please do a quick math problem: What's 6x7?", 0, 0, 300, 0, "HelveticaNeue-Light", 20 )
    text.x = display.contentWidth/2
    text.y = 150
    self.view:insert( text )

    answerField = native.newTextField( 10, display.contentHeight/2+30, 150, 30,fieldHandler)
    answerField.x=display.contentWidth/2
    answerField.y=text.y+70
    self.view:insert( answerField )

  

 

  local function onButtonEvent (event)
   
      
      if answerField.text == '42' then
      	system.openURL( "http://snappy.ladeezfirstmedia.com/?page_id=34" )
	else
       	local alert = native.showAlert("Oops","Please try again.",{"OK","Cancel"}, clearNow)

      end   
    
   
  
  end
  
  local closeButton = widget.newButton
  {
    id = "closeButton",
    defaultFile = "images/submit.png",
	overFile = "images/submit.png",
	label = "",
	width = 100,
	height = 38,		    
	onRelease = onButtonEvent,
    font = "HelveticaNeue-Light",
    labelColor = {
      default = { 255, 255, 255 },
      over = { 120, 53, 128, 255 },
    }
  }

  closeButton.x = display.contentWidth/2
  closeButton.y = display.contentHeight/2+50
  self.view:insert( closeButton )


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