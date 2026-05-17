--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Map_AgentItem_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

local AgentEnum = {
    Dispatching = 2,    --派遣中
    NotDispatched = 3,    --未派遣
}

function M:Initialize(Initializer)
    self.Super.Initialize(self)
    self.IsChoose = false
    --self.Click = false
    self.Owner = nil 
end


function M:Construct()
    self.Btn_Minus.Button_Area.OnClicked:Add(self, self.OnClickMinus)
    self.Btn_Click.OnClicked:Add(self, self.OnClick)
    self.Btn_Click.OnPressed:Add(self, self.OnPressed)
    self.Btn_Click.OnReleased:Add(self, self.OnReleased)
    self.Btn_Click.OnHovered:Add(self, self.OnHovered)
    self.Btn_Click.OnUnhovered:Add(self, self.OnUnhovered)

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
        self.WS_Type:SetActiveWidgetIndex(1)
        return
    end
    Content.UI = self
    self.Content = Content
    local IsChoose = self.Content.Parent.ChooseAgentList[self.Uuid] and true or false
    self.Content.IsChoose = IsChoose
    self.State = Content.State
    self:SetCharInfo(self.Id)
    self:SetCharAbility(self.Uuid)
    self:SetCharState()
end

function M:BP_OnEntryReleased()
    self.Content.UI = nil
end


function M:OnClick()
    if self.Content.Parent ~= nil then     
        AudioManager(self):PlayUISound(self, "event:/ui/common/team_avatar_click", "", nil)
        self.Content.Parent:OnListItemClicked(self.Content)
    end
end

function M:OnClickMinus()
    if self.Content.Parent ~= nil then
        self.Content.Parent:OnListItemClicked(self.Content)
    end
end

function M:SetCharInfo(Id)
    local Path = DataMgr.Char[Id].Icon
    if Path == nil then
        DebugPrint(Id.."图片路径不存在")
        return
    end
    local IconDynaMaterial = self.Icon_Head:GetDynamicMaterial()
    if(IconDynaMaterial)then
        IconDynaMaterial:SetTextureParameterValue("IconMap",LoadObject(Path))   
    end
    --self.Icon_Head:SetBrushResourceObject(LoadObject(Path))
    self.Text_Name:SetText(GText(DataMgr.Char[Id].CharName))
end

function M:SetCharState()
    self:StopAllAnimations()
    if self.State == AgentEnum.Dispatching then
        self.Text_Dispatching:SetText(GText("UI_Disptach_Agent_State_Doing"))
        self:PlayAnimation(self.Dispatching)
    elseif self.State == AgentEnum.NotDispatched then
        self.Text_Free:SetText(GText("UI_Disptach_Agent_State_Release"))
        self:PlayAnimation(self.Normal)
    end
    if self.Content.IsChoose == true then
        self:StopAllAnimations()
        self:PlayAnimation(self.Select)
        self.Text_Selected:SetText(GText("UI_Disptach_Chosen"))
    end


end

function M:SetCharAbility(UuId)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    self.WBox_Ability:ClearChildren()
    local Path = '/Game/UI/WBP/Map/Widget/Dispatch/WBP_Map_Ability_S.WBP_Map_Ability_S'
    local Char = Avatar.Chars[CommonUtils.Str2ObjId(UuId)]
    local Tag = Char:GetCurrentUnlockDispatchTag()
    for Type, Count in pairs(Tag) do
        for i = 1, Count do          
            local AbilityItem = UIManager(self):CreateWidget(Path)
            if AbilityItem ~= nil then
                local IconPath = DataMgr.CharDispatchTag[Type].Icon
                local Icon = LoadObject(IconPath)
                AbilityItem.Icon_Ability:SetBrushResourceObject(Icon)
                self:SetColor(AbilityItem, Type)
                self.WBox_Ability:AddChildToWrapBox(AbilityItem)
            end
        end      
    end
end

function M:SetColor(Item, Type)
    if Type == "Battle" then
        Item.BG:SetColorAndOpacity(Item.Color_BG_Red)
        Item:PlayAnimation(Item.Active)
    elseif Type == "Collect" or Type == "Mine" or Type == "Fish" or Type == "Pet" then
        Item.BG:SetColorAndOpacity(Item.Color_BG_Blue)
        Item:PlayAnimation(Item.Active)
    elseif Type == "Workaholic" or Type == "Rigorous" or Type == "Skilled" or Type == "Lucky" then
        --Item.BG:SetColorAndOpacity(Item.Color_BG_Green)
        Item:PlayAnimation(Item.Special)
    else
        Item.BG:SetColorAndOpacity(Item.Color_BG_Green)
        Item:PlayAnimation(Item.Active)
    end
end

-- function M:PlayClickAni()
--     -- if self.IsChoose == false then
--     --     self.Click = true
--     --     self:PlayAnimation(self.Click)
--         DebugPrint("lkkkkkkkUnhoveredUnhoveredUnhovered")
--     --end

-- end
function M:OnUnhovered()
    if self.Content.IsChoose then
        return
    end
    self.BG:OnCellUnhovered()
end
function M:OnPressed()
    if self.Content.IsChoose then
        return
    end
    self.BG:OnCellPressed()
end
function M:OnReleased()
    if self.Content.IsChoose or self.State == AgentEnum.Dispatching then
        return
    end
    self.BG:OnCellReleased()
end

function M:OnHovered()
    if self.Content.IsChoose then
        return
    end
    self.BG:OnCellHovered()
end



-- function M:OnAddedToFocusPath(InFocusEvent)
--     DebugPrint("lkkkkkOnAddedToFocusPathOnAddedToFocusPath")
-- end

-- function M:OnRemovedFromFocusPath(InFocusEvent)
--     DebugPrint("lkkkkkOnRemovedFromFocusPathOnRemovedFromFocusPathOnRemovedFromFocusPath")
-- end


return M
