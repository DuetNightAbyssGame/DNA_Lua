--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local ArmoryUtils = require "BluePrints.UI.WBP.Armory.ArmoryUtils"

---@type WBP_Armory_SkinMod_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C","BluePrints.UI.BP_EMUserWidgetUtils_C"})

function M:Construct()
    self.TextNot:SetText(GText("UI_Mod_Not_Get"))
    self.Key:CreateCommonKey({ KeyInfoList = {{Type = "Img", ImgShortPath = "Y"}} })
    self:AddInputMethodChangedListen()
    self:RefreshOpInfoByInputDevice(UIUtils.UtilsGetCurrentInputType())
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    self:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
    if(CurInputDevice == ECommonInputType.Gamepad)then
        self.Key:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    else
        self.Key:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

--function M:Destruct()
--end

function M:Init(Params)
    self.Params = Params
    local Avatar = ArmoryUtils:GetAvatar()
    local HasMod = false
    local ModServerData
    for _, Mod in pairs(Avatar.Mods) do
        if(Mod.ModId == Params.ModId)then
            ModServerData = Mod
            HasMod = true
            break
        end
    end
    self.HasMod = HasMod
    if(HasMod)then
        self:StopAnimation(self.Not)
        self:PlayAnimation(self.Normal)
    else
        self:StopAnimation(self.Normal)
        self:PlayAnimation(self.Not)
    end
    local Data = DataMgr.Mod[Params.ModId]
    if(not Data)then
        return
    end
    self:SetRarity(Data.Rarity)
    self.TextModName:SetText(GText(Data.Name))
    if(ModServerData)then
        self.TextCostNum:SetText(ModServerData.CostMod)
    else
        self.TextCostNum:SetText(Data.Cost + Data.MaxLevel * Data.CostChange)
    end
    self.Image_ModIcon:SetBrushResourceObject(LoadObject(Data.Icon))
end

function M:SetRarity(Rarity)
    local VarName = "Qua_" .. (Rarity or "")
    if(self[VarName])then
        self.Image_Qua:SetBrushResourceObject(self[VarName])
    end
end

function M:OnBtnClicked()
    if(not self.HasMod)then
        return
    end
    ModController:OpenView(ModCommon.ArmoryMod,
        self.Params.Type,self.Params.Tag,{self.Params.Target.Uuid},nil
    )
end

return M
