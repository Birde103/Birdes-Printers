AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.SpawnOffset = Vector(15, 0, 15)

local function PrintMore(ent)
    if not IsValid(ent) then return end

    ent.sparking = true
    timer.Simple(3, function()
        if not IsValid(ent) then return end
        ent:CreateMoneybag()
    end)
end

function ENT:StartSound()
    self.sound = CreateSound(self, Sound("ambient/levels/labs/equipment_printer_loop1.wav"))
    self.sound:SetSoundLevel(25)
    self.sound:PlayEx(1, 100)
end

function ENT:PostInit()
    --Dumb things what you want to run on printer spawn
end

function ENT:Initialize()
    self:initVars()
    self:SetModel(self.model)
    DarkRP.ValidatedPhysicsInit(self, SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

    local phys = self:GetPhysicsObject()

    if phys:IsValid() then
        phys:Wake()
    end

    timer.Simple(math.random(self.MinTimer, self.MaxTimer), function() PrintMore(self) end)
    self:StartSound()
    self:PostInit()
end

function ENT:OnTakeDamage(dmg)
    self:TakePhysicsDamage(dmg)

    if self.burningup then return end

    self.damage = (self.damage or 100) - dmg:GetDamage()
    if self.damage <= 0 then
        local rnd = math.random(1, 10)
        if rnd < 3 then
            self:BurstIntoFlames()
        else
            self:Destruct()
            self:Remove()
        end
    end
end

function ENT:Destruct()
    local vPoint = self:GetPos()
    local effectdata = EffectData()
    effectdata:SetStart(vPoint)
    effectdata:SetOrigin(vPoint)
    effectdata:SetScale(1)
    util.Effect("Explosion", effectdata)
    if IsValid(self:Getowning_ent()) then DarkRP.notify(self:Getowning_ent(), 1, 4, DarkRP.getPhrase("money_printer_exploded")) end
end

function ENT:BurstIntoFlames()
    if hook.Run("moneyPrinterCatchFire", self) == true then return end

    if IsValid(self:Getowning_ent()) then DarkRP.notify(self:Getowning_ent(), 0, 4, DarkRP.getPhrase("money_printer_overheating")) end
    self.burningup = true
    local burntime = math.random(8, 18)
    self:Ignite(burntime, 0)
    timer.Simple(burntime, function() self:Fireball() end)
end

function ENT:Fireball()
    if not self:IsOnFire() then self.burningup = false return end
    local dist = math.random(20, 280) -- Explosion radius
    self:Destruct()
    for k, v in ipairs(ents.FindInSphere(self:GetPos(), dist)) do
        if not v:IsPlayer() and not v:IsWeapon() and v:GetClass() ~= "predicted_viewmodel" and not v.IsMoneyPrinter then
            v:Ignite(math.random(5, 22), 0)
        elseif v:IsPlayer() then
            local distance = v:GetPos():Distance(self:GetPos())
            v:TakeDamage(distance / dist * 100, self, self)
        end
    end
    self:Remove()
end

function ENT:CreateMoneybag()
    if self:IsOnFire() then return end

    local MoneyPos = self:GetPos() + self.SpawnOffset
    amount = hookAmount or amount

--Overheat

    local amount = 200

    self:SetMoney( self:GetMoney() + amount )

    --local moneybag = DarkRP.createMoneyBag(MoneyPos, amount)
    hook.Run("moneyPrinterPrinted", self, moneybag)
    self.sparking = false
    timer.Simple(math.random(self.MinTimer, self.MaxTimer), function() PrintMore(self) end)
end

function ENT:Think()
    if self:WaterLevel() > 0 then
        self:Destruct()
        self:Remove()
        return
    end
    self:StartSound()
    if not self.sparking then return end

    local effectdata = EffectData()
    effectdata:SetOrigin(self:GetPos())
    effectdata:SetMagnitude(0)
    effectdata:SetScale(0)
    effectdata:SetRadius(0)
    util.Effect("Sparks", effectdata)
end

function ENT:Use( ply )
    if self:GetMoney() > 0 then

        ply:addMoney( self:GetMoney() )

        DarkRP.notify( ply, 0, 5, "You Took $" .. self:GetMoney() .. " From The Gold Printer")

        self:SetMoney( 0 )
    end
end