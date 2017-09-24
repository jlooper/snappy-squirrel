Nav = {}
local nav,sprite,toggleSprite
local widget = require("widget")
local leftAcorn,rightAcorn,home
local playing
local composer = require( "composer" )


function Nav:new()

  
  local function clear()
    display.remove(helperText)   
    helperText=nil
    display.remove(helperSpeech)   
    helperSpeech=nil
    display.remove(leftAcorn)   
    leftAcorn=nil
    display.remove(rightAcorn)   
    rightAcorn=nil
    display.remove(home)   
    home=nil
    display.remove(sprite)
    sprite=nil
  end

local sound
local click = audio.loadSound("audio/click.mp3")

local function playClick()
  sound = audio.play( click )
end

local function next(event)
    if event.phase == "ended" then 

    playClick()

      if currPage < 10 then
        currPage = currPage+1
        
        composer.gotoScene( "page"..currPage, "fade", 200 )
      else
        currPage = 0
        clear()
        composer.gotoScene( "theend", "fade", 200 )
      end
    end
  end

  local function back(event)
    if event.phase == "ended" then

    playClick()

       if currPage ~= nil then
          if currPage > 1 then
            currPage = currPage-1
            print(currPage) 
            composer.gotoScene( "page"..currPage, "fade", 200 )
          end
        end
    end
  end

  local function goHome(event)
    if ( "ended" == event.phase ) then

    playClick()
    audio.stop()

        currPage = 0
        composer.gotoScene( "title", "slideLeft", 800 ) 
        clear()
    end
  end


  leftAcorn = display.newImageRect( "images/acorn_left.png",39,36 )
  leftAcorn.x, leftAcorn.y = display.contentWidth/2-40, display.contentHeight-10
  leftAcorn:addEventListener("touch",back)

  rightAcorn = display.newImageRect("images/acorn_right.png",38,36 )
  rightAcorn.x, rightAcorn.y = display.contentWidth/2+40, display.contentHeight-10
  rightAcorn:addEventListener("touch",next)

  home = display.newImageRect("images/home.png",40,38 )
  home.x, home.y = display.contentWidth/2, display.contentHeight-5
  home:addEventListener("touch",goHome)

  local function turnAudioOff()
    audio.stop()
  end

function toggleSprite(event)

  print(playing)

  if event.phase == "ended" then
   
   if playing then
      sprite:pause()
      sprite:setFrame(1)
      audio:pause()
      sequenceComplete=true
      playing=false
    else
      sprite:setSequence("play")
      sprite:play()
      audio:resume()
      playing=true
    end  

  end 

end

  local sheetInfo = require("images.animations.sound.sound")
  local myImageSheet = graphics.newImageSheet( "images/animations/sound/sound.png", sheetInfo:getSheet() )
  local sequenceData = {
      {name = "play", frames={1,2,3,4,4,3,2,1}, time=1000}
    }  
    sprite = display.newSprite( myImageSheet,sequenceData)
    sprite.x = rightAcorn.x+80
    sprite.y = rightAcorn.y-5
    sprite:scale(.5,.5)
    sprite:addEventListener("touch",toggleSprite)
    if audio.isChannelActive(2) then
      playing = true
      sprite:play()
    end
     
  

	return nav

end

return Nav