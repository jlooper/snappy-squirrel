local composer = require( "composer" )
local scene = composer.newScene()

local widget = require( "widget" )
local colorSnappy
local isDrawing=false

function scene:create( event )
	local sceneGroup = self.view

		--Maths
		local _W = display.contentWidth
		local _H = display.contentHeight
		local mR = math.round 

		
		--Groups
		local backGroup, drawGroup, overlayGroup

		--Drawing Vars
		local colourCircle --Shows the user how big and the colour of their brush
		local linePoints = {} --Holds all the drawn line information. You could save this to a JSON file if you want to store it.
		local brushSizes = {2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36,38,40,42} --All of our brush sizes (used on the slider)
		local chosenSize = 11 --Set our initial size.
		local colours = {}
		local chosenColour = 4 --Set our initial colour to the fourth one along the bottom
		colours[1] = { 180/255,180/255,180/255 }  --All the various colours along the bottom. In order.
		colours[2] = { 107/255,107/255,107/255 }
		colours[3] = { 29/255,30/255,30/255 }
		colours[4] = { 101/255,15/255,47/255 }
		colours[5] = { 137/255,30/255,112/255 }
		colours[6] = { 195/255,70/255,148/255 }
		colours[7] = { 140/255,75/255,152/255 }
		colours[8] = { 86/255,71/255,151/255 }
		colours[9] = { 21/255,76/255,154/255 }
		colours[10] = { 37/255,108/255,179/255 }
		colours[11] = { 55/255,191/255,239/255 }
		colours[12] = { 100/255,197/255,225/255 }
		colours[13] = { 23/255,175/255,186/255 }
		colours[14] = { 32/255,175/255,139/255 }
		colours[15] = { 26/255,150/255,56/255 }
		colours[16] = { 81/255,175/255,50/255 }
		colours[17] = { 174/255,204/255,79/255 }
		colours[18] = { 240/255,230/255,41/255 }
		colours[19] = { 250/255,180/255,30/255 }
		colours[20] = { 240/255,130/255,17/255 }
		colours[21] = { 212/255,107/255,26/255 }
		colours[22] = { 167/255,79/255,24/255 }
		colours[23] = { 151/255,25/255,22/255 }
		colours[24] = { 227/255,17/255,28/255 }
		colours[25] = { 1,1,1 } --You dont actually see this colour on the page. Its reserved/hidden for the eraser.


		--Pre-declared vars -Done here so we can easily modigy them.
		local pencilButton, brushButton, eraserButton, slider, background

		--Control vars for the above.
		local pencilActive, brushActive, eraserActive = false, true, false

		--Hide Button vars.
		local movingActive = false --Tracks if its transitioning or not.
		local movingTrans --So we can easily cancel it etc.
		local buttonsShowing = true --Can test against this var.

		local screenGroup = self.view

	--Create the groups and insert them into the view...
	backGroup = display.newGroup()
	drawGroup = display.newGroup()
	overlayGroup = display.newGroup()
	screenGroup:insert(backGroup)
	screenGroup:insert(drawGroup)
	screenGroup:insert(overlayGroup) 
	

	--------------------------------------------------
	-- ***BUTTON FUNCTIONS***
	--Functions for the buttons we create further down
	--
	--Please note that we are setting the focus for each of the buttons below.
	--If we do not, the app thinks we are trying to start drawing if we drag our
	--finger off the buttons, which would cause an error. Therefore setting the 
	--focus forces the app to only apply the touches to our set buttons and not
	--the background line drawing function.
	--------------------------------------------------
	local function colourTouched(event)
		if event.phase=="began" then
            display.getCurrentStage():setFocus(event.target)

		elseif event.phase == "ended" then
			display.getCurrentStage():setFocus(nil)
			
			if eraserActive == false and pencilActive == false then
				chosenColour=event.target.id
				colourCircle:setFillColor(colours[chosenColour][1], colours[chosenColour][2], colours[chosenColour][3])
			end
		end
		return true
	end

	--Hides all the bottomBar buttons. Makes it easier to draw!
	local function hidButtons(event)
		if event.phase=="began" then
            display.getCurrentStage():setFocus(event.target)

		elseif event.phase == "ended" then
			display.getCurrentStage():setFocus(nil)

			if buttonsShowing == true then
				--Check to see if we can move it now or not.
				if movingActive == false then 
					--After the transition is done
					local function transCallback()
						movingActive = false
						buttonsShowing = false
					end
					movingTrans = transition.to(overlayGroup, {time=360, y = 100, onComplete = transCallback})
				end
			else
				--Check to see if we can move it now or not.
				if movingActive == false then 
					--After the transition is done
					local function transCallback()
						movingActive = false
						buttonsShowing = true
					end
					movingTrans = transition.to(overlayGroup, {time=360, y = 0, onComplete = transCallback})
				end
			end
		end
		return true
	end

	--Quick exit function
	local function exitNow(event)
		if event.phase=="began" then
            display.getCurrentStage():setFocus(event.target)

		elseif event.phase == "ended" then
			display.getCurrentStage():setFocus(nil)
			composer.gotoScene( "title", "slideLeft", 800 )	
		end
		return true
	end

	--Slider listener function
	local function sliderListener( event )
		if pencilActive == false then
		    chosenSize = (mR(event.value/5))+1

		    --Now we change the size of the brush circle.
		    display.remove(colourCircle); colourCircle = nil; 
		    colourCircle = display.newCircle(overlayGroup,0,0,brushSizes[chosenSize]/2)
			colourCircle.x = 40; colourCircle.y = _H-48
			colourCircle:setFillColor(colours[chosenColour][1], colours[chosenColour][2], colours[chosenColour][3])
		else
			slider:setValue( 0 ) 
		end
	end

	--ClearLines function. Cleans the screen! Good to use if it starts to lag.
	local function clearLines(event)
		if event.phase=="began" then
            display.getCurrentStage():setFocus(event.target)
            event.target.alpha = 0.5

		elseif event.phase == "ended" then
			display.getCurrentStage():setFocus(nil)
			event.target.alpha = 1

			--First we ask if the user really wants to clear the image!
			local function clearNow( event )
				if event.index == 1 then
					local i
					for i=drawGroup.numChildren, 1, -1 do
						display.remove(drawGroup[i]); drawGroup[i] = nil
					end	
					--reinsert snappy
					colorSnappy = display.newImageRect(drawGroup,"images/colorSnappy.png",235,280);
					colorSnappy.x,colorSnappy.y = display.contentWidth/2,display.contentHeight/2+150

				end
			end
			local alert = native.showAlert("Warning","You are about to delete your work, are you sure you want to continue?",{"OK","Cancel"}, clearNow)
		end
		return true
	end	

	--saveToGallery function. This will save the current drawn image to the users photo gallery.
	local function saveToGallery(event)
		if event.phase=="began" then
            display.getCurrentStage():setFocus(event.target)
            event.target.alpha = 0.5

		elseif event.phase == "ended" then
			display.getCurrentStage():setFocus(nil)
			event.target.alpha = 1

			--First check to see if there is anything in the group before saving.
			if drawGroup.numChildren > 0 then		
				--Quickly add a white background to the drawgroup!
				local whiteBg = display.newRect(0,0,display.contentWidth,display.contentHeight)
				drawGroup:insert(1, whiteBg)

				--Save the drawGroup only. Also set the second option to true so that it saves to the devices photo library
				--We also remove save straight away as the app will try to display it after its captured.
				local save = display.capture( drawGroup, true )
				save:removeSelf(); save = nil
				whiteBg:removeSelf(); whiteBg = nil
			
				local alert = native.showAlert("Alert","Your drawing was saved to your device's photo library!",{"OK"})
			else
				local alert = native.showAlert("Alert","There's nothing drawn to save!",{"OK"})
			end
		end
		return true
	end	

	--Button press function. Controls the pencil brush and eraser buttons
	local lastSize, lastColour = 1,1 --These vars remember what we had before we clicked pencil or eraser.
	local function btnPress(event)
		if event.phase=="began" then
            display.getCurrentStage():setFocus(event.target)
            
		elseif event.phase == "ended" then
			display.getCurrentStage():setFocus(nil)
			local id = event.target.id 

			--Check which button was pressed and do different things accordinly. 
			--We also check to see if we are going back to brush from the other two. If we are
			--we reset the size and colour to what they were previsouly.
			if id == "pencil" then
				if pencilActive == false and eraserActive == false then
					lastSize = chosenSize
					lastColour = chosenColour
				end

				--Change some vars now
				pencilButton.alpha = 1; brushButton.alpha = 0.5; eraserButton.alpha = 0.5
				pencilActive = true; brushActive = false; eraserActive = false

				chosenColour = 3
				chosenSize = 1
				slider:setValue( 0 ) 

				display.remove(colourCircle); colourCircle = nil; 
			    colourCircle = display.newCircle(overlayGroup,0,0,brushSizes[chosenSize]/2)
				colourCircle.x = 40; colourCircle.y = _H-58
				colourCircle:setFillColor(colours[chosenColour][1], colours[chosenColour][2], colours[chosenColour][3])

			elseif id == "brush" then
				--If if it one of these last we reset our brush and sizes.
				if pencilActive == true or eraserActive == true then
					chosenColour = lastColour
					chosenSize = lastSize
					slider:setValue( (chosenSize-1)*5 ) 

					display.remove(colourCircle); colourCircle = nil; 
				    colourCircle = display.newCircle(overlayGroup,0,0,brushSizes[chosenSize]/2)
					colourCircle.x = 40; colourCircle.y = _H-58
					colourCircle:setFillColor(colours[chosenColour][1], colours[chosenColour][2], colours[chosenColour][3])
				end

				--Change some vars now
				pencilButton.alpha = 0.5; brushButton.alpha = 1; eraserButton.alpha = 0.5
				pencilActive = false; brushActive = true; eraserActive = false

			elseif id == "eraser" then
				if eraserActive == false and pencilActive == false then
					lastSize = chosenSize
					lastColour = chosenColour
				end

				--Change some vars now
				pencilButton.alpha = 0.5; brushButton.alpha = 0.5; eraserButton.alpha = 1
				pencilActive = false; brushActive = false; eraserActive = true

				chosenColour = 25
				colourCircle:setFillColor(colours[chosenColour][1], colours[chosenColour][2], colours[chosenColour][3])
			end
		end
		return true
	end

	

	--------------------------------------------------
	-- ***BUTTON SETUP***
	--Creates the brush/clear/save/slider buttons
	--------------------------------------------------
	--White background.
	background = display.newRect(backGroup,0,0,display.contentWidth,display.contentHeight)
	background.anchorX = 0
	background.anchorY = 0

	--color snappy

	colorSnappy = display.newImageRect(drawGroup,"images/colorSnappy.png",235,280);
	colorSnappy.x,colorSnappy.y = display.contentWidth/2,display.contentHeight/2+150

	--The main bottom toolbar. 
	local bottomBar = display.newImageRect(overlayGroup,"images/bottomBar.png",display.contentWidth,80);
	bottomBar.anchorX = 0.5
	bottomBar.anchorY = 0
	bottomBar.y = _H-120; bottomBar.x = _W*0.5 
	
	--Add an invisible button onto the toolbar so that we can hide it all easily.
	local hideButton = display.newRect(overlayGroup,0,0,100,30)
	hideButton.anchorX = 0.5
	hideButton.anchorY = 0
	hideButton:setFillColor( 0,0,0 )
	hideButton.x = _W*0.5; hideButton.y = bottomBar.y; hideButton.alpha = 0.01
	hideButton:addEventListener("touch", hidButtons)

	
	--Top left exit button
	local exitButton = display.newImageRect(backGroup,"images/home.png",50,50)
	exitButton.anchorX = 0
	exitButton.anchorY = 0
	exitButton.x = 0; exitButton.y = 0;
	exitButton:addEventListener("touch", exitNow)




	--Create the coloured brush on the far left hand side of the screen. This shows the
	--user the size of their brush as well as its colour.
	colourCircle = display.newCircle(overlayGroup,0,0,brushSizes[chosenSize]/2)
	colourCircle.anchorX = 0.5
	colourCircle.anchorY = 0.5
	colourCircle.x = 40; colourCircle.y = _H-58
	colourCircle:setFillColor(colours[chosenColour][1], colours[chosenColour][2], colours[chosenColour][3])


	--Now the buttons that control brush/eraser/save and clear etc.
	--First the clear button
	local clearButton = display.newImageRect(overlayGroup, "images/clearBtn.png", 78, 26)
	clearButton.anchorX = 1
	clearButton.anchorY = 0
	clearButton.x = (_W*0.5)-94; clearButton.y = bottomBar.y+26
	clearButton:addEventListener("touch", clearLines)

	--Now the save.
	local saveButton = display.newImageRect(overlayGroup, "images/saveBtn.png", 78, 26)
	saveButton.anchorX = 1
	saveButton.anchorY = 0
	saveButton.x = clearButton.x+90; saveButton.y = clearButton.y
	saveButton:addEventListener("touch", saveToGallery)

	--Pencil Button
	--The next three are localised at the top so we can easily edit their alpha values.
	pencilButton = display.newImageRect(overlayGroup, "images/pencilBtn.png", 46, 46)
	pencilButton.anchorY = 0
	pencilButton.x = (_W*0.5)+106; pencilButton.y = bottomBar.y +27;  
	pencilButton.id = "pencil"; pencilButton.alpha = 0.5 --Change its alpha so it looks like its not in use.
	pencilButton:addEventListener("touch", btnPress)

	--Brush Button
	brushButton = display.newImageRect(overlayGroup, "images/brushBtn.png", 46, 46)
	brushButton.anchorY = 0
	brushButton.x = pencilButton.x+52; brushButton.y = pencilButton.y; 
	brushButton.id = "brush"
	brushButton:addEventListener("touch", btnPress)

	--Eraser Button --Actually just changes it to a white brush. Cheating way!
	eraserButton = display.newImageRect(overlayGroup, "images/eraserBtn.png", 46, 46)
	eraserButton.anchorY = 0
	eraserButton.x = brushButton.x+52; eraserButton.y = pencilButton.y; 
	eraserButton.id = "eraser"; eraserButton.alpha = 0.5 --Change its alpha so it looks like its not in use.
	eraserButton:addEventListener("touch", btnPress)


	--Loop through making all the coloured rectangles
	--We also add a tap listener to each to the colourTouched function futher up.
	local i 
	for i=1, #colours do
		local width = display.contentWidth/(#colours-1)
		local xPos = (i-1)*width

		local rect = display.newRect(overlayGroup, 0+xPos, display.contentHeight-40, width, 40)
		rect.anchorX = 0
		rect.anchorY = 0
		rect:setFillColor(colours[i][1], colours[i][2], colours[i][3]); rect.id = i; 
		rect:addEventListener("touch", colourTouched) 
	end

	--Slider that controls the size of the brush!
	slider = widget.newSlider{
	    top = display.contentHeight-75,
	    left = 90,
	    orientation="horizontal",
	    width=200,
	    listener = sliderListener
	}
	slider:setValue( 40 ) --changes handle position and value
	overlayGroup:insert(slider)




	--------------------------------------------------
	-- *** DRAWING FUNCTIONS ***
	--Line creation functions
	--------------------------------------------------
	--Draw line function. Called from newLine
	local function drawLine()
		if pencilActive then
	        local line = display.newLine(linePoints[#linePoints-1].x,linePoints[#linePoints-1].y,linePoints[#linePoints].x,linePoints[#linePoints].y)
	        line:setStrokeColor(colours[chosenColour][1], colours[chosenColour][2], colours[chosenColour][3]);
	        line.strokeWidth = brushSizes[chosenSize];
	        drawGroup:insert(line)
	    end

        local circle = display.newCircle(linePoints[#linePoints].x, linePoints[#linePoints].y, brushSizes[chosenSize]*0.5)
        circle:setFillColor(colours[chosenColour][1], colours[chosenColour][2], colours[chosenColour][3])
        drawGroup:insert(circle)
    end
 
    --newLine function. Called when you touch the background.
	local function newLine(event)
        if event.phase=="began" then
            display.getCurrentStage():setFocus(event.target)
            
            local circle = display.newCircle(event.x, event.y, brushSizes[chosenSize]*0.5)
            circle:setFillColor(colours[chosenColour][1], colours[chosenColour][2], colours[chosenColour][3])
            drawGroup:insert(circle)
            
            linePoints = nil; linePoints = {};
            
            local pt = {}
            pt.x = event.x;
            pt.y = event.y;
            table.insert(linePoints,pt);
                                        
        elseif event.phase=="moved" then
          	local pt = {}
            pt.x = event.x;
            pt.y = event.y;

            if not (pt.x==linePoints[#linePoints].x and pt.y==linePoints[#linePoints].y) then
                table.insert(linePoints,pt)
                drawLine()
            end
        
        elseif event.phase=="cancelled" or "ended" then
            display.getCurrentStage():setFocus(nil)
        end      
		return true
	end   
	
	--Delay the background touch from being allowed.
	local function allowTouch()
		background:addEventListener("touch", newLine)
	end
	timer.performWithDelay(400, allowTouch, 1)

end



function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
	local alert = native.showAlert("Welcome!","Color Snappy!",{"OK","Cancel"}, clearNow)

		
		
	end	

end





function scene:exit( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		
		
	elseif phase == "did" then
		-- Called when the scene is now off screen
		if movingTrans then transition.cancel(movingTrans); movingTrans = nil; end
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