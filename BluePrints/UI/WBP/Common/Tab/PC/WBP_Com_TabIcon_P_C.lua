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
--             IconPath = "/Game/UI/UI_PNG/Atlas/Tab/T_Tab_All.T_Tab_All", 图片路径
--             ShowRedDot = 1, 显示红点,
--             IsNew = 1, 显示新图标,
--             ShowRedDotNum = 10, 显示数量红点
--             IsLocked = false,  是否此Tab仍处于锁定状态（true为锁定，默认不锁定）
--             IsForbidden = false,  是否此Tab处于禁用状态（true为禁用，默认不禁用）
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
    self.Text_Name:SetText(Info.Text)
    if (self.IsLocked) then
        -- 当前内容已锁定
        self:PlayAnimation(self.Lock)
    end
    if (self.Reddot) then
        self:SetReddot(Info.IsNew, Info.ShowRedDot)
    end
    if (self.Reddot_Num) then
        self:SetReddotNum(Info.ShowRedDotNum)
    end
    self.bClickEnable = not Info.IsForbidden
    if (not self.bClickEnable) then
        -- 当前内容已禁用
        self:PlayAnimation(self.Forbidden)
    end
    self.IsOn = Info.IsOn
    if(Info.IsOn)then
        if (self:IsAnimationPlaying(self.UnHover)) then
            self:StopAnimation(self.UnHover)
        end
        self:PlayAnimation(self.Click,0,1,0,1000)
    else
        self:PlayAnimation(self.Normal,0,1,0,1000)
    end
    local CanvasSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Img_TabIcon)
    self.ItemSize = CanvasSlot:GetSize()

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

function M:HideTextName(bHide)
    if (bHide) then
        -- if (self:IsAnimationPlaying(self.Panel_Name_In)) then
        --     self:StopAnimation(self.Panel_Name_In)
        -- end
        -- self:PlayAnimation(self.Panel_Name_Out)
        self.Panel_Name:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    else
        -- if (self:IsAnimationPlaying(self.Panel_Name_Out)) then
        --     self:StopAnimation(self.Panel_Name_Out)
        -- end
        self.Panel_Name:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        self:PlayAnimation(self.Panel_Name_In)
    end
end

function M:GetTabId()
    return self.Info.TabId
end

function M:GetTabIndex()
    return self.Idx
end

function M:SetDisturbIcon(bNotDisturb)
    RunAsyncTask(self, "SetDisturbIconTask", function(CoroutineObj)
        if bNotDisturb then
            if not self.DisturbUI then
                self.DisturbUI = UIManager():CreateWidgetAsync(nil, CoroutineObj, 
                    '/Game/UI/WBP/Chat/Widget/WBP_Chat_DontDisturb.WBP_Chat_DontDisturb', false)
                self.Group_ChatDontDisturb:AddChild(self.DisturbUI)
            end
            self.Group_ChatDontDisturb:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        else
            self.Group_ChatDontDisturb:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
    end)
end

function M:Update_LineEffect(InGeometry, MouseEvent)
    if (self.IsOn or self.IsLocked or not self.bClickEnable) then
        --选中或者未解锁或者禁用态的时候不需要触发
        return
    end
    -- 更新一下VxLine效果
    local ScreenSpacePosition = UE4.UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(MouseEvent)
    local Scale = UE4.UWidgetLayoutLibrary.GetViewportScale(self)
    local thisPos = UE4.USlateBlueprintLibrary.AbsoluteToLocal(InGeometry, ScreenSpacePosition) * Scale
    local halfSizeX, MatFactor = self.ItemSize.X * 0.5, 0
    if (thisPos.X < halfSizeX) then
        -- 在左边
        MatFactor = math.max(0, 0.4 - thisPos.X / halfSizeX * 0.4)
    else
        MatFactor = math.max(-0.4, -0.4 * (thisPos.X - halfSizeX) / halfSizeX )
    end
    local VXLineMat = self.VX_Line:GetDynamicMaterial()
    VXLineMat:SetScalarParameterValue("Mask_U_offset", MatFactor)
    -- local VXLineCopyMat = self.VX_Line_Copy:GetDynamicMaterial()
    -- VXLineCopyMat:SetScalarParameterValue("Mask_U_offset", MatFactor)
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
                -- self.Panel_Name:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
                self:PlayAnimation(self.Click) 
            end
            self:UnbindAllFromAnimationFinished(self.Press)
            self:BindToAnimationFinished(self.Press, {self, PlayPressAnimFinished})
            self:HideTextName(false)
            self:PlayAnimation(self.Press) 
        else
            self:PlayAnimation(self.Click)  
        end
        if(self.EventSwitchOn)then
            self.EventSwitchOn(self.ObjSwitchOn,self)
        end
    else
        self:StopAllAnimations()
        self:PlayAnimation(self.Normal)
        if(self.EventSwitchOff)then
            self.EventSwitchOff(self.ObjSwitchOff,self)
        end
    end
end

function M:BindEventOnHoverOnOrOff(Obj,Event)
    self.ObjHoverOnOrOff = Obj
    self.EventHoverOnOrOff = Event
end

function M:UnbindEventOnHoverOnOrOff()
    self.ObjHoverOnOrOff = nil
    self.EventHoverOnOrOff = nil
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

function M:SetClickEnable(bEnable)
    self.bClickEnable = bEnable
end

function M:SetLockInfo(bUnLock)
    self.IsLocked = bUnLock
    if (bUnLock) then
        self:PlayAnimation(self.Normal)
    else
        self:PlayAnimation(self.Lock)
    end
end

function M:IsTabLocked()
    return self.IsLocked
end

function M:GetIsCanSelect()
    return self.bClickEnable and not self.IsLocked
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
        self:SetSwitchOn(true, false)
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

function M:Btn_Hover()
    --选中或者未解锁的时候不触发Hover动画
    if (self.IsOn or self.IsLocked or not self.bClickEnable) then
        return
    end
    if(self.HoverSoundFunc)then
        self.HoverSoundFunc(self.SoundFuncReceiver,self.Idx)
    end
    self:PlayAnimation(self.Hover)
    self:HideTextName(false) 
    if(self.EventHoverOnOrOff)then
        self.EventHoverOnOrOff(self.ObjHoverOnOrOff, self, true)
    end
end

function M:Btn_UnHover()
    --选中或者未解锁的时候不触发UnHover动画
    if(self.IsOn or self.IsLocked or not self.bClickEnable)then
        return
    end
    if (self:IsAnimationPlaying(self.Hover)) then
        self:StopAnimation(self.Hover)
    end
    -- if (self:IsAnimationPlaying(self.Press)) then
    --     self:StopAnimation(self.Press)
    -- end
    -- self:StopAllAnimations()
    self:PlayAnimation(self.UnHover)
    self:HideTextName(true) 
    if(self.EventHoverOnOrOff)then
        self.EventHoverOnOrOff(self.ObjHoverOnOrOff, self, false)
    end
end

---@param IsNew boolean 是否显示 新 样式的红点
---@param Upgradeable boolean 是否显示 普通 样式的红点
---@param OtherReddot boolean 是否切换成另一样式的红点(灰色)
function M:SetReddot(IsNew,Upgradeable,OtherReddot)
    self.IsNew = IsNew
    self.Upgradeable = Upgradeable
    self.OtherReddot = OtherReddot

    if Upgradeable then
        self.New:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        if self.Reddot then
            self.Reddot:SetReddotStyle(0)
            self.Reddot:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        end
        return
    end

    if IsNew then
        if self.Reddot then
            self.Reddot:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        end
        self.New:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        return
    end

    if OtherReddot then
        self.New:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        if self.Reddot then
            self.Reddot:SetReddotStyle(1)
            self.Reddot:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        end
        return
    end

    self.New:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    if self.Reddot then
        self.Reddot:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end
end

---@param RedNum number 红点数量
function M:SetReddotNum(RedNum)
    if (RedNum ~= nil) then
        RedNum = tostring(RedNum)
        if not string.isempty(RedNum) and RedNum ~= "0" then
            self.Reddot_Num:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            self.Reddot_Num:SetNum(RedNum)
            return
        end
    end
    self.Reddot_Num:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

return M
