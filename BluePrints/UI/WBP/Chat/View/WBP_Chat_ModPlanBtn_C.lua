--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local ModModel = ModController:GetModel()

---@type WBP_Chat_ModPlanBubble_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

-- function M:Construct()
-- end

function M:OnBtnClickInMod()
    local ChatView = ChatController:GetView()
    if ChatView.IsBeginToClose then return end

    local Tag = nil
    if self.TargetType == "Weapon" then
        local BattleConf = DataMgr.BattleWeapon[self.TargetId]
        if BattleConf.WeaponTag then
            if table.findValue(BattleConf.WeaponTag, "Melee") then
                Tag = "Melee"
            elseif table.findValue(BattleConf.WeaponTag, "Ranged") then
                Tag = "Ranged"
            end
        end
    else Tag = self.TargetType end
    
    local bBattle = ChatView.bBattle
    ChatView:Close()
    
    local UIMode
    if self.bSelfMsg then
    --当是自己发出的消息时，Mod界面仅为预览模式
        UIMode = ModCommon.MainUICase.Preview
    else
    --当是他人发出的消息时，Mod界面才为导入模式
        UIMode = ModCommon.MainUICase.CopyMode
    end
    ModModel:CreateDummyAvatarForCopyMode(self.ModSuitInfo, self.SenderName)
    ModController:OpenView(ModCommon.ArmoryMod, self.TargetType, Tag, 
        {1}, nil, {Func = function()
            ChatController:OpenView(nil, bBattle)
        end}, UIMode, nil)
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_mod_suit_preset", nil, nil)
end
function M:OnBtnClickInSkin()
    local ChatView = ChatController:GetView()
    if ChatView.IsBeginToClose then return end
    if IsClient(self) then
        UIManager(self):ShowUITip("CommonToastMain", GText("UI_COMMONPOP_TITLE_100059"))
        return
    end
    local bBattle = ChatView.bBattle
    ChatView:Close()
    UIManager(self):LoadUINew("ArmorySkin", {
        Type = self.SkinType, 
        SkinId = self.SkinId,
        HairId = self.HairId,
        OpenPreviewDyeFromChat = true, 
        Colors = self.DyePlanInfo.Colors, 
        OnCloseCallback= function()
            ChatController:OpenView(nil, bBattle)
        end
    })
end
function M:Destruct()
    -- self.Button_Area.OnClicked:Remove(self, self.OnBtnClickInMod)
    -- self.Button_Area.OnClicked:Remove(self, self.OnBtnClickInSkin)
end

function M:InitMod(ModSuitInfo, bSelfMsg, SenderName)
    self.DyePlanInfo = nil
    self.SenderName = nil
    self.ModSuitInfo = ModSuitInfo
    local ModSuitName = ModSuitInfo.TargetInfo[6]
    local TargetType = ModSuitInfo.TargetInfo[1]
    local TargetId = ModSuitInfo.TargetInfo[2]
    self.TargetType = TargetType
    self.TargetId = TargetId
    self.Text_Plan:SetText(GText(ModSuitName))
    local Conf, Name = nil, "角色或武器被删除了!!!!"
    if TargetType == "Char" then
        Conf = DataMgr.Char[TargetId]
        if Conf.GenderTag ~= nil then
            Name = SenderName
            self.SenderName = SenderName
        else
            Name = Conf.CharName
        end
    elseif TargetType == "Weapon" then
        Conf = DataMgr.Weapon[TargetId]
        Name = Conf.WeaponName
    elseif TargetType == "UWeapon" then
        Conf = DataMgr.UWeapon[TargetId]
        Name = Conf.WeaponName
    end
    if Conf.Icon then
        UResourceLibrary.LoadObjectAsync(self, Conf.Icon, {self, function(_, Icon)
            local Mat = self.Img_Avatar:GetDynamicMaterial()
            Mat:SetTextureParameterValue("IconMap", Icon)
        end})
    end
    self.Text_Avatar:SetText(GText(Name))
    self.bSelfMsg = bSelfMsg
    -- if bSelfMsg then
    --     self.Button_Area:SetVisibility(UIConst.VisibilityOp.Collapsed)
    -- else
    --     self.Button_Area:SetVisibility(UIConst.VisibilityOp.Visible)
    -- end
    self.Button_Area.OnClicked:Clear()
    self.Button_Area.OnClicked:Add(self, self.OnBtnClickInMod)
end

function M:InitDye(DyePlanInfo, bSelfMsg)
    self.ModSuitInfo = nil
    self.DyePlanInfo = DyePlanInfo
    local DyePlanName = DyePlanInfo.PlanName
    local SkinType = DyePlanInfo.SkinType
    local SkinId = DyePlanInfo.SkinId
    local SkinName = DyePlanInfo.TargetName
    self.SkinType = SkinType
    self.SkinId = SkinId
    self.Text_Plan:SetText(GText(DyePlanName))
    local Conf = nil
    if SkinType == "Char" then
        Conf = DataMgr.Skin[SkinId]
    elseif SkinType == "Weapon" then
        Conf = DataMgr.WeaponSkin[SkinId] or DataMgr.Weapon[SkinId]
    elseif SkinType == "Hair" then
        Conf = DataMgr.Hair[SkinId]
        self.SkinType = "Char"
        self.HairId = SkinId
        self.SkinId = DyePlanInfo.CharId
    end
    if Conf and Conf.Icon then
        UResourceLibrary.LoadObjectAsync(self, Conf.Icon, {self, function(_, Icon)
            local Mat = self.Img_Avatar:GetDynamicMaterial()
            Mat:SetTextureParameterValue("IconMap", Icon)
        end})
    end
    self.Text_Avatar:SetText(GText(SkinName))
    self.bSelfMsg = bSelfMsg
    -- if bSelfMsg then
    --     self.Button_Area:SetVisibility(UIConst.VisibilityOp.Collapsed)
    -- else
    --     self.Button_Area:SetVisibility(UIConst.VisibilityOp.Visible)
    -- end
    self.Button_Area.OnClicked:Clear()
    self.Button_Area.OnClicked:Add(self, self.OnBtnClickInSkin)
end
return M
