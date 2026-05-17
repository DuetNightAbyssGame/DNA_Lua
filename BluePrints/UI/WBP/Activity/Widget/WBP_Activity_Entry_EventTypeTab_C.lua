--
-- DESCRIPTION
--
-- @COMPANY ** 活动左下方限时/常驻切换开关
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local ActivityReddotHelper = require "BluePrints.UI.WBP.Activity.ActivityReddotHelper"
local ActivityUtils = require "Blueprints.UI.WBP.Activity.ActivityUtils"

---@type WBP_Activity_Entry_EventTypeTab_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C","BluePrints.Common.TimerMgr","BluePrints.Common.DelayFrameComponent"})

--function M:Initialize(Initializer)
--end

--function M:PreConstruct(IsDesignTime)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:Destruct()
    ReddotManager.RemoveAllListener(self.LimitNodeName)
    ReddotManager.RemoveAllListener(self.NormalNodeName)
    self:CleanTimer()
    self:UnbindAllFromAnimationFinished(self.UnHover)
    self:UnBindButtonPerformances()
    self:StopAllAnimations()
    self.Info = nil
    self.ParentWidget = nil
end

function M:Init(Info)
    self.Info = Info
    -- 所属的对象 @BluePrints.UI.WBP.Activity.WBP_Activity_EntryBase_C
    self.ParentWidget = Info.OwnerPanel
    self.bLimitTime = true
    self:BindButtonPerformances()
    self.Key_Left:CreateGamepadKey(UIConst.GamePadImgKey.DPadLeft)
    self.Key_Right:CreateGamepadKey(UIConst.GamePadImgKey.DPadRight)
    self.Text_TabLimitTime:SetText(GText("MAIN_UI_TransientGameEvent"))
    self.Text_TabNormal:SetText(GText("MAIN_UI_PermanentGameEvent"))
    self.LimitNodeName = "LeftEventTypeTab"
    self.NormalNodeName = "RightEventTypeTab"
    self.bSwitchCooldown = false
end

function M:BindButtonPerformances()
    self.Btn_Click.OnClicked:Add(self, self.OnClicked)
    self.Btn_Click.OnPressed:Add(self, self.OnPressed)
    --self.Btn_Click.OnReleased:Add(self, self.OnReleased)
    self.Btn_Click.OnHovered:Add(self, self.OnHovered)
    self.Btn_Click.OnUnhovered:Add(self, self.OnUnhovered)
end

function M:UnBindButtonPerformances()
    self.Btn_Click.OnClicked:Clear()
    self.Btn_Click.OnPressed:Clear()
    --self.Btn_Click.OnReleased:Clear()
    self.Btn_Click.OnHovered:Clear()
    self.Btn_Click.OnUnhovered:Clear()
end

function M:OnClicked()
    self:PlayAnimation(self.Click)
    self:SwitchTab()
end

function M:OnPressed()
    AudioManager(self):PlayUISound(self, "event:/ui/activity/type_btn_click", nil, nil)
    if self:IsAnimationPlaying(self.Switch) then
        return
    end
    self:PlayAnimation(self.Press)
end

function M:OnHovered()
    if self.bBtnClickHovered then
        return
    end
    self.bBtnClickHovered = true
    self:StopAnimation(self.UnHover)
    self:PlayAnimation(self.Hover)
end

function M:OnUnhovered()
    if not self.bBtnClickHovered then
        return
    end
    self.bBtnClickHovered = false
    self:StopAnimation(self.Hover)
    self:BindToAnimationFinished(self.UnHover, {self, function()
            self:UnbindAllFromAnimationFinished(self.UnHover)
            self:PlayAnimation(self.Normal)
        end})
    self:PlayAnimation(self.UnHover)
end

--@param TargetTabName String
function M:SwitchTab(TargetTabName)
    if self:IsForbidden() then return end
    if self:IsAnimationPlaying(self.Switch) then
        DebugPrint("lgc@ 动画Switch正在播放,切换失败")
        return
    end
    if not self.bSwitchCooldown then
        self.bSwitchCooldown = true
        self:AddTimer(0.3, function()
            self.bSwitchCooldown = false
        end, false, 0, nil, true)
    else
        DebugPrint("lgc@ 切换冷却中,切换失败")
        return
    end

    if TargetTabName == "LimitTime" and self.bLimitTime then
        return
    elseif TargetTabName == "Normal" and (not self.bLimitTime) then
        return
    end
    if self.bLimitTime then --切换至常驻
        self.bLimitTime = false
    else                    --切换至限时
        self.bLimitTime = true
    end
    self.ParentWidget:GenerateAllDataInfo()
    if self.bLimitTime then
        self:PlayAnimation(self.Switch, 0, 1, EUMGSequencePlayMode.Reverse, 1.0)
        self.bReverse = true
    else
        self:PlayAnimation(self.Switch)
        self.bReverse = false
    end
    self:BindToAnimationFinished(self.Switch, {self, function()
        self:UnbindAllFromAnimationFinished(self.Switch)
        if self.bBtnClickHovered then
            self:PlayAnimation(self.Hover)
        end
        if self.bReverse then
            self:PlayAnimation(self.Switch, 0.99, 1, EUMGSequencePlayMode.Reverse, 1.0)
        else
            self:PlayAnimation(self.Switch, 0.99, 1, EUMGSequencePlayMode.Forward, 1.0)
        end
    end})
end

function M:ResetPos()
    self:StopAllAnimations()
    if self:IsLimitTime() then
        self:PlayAnimation(self.Switch, 0.8, 1, EUMGSequencePlayMode.Reverse, 1.0)
    else
        self:PlayAnimation(self.Switch, 0, 1, EUMGSequencePlayMode.Forward, 1.0)
    end
end

function M:InitReddotTreeInfo()
    if self:IsForbidden() or not self.ParentWidget or not self.ParentWidget.SubTabItems then return end
    local NormalChildNodes = {}
    local LimitTimeChildNodes = {}
    for _, value in pairs(self.ParentWidget.SubTabItems) do
        local ChildNodeName = ActivityReddotHelper.GetEventTabNodeName(value.TabId)
        if value.bLimit and value.bLimit == true and ChildNodeName then
            LimitTimeChildNodes[ChildNodeName] = 1
        elseif value.bLimit and value.bLimit == false and ChildNodeName then
            NormalChildNodes[ChildNodeName] = 1
        end
        ::continue1::
    end
    ReddotManager.AddListener(self.NormalNodeName,self,function(self, Count)
        self:AddDelayFrameFunc(function()
            self:UpdateEventTypeTabReddot()
        end, 1)
    end,NormalChildNodes,true)
    ReddotManager.AddListener(self.LimitNodeName,self,function(self, Count)
        self:AddDelayFrameFunc(function()
            self:UpdateEventTypeTabReddot()
        end, 2)
    end,LimitTimeChildNodes,true)
end

--@public
function M:IsLimitTime()
    return self.bLimitTime
end

--@public
function M:SetIsLimitTime(InIsLimitTime)
    self.bLimitTime = InIsLimitTime
end

--@public
function M:IsForbidden()
    return self.bForbidden or false
end

--@public
function M:SetForbidden(IsForbidden)
    self.bForbidden = IsForbidden
end

function M:GetIsShowReddotAndNew(Content)
    local bShowReddot,bShowNew = false,false
    if not Content then
        return bShowReddot,bShowNew
    end
    if Content.ShowRedDot then
        bShowReddot = true
    end
    if Content.IsNew then
        bShowNew = true
    end
    if not Content.TabId then --空态
        return bShowReddot,bShowNew
    end
    local NodeName = ActivityReddotHelper.GetEventTabNodeName(Content.TabId)
    local ReddotNode = ReddotManager.GetTreeNode(NodeName)
    if ReddotNode and ReddotNode.Count and ReddotNode.Count > 0 then
        if ReddotNode.ReddotType == UIConst.RedDotType.CommonRedDot then
            bShowReddot = true
        elseif ReddotNode.ReddotType == UIConst.RedDotType.NewRedDot then
            bShowNew = true
        end
    end
    return bShowReddot,bShowNew
end

function M:UpdateEventTypeTabReddot(bForceExec)
    if self:IsForbidden() then return end
    if self.bCoolDown and (not bForceExec) then
        self.PendingExec = true
        return
    end
    self.bCoolDown = true
    self:AddTimer(0.1,function()
        if not self then return end
        self.bCoolDown = false
        if self.PendingExec then
            self.PendingExec = false
            self:UpdateEventTypeTabReddot()
        end
    end,false,0,nil,true)
    if not self.ParentWidget then return end
    local TargetListTab = self.ParentWidget.List_Tab
    if not TargetListTab then return end
    local AllItems = TargetListTab:GetListItems():ToTable()
    local LimitItems, NormalItems = {}, {}
    for _, Item in pairs(AllItems) do
        if Item.bLimit ~= nil and Item.bLimit == true then
            LimitItems[Item.TabId] = Item
        elseif Item.bLimit ~= nil and Item.bLimit == false then
            NormalItems[Item.TabId] = Item
        end
    end
    local UpdateReddotAndNew = function(TargetItems,TargetReddot,TargetNew)
        local bShowReddot = false
        local bShowNew = false
        for _, Content in pairs(TargetItems) do
            local bSingleShowReddot = false
            local bSingleShowNew = false
            bSingleShowReddot,bSingleShowNew = self:GetIsShowReddotAndNew(Content)
            if bSingleShowReddot then
                bShowReddot = true
            end
            if bSingleShowNew then
                bShowNew = true
            end
        end
        if bShowReddot then
            TargetReddot:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        else
            TargetReddot:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
        if (not bShowReddot) and bShowNew then
            TargetNew:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        else
            TargetNew:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
    end
    local TargetReddot = self.Reddot01
    local TargetNew = self.New01
    if self.bLimitTime or bForceExec then
        UpdateReddotAndNew(LimitItems,TargetReddot,TargetNew)
    end
    if (not self.bLimitTime) or bForceExec then
        TargetReddot = self.Reddot02
        TargetNew = self.New02
        UpdateReddotAndNew(NormalItems,TargetReddot,TargetNew)
    end
end

function M:UpdateUIStyleInPlatform(IsUseGamePad)
    --处理手柄提示
    if (not self.Key_Left) or (not self.Key_Right) then return end
    if IsUseGamePad then
        self.Key_Left:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.Key_Right:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
        self.Key_Left:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Key_Right:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    self:PlayAnimation(self.Normal)
end

-----------------------------------------------输入事件相关------------------------------------------------
-- function M:Handle_KeyEventOnPC(InKeyName)
--     local IsEventHandled = true
--     -- 处理键盘相关的交互事件

--     return IsEventHandled
-- end

function M:Handle_KeyEventOnGamePad(InKeyName)
    local IsEventHandled = false
    -- 处理手柄相关的交互事件
    if (InKeyName == "Gamepad_LeftShoulder") then
        if not self.bLimitTime then
            self:SwitchTab("LimitTime")
        end
        self:PlayAnimation(self.Normal)
        IsEventHandled = true
    elseif (InKeyName == "Gamepad_RightShoulder") then
        if self.bLimitTime then
            self:SwitchTab("Normal")
        end
        self:PlayAnimation(self.Normal)
        IsEventHandled = true
    end
    return IsEventHandled
end

return M
