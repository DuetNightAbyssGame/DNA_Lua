--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Map_DispatchAgent_L_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

local AgentEnum = {
    Dispatching = 2,    --派遣中
    NotDispatched = 3,    --未派遣
    Fighting = 1,   --出战中
}

function M:Initialize(Initializer)
    self.Super.Initialize(self)
    self.IsChoose = false
    self.Owner = nil 
    self.AbilityList = {}
end

function M:Construct()
    --self.Item.Btn_Add.OnClicked:Add(self, self.OnClick)
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function M:OnListItemObjectSet(Content)
    self.Id = Content.Id
    self.Uuid = Content.Uuid
    self.Owner = Content.Owner
    self.State = Content.State
    if(self.Id == -1) then
        self.Item.Switch_Type:SetActiveWidgetIndex(1)
        return
    end
    self.Content = Content
    Content.UI = self
    local CharInfo = DataMgr.Char[self.Id]
    self.Item.Content = {}
    self.Item:SetInteractivity(true)
    self.Item:SetMinusBtn(true, self, self.OnClickMinus)
    self.Item.Minus:SetVisibility(ESlateVisibility.Collapsed)
    self.Item:SetIcon(CharInfo.Icon)
    self.Item:SetRarity(CharInfo.CharRarity)
    if(self.State == AgentEnum.Dispatching) then
        self.Item:SetDispatchAgent(self.State, GText("UI_Disptach_Agent_State_Doing"))
    elseif self.State == AgentEnum.Fighting then
        self.Item:SetDispatchAgent(self.State, GText("UI_Disptach_Agent_State_Busy"))
    else
        self.Item:SetDispatchAgent(self.State, nil)
    end
    self.Item.VerticalBox_NameLevelNum:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.WBox_Ability:ClearChildren()
    self:AddAbility()

end

function M:BP_OnEntryReleased()
    if self.conten then
        self.Content.UI = nil
    end
end

function M:OnClickMinus()
    self:CancelChoose()
    self.Owner.DispatchDetail:RemoveAgentData(nil, self.Uuid)
end

function M:AddAbility()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local Char = Avatar.Chars[CommonUtils.Str2ObjId(self.Uuid)]
    self.AbilityList = Char:GetCurrentUnlockDispatchTag()
    for Type, Count in pairs(self.AbilityList) do
        for i = 1, Count do
            local TagInfo = DataMgr.CharDispatchTag[Type]
            local Path = '/Game/UI/WBP/Map/Widget/Dispatch/WBP_Map_Ability_S.WBP_Map_Ability_S'
            local Item = UIManager(self):CreateWidget(Path)
            Item.Icon_Ability:SetBrushResourceObject(LoadObject(TagInfo.Icon))
            self:SetColor(Item, TagInfo.DispatchTag)
            self.WBox_Ability:AddChildToWrapBox(Item)
        end
    end
    -- local Info = DataMgr.Char[self.Id].DispatchTag
    -- for _, Tag in pairs(Info) do
    --     local TagInfo = DataMgr.CharDispatchTag[Tag]
    --     local Path = '/Game/UI/WBP/Map/Widget/Dispatch/WBP_Map_Ability_S.WBP_Map_Ability_S'
    --     local Item = UIManager(self):CreateWidget(Path)
    --     Item.Icon_Ability:SetBrushResourceObject(LoadObject(TagInfo.Icon))
    --     self:SetColor(Item, TagInfo.DispatchTag)
    --     self.WBox_Ability:AddChildToWrapBox(Item)
    -- end
end


function M:SetColor(Item, Type)
    local ColorName = UIUtils.GetDispathchColorNameByType(Type)
    if(ColorName and Item["Color_BG_"..ColorName])then
        Item.BG:SetColorAndOpacity(Item["Color_BG_"..ColorName])
    else      
        Item:PlayAnimation(Item.Special)
    end
end

function M:CancelChoose()
    if self.State == AgentEnum.Dispatching or self.State == AgentEnum.Fighting then
        return
    end
    local Info = self.Item.Set:GetChildAt(0)
    Info.Img_Mask:SetVisibility(ESlateVisibility.Collapsed)
    Info.TipText:SetVisibility(ESlateVisibility.Collapsed)
    self.Item.Minus:SetVisibility(ESlateVisibility.Collapsed)
    self.IsChoose = false
end

-- function M:OnMouseEnter(MyGeometry,MouseEvent)
--     return self.Item:OnMouseEnter(MyGeometry,MouseEvent)
-- end

-- function M:OnMouseLeave(MouseEvent)
--     return self.Item:OnMouseLeave(MouseEvent)
-- end

-- function M:OnMouseButtonDown(MyGeometry, MouseEvent)
--    return self.Item:OnMouseButtonDown(MyGeometry, MouseEvent)
-- end

-- function M:OnMouseButtonUp(MyGeometry,MouseEvent)
--     return self.Item:OnMouseButtonUp(MyGeometry,MouseEvent)
-- end

-- function M:OnMouseMove(MyGeometry, MouseEvent)
--     return self.Item:OnMouseMove(MyGeometry, MouseEvent)
-- end

-- function M:OnTouchStarted(MyGeometry, InTouchEvent)
--     return self.Item:OnMouseButtonDown(MyGeometry, InTouchEvent,true)
-- end

-- function M:OnTouchEnded(MyGeometry, InTouchEvent)
--     return self.Item:OnMouseButtonUp(MyGeometry, InTouchEvent,true)
-- end

-- function M:OnTouchMoved(MyGeometry, InTouchEvent)
--     return self.Item:OnTouchMoved(MyGeometry, InTouchEvent)
-- end

-- function M:OnMouseCaptureLost()
--     return self.Item:OnMouseCaptureLost()
-- end



return M
