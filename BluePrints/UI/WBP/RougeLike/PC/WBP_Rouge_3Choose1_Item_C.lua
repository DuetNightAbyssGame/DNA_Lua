--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Rouge_Treasure3Choose1Item_P_C
local M = Class("BluePrints.UI.BP_UIState_C")

--function M:Initialize(Initializer)
--end

--function M:PreConstruct(IsDesignTime)
--end

function M:Construct()
    self.BtnCD = 0.5 -- 发送rpc操作的内置CD
    self.Rarity2Color = {
        "Blue",
        "Purple",
        "Yellow",
    }
    UIUtils.InitDefinitionTextWidget(self, self.Text_Desc, "ExplanationId")
end

--function M:InitUIInfo(Name, IsInUIMode, EventList, ...)
--    DebugPrint("zyh222")
--    
--    self.Super.InitUIInfo(self, Name, IsInUIMode, EventList, ...)
--end

function M:OnListItemObjectSet(Content)
    Content.SelfWidget=self
   self:OnLoaded(Content.AwardInfo,Content.Parent,Content.NotHit)
end

function M:OnLoaded(...)
    local AwardInfo, Parent,NotHit = ...
    self.NotHit=NotHit
    if NotHit then
        self.Button_Select:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
    PrintTable(AwardInfo, 10)
    self.AwardType = AwardInfo.AwardType
    self.AwardId = AwardInfo.AwardId
    self.Parent = Parent
    self.AwardLevel=AwardInfo.AwardLevel
    self:PlayAnimation(self.Normal)
    self["WBP_Rouge"..self.AwardType.."ItemPart"]:OnLoaded(AwardInfo)
    self.IsSelected = false
    local AwardData
    local AwardDesc
    self.ExplanationId = nil
    if self.AwardType == "Blessing" then
        AwardData = DataMgr.RougeLikeBlessing
        AwardDesc = UIUtils.GenRougeBlessingDesc(self.AwardId, AwardInfo.AwardLevel or 0)
        local BlessingGroup = DataMgr.RougeLikeBlessing[self.AwardId].BlessingGroup
        local SuitName = DataMgr.BlessingGroup[BlessingGroup].Name
        self.Text_SuitTitle:SetText(GText(SuitName))
        self.ExplanationId = AwardData[self.AwardId].ExplanationId
    elseif self.AwardType == "Treasure" then
        AwardData = DataMgr.RougeLikeTreasure
        AwardDesc = UIUtils.GenRougeTreasureDesc(self.AwardId)
        self.ExplanationId = AwardData[self.AwardId].ExplanationId
    end

    -- if self.ExplanationId ~= nil and #self.ExplanationId > 0 then
    --     AwardDesc = UIUtils.GenRougeCombatTermDesc(AwardDesc, self.ExplanationId)
    -- end

    self.Text_Desc:SetText(AwardDesc)
    self.Button_Select.OnHovered:Add(self, self.OnBtnHover)
    self.Button_Select.OnClicked:Add(self, self.OnBtn_SelectClicked)
    self.Btn_Desc.OnClicked:Add(self, self.OnBtn_DescClicked)
    self.StartTime = UE4.UGameplayStatics.GetRealTimeSeconds(self)
    self.Rarity = AwardData[self.AwardId][self.AwardType.."Rarity"]
    self.WidgetSwitcher_VX:SetActiveWidgetIndex(self.Rarity - 1)

    if self.AwardType == "Treasure" then
        self.Image_Sign:SetBrushResourceObject(self["Sign_"..self.Rarity2Color[self.Rarity]])
        local TreasureNum=UIUtils.GetTreasureGroupNum(self.AwardId)
        local CurrentTreasureNum=UIUtils.GetCurrentTreasureGroupNum(self.AwardId)
        if self.Parent.ItemNum and self.Parent.ItemNum == 1 or self.NotHit then
            CurrentTreasureNum = CurrentTreasureNum + 1
            if CurrentTreasureNum==TreasureNum then
                self.Rouge_SuitSign:PlayAnimation(self.Rouge_SuitSign.Active)
            end
        end
        local Text=tostring(CurrentTreasureNum).."/"..tostring(TreasureNum)
        -- if TreasureNum>0 then
            
        -- else
        --     self.Rouge_SuitSign:SetVisibility(UIConst.VisibilityOp.Collapsed)
        -- end
        local ItemInfo = DataMgr["TreasureGroup"][DataMgr.RougeLikeTreasure[self.AwardId].TreasureGroup]
        if ItemInfo then
            self.Rouge_SuitSign.Text_SuitTitle:SetText(Text)
            if ItemInfo.Icon then
                local IconObj = LoadObject(ItemInfo.Icon)
                assert(IconObj, "未找到对应TreasureGroup的Icon:"..DataMgr.RougeLikeTreasure[self.AwardId].TreasureGroup)
                self.Rouge_SuitSign.Image_TitleIcon:SetBrushResourceObject(IconObj)
            else
                self.Rouge_SuitSign.Image_TitleIcon:SetVisibility(UIConst.VisibilityOp.Collapsed)
            end
            self.Rouge_SuitSign:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
            self.bShowSuitSign = true
        else
            self.Rouge_SuitSign:SetVisibility(UIConst.VisibilityOp.Collapsed)
            self.bShowSuitSign = false
        end
        
        self.Rouge_SuitSign.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor.OnMenuOpenChanged:Remove(self,self.ItemMenuAnchorChanged)
        self.Rouge_SuitSign.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor.OnMenuOpenChanged:Add(self,self.ItemMenuAnchorChanged)
        self.Rouge_SuitSign.Com_BtnQa:Init(
        {
            OwnerWidget  = self,
            ClickCallback=function ()
                local TreasureGroupId = DataMgr.RougeLikeTreasure[self.AwardId].TreasureGroup
                if TreasureGroupId then
                    TreasureNum=UIUtils.GetTreasureGroupNum(self.AwardId)
                    CurrentTreasureNum=UIUtils.GetCurrentTreasureGroupNum(self.AwardId)
                    local bActiveTreasure=false
                    if TreasureNum==CurrentTreasureNum+1 and (self.NotHit or self.IsSelected) then
                        bActiveTreasure=true
                    end
                    local Content = {ItemType = "TreasureGroup", ItemId = TreasureGroupId,MenuPlacement = EMenuPlacement.MenuPlacement_MenuRight,bActive=bActiveTreasure}
                    self.Rouge_SuitSign.ItemDetails_MenuAnchor:OpenItemDetailsWidget(false, Content)
                else
                    DebugPrint("@@@ Rouge没找到TreasureGroupId")
                end
            end
        })   
    else
        self.BlessingBuffIcon:PlayAnimation(self.BlessingBuffIcon[self.Rarity2Color[self.Rarity]])
        UE.UResourceLibrary.LoadObjectAsync(self,AwardData[self.AwardId].TypeIcon,{self,M.OnBlessingBuffIconLoadFinish})
    end
    
    --self:PlayAnimation(self.Change)
    self:AddTimer(0.1, function()
        UIUtils.SetTextJustificationByLineCount(self.Text_Desc)
        self.Text_Desc:SetAutoWrapText(false)
    end)
    if not self.GameInputModeSubsystem then
        self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
    end
    if self.NotHit then
        self.Key_Definition:CreateCommonKey(
            {
                KeyInfoList = {{Type = "Img",ImgShortPath = "A"}},
                Desc =  GText("UI_CTL_Explain")
            }
        )
    else
        self.Key_Definition:CreateCommonKey(
            {
                KeyInfoList = {{Type = "Img",ImgShortPath = "UP"}},
                Desc =  GText("UI_CTL_Explain")
            }
        )
    end
    self:UpdateCompadKeyDefinition(false)
    self.Super.OnLoaded(self, ...)
end

function M:ItemMenuAnchorChanged(bIsOpen)
    if not bIsOpen then
        self.Parent.bInSuitScroll = false
        self:SetFocus()
        if type(self.Parent.ShowTreasureSuitGamePadKey) == "function" then
            self.Parent:ShowTreasureSuitGamePadKey()
        end
    end
end

--聚焦到按钮 并且处于手柄端 SelectItem
function M:OnBtnHover()
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        self:AddDelayFrameFunc(function()
            self:SelectItem()
        end, 1)
        
    end
end

function M:OnBtn_SelectClicked()
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        if self.IsSelected == true then
            self.Parent:OnConfirmBtnClicked()
            return
        end
    end
    self:SelectItem()
end

function M:OnBtn_DescClicked()
    if not self.IsSelected and self.Button_Select:GetVisibility() == UIConst.VisibilityOp.Visible then
        self:SelectItem()
        return
    end

    if UIUtils.IsGamepadInput() then
        UIUtils.OnDefinitionLinkClicked(self, self.ExplanationId)
    end
end

function M:SelectItem()
    DebugPrint("检测到被选中")
    if self:IsAnimationPlaying(self.Hover) then
        self:StopAnimation(self.Hover)
    end
    self.IsSelected = true
    self:PlayAnimationForward(self.Click)
    AudioManager(self):PlayUISound(self, "event:/ui/roguelike/choose_point_click", nil, nil)
    self.Parent:SelectItem(self.AwardId, self)
end

function M:UpdateCompadKeyDefinition(bShowGamepadKey)
    if UIUtils.UtilsGetCurrentInputType()==ECommonInputType.Gamepad then
        if bShowGamepadKey then
            if self.ExplanationId ~= nil and #self.ExplanationId > 0 then
                self.Key_Definition:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
                return
            end
        end
    end
    if self.Key_Definition:GetVisibility() ~= ESlateVisibility.Collapsed then
        self.Key_Definition:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function M:OnBtn_ConfirmClicked()
    self.CurrentTime = UE4.UGameplayStatics.GetRealTimeSeconds(self)
    DebugPrint("检测到按键按下")
    if(self.CurrentTime - self.StartTime < self.BtnCD) then
        self:PlayAnimationForward(self.Normal)
        return
    end
    self.StartTime = UE4.UGameplayStatics.GetRealTimeSeconds(self)
    AudioManager(self):PlayUISound(self, "event:/ui/roguelike/choose_point_confirm", nil, nil)
    self.Parent:ChooseItem(self.AwardId, self)
end

function M:SwitchDesc(IsSimple)

    if self.AwardId==nil then
        return
    end
    local AwardData
    local AwardDesc
    if self.AwardType == "Blessing" then
        AwardData = DataMgr.RougeLikeBlessing
        AwardDesc = UIUtils.GenRougeBlessingSimpleDesc(self.AwardId)
        if not IsSimple or AwardDesc==nil then
            AwardDesc = UIUtils.GenRougeBlessingDesc(self.AwardId, self.AwardLevel or 0)
        end
    elseif self.AwardType == "Treasure" then
        AwardData = DataMgr.RougeLikeTreasure
        AwardDesc=UIUtils.GenRougeTreasureSimpleDesc(self.AwardId)
        if not IsSimple or  AwardDesc ==nil then
            AwardDesc = UIUtils.GenRougeTreasureDesc(self.AwardId)
        end
    end
    if AwardDesc==nil then
        Battle(self):ShowBattleError("肉鸽"+self.AwardType+"表中Id为"+tostring(self.AwardId)"的描述为空")

    end

    -- if self.ExplanationId ~= nil and #self.ExplanationId > 0 then
    --     AwardDesc = UIUtils.GenRougeCombatTermDesc(AwardDesc, self.ExplanationId)
    -- end
    if AwardDesc ~= tostring(self.Text_Desc:GetText()) then
        self.Text_Desc:SetText(AwardDesc)
        if self.ExplanationId ~= nil and #self.ExplanationId > 0 then
            UIUtils.SetDefinitionText(self.Text_Desc, self.ExplanationId)
        end
    end

    if IsSimple then
        self["WBP_Rouge"..self.AwardType.."ItemPart"].Text_ArchiveSign:SetVisibility(UIConst.VisibilityOp.Collapsed)
    else
        self["WBP_Rouge"..self.AwardType.."ItemPart"].Text_ArchiveSign:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
end

function M:OnBlessingBuffIconLoadFinish(Object)
    if Object and IsValid(self) then
        self.BlessingBuffIcon.Image_BlessingBuffIcon:SetBrushResourceObject(Object)
    end
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)

    if InKeyName == Const.GamepadDPadUp then
        self:OnBtn_DescClicked()
    end
    return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    if  self.GameInputModeSubsystem and UIUtils.UtilsGetCurrentInputType()==ECommonInputType.Gamepad then
        if self.Parent then
            if self.Parent.ChangeSelectItem then
                self.Parent:ChangeSelectItem(self)
            end
            self.Parent.CurrentSelectItem=self
            if self.Parent.OnItemSelected then
                self.Parent:OnItemSelected()
            end
            if self.Parent.ShowBottomGamePadKey then
                self.Parent:ShowBottomGamePadKey(true)
            end
        end
        self.GameInputModeSubsystem:SetTargetUIFocusWidget(self)
        self.GameInputModeSubsystem:UpdateCurrentFocusWidgetPos()
    end
    return  M.Super.OnFocusReceived(self, MyGeometry, InFocusEvent)
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
    if CurInputType == ECommonInputType.Gamepad then
        --self.Btn_Desc:SetFocus()
        if self.DefinitionWidget and IsValid(self.DefinitionWidget) then
            self.DefinitionWidget:SetFocus()
        end
    end
end

-- function M:OnAnalogValueChanged(MyGeometry,InAnalogInputEvent)
--     if UIUtils.UtilsGetCurrentInputType()==ECommonInputType.Gamepad then
--         local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
--         local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
--         local AddOffset = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 5
--         if InKeyName == "Gamepad_RightY" then
--             if self.CurrentSelectItem then
--                 local CurScrollOffset = self.ScrollBox_Desc:GetScrollOffset()
--                 self.ScrollBox_Desc:SetScrollOffset(CurScrollOffset + AddOffset)
--             end
--         end
--         return UE4.UWidgetBlueprintLibrary.UnHandled()
--     end
-- end
--function M:Tick(MyGeometry, InDeltaTime)
--end

return M
