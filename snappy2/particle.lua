-------------------------------------------------------------------------
--T and G Apps Ltd.
--Created by Joseph Stevens
--www.tandgapps.co.uk
--joe@tandgapps.co.uk

--CoronaSDK version 2013.1179 was used for this template.

--You are not allowed to publish this template to the Appstore as it is. 
--You need to work on it, improve it and replace the graphics. 

--For questions and/or bugs found, please contact me using our contact
--form on http://www.tandgapps.co.uk/contact-us/
-------------------------------------------------------------------------


local particle = {}
local particle_mt = { __index = particle }

-- Constructor
function particle.new(particleType, startX, startY)
    local newParticle = {
        particleType = particleType,
        particleImage = display.newImageRect(tileIconSheet, particleType, 30, 30),
        isAlive = true,
        isDirectionNegative = false,
        startX = startX,
        startY = startY,
        offsetX = 0,
        offsetY = 0
    }
    -- Randomly reverse particle x direction
    if math.round(math.random()) == 1 then
        newParticle.isDirectionNegative = true
    end
    return setmetatable(newParticle, particle_mt)
end

-- Update a particle's position
function particle:update()
    -- Don't do anything if the particle is dead
    if not self.isAlive then
        return
    end

    -- Move and fade out the particle
    self.offsetX = self.offsetX + 3
    self.offsetY = (math.sin(self.offsetX / 100 * 2 + 1) * 2 - 1.7) * 200
    if self.isDirectionNegative then
        self.particleImage.x = self.startX - self.offsetX
    else
        self.particleImage.x = self.startX + self.offsetX
    end
    self.particleImage.y = self.startY - self.offsetY
    self.particleImage.alpha = self.particleImage.alpha - 0.05
    if self.particleImage.alpha <= 0.1 then
        self.isAlive = false
        self.particleImage:removeSelf()
        self.particleImage = nil
    end
end

return particle
