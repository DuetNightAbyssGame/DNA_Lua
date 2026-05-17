--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

local GachaCommon = require "BluePrints.UI.WBP.Gacha.GachaCommon"

---@type WBP_Gacha_DetailProbabilityItem_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C", "BluePrints.Common.DelayFrameComponent"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    -- self.List_Probability:DisableScroll(true)
end

function M:OnListItemObjectSet(Content)
    local ProbabilityText = "Probability"
    local Probability
    if Content.GachaItemRarity == 5 then
        ProbabilityText = ProbabilityText.."Gold"
        Probability = DataMgr.GachaProbability[DataMgr.SkinGacha[Content.GachaId].ProbabilityId][ProbabilityText] or 0
    elseif Content.GachaItemRarity == 4 then
        ProbabilityText = ProbabilityText.."Purple"
        Probability = DataMgr.GachaProbability[DataMgr.SkinGacha[Content.GachaId].ProbabilityId][ProbabilityText] or 0
    else
        local Probability5 = DataMgr.GachaProbability[DataMgr.SkinGacha[Content.GachaId].ProbabilityId][ProbabilityText.."Gold"] or 0
        local Probability4 = DataMgr.GachaProbability[DataMgr.SkinGacha[Content.GachaId].ProbabilityId][ProbabilityText.."Purple"] or 0
        Probability = GachaCommon.GACHA_PROBABILITY_BASE - Probability5 - Probability4
    end
    local Rate =  math.min(math.max(Probability / GachaCommon.GACHA_PROBABILITY_BASE, 0), 1) * 100

    if Content.GachaItemRarity == 5 then
        self.Text_Title:SetText(string.format(GText("UI_SkinGacha_Gold"), Rate))
    elseif Content.GachaItemRarity == 4 then
        self.Text_Title:SetText(string.format(GText("UI_SkinGacha_Purple"), Rate))
    elseif Content.GachaItemRarity == 3 then
        self.Text_Title:SetText(string.format(GText("UI_SkinGacha_Blue"), Rate))
    end
    self.List_Probability:ClearChildren()
    for _, ItemData in ipairs(Content.ItemLst) do
        local Probability = math.min(math.max(ItemData.Probability / GachaCommon.GACHA_PROBABILITY_BASE, 0), 1) * 100
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        local Type =  GachaCommon.GachaItemTypeMap[ItemData.Type]
        Content.Id = ItemData.Id
        Content.Icon = ItemUtils.GetItemIconPath(ItemData.Id, Type)
        Content.ParentWidget = self
        Content.ItemType = Type
        if Type == "Skin" or Type == "CharAccessory" or Type == "WeaponSkin" or Type == "WeaponAccessory" or (Type == "Resource" and DataMgr.Resource[ItemData.Id].ResourceSType == "GestureItem")  then
        else
            Content.Count = ItemData.Count
        end
        Content.Rarity = DataMgr[Type][ItemData.Id].Rarity or 1
        Content.IsShowDetails = true
        Content.bDisableCommonClick = true
        Content.OnMouseButtonUpEvents =
        {
            Obj = self,
            Callback = function()
                if Content.ItemType == "Skin"  then
                    PageJumpUtils:CloseFrontDialog()
                    UIManager(self):LoadUINew("ArmorySkin", {Type = "Char", SkinId = Content.Id, OnCloseCallback = function()
                        local GachaMain = UIManager(self):GetUIObj("GachaMain")
                        if GachaMain then
                            GachaMain:OnClickBtnDetails()
                        end
                    end})
                elseif Content.ItemType == "WeaponSkin" then
                    PageJumpUtils:CloseFrontDialog()
                    UIManager(self):LoadUINew("ArmorySkin", {Type = "Weapon", SkinId = Content.Id, OnCloseCallback = function()
                        local GachaMain = UIManager(self):GetUIObj("GachaMain")
                        if GachaMain then
                            GachaMain:OnClickBtnDetails()
                        end
                    end})
                end
            end
        }
        Content.JumpReturnCallBack = 
        {
            CallBack = function()
                local GachaMain = UIManager(self):GetUIObj("GachaMain")
                if GachaMain then
                    GachaMain:OnClickBtnDetails()
                end
            end,
            -- CallBackObj = UIManager(self):GetUIObj("GachaMain"),
        }
        Content.HandleMouseDown = true
        Content.UIName = "GachaMain"
        local Widget = UIManager(self):_CreateWidgetNew("ComItemUniversalM")
        self.List_Probability:AddChild(Widget)
        Widget:Init(Content)

    end

    self:AddDelayFrameFunc(function()
        self:SetupLazyNavigation()
    end, 1)
end

function M:GetWrapBoxItemsPerRow(WrapBox)
    if not WrapBox then return 0 end

    local ChildCount = WrapBox:GetChildrenCount()
    if ChildCount == 0 then return 0 end

    local FirstChild = WrapBox:GetChildAt(0)
    local FirstGeo = FirstChild:GetCachedGeometry()
    local FirstPos = UE4.USlateBlueprintLibrary.GetLocalTopLeft(FirstGeo)
    local FirstY = FirstPos.Y
    local Count = 1

    for i = 1, ChildCount - 1 do
        local Child = WrapBox:GetChildAt(i)
        local ChildGeo = Child:GetCachedGeometry()
        local CurrentPos = UE4.USlateBlueprintLibrary.GetLocalTopLeft(ChildGeo)
        local CurrentY = CurrentPos.Y

        if math.abs(CurrentY - FirstY) > 5.0 then
            break
        else
            Count = Count + 1
        end
    end
    return Count
end

function M:HandleNavigation(ChildIndex, Direction)
    local WrapBox = self.List_Probability
    if not WrapBox or not UE4.UKismetSystemLibrary.IsValid(WrapBox) then return nil end

    local ItemsPerRow = self:GetWrapBoxItemsPerRow(WrapBox)
    if ItemsPerRow <= 0 then return nil end
    local ChildCount = WrapBox:GetChildrenCount()

    if Direction == "Down" then
        local TargetIndex = ChildIndex + ItemsPerRow
        if TargetIndex < ChildCount then
            return WrapBox:GetChildAt(TargetIndex)
        end
    elseif Direction == "Up" then
        local TargetIndex = ChildIndex - ItemsPerRow
        if TargetIndex >= 0 then
            return WrapBox:GetChildAt(TargetIndex)
        end
    elseif Direction == "Left" then
        local bIsRowStart = ChildIndex % ItemsPerRow == 0
        local TargetIndex = ChildIndex - 1
        if not bIsRowStart and TargetIndex >= 0 then
            return WrapBox:GetChildAt(TargetIndex)
        end
    elseif Direction == "Right" then
        local bIsRowEnd = (ChildIndex + 1) % ItemsPerRow == 0
        local TargetIndex = ChildIndex + 1
        if not bIsRowEnd and TargetIndex < ChildCount then
            return WrapBox:GetChildAt(TargetIndex)
        end
    end

    return nil
end

function M:SetupLazyNavigation()
    local WrapBox = self.List_Probability
    if not WrapBox or not UE4.UKismetSystemLibrary.IsValid(WrapBox) then return end
    local ChildCount = WrapBox:GetChildrenCount()
    if ChildCount == 0 then return end

    local ItemsPerRow = self:GetWrapBoxItemsPerRow(WrapBox)
    if ItemsPerRow <= 0 then return end

    for i = 0, ChildCount - 1 do
        local Child = WrapBox:GetChildAt(i)

        local DownIndex = i + ItemsPerRow
        if DownIndex < ChildCount then
            Child:SetNavigationRuleCustom(UE4.EUINavigation.Down, function()
                return self:HandleNavigation(i, "Down")
            end)
        end

        local UpIndex = i - ItemsPerRow
        if UpIndex >= 0 then
            Child:SetNavigationRuleCustom(UE4.EUINavigation.Up, function()
                return self:HandleNavigation(i, "Up")
            end)
        end

        Child:SetNavigationRuleCustom(UE4.EUINavigation.Left, function()
            return self:HandleNavigation(i, "Left")
        end)
        Child:SetNavigationRuleCustom(UE4.EUINavigation.Right, function()
            return self:HandleNavigation(i, "Right")
        end)
    end
end

function M:BP_GetDesiredFocusTarget()
    return self.List_Probability:GetChildAt(0)
end

return M
