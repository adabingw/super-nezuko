PlayerAttackState = Class{__includes = BaseState}

function PlayerAttackState:init(player)
    self.player = player
    local hitboxX, hitboxY, hitboxWidth, hitboxHeight

    -- hitboxWidth = 20
    -- hitboxHeight = 35
    -- hitboxX = self.player.x - hitboxWidth
    -- hitboxY = self.player.y + 2

    if self.player.direction == 'left' then
        hitboxWidth = 15
        hitboxHeight = 16
        hitboxX = self.player.x - hitboxWidth
        hitboxY = self.player.y + 2
    elseif self.player.direction == 'right' then
        hitboxWidth = 15
        hitboxHeight = 16
        hitboxX = self.player.x + self.player.width
        hitboxY = self.player.y + 2
    end

    -- separate hitbox for the player's sword; will only be active during this state
    self.swordHitbox = Hitbox(hitboxX, hitboxY, hitboxWidth, hitboxHeight)

    -- sword-left, sword-up, etc
    self.animation = Animation {
        frames = {6},
        interval = 1
    }

    self.player.currentAnimation = self.animation
end

function PlayerAttackState:update(dt)
    self.player.currentAnimation:update(dt)
    gSounds['sword']:stop()
    gSounds['sword']:play()
    
    -- check if hitbox collides with any entities in the scene
    for k, entity in pairs(self.player.level.entities) do
        if entity:collides(self.swordHitbox) then
            gSounds['kill']:play()
            gSounds['kill2']:play()
            self.player.score = self.player.score + 100
            table.remove(self.player.level.entities, k)
        end 
    end

    if love.keyboard.wasPressed('space') then
        self.player:changeState('jump')
    else 
        self.player:changeState('idle')
    end

    if love.keyboard.isDown('left') or love.keyboard.isDown('right') then
        self.player:changeState('walking')
    end

    if love.keyboard.wasPressed('up') then
        self.player:changeState('jump')
    end

    -- -- if we've fully elapsed through one cycle of animation, change back to idle state
    -- if self.player.currentAnimation.timesPlayed > 0 then
        -- self.player.currentAnimation.timesPlayed = 0
    -- end

    --
    -- debug for player and hurtbox collision rects VV
    --

    -- love.graphics.setColor(255, 0, 255, 255)
    love.graphics.rectangle('line', self.player.x, self.player.y, self.player.width, self.player.height)
    love.graphics.rectangle('line', self.swordHitbox.x, self.swordHitbox.y,
        self.swordHitbox.width, self.swordHitbox.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end