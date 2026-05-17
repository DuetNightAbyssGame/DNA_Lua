local Component = {}

function Component:SetDoubleModDropFirst()
    self.logger.info("SetDoubleModDropFirst")
    local function Cb(ErrCode,Ret)
        DebugPrint("SetDoubleModDropFirst",ErrorCode:Name(ErrCode))
    end
	self:CallServer("SetDoubleModDropFirst", Cb)
end

return Component