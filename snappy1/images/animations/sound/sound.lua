--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:0e94d860fd4d37de6329775f69751768:1/1$
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
            x=102,
            y=2,
            width=22,
            height=44,
            sourceX = 0,
            sourceY = 3,
            sourceWidth = 50,
            sourceHeight = 50
        },
        {
            -- 2@2x
            x=2,
            y=48,
            width=33,
            height=44,
            sourceX = 0,
            sourceY = 3,
            sourceWidth = 50,
            sourceHeight = 50
        },
        {
            -- 3@2x
            x=57,
            y=2,
            width=43,
            height=44,
            sourceX = 0,
            sourceY = 3,
            sourceWidth = 50,
            sourceHeight = 50
        },
        {
            -- 4@2x
            x=2,
            y=2,
            width=53,
            height=44,
            sourceX = 0,
            sourceY = 3,
            sourceWidth = 53,
            sourceHeight = 50
        },
    },
    
    sheetContentWidth = 128,
    sheetContentHeight = 128
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
