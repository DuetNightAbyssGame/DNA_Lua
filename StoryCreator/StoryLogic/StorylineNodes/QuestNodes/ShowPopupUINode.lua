---@see 战斗类
local ShowPopupUINode = Class('StoryCreator.StoryLogic.StorylineNodes.BaseAsynQuestNode')

function ShowPopupUINode:Init()
    self.PopupId = nil
end

-- function ShowPopupUINode:Start(QuestLine, InportName)
--     if InportName == "Stop" then 
--         DebugPrint("Tianyi@ Stop monitor player status")
--         self:StopListen(false)
--     else
--         self:Execute(function(ReturnValue)
--             self:Finish(ReturnValue ~= nil and tostring(ReturnValue) or nil)
--         end)
--     end
-- end

function ShowPopupUINode:Execute(Callback)
    if self.PopupId then 
        ---@type Common_Dialog_Params 
        local Param = {}
        Param.RightCallbackFunction = function()
            DebugPrint("Tianyi@ Return True")
            if Callback then 
                Callback("True")
            end
        end

        Param.LeftCallbackFunction = function()
            DebugPrint("Tianyi@ Return False")
            if Callback then 
                Callback("False")
            end
        end

        Param.CloseBtnCallbackFunction = function()
            DebugPrint("Tianyi@ Return False")
            if Callback then 
                Callback("False")
            end
        end

        local GameInstance = GWorld.GameInstance
        local UIManager = GameInstance:GetGameUIManager()
        UIManager:ShowCommonPopupUI(self.PopupId, Param, nil)
    end
end

function ShowPopupUINode:Clear()
    self.PopupId = nil
end

return ShowPopupUINode
