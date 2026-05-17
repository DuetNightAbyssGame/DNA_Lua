--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Play_DailyProgress_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end
function M:RefreshProgress(Parent)
    self.Parent = Parent
    -- 获取 PlayerAvatar 和 当前进度
    local PlayerAvatar = GWorld:GetAvatar()
    if not PlayerAvatar then return end
    local DataArray = {}

    local key = nil
    local maxLv = nil
    local prevLv = nil  -- 记录上一个 lv

    local SortedKeys = {}
    for lv in pairs(DataMgr.DailyGoalReward) do
        table.insert(SortedKeys, lv)
    end

    table.sort(SortedKeys) -- 默认升序
    for _, lv in ipairs(SortedKeys) do
        -- 记录最大的等级
        if not maxLv or lv > maxLv then
            maxLv = lv
        end

        if lv == PlayerAvatar.DailyInitLevel then
            key = lv
            break
        elseif lv > PlayerAvatar.DailyInitLevel then
            key = prevLv
            break
        end

        -- 记录上一个 lv
        prevLv = lv
    end

    if not key then
        key = maxLv
    end

    local DailyGoalReward = DataMgr.DailyGoalReward[key]
    -- 填充 DataArray 并排序
    for key, ItemData in pairs(DailyGoalReward) do
        table.insert(DataArray, ItemData)
    end

    table.sort(DataArray, function(a, b)
        return a.RequiredActiveness < b.RequiredActiveness
    end)

    --local CurrentTaskProgress = PlayerAvatar.CurrentTaskProgress

    -- 初始化所有的奖励项
    for i, ItemData in ipairs(DataArray) do
        local Reward = self["Reward0" .. i]
        Reward:Init(ItemData,Parent)
    end

    -- for i = 1, #DataArray - 1 do
    --     local RequiredProgressStart = DataArray[i].RequiredActiveness
    --     local RequiredProgressEnd = DataArray[i + 1].RequiredActiveness

    --     -- 计算当前阶段的总进度范围
    --     local TotalProgressRange = RequiredProgressEnd - RequiredProgressStart
    --     local Progress = 0

    --     if CurrentTaskProgress >= RequiredProgressStart then
    --         if CurrentTaskProgress >= RequiredProgressEnd then
    --             Progress = 1
    --         else
    --             Progress = (CurrentTaskProgress - RequiredProgressStart) / TotalProgressRange
    --         end
    --     end

    --     -- DebugPrint("OnDailyProgressRewardChange - RequiredProgressStart: ", RequiredProgressStart)
    --     -- DebugPrint("OnDailyProgressRewardChange - Progress: ", Progress)

    --     -- 设置进度条的进度百分比
    --     self["Bar0" .. i]:SetPercent(Progress)
    -- end
end

function M:OnAddedToFocusPath(InFocusEvent)
    if UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad or self.Mobile then
        return
    end
    local StyleOfPlay = UIManager(self):GetUIObj("StyleOfPlay")
    if not StyleOfPlay then
        return
    end

    local BottomKeyInfo = {
            {
                GamePadInfoList = {
                    { Type = "Img", ImgShortPath = "A", Owner = self }
                },
                Desc = GText("UI_Tips_Ensure"),
                bLongPress = false,
            },
            {
                KeyInfoList = { { Type = "Text", Text = "Esc", ClickCallback = self.Parent.CloseSelf, Owner = self } },
                GamePadInfoList = {
                    { Type = "Img", ImgShortPath = "B", Owner = self }
                },
                Desc = GText("UI_BACK"),
            },

        }
        StyleOfPlay:UpdateOtherPageTab(BottomKeyInfo)
end



return M
