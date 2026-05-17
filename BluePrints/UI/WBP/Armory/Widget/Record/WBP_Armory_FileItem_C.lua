--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Armory_FileItem_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})
local ArmoryUtils = require "BluePrints.UI.WBP.Armory.ArmoryUtils"

function M:Construct()
    self.Button_Area.OnClicked:Add(self,self.OnCellClicked)
    self.Button_Area.OnHovered:Add(self,self.OnCellHovered)
    self.Button_Area.OnUnhovered:Add(self,self.OnCellUnhovered)
    self.Button_Area.OnPressed:Add(self,self.OnCellPressed)
    -- self.Btn_Play.OnClicked:Add(self,self.OnBtnClicked) --与Button_Area合并
    self:RefreshBaseInfo()
end

function M:OnListItemObjectSet(Content)
    self.Parent = Content.Parent
    self.Content = Content
    Content.UI = self
    if(Content.IsLocked)then
        self.IsLocked = true
        self:PlayAnimation(self.Forbidden)
        self.Icon_Lock:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        self.Button_Area:SetVisibility(UIConst.VisibilityOp["HitTestInvisible"])
    else
        self:PlayAnimation(self.Normal)
        self.Icon_Lock:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        self.Button_Area:SetVisibility(UIConst.VisibilityOp["Visible"])
    end
    self:SetReddot(Content.IsNew)
    self.Text_Title:SetText(Content.Title)
    if(Content.IsShowBtnPlay)then
        self.WidgetSwitcher_State:SetVisibility(UIConst.VisibilityOp["HitTestInvisible"])
        self.WidgetSwitcher_State:SetActiveWidgetIndex(0)
        self.Btn_Play:SetVisibility(UIConst.VisibilityOp["HitTestInvisible"])
    else
        self.WidgetSwitcher_State:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        self.Btn_Play:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end
    if(Content.IsLocked)then
        self:PlayAnimation(self.Forbidden)
        self.Btn_Play:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    else
        self:PlayAnimation(self.Normal)
        self.Btn_Play:SetVisibility(UIConst.VisibilityOp["HitTestInvisible"])
    end
    if self.CurInputDevice == ECommonInputType.Gamepad then
        self:SetVisibility(UIConst.VisibilityOp["Visible"])
    end

    ---创建红点信息
    if  Content.CharDataType==nil then return end
    local ReddotName=table.concat({ArmoryUtils.FilesTabType[2], Content.CharId,Content.CharDataType, Content.CharDataTarget}, "_")
    ReddotManager.AddListenerEx(ReddotName,self,function(self,Count)
        if Count > 0 then
            self:SetReddot(true)
        else
            self:SetReddot(false)
        end
    end)
    if   self.ReddotName  then
        ScreenPrint("似乎Item改成复用了，记得在BP_OnEntryReleased增加移除监听函数")
    end
    self.ReddotName = ReddotName
end
--尚未调用,如果改成了listview，记得在这里调用移除红点监听函数
function M:BP_OnEntryReleased()
    if (self.Content) then
        self.Content.UI = nil
    end
end
function M:SetIsPlaying(IsPlaying)
    if(self.Content)then
        self.Content.IsPlaying = IsPlaying
    end
    if(IsPlaying)then
        self.WidgetSwitcher_State:SetActiveWidgetIndex(1)
    else
        self.WidgetSwitcher_State:SetActiveWidgetIndex(0)
    end
end

function M:OnCellClicked()
    self:SetIsSelected(not self.Content.IsSelected)
    if(self.Content.OnClicked)then
        self.Content.OnClicked(self.Content.Parent,self.Content)
    end
    --原Btn_Play点击事件
    if(self.Content and self.Content.OnBtnClicked)then
        self.Content.OnBtnClicked(self.Content.Parent,self.Content)
    end
    if self.ReddotName then
        ReddotManager.ClearLeafNodeCount(self.ReddotName)
         local Detail = ReddotManager.GetLeafNodeCacheDetail(self.ReddotName)
         if Detail then
             Detail.IsRead = true
         end
    end
end

function M:SetIsSelected(IsSelected)
    self.Content.IsSelected = IsSelected
    if(IsSelected)then
        self:StopAnimation(self.Normal)
        self:PlayAnimation(self.Click)
        self:PlayAnimation(self.Select)
    else
        self:StopAnimation(self.Click)
        self:StopAnimation(self.Select)
        self:PlayAnimation(self.Normal)
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

function M:OnCellHovered()
    if self.Content == nil then return end
    if(not self.Content.IsLocked and not self.Content.IsSelected)then
        self:PlayAnimation(self.Hover)
    end
end

function M:OnCellUnhovered()
    if self.Content == nil then return end
    if(not self.Content.IsLocked and not self.Content.IsSelected)then
        -- self:StopAnimation(self.Hover)
        self:PlayAnimation(self.UnHover)
    end
end

function M:OnCellPressed()
    if self.Content == nil then return end
    if(not self.Content.IsLocked and not self.Content.IsSelected)then
        self:PlayAnimation(self.Press)
    end
end

function M:GetSize()
    local Slot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Common_List_Subcell_PC)
    return Slot:GetSize()
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnAddedToFocusPath(InFocusEvent)
    self.Parent.ScrollBox_File:ScrollWidgetIntoView(self, true, UE4.EDescendantScrollDestination.IntoView)
end

function M:RefreshBaseInfo()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(self.GameInputModeSubsystem)) then
        self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    self.CurGamepadName = CurGamepadName
    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    local ActiveWidgetIndex = IsUseKeyAndMouse and 0 or 1
    if (IsUseKeyAndMouse) then
        --键鼠
        if self.IsLocked then
            self:SetVisibility(UIConst.VisibilityOp["HitTestInvisible"])
        end
    else
        --手柄
        self:SetVisibility(UIConst.VisibilityOp["Visible"])
    end
    self.CurInputDevice = CurInputDevice
end
function M:Destruct()
    if(self.ReddotName)then
        ReddotManager.RemoveListener(self.ReddotName,self)
    end
end
return M
