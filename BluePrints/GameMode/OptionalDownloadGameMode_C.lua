require "UnLua"
local HotUpdateUtils = require("Utils.HotUpdateUtils")

---@type AOptionalDownloadGameMode
local M = Class()

function M:ReceiveBeginPlay()
    local NecessaryPatchSigns = HotUpdateUtils.NormalizeNecessoryPatchSigns(self.NecessaryPatchSigns)
    UIManager(self):LoadUINew("OptionalPatch", NecessaryPatchSigns)
end

return M

