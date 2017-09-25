Nav = {}
local nav
local widget = require("widget")
local leftAcorn,rightAcorn,home
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
    display.remove(ladybug)
    ladybug=nil
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


	return nav

end

return Nav