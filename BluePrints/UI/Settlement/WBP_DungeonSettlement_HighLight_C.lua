local FriendController = require "BluePrints.UI.WBP.Friend.FriendController"
--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Settlement_DataDisplay_C
local WBP_Settlement_DataDisplay_C = Class({"BluePrints.UI.BP_EMUserWidget_C"})

--function M:Initialize(Initializer)
--end

function WBP_Settlement_DataDisplay_C:Construct()
    local LevelEnterData = DataMgr.LevelEnterData
    self.SwitchBattleDataTypeToText = {
        ["Damage"] = LevelEnterData["Damage"].HighLightName,--伤害
        ["Kill"] = LevelEnterData["Kill"].HighLightName,--击杀
        ["Damaged"] = LevelEnterData["Damaged"].HighLightName,--承受伤害
        ["Heal"] = LevelEnterData["Heal"].HighLightName,--治疗
        ["DamageSingle"] = LevelEnterData["DamageSingle"].HighLightName,--单次最高伤害
        ["Destroy"] = LevelEnterData["Destroy"].HighLightName,--击破可破碎物
        ["HitCount"] = LevelEnterData["HitCount"].HighLightName,--最高连击数
    }
    self.IconColorByType = {
        [1] = self.Color_Red,
        [2] = self.Color_Blue,
        [3] = self.Color_Green,
        [4] = self.Color_Yellow,
    }

    --绑定按钮信息
    self.Button_Area.OnClicked:Add(self, self.OnAddFriendButtonClicked)
    self.Button_Area.OnHovered:Add(self, self.OnAddFriendButtonHovered)
    self.Button_Area.OnUnhovered:Add(self, self.OnAddFriendButtonUnhovered)
    self.Button_Area.OnPressed:Add(self, self.OnAddFriendButtonPressed)

    self:UnbindAllFromAnimationFinished(self.AddBtn_Click)
    self:BindToAnimationFinished(self.AddBtn_Click, {self, function()
        self:PlayAnimation(self.AddBtn_Hover)
    end})
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

-- Parmas  Type 显示类型  Value 数据
function WBP_Settlement_DataDisplay_C:Init(Parmas)
    self.Parmas = Parmas
    if not self.Parmas then
        return
    end
    self.TitleText = GText(self.SwitchBattleDataTypeToText[self.Parmas.DataName])
    self.Text_Type:SetText(self.TitleText)
    self:InitUIByType()
    self:SetColor()
    self:InitData()
    self:InitFriendData()
    --self:SetVisibility(ESlateVisibility.Visible)
    --self:PlayAnimation(self.In) --蓝图里播放
end

function WBP_Settlement_DataDisplay_C:InitFriendData()
    --真人玩家名称
    if self.Parmas.PlayerName then
        self:SwitchName(0)
        self.Text_Name:SetText(self.Parmas.PlayerName)
    else
        self:SwitchName(1)
        self.Text_Name:SetText(GText("UI_Shadow_Name"))
        --self.Text_Name:SetVisibility(ESlateVisibility.Collapsed)
    end

    --显示添加好友信息按钮
    if self.Parmas.Uid and self:CheckAddFriend() then
        self.Text_Add:SetText(GText("UI_Friend_AddFriend"))
        self.SizeBox_Add:SetVisibility(ESlateVisibility.Visible)
        self:PlayAnimation(self.AddBtn_Normal)
    else
        self.bIsFocusable = false
        self.SizeBox_Add:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function WBP_Settlement_DataDisplay_C:CheckAddFriend()
    --已经是好友/黑名单不显示
    DebugPrint("CheckAddFriend", FriendController:GetModel():GetBlackListDict()[self.Parmas.Uid], FriendController:GetModel():GetFriendDict()[self.Parmas.Uid])
    return (FriendController:GetModel():GetBlackListDict()[self.Parmas.Uid] == nil) and (FriendController:GetModel():GetFriendDict()[self.Parmas.Uid] == nil)
end

--图标染色
function WBP_Settlement_DataDisplay_C:SetColor()
    local DataType = DataMgr.LevelEnterData[self.Parmas.DataName].Type
    if not DataType then
        return
    end
    local Color = self.IconColorByType[DataType]  -- FSlateColor
    self:SwitchColor(DataType - 1)
    -- self.Icon_Type:SetColorAndOpacity(Color.SpecifiedColor)
    -- self.Text_Colon:SetColorAndOpacity(Color.SpecifiedColor) 
    -- self.Text_Data:SetColorAndOpacity(Color.SpecifiedColor) 
    -- self.Text_Type:SetColorAndOpacity(Color.SpecifiedColor) 
end

function WBP_Settlement_DataDisplay_C:InitUIByType()
    --加载图标
    local IconPath = DataMgr.LevelEnterData[self.Parmas.DataName].Icon
    if not IconPath then
        return
    end
    IconPath = string.format("Texture2D'/%s'", IconPath)
    local Img = LoadObject(IconPath)
    if not Img then
        DebugPrint("缺少图片资源: ImgPath = " .. IconPath)
        return
    end
    self.Icon_Type:SetBrushResourceObject(Img)
end

function WBP_Settlement_DataDisplay_C:InitData()
    local NumText = self.Parmas.Value
    if NumText < 1000000000 then
        NumText = Utils.FormatNumber(NumText, false)
        if self.Parmas.DataName == "Damage" or self.Parmas.DataName == "Damaged" then
            NumText = string.format("%s", NumText).."%"
        end
    else
        NumText = Utils.FormatNumber(NumText, true)
    end
    self.Text_Data:SetVisibility(ESlateVisibility.Visible)
    self.Text_Data:SetText(NumText)
end



function WBP_Settlement_DataDisplay_C:OnAddFriendButtonClicked()
    DebugPrint("WBP_Settlement_DataDisplay_C:OnAddFriendButtonClicked")
    self:PlayAnimation(self.AddBtn_Click)
    --FriendController:SendAddFriend(self.Parmas.Uid)
    AudioManager(self):PlayUISound(self, "event:/ui/common/click")
    FriendController:OpenAddFriendDialog(self, {Uid = self.Parmas.Uid})
end

function WBP_Settlement_DataDisplay_C:OnAddFriendButtonHovered()
    DebugPrint("WBP_Settlement_DataDisplay_C:OnAddFriendButtonHovered")
    self:PlayAnimation(self.AddBtn_Hover)
end

function WBP_Settlement_DataDisplay_C:OnAddFriendButtonUnhovered()
    DebugPrint("WBP_Settlement_DataDisplay_C:OnAddFriendButtonUnhovered")
    self:PlayAnimation(self.AddBtn_UnHover)
end

function WBP_Settlement_DataDisplay_C:OnAddFriendButtonPressed()
    DebugPrint("WBP_Settlement_DataDisplay_C:OnAddFriendButtonPressed")
    self:PlayAnimation(self.AddBtn_Press)
end

function WBP_Settlement_DataDisplay_C:OnFocusReceived()
    self.Button_Area:SetFocus()
    return true
end

return WBP_Settlement_DataDisplay_C
