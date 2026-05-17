require "UnLua"

--- @class NpcHeadUISubsystem : UNpcHeadUISubsystem
local NpcHeadUISubsystem = Class("BluePrints.Common.TimerMgr")

function NpcHeadUISubsystem:OnInitialize()
    self.EmojiDuration = 5
    self.EmojiTimer = {}
    if ChatController then
        ChatController:RegisterEvent(self, function(self, EventId, ...)
            if EventId == ChatCommon.EventID.RecvStickerInPubChannels then
                local Uid, EmojiPath = ...
                self:OnShowPlayerEmoji(Uid, EmojiPath)
            end
        end)
    end
end
--转移到C++
-- function NpcHeadUISubsystem:InitHeadWidgetComponent(Character)
--     if not IsValid(Character) then return end
--     local HeadWidgetComponent = Character.HeadWidgetComponent
--     if not IsValid(HeadWidgetComponent) then
--         local BPClass = self:GetHeadWidgetClass()
--         HeadWidgetComponent = Character:AddComponentByClass(BPClass, false, FTransform(), false)
--     end
--     if not IsValid(HeadWidgetComponent) then return end
--     if (type(Character.IsNPC) == "function" and Character:IsNPC()) 
--         -- 很丑陋的写法，但是CustomNpc身上的判定方式就是和Character身上判定Npc的方法同名（黑脸
--             or (type(Character.IsNPC) == "boolean" and Character.IsNPC) then
--         self:RegisterHeadWidgetComp(Character.NpcId, HeadWidgetComponent)
--         HeadWidgetComponent:InitSelfTransform("head", self.NpcHeight)
--     elseif Character.IsPlayer and Character:IsPlayer() then
--         HeadWidgetComponent:InitSelfTransform("", self.PlayerHeight)
--     elseif Character.IsPhantom and Character:IsPhantom() then
--         HeadWidgetComponent:InitSelfTransform("", self.PhantomHeight)
--     else
--         HeadWidgetComponent:InitSelfTransform("", self.DefaultHeight)
--     end
--     Character.HeadWidgetComponent = HeadWidgetComponent
--     return HeadWidgetComponent
-- end

-- function NpcHeadUISubsystem:GetHeadWidgetComponent(Character)
--     if not IsValid(Character) then return end
--     local HeadWidgetComponent = Character.HeadWidgetComponent
--     if not IsValid(HeadWidgetComponent) then 
--         HeadWidgetComponent = self:InitHeadWidgetComponent(Character)
--     end
--     return HeadWidgetComponent
-- end

function NpcHeadUISubsystem:OnNpcEndPlay_Lua(Npc)
end

function NpcHeadUISubsystem:OnDeinitialize()
    if ChatController then
        ChatController:UnRegisterEvent(self)
    end
end

function NpcHeadUISubsystem:OnShowPlayerEmoji(Uid, EmojiPath)
    local EMGameState = UE4.UGameplayStatics.GetGameState(self)

    local IsInDungeon = EMGameState and EMGameState:IsInDungeon()
    local Avatar = GWorld:GetAvatar()

    if (not IsInDungeon) and Avatar.Uid ~= Uid then
        return 
    end

    local Eid
    local Player
    if Avatar.Uid ~= Uid then
        local GameState = UE4.UGameplayStatics.GetGameState(self)
        for i, PlayerState in pairs(GameState.PlayerArray) do
            if PlayerState and PlayerState.Uid == Uid then
                Eid = PlayerState.Eid
                break
            end
        end
        -- local Member = TeamController:GetModel():GetTeamMember(Uid)
        -- if not Member then
        --     return
        -- end
        -- Eid = Member.Eid
        Player = Battle(self):GetEntity(Eid)
    else
        Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
        Eid = Player.Eid
    end

    if not Player then
        return 
    end

    local Timer = self.EmojiTimer[Eid]
    if Timer then
        self:RemoveTimer(Timer)
    end

    Player:StopEmoji()
    Player:PlayEmoji(EmojiPath)
    Timer = self:AddTimer(self.EmojiDuration, function()
        self.EmojiTimer[Eid] = nil
        Player:StopEmoji()
    end)
    self.EmojiTimer[Eid] = Timer
end

return NpcHeadUISubsystem
