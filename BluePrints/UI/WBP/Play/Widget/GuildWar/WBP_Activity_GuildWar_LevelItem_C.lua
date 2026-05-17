--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR shilei
-- @DATE ${date} ${time}
--
require "UnLua"
local RomanNum = Const.RomanNum
---@type WBP_Activity_GuildWar_LevelItem_C
local M = Class({"BluePrints.UI.BP_UIState_C"})
M._components = {
    "BluePrints.UI.WBP.Play.Widget.GuildWar.GuildWarView",
}
function M:Construct()
    M.Super.Construct(self)
    self.IsSelect = false
    self.Text_LvName:SetText(GText("UI_LEVEL_NAME"))
    self.New_Tag:SetVisibility(ESlateVisibility.Collapsed)
    self.Btn_Click.OnClicked:Add(self, self.OnSubCellClicked)
    self.Mobile = CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile"
    self.Text_Unlock:SetText(GText("UI_RaidDungeon_Unlock_Time"))
end

function M:Destruct()
    if self:IsExistTimer(self.UpdateGuildWarTimer) then
        self:RemoveTimer(self.UpdateGuildWarTimer)
    end
end


function M:BindEventOnClicked(Obj, Func, ...)
    if not Obj or not Func then
        return
    end
    self.Obj = Obj
    self.Func = Func
    self.Params = { ... }
end

--聚焦到自身 并且处于手柄端 执行点击
function M:OnFocusReceived(MyGeometry, InFocusEvent)
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        self:OnSubCellClicked()
    end
    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

-- 初始化关卡信息
function M:InitDungeonInfo(DungeonId, Index, IsShowDungeonName, Parent)
    self.DungeonId = DungeonId
    self.Parent = Parent
    local Data = DataMgr.Dungeon[DungeonId]
    if not Data then
        DebugPrint("ZDX_找不到关卡数据:", DungeonId)
        return
    end
    self.Bottom:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    -- 判断是否解锁
    if self:CheckDungeonCondition(DungeonId) then
        self:PlayAnimation(self.Normal)
    else
        -- 标记通用ListCell不可交互，用于禁用ListCell点击相关动效
        self:PlayAnimation(self.Lock)

        if self:IsExistTimer(self.UpdateGuildWarTimer) then
            self:RemoveTimer(self.UpdateGuildWarTimer)
        end

        --Tick更新自身是否解锁
        self.UpdateGuildWarTimer = self:AddTimer(3.0, function()
            self:RefreshBtnState()
            self:ShowTips(false)
            self:RemoveTimer(self.UpdateGuildWarTimer)
        end, true, 0, "UpdateGuildWar_LevelItem", true)
    end

    --- 设置关卡序号图片
    --@todo ZDX_等策划配表
    --是否显示关卡名称
    if IsShowDungeonName then
        self.Title_Level:SetText(GText(Data.DungeonName))
    else
        self.Title_Level:SetText(GText(RomanNum[Index]))
    end

    self.Text_Up:SetText(GText("RaidDungeon_Base_Point_Up"))


    if Data.DungeonLevel then
        self.Text_Lv:SetVisibility(ESlateVisibility.Visible)
        self.Text_Lv:SetText(Data.DungeonLevel)
    else
        self.Text_Lv:SetVisibility(ESlateVisibility.Collapsed)
    end
end

---通用subcell点击响应方法
function M:OnSubCellClicked()
    if self.IsSelect then return end
    AudioManager(self):PlayUISound(self, "event:/ui/activity/gerengonghuizhan_level_btn_click", nil, nil)
    if self:CheckDungeonCondition(self.DungeonId)  then
        if DataMgr.RaidDungeon[self.DungeonId].DifficultyLevel <= 1 then
            self:PlayAnimationForward(self.Click_Normal)
        else
            self:PlayAnimationForward(self.Click)
        end
    end
    if self.Obj and self.Func then
        self.Func(self.Obj, table.unpack(self.Params))
    end
end

--是否显示积分效率提示
function M:IsShowBottom() 
    -- if DataMgr.RaidDungeon[self.DungeonId].DifficultyLevel <= 1 then
    --     self.Bottom:SetVisibility(ESlateVisibility.Collapsed)
    -- else
    --     self.Bottom:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    -- end 
end


function M:SetDifficultyLevel()

end

function M:SetTimeShow()
    self:UpdateTimeCountDown()
    self:AddTimer(1.0, self.UpdateTimeCountDown, false, 3, "GuildWar_LevelItem_UpdateTimeContent")
    self:ShowTips(true)
    self:AddTimer(3.0, function() self:ShowTips(false) end, false, 0, "GuildWar_LevelItemTips_UpdateTimeContent")
end

function M:UpdateTimeCountDown()
    local RaidDungeon = DataMgr.RaidDungeon[self.DungeonId]
    local TargetUnixTime = RaidDungeon.UnlockDate
    local RemainTimeDict, TimeCount = UIUtils.GetLeftTimeStrStyle2(TargetUnixTime)
    self.Time:SetTimeText("", RemainTimeDict)
    self:RefreshBtnState()
end

function M:ShowTips(bShow)
    self.Panel_Tip:SetVisibility(bShow and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed)
end

function M:IsMatching()
    local MatchTimingBar = UIManager(self):GetUIObj("DungeonMatchTimingBar")
    return MatchTimingBar and true
end

function M:RefreshBtnState()
    -- 判断是否解锁
    local bCheck = self:CheckDungeonCondition(self.DungeonId)
    if bCheck then
        if not self.IsSelect then
            --self:StopAllAnimations()
            self:PlayAnimation(self.Normal)
        end
    else
        self:PlayAnimation(self.Lock)
    end
end

function M:OnMouseEnter(MyGeometry, MouseEvent)
    self.IsEnter = true
    if  self.Mobile or self.IsSelect or self:IsPlayingAnimation(self.Click) then
        return
    end
    self:StopAnimation(self.UnHover)  
    self:PlayAnimation(self.Hover)
   
    -- if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad and not self.IsEmpty then
    --     --self.Btn_Goto:SetPCVisibility(false)
    -- end
end

function M:OnMouseLeave(MyGeometry, MouseEvent)
    self.IsEnter = false
    if self.Mobile or self.IsSelect  then --or self:IsPlayingAnimation(self.Click)
        return
    end
    self:StopAnimation(self.Hover)  
    self:PlayAnimation(self.Unhover)
end

AssembleComponents(M)
return M
