

local ExecuteBlueprintFunctionSetVarNode = Class('StoryCreator.StoryLogic.StorylineNodes.BaseAsynQuestNode')
local VarLogType = UE.EStoryLogType.StoryVar

-- 没有初始化可以省略
function ExecuteBlueprintFunctionSetVarNode:Init()
	self.FunctionName = nil
    self.VarName = nil
    self.VarInfos = {}
end

function ExecuteBlueprintFunctionSetVarNode:Execute(Callback)
    if not self.VarName or self.VarName == "" then
        UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, VarLogType, "通过蓝图函数设置变量节点出错", "没有填写VarName, FileName:" .. tostring(self.Context.FileName) .. ",请策划排查.")
        Callback()
        return
    end

    local VarInfo = DataMgr.StoryVariable[self.VarName]
    if not VarInfo then
        local _Str = "变量:[" .. tostring(self.VarName) .. "]需要现在StoryVariable.xlsx中先声明"
        if self.QuestChainId and self.QuestChainId ~= 0 then
            _Str = _Str .. ",QuestChainId:[" .. tostring(self.QuestChainId) .. "]"
        end
        _Str = _Str .. ",FileName:" .. tostring(self.Context.FileName) .. ",请策划排查."
        UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, VarLogType, "通过蓝图函数设置变量节点出错", _Str)
        Callback()
        return
    end

    local NewVarInfos = {}
    for k,v in pairs(self.VarInfos) do
        local _VarName = v.VarName
        local _VarValue = v.VarValue
        if tonumber(_VarValue) then
            NewVarInfos[_VarName] = tonumber(_VarValue)
        else
            NewVarInfos[_VarName] = _VarValue
        end
    end

    -- PrintTable({NewVarInfos=NewVarInfos},10)

    local StorySubsystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, UStorySubsystem:StaticClass())
    local Ret = StorySubsystem:ExecuteBlueprintVarFunction(self.FunctionName, self.VarName, NewVarInfos, self.QuestChainId, false)
    if not (type(Ret) == 'number' and Ret % 1 == 0) then
        UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, VarLogType, "通过蓝图函数设置变量节点出错", "函数[" .. tostring(self.FunctionName) .. "]的返回值不是int类型, Ret:"..tostring(Ret))
        Callback()
        return nil
    end
    -- PrintTable({Ret=Ret})
    StorySubsystem:SetInt(self.VarName, Ret)
    if not VarInfo.IsGlobal then
        Callback()
    else
        EventManager:AddEvent(EventID.OnStoryVarUpdated, self, function(Obj, VarName, VarValue)
            EventManager:RemoveEvent(EventID.OnStoryVarUpdated, self)
            if VarName == self.VarName and VarValue == Ret then
                -- ScreenPrint("ExecuteBlueprintFunctionSetVarNode:Complete".." "..VarName.." "..VarValue)
                Callback()
            end
        end)
    end
end

function ExecuteBlueprintFunctionSetVarNode:Stop()
    self:Clear()
end

-- 没有Node自身清理工作可以省略
function ExecuteBlueprintFunctionSetVarNode:Clear()
	-- ScreenPrint("ExecuteBlueprintFunctionSetVarNode:Clear")
    EventManager:RemoveEvent(EventID.OnStoryVarUpdated, self)
end

-- 没有Questline清理工作可以省略
function ExecuteBlueprintFunctionSetVarNode:OnQuestlineFinish()
	-- ScreenPrint("ExecuteBlueprintFunctionSetVarNode:OnQuestlineFinish")
end

-- 没有Questline成功工作可以省略
function ExecuteBlueprintFunctionSetVarNode:OnQuestlineSuccess()
	-- ScreenPrint("ExecuteBlueprintFunctionSetVarNode:OnQuestlineSuccess")
end

-- 没有Questline失败工作可以省略
function ExecuteBlueprintFunctionSetVarNode:OnQuestlineFail()
	-- ScreenPrint("ExecuteBlueprintFunctionSetVarNode:OnQuestlineFail")
end

return ExecuteBlueprintFunctionSetVarNode