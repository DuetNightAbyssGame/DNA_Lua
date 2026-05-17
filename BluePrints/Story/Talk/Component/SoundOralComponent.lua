---@Deprecated 已废弃代码，待删除

---@class FSoundOralComponent
local FSoundOralComponent = {}

function FSoundOralComponent.New()
	local NewItem = setmetatable({}, {
		__index = FSoundOralComponent
	})
	return NewItem
end

function FSoundOralComponent:GetAssetPaths(AudioManager, VoiceName, ExStoryInfo)
	assert(AudioManager, string.format("AudioManager 是空，获取台本音频相关资源路径失败。VoiceName: %s", VoiceName))
	assert(VoiceName, string.format("VoiceName 是空，获取台本音频相关资源路径失败。是空，获取台本音频相关资源路径失败。VoiceName: %s", VoiceName))
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
	DebugPrint("TTT:SoundOralComponent GetAssetPaths", RealEventPath, SelectKey, EventAssetPath, OralPath)
	return AssetPaths
end

function FSoundOralComponent:PlaySoundWithOral(AudioManager, VoiceName, VoiceActor, bIsAttached, ExStoryInfo, EventKey, Callback)
	local AttachedActor = VoiceActor
	local bIsPlay2D = not bIsAttached
	if (bIsPlay2D) then
		AttachedActor = UE4.UGameplayStatics.GetPlayerController(AudioManager, 0)
	end

	local GameInstance = GWorld.GameInstance
	local RealEventPath, SelectKey, OralPath, EventExist = AudioManager:GetEventData(VoiceName, ExStoryInfo)
	local PlayStruct = FPlayFMODSoundStruct()
	DebugPrint("TTT:PlaySoundWithOral", RealEventPath, SelectKey, bIsPlay2D, AttachedActor:GetName())
	PlayStruct.FMODEvent = AudioManager:GetFMODEventByPath_Sync(RealEventPath)
	PlayStruct.EventKey = EventKey
	PlayStruct.bStopWhenAttachedToDestoryed = true
	PlayStruct.bPlayAs2D = bIsPlay2D
	PlayStruct.SelectKey = SelectKey
	PlayStruct = UE4.UAudioManager.SetObjectToFPlayFMODSoundStruct(PlayStruct, AttachedActor)
	PlayStruct.DynamicSoundStop = {GameInstance, function()
		if Callback then
			Callback()
		end
		if (VoiceActor and VoiceActor.StopOral) then
			VoiceActor:StopOral(VoiceName)
		end
	end}
	
	DebugPrint(string.format("TTT:PlaySoundWithOral: %s, %s, %s, %s", VoiceName, RealEventPath,
	SelectKey, OralPath))
	local SoundEventInstance = AudioManager:PlayFMODSound_Sync(PlayStruct)

	if (IsValid(VoiceActor) and VoiceActor.StartOral) then
		local OralBaked = self:GetOralBaked(OralPath)
		VoiceActor:StartOral(VoiceName, OralBaked)
	end

	return SoundEventInstance
end

function FSoundOralComponent:GetOralBaked(OralBakedPath)
	local OralBaked = UE4.LoadObject(OralBakedPath)
	DebugPrint("TTT:GetOralBaked", OralBakedPath, OralBaked)
	return OralBaked
end

return {
	FSoundOralComponent = FSoundOralComponent
}
