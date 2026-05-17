--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_BuffDialog_C
local M = Class({"BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.Super.Construct(self)
    self.Avatar = GWorld:GetAvatar()
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:Destruct()
    self.Super.Destruct(self)
    self:RemoveInputMethodChangedListen()
end

function M:InitContent(Params, PopupData, Owner)
    self.Owner = Owner
    self.Parent = Params.Parent
    self.CurBuffType = Params.Type
    self:Init(Params.Type)
    self:SetFocus()
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
    self:AddInputMethodChangedListen()
    if  UIUtils.UtilsGetCurrentInputType()==ECommonInputType.Gamepad then
        self:InitGamepadView()
    end
end

function M:InitBuffs(Type)
    if Type == "Normal" then
        self.StartIndex_Cur = 1
        self.EndIndex_Cur = 2
        self.StartIndex_Other = 3
        self.EndIndex_Other = 3
    elseif Type == "Weapon" then
        self.StartIndex_Cur = 3
        self.EndIndex_Cur = 3
        self.StartIndex_Other = 1
        self.EndIndex_Other = 2
    end
    self.SumNumber = self.EndIndex_Cur - self.StartIndex_Cur + 1
    self.Buffs = {}
    for i=self.StartIndex_Cur,self.EndIndex_Cur do
        if self.Avatar.PaotaiBuffs then
            self.Buffs[i-self.StartIndex_Cur+1] = self.Avatar.PaotaiBuffs[i]
        end
    end
    self:AddTimer(0.01, function ()
        self:SetTipText()
    end)
end

function M:Init(Type)
    self:InitBuffs(Type)
    self:RefreshListInfo()
end

function M:RefreshListInfo()
    self.List_Buff:ClearListItems()
    local BuffInfo = nil
    if self.CurBuffType == "Weapon" then
        BuffInfo = DataMgr.PaotaiGameWeapon
    else
        BuffInfo = DataMgr.PaotaiGameProp
    end
    if BuffInfo then
        local ClassPath = '/Game/UI/UI_PC/Common/Common_Item_subsize_PC_Content.Common_Item_subsize_PC_Content_C'
        for _,Info in ipairs(BuffInfo) do
            local Content = NewObject(UE4.LoadClass(ClassPath))
            Content.ClickEvent = {
                Obj = self,
                Func = self.ClickBuffListItem,
                Params = {Content},
            }
            Content.Id = Info.Id
            Content.BuffId = Info.BuffId
            Content.Parent = self
            Content.Icon = Info.PropIcon or Info.WeaponIcon
            Content.Name = Info.PropName or Info.WeaponName
            Content.Des = Info.PropDes or Info.WeaponDes
            Content.LockDes = Info.PropLockDes or Info.DungeonLockDes
            Content.Type = self.CurBuffType
            Content.CanCancelSelection = true
            Content.IsSelect = self:CheckIsSelected(Content.BuffId)
            self.List_Buff:AddItem(Content)
        end
    end
end

function M:CheckIsSelected(BuffId)
    for Index,Id in pairs(self.Buffs) do
        if BuffId == Id then
            return Index
        end
    end
    return false
end

function M:ClickBuffListItem(Content)
    if Content then
        if not Content.IsUnlock then
            return false
        end
        if Content.IsSelect then
            local Ans = self:RemoveBuff(Content.BuffId)
            if Ans then
                Content.Entry:SetSelectedByClick(false)
                self:SetTipText()
            end
            return Ans
        else
            local Ans = self:AddBuff(Content.BuffId)
            if Ans then
                Content.Entry:SetSelectedByClick(true)
                self:SetTipText()
            end
            return Ans
        end
    end
    return false
end

function M:RemoveBuff(Id)
    local TargetIndex = nil
    for Index,BuffId in pairs(self.Buffs) do
        if BuffId == Id then
            TargetIndex = Index
            break
        end
    end
    if TargetIndex then
        table.remove(self.Buffs, TargetIndex)
        return true
    end
    return false
end

function M:AddBuff(BuffId)
    local CurNum = #self.Buffs
    if CurNum < self.EndIndex_Cur - self.StartIndex_Cur + 1 then
        table.insert(self.Buffs, BuffId)
        return true
    end
    return false
end

function M:SetListItemCanCancelSelection()
    local Contents = self.List_Buff:GetListItems()
    for _, Content in pairs(Contents) do
        Content.CanCancelSelection = self:CheckCanCancelSelection(Content.BuffId)
    end
    local AllDisplayWidget = self.List_Buff:GetDisplayedEntryWidgets()
    for _, Widget in pairs(AllDisplayWidget) do
        Widget:SetCanCancelSelection(Widget.Content.CanCancelSelection)
    end
end

function M:PackageData()
    table.sort(self.Buffs,function (a,b)
        return a < b
    end)
    local Buffs = {}
    for i=1,3 do
        if self.Avatar.PaotaiBuffs then
            Buffs[i] = self.Avatar.PaotaiBuffs[i]
        end
    end
    for i=self.StartIndex_Cur,self.EndIndex_Cur do
        Buffs[i] = self.Buffs[i-self.StartIndex_Cur+1]
    end
    return {Buffs = Buffs}
end

function M:AddInputMethodChangedListen()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice) 
    end
end

function M:RemoveInputMethodChangedListen()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice) 
    end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    if (IsUseKeyAndMouse) then
        self:InitKeyBoardView()
    else
        self:InitGamepadView()
    end
end

function M:InitGamepadView()
    self:ShowGamepadBtn(true)
    self:ShowGamepadCloseBtn(true)
end

function M:InitKeyBoardView()
    self:ShowGamepadBtn(false)
    self:ShowGamepadCloseBtn(false)
end

function M:OnContentFocusReceived(MyGeometry, InFocusEvent)
    self.List_Buff:NavigateToIndex(0)
    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        self.List_Buff:NavigateToIndex(0)
    end
    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:ShowGamepadBtn(bShow)
    if bShow then 
        if self.GamepadBtnIndex then 
            if self.Owner:GetGamepadShortcutByIndex(self.GamepadBtnIndex) then
                self:ShowGamepadShortcut(self.GamepadBtnIndex)
            end
            return
        end
        self.GamepadBtnIndex = self:ShowGamepadShortcutBtn({        
            KeyInfoList = {
            {
                Type = "Img",
                ImgShortPath = "A"
            }},
            Desc = GText("UI_CTL_Add/Remove")
        })
    else 
        if self.GamepadBtnIndex then 
            self:HideGamepadShortcut(self.GamepadBtnIndex)
        end
    end
end

function M:SetTipText()
    Tips = {
        string.format(GText("PaotaiGame_Equipped"), #self.Buffs, self.SumNumber)
    }
    self:BroadcastDialogEvent("UpdateDialogTipText", { Tips = Tips, DialogItemIndex = 1, bShowTip = true})
end

return M
