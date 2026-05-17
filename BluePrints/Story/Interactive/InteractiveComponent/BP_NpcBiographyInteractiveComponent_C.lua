require "UnLua"
local EMCache = require "EMCache.EMCache"

local LuaConst = require("EMLuaConst")
local BP_NpcBiographyInteractiveComponent_C = Class("BluePrints.Story.Interactive.InteractiveComponent.BP_InteractiveBaseComponent_C")

function BP_NpcBiographyInteractiveComponent_C:IsCanInteractive(PlayerActor)
    local Owner = self:GetOwner()
    if LuaConst.OpenComputeInteractive then
        return self:GetDistanceCheckResult()
            and self.BFaceToACheck(Owner, PlayerActor, self.InteractiveFaceAngle)
            and self:LockShowCheck(Owner)
            and self:ConditionCheck(Owner) and not Owner.bHidden
    else
        return self.DistanceCheck(Owner, PlayerActor, self.InteractiveDistance) 
            and self.BFaceToACheck(Owner, PlayerActor, self.InteractiveFaceAngle)
            and self:LockShowCheck(Owner)
            and self:ConditionCheck(Owner) and not Owner.bHidden
    end
end

function BP_NpcBiographyInteractiveComponent_C:GetUUID()
    return self:GetClass():GetName() .. tostring(self:GetOwner().NpcId)
end

function BP_NpcBiographyInteractiveComponent_C:SelectVailable()
    if not self:LoadBiographyData() then
        return
    end
    local Avatar = GWorld:GetAvatar()
    if Avatar == nil then return false end

    for Index, Data in pairs(self.BiographyDatas) do
        if Data["ConditionId"] == nil or Avatar:CheckCondition(Data["ConditionId"]) == true then
            self.BiographyData = Data
            return
        end
    end
    self.BiographyData = nil
end
 
function BP_NpcBiographyInteractiveComponent_C:LockShowCheck(Owner)
    self:SelectVailable()
    
    if self.BiographyData ~= nil then 
        return true
    elseif self.DatasLength > 0 then
        return true
    else
        return false
    end
end

function BP_NpcBiographyInteractiveComponent_C:BtnPressed(PlayerActor)
    if self:IsLocked() == false then
        self.UIName = "NpcBiography"

        self:StartInteractive(PlayerActor)
        local UIManager = UGameplayStatics.GetGameInstance(self):GetGameUIManager()
        local NpcBiographyUI = UIManager:LoadUINew("NpcBiography", 
            GText(self.BiographyData["NpcName"]),
            GText(self.BiographyData["NpcInformation"]),
            "",
            self.BiographyData["NpcAge"])
        if not NpcBiographyUI then return end

        -- 印象探查开始埋点
        local Owner = self:GetOwner()
        local NpcId = -1 
        if Owner then
            NpcId = Owner.NpcId or -1
        end
        local NpcBiographyId = self.BiographyData["NpcBiographyId"]
        NpcId = tostring(NpcId)
        NpcBiographyId = tonumber(NpcBiographyId)
        HeroUSDKSubsystem():UploadTrackLog_Lua("impression_exploration_start", { 
            npc_id = NpcId,
            npc_biography_id = NpcBiographyId
        })
        DebugPrint("@@@ 印象探查开始", NpcId, NpcBiographyId)

        -- 印象探查结束埋点
        NpcBiographyUI:BindOnClose(function()
            HeroUSDKSubsystem():UploadTrackLog_Lua("impression_exploration_end", { 
                npc_id = NpcId,
                npc_biography_id = NpcBiographyId
            })
            DebugPrint("@@@ 印象探查结束",NpcId,NpcBiographyId)
        end)
        --NpcBiographyUI.Text_AgeTitle:SetText(GText("NpcBiography_AgeText"))
        -- NpcBiographyUI.Text_NpcStoryTitle:SetText(GText(self.BiographyData["NpcName"]))
        -- NpcBiographyUI.Text_AgeNum:SetText(self.BiographyData["NpcAge"])--
        --NpcBiographyUI.Text_StoryDetail:SetText(GText(self.BiographyData["NpcInformation"]))
    end
end

function BP_NpcBiographyInteractiveComponent_C:OnClicked_Locked()
    local LastBiography = self.BiographyDatas[1]
    if LastBiography ~= nil then
        local LockedMsg = self.LockedMsg
        LockedMsg = LockedMsg or LastBiography["ProbeFailedTip"]
        UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText(LockedMsg))
    end
end

--function BP_NpcBiographyInteractiveComponent_C:Initialize(Initializer)
--end

-- function BP_NpcBiographyInteractiveComponent_C:GetInteractiveName()
-- 	return self.DisplayInteractiveName
-- end

function BP_NpcBiographyInteractiveComponent_C:ReceiveBeginPlay()
    BP_NpcBiographyInteractiveComponent_C.Super.ReceiveBeginPlay(self)

    local Data = DataMgr.CommonUIConfirm[self.CommonUIConfirmID]
    if Data == nil then return end

    self:LoadBiographyData()
    if self.NpcData ~= nil then
        local Language = CommonConst.SystemLanguage
        if Language == CommonConst.SystemLanguages.CN or Language == CommonConst.SystemLanguages.TC then
            self:SetInteractiveName(GText(Data.ConfirmText)..GText(self.NpcData["UnitName"]))
        elseif Language == CommonConst.SystemLanguages.EN then
            self:SetInteractiveName(GText(self.NpcData["UnitName"]).."'s "..GText(Data.ConfirmText))
        elseif Language == CommonConst.SystemLanguages.JP then
            self:SetInteractiveName(GText(self.NpcData["UnitName"]).."を"..GText(Data.ConfirmText))
        elseif Language == CommonConst.SystemLanguages.KR then
            self:SetInteractiveName(GText(self.NpcData["UnitName"]).." "..GText(Data.ConfirmText))
        end
    end
end

function BP_NpcBiographyInteractiveComponent_C:LoadBiographyData()
    local Owner = self:GetOwner()
    if self.NpcData == nil then
        self.NpcData = DataMgr.Npc[Owner.NpcId]
    end
    if self.NpcData == nil then
        return false
    end
    if self.BiographyDatas == nil then
        self.BiographyDatas = {}

        for Index = #self.NpcData.NpcBiographyId, 1, -1 do
            local Id = self.NpcData.NpcBiographyId[Index]
            table.insert(self.BiographyDatas, DataMgr.NpcBiography[Id])
        end
    end
    if self.BiographyDatas == nil then
        return false
    end
    if self.DatasLength == nil then
        self.DatasLength = #(self.BiographyDatas)
    end
    return true
end

function BP_NpcBiographyInteractiveComponent_C:ConditionCheck()
    local BiographyDatas = self.BiographyDatas

    local Avatar = GWorld:GetAvatar()
    if nil == Avatar then return false end
    
    if BiographyDatas then
        for _, BiographyData in ipairs(BiographyDatas) do
            local DispConditionId = BiographyData.DispConditionId

            if nil == DispConditionId or Avatar:CheckCondition(DispConditionId) then
                return true
            end
        end
    end
    return false
end

function BP_NpcBiographyInteractiveComponent_C:IsLocked()
    self:SelectVailable()

    if self:CheckForbiddenBySpecialQuest() then
        self:SetOverridenLockedMsg("QUEST_INSPECIALQUEST_MSG")
        return true
    else
        self:SetOverridenLockedMsg()
    end
    
    if self.BiographyData ~= nil then 
        return false
    elseif self.DatasLength > 0 then
        return true
    else
        return true
    end
end

function BP_NpcBiographyInteractiveComponent_C:SetOverridenLockedMsg(Msg)
    self.LockedMsg = Msg
end

function BP_NpcBiographyInteractiveComponent_C:IsForbidden()
    if BP_NpcBiographyInteractiveComponent_C.Super.IsForbidden(self) then
        return true
    end

    if self:CheckForbiddenBySpecialQuest() then
        self:SetOverridenFailMsg("QUEST_INSPECIALQUEST_MSG")
        return true
    else
        self:SetOverridenFailMsg()
    end

    return false
end


function BP_NpcBiographyInteractiveComponent_C:CheckForbiddenBySpecialQuest()
    local Avatar = GWorld:GetAvatar()
    if Avatar and Avatar.InSpecialQuest then 
        return true
    end
    return false
end

--function BP_NpcBiographyInteractiveComponent_C:ReceiveEndPlay()
--end

-- function BP_NpcBiographyInteractiveComponent_C:ReceiveTick(DeltaSeconds)
-- end

return BP_NpcBiographyInteractiveComponent_C
