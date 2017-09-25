-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- include the Corona "composer" module
local composer = require "composer"

display.setDefault( "background",.30,.51,.17)--green

composer.gotoScene( "title", "fade" )

display.setDefault( "anchorX", 0.5 )
display.setDefault( "anchorY", 1 )

