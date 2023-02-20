include("shared.lua")

function ENT:Initialize()
    self:initVars()
    if not self.DisplayName or self.DisplayName == "" then
        self.DisplayName = DarkRP.getPhrase("money_printer")
    end
end

local camStart3D2D = cam.Start3D2D
local camEnd3D2D = cam.End3D2D
local drawWordBox = draw.WordBox
local IsValid = IsValid

local color_clear = Color(0,0,0,0)
local color_white = color_white
local color_frame = Color(175,206,0,255) 
local color_txtframe = Color(64,64,64,255)
local color_outline = Color(109,109,109,255)

function ENT:Draw()
    self:DrawModel()

    local Pos = self:GetPos()
    local Ang = self:GetAngles()

    local owner = self:Getowning_ent()
    owner = (IsValid(owner) and owner:Nick()) or DarkRP.getPhrase("unknown")

    local money = "Money: $" .. self:GetMoney()

    surface.SetFont("HUDNumber5")
    local text = self.DisplayName
    local text2 =  self.Frame
    local text3 =  self.TxtFrame
    local TextWidth4 = surface.GetTextSize(text)
    local TextWidth3 = surface.GetTextSize(owner)
    local TextWidth2 = surface.GetTextSize(money)
    local TextWidth = surface.GetTextSize(text2)
    local TextWidth1 = surface.GetTextSize(text3)

    
    Ang:RotateAroundAxis(Ang:Up(), 90)

    camStart3D2D(Pos + Ang:Up() * 11.5, Ang, 0.11)
        drawWordBox(2, -TextWidth * 0.4, -140, text2, "CloseCaption_BoldItalic", color_frame, color_clear)
        drawWordBox(2, -TextWidth * 0.4, 5, text2, "CloseCaption_BoldItalic", color_frame, color_clear)
        drawWordBox(2, -TextWidth * 0.4, 35, text2, "CloseCaption_BoldItalic", color_frame, color_clear)
        drawWordBox(2, -TextWidth * 0.4, 65, text2, "CloseCaption_BoldItalic", color_frame, color_clear)
        drawWordBox(2, -TextWidth * 0.4, -100, text2, "CloseCaption_BoldItalic", color_frame, color_clear)
        drawWordBox(2, -TextWidth * 0.4, -70, text2, "CloseCaption_BoldItalic", color_frame, color_clear) 
        drawWordBox(2, -TextWidth * 0.4, -120, text2, "CloseCaption_BoldItalic", color_frame, color_clear)
        drawWordBox(2, -TextWidth * 0.4, 95, text2, "CloseCaption_BoldItalic", color_frame, color_clear)
        drawWordBox(2, -TextWidth * 0.4, 120, text2, "CloseCaption_BoldItalic", color_frame, color_clear)
        drawWordBox(2, -TextWidth * 0.4, -40, text2, "CloseCaption_BoldItalic", color_frame, color_clear)
        drawWordBox(2, -TextWidth * 0.4, -15, text2, "CloseCaption_BoldItalic", color_frame, color_clear)
        drawWordBox(2, -TextWidth1 * 0.4, 43, text3, "CloseCaption_BoldItalic", color_txtframe, color_clear)
        drawWordBox(2, -TextWidth1 * 0.4, -20, text3, "CloseCaption_BoldItalic", color_txtframe, color_clear)
        drawWordBox(2, -TextWidth1 * 0.4, -80, text3, "CloseCaption_BoldItalic", color_txtframe, color_clear)
        drawWordBox(2, -TextWidth4 * 0.4, -20, text, "DermaLarge", color_clear, color_white)
        drawWordBox(2, -TextWidth3 * 0.4, -80, owner, "DermaLarge", color_clear, color_white)
        drawWordBox(2, -TextWidth2 * 0.4, 40, money, "DermaLarge", color_clear, color_white)
    camEnd3D2D()
end

function ENT:Think()
end