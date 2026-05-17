require "UnLua"

---@type WBP_Activity_SoloTreasure_Level_PrepareBtn_C
local Level_PrepareBtn = Class({"BluePrints.UI.BP_EMUserWidget_C"})

function Level_PrepareBtn:BindPrepareBtnState()
    self.Button_Area.OnClicked:Add(self, self.BtnOnClicked)

    if self.Button_Area.OnHovered then
        self.Button_Area.OnHovered:Clear()
        self.Button_Area.OnHovered:Add(self, self.BtnHovered)
    end

    if self.Button_Area.OnUnhovered then
        self.Button_Area.OnUnhovered:Clear()
        self.Button_Area.OnUnhovered:Add(self, self.BtnUnhovered)
    end

    if self.Button_Area.OnPressed then
        self.Button_Area.OnPressed:Clear()
        self.Button_Area.OnPressed:Add(self, self.BtnPressed)
    end
end

function Level_PrepareBtn:BtnHovered()
    self:PlayAnimation(self.Hover)
end

function Level_PrepareBtn:BtnUnhovered()
    self:StopAnimation(self.Hover)
    self:PlayAnimation(self.UnHover)
end

function Level_PrepareBtn:BtnPressed()
    self:StopAnimation(self.Hover)
    self:PlayAnimation(self.Press)
end

function Level_PrepareBtn:BtnOnClicked()
    self:StopAnimation(self.Hover)
    self:StopAnimation(self.Press)
    self:PlayAnimation(self.Click)
end

return Level_PrepareBtn
