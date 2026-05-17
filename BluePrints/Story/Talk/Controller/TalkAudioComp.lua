
---@class TalkAudioComp_C
local TalkAudioComp_C = {}

local ETalkAudioState = {
	Stop = "Stop",
	Play = "Play",
	Pause = "Pause"
}

-- 加载音频资源的代理类 FPlayAudioProxy
local FPlayAudioProxy = {}
FPlayAudioProxy.New = function(AssetPaths, OnComplete)
	local Obj = setmetatable({}, {
		__index = FPlayAudioProxy
	})
	Obj.bIsPaused = false 	--是否加载途中暂停
	Obj.bIsReady = false  	--是否加载完毕
	Obj.bIsValid = true		--是否已失效
	Obj.OnComplete = OnComplete
	Obj:Load(AssetPaths)
	return Obj
end

function FPlayAudioProxy:Load(AssetPaths)
	local LoadedCount = 0
	local TotalToLoad = #AssetPaths
	if TotalToLoad == 0 then
		self.bIsReady = true
		if self.OnComplete then self.OnComplete() end
		self:Clear()
		return
	end
	local GameInstance = GWorld.GameInstance
	for _, Path in pairs(AssetPaths) do
		UResourceLibrary.LoadObjectAsync(GameInstance, Path, {GameInstance, function(_, Asset)
			if(not self or not self.bIsValid) then return end
			LoadedCount = LoadedCount + 1
			if (LoadedCount < TotalToLoad) then return end
			self.bIsReady = true
			if (self.bIsReady and not self.bIsPaused) then
				if self.OnComplete then self.OnComplete() end
				self:Clear()
			end
		end})
	end
end

function FPlayAudioProxy:Clear()
	self.bIsValid = false
end

function FPlayAudioProxy:Pause()
	if(not self.bIsValid or self.bPause) then return end
	self.bIsPaused = true
end

function FPlayAudioProxy:Resume()
	if(not self.bIsValid or not self.bPause) then return end
	self.bIsPaused = false
	if (self.bIsReady) then
		if self.OnComplete then self.OnComplete() end
		self:Clear()
	end
end
------- FPlayAudioProxy -------

TalkAudioComp_C.New = function()
	---@type TalkActionComp_C
	local Obj = setmetatable({}, {
		__index = TalkAudioComp_C
	})
	TalkAudioComp_C:SetAudioState(ETalkAudioState.Stop)
	return Obj
end

---@param VoiceName string
---@param SoundHandle string
---@param ExtraInfo table
---@param Callback table
---@param bNoWait boolean
---@param bForceOral boolean
---@param bIsAttachActor boolean
---@param bPauseResume boolean
function TalkAudioComp_C:PlayAudio(VoiceName, SrcActor, OriginalCallback, ExtraInfo, bIsAttachActor, 
				SoundHandle, OverrideAttachActor, bPauseResume, bNoWait)
	local GameInstance = GWorld.GameInstance
	local AudioManager = AudioManager(GameInstance)

	local Callback = function()
		if not self.bCallbackExecuted then
			self.bCallbackExecuted = true
			if OriginalCallback then
				OriginalCallback()
			end
		end
	end

	if bPauseResume then
		-- 当暂停恢复，并且语音已经开始播放时，无需重新播放
		if not AudioManager:IsSoundStoped_CPP(self.sound_event_instance) then
			self.SoundFinishCallback = Callback
			return
		end
	end
	--确保上个Audio停止后，再对SoundFinishCallback重新赋值
	self:StopVOSound()
	self.bCallbackExecuted = false
	self.SoundFinishCallback = Callback

	if not VoiceName then
		if (Callback) then Callback() end
		return
	end
	self.PauseEventVolume = nil
	local ExtraInfo = ExtraInfo or {}
	self.ExtraInfo = ExtraInfo
	local AssetPaths = self:GetAssetPaths(AudioManager, VoiceName, ExtraInfo.ExStoryInfo)
	if not AssetPaths or (#AssetPaths == 0) then
		DebugPrint(string.format("TalkAudioComp_C:Error, VoiceName: %s 的音频资源不存在", VoiceName))
		if (Callback) then Callback() end
		self.ExtraInfo = nil
		return
	end
	self:ClearPlayAudioProxy()

	-- 加载完成回调
	local OnComplete = function()
		self.bStopSoundWhenClear = true
		local VoiceActor = SrcActor
		local AttachActor = OverrideAttachActor or SrcActor
		local bIsPlay2D = not bIsAttachActor
		if (bIsPlay2D) then
			AttachActor = UE4.UGameplayStatics.GetPlayerController(AudioManager, 0)
		end
		if (not IsValid(AttachActor)) then
			UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.Talk, "对话音频播放失败：AttachActor为空", string.format("绑定Actor为空, 请检查SpeakNpc是否正常注册, VoiceName: %s", VoiceName))
			if (Callback) then Callback() end
			return
		end
		self.AttachActor = AttachActor
		local EventKey = self:GetEventKey(SoundHandle or "VO")
		local SoundEventInstance = self:PlaySoundWithOral(AudioManager, VoiceName, VoiceActor, bIsAttachActor, 
			ExtraInfo.ExStoryInfo, ExtraInfo.DisableMouth)
		self.sound_event_instance = SoundEventInstance
	end

	-- 代理类内部异步加载音频资源
	self.PlayAudioProxy = FPlayAudioProxy.New(AssetPaths, OnComplete)

	if bNoWait then
		if (Callback) then Callback() end
	end
end

function TalkAudioComp_C:PlaySoundWithOral(AudioManager, VoiceName, VoiceActor, bIsAttached, ExStoryInfo, DisableMouth) 
	local AttachedActor = VoiceActor
	local bIsPlay2D = not bIsAttached
	if (bIsPlay2D) then
		AttachedActor = UE4.UGameplayStatics.GetPlayerController(AudioManager, 0)
	end
	local GameInstance = GWorld.GameInstance
	local RealEventPath, SelectKey, OralPath, EventExist = AudioManager:GetEventData(VoiceName, ExStoryInfo)
	local PlayStruct = FPlayFMODSoundStruct()
	DebugPrint("TalkAudioComp_C:PlaySoundWithOral", RealEventPath, SelectKey, bIsPlay2D, AttachedActor:GetName())
	PlayStruct.FMODEvent = AudioManager:GetFMODEventByPath_Sync(RealEventPath)
	PlayStruct.EventKey = self:GetEventKey()
	PlayStruct.bStopWhenAttachedToDestoryed = true
	PlayStruct.bPlayAs2D = bIsPlay2D
	PlayStruct.SelectKey = SelectKey
	PlayStruct = UE4.UAudioManager.SetObjectToFPlayFMODSoundStruct(PlayStruct, AttachedActor)
	PlayStruct.DynamicSoundStop = {GameInstance, function()
		self:OnPlayAudioFinished()
		if not DisableMouth then
			if (IsValid(VoiceActor) and VoiceActor.StopOral) then
				VoiceActor:StopOral(VoiceName)
			end
		end
	end}
	
	local SoundEventInstance = AudioManager:PlayFMODSound_Sync(PlayStruct)
	if (AudioManager:IsSoundStoped_CPP(SoundEventInstance)) then
		DebugPrint(string.format("TalkAudioComp_C:PlaySoundWithOral Failed, %s, %s, %s, %s", VoiceName, RealEventPath,
			SelectKey, OralPath))
		self:OnPlayAudioFinished()
		return
	end
	self:SetAudioState(ETalkAudioState.Play)

	if not DisableMouth then
		if (IsValid(VoiceActor) and VoiceActor.StartOral) then
			local OralBaked = self:GetOralBaked(OralPath)
			VoiceActor:StartOral(VoiceName, OralBaked)
		end
	end

	return SoundEventInstance
end

function TalkAudioComp_C:OnPlayAudioFinished()
	self:SetAudioState(ETalkAudioState.Stop)
	DebugPrint("TalkAudioComp_C: OnPlayAudioFinished", self.SoundFinishCallback)
	if self.SoundFinishCallback then 
		self.SoundFinishCallback() 
	end
end

function TalkAudioComp_C:GetEventKey(SoundHandle)
	if not SoundHandle then
		return self.AudioEventKey
	end
	self.AudioEventKey = "TalkAudio_"..tostring(SoundHandle)
	return self.AudioEventKey
end

function TalkAudioComp_C:StopVOSound()
	if self:GetAudioState() == ETalkAudioState.Stop then
		DebugPrint("TalkAudioComp_C: StopVOSound Failed, Audio Already Stopped", self:GetAudioState())
		return
	end
	local GameInstance = GWorld.GameInstance
	local AttachActor = self.AttachActor
	if not AttachActor then
		AttachActor = UE4.UGameplayStatics.GetPlayerController(GameInstance, 0)
	end
	AudioManager(GameInstance):StopSound(AttachActor, self:GetEventKey())
	self.AudioEventKey = nil
	self:SetAudioState(ETalkAudioState.Stop)
end

function TalkAudioComp_C:GetAudioState()
	return self.AudioState
end

function TalkAudioComp_C:SetAudioState(AudioState)
	if not ETalkAudioState[AudioState] then
		return
	end
	self.AudioState = AudioState
end

function TalkAudioComp_C:Clear()
	self.SoundFinishCallback = nil
	if self.bStopSoundWhenClear then
		self:StopVOSound()
	end
	self:ClearPlayAudioProxy()
end

function TalkAudioComp_C:ClearPlayAudioProxy()
	if (self.PlayAudioProxy) then
		self.PlayAudioProxy:Clear()
		self.PlayAudioProxy = nil
	end
end

function TalkAudioComp_C:IsAudioLoading()
	return self.PlayAudioProxy and self.PlayAudioProxy.bIsValid
end

function TalkAudioComp_C:OnPaused()
	DebugPrint("TalkAudioComp_C:OnPaused", self:GetAudioState())
	if (self:IsAudioLoading()) then
		self.PlayAudioProxy:Pause()
		return
	end

	if self:GetAudioState() ~= ETalkAudioState.Play then
		return
	end
	self:SetAudioState(ETalkAudioState.Pause)
	local GameInstance = GWorld.GameInstance
	local AudioManager = AudioManager(GameInstance)
	local AttachActor = self.AttachActor
	if not AttachActor then
		AttachActor = UE4.UGameplayStatics.GetPlayerController(GameInstance, 0)
	end
	local EventKey = self:GetEventKey()

	self.PauseEventVolume = self.PauseEventVolume or AudioManager:GetEventVolume(AttachActor, EventKey)
	AudioManager:PauseEvent(AttachActor, EventKey, true)
	AudioManager:SetEventVolume(AttachActor, EventKey, 0)
	AudioManager:SetEventSoundParam(nil, Const.DialogueEffectSoundKey, {voice_effect_type = 0})
end

function TalkAudioComp_C:OnPauseResumed()
	DebugPrint("TalkAudioComp_C:OnPauseResumed", self:GetAudioState())
	if (self:IsAudioLoading()) then
		self.PlayAudioProxy:Resume()
		return
	end

	if self:GetAudioState() ~= ETalkAudioState.Pause then
		return
	end
	local GameInstance = GWorld.GameInstance
	local AudioManager = AudioManager(GameInstance)
	local AttachActor = self.AttachActor
	if not AttachActor then
		AttachActor = UE4.UGameplayStatics.GetPlayerController(GameInstance, 0)
	end
	local EventKey = self:GetEventKey()

	AudioManager:PauseEvent(AttachActor, EventKey, false)
	-- AudioManager:RecoverEventInstanceVolume(AttachActor, EventKey)
	AudioManager:RecoverEventInstanceVolume(AttachActor, EventKey, self.PauseEventVolume or 1)
	if self.ExtraInfo and self.ExtraInfo.SnapShot then
        AudioManager:SetEventSoundParam(nil, Const.DialogueEffectSoundKey, {voice_effect_type = Const.DialogueSnapShot[self.ExtraInfo.SnapShot]})
	end
	self:SetAudioState(ETalkAudioState.Play)
end

function TalkAudioComp_C:GetAssetPaths(AudioManager, VoiceName, ExStoryInfo)
	if not AudioManager:GetGender() then
		return
	end
	local EventPath = VoiceName
	if (ExStoryInfo == "EXPlayer") then
		EventPath = VoiceName .. AudioManager:GetGender(true)
	else
		EventPath = VoiceName .. AudioManager:GetGender()
	end

	local RealEventPath = nil
    local SelectKey = nil
    local EventExist = nil
    local OralPath = nil
	RealEventPath, SelectKey, OralPath, EventExist = AudioManager:DoesVoiceSoundPathExist(EventPath)
	if not EventExist then
		RealEventPath, SelectKey, OralPath, EventExist = AudioManager:DoesVoiceSoundPathExist(VoiceName)
	end
	local EventAssetPath = AudioManager:GetEventAssetPath(RealEventPath)

	local AssetPaths = {}
	if (EventAssetPath ~= "") then
		table.insert(AssetPaths, EventAssetPath)
	end

	if (string.sub(OralPath, 1, 6) ~= "event:" and UResourceLibrary.CheckResourceExistOnDisk(OralPath)) then
		table.insert(AssetPaths, OralPath)
	end
	DebugPrint("TalkAudioComp_C: GetAssetPaths", RealEventPath, SelectKey, EventAssetPath, OralPath)
	return AssetPaths
end

function TalkAudioComp_C:GetOralBaked(OralBakedPath)
	local OralBaked = UE4.LoadObject(OralBakedPath)
	DebugPrint("TTT:GetOralBaked", OralBakedPath, OralBaked)
	return OralBaked
end

return TalkAudioComp_C
