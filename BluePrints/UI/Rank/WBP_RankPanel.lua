--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_RankPanel_C
local WBP_RankPanel_C = Class("BluePrints.UI.BP_UIState_C")

function WBP_RankPanel_C:OnLoaded(...)
    self.ScrollBox_RankInfo:ClearChildren()
    self.RankInfoList = ...
    self.wbp_rankinfo_class = UE4.UClass.Load("/Game/BluePrints/UI/Rank/WBP_RankInfo.WBP_RankInfo")

    self:ChaneInputMode(true)
    self:InitButtons()

    self.ScrollBox_RankInfo:ClearChildren()
    self:InitTitle()
    self:ShowRankInfo()
end

function WBP_RankPanel_C:ChaneInputMode(bIsUI)
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    if bIsUI then
        UE4.UWidgetBlueprintLibrary.SetInputMode_UIOnly(PlayerController, self)
        PlayerController.bShowMouseCursor = true
    else
        UE4.UWidgetBlueprintLibrary.SetInputMode_GameOnly(PlayerController)
        PlayerController.bShowMouseCursor = false
    end
end

function WBP_RankPanel_C:InitButtons()
    -- self.Btn_Close.btn_close.OnClicked:Add(self, self.Close)
    self.Btn_Close:Init("Close", self, self.Close)
end

function WBP_RankPanel_C:InitTitle()
    self.WBP_RankInfo_Title = UE4.UWidgetBlueprintLibrary.Create(self, self.wbp_rankinfo_class)
    self.ScrollBox_RankInfo:AddChild(self.WBP_RankInfo_Title)
    self.WBP_RankInfo_Title:SetTextByTable({"排名","玩家名称","排序依据","角色","近战武器","远程武器","伤害"})
end

function WBP_RankPanel_C:ShowRankInfo()
    for i,v in pairs(self.RankInfoList) do
        local wbp_rankinfo = UE4.UWidgetBlueprintLibrary.Create(self, self.wbp_rankinfo_class)
        self.ScrollBox_RankInfo:AddChild(wbp_rankinfo)
        wbp_rankinfo:SetTextByInfo(i,v)
    end
end

function WBP_RankPanel_C:Close()
    self:ChaneInputMode(false)
    self.Btn_Close.btn_close.OnClicked:Clear()
    self.Super.Close(self)
end

return WBP_RankPanel_C
