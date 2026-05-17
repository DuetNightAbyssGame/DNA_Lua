
local OpenSytstemUINode = Class("StoryCreator.StoryLogic.StorylineNodes.BaseAsynQuestNode")
function OpenSytstemUINode:Init()
    self.IsAsync = true
	self.UIName=""
    self.IsInterfaceJump = false
    self.InterfaceJumpId = 0
end

function OpenSytstemUINode:Execute(Callback)
	-- 异步节点需要通过Callback返回 -- Callback(ReturnPort)
    self.UIObj = self:OpenUI()
    self.Callback=Callback
    if (self.IsAsync == false) then
        self:ExecuteNext()
    elseif (self.IsAsync == true) then
        EventManager:AddEvent(EventID.UnLoadUI, self, self.OnUIClose)
    end
end

function OpenSytstemUINode:Clear()
	if(self.IsAsync == true) then
        EventManager:RemoveEvent(EventID.OnJumpToPage, self)
        EventManager:RemoveEvent(EventID.UnLoadUI, self)
        if IsValid(self.UIObj) then
    		UIManager(self):UnLoadUINew(self.UIName)
            self.UIObj = nil
        end
	end
end

function OpenSytstemUINode:GetJumpPageUI(FromPage, ToPage)
    EventManager:RemoveEvent(EventID.OnJumpToPage, self)
    if IsValid(ToPage) then
        self.UIName = ToPage:GetUIConfigName()
        self.UIObj = ToPage
    end
    DebugPrint("OpenSytstemUINode:GetJumpPageUI", self.UIName, self.UIObj)
end

function OpenSytstemUINode:OnUIClose(UIName)
    if UIName==self.UIName then
        EventManager:RemoveEvent(EventID.UnLoadUI, self)
        self:ExecuteNext()
    end
end

function OpenSytstemUINode:ExecuteNext()
    DebugPrint("OpenSytstemUINode:ExecuteNext", self.UIName, self.UIObj)
    self.Callback()
end
--作用同gm OpenUI的打开界面函数
--@param UIName 界面名字
function OpenSytstemUINode:OpenUI()
    -- 打开界面（界面名字后面可以跟需要传入的参数）
    -- example: gm OpenUI BagMain
    if (self.IsInterfaceJump == false) then
        local UIName = self.UIName
        local SystemUIConfig = DataMgr.SystemUI[UIName]
        if (SystemUIConfig ~= nil) then
            return UIManager(self):LoadUINew(UIName)
        end
        local UIConfig = UIConst.AllUIConfig[UIName]
        if (UIConfig == nil) then
            ScreenPrint(string.format("OpenSytstemUINode：打开界面节点出错，没有找到相关UI信息,请检查节点填入的UIName,UI名字为%s", UIName))
            DebugPrint("========================================================================OpenSytstemUINode: Not Find UIName In SystemUI or AllUIConfig, UIName Is : %s ",UIName)
            local Message="OpenSytstemUINode：打开界面节点出错，没有找到相关UI信息,请检查节点填入的UIName,UI名字为".. UIName
            UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.Quest, "OpenSytstemUINode节点出错，没有找到相关UI信息", Message)
            EventManager:RemoveEvent(EventID.UnLoadUI, self)
            return
        end

        return UIManager(self):LoadUI(UIConfig.resource, UIName, UIConfig.zorder)
    elseif (self.IsInterfaceJump == true) then
        local InterfaceJumpId = self.InterfaceJumpId
        if (self.IsAsync == true) then
            --节点为异步时，需获取跳转节点的UIName，以监听其关闭
            EventManager:AddEvent(EventID.OnJumpToPage, self, self.GetJumpPageUI)
        end
        PageJumpUtils:JumpToTargetPageByJumpId(InterfaceJumpId)
    end
    return nil
end
return OpenSytstemUINode