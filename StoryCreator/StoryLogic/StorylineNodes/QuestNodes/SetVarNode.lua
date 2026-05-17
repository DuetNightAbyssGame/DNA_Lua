

local SetVarNode = Class('StoryCreator.StoryLogic.StorylineNodes.BaseAsynQuestNode')
local VarLogType = UE.EStoryLogType.StoryVar

-- 没有初始化可以省略
function SetVarNode:Init()
	self.VarName = nil
    self.VarValue = 0
end

function SetVarNode:Execute(Callback)
    if not self.VarName or self.VarName == "" then
        UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, VarLogType, "SetVarNode节点出错", "没有填写VarName, FileName:" .. tostring(self.Context.FileName) .. ",请策划排查.")
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
        UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, VarLogType, "SetVarNode节点出错", _Str)
        Callback()
        return
    end

    -- PrintTable({Q=VarInfo.QuestChainId,Q2=self.QuestChainId,V=VarInfo.VarName})
    if VarInfo.QuestChainId and VarInfo.QuestChainId ~= self.QuestChainId then
        local _Str = "变量:[" .. tostring(self.VarName) .. "]不能在QuestChain:[" .. tostring(self.QuestChainId) .. "]中使用！表里填里它只支持在QuestChain:[" .. tostring(VarInfo.QuestChainId) .. "]中使用！"
        _Str = _Str .. ",请策划排查."
        UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, VarLogType, "StorySubsystem错误", _Str)
        Callback()
        return
    end

    local StorySubsystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, UStorySubsystem:StaticClass())
    StorySubsystem:SetInt(self.VarName, self.VarValue)
    if not VarInfo.IsGlobal then
        Callback()
    else
        EventManager:AddEvent(EventID.OnStoryVarUpdated, self, function(Obj, VarName, VarValue)
            if VarName == self.VarName and VarValue == self.VarValue then
                -- ScreenPrint("SetVarNode:Complete".." "..VarName.." "..VarValue)
                Callback()
            end
        end)
    end
end

function SetVarNode:Stop()
    self:Clear()
end

function SetVarNode:Clear()
	-- ScreenPrint("SetVarNode:Clear")
    EventManager:RemoveEvent(EventID.OnStoryVarUpdated, self)
end

-- 没有Questline清理工作可以省略
function SetVarNode:OnQuestlineFinish()
	-- ScreenPrint("SetVarNode:OnQuestlineFinish")
end

-- 没有Questline成功工作可以省略
function SetVarNode:OnQuestlineSuccess()
	-- ScreenPrint("SetVarNode:OnQuestlineSuccess")
end

-- 没有Questline失败工作可以省略
function SetVarNode:OnQuestlineFail()
	-- ScreenPrint("SetVarNode:OnQuestlineFail")
end

return SetVarNode