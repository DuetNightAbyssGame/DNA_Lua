--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local NormalTaskNewReddotName = "JJGameTask_Normal_New"
local NormalTaskBPPath = "/Game/UI/WBP/Activity/Widget/JJGame/Normal/WBP_Activity_JJGame_NormalSubItem.WBP_Activity_JJGame_NormalSubItem"
local TaskType = {
    Daily = {1,2},
    Cycle = 3,
    Achievement = 4,
}
---@type WBP_Activity_JJGame_NormalItem_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.MidTermConst = DataMgr.MidTermGoalConstant
    self.MidTermGoalEventId = self.MidTermConst["MidTermGoalEventId"].ConstantValue
    self.List_Task:SetAllowOverscroll(false)
    self.List_Task:DisAbleScroll(true)
    self.List_Task.BP_OnEntryInitialized:Add(self, self.OnListTaskEntryInitialized)
end

function M:Destruct()
    if self.HasNewTask then
        self:TryClearNormalTaskNewReddot()
    end
end

function M:Init(TaskConfig)
    self.TaskConfig = TaskConfig
    self.Owner = TaskConfig.Owner
    self.JJGameBase = self.Owner.Owner
    self.EventDay = TaskConfig.EventDay
    self.YesterdayRewardGot = TaskConfig.YesterdayRewardGot
    self.Text_Title:SetText(GText(TaskConfig.Name))
    self._Avatar = GWorld:GetAvatar()
    self:UpdateTaskList()
    self:UpdateNormalTaskTabNewReddot()
end

function M:UpdateNormalTaskTabNewReddot()
    if not self.Owner then return end
    if self.HasNewTask then
        self.Owner.Owner.Com_Tab:ShowTabRedDot(1, true)
    else
        self.Owner.Owner.Com_Tab:ShowTabRedDot(1, false)
    end
end

function M:UpdateTaskList()
    self.List_Task:ClearListItems()
    self.TaskContentList = {}
    self.MidTermGoals = self._Avatar.MidTermGoals[self.MidTermGoalEventId] or {}
    local MidTermTasks = self.MidTermGoals.Tasks or {}
    local SortedTaskList = self:SortTaskList(MidTermTasks)
    for i,Task in pairs(SortedTaskList) do
        local TaskData = DataMgr.MidTermTask[Task.UniqueID]
        if not TaskData then
            print("TaskData is nil, Task.UniqueID = ", Task.UniqueID)
            Utils.ScreenPrint("MidTermTask表中不存在UniqueID为"..Task.UniqueID.."的任务，请检查配置")
           goto continue
        end
        local TaskItem = nil
        if type(self.TaskConfig.TaskType) == "table" then
            if TaskData.EnableDay ~= self.EventDay then
                goto continue
            end
            if TaskData.TaskType == self.TaskConfig.TaskType[1] then
                TaskItem = self:NewItemContent(TaskData.TaskType, TaskData.TaskId, self.MidTermConst["DailyRewardPoint_1"].ConstantValue, TaskData.TaskDes)
            elseif TaskData.TaskType == self.TaskConfig.TaskType[2] then
                TaskItem = self:NewItemContent(TaskData.TaskType, TaskData.TaskId, self.MidTermConst["DailyRewardPoint_2"].ConstantValue, TaskData.TaskDes)
            end
        else
            if TaskData.TaskType == self.TaskConfig.TaskType then
                TaskItem = self:NewItemContent(TaskData.TaskType, TaskData.TaskId, self.MidTermConst["CycleRewardPoint"].ConstantValue, TaskData.TaskDes)
                TaskItem.MidTermTasksRecord = self._Avatar.MidTermTasksRecord[Task.UniqueID] or {}
            end
        end
        if TaskItem then
            TaskItem.TaskProp = Task.Props
            TaskItem.TaskConfig = TaskData
            table.insert(self.TaskContentList, TaskItem)
            self.List_Task:AddItem(TaskItem)
        end
        ::continue::
    end
    self.List_Task:RequestPlayEntriesAnim()
    self:TryIncreaceNormalTaskNewReddot()
end

function M:OnListTaskEntryInitialized()
    if self.TaskConfig.Name == "UI_Event_MidTerm_DailyTask" then
        local FirstItem = self.List_Task:GetItemAt(0)
        if FirstItem and FirstItem.SelfWidget then
            FirstItem.SelfWidget:SetFocus()
        else
            self.List_Task:SetFocus()
        end
    end
end

function M:SortTaskList(TaskList)
    local SortedTaskList = {}
    for k, v in pairs(TaskList) do
        table.insert(SortedTaskList, {key = tonumber(k), value = v})
    end
    table.sort(SortedTaskList, function(a, b)
        return a.key < b.key
    end)
    local result = {}
    for _, pair in ipairs(SortedTaskList) do
        table.insert(result, pair.value)
    end
    return result
end

function M:TryIncreaceNormalTaskNewReddot()
    for _, TaskItem in pairs(self.TaskContentList) do
        -- if (TaskItem.TaskConfig.TaskType == TaskType.Daily[1]
        -- or TaskItem.TaskConfig.TaskType == TaskType.Daily[2]) then
        --     goto continue
        -- end
        local CacheKey = TaskItem.TaskProp.UniqueID
        local CacheData = ReddotManager.GetLeafNodeCacheDetail(NormalTaskNewReddotName)
        if CacheData and CacheData[CacheKey] == nil then
            CacheData[CacheKey] = true
            ReddotManager.IncreaseLeafNodeCount(NormalTaskNewReddotName)
        end
        if CacheData and CacheData[CacheKey] == true then
            self.HasNewTask = true
        end
        ::continue::
    end
end

function M:TryClearNormalTaskNewReddot()
    local CacheData = ReddotManager.GetLeafNodeCacheDetail(NormalTaskNewReddotName)
    if CacheData then
        for key, _ in pairs(CacheData) do
            CacheData[key] = false
        end
    end
    ReddotManager.ClearLeafNodeCount(NormalTaskNewReddotName)
    self.HasNewTask = false
end

function M:NewItemContent(TaskType, TaskId, TaskPoint, TaskDes)
    local ItemContent = NewObject(UIUtils.GetCommonItemContentClass())
    ItemContent.Owner = self
    ItemContent.TaskType = TaskType
    ItemContent.Id = TaskId
    ItemContent.Point = TaskPoint
    ItemContent.Desc = TaskDes
    ItemContent.YesterdayRewardGot = self.YesterdayRewardGot
    return ItemContent
end

function M:OnAchvFinished(TaskId)
    if not self.TaskContentList then return end
    for _, TaskItem in pairs(self.TaskContentList) do
        if TaskItem.SelfWidget and TaskItem.SelfWidget.OnAchvFinished then
            TaskItem.SelfWidget:OnAchvFinished(TaskId)
        end
    end
end

function M:OnMidTermTaskProgressChange(TaskId, Progress)
    if not self.TaskContentList then return end
    for _, TaskItem in pairs(self.TaskContentList) do
        if TaskItem.SelfWidget and TaskItem.SelfWidget.OnMidTermTaskProgressChange then
            TaskItem.SelfWidget:OnMidTermTaskProgressChange(TaskId, Progress)
        end
    end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:BP_GetDesiredFocusTarget()
    -- if CommonUtils.GetDeviceTypeByPlatformName() == "Mobile" then
    --     return self.VB_Task:GetChildAt(0)        
    -- else
    --     return self.List_Task
    -- end
    
    -- return self.List_Task
end

return M
