-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local PersonalTitleUtils = require "Utils.PersonalTitleUtils"

---@class WBP_UniformHeadWidget_C : BP_UIState_C, WBP_NPC_UniformHeadWidget_C
local M = Class({"Blueprints.UI.BP_UIState_C"})

function M:Initialize(Initializer)
    self.Super.Initialize(self, Initializer)
    self.AttachedWidgetComponent = nil
    self.bHasInitialized = true
    self.bHasConstruct = false
    self.ExternWidget = {} ---@type table<UniformHeadEnum, UUserWidget> 先这么放着，为后来如果要把Name、Bubble等拆分成动态加载的做准备
end

function M:Construct(...)
    M.Super.Construct(self, ...)
    self.bHasConstruct = true
    if self.EnableParamsPreConstruct then
        self:ConstructRefreshEnable(self.EnableParamsPreConstruct)
        self.EnableParamsPreConstruct = nil
    end
end

function M:InitSubWidgets()
    self.NPC_Bubble_Long:Init(self)
    self.NPC_Bubble_Short:Init(self)
    self.NPC_Impression:Init(self)
    self.NPC_ImpressionShop:Init(self)
    self.Npc_Name_PC:Init(self)
    self.Com_GuidePoint:InitNpcSideQuestBubble(self)
    self.ActiveCount = 0
    self.EnabledWidgets = {}
    self.EnabledWidgets['Name'] = false
    self.EnabledWidgets['Bubble'] = false
    self.EnabledWidgets['Impression'] = false
    self.EnabledWidgets['HeadIcon'] = false
    self.EnabledWidgets['NpcSideIndicator'] = false
    self:InitSpecialWidget()
    self.TitleClassPath = nil
    for WidgetName, Widget in pairs(self.ExternWidget) do
        Widget:Init(self)
        self.EnabledWidgets[WidgetName] = false
    end
end

function M:TryInsertNewWidget(WidgetName)
    self.Pos_Bubble:SetVisibility(UE.ESlateVisibility.SelfHitTestInvisible)
    if self.ExternWidget[WidgetName] then
        return self.ExternWidget[WidgetName]
    end
    local WidgetClass = self:GetExternWidgetClass(WidgetName)-- 先这么放着，为后来如果要把Name、Bubble等拆分成动态加载的做准备
    if not WidgetClass then return end
    local Item = UIManager(self):CreateWidget(WidgetClass)
    self.ExternWidget[WidgetName] = Item
    -- self.Pos_Bubble:SetVisibility(UE.ESlateVisibility.SelfHitTestInvisible)
    if WidgetName == "Bubble_Reward" then
        self.Pos_Bubble:ClearChildren()
        self.Pos_Bubble:AddChildToOverlay(Item)
    elseif WidgetName == "Bubble_Emoji" then
        self.Pos_Bubble:ClearChildren()
        self.Pos_Bubble:AddChildToOverlay(Item)
    else
        self.VB:AddChildToVerticalBox(Item)
    end
    Item:Init(self)
    return self.ExternWidget[WidgetName]
end

function M:EnableWidget(WidgetName, ...)
    if not self:CheckCanWork() then return end
    self:TryEnableWidget(WidgetName,true, ...)
end

function M:DisableWidget(WidgetName, ...)
    if not self:CheckCanWork() then return end
    self:TryEnableWidget(WidgetName,false, ...)
end

function M:TryEnableWidget(WidgetName,bEnable,...)
    if not self:CheckCanWork() then
        return
    end
    --DebugPrint( "M:TryEnableWidget",self.AttachedWidgetComponent:GetOwner():GetName(),WidgetName,bEnable,...,self.EnabledWidgets[WidgetName])
    local WidgetNameOrign = WidgetName
    if WidgetName == "Long_Bubble" or WidgetName == "Short_Bubble" then
        WidgetName = "Bubble"
    end
    if (not not self.EnabledWidgets[WidgetName]) == bEnable then
        return
    end

    self.EnabledWidgets[WidgetName] = bEnable
    --由于WidgetComponent的SetWidget，Widget会延迟一帧构造，原因待查
    if not self.bHasConstruct then
        local EnableParams = self.EnableParamsPreConstruct or {}
        self.EnableParamsPreConstruct = EnableParams
        EnableParams[WidgetNameOrign] = table.pack(...)
        return
    end
    self:EnableWidgetInternal(WidgetNameOrign, bEnable, ...) 
end

function M:ConstructRefreshEnable(EnableParams)
    local EnabledWidgets = self.EnabledWidgets
    for WidgetName, Param in pairs(EnableParams) do
        local WidgetNameOrign = WidgetName
        if WidgetName == "Long_Bubble" or WidgetName == "Short_Bubble" then
            WidgetName = "Bubble"
        end
        self:EnableWidgetInternal(WidgetNameOrign, EnabledWidgets[WidgetName], table.unpack(Param))
    end
end

function M:EnableWidgetInternal(WidgetName, bEnable, ...)
    if bEnable then
        self.ActiveCount = self.ActiveCount + 1
    else
        self.ActiveCount = self.ActiveCount - 1
    end
    local SpecialWidget = self:TryGetSpecailWidget(WidgetName)
    local Widget
    if IsValid(SpecialWidget) then
        self:EnableSpecialWidget(WidgetName, SpecialWidget, bEnable, ...)
    else
        Widget = self:TryGetWidget(WidgetName)
        if IsValid(Widget) then 
            if bEnable then
                Widget:OnEnabled(...)
            else
                Widget:OnDisabled(...)
            end
        end
    end
    if self.AttachedWidgetComponent then
        self.AttachedWidgetComponent:OnChangeActiveWidgets(self.ActiveCount)
        -- local bEnableScale, MinScale, MaxScale, MinScaleDis, MaxScaleDis = self:GetWidgetScaleParams(WidgetName)
        -- if bEnableScale then
        --     if bEnable then
        --         self.AttachedWidgetComponent:AddDistanceTestInfo(Widget or SpecialWidget, MinScale, MaxScale, MinScaleDis, MaxScaleDis)
        --     else
        --         self.AttachedWidgetComponent:RemoveDistanceTestInfo(Widget or SpecialWidget)
        --     end
        -- end
    end
end

function M:CheckCanWork()
    return self.bHasInitialized 
end

function M:TryGetWidget(WidgetName)
    if WidgetName == 'Name' then
        return self.NPC_Name_PC
    elseif WidgetName == 'Bubble' then
        return self:SelectBubbleWidget() 
    elseif WidgetName == 'Short_Bubble' then
        return self:SetBubbleWidget(1)
    elseif WidgetName == 'Long_Bubble' then
        return self:SetBubbleWidget(0)
    elseif WidgetName == 'Impression' then
        return self.NPC_Impression
    elseif WidgetName == 'HeadIcon' then
        return self.NPC_ImpressionShop
    elseif WidgetName == 'NpcSideIndicator' then
        return self.Com_GuidePoint
    else
        return self:TryInsertNewWidget(WidgetName)
    end
end

function M:SelectBubbleWidget()
    local HeadUISubsystem = UNpcHeadUISubsystem.GetHeadUISubsystem(self)
    local Owner = self.AttachedWidgetComponent:GetOwner()
    local bUseShortBubble = false
    if HeadUISubsystem and Owner then
        bUseShortBubble = HeadUISubsystem:ShouldUseShortBubble(Owner)
    end

    local ActiveBubbleIdx = bUseShortBubble and 1 or 0

    return self:SetBubbleWidget(ActiveBubbleIdx)
end

function M:SetBubbleWidget(Index)
    local OldIndex = self.NPC_Bubble_Switcher:GetActiveWidgetIndex()
    if OldIndex ~= Index then
        local OldWidget = self.NPC_Bubble_Switcher:GetActiveWidget()
        if IsValid(OldWidget) then
            OldWidget:OnDisabled()
        end
    end
    self.NPC_Bubble_Switcher:SetActiveWidgetIndex(Index)
    return self.NPC_Bubble_Switcher:GetActiveWidget()
end

-- function M:SetAttachedWidget(AttachedWidgetComponent)
--     self.AttachedWidgetComponent = AttachedWidgetComponent
-- end

-- function M:UnsetAttachedWidget()
--     self.AttachedWidgetComponent = nil
--     if self.Title then
--         self.Title:ClearChildren()
--     end
--     self.Pos_Bubble:SetVisibility(UE.ESlateVisibility.Collapsed)
--     self.bHasConstruct = false
-- end

function M:SetWidgetInitBubble()
    self.Com_GuidePoint:InitBubble(self)
end

function M:EnableSpecialWidget(WidgetName, Widget, bEnable, ...)
    if WidgetName == "Title" then
        if bEnable then
            self:EnableTitleWidget(Widget,  ...)
        else
            self:DisableTitleWidget(Widget)
        end
    end
end

function M:EnableTitleWidget(Widget, TitlePrefix, TitleSuffix, TitleFrameId)
    -- local ClassPath = PersonalTitleUtils.GetTitleFramePath(TitleFrameId)
    -- if not ClassPath then
    --     return
    -- end
    -- if ClassPath ~= self.TitleClassPath then
    --     self.Title:ClearChildren()
    --     self.TitleClassPath = ClassPath
    -- end
    -- if not IsValid(self.TitleWidget) then
    --     local Item = UIManager(self):CreateWidget(self.TitleClassPath)
    --     self.Title:AddChildToOverlay(Item)
    --     self.TitleWidget = Item
    -- end
    -- self.TitleWidget:SetTitleContent(TitlePrefix, TitleSuffix)
    -- self.Title:SetVisibility(UE.ESlateVisibility.SelfHitTestInvisible)
    UIUtils.SetTitle(self.Title, {
        TitleBefore = TitlePrefix, 
        TitleAfter = TitleSuffix,
        TitleFrame = TitleFrameId,
    }, true)
end

function M:DisableTitleWidget(Widget)
    self.Title:SetVisibility(UE.ESlateVisibility.Collapsed)
end

function M:InitSpecialWidget()
    self.Title:SetVisibility(UE.ESlateVisibility.Collapsed)
end

function M:TryGetSpecailWidget(WidgetName)
    if WidgetName == "Title" then
        return self.Title
    end
end

return M
