--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Experience_Main_EXItem01_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.Avatar = GWorld:GetAvatar()
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function M:OnListItemObjectSet(Content)
    self.Content = Content
    self.Content.Entry = self

    local PlayerExpSubSourceTemp = {}
    for _,SubSourceInfo in pairs(DataMgr.PlayerExpSubSource) do
        if SubSourceInfo.Source == Content.ID then
            if not PlayerExpSubSourceTemp[SubSourceInfo.SubSourceName] or PlayerExpSubSourceTemp[SubSourceInfo.SubSourceName].ID > SubSourceInfo.ID then
                PlayerExpSubSourceTemp[SubSourceInfo.SubSourceName] = SubSourceInfo
            end
        end
    end
    local PlayerExpSubSource = {}
    for SubSourceName,SubSourceInfo in pairs(PlayerExpSubSourceTemp) do
        table.insert(PlayerExpSubSource,SubSourceInfo)
    end
    table.sort(PlayerExpSubSource,function (a,b)
        return a.Sequence > b.Sequence
    end)
    self.List_Attr:ClearListItems()
    for Index,SubSourceInfo in pairs(PlayerExpSubSource) do
        local SubContent = NewObject(UIUtils.GetCommonItemContentClass())
        local SubContentInfo = Content.AllSubContentInfo[SubSourceInfo.SubSourceName]
        SubContent.CanGetRewardExp = SubContentInfo.CanGetRewardExp
        SubContent.CollectRewardExp = SubContentInfo.CollectRewardExp
        SubContent.ID = SubContentInfo.ID
        SubContent.SubSourceName = SubContentInfo.SubSourceName
        SubContent.TotalNum = SubContentInfo.TotalNum
        SubContent.CurNum = SubContentInfo.CurNum
        self.List_Attr:AddItem(SubContent)
    end
    self.Text_Describe_Title:SetText(GText(Content.SourceName))
    self.Text_TitleNum:SetText(Content.SumCollectRewardExp)
    if Content.SumCanGetRewardExp then
        self.Text_TitleNum_All:SetText("/"..Content.SumCanGetRewardExp)
        self.Text_TitleNum_All:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    else
        self.Text_TitleNum_All:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

return M
