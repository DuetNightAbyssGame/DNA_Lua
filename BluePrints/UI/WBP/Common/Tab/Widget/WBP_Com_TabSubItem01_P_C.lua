--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type Common_Toggle_TabItem_PC_C
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

--function M:Initialize(Initializer)
--end

--function M:PreConstruct(IsDesignTime)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:Update(Idx, Info, PlatformDeviceName)
    self.Info = Info
    Info.UI = self
    self.Idx = Idx
    self.IsLocked = Info.IsLocked
    self.PlatformDeviceName = PlatformDeviceName
    if Info.IconPath then
        if self.Img_Icon then
            self.Img_Icon:GetDynamicMaterial():SetTextureParameterValue("Mask", LoadObject(Info.IconPath))
        end
    end
    if (self.IsLocked) then
        -- 当前内容已被锁定
        self:PlayAnimation(self.Lock)
    end
    self.Text_SubTab:SetText(Info.Text)
    if (self.Reddot) then
        self:SetReddot(Info.IsNew, Info.ShowRedDot)
    end
    if (self.Reddot_Num) then
        self:SetReddotNum(Info.ShowRedDotNum)
        if (Info.RedDotTreeName) then
            self:AddReddotListener(Info.RedDotTreeName)
        end
    end
    if self.Info and self.Info.TipsData then
        local TipsData = self.Info.TipsData

        if TipsData.TipsName then
            self.Text_DontCost:SetText(TipsData.TipsName)
        end

        if TipsData.Icon then
            self.Common_Item_Icon.Img_Icon:SetBrushResourceObject(LoadObject(TipsData.Icon))
        end

        if self.DontCost_In then
            self:PlayAnimation(self.DontCost_In)
        end
    end
end

function M:AddReddotListener(ReddotTreeName)
    -- 添加红点树监听
    ReddotManager.AddListener(ReddotTreeName, self, function(self,Count)
        local ReddotType = DataMgr.ReddotNode[ReddotTreeName].Type
        local IsNew = ReddotType == 1 and Count>0
        local Upgradeable = ReddotType == 0 and Count>0
        self:SetReddot(IsNew, Upgradeable)
    end)
end

function M:RemoveReddotListener(ReddotTreeName)
    if (ReddotTreeName == nil) then
        return
    end
    -- 移除红点树监听
    ReddotManager.RemoveListener(ReddotTreeName, self)
end

function M:SetFitSize(NewSize)
    if (self.Root) then
        self.Root:SetWidthOverride(NewSize.X)
        self.Root:SetHeightOverride(NewSize.Y)
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

function M:Btn_Clicked()
    if(self.SoundFunc)then
        self.SoundFunc(self.SoundFuncReceiver)
    end
    --再次点击不可取消选中
    if (not self.IsOn) then
        self:SetSwitchOn(true)
    end
end

function M:Btn_Press()
    if (self.IsOn or self.IsLocked) then
        --选中的时候再次按下
        return
    end
    if (self:IsAnimationPlaying(self.Press)) then
        return
    end
    self:UnbindAllFromAnimationFinished(self.Press)
    self:PlayAnimation(self.Press) 
end

function M:Btn_Hover()
    -- 手机端不触发
    if (self.PlatformDeviceName == "Mobile") then
        return
    end
    --选中的时候不触发Hover动画
    if (self.IsOn or self.IsLocked) then
        return
    end
    if(self.HoverSoundFunc)then
        self.HoverSoundFunc(self.SoundFuncReceiver,self.Idx)
    end
    self:PlayAnimation(self.Hover) 
end

function M:Btn_UnHover()
    -- 手机端不触发
    if (self.PlatformDeviceName == "Mobile") then
        return
    end
    --选中的时候不触发UnHover动画
    if (self.IsOn or self.IsLocked) then
        return
    end
    if (self:IsAnimationPlaying(self.Hover)) then
        self:StopAnimation(self.Hover)
    end
    -- if (self:IsAnimationPlaying(self.Press)) then
    --     self:StopAnimation(self.Press)
    -- end
    self:PlayAnimation(self.UnHover) 
end

function M:SetSwitchOn(IsOn, IsNeedPressAnim)
    -- 未解锁的状态点击出个提示
    if (self.IsLocked) then
        local ShowTextContent = self.Info.LockReasonText or "Not Define!!!!"
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, ShowTextContent)
        return
    end

    self.IsOn = IsOn
    if (IsOn) then
        -- self:StopAllAnimations()
        if (self:IsAnimationPlaying(self.UnHover)) then
            self:StopAnimation(self.UnHover)
        end
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
        if self.EventSwitchOn then
            self.EventSwitchOn(self.ObjSwitchOn, self)
        end
        -- if self.Info and self.Info.TipsData then
        --     self:PlayAnimation(self.DontCost_In)
        -- end
    else
        self:StopAllAnimations()
        self:PlayAnimation(self.Normal)
        -- if self.Info and self.Info.TipsData then
        --     self:PlayAnimation(self.DontCost_Out)
        -- end
        if(self.EventSwitchOff)then
            self.EventSwitchOff(self.ObjSwitchOff, self)
        end
    end
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

function M:BindHoverSoundFunc(func,Receiver)
    self.HoverSoundFunc = func
    self.SoundFuncReceiver = Receiver
end

function M:SetLockInfo(bUnLock)
    self.IsLocked = not bUnLock
    if (bUnLock) then
        self:PlayAnimation(self.Normal)
    else
        self:PlayAnimation(self.Lock)
    end
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

    if (self.Reddot) then
        if (OtherReddot) then
            self.Reddot:SetReddotStyle(1)
            self.Reddot:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        elseif (Upgradeable) then
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

function M:Destruct()
    if (self.Info) then
        self:RemoveReddotListener(self.Info.RedDotTreeName)
        self.Info.UI = nil
    end
end

return M
