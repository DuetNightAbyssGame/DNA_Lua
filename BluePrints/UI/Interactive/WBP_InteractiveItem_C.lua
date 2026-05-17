--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

---@class WBP_InteractiveItem_C : WBP_Battle_InteractiveItem_C
local WBP_InteractiveItem_C = Class({"BluePrints.Common.TimerMgr","BluePrints.UI.BP_EMUserWidget_C"})

WBP_InteractiveItem_C.State =
{
    Normal = 0,
    Press = 1,
    Hover = 2
}

local InteractiveTypeEnum = {
	Default = 0,
	Quest = 1,
	PickUpAll = 3,
}

local QuestInteractiveTypeEnum = {
    CommonQuest = 1,
    SpecialQuest = 2,
}
local LongPressAnimationTime = 1

function WBP_InteractiveItem_C:Initialize(Initializer)
    --self.Overridden.Initialize(self, Initializer)

    ---@type BP_InteractiveBaseComponent_C
    self.InteractiveInfo = nil
    self.CurrentInputDevice = {"KeyboardKey","MouseButton"}
    self.PlayingAnimations = {}
end

--function WBP_InteractiveItem_C:PreConstruct(IsDesignTime)
--end

function WBP_InteractiveItem_C:Construct()
    if rawget(self, "bConstruct") then
        return
    end
    rawset(self, "bConstruct", true)
    rawset(self, "bOnRemoved", false)
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        self.Key:SetVisibility(ESlateVisibility.Hidden)
    else
        self.Key:SetVisibility(ESlateVisibility.Collapsed)
    end

    self.Button_Area.OnPressed:Add(self, self.OnInteractiveItemPressed)
    self.Button_Area.OnReleased:Add(self, self.OnInteractiveItemReleased)
    self.Button_Area.OnClicked:Add(self, self.OnInteractiveItemClicked)
    self.Button_Area.OnHovered:Add(self, self.OnInteractiveItemHovered)
    self.Button_Area.OnUnhovered:Add(self, self.OnInteractiveItemUnhovered)

    -- local Key, _ = self:GetKeyName("Interactive")
    self.Key_Interactive:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Text",
                Text = CommonUtils:GetActionMappingKeyName("Interactive"),
            }
        },
    })
    self.Tag_New:SetVisibility(ESlateVisibility.Collapsed)
    self.State = WBP_InteractiveItem_C.State.Normal
end

function WBP_InteractiveItem_C:GetAnimationNameByAnimation(Ainmation)
    if not rawget(self, "AnimationNames") then
        local AnimationNames = {
            [self.In] = "In",
            [self.Out] = "Out",
            [self.Normal] = "Normal",
            [self.Hover] = "Hover",
            [self.UnHover] = "UnHover",
            [self.Press] = "Press",
            [self.Click] = "Click",
            [self.Forbidden_Normal] = "Forbidden_Normal",
            [self.Forbidden_Hover] = "Forbidden_Hover",
            [self.Forbidden_UnHover] = "Forbidden_UnHover",
            [self.Forbidden_Press] = "Forbidden_Press",
            [self.Forbidden_Click] = "Forbidden_Click",
            [self.Lock_Normal] = "Lock_Normal",
            [self.Lock_Hover] = "Lock_Hover",
            [self.Lock_UnHover] = "Lock_UnHover",
            [self.Lock_Press] = "Lock_Press",
            [self.Lock_Click] = "Lock_Click",
            [self.UnLock] = "UnLock",
            [self.LongPress_Normal] = "LongPress_Normal",
            [self.LongPress] = "LongPress",
            [self.Loop] = "Loop"
        }
        rawset(self, "AnimationNames", AnimationNames)
    end
    return self.AnimationNames[Ainmation]
end

--function WBP_InteractiveItem_C:Tick(MyGeometry, InDeltaTime)
--end

function WBP_InteractiveItem_C:InitWidgetInfoInGamePad(IsGamePad)
    if not IsGamePad or self.GamePadKeyInited then
        return
    end
    local GamepadKeys = UIUtils.GetIconListByActionName("Interactive")
    -- 目前蓝图结构不支持手柄组合键形式 若为多个，直接取第一个
    local ImgShortPath = GamepadKeys[1]
    self.Key_Interactive_GamePad:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = ImgShortPath,
                bSpecialLongPress = self.InteractiveInfo:IsLastingInteract(),
            },
        },
    })
    rawset(self, "GamePadKeyInited", true)
end

function WBP_InteractiveItem_C:Destruct()
    if rawget(self, "bSkipDestruct") then
        return
    end
    -- self.InteractiveInfo = nil
    rawset(self, "UseItemIcon", false)
    rawset(self, "bOnRemoved", false)
    rawset(self, "bPickAll", nil)
    rawset(self, "bConstruct", nil)
    rawset(self, "LoadResourceID", nil)
    rawset(self, "IsPickUpAllItem", nil)
    rawset(self, "InteractivePriority", nil)
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        self.Key:SetVisibility(ESlateVisibility.Hidden)
    else
        self.Key:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function WBP_InteractiveItem_C:InitPickAllInfoInGamePad()
    local GamepadKeys = UIUtils.GetIconListByActionName("Interactive")
    -- 目前蓝图结构不支持手柄组合键形式 若为多个，直接取第一个
    local ImgShortPath = GamepadKeys[1]
    self.Key_Interactive_GamePad:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = ImgShortPath,
            },
        },
    })
end

---@param InteractiveItemInfo BP_InteractiveBaseComponent_C
function WBP_InteractiveItem_C:InitInteractiveInfo(InteractiveInfo)
    if self.InteractiveInfo == InteractiveInfo then
        return
    end
    assert(InteractiveInfo)
    self.InteractiveInfo = InteractiveInfo
    self.ShouldHighlight = InteractiveInfo:GetShouldHighlight()
    self:UpdateIcon()
    self:SetInteractiveText(InteractiveInfo:GetInteractiveName(), self:GetTextColor())
    local InteractiveCondition = InteractiveInfo:GetInteractiveCondition()
    if InteractiveCondition then
        self.Text_ExploreKeyNum:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Text_ExploreKeyNum:SetText(InteractiveCondition)
    else
        self.Text_ExploreKeyNum:SetVisibility(ESlateVisibility.Collapsed)
    end
    self:UpdateStars()
    self:PlayAnimation(self["in"], 0, 1, UE4.EUMGSequencePlayMode.Forward, 1, true)
    self:PlayAnimation(self:GetAnimation("Normal"))
    self:InitLongPressState()
    self:UpdateCostItemDetail()
    self:InitOwnerUuId()
    self.ListPriority = InteractiveInfo.ListPriority or 1
end

function WBP_InteractiveItem_C:InitLongPressState()
    if not self.InteractiveInfo then
        return
    end
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
    if not Player then return end 
    if self.InteractiveInfo:IsForbidden(Player) then
        return
    end
    -- 是否为长按交互
    if self.InteractiveInfo:IsLastingInteract() then
        -- 长按交互类型是否为 进度类型 (长按交互时间为不为0 则为进度类型)
        if self.InteractiveInfo:GetNeedLongPressTime() ~= 0 then
            local PressedPercent = self.InteractiveInfo:GetLongPressedPercent()
            local ReduceTime = self.InteractiveInfo:GetReduceTime()
            -- ScreenPrint("CurrentPressedTime = " .. tostring(PressedPercent).."  ReduceTime: "..tostring(ReduceTime))
            -- ReduceTime 若 <= 0 则说明为保存交互进度的交互选项
            local AnimationSpeed = ReduceTime <= 0 and 0 or (LongPressAnimationTime / ReduceTime)
            self:PlayAnimation(self:GetAnimation("LongPress"), 1 - PressedPercent, 1, UE4.EUMGSequencePlayMode.Reverse, AnimationSpeed)
            -- self:PauseAnimation(self.LongPress)
            self.Text_RemainTime:SetRenderOpacity(0)
        end
    end
end

function WBP_InteractiveItem_C:InitPickAllInfo()
    self.InteractiveInfo = nil
    rawset(self, "IsPickUpAllItem", true)
    self:PlayAnimation(self["in"], 0, 1, UE4.EUMGSequencePlayMode.Forward, 1, true)
    self:PlayAnimation(self:GetAnimation("Normal"))
    self:SetInteractiveText(GText("UI_Interaction_Drop_All"), self:GetTextColor())
    local Path = "/Game/UI/Texture/Dynamic/Atlas/Interactive/T_Interactive_Pick"
    rawset(self, "LoadResourceID", nil)
    local Handle = UE.UResourceLibrary.LoadObjectAsyncWithId(self, Path, {self,WBP_InteractiveItem_C.OnIconLoadFinish})
    if Handle then
        rawset(self, "LoadResourceID", Handle.ResourceID)
    end

    self:InitPickAllInfoInGamePad()
end

function WBP_InteractiveItem_C:InitOwnerUuId()
    if not IsValid(self.InteractiveInfo) then
        return
    end
    self.OwnerUuId = self.InteractiveInfo:GetOwner():GetName()
end

function WBP_InteractiveItem_C:UseGamePadStyle(UseGamePadStyle)
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        self:InitWidgetInfoInGamePad(UseGamePadStyle)
        local ActiveWidgetIndex = UseGamePadStyle and 1 or 0
        -- 0 PC  1 手柄
        self.WidgetSwitcher_Key:SetActiveWidgetIndex(ActiveWidgetIndex)
    end
end

function WBP_InteractiveItem_C:GetTextColor()
    if not IsValid(self.InteractiveInfo) then
        return self.NormalColor
    end
    if self.InteractiveInfo:GetRarity() > 0 then
        return self.RarityTextColor:GetRef(self.InteractiveInfo:GetRarity())
    else
        return self.InteractiveInfo:IsImportant() and self.ImportantColor or self.NormalColor
    end
end

function WBP_InteractiveItem_C:SelectEntryItem(bSelected, IsGamePad)
    self.bSelected = bSelected
    self:UseGamePadStyle(IsGamePad)
    if bSelected then
        if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
            self.Key:SetVisibility(ESlateVisibility.Visible)
            local InteractiveUI = self:GetInteractiveUI()
            if InteractiveUI ~= nil then
                if InteractiveUI.IsPickingAllInteractiveItem and self:IsPickUpItemWithOneClick() then
                    self.Key:SetVisibility(ESlateVisibility.Hidden)
                else
                    self.Key:SetVisibility(ESlateVisibility.Visible)
                end
            end
        else
            self.Key:SetVisibility(ESlateVisibility.Collapsed)
        end
        AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_add", nil, nil)
        self:StopAnimation(self:GetAnimation("Normal"))
        self:StopAnimation(self:GetAnimation("UnHover"))
        self:PlayAnimation(self:GetAnimation("Hover"))
        self:UpdateIcon()
        self.State = WBP_InteractiveItem_C.State.Hover
    else
        if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
            self.Key:SetVisibility(ESlateVisibility.Hidden)
        else
            self.Key:SetVisibility(ESlateVisibility.Collapsed)
        end
        self:StopAnimation(self:GetAnimation("Hover"))
        self:PlayAnimation(self:GetAnimation("UnHover"))
        self:UpdateIcon()
        self.State = WBP_InteractiveItem_C.State.Normal
    end
end

function WBP_InteractiveItem_C:IsPickUpItemWithOneClick()
    if not IsValid(self.InteractiveInfo) then
        return false
    end

    -- local IsPickUpComponent = URuntimeCommonFunctionLibrary.ObjIsChildOf(self.InteractiveInfo, UPickUpInteractiveComponent)
    -- local IsChestComponent = URuntimeCommonFunctionLibrary.ObjIsChildOf(self.InteractiveInfo, UChestInteractiveComponent)
    return self.InteractiveInfo:CanPickUpWithOneClick()
end

function WBP_InteractiveItem_C:OnInteractiveItemPressed()
    local InteractiveUI = self:GetInteractiveUI()
    if not InteractiveUI then
        return
    end
    if self:IsAnimationPlaying(self.Out) or self:IsAnimationPlaying(self.Press) then
        return
    end
    InteractiveUI:SelectSpecifiedItem(self)
    -- self:PlayInteractiveItemAnim("Press", false)
    self.bPressed = true
    InteractiveUI:PressedSelectAction(true)
end

function WBP_InteractiveItem_C:PlayPressAnim()
    local InteractiveUI = self:GetInteractiveUI()
    if not InteractiveUI then
        return
    end
    local PlayerActor = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
    if not PlayerActor then
        return
    end
    self.State = WBP_InteractiveItem_C.State.Press
    -- 是否为长按交互
    if IsValid(self.InteractiveInfo) and self.InteractiveInfo:IsLastingInteract() and not self.InteractiveInfo:IsForbidden(PlayerActor) then
        -- 长按交互类型是否为 Loop (长按交互时间为0 则为Loop类型)
        if self.InteractiveInfo:GetNeedLongPressTime() == 0 then
            self:PlayInteractiveItemAnim("Loop", false)
        else
            local NeedPressTime = self.InteractiveInfo:GetNeedLongPressTime()
            local PressedPercent = self.InteractiveInfo:GetLongPressedPercent()
            -- ScreenPrint("PressedTime = " .. tostring(PressedPercent))
            local AnimationSpeed = LongPressAnimationTime / NeedPressTime
            self:PlayAnimation(self.LongPress, PressedPercent, 1, UE4.EUMGSequencePlayMode.Forward, AnimationSpeed)
            if self.InteractiveInfo:NeedShowRemaindTime() then
                self:AddTimer(0.05 ,self.UpdateLongPressRemaindTime, true, 0, "UpdateLongPressRemaindTime", true)
                self.Text_RemainTime:SetRenderOpacity(1)
            else
                self.Text_RemainTime:SetRenderOpacity(0)
            end
        end
        self:UpdateText()
    else
        self:PlayInteractiveItemAnim("Press", false)
    end
    if InteractiveUI.CurInputDeviceType == ECommonInputType.Gamepad and IsValid(self.InteractiveInfo) and self.InteractiveInfo:IsLastingInteract() then
        self.Key_Interactive_GamePad:OnButtonPressed()
    end
end

function WBP_InteractiveItem_C:OnInteractiveItemReleased()
    local InteractiveUI = self:GetInteractiveUI()
    if not InteractiveUI then
        return
    end

    InteractiveUI:ReleasedSelectAction(true)
    self.bPressed = false
end

function WBP_InteractiveItem_C:PlayReleaseAnim()
    if self.bSelected and CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        local PlayerActor = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
        if not PlayerActor then
            return
        end
        self.State = WBP_InteractiveItem_C.State.Hover
        -- 是否为长按交互
        if IsValid(self.InteractiveInfo) and self.InteractiveInfo:IsLastingInteract() and not self.InteractiveInfo:IsForbidden(PlayerActor) then
            -- 长按交互类型是否为 Loop (长按交互时间为0 则为Loop类型)
            if self.InteractiveInfo:GetNeedLongPressTime() == 0 then
                self:PlayInteractiveItemAnim("Hover", false)
            else
                local PressedTime = self:GetAnimationCurrentTime(self.LongPress)
                local ReduceTime = self.InteractiveInfo:GetReduceTime()
                -- ReduceTime 若 <= 0 则说明为保存交互进度的交互选项
                if ReduceTime <= 0 then
                    self:PlayAnimation(self:GetAnimation("LongPress"), PressedTime, 1, UE4.EUMGSequencePlayMode.Forward, 0)
                    self:PauseAnimation(self.LongPress)
                else
                    local AnimationSpeed = LongPressAnimationTime / ReduceTime
                    self:PlayAnimation(self:GetAnimation("LongPress"), 1 - PressedTime, 1, UE4.EUMGSequencePlayMode.Reverse, AnimationSpeed)
                end
                self:RemoveTimer("UpdateLongPressRemaindTime",true)
                self.Text_RemainTime:SetRenderOpacity(0)
            end
            self:UpdateText()
        else
            self:PlayInteractiveItemAnim("Hover", false)
        end
        -- self:PlayAnimation(self:GetAnimation("Hover"), 0, 1, UE4.EUMGSequencePlayMode.Forward, 10000)
        local InteractiveUI = self:GetInteractiveUI()
        if not InteractiveUI then
            return
        end
        if InteractiveUI.CurInputDeviceType == ECommonInputType.Gamepad and IsValid(self.InteractiveInfo) and self.InteractiveInfo:IsLastingInteract() then
            self.Key_Interactive_GamePad:OnButtonReleased()
        end
    else
        self:PlayInteractiveItemAnim("Normal", false)
        -- self:PlayAnimation(self:GetAnimation("Normal"), 0, 1, UE4.EUMGSequencePlayMode.Forward, 10000)
        self.State = WBP_InteractiveItem_C.State.Normal
    end
end

-- 显示消耗资产
function WBP_InteractiveItem_C:UpdateCostItemDetail()
    local CostItemInfo = self.InteractiveInfo:GetCostItemInfo()
    if not CostItemInfo then
        self.Panel_Cost:SetVisibility(UIConst.VisibilityOp.Collapsed)
        return
    end

    if not CostItemInfo.IconPath or not CostItemInfo.PossessNum or not CostItemInfo.CostNum then
        self.Panel_Cost:SetVisibility(UIConst.VisibilityOp.Collapsed)
        DebugPrint(ErrorTag, "WBP_InteractiveItem_C ShowCostItemInfo IconPath 或 PossessNum 或 CostNum 请检查 GetCostItemInfo 返回值")
        return
    end

    local IconObj = LoadObject(CostItemInfo.IconPath)
    if not IconObj then
        IconObj = LoadObject("/Game/UI/Texture/Dynamic/Atlas/Prop/Item/T_Coin_Main_Lv3.T_Coin_Main_Lv3")
        DebugPrint(ErrorTag, "WBP_InteractiveItem_C ShowCostItemInfo IconPath 加载失败, 使用默认图标")
    end
    self.Img_Currency:SetBrushFromTexture(IconObj)
    self.Text_Cost:SetText(CostItemInfo.CostNum)

    if CostItemInfo.PossessNum < CostItemInfo.CostNum then
        self.Text_Cost:SetColorAndOpacity(self.UnEnoughColor)
    else
        self.Text_Cost:SetColorAndOpacity(self.EnoughColor)
    end

    local ConsumeTextKey = CostItemInfo.ConsumeTextKey
    if ConsumeTextKey and ConsumeTextKey ~= "" then
        self.Text_Consume:SetText(GText(ConsumeTextKey))
        self.Text_Consume:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
        self.Text_Consume:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end

    self.Panel_Cost:SetVisibility(UIConst.VisibilityOp.Visible)
end

function WBP_InteractiveItem_C:OnInteractiveItemClicked()
    local InteractiveUI = self:GetInteractiveUI()
    if not InteractiveUI then
        return
    end
    if self:IsAnimationPlaying(self.Click) then
        return
    end
    if not self:TryPlayClickAnim() then
        InteractiveUI:ClickSelectAction()
    end
end

function WBP_InteractiveItem_C:OnInteractiveItemHovered()
    if not self:CanDoAction() then
        return
    end
    local InteractiveUI = self:GetInteractiveUI()
    if not InteractiveUI then
        return
    end
    -- self:PlayAnimation(self.Hover)
    InteractiveUI:HoveredSelectAction(self)
end

function WBP_InteractiveItem_C:OnInteractiveItemUnhovered()
    if not self:CanDoAction() then
        return
    end
    -- self:PlayAnimation(self.UnHover)
    if self.bPressed then
        self:OnInteractiveItemReleased()
    end
end

---@return WBP_InteractivePanel_C
function WBP_InteractiveItem_C:GetInteractiveUI()
    ---@type BP_UIManagerComponent_C
    local UIManager = UIManager(self)
    assert(UIManager, "Can't get UIManager")

    return UIManager:GetUIObj(UIConst.InteractiveUIName)
end

function WBP_InteractiveItem_C:TryPlayClickAnim()
    if IsValid(self.InteractiveInfo) and self.InteractiveInfo:IsLastingInteract() then
        return false
    end
    self:PlayInteractiveItemAnim("Click")
    return true
end

function WBP_InteractiveItem_C:OnAnimationStarted(InAnimation)
    -- local AnimationName = self:GetAnimationNameByAnimation(InAnimation)
    -- ScreenPrint("WYX OnAnimationStarted "..AnimationName)
    if self.UnLock == InAnimation then
        self.Tag_New:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        return
    end
    if self.In == InAnimation or self.Out == InAnimation then
        return
    end
    self.PlayingAnimations[InAnimation] = true
end

function WBP_InteractiveItem_C:OnAnimationFinished(InAnimation)
    self.PlayingAnimations[InAnimation] = nil
    if rawget(self, "bOnRemoved") then
        return
    end
    if self.bRemoveing then
        return
    end
    
    if self.Click == InAnimation then
        local InteractiveUI = self:GetInteractiveUI()
        if not InteractiveUI then
            return
        end
        rawset(self, "bOnRemoved", true)
        if self.bReAddClick then
            self.bReAddClick = false
            return
        end
        if rawget(self, "bPickAll") then
            if IsValid(self.InteractiveInfo) then
                self.InteractiveInfo:BtnClicked(UGameplayStatics.GetPlayerCharacter(self, 0), 0)
            end
        else
            InteractiveUI:ClickSelectAction()
        end
       
        InteractiveUI:OnInteractiveItemRemoveAnimFinish(self)
    -- elseif self["in"] == InAnimation or self.UnLock == InAnimation then
    --     if self.bSelected then
    --         self:PlayAnimation(self:GetAnimation("Hover"))
    --     else
    --         self:PlayAnimation(self:GetAnimation("Normal"))
    --     end
    elseif self.Forbidden_Click == InAnimation then
        if IsValid(self.InteractiveInfo) then
            self.InteractiveInfo:OnClicked_Forbidden()
        end
    elseif self.Lock_Click == InAnimation then
        if IsValid(self.InteractiveInfo) then
            self.InteractiveInfo:OnClicked_Locked()
        end
    elseif self.Out == InAnimation then
        local InteractiveUI = self:GetInteractiveUI()
        if not InteractiveUI then
            return
        end
        if self.bReAddOut then
            self.bReAddOut = false
            return
        end
        rawset(self, "bOnRemoved", true)
        InteractiveUI:OnInteractiveItemRemoveAnimFinish(self)
    -- elseif self.Press == InAnimation then
    --     if self.InteractiveInfo and self.InteractiveInfo:IsLastingInteract() then
    --         if not self.bForceStop then
    --             local InteractiveUI = self:GetInteractiveUI()
    --             if InteractiveUI then
    --                 InteractiveUI:PressedSelectAction(true)
    --             end
    --         end
    --     end
    elseif self.LongPress == InAnimation then
        self:UpdateStateAnim()
    elseif self.UnLock == InAnimation then
        if self.bSelected then
            self:PlayAnimation(self:GetAnimation("Hover"))
        else
            self:PlayAnimation(self:GetAnimation("Normal"))
        end
    end
    self.bForceStop = false
end

function WBP_InteractiveItem_C:ReAdd()
    if not self:IsAnimationPlaying(self.Out) and not self:IsAnimationPlaying(self.Click) then
        return
    end
    if self:IsAnimationPlaying(self.Out) then
        self.bReAddOut = true
        self:StopAnimation(self.Out)
    end
    if self:IsAnimationPlaying(self.Click) then
        self.bReAddClick = true
        self:StopAnimation(self.Click)
    end
    self:PlayAnimation(self["in"], 0, 1, UE4.EUMGSequencePlayMode.Forward, 1, true)
    self:InitLongPressState()
    self:UpdateCostItemDetail()
    rawset(self, "bOnRemoved", false)
end

function WBP_InteractiveItem_C:CanDoAction()
    return not (self:IsAnimationPlaying(self.Out) or self:IsAnimationPlaying(self.Click)) and not rawget(self, "bPickAll")
end

function WBP_InteractiveItem_C:GetKeyName(ActionName)
    local InputSetting = UE4.UInputSettings.GetInputSettings()
    local ActionKeys = UE4.TArray(UE4.FInputActionKeyMapping)
    InputSetting:GetActionMappingByName(ActionName, ActionKeys)
    for i,KeyMap in ipairs(ActionKeys) do
        local key = KeyMap.Key
        -- UEPrint(UE4.UKismetInputLibrary.Key_GetDisplayName(key))
        for i,v in pairs(self.CurrentInputDevice) do
            if UE4.UKismetInputLibrary["Key_Is"..v](key) then
                -- print(_G.LogTag, UE4.UKismetInputLibrary.Key_GetDisplayName(key))
                -- local res = UE4.UKismetInputLibrary.Key_GetDisplayName(key)
                local res = UE4.UFormulaFunctionLibrary.Key_GetFName(key)
                local res_TextMap_index = string.gsub(res," ","_")
                if DataMgr.TextMap[res_TextMap_index] then
                    res = GText(res_TextMap_index)
                end
                return res, v
            end
        end
    end
    return nil, nil
end

function WBP_InteractiveItem_C:PlayInteractiveItemAnim(AnimName, bRestoreState)
    if self:IsAnimationPlaying(self.Out) or self:IsAnimationPlaying(self.Click) then
        return
    end
    if bRestoreState == nil then
        bRestoreState = true
    end
    self.bForceStop = true
    -- self:StopAllInteractiveAnim()
    self:StopAllInteractiveAnim(AnimName)
    self:PlayAnimation(self:GetAnimation(AnimName), 0, 1, UE4.EUMGSequencePlayMode.Forward, 1, bRestoreState)
end

function WBP_InteractiveItem_C:StopAllInteractiveAnim(AnimName)
    self.bRemoveing = true
    -- if AnimName ~= "Normal" then
    --     self:StopAnimation(self:GetAnimation("Normal"))
    -- end
    -- if AnimName ~= "Hover" then
    --     self:StopAnimation(self:GetAnimation("Hover"))
    -- end
    -- if AnimName ~= "UnHover" then
    --     self:StopAnimation(self:GetAnimation("UnHover"))
    -- end
    -- if AnimName ~= "Press" then
    --     self:StopAnimation(self:GetAnimation("Press"))
    -- end
    -- if AnimName ~= "Click" then
    --     self:StopAnimation(self:GetAnimation("Click"))
    -- end
    local IgnoreAnimation = nil
    if AnimName then
        IgnoreAnimation = self:GetAnimation(AnimName)
    end
    for Animation, Value in pairs(self.PlayingAnimations) do
        if IgnoreAnimation ~= Animation then
            self:StopAnimation(Animation)
        end
    end
    self.bRemoveing = false
    -- self:StopAnimation(self:GetAnimation("Normal"))
    -- self:StopAnimation(self:GetAnimation("Hover"))
    -- self:StopAnimation(self:GetAnimation("UnHover"))
    -- self:StopAnimation(self:GetAnimation("Press"))
    -- self:StopAnimation(self:GetAnimation("Click"))
end

function WBP_InteractiveItem_C:GetAnimation(AnimName)
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
    if not Player then return end
    if not IsValid(self.InteractiveInfo) then
        -- UEPrint("WYX NoInteractiveInfo Animation:"..AnimName)
        return self[AnimName]
    end
    if self.InteractiveInfo:IsLocked() then
        local FinalAnimationName = self["Lock_" .. AnimName] and "Lock_" .. AnimName or AnimName
        -- UEPrint("WYX Locked Animation:"..FinalAnimationName)
        return self[FinalAnimationName]
    end
    if self.InteractiveInfo:IsForbidden(Player) then
        local FinalAnimationName = self["Forbidden_" .. AnimName] and "Forbidden_" .. AnimName or AnimName
        -- UEPrint("WYX Forbidden Animation:"..FinalAnimationName)
        return self[FinalAnimationName]
    end
    -- UEPrint("WYX Normal Animation :"..AnimName)
    return self[AnimName]
end

function WBP_InteractiveItem_C:UpdateStars()
    if not IsValid(self.InteractiveInfo) then
        return
    end
    local Stars = self.InteractiveInfo:GetStars()
    local Visibility = Stars and ESlateVisibility.HitTestInvisible or ESlateVisibility.Collapsed
    self.HB_Star:SetVisibility(Visibility)
    self.WS_Temple:SetVisibility(Visibility)
    self.WS_TempleIcon:SetVisibility(Visibility)
    if not Stars then
        return
    end
    self.Group_Temple:SetVisibility(ESlateVisibility.HitTestInvisible)
    if Stars == -2 then
        self.HB_Star:SetVisibility(ESlateVisibility.Collapsed)
        self.WS_Temple:SetVisibility(ESlateVisibility.HitTestInvisible)
        self.WS_Temple:SetActiveWidgetIndex(0)
        self.WS_TempleIcon:SetVisibility(ESlateVisibility.HitTestInvisible)
        self.WS_TempleIcon:SetActiveWidgetIndex(0)
    elseif Stars == -1 then
        self.HB_Star:SetVisibility(ESlateVisibility.Collapsed)
        self.WS_Temple:SetVisibility(ESlateVisibility.HitTestInvisible)
        self.WS_Temple:SetActiveWidgetIndex(1)
        self.WS_TempleIcon:SetVisibility(ESlateVisibility.HitTestInvisible)
        self.WS_TempleIcon:SetActiveWidgetIndex(1)
    else
        self.WS_TempleIcon:SetVisibility(ESlateVisibility.Collapsed)
        self.HB_Star:SetVisibility(ESlateVisibility.HitTestInvisible)
        for i = 1, Stars do
            self["WBP_LevelMap_TempleStarItem_" .. i]:SetSmallStar()
            self["WBP_LevelMap_TempleStarItem_" .. i]:SetTipsNormal()
        end
        for i = Stars + 1, 3 do
            self["WBP_LevelMap_TempleStarItem_" .. i]:SetSmallStar()
            self["WBP_LevelMap_TempleStarItem_" .. i]:SetTipsEmpty()
        end
        if Stars == 3 then
            self.WS_Temple:SetVisibility(ESlateVisibility.HitTestInvisible)
            self.WS_Temple:SetActiveWidgetIndex(1)
        end
    end
end

function WBP_InteractiveItem_C:UpdateInteractiveItemState()
    self:UpdateIcon()
    self:UpdateText()
    self:UpdateCondition()
    self:UpdateStateAnim()
    self:InitLongPressState()
    self:UpdateCostItemDetail()
end

function WBP_InteractiveItem_C:UpdateIcon()
    if not IsValid(self.InteractiveInfo) then
        return
    end
    local PlayerCharacter = UGameplayStatics.GetPlayerCharacter(self, 0)
    local InteractiveIconPath, UseItemIcon = self.InteractiveInfo:GetInteractiveIcon(PlayerCharacter)
    local QuestID = self.InteractiveInfo:GetQuestID()
    local SpecialQuestID = self.InteractiveInfo:GetSpecialQuestID()
    if QuestID and (QuestID ~= 0 or (SpecialQuestID and SpecialQuestID ~= 0)) then
        -- 非特殊任务 使用对应任务Icon -- 现在策划要求禁用态使用禁用图标
        if not self.InteractiveInfo:IsForbidden() and self.InteractiveInfo:GetQuestInteractiveType() ~= QuestInteractiveTypeEnum.SpecialQuest then
            local QuestIconPath, bInTracking = self:GetQuestInteractiveIconPath(QuestID, SpecialQuestID)
            InteractiveIconPath = QuestIconPath and QuestIconPath or InteractiveIconPath
            UseItemIcon = bInTracking
        end
    end
    rawset(self, "UseItemIcon", UseItemIcon)
    -- ScreenPrint("WYX UpdateIcon "..InteractiveIconPath)
    if InteractiveIconPath then
        -- local AnimationAsset = UE4.UResourceLibrary.FindObject(self, InteractiveIconPath)
        -- if not AnimationAsset then
        rawset(self, "LoadResourceID", nil)
        local Handle = UE.UResourceLibrary.LoadObjectAsyncWithId(self, InteractiveIconPath, {self,WBP_InteractiveItem_C.OnIconLoadFinish})
        if Handle then
            rawset(self, "LoadResourceID", Handle.ResourceID)
        end
        -- else
        --     self:OnIconLoadFinish(AnimationAsset)
        -- end
        -- if UseItemIcon then
        --     self.Img_Item:SetBrushResourceObject(InteractiveIcon)
        --     self.Img_Item:SetVisibility(ESlateVisibility.Visible)
        --     self.Img_Icon:SetVisibility(ESlateVisibility.Collapsed)
        -- else
        --     self.Img_Icon:SetBrushResourceObject(InteractiveIcon)
        --     self.Img_Icon:SetVisibility(ESlateVisibility.Visible)
        --     self.Img_Item:SetVisibility(ESlateVisibility.Collapsed)
        -- end
    else
        self.WidgetSwitcher_0:SetVisibility(ESlateVisibility.Collapsed)
        -- self.Img_Icon:SetVisibility(ESlateVisibility.Collapsed)
        self.Img_Item:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function WBP_InteractiveItem_C:OnIconLoadFinish(Object, ResourceID)
    if not IsValid(self) or (ResourceID ~= nil and rawget(self, "LoadResourceID") ~= ResourceID) then
        return
    end
    local PlayerActor = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
    if not PlayerActor then return end
    if not Object then
        self.WidgetSwitcher_0:SetVisibility(ESlateVisibility.Collapsed)
        -- self.Img_Icon:SetVisibility(ESlateVisibility.Collapsed)
        self.Img_Item:SetVisibility(ESlateVisibility.Collapsed)
    end

    if rawget(self, "UseItemIcon") then
        self.Img_Item:SetBrushResourceObject(Object)
        self.Img_Item:SetVisibility(ESlateVisibility.Visible)
        self.WidgetSwitcher_0:SetVisibility(ESlateVisibility.Collapsed)
        -- self.Img_Icon:SetVisibility(ESlateVisibility.Collapsed)
    else
        if self.ShouldHighlight and (not self.InteractiveInfo:IsLocked()) and (not self.InteractiveInfo:IsForbidden(PlayerActor)) then
            local IconDynaMaterial = self.Img_Icon_Special:GetDynamicMaterial()
            IconDynaMaterial:SetTextureParameterValue("Mask", Object)
            self.WidgetSwitcher_0:SetActiveWidgetIndex(1)
        else
            self.Img_Icon:SetBrushResourceObject(Object)
            self.WidgetSwitcher_0:SetActiveWidgetIndex(0)
        end
        self.WidgetSwitcher_0:SetVisibility(ESlateVisibility.Visible)
        -- self.Img_Icon:SetVisibility(ESlateVisibility.Visible)
        self.Img_Item:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function WBP_InteractiveItem_C:UpdateStateAnim()
    self:StopAllInteractiveAnim()
    if self.State == WBP_InteractiveItem_C.State.Normal then
        self:PlayAnimation(self:GetAnimation("Normal"), 0, 1, UE4.EUMGSequencePlayMode.Forward, 10000)
    elseif self.State == WBP_InteractiveItem_C.State.Press then
        self:UpdatePressStateAnim()
    elseif self.State == WBP_InteractiveItem_C.State.Hover then
        self:PlayAnimation(self:GetAnimation("Hover"), 0, 1, UE4.EUMGSequencePlayMode.Forward, 10000)
    end
end

function WBP_InteractiveItem_C:UpdatePressStateAnim()
    if not IsValid(self.InteractiveInfo) then
        self:PlayAnimation(self:GetAnimation("Press"), 0, 1, UE4.EUMGSequencePlayMode.Forward, 10000)
        return
    end

    -- 是否为长按交互
    if self.InteractiveInfo:IsLastingInteract() then
        -- 长按交互类型是否为 进度类型 (长按交互时间为不为0 则为进度类型)
        if self.InteractiveInfo:GetNeedLongPressTime() ~= 0 then
            local PressedPercent = self.InteractiveInfo:GetLongPressedPercent()
            local ReduceTime = self.InteractiveInfo:GetReduceTime()
            -- ScreenPrint("CurrentPressedTime = " .. tostring(PressedPercent).."  ReduceTime: "..tostring(ReduceTime))
            -- ReduceTime 若 <= 0 则说明为保存交互进度的交互选项
            local AnimationSpeed = ReduceTime <= 0 and 0 or (LongPressAnimationTime / ReduceTime)
            self:PlayAnimation(self:GetAnimation("LongPress"), 1 - PressedPercent, 1, UE4.EUMGSequencePlayMode.Reverse, AnimationSpeed)
            -- self:PlayAnimation(self.LongPress, PressedPercent, 1, UE4.EUMGSequencePlayMode.Forward, 0)
            -- self:PauseAnimation(self.LongPress)
            self.Text_RemainTime:SetRenderOpacity(0)
        end
    else
        self:PlayAnimation(self:GetAnimation("Press"), 0, 1, UE4.EUMGSequencePlayMode.Forward, 10000)
    end
end

-- 更新 进度类型 长按选项的剩余时间文本
function WBP_InteractiveItem_C:UpdateLongPressRemaindTime()
    if not IsValid(self.InteractiveInfo) then
        return
    end
    local TotalLonPressTime = self.InteractiveInfo:GetNeedLongPressTime()
    -- local CurPercent = self.InteractiveInfo:GetLongPressedPercent()
    local CurPercent = self:GetAnimationCurrentTime(self.LongPress)
    self.Text_RemainTime:SetText(string.format("%ss", string.format("%.1f", math.max(0.0, TotalLonPressTime * (1 - CurPercent)))))
end

function WBP_InteractiveItem_C:UpdateText()
    if not IsValid(self.InteractiveInfo) then
        return
    end
    local InteractiveName = self.InteractiveInfo:GetInteractiveName()
    if self.InteractiveInfo:IsLastingInteract() then
        if self.State == WBP_InteractiveItem_C.State.Press then
            InteractiveName = self.InteractiveInfo:GetLongPressingText()
        end
    end
    self:SetInteractiveText(InteractiveName, self:GetTextColor())
end

function WBP_InteractiveItem_C:SetInteractiveText(Text, Color)
    if self.ShouldHighlight then
        self.Text_Interactive_Special:SetText(Text)
        self.WidgetSwitcher_1:SetActiveWidgetIndex(1)
    else
        self.Text_Interactive:SetText(Text)
        self.Text_Interactive:SetColorAndOpacity(Color)
        self.WidgetSwitcher_1:SetActiveWidgetIndex(0)
    end
end

function WBP_InteractiveItem_C:UpdateCondition()
    if not IsValid(self.InteractiveInfo) then
        return
    end
    local InteractiveCondition = self.InteractiveInfo:GetInteractiveCondition()
    if InteractiveCondition then
        self.Text_ExploreKeyNum:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Text_ExploreKeyNum:SetText(InteractiveCondition)
    else
        self.Text_ExploreKeyNum:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function WBP_InteractiveItem_C:GetInteractivePriority()
    if rawget(self, "InteractivePriority") then
        return self.InteractivePriority
    end
    if rawget(self, "IsPickUpAllItem") then
        -- 获取配置的全部拾取的优先级
        local Priority = DataMgr.InteractiveType[InteractiveTypeEnum.PickUpAll].Priority
        rawset(self, "InteractivePriority", Priority)
        self.InteractivePriority = Priority
        return Priority
    end
    if IsValid(self.InteractiveInfo) then
        local Priority = self.InteractiveInfo:GetInteractivePriority()
        rawset(self, "InteractivePriority", Priority)
        return Priority
    end
    return nil
end

-- return 的第一个参数是 交互选项Icon路径 第二个为是否是追踪中
function WBP_InteractiveItem_C:GetQuestInteractiveIconPath(InQuestChainId, InSpecialQuestId)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    if InSpecialQuestId and InSpecialQuestId ~= 0 then
        if DataMgr.SpecialQuestConfig[InSpecialQuestId] then
            InQuestChainId = DataMgr.SpecialQuestConfig[InSpecialQuestId].QuestChainId
        end
    end
    local bQuestInTracking = Avatar.TrackingQuestChainId == InQuestChainId
    if DataMgr.QuestChain[InQuestChainId] then
        local CurQuestChainType = DataMgr.QuestChain[InQuestChainId].QuestChainType
        if CurQuestChainType then
            if bQuestInTracking then
                return DataMgr.QuestTypeIcon[CurQuestChainType].TrackingIcon, true
            else
                return DataMgr.QuestTypeIcon[CurQuestChainType].NotTrackingIcon, false
            end
        end
    end
    return nil
end

return WBP_InteractiveItem_C
