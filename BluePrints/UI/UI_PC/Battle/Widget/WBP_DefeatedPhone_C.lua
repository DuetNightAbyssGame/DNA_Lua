--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type Battle_Execute_Phone_C
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

M._components = {
    "BluePrints.UI.UI_Phone.Battle.Component.DraggableWidgetComponent",
}

--function M:Initialize(Initializer)
--end

--function M:PreConstruct(IsDesignTime)
--end

function M:Construct()
    self.ExecuteItems = {}
    self.Btn_Execute.OnClicked:Add(self, self.OnClick)
end

function M:Tick(MyGeometry, InDeltaTime)
    self:RefreshPhoneExecuteBan()
end

function M:IsCanExecute()
    if not self.Player then
        return false
    end
    if not self.Player:DoCheckUseSkill(self.Player:GetSkillByType(UE.ESkillType.Condemn)) then
        return false
    end
    for Widget, _ in pairs(self.ExecuteItems) do
        if Widget.bCanExecute and Widget.DefeatedCharacter and Widget.DefeatedCharacter.PenalizeInteractiveComponent
                and Widget.DefeatedCharacter.PenalizeInteractiveComponent:IsCanInteractive(self.Player) then
            return true
        end
    end
    return false
end

function M:IsCanExecuteForSingleCharacter(Character)
    if not self.Player then
        return false
    end
    if not self.Player:DoCheckUseSkill(self.Player:GetSkillByType(UE.ESkillType.Condemn)) then
        return false
    end
    for Widget, _ in pairs(self.ExecuteItems) do
        if Widget.bCanExecute and Widget.DefeatedCharacter and Widget.DefeatedCharacter == Character and Widget.DefeatedCharacter.PenalizeInteractiveComponent
                and Widget.DefeatedCharacter.PenalizeInteractiveComponent:IsCanInteractive(self.Player) then
            return true
        end
    end
    return false
end

function M:PlayLoopAnimation(Widget)
    if not self.PlayLoopWidget then
        self.PlayLoopWidget = {}
    end
    if CommonUtils.TableLength(self.PlayLoopWidget) == 0 then
        self:PlayAnimation(self.Loop, 0, 0, 0, 1, true)
    end
    self.PlayLoopWidget[Widget] = true
end

function M:StopLoopAnimation(Widget)
    if not self.PlayLoopWidget then
        self.PlayLoopWidget = {}
    end
    self.PlayLoopWidget[Widget] = nil
    if CommonUtils.TableLength(self.PlayLoopWidget) == 0 then
        self:StopAnimation(self.Loop)
    end
end

function M:RefreshPhoneExecuteBan()
    if CommonUtils.GetDeviceTypeByPlatformName(self) ~= "Mobile" then
        return
    end
    -- 拖拽状态不处理状态，表示在自定义设计界面之中
    if (self.bDraggable) then
        return
    end
    if self:IsCanExecute() then
        if self.IsPlayBan then
            self:ShowBan(false)
        end
        self.IsPlayBan = false
    else
        if not self.IsPlayBan then
            self:ShowBan(true)
        end
        self.IsPlayBan = true
    end
end

function M:Show(ExecuteItem)
    self.ExecuteItems[ExecuteItem] = true
    if self.IsShow then
        return
    end
    self.IsShow = true
    self.Player = UGameplayStatics.GetPlayerCharacter(self, 0)
    self.IsPlayBan = false
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManager = GameInstance:GetGameUIManager()
    self.DefeatedUI = UIManager:GetUIObj("DefeatedInteract")
    self:StopAllAnimations()
    self:SetVisibility(ESlateVisibility.Visible)
    self:PlayAnimation(self.In)
    local BattleMainUI = UIManager:GetUIObj("BattleMain")
    if BattleMainUI and BattleMainUI.Char_Skill then
        BattleMainUI.Char_Skill.Switch_Type:SetActiveWidgetIndex(0)
    end
end

function M:Hide(ExecuteItem)
    self.ExecuteItems[ExecuteItem] = nil
    local IsZero = CommonUtils.TableLength(self.ExecuteItems) == 0
    if self.IsShow == false and IsZero then
        return
    end
    self.IsShow = false
    self.IsPlayBan = false
    self:StopAllAnimations()
    self:ShowBan(false)
    self:PlayAnimation(self.Out)
end

function M:DirectlyClose()
    self.IsShow = false
    self.IsPlayBan = false
    self:StopAllAnimations()
    self:ShowBan(false)
    self:PlayAnimation(self.Out)
end

function M:ShowBan(IsShow)
    if IsShow then
        self.Image_Ban:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Image_Icon:SetOpacity(0.5)
        self:StopAnimation(self.Loop)
    else
        self.Image_Ban:SetVisibility(ESlateVisibility.Collapsed)
        self.Image_Icon:SetOpacity(1)
        for Widget, v in pairs(self.ExecuteItems) do
            if Widget and Widget.MarkPlayLoop then
                self:PlayAnimation(self.Loop, 0, 0, 0, 1, true)
                break
            end
        end
    end
end

function M:OnAnimationFinished(Animation)
    if Animation == self.Out then
        self:SetVisibility(ESlateVisibility.Collapsed)
    elseif Animation == self.In then
        --self:PlayAnimation(self.Loop)
    end
end

function M:OnClick()
    ---@type Battle_Execute_PC_C
    local DefeatedUI = UIManager(self):GetUIObj("DefeatedInteract")
    if not DefeatedUI then
        return
    end
    if self.IsPlayBan then
        return
    end
    DefeatedUI:OnClick()
end

AssembleComponents(M)

return M
