
require "UnLua"

local FStoryLog = require("BluePrints/Story/Log/StoryLog")

---@type BP_StoryLogSubsystem_C
local M = Class()

function M:OnInitialize()
end

function M:OnDeinitialize()
end

---@param Title string
---@param Message string
function M:OnPrintToFeiShu(Type, Title, Message)
	--参数验证
	if not Type or not Title or not Message then
        DebugPrint(ErrorTag, "BP_StoryLogSubsystem:OnPrintToFeiShu, 参数为空", Type, Title, Message)
        return
    end
    local TypeString = nil
    local Success, Result = pcall(function()
        return UE.EStoryLogType:GetDisplayNameTextByValue(Type)
    end)
    if not Success or not Result or Result == "" then
        DebugPrint(ErrorTag, "BP_StoryLogSubsystem:OnPrintToFeiShu, 参数Type不是有效的EStoryLogType枚举值", Type)
        return
    end
    TypeString = Result

    --去重
    if not GWorld.StoryLogDict then
        GWorld.StoryLogDict = {}
    end
    local ErrorDictContent = TypeString..Title..Message
    if ErrorDictContent ~= "" and GWorld.StoryLogDict[ErrorDictContent] then
        return
    end
    GWorld.StoryLogDict[ErrorDictContent] = true

    --打印
	local StoryLog = FStoryLog:New()
	local Ct = {
        "【错误大类】: ", TypeString, "\n",
        "【标题】: ", Title, "\n",
        "【具体内容】: ",Message,
    }
    local Ret = table.concat(Ct)
	StoryLog:AddTextLine(Ret)

	self:AddTracebackLog(StoryLog)
	self:AddPlatformLog(StoryLog)
	self:AddSubregionLog(StoryLog)
	self:AddWorkingTalkTaskLog(StoryLog)

	ScreenPrint(string.format("%s\n%s", Title, StoryLog:ToString()))

	local Avatar = GWorld:GetAvatar()
	if (Avatar) then
		Avatar:SendToFeishuForJQ(StoryLog:ToRichString(), Title)
	end
end

---@param StoryLog FStoryLog
function M:AddTracebackLog(StoryLog, Level, LineLimit)
	Level = Level or 4
	LineLimit = LineLimit or 10

	local Traceback = nil
	local NativeTraceback = debug.traceback(nil, Level)
	local Lines = string.split(NativeTraceback, "\n")
	local LineCount = #Lines
	if LineCount > LineLimit then
		local HeadLineCount = math.ceil(LineLimit / 2)
		local HeadLine = table.concat(Lines, "\n", 1, HeadLineCount)

		HeadLineCount = HeadLineCount + 1
		HeadLine = string.format("%s\n(...skip calls...)", HeadLine)

		local TailLineCount = LineLimit - HeadLineCount
		local TailLine = table.concat(Lines, "\n", LineCount - TailLineCount + 1, LineCount)

		Traceback = string.format("%s\n%s", HeadLine, TailLine)
	else
		Traceback = NativeTraceback
	end

	StoryLog:AddSeparator()
	StoryLog:AddTitleLine("调用栈")
	StoryLog:AddTextLine(Traceback)
end

---@param StoryLog FStoryLog
function M:AddPlatformLog(StoryLog)
	local PlatformName = UE4.UGameplayStatics.GetPlatformName()
	if (UE4.URuntimeCommonFunctionLibrary.IsPlayInEditor(GWorld.GameInstance)) then
		PlatformName = "编辑器"
	end

	StoryLog:AddSeparator()
	StoryLog:AddTitleLine("平台信息")
	StoryLog:AddKeyLine("平台", PlatformName)
end

---@param StoryLog FStoryLog
function M:AddSubregionLog(StoryLog)
	local Avatar = GWorld:GetAvatar()
	if (Avatar == nil) then
		return
	end

	local SubregionId = Avatar:GetCurrentRegionId()
	local SubregionName = "无效的子区域命名"
	local SubregionData = DataMgr.SubRegion[SubregionId]
	if (SubregionData) then
		local TextData = DataMgr.TextMap[SubregionData.SubRegionName]
		if (TextData) then
			SubregionName = GText(SubregionData.SubRegionName)
		end
	end

	StoryLog:AddSeparator()
	StoryLog:AddTitleLine("区域信息")
	StoryLog:AddKeyLine("子区域 ID", SubregionId)
	StoryLog:AddKeyLine("子区域名称", SubregionName)
end

function M:AddWorkingTalkTaskLog(StoryLog)
	local TS = TalkSubsystem()
	if (not TS) then
		return
	end

	local Logs = TS:GetAllWorkingTaskDebugLogs()
	if (not Logs or #Logs == 0) then
		return
	end

	StoryLog:AddSeparator()
	StoryLog:AddTitleLine("当前运行中的对话任务信息")
	for _, Log in pairs(Logs) do
		StoryLog:AddMapLine(Log)
	end
end

return M
