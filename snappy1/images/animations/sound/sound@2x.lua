--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:2685052c0263cbd2c070fba8a840c3db:1/1$
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            -- 1@2x
            x=204,
            y=4,
            width=44,
            height=88,

            sourceX = 0,
            sourceY = 6,
            sourceWidth = 100,
            sourceHeight = 100
        },
        {
            -- 2@2x
            x=3,
            y=96,
            width=66,
            height=88,

            sourceX = 0,
            sourceY = 6,
            sourceWidth = 100,
            sourceHeight = 100
        },
        {
            -- 3@2x
            x=112,
            y=4,
            width=86,
            height=88,

            sourceX = 0,
            sourceY = 6,
            sourceWidth = 100,
            sourceHeight = 100
        },
        {
            -- 4@2x
            x=4,
            y=4,
            width=106,
            height=88,

            sourceX = 0,
            sourceY = 6,
            sourceWidth = 106,
            sourceHeight = 100
        },
    },
    
    sheetContentWidth = 256,
    sheetContentHeight = 256
}

SheetInfo.frameIndex =
{

    ["1@2x"] = 1,
    ["2@2x"] = 2,
    ["3@2x"] = 3,
    ["4@2x"] = 4,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
