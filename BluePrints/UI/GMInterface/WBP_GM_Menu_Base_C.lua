--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
--GM指令UI中，所有菜单的基类
require "UnLua"

local WBP_GM_Menu_Base_C = Class("BluePrints.UI.BP_UIState_C")

function WBP_GM_Menu_Base_C:Construct(...)
    self.Overridden.Construct(self)
    self.bIsFocusable = true
    self:SetFocus()
end

--每个菜单保存着自身的Command对象，该对象包含子菜单中所有在List中指令
function WBP_GM_Menu_Base_C:InitMenu(Command)
    self.Command = Command
    if(self.Bg_AutoSize and self.Vertical_AutoSize)then
        --保存UMG中设置背景的大小
        local BGSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Bg_AutoSize)
        BGSlot:SetAutoSize(false)
        self.OriginalBG_Size = BGSlot:GetSize()
        local VB_Slot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Vertical_AutoSize)
        self.OriginalVB_Size = VB_Slot:GetSize()
        local ListSlot = UE4.UWidgetLayoutLibrary.SlotAsVerticalBoxSlot(self.List)
        local SlateSize = FSlateChildSize()
        SlateSize.Value = 1
        SlateSize.SizeRule = UE4.ESlateSizeRule.Auto
        ListSlot:SetSize(SlateSize)
        --背景和Vertical_Box的大小设为0，防止在首次打开时出现闪烁
        local TemSize =  FVector2D(self.OriginalVB_Size.X, 0)
        VB_Slot:SetSize(TemSize)
        TemSize = FVector2D(self.OriginalBG_Size.X,0)
        BGSlot:SetSize(TemSize)
    end
end


--List的Entry数量改变时可以手动调用此方法，一般用于自适应改变背景大小
function WBP_GM_Menu_Base_C:OnEntryNumChanged(Entry)
    --缺少其中一个控件的菜单的背景不会自适应大小
    if(not self.Bg_AutoSize or not self.Vertical_AutoSize or not Entry.Panel_Size )then
        return
    end
    local ListEntryLength = self.List:GetDisplayedEntryWidgets():Length()
    if(ListEntryLength > self.EntryNumForScroll)then
        return
    end
    local TopHeight = 0.0
    local BottomHeight = 0.0
    if(self.Panel_Top)then
        TopHeight = self.Panel_Top:GetDesiredSize().Y
    end
    if(self.Panel_Bottom)then
        BottomHeight = self.Panel_Bottom:GetDesiredSize().Y
    end
    --因为此时Entry还没渲染，所以根据Entry最外层名为Panel_Size的CanvasPanel的大小来改变背景图片大小
    local EntrySlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(Entry.Panel_Size)
    local EntrySize = EntrySlot:GetSize()
    local space = self.List.EntrySpacing
    if(ListEntryLength <= 1)then
        space = 0
    end
    --计算新增Entry后Vertical_Box的高度
    local NewHeight = (EntrySize.Y + space) * ListEntryLength - space + TopHeight + BottomHeight
    --根据与UMG中设置的高度比例来缩放背景和Vertical_Box
    local HeightScale = NewHeight / self.OriginalVB_Size.Y
    local VB_Slot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Vertical_AutoSize)
    local VB_Size = VB_Slot:GetSize()
    VB_Size.Y = self.OriginalVB_Size.Y * HeightScale + 1 --加1是为了让List自动加载下一个Entry
    VB_Slot:SetSize(VB_Size)
    local BG_Slot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Bg_AutoSize)
    local BG_Size = BG_Slot:GetSize()
    BG_Size.Y = self.OriginalBG_Size.Y * HeightScale
    BG_Slot:SetSize(BG_Size)
    if(ListEntryLength >= self.EntryNumForScroll)then
        self:ShowScrollbar(NewHeight)
    end
end

--设置Vertical_Box中各部分的权重，显示滚动条
function WBP_GM_Menu_Base_C:ShowScrollbar(NewHeight)
    local TopHeight = 0.0
    local TopSizeValue = 0.0
    local BottomHeight = 0.0
    local BottomSizeValue = 0.0
    local SlateSize = FSlateChildSize()
    if(self.Panel_Top)then
        TopHeight = self.Panel_Top:GetDesiredSize().Y
        TopSizeValue = TopHeight / NewHeight
        local PtSlott = UE4.UWidgetLayoutLibrary.SlotAsVerticalBoxSlot(self.Panel_Top)
        SlateSize.Value = TopSizeValue
        SlateSize.SizeRule = UE4.ESlateSizeRule.Fill
        PtSlott:SetSize(SlateSize)
    end
    if(self.Panel_Bottom)then
        BottomHeight = self.Panel_Bottom:GetDesiredSize().Y
        BottomSizeValue = BottomHeight / NewHeight
        local PbSlott = UE4.UWidgetLayoutLibrary.SlotAsVerticalBoxSlot(self.Panel_Bottom)
        SlateSize.Value = BottomSizeValue
        SlateSize.SizeRule = UE4.ESlateSizeRule.Fill
        PbSlott:SetSize(SlateSize)
    end
    local ListSlot = UE4.UWidgetLayoutLibrary.SlotAsVerticalBoxSlot(self.List)
    SlateSize.Value = 1-TopSizeValue-BottomSizeValue
    SlateSize.SizeRule = UE4.ESlateSizeRule.Fill
    ListSlot:SetSize(SlateSize)
end

function WBP_GM_Menu_Base_C:RefreshItems()
    local Entrys = self.List:GetDisplayedEntryWidgets()
    local Length = Entrys:Length()
    for i=1,Length,1 do
        if(Entrys[i].SetItem)then
            Entrys[i]:SetItem()
        end
    end
end

function WBP_GM_Menu_Base_C:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (InKeyName == "Escape") then
        self:Close()
    end
    return UE4.UWidgetBlueprintLibrary.Handled()
end

return WBP_GM_Menu_Base_C
