--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Npc_Name_C
local WBP_NPC_Name_C = Class({"BluePrints.Common.TimerMgr","BluePrints.UI.BP_EMUserWidget_C"})

function WBP_NPC_Name_C:Initialize(Initializer)
    --DebugPrint("@@@ Initialize W_NPC_Name")
    self.ParentHeadWidget = nil
    self.bIsEnabled_Name = false
    self.PosInitialized = false
    self.Style = nil
    self.PlayerNumber = nil
end

function WBP_NPC_Name_C:Init(ParentHeadWidget)

    self:SetRenderOpacity(0)
    if not self.PosInitialized then
        self:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.PosInitialized = true
    end
    self.ParentHeadWidget = ParentHeadWidget
    self.bIsEnabled_Name = false
    -- self.Style = nil
    -- self.PlayerNumber = nil
end

function WBP_NPC_Name_C:OnEnabled(Name, Style, PlayerNumber)
    if self.bIsEnabled_Name then
        return
    end
    --DebugPrint("WBP_NPC_Name_C:OnEnabled", Name, Style, PlayerNumber)
    --DebugPrint("@@@ OnEnabled Name",self.bIsEnabled_Name,Npc:GetName(), DataMgr.Npc[Npc.NpcId].UnitName, self.NpcName,self.ParentHeadWidget)
    Style = Style or "Default"
    self:SwitchStyle(Style)
    self:SetPlayerNumber(PlayerNumber)
    self.bIsEnabled_Name = true
    self.NameTxt:SetText(Name)
    self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    EMUIAnimationSubsystem:EMStopAnimation(self.ParentHeadWidget, self.ParentHeadWidget.Name_Out)
    EMUIAnimationSubsystem:EMPlayAnimation(self.ParentHeadWidget, self.ParentHeadWidget.Name_In)
    -- self.ParentHeadWidget:PlayAnimation(self.ParentHeadWidget.Name_In)
end

function WBP_NPC_Name_C:SwitchStyle(Style)
    --if self.Style == Style then return end
    self.Style = Style
    local LoadMaterial = nil
    if Style == "Phantom" then
        LoadMaterial = self.PlayerMaterial
    elseif Style == "Player" then
        LoadMaterial = self.DefaultMaterial
    else
        local Font = self.NameTxt.Font
        Font.FontMaterial = nil
        self.NameTxt:SetFont(Font)
        return
    end
    UResourceLibrary.LoadObjectAsync(self, tostring(LoadMaterial), {
        self, 
        function(obj, Material)
            if not IsValid(obj) then return end
            if Style ~= self.Style then return end
            local Font = self.NameTxt.Font
            Font.FontMaterial = Material
            self.NameTxt:SetFont(Font)
        end
    })
end

function WBP_NPC_Name_C:SetPlayerNumber(PlayerNumber)
    if PlayerNumber == 0 then PlayerNumber = nil end
    --if self.PlayerNumber == PlayerNumber then return end
    self.PlayerNumber = PlayerNumber
    if not PlayerNumber then 
        self.Group_TeamSign:SetVisibility(UIConst.VisibilityOp.Collapsed)
        return
    end
    self.Group_TeamSign:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    local UpdateTeamTag = function(TeamTag)
        if not IsValid(TeamTag) then return end
        if not self.PlayerNumber then return end
        local Number = self.PlayerNumber
        TeamTag:Init(false, Number, nil)
    end
    if self.Group_TeamSign:HasAnyChildren() then
        local TeamTag = self.Group_TeamSign:GetChildAt(0)
        if IsValid(TeamTag) then 
            UpdateTeamTag(TeamTag)
            return 
        end
        self.Group_TeamSign:ClearChildren()
    end
    -- RunAsyncTask(self, "SetPlayerNumber", function(CoroutineObj)
    --     local TeamTag = UIManager(self):CreateWidgetAsync("WBP_NPC_Name_Tag", CoroutineObj,
    --         tostring(self.NameTagReference))
    --     DebugPrint("WBP_NPC_Name_C:SetPlayerNumber", TeamTag)
    --     if not IsValid(self) then return end
    --     if (TeamTag) then
    --         self.Group_TeamSign:AddChild(TeamTag)
    --         UpdateTeamTag(TeamTag)
    --     end
    -- end)
    --DebugPrint("WBP_NPC_Name_C:SetPlayerNumber",  self.NameTagReference)
    UIManager(self):CreateWidgetAsync("WBP_NPC_Name_Tag", function(TeamTag)
        if not IsValid(self) then return end
        if (TeamTag) then
            self.Group_TeamSign:AddChild(TeamTag)
            UpdateTeamTag(TeamTag)
        end
    end,tostring(self.NameTagReference))
end


function WBP_NPC_Name_C:OnDisabled()
    if not self.bIsEnabled_Name then
        return
    end
    --DebugPrint("@@@ OnDisabled Name",self.bIsEnabled_Name,self,self.ParentHeadWidget)
    self.bIsEnabled_Name = false
    -- self.ParentHeadWidget:StopAllAnimations()
    EMUIAnimationSubsystem:EMStopAnimation(self.ParentHeadWidget, self.ParentHeadWidget.Name_In)
    EMUIAnimationSubsystem:EMPlayAnimation(self.ParentHeadWidget, self.ParentHeadWidget.Name_Out)
    -- self.ParentHeadWidget:PlayAnimation(self.ParentHeadWidget.Name_Out)
end

return WBP_NPC_Name_C
