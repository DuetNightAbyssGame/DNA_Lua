local Component = {}

function Component:MarkWebJumped(JumpEventId,InCallBack)
    self.logger.info("MarkWebJumped", JumpEventId)
    local function Cb(ErrCode)
        DebugPrint("MarkWebJumped",ErrorCode:Name(ErrCode))
        if InCallBack then
            InCallBack(ErrCode)
        end
    end
	self:CallServer("MarkWebJumped", Cb, JumpEventId) 
end

function Component:GetWebJumpReward(JumpEventId,InCallBack)
    self.logger.info("GetWebJumpReward", JumpEventId)
    local function Cb(ErrCode, RewardRet)
        DebugPrint("GetWebJumpReward",ErrorCode:Name(ErrCode))
        if InCallBack then
            InCallBack(ErrCode, RewardRet)
        end
    end
	self:CallServer("GetWebJumpReward", Cb, JumpEventId) 
end

return Component