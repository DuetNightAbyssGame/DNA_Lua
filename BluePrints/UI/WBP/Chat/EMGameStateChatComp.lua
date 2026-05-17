
local ChatController = require "BluePrints.UI.WBP.Chat.ChatController"

--处理聊天消息广播的EMGameState组件
---@type BP_EMGameState_C
local Component = {}

---@param Messages TArray<FChatMessageInfo>
function Component:MulticastChatMessage_Lua(Messages)
    local MyPlayer = GWorld:GetMainPlayer()
    ---@param DsMessage FChatMessageInfo
    for _, DsMessage in pairs(Messages) do
        if DsMessage.Eid == MyPlayer.Eid then
            ChatController:RecvChatToTeam(DsMessage.Content)
        else
            local OtherDs = self:GetPlayerState(DsMessage.Eid)
            local Message = {
                Uid = DsMessage.Eid, --@note Ds通信的聊天，消息记录的Uid为PlayerState的Eid
                Content = DsMessage.Content,
                Time = DsMessage.TimeStamp,
                Sender = {
                    Uid = OtherDs.Uid,
                    Nickname = OtherDs.PlayerName,
                    Level = OtherDs.PlayerLevel,
                    HeadIconId = OtherDs.HeadIconId,
					HeadFrameId = OtherDs.HeadFrameId,
                    IsOnline = true,
                    IsInDungeon = true,
                },
                Type = CommonConst.MESSAGE_TYPE_TEAM,
                ChannelType = ChatCommon.ChannelDef.InTeam,
            }
            ChatController:HandleChatMessage(Message)
        end
    end
end


return Component