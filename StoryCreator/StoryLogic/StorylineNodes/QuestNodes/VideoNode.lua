



local VideoNode = Class('StoryCreator.StoryLogic.StorylineNodes.BaseAsynQuestNode')


function VideoNode:Init()
    self.MediaSourceRef = ""
end

function VideoNode:Execute(Callback)
    DebugPrint("------------ VideoNode Execute------------------")
    local _FireCallback = function()
        if(Callback)then
            Callback()
        end
    end
    local obj = LoadObject(self.MediaSourceRef)
    if obj then
        self.Action = UE4.UAsyncVideoAction.PlayVideoByMediaSource(GWorld.GameInstance, obj)
        if IsValid(self.Action) then
            self.ActionRefProxy = Ref(self.Action)
            self.Action.OnPlayEnd:Add(GWorld.GameInstance, function()
                self.Action.OnPlayEnd:Clear()
                _FireCallback()
            end)
        else
            DebugPrint("播放视频失败 PlayVideoByMediaSourcec未返回正确值",GWorld.GameInstance, obj)
            _FireCallback()
        end
    else
        DebugPrint("Error: Load Media Source Failed, Ref:",self.MediaSourceRef)
        _FireCallback()
    end
end

function VideoNode:Clear()
    if(self.ActionRefProxy and IsValid(self.Action))then
        self.Action.OnPlayEnd:Clear()
    end
    self.ActionRefProxy = nil
end

return VideoNode
