--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Reasoning_Ani_C
local M = Class("BluePrints.UI.BP_UIState_C")

function M:Construct()
    self:SetCharacterImg()
    self.GameInputModeSubsystem:SetNavigateWidgetOpacity(0)
end

function M:SetCharacterImg()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        DebugPrint("Error: WBP_Reasoning_Ani_C SetCharacterImg 找不到Avatar")
    end
    local RegionId = Avatar:GetCurrentRegionId()
    if(not RegionId or DataMgr.SubRegion[RegionId] == nil) then
        DebugPrint("Error: WBP_Reasoning_Ani_C SetCharacterImg 找不到区域或区域对应Player数据 RegionId: ", RegionId)
        return
    end
    -- Player/EXplayer
    local PlayerIdentity = DataMgr.SubRegion[RegionId].SwitchPlayer
    if not PlayerIdentity then
        DebugPrint("Error: WBP_Reasoning_Ani_C SetCharacterImg 当前区域没有可切换角色")
        return
    end
    if PlayerIdentity == "Player" then
        if Avatar.Sex == 1 then
            self.CharaImg = LoadObject("Texture2D'/Game/UI/Texture/Dynamic/Image/Reasoning/T_Reasoning_Female.T_Reasoning_Female'")
        else
            self.CharaImg = LoadObject("Texture2D'/Game/UI/Texture/Dynamic/Image/Reasoning/T_Reasoning_Male.T_Reasoning_Male'")
        end
    else
        if Avatar.WeitaSex == 1 then
            self.CharaImg = LoadObject("Texture2D'/Game/UI/Texture/Dynamic/Image/Reasoning/T_Reasoning_EXFemale.T_Reasoning_EXFemale'")
        else
            self.CharaImg = LoadObject("Texture2D'/Game/UI/Texture/Dynamic/Image/Reasoning/T_Reasoning_EXFemale.T_Reasoning_EXMale'")
        end
    end
    self.Image_Avatar:SetBrushResourceObject(self.CharaImg)
end

function M:OnLoaded(...)
	M.Super:OnLoaded(...)
    self.Answers,self.AnswerId = ...
    self:BindToAnimationFinished(self.In,{self,function ()
        self:UnbindAllFromAnimationFinished(self.In)
        self.AssociateWidget = UIManager(self):LoadUINew("DetectiveAssociate", 2, self.Answers, self.AnswerId)
        self:PlayAnimation(self.Out)
    end})
    self:BindToAnimationFinished(self.Out,{self,function ()
        self:UnbindAllFromAnimationFinished(self.Out)
        self.AssociateWidget:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.AssociateWidget:StopAllAnimations()
        self.AssociateWidget:StartPlayInAnimation()
        self:Close()
    end})
    self:PlayAnimation(self.In)
    AudioManager(self):PlayUISound(self, "event:/ui/common/tuili_clue_think_inspiration", nil, nil)
    self:SetFocus()
end

return M
