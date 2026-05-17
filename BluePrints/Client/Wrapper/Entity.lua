local Class = _G.TypeClass
local IdManager = require "NetworkEngine.Common.IdManager"
local LogManager= require "NetworkEngine.Common.LogManager"


---@class ClientAvatarEntity
local AvatarEntity = Class("AvatarEntity")

function AvatarEntity:Init(eid, override)
	self.id = eid or IdManager.GenId()
	self.logger = LogManager:GenClientLogger(self.id, self.__Name__)
	self.is_destroyed = false
	self.is_override = false
	self.is_client_entity = true
	self.server_proxy = nil

	self.CallbackFuncs = {}
	self.CallbackId2RPCName = {}

	override = override or false
	GWorld.EntityManager:AddEntity(self.id, self, override)
end

function AvatarEntity:SetServerProxy(server_proxy)
	self.server_proxy = server_proxy
end

function AvatarEntity:SetOverrideFlag(flag)
	self.is_override = flag
end

function AvatarEntity:BecomePlayer()
	self:OnBecomePlayer()
end

function AvatarEntity:OnBecomePlayer()
end

function AvatarEntity:CallServerMethod(func_name, ...)
	if GWorld.IsForbidEntityMessage then
		return
	end

	local Args = {...}
    Args = RpcUtils.RevertArgs(Args)
	self.server_proxy:Send("EntityMessage", func_name, table.unpack(Args))
	self:RpcCache(func_name, ...)
end

function AvatarEntity:CallServer(func_name, callback, ...)
	local CallbackId = GWorld:GenCallbackId()
	self.CallbackFuncs[CallbackId] = callback
	self.CallbackId2RPCName[CallbackId] = func_name
	self:CallServerMethod(func_name, CallbackId, ...) 
end

function AvatarEntity:BindCallbackFunc(callback)
	local CallbackId = GWorld:GenCallbackId()
	self.CallbackFuncs[CallbackId] = callback
	return CallbackId
end

function AvatarEntity:LatentCallServer(func_name, ...)
	local CallbackId = GWorld:GenCallbackId()
	local LatentId = CallbackId
	self.CallbackFuncs[CallbackId] = self.LatentResume

	local Args = {...}
    Args = RpcUtils.RevertArgs(Args)

	self.server_proxy:LatentSend(LatentId, "EntityMessage", func_name, table.unpack(Args))
	return table.unpack(self.Latents[LatentId])
end 

function AvatarEntity:LatentResume(LatentId, ...)
	-- self.server_proxy.GateClientBase.ClientChannel.UTcpClient::CppLatentResume
	self.Latents[LatentId] = {...}
	self.server_proxy.stub:CppLatentResume(LatentId)
	return
end

function AvatarEntity:CallClientCallback(CallbackId, ...)
	local callback = self.CallbackFuncs[CallbackId]
	if callback then
		callback(...)
	end
	self:_TryProcessBlockUIMark(CallbackId)
	self.CallbackFuncs[CallbackId] = nil
end

function AvatarEntity:_TryProcessBlockUIMark(CallbackId)
	local RPCName = self.CallbackId2RPCName[CallbackId]
	if RPCName and self.BlockUIMarks then 
		if self.BlockUIMarks[RPCName] then
			UIManager(GWorld.GameInstance):_BlockAllUIInput(false, RPCName)
			DebugPrint(LXYTag, "Decorator:BlockAllUIInput Unlock",RPCName)
		end
		self.BlockUIMarks[RPCName] = nil
	end
	self.CallbackId2RPCName[CallbackId] = nil
end

function AvatarEntity:Destroy()
	if self.is_destroyed then
		return
	end
	self:OnDestroy()
	self.is_destroyed = true
end

function AvatarEntity:OnDestroy()
	self:SaveRPCCalls()
end

--------------------------------------------- 测试 ---------------------------------------------

function AvatarEntity:GetSerializeOnline()
	return require "NetworkEngine.Bot.OnlineRpc.SerializeOnlineRpc"
end

function AvatarEntity:RpcCache(FuncName, ...)
	-- local SerializeOnline = self:GetSerializeOnline()
	-- if not SerializeOnline then return end
	-- if FuncName == "RequestEnterOnline" then
	-- 	SerializeOnline.StartRpcCache()
	-- end
	-- if not SerializeOnline.GetStartRpcCacheState() then
	-- 	return
	-- end
	-- SerializeOnline.log_rpc_call(FuncName, ...)
	-- if FuncName == "RequestLeaveOnline" then
	-- 	SerializeOnline.CloseRpcCache()
	-- 	SerializeOnline.SaveRPCCalls()
	-- end
end
function AvatarEntity:SaveRPCCalls()
	-- local SerializeOnline = self:GetSerializeOnline()
	-- if not SerializeOnline then return end
	-- SerializeOnline.CloseRpcCache()
	-- SerializeOnline.SaveRPCCalls()
end
--------------------------------------------- 测试 ---------------------------------------------


return {AvatarEntity = AvatarEntity}
