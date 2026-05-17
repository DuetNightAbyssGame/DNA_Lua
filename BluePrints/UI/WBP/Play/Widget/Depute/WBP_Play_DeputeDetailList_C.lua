--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR zhangdongxu
-- @DATE ${date} ${time}
--
require "UnLua"
local RomanNum = Const.RomanNum
---@type WBP_Play_DeputeDetailList_C
local M = Class("BluePrints.UI.BP_UIState_C")
function M:Construct()
    --- TextMap配置
    self.Text_LvName:SetText(GText("UI_LEVEL_NAME"))
    self.New_Tag:SetVisibility(ESlateVisibility.Collapsed)
    self.GuidePoint:SetVisibility(ESlateVisibility.Collapsed)
    self.Bg_List:BindEventOnClicked(self, self.OnSubCellClicked)
    self.Bg_List:TryOverrideSoundFunc(function()
        AudioManager(self):PlayUISound(self, "event:/ui/common/click_mid", nil, nil)
    end)
    EventManager:AddEvent(EventID.TeamMatchTimingStart, self, self.RefreshBtnState)
    EventManager:AddEvent(EventID.TeamMatchTimingEnd, self, self.RefreshBtnState)

    -- self:SetNavigationRuleCustom(EUINavigation.Left, { self, function()
    --     self.Parent:SetEventFocus(0)
    --     -- local Item = UIManager(self):GetUIObj("StyleOfPlay")
    --     -- local SelectLevel = Item:OpenSubUI("DungeonSelect")
    --     -- BottomKeyInfo = {
    --     --     {
    --     --         GamePadInfoList = { {
    --     --             Type = "Img",
    --     --             ImgShortPath = "A",
    --     --             Owner = SelectLevel
    --     --         } },
    --     --         Desc = GText("UI_Controller_CheckDetails"),
    --     --         bLongPress = false,
    --     --     },
    --     --     {
    --     --         GamePadInfoList = { {
    --     --             Type = "Img",
    --     --             ImgShortPath = "B",
    --     --             Owner = SelectLevel
    --     --         } },
    --     --         Desc = GText("UI_BACK"),
    --     --         bLongPress = false,
    --     --     },
    --     -- }
    --     -- Item:UpdateOtherPageTab(BottomKeyInfo)
    --     return nil
    -- end })
end

function M:Destruct()
    EventManager:RemoveEvent(EventID.TeamMatchTimingStart, self)
    EventManager:RemoveEvent(EventID.TeamMatchTimingEnd, self)
end

function M:BindEventOnClicked(Obj, Func, ...)
    if not Obj or not Func then
        return
    end
    self.Obj = Obj
    self.Func = Func
    self.Params = { ... }
end

--聚焦到自身 并且处于手柄端 那么就执行OnCellClicked
function M:OnFocusReceived(MyGeometry, InFocusEvent)
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        if self.Bg_List then
            self.Bg_List:OnCellClicked()
        end
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

    -- 判断是否解锁
    if PageJumpUtils:CheckDungeonCondition(Data.Condition) then
        self:SetVisibility(ESlateVisibility.Visible)
        self.Image_Lock:SetVisibility(ESlateVisibility.Collapsed)
        self.WidgetSwitcher_State:SetActiveWidgetIndex(0)
    else
        -- 标记通用ListCell不可交互，用于禁用ListCell点击相关动效
        self.Bg_List.IsCantInteractable = true
        self.WidgetSwitcher_State:SetActiveWidgetIndex(1)
        self:PlayAnimation(self.Forbidden)
    end

    --- 设置关卡序号图片
    --@todo ZDX_等策划配表
    --是否显示关卡名称
    if IsShowDungeonName then
        self.Title_Level:SetText(GText(Data.DungeonName))
    else
        self.Title_Level:SetText(GText(RomanNum[Index]))
    end


    if Data.DungeonLevel then
        self.Text_Lv:SetVisibility(ESlateVisibility.Visible)
        self.Text_Lv:SetText(Data.DungeonLevel)
    else
        self.Text_Lv:SetVisibility(ESlateVisibility.Collapsed)
    end
end

---通用subcell点击响应方法
function M:OnSubCellClicked()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return false
    end

    if self:IsMatching() then
        return false
    end

    if PageJumpUtils:CheckDungeonCondition(DataMgr.Dungeon[self.DungeonId].Condition, true) then
        self:PlayAnimation(self.Select)
        if self.Obj and self.Func then
            self.Func(self.Obj, table.unpack(self.Params))
        end
    end
end

function M:IsMatching()
    local MatchTimingBar = UIManager(self):GetUIObj("DungeonMatchTimingBar")
    return MatchTimingBar and true
end

function M:RefreshBtnState(bIsMatching)
    if bIsMatching == nil then
        bIsMatching = self:IsMatching()
    end

    -- 判断是否解锁
    local Data = DataMgr.Dungeon[self.DungeonId]
    if PageJumpUtils:CheckDungeonCondition(Data.Condition) then
        if bIsMatching then
            self.Bg_List.IsCantInteractable = true
        else
            self.Bg_List.IsCantInteractable = false
        end

        if not self.Bg_List.IsSelect then
            self:StopAllAnimations()

            self:PlayAnimation(bIsMatching and self.Forbidden or self.Normal)
            local InnerBg = self.Bg_List
            if InnerBg then
                InnerBg:PlayAnimation(bIsMatching and InnerBg.Forbidden or InnerBg.Normal)
            end
        end

        self:SetVisibility(ESlateVisibility.Visible)
        self.WidgetSwitcher_State:SetActiveWidgetIndex(0)
        self.Image_Lock:SetVisibility(ESlateVisibility.Collapsed)
    else
        -- 标记通用ListCell不可交互，用于禁用ListCell点击相关动效
        self.Bg_List.IsCantInteractable = true
        self.WidgetSwitcher_State:SetActiveWidgetIndex(1)
        self.Image_Lock:SetVisibility(ESlateVisibility.Visible)
        self:PlayAnimation(self.Forbidden)
    end
end


return M
