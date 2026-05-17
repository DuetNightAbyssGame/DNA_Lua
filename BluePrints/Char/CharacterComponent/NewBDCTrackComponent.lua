local CommonUtils = require  "Utils.CommonUtils"
local TimeUtils = require "Utils.TimeUtils"

---@type BP_PlayerCharacter_C
local Component = {}

function Component:BuildCommonTrackInfo(PlayerAvatar)
    local TrackInfo = {}
    TrackInfo.bones_id = self.InfoForInit.RoleId
    TrackInfo.map_id = WorldTravelSubsystem():GetCurrentSceneId()
    -- TrackInfo["#role_key"] = CommonUtils.ObjId2Str(PlayerAvatar.Eid)
    TrackInfo.Position = tostring(self:K2_GetActorLocation())
    return TrackInfo
end

function Component:TickBigWorldPathInfo()
    if not self.bIsInBigWorld then
        return
    end
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        if not self.UploadBDCTrackInfo.BigWorldPathInfo then
            self.UploadBDCTrackInfo.BigWorldPathInfo = {}
        end
        table.insert(self.UploadBDCTrackInfo.BigWorldPathInfo, { map_id = Avatar.CurrentRegionId, position = tostring(self:K2_GetActorLocation()), trigger_time = TimeUtils.NowTime() })
    end
end

-- function Component:RecordSkillUseCount(SkillId)
--     if not self.UploadBDCTrackInfo then
--         return
--     end
--     if not self:IsMainPlayer() then
--         return
--     end
--     -- local PlayerAvatar = GWorld:GetAvatar()
--     -- if not PlayerAvatar then
--     --     return
--     -- end
--     if not self.UploadBDCTrackInfo.SkillUseCount then
--         self.UploadBDCTrackInfo.SkillUseCount = {}
--     end
--     if not self.UploadBDCTrackInfo.SkillUseCount[SkillId] then
--         self.UploadBDCTrackInfo.SkillUseCount[SkillId] = {}
--         self.UploadBDCTrackInfo.SkillUseCount[SkillId].skill_id = SkillId
--         self.UploadBDCTrackInfo.SkillUseCount[SkillId].weapon_id = IsValid(self.UsingWeapon) and self.UsingWeapon.WeaponId or 0
--         self.UploadBDCTrackInfo.SkillUseCount[SkillId].weapon_type = IsValid(self.UsingWeapon) and self.UsingWeapon:GetWeaponType() or 0
--         -- self.UploadBDCTrackInfo.SkillUseCount[SkillId].role_level = self:GetAttr("Level")
--         -- self.UploadBDCTrackInfo.SkillUseCount[SkillId].bones_id = self.InfoForInit.RoleId
--         -- self.UploadBDCTrackInfo.SkillUseCount[SkillId].bones_level = self:GetAttr("Level")
--         self.UploadBDCTrackInfo.SkillUseCount[SkillId].use_number = 0
--         -- self.UploadBDCTrackInfo.SkillUseCount[SkillId].pve_id = GWorld.SceneId
--     end
--     self.UploadBDCTrackInfo.SkillUseCount[SkillId].use_number = self.UploadBDCTrackInfo.SkillUseCount[SkillId].use_number + 1

--     if SkillId == self:GetSkillByType(UE.ESkillType.Condemn) then
--         if not self.UploadBDCTrackInfo.CondemnSkillCount then
--             -- self.UploadBDCTrackInfo.CondemnSkillCountInfo = self:BuildCommonTrackInfo(PlayerAvatar)
--             self.UploadBDCTrackInfo.CondemnSkillCount = 0
--         end
--         self.UploadBDCTrackInfo.CondemnSkillCount = self.UploadBDCTrackInfo.CondemnSkillCount + 1
--     end
-- end

-- function Component:RecordWeaponUseCount()
--     if not self.UploadBDCTrackInfo then
--         return
--     end
--     if not self:IsMainPlayer() then
--         return
--     end
--     if not IsValid(self.UsingWeapon) then
--         return
--     end
--     if not self.UploadBDCTrackInfo.WeaponUseCount then
--         self.UploadBDCTrackInfo.WeaponUseCount = {}
--     end
--     if not self.UploadBDCTrackInfo.WeaponUseCount[self.UsingWeapon.WeaponId] then
--         self.UploadBDCTrackInfo.WeaponUseCount[self.UsingWeapon.WeaponId] = {}
--         self.UploadBDCTrackInfo.WeaponUseCount[self.UsingWeapon.WeaponId].weapon_id = self.UsingWeapon.WeaponId
--         -- self.UploadBDCTrackInfo.WeaponUseCount[self.UsingWeapon.WeaponId].weapon_level = self.UsingWeapon:GetAttr("Level")
--         self.UploadBDCTrackInfo.WeaponUseCount[self.UsingWeapon.WeaponId].weapon_type = self.UsingWeapon:GetWeaponType()
--         -- self.UploadBDCTrackInfo.WeaponUseCount[self.UsingWeapon.WeaponId].role_level = self:GetAttr("Level")
--         -- self.UploadBDCTrackInfo.WeaponUseCount[self.UsingWeapon.WeaponId].bones_id = self.InfoForInit.RoleId
--         -- self.UploadBDCTrackInfo.WeaponUseCount[self.UsingWeapon.WeaponId].bones_level = self:GetAttr("Level")
--         -- self.UploadBDCTrackInfo.WeaponUseCount[self.UsingWeapon.WeaponId].pve_id = GWorld.SceneId
--     end 
--     self.UploadBDCTrackInfo.WeaponUseCount[self.UsingWeapon.WeaponId].usage_count = 1 or self.UploadBDCTrackInfo.WeaponUseCount[self.UsingWeapon.WeaponId].UseCount + 1
-- end

-- ---@param DamageEvent BP_DamageStruct_C
-- function Component:RecordDamageTrack(DamageEvent)
--     if not self.UploadBDCTrackInfo then
--         return
--     end
--     if not self:IsMainPlayer() then
--         return
--     end
--     local PlayerAvatar = GWorld:GetAvatar()
--     if not PlayerAvatar then
--         return
--     end
--     if not self.UploadBDCTrackInfo.DamageTrack then
--         self.UploadBDCTrackInfo.DamageTrack = {}
--     end
--     local NewTrack = self:BuildCommonTrackInfo(PlayerAvatar)
--     local Source = Battle(self):GetEntity(DamageEvent.SourceEid)
--     if IsValid(Source) then
--         NewTrack.AttackerID = Source.UnitId or "null"
--         if Source.UnitName then
--             NewTrack.AttackerName = Source.UnitName
--         elseif Source.InfoForInit and Source.InfoForInit.UnitName then
--             NewTrack.AttackerName = Source.InfoForInit.UnitName
--         else
--             NewTrack.AttackerName = "null"
--         end
--     else
--         NewTrack.AttackerID = "null"
--         NewTrack.AttackerName = "null"
--     end
--     local TotalDamageValue = DamageEvent.TrueValue
--     NewTrack.damage_value = TotalDamageValue
--     NewTrack.source_skillid = DamageEvent.SkillId or "null"
--     table.insert(self.UploadBDCTrackInfo.DamageTrack, NewTrack)
-- end

function Component:TrackJumpCountInfo()
    if not self.UploadBDCTrackInfo then
        return
    end
    if not self:IsMainPlayer() then
        return
    end
    if not self.UploadBDCTrackInfo.JumpCount then
        -- self.UploadBDCTrackInfo.JumpCountInfo = self:BuildCommonTrackInfo(PlayerAvatar)
        self.UploadBDCTrackInfo.JumpCount = 0
    end
    self.UploadBDCTrackInfo.JumpCount = self.UploadBDCTrackInfo.JumpCount + 1
end

function Component:TrackJumpSecondCountInfo()
    if not self.UploadBDCTrackInfo then
        return
    end
    if not self:IsMainPlayer() then
        return
    end
    -- local PlayerAvatar = GWorld:GetAvatar()
    -- if not PlayerAvatar then
    --     return
    -- end
    if not self.UploadBDCTrackInfo.JumpSecondCount then
        -- self.UploadBDCTrackInfo.JumpSecondCountInfo = self:BuildCommonTrackInfo(PlayerAvatar)
        self.UploadBDCTrackInfo.JumpSecondCount = 0
    end
    self.UploadBDCTrackInfo.JumpSecondCount = self.UploadBDCTrackInfo.JumpSecondCount + 1
end

function Component:TrackJumpWallCountInfo()
    if not self.UploadBDCTrackInfo then
        return
    end
    if not self:IsMainPlayer() then
        return
    end
    -- local PlayerAvatar = GWorld:GetAvatar()
    -- if not PlayerAvatar then
    --     return
    -- end
    if not self.UploadBDCTrackInfo.JumpWallCount then
        -- self.UploadBDCTrackInfo.JumpWallCountInfo = self:BuildCommonTrackInfo(PlayerAvatar)
        self.UploadBDCTrackInfo.JumpWallCount = 0
    end
    self.UploadBDCTrackInfo.JumpWallCount = self.UploadBDCTrackInfo.JumpWallCount + 1
end

-- function Component:TrackFlyShootCountInfo()
--     if not self.UploadBDCTrackInfo then
--         return
--     end
--     if not self:IsMainPlayer() then
--         return
--     end
--     -- local PlayerAvatar = GWorld:GetAvatar()
--     -- if not PlayerAvatar then
--     --     return
--     -- end
--     if not self.UploadBDCTrackInfo.FlyShootCount then
--         -- self.UploadBDCTrackInfo.FlyShootCountInfo = self:BuildCommonTrackInfo(PlayerAvatar)
--         self.UploadBDCTrackInfo.FlyShootCount = 0
--     end
--     self.UploadBDCTrackInfo.FlyShootCount = self.UploadBDCTrackInfo.FlyShootCount + 1
-- end

function Component:TrackDefeatedCountInfo()
    if not self.UploadBDCTrackInfo then
        return
    end
    if not self:IsMainPlayer() then
        return
    end
    local PlayerAvatar = GWorld:GetAvatar()
    if not PlayerAvatar then
        return
    end
    if not self.UploadBDCTrackInfo.DefeatedCountInfo then
        self.UploadBDCTrackInfo.DefeatedCountInfo = self:BuildCommonTrackInfo(PlayerAvatar)
        self.UploadBDCTrackInfo.DefeatedCountInfo.defeated_count = 0
    end
    self.UploadBDCTrackInfo.DefeatedCountInfo.defeated_count = self.UploadBDCTrackInfo.DefeatedCountInfo.defeated_count + 1
end

function Component:TrackDeadInfo()
    if not self.UploadBDCTrackInfo then
        return
    end
    if not self:IsMainPlayer() then
        return
    end
    -- local PlayerAvatar = GWorld:GetAvatar()
    -- if not PlayerAvatar then
    --     return
    -- end
    if not self.UploadBDCTrackInfo.DeadCount then
        self.UploadBDCTrackInfo.DeadCount = 0
    end
    -- local NewTrack = self:BuildCommonTrackInfo(PlayerAvatar)
    -- NewTrack.role_level = self:GetAttr("Level")
    self.UploadBDCTrackInfo.DeadCount = self.UploadBDCTrackInfo.DeadCount + 1  
end

function Component:TrackRecoverInfo()
    if not self.UploadBDCTrackInfo then
        return
    end
    if not self:IsMainPlayer() then
        return
    end
    -- local PlayerAvatar = GWorld:GetAvatar()
    -- if not PlayerAvatar then
    --     return
    -- end
    if not self.UploadBDCTrackInfo.RecoveryCount then
        self.UploadBDCTrackInfo.RecoveryCount = 0
    end
    self.UploadBDCTrackInfo.RecoveryCount = self.UploadBDCTrackInfo.RecoveryCount + 1
    -- local NewTrack = self:BuildCommonTrackInfo(PlayerAvatar)
    -- NewTrack.role_level = self:GetAttr("Level")
    -- table.insert(self.UploadBDCTrackInfo.RecoveryInfo, NewTrack)
end

function Component:TrackSkipTalkInfo(TalkTaskData)
    if not self.UploadBDCTrackInfo then
        return
    end

    local PlayerAvatar = GWorld:GetAvatar()
    if not PlayerAvatar then
        return
    end

    local NewTrack = self:BuildCommonTrackInfo(PlayerAvatar)
    NewTrack.role_Level = PlayerAvatar.Level
    NewTrack.char_id = PlayerAvatar:GetCurrentCharConfigID()
    NewTrack.talk_path = TalkTaskData.FilePath
    NewTrack.talk_name = TalkTaskData.TalkName
    NewTrack.talk_type = TalkTaskData.TalkType
    NewTrack.talk_id = TalkTaskData.Key
    NewTrack.dialogue_id = TalkTaskData.FirstDialogueId

    HeroUSDKSubsystem(self):UploadTrackLog_Lua("skip_talk", NewTrack)
end

function Component:TraceBDCUploadInfo(EventName, Properties)
    if not self.NewUploadBDCTrackInfo then
        self.NewUploadBDCTrackInfo = {}
    end
    if not self.NewUploadBDCTrackInfo[EventName] then
        self.NewUploadBDCTrackInfo[EventName] = {}
    end
    table.insert(self.NewUploadBDCTrackInfo[EventName], Properties)
end

return Component