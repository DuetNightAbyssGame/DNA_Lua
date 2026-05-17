--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_AutoChess_Level_Linear_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})
local TimeUtils = require "Utils.TimeUtils"
local Model = require  "BluePrints.UI.AutoChess.AutoChessDataModel"

local LetterMap = {
    [1] = "A", [2] = "B", [3] = "C", [4] = "D", [5] = "E",
    [6] = "F", [7] = "G", [8] = "H", [9] = "I", [10] = "J",
    [11] = "K", [12] = "L", [13] = "M", [14] = "N", [15] = "O",
    [16] = "P", [17] = "Q", [18] = "R", [19] = "S", [20] = "T",
    [21] = "U", [22] = "V", [23] = "W", [24] = "X", [25] = "Y",
    [26] = "Z"
}

local LevelState = {
    Pass = 0, --已首通
    UnPass = 1, --解锁未首通
    UnLock = 2, --未解锁
}

local ActiveId = 103016

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()

end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function M:Init(Content)
    --处理首尾空格子
    if Content.Id == -1 then
        self:SetRenderOpacity(0)
        local CanvasSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.BG)
        local ItemSize = CanvasSlot:GetSize()
        CanvasSlot:SetSize(FVector2D(Content.Size/2 -ItemSize.X ,ItemSize.Y))
        return
    end
    self.Content = Content
    self.Id = Content.Id
    self.Index = Content.Index
    self.State = Content.State
    self:PlayAnimation(self.Normal)
    local Info = DataMgr.AutoChessMission[Content.Id]
    if Content.Index % 2 ~= 0 then
        self.Main:SetRenderTranslation(self.Position_Up)
        self.Panel_Line_Down:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Panel_Line_Up:SetVisibility(UE4.ESlateVisibility.Hittestinvisible)
        self.BG_Line_Up:SetVisibility(UE4.ESlateVisibility.Hittestinvisible)
        self.BG_Line_Down:SetVisibility(UE4.ESlateVisibility.Collapsed)
    else
        self.BG_Line_Up:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.BG_Line_Down:SetVisibility(UE4.ESlateVisibility.Hittestinvisible)
        self.Main:SetRenderTranslation(self.Position_Down)
        self.Panel_Line_Down:SetVisibility(UE4.ESlateVisibility.Hittestinvisible)
        self.Panel_Line_Up:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    if Content.NextState and Content.NextState == LevelState.UnLock then
        self.Panel_Line_Down:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Panel_Line_Up:SetVisibility(UE4.ESlateVisibility.Collapsed)
    else
        if Content.Index % 2 ~= 0 then
            self.Main:SetRenderTranslation(self.Position_Up)
            self.BG_Line_Up:SetVisibility(UE4.ESlateVisibility.Hittestinvisible)
            self.BG_Line_Down:SetVisibility(UE4.ESlateVisibility.Collapsed)
        else
            self.Main:SetRenderTranslation(self.Position_Down)
            self.BG_Line_Up:SetVisibility(UE4.ESlateVisibility.Collapsed)
            self.BG_Line_Down:SetVisibility(UE4.ESlateVisibility.Hittestinvisible)
        end
    end

    if Content.bFinal  then
        self.Panel_Line:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    self.Text_Num:SetText(LetterMap[Content.Index % #LetterMap])
    self.Text_Name:SetText(GText(DataMgr.Dungeon[Info.DungeonId].DungeonName))
    self.Btn_Click.OnClicked:Add(self, self.OnCellClicked)
    self.Panel_State:SetVisibility(UE4.ESlateVisibility.Visible)
    if self.State == LevelState.Pass then
        self.New:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.WS_Type:SetActiveWidgetIndex(0)
        self.Text_State:SetTexT(GText("UI_AutoChess_FirstComplete"))
    else
        if self.State == LevelState.UnPass then
            local Node = ReddotManager.GetTreeNode("AutoChessLinear")
            if Node and Node.Cache.Detail and Node.Cache.Detail[self.Id] == nil then
                Node.Cache.Detail[self.Id] = true
                ReddotManager.IncreaseLeafNodeCount(DataMgr.ReddotNode.AutoChessLinear.Name, 1)
                self.New:SetVisibility(UE4.ESlateVisibility.Visible)
            elseif Node and Node.Cache.Detail and Node.Cache.Detail[self.Id] == true then
                self.New:SetVisibility(UE4.ESlateVisibility.Visible)
            end
        end
        if Info.UnlockRankID then
            self.WS_Type:SetActiveWidgetIndex(1)
            self.Text_RankUp:SetTexT(GText("UI_AutoChess_RankLimitUp"))
            local RankInfo = DataMgr.AutoChessPoint[Info.UnlockRankID]
            self.Icon_Rank:SetBrushResourceObject(LoadObject(RankInfo.RankIcon))
        else
            self.Panel_State:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
    end
    self:PlayStateAni()
end




function M:PlayStateAni()
    if self.State == LevelState.UnLock then
        self:PlayAnimation(self.Lock_Normal)
    end
end

function M:BindEventOnClicked(Obj, Func, ...)
    if not Obj or not Func then
        return
    end
    self.Obj = Obj
    self.Func = Func
    self.Params = {...}
end

function M:OnCellClicked(Speed, isDragSelect)
    if self.Content.Parent.SelectedItem == self then
        return
    end
    if Model:CheckLinearIsNew(self.Content.Id) then
        Model:DecreaseLinearReddotById(self.Content.Id)
        self.New:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    AudioManager(self):PlayUISound(self, "event:/ui/activity/auto_chess_sub_level_btn_click", nil, nil)
    if self.Obj and self.Func then
        self.Func(self.Obj, table.unpack(self.Params), Speed, isDragSelect)
    end
end


function M:OnSelected()
    if self.State == LevelState.UnLock then
        self:PlayAnimation(self.Lock_Change)
    else
        self:StopAnimation(self.Normal)
        self:PlayAnimation(self.Change)
    end
end


function M:OnUnSelected()
    if self.State == LevelState.UnLock then
        self:PlayAnimation(self.Lock_Normal)
    else
        self:PlayAnimation(self.Normal)
    end
end


return M
