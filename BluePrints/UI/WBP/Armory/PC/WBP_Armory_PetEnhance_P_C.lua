--
-- DESCRIPTION 词条进阶界面pc端，包含手柄操控逻辑
--
-- @COMPANY **
-- @AUTHOR 叶轲
-- @DATE 3.26
--
require "UnLua"

---@type WBP_Armory_PetEnhance_P_C
local M = Class({"BluePrints.UI.BP_UIState_C"})
M._components =
    {"BluePrints.UI.WBP.Armory.WBP_Armory_PetEnhance_Base_Compoment" --  "BluePrints.UI.UI_PC.Common.LSFocusComp"
    }

function M:Construct()
    self.IsPc = true
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    -- self:AddLSFocusTarget(nil, {self.Selective_Listing.Common_Sort_List})
end
function M:InitTabInfo()
    self.Tab_PetEnhance:Init({
        Tabs = {},
        DynamicNode = {"Back", "Tip", "BottomKey"},
        BottomKeyInfo = {{
            GamePadInfoList = {{
                Type = "Img",
                ImgShortPath = "A",
                -- ClickCallback = self.OnReturnKeyDown,
                Owner = self
            }},
            Desc = GText("UI_CTL_Add/Remove")
        }, {
            KeyInfoList = {{
                Type = "Text",
                Text = "Esc",
                ClickCallback = self.OnReturnKeyDown,
                Owner = self
            }},
            GamePadInfoList = {{
                Type = "Img",
                ImgShortPath = "B",
                ClickCallback = self.OnReturnKeyDown,
                Owner = self
            }},
            Desc = GText("UI_BACK")
        }},
        StyleName = "Text",
        OwnerPanel = self,
        TitleName = GText("Pet_Affix_Break"),
        BackCallback = function()
            self:OnReturnKeyDown(true)
        end
    })
end

function M:Close()

    M.Super.Close(self)
end

function M:OnLoaded(...)
    -- 界面初始化完成
    M.Super.OnLoaded(self, ...)
    self:PlayInAnim()
    self:AddTimer(0.1, function()
    self:SetOriginFocus()
    end, nil, nil, nil, true)
end
--- 返回按键回调
---@param bIsForceClose 是否强制关闭，标题上的返回键用
function M:OnReturnKeyDown(bIsForceClose)
    if self.IsListExpanded == true and bIsForceClose ~= true then
        self:ExpandList(false)
        if self.CurInputDeviceType == ECommonInputType.Gamepad then
            self:SetOriginFocus()
        end
        return
    end
    -- 返回上一级
    if (not self:CheckIsCanCloseSelf()) then
        return
    end
    self:PlayOutAnim()
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        if InKeyName == UIConst.GamePadKey.FaceButtonBottom then
            self:OnGamePadADown()
        end
    end
    -- M.Super.OnPreviewKeyDown(self, MyGeometry, InKeyEvent)
    return UE4.UWidgetBlueprintLibrary.UnHandled()
end
--------------------------输入交互--------------------------------
function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InputEvent = UWidgetBlueprintLibrary.GetInputEventFromKeyEvent(InKeyEvent)
    if (UKismetInputLibrary.InputEvent_IsRepeat(InputEvent)) then
        return UIUtils.Handled
    end
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        IsEventHandled = self:OnGamePadDown(InKeyName)
    else
        if (InKeyName == "Escape") then
            IsEventHandled = true
            self:OnReturnKeyDown()
        end
    end
    return UE4.UWidgetBlueprintLibrary.Handled()
end

--- 手柄输入处理
---@param InKeyName 按键名
function M:OnGamePadDown(InKeyName)
    local IsEventHandled = false
    if self.GamePadKeyTable == nil then
        self.GamePadKeyTable = {
            [UIConst.GamePadKey.FaceButtonRight] = function()
                self:OnReturnKeyDown()
            end,
            [UIConst.GamePadKey.LeftThumb] = function()
                self.Selective_Listing.Common_Sort_List:SetFocus()
            end,
            [UIConst.GamePadKey.FaceButtonLeft] = function()
                if self.Btn_Enhance.IsForbidden == false then
                    self:OnEnhanceClicked()
                end
            end,
            [UIConst.GamePadKey.FaceButtonBottom] = function()
                self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
                local s = self.GameInputModeSubsystem:GetCurrentLocalPlayerFocusWidgetType()
                self:OnGamePadADown()
            end,
            [UIConst.GamePadKey.SpecialRight] = function()
                if self.bItemDetailsShowed then
                    self:LockOrUnlockPet()
                end
            end

        }
    end
    if self.GamePadKeyTable[InKeyName] ~= nil then
        self.GamePadKeyTable[InKeyName](self)
        IsEventHandled = true
    end
    if IsEventHandled == false then
        IsEventHandled = self.Tab_PetEnhance:Handle_KeyEventOnGamePad(InKeyName)
    end

    return IsEventHandled
end

-- 检测到输入设备变化，初始化手柄focus
function M:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
    self.CurInputDeviceType = CurInputType
    if CurInputType == ECommonInputType.Gamepad then
        if  self:HasAnyFocus() then
            self:SetOriginFocus()
        end
        return
    else

    end
end
---切换到手柄后默认聚焦第一个词条,若宠物背包打开则聚焦到第一个宠物
function M:SetOriginFocus()
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
    local Type = self.GameInputModeSubsystem:GetCurrentLocalPlayerFocusWidgetType()
    if Type == "SObjectWidget" then
        for i = 1, 3 do
            if self["EntryItem_" .. i]:HasAnyUserFocus() then
                return
            end
        end
    end
    if self.IsListExpanded then
        self.Selective_Listing:SetFocusToList()
        return
    end
    local index = self.CurEntryContent.index
    self.EntryItemWidgets[index]:SetFocus()
    self:SetSingleBottomKeyInfo(2)
    -- local WidgetNameIndex = self.EntryItemWidgets[1].WidgetIndex
    -- self:OnEntryClicked(WidgetNameIndex)
end
---导航到右边的物品栏如果被禁用则不用被导航
function M:LuaNavOutItemRight()
    if self.Item_1.Panel_Add.Visibility == UIConst.VisibilityOp.SelfHitTestInvisible then
        return self.Item_1
    end
    return nil

end
--- 词条导航函数，导航时同步选中
function M:OnEntryGamePadNavigationLeft()
    local index = self.CurEntryContent.index - 1
    if index >= 1 and self.EntryItemWidgets[index] then
        local WidgetNameIndex = self.EntryItemWidgets[index].WidgetIndex
        self:OnEntryClicked(WidgetNameIndex)
        return self.EntryItemWidgets[index]
    end
    return nil
end
---词条导航函数，导航时同步选中
function M:OnEntryGamePadNavigationRight()
    local index = self.CurEntryContent.index + 1
    if self.EntryItemWidgets[index] then
        local WidgetNameIndex = self.EntryItemWidgets[index].WidgetIndex
        self:OnEntryClicked(WidgetNameIndex)
        return self.EntryItemWidgets[index]
    end
    return nil
end
---自定义手柄选中词条时A键回调
function M:OnGamePadADown()
    if self.IsListExpanded == false then
        if self.CurEntryContent.IsLocked or self.CurEntryContent.IsEmpty then
            return
        elseif self.CurEntryContent.EntryId and DataMgr.PetEntry[self.CurEntryContent.EntryId].PetEntryUPID == nil then
            return
        else -- 宠物词条可升级,可以打开背包

        end
        self:ExpandList(true) -- 接下来执行的逻辑在Armory_PetEnhance_Selective_Listing_Compoment
        self:FocusListItem()
    else
        local FilteredPets = self:GetFilteredPet(self.CurEntryContent.EntryId)
        if FilteredPets and #FilteredPets == 0 then
            UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("AvailablePet_Empty")) -- 没有素材
        else
            UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_Armory_Toast_Material")) -- 请选择材料

        end
    end
end
---设置底部A键变化 nil 不显示，1 增加/减少 2选择素材 
function M:SetSingleBottomKeyInfo(KindIndex)
    -- local 
    local Keys = {"UI_CTL_Add/Remove", "UI_CTL_Pet_Select"}
    if KindIndex ~= nil and Keys[KindIndex] == nil then
        ScreenPrint("传入index错误，没有对应文本")
        return
    end
    local AKeyInfo = {

        GamePadInfoList = {{
            Type = "Img",
            ImgShortPath = "A",
            Owner = self
        }},
        Desc = GText(Keys[KindIndex])
    }
    if KindIndex == nil then
        AKeyInfo = {}
    end
    if self.Tab_PetEnhance and self.Tab_PetEnhance.BottomKeyWidget[1] then
        self.Tab_PetEnhance:SetSingleBottomKeyInfo(self.Tab_PetEnhance.BottomKeyWidget[1], AKeyInfo)
    end
end
function M:ChanegeSelectEntry()
    if self.CurInputDeviceType == ECommonInputType.Gamepad then
        self:SetSingleBottomKeyInfo(2)
    end
end
-- 词条升级面板
function M:InitEnhaceEntry()

end
-- 词条满级面板
function M:InitMaxEntry()
end
-- 词条未解锁面板（已废弃）
function M:InitLockedEntry()

end
-- 空槽位词条面板
function M:InitLNullEntry()
    self:SetSingleBottomKeyInfo(nil)
end

AssembleComponents(M)
return M
