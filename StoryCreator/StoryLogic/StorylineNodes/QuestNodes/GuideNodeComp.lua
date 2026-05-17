
---引导相关的QuestNode组件，目前主要用来辨别哪些节点属于显示引导UI的
local GuideNodeComp = {}

function GuideNodeComp:IsGuideNode()
    return true
end

return GuideNodeComp