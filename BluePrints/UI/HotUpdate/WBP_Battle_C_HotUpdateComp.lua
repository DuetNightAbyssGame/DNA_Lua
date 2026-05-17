local HotUpdateUtils = require "Utils.HotUpdateUtils"

local M = {}

function M:Construct()
    local HotUpdateSubsystem = USubsystemBlueprintLibrary.GetGameInstanceSubsystem(self, UHotUpdateSubsystem)
    if not HotUpdateSubsystem then
        return
    end
    HotUpdateSubsystem.OnUpdateStartDelegate:Add(self, self.OnUpdateStart)
    HotUpdateSubsystem.PatchPostSuccessDelegate:Add(self, self.OnPatchFinish)
    HotUpdateSubsystem.PatchAllSuccessDelegate:Add(self, self.OnPatchAllFinish)

    self:TryAutoDownloadNextNecessoryPatch()
end

function M:Destruct()
    local HotUpdateSubsystem = USubsystemBlueprintLibrary.GetGameInstanceSubsystem(self, UHotUpdateSubsystem)
    if not HotUpdateSubsystem then
        return
    end
    HotUpdateSubsystem.OnUpdateStartDelegate:Remove(self, self.OnUpdateStart)
    HotUpdateSubsystem.PatchPostSuccessDelegate:Remove(self, self.OnPatchFinish)
    HotUpdateSubsystem.PatchAllSuccessDelegate:Remove(self, self.OnPatchAllFinish)
end

function M:OnUpdateStart()
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    if not UIManager then
        return
    end
    if UIManager:GetUIObj("OptionalPatch") then
        return
     end
    local HotUpdateSubsystem = USubsystemBlueprintLibrary.GetGameInstanceSubsystem(self, UHotUpdateSubsystem)
    if not HotUpdateSubsystem then
        return
    end
    local OptionalPatches = HotUpdateSubsystem:GetDownloadingOptionalSigns()
    if not OptionalPatches or OptionalPatches:Num() == 0 then
        return
    end
    for _, PatchID in pairs(OptionalPatches:ToTable()) do
        local PatchResource = DataMgr.PatchResource[PatchID]
        if PatchResource then
            UIManager:ShowUITip(
                UIConst.Tip_CommonTop,
                string.format(GText("UI_Patch_Toast_Start"), GText(PatchResource.Name))
            )
        end
    end
    -- 添加动效
    self:AddDownloadSignEffect()
    EventManager:FireEvent(EventID.DownloadTaskStart)
end

function M:OnPatchFinish(bFirst, OptionalPatches)
    if not OptionalPatches or OptionalPatches:Num() == 0 then
        return
    end
    for _, PatchID in pairs(OptionalPatches:ToTable()) do
        local PatchResource = DataMgr.PatchResource[PatchID]
        if PatchResource then
            UIManager(self):ShowUITip(UIConst.Tip_CommonTop, string.format(GText("UI_Patch_Toast_Finish"), GText(PatchResource.Name)))
        end
    end
end

function M:OnPatchAllFinish(bFirst)
    self:TryAutoDownloadNextNecessoryPatch()
    -- 移除动效
    self:RemoveDownloadSignEffect()
    EventManager:FireEvent(EventID.DownloadTaskFinish)
end

function M:TryAutoDownloadNextNecessoryPatch()
    HotUpdateUtils.TryAutoDownloadNextNecessoryPatch(self)
end

return M
