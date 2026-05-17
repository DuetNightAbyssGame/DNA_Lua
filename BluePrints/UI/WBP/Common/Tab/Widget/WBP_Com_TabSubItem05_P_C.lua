--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Com_TabSubItem05_P_C
local M = Class("BluePrints.UI.BP_EMUserWidget_C")
local ArmoryUtils = require "BluePrints.UI.WBP.Armory.ArmoryUtils"

--function M:Initialize(Initializer)
--end

--function M:PreConstruct(IsDesignTime)
--end

function M:Construct()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    self.PlatformDeviceName = self.GameInputModeSubsystem:GetCurrentGamepadName()
end

function M:Destruct()
    if self.ReddotName then
        ReddotManager.RemoveListener(self.ReddotName,self)
    end
end

function M:OnListItemObjectSet(Content)
    self.Content = Content
    Content.Widget = self
    self:Update(Content.Idx,Content.Info,self.PlatformDeviceName)
    if (Content.IconPath) then
        self:SetIcon(Content.IconPath)
    end
    self:StopAllAnimations()
    self:FlushAnimations()
    self.IsSelected = Content.IsSelected
    self:SetIsSelected(Content.IsSelected)
    self:SetReddot(Content.IsNew,Content.Upgradeable)
    self.OnAddedToFocusPathEvent = Content.OnAddedToFocusPath
    if Content.TabType==ArmoryUtils.FilesTabType[2]  then
        local ReddotName= table.concat({ArmoryUtils.FilesTabType[2], Content.CharId,Content.Idx}, "_")
        if self.ReddotName then
            ReddotManager.RemoveListener(self.ReddotName,self)
            self.ReddotName=nil
        end
        ReddotManager.AddListenerEx(ReddotName,self, function(self, Count)
            if Count>0 then
                self:SetReddot(true)
            else
                self:SetReddot(false)
            end
        end)
        self.ReddotName=ReddotName
    end
end

function M:SetIcon(IconPath)
    local Icon = LoadObject(IconPath)
    if IsValid(Icon) then
        self.Icon_Tab:SetBrushResourceObject(Icon)
    end
end

function M:SetIsSelected(IsSelected)
    self.IsSelected = IsSelected
    if(IsSelected)then
        self:StopAllAnimations()
        self:PlayAnimation(self.Click)
        self:SetSwitchOn(true)
    else
        self:StopAnimation(self.Click)
        self:PlayAnimation(self.Normal)
        self:SetSwitchOn(false)
    end
end

function M:Update(Idx, Info, PlatformDeviceName)
    self.Info = Info
    Info.UI = self
    self.Idx = Idx
    self.IsLocked = Info.IsLocked
    self.PlatformDeviceName = PlatformDeviceName
    if (self.IsLocked) then
        -- 当前内容已被锁定
        self:PlayAnimation(self.Lock)
    end
    if(self.Text_SubTab)then
        self.Text_SubTab:SetText(Info.Text)
    end

    if (self.Reddot) then
        self:SetReddot(Info.IsNew, Info.ShowRedDot)
    end
    if (self.Reddot_Num) then
        self:SetReddotNum(Info.ShowRedDotNum)
    end
    if (Info.IconPath) then
        local Icon = LoadObject(Info.IconPath)
        local Material = self.Icon_Tab:GetDynamicMaterial()
        if (Material ~= nil) then
            Material:SetTextureParameterValue("Mask", Icon)
        else
            self.Icon_Tab:SetBrushResourceObject(Icon)
        end
    end
end

function M:GetTabId()
    return self.Info.TabId
end

function M:GetTabIndex()
    return self.Idx
end

function M:Btn_Clicked()
    self:StopAnimation(self.Normal)
    if(self.Content.OnClicked)then
        self.Content.OnClicked(self.Content.Parent,self.Content)
    end
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
    else
        self:StopAllAnimations()
        self:PlayAnimation(self.Normal)
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
function M:SetReddot(IsNew, Upgradeable, OtherReddot)
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
    if(self.Info)then
        self.Info.UI = nil
    end
    if self.ReddotName then
        ReddotManager.RemoveListener(self.ReddotName,self)
        self.ReddotName=nil
    end
end

function M:OnAddedToFocusPath(InFocusEvent)
    if(self.OnAddedToFocusPathEvent)then
        local Obj = self.OnAddedToFocusPathEvent.Obj
        local Callback = self.OnAddedToFocusPathEvent.Callback
        local Params = self.OnAddedToFocusPathEvent.Params
        Callback(Obj,Params)
    end
end

return M
