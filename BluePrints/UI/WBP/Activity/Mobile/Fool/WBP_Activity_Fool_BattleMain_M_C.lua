require "UnLua"

local M = Class("BluePrints.UI.WBP.Activity.PC.Fool.WBP_Activity_Fool_BattleMain_Base")
local ROTATE_SENSITIVITY  = 0.1

function M:Construct()
    self.Super.Construct(self)
end

function M:Destruct()
    self.Skill01.Button_Area.OnClicked:Clear()
    self.Skill02.Button_Area.OnClicked:Clear()
    self.Super.Destruct(self)
end

function M:InitTransformButtons()
    self.Skill01.Button_Area.OnClicked:Add(self, self.SwitchTransform)   -- 切换变身按钮
    self.Skill02.Button_Area.OnClicked:Add(self, self.Randomransform)   -- 再次随机按钮
end

function M:OnTouchMoved(MyGeometry, InTouchEvent)
    local CursorDelta = UE4.UKismetInputLibrary.PointerEvent_GetCursorDelta(InTouchEvent)
    local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    if PlayerCharacter and IsValid(PlayerCharacter) then
        PlayerCharacter:AddCharacterYawInput(CursorDelta.X * ROTATE_SENSITIVITY)
        PlayerCharacter:AddCharacterPitchInput(-CursorDelta.Y * ROTATE_SENSITIVITY)
    end

    return UIUtils.Handled
end


return M