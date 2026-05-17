--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Com_TabIcon_P_C
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

--function M:Initialize(Initializer)
--end

--function M:PreConstruct(IsDesignTime)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--    Info = {
--             Text = "任务"   Tab文本
--             TabId = 1, Tab的Id,
---            IconPath = "/Game/UI/UI_PNG/Atlas/Tab/T_Tab_All.T_Tab_All", 图片路径
--             ShowRedDot = 1, 显示红点,
--             IsNew = 1, 显示新图标,
--             ShowRedDotNum = 10, 显示数量红点
--             IsLocked = false,  是否此Tab仍处于锁定状态（true为锁定）
--             LockReasonText = GText("UI_RegionMap_MaxMark"), 未解锁点击提示文本
--           }     

function M:Update(Idx, Info)
    self.Info = Info
    Info.UI = self
    self.Idx = Idx
    self.IsLocked = Info.IsLocked
    if (Info.IconPath) then
        local Icon = LoadObject(Info.IconPath)
        local Material = self.Img_TabIcon:GetDynamicMaterial()
        Material:SetTextureParameterValue("Mask", Icon)
    end
    if(self.Reddot)then
        self:SetReddot(Info.IsNew, Info.ShowRedDot)
    end
    if (self.Reddot_Num) then
        self:SetReddotNum(Info.ShowRedDotNum)
    end
    if (self.IsLocked) then
        -- 当前内容已被锁定
        self:PlayAnimation(self.Lock)
    end
    self.IsOn = Info.IsOn
    if(Info.IsOn)then
        self:PlayAnimation(self.Click,0,1,0,1000)
    else
        self:PlayAnimation(self.Normal,0,1,0,1000)
    end
    self.bClickEnable = true

    if self.Info.BindReddotNode then
        local ReddotNodeName = self.Info.BindReddotNode
        ReddotManager.RemoveListener(ReddotNodeName, self)
        ReddotManager.AddListener(ReddotNodeName, self, function(self, Count, RdType, RdName)
            if Count > 0 then
                if RdType == EReddotType.Normal then
                    self:SetReddot(false, true)
                elseif RdType == EReddotType.New then
                    self:SetReddot(true, false)
                end
            else
                self:SetReddot(false, false)
            end
        end)
    end

end

function M:SetSwitchOn(IsOn, IsNeedPressAnim)
    -- 未解锁的状态点击出个提示
    if (self.IsLocked) then
        local ShowTextContent = self.Info.LockReasonText or "Not Define!!!!"
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, ShowTextContent)
        return
    end
    self.IsOn = IsOn
    if(IsOn) then
        if (IsNeedPressAnim) then
            local function PlayPressAnimFinished()
                self:PlayAnimation(self.Click) 
            end
            self:UnbindAllFromAnimationFinished(self.Press)
            self:BindToAnimationFinished(self.Press, {self, PlayPressAnimFinished})
            self:PlayAnimation(self.Press) 
        else
            self:PlayAnimation(self.Click)  
        end
        if (self.EventSwitchOn) then
            self.EventSwitchOn(self.ObjSwitchOn,self)
        end
    else
        self:StopAllAnimations()
        self:PlayAnimation(self.Normal)
        if (self.EventSwitchOff) then
            self.EventSwitchOff(self.ObjSwitchOff,self)
        end
    end
end

function M:GetTabId()
    if (not self.Info) then
        DebugPrint(ErrorTag, "WBP_Com_TabItem_M_C==:GetTabId error, Info is nil")
        return nil
    end
    return self.Info.TabId
end

function M:GetTabIndex()
    return self.Idx
end

function M:BindEventOnSwitchOn(Obj,Event)
    self.ObjSwitchOn = Obj
    self.EventSwitchOn = Event
end

function M:UnbindEventOnSwitchOn()
    self.ObjSwitchOn = nil
    self.EventSwitchOn = nil
end

function M:BindEventOnSwitchOff(Obj,Event)
    self.ObjSwitchOff = Obj
    self.EventSwitchOff = Event
end

function M:UnbindEventOnSwitchOff()
    self.ObjSwitchOff = nil
    self.EventSwitchOff = nil
end

function M:BindSoundFunc(func,Receiver)
    self.SoundFunc = func
    self.SoundFuncReceiver = Receiver
end

function M:SetClickEnable(bEnable)
    self.bClickEnable = bEnable
end

function M:Btn_Click()
    if (not self.bClickEnable) then
        -- 禁用点击
        return
    end
    if(self.SoundFunc)then
        self.SoundFunc(self.SoundFuncReceiver,self.Idx)
    end
    if(not self.IsOn)then
        self:SetSwitchOn(true)
    end
end

function M:Btn_Press()
    if (self.IsOn or self.IsLocked or not self.bClickEnable) then
        return
    end
    if (self:IsAnimationPlaying(self.Press)) then
        return
    end
    self:UnbindAllFromAnimationFinished(self.Press)
    self:PlayAnimation(self.Press)
end

-- function M:Btn_Hover()
--     --选中或者未解锁的时候不触发Hover动画
--     if (self.IsOn or self.IsLocked) then
--         return
--     end
--     self:PlayAnimation(self.Hover)
-- end

-- function M:Btn_UnHover()
--     --选中或者未解锁的时候不触发UnHover动画
--     if(self.IsOn or self.IsLocked)then
--         return
--     end
--     if (self:IsAnimationPlaying(self.Hover)) then
--         self:StopAnimation(self.Hover)
--     end
--     if (self:IsAnimationPlaying(self.Press)) then
--         self:StopAnimation(self.Press)
--     end
--     -- self:StopAllAnimations()
--     self:PlayAnimation(self.Normal)
-- end

function M:Btn_Release()
    --选中或者未解锁的时候不触发Release动画
    if (self.IsOn or self.IsLocked) then
        return
    end
    if (self:IsAnimationPlaying(self.Press)) then
        self:StopAnimation(self.Press)
    end
    self:PlayAnimation(self.Normal)
end

function M:SetLockInfo(bUnLock)
    self.IsLocked = bUnLock
    if (bUnLock) then
        self:PlayAnimation(self.Normal)
    else
        self:PlayAnimation(self.Lock)
    end
end

function M:GetShowText()
    return self.Info.Text
end

---@param IsNew boolean 是否显示 新 样式的红点
---@param Upgradeable boolean 是否显示 普通 样式的红点
---@param OtherReddot boolean 是否切换成另一样式的红点(灰色)
function M:SetReddot(IsNew,Upgradeable,OtherReddot)
    self.IsNew = IsNew
    self.Upgradeable = Upgradeable
    self.OtherReddot = OtherReddot
    if(IsNew)then
        self.Reddot:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        self.New:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        return
    end
    self.New:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    if(self.Reddot) then
        if(OtherReddot)then
            self.Reddot:SetReddotStyle(1)
            self.Reddot:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        elseif(Upgradeable)then
            self.Reddot:SetReddotStyle(0)
            self.Reddot:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        else
            self.Reddot:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        end
    end
end

---@param RedNum number 红点数量
function M:SetReddotNum(RedNum)
    if (RedNum ~= nil and RedNum > 0) then
        self.Reddot_Num:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Reddot_Num:SetNum(RedNum)
    else
        self.Reddot_Num:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

return M
