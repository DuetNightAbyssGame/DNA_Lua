--
-- DESCRIPTION
-- Base界面，实现基础分层模块
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"
local StrLib             = require "BluePrints.Common.DataStructure"
local Deque              = StrLib.Deque
local Stack              = StrLib.Stack

---@type WBP_SceneStart_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

M._components = {
    "BluePrints.UI.WBP.Basic.HierarchicalLayerUtils",
}

---初始化lua变量时使用
function M:Initialize(Initializer)
    -- 初始化各个分层所需要的变量

    -- HUD层的相关变量
    self.WidgetInHUD_Deque = Deque.New()                       -- HUD层的Widget队列
    self.HUDWidget = nil                                       -- HUD主界面的引用
end

---初始化设置各个分层以及添加监听事件
function M:Construct()
    -- 初始化设置HUD层
    self:InitHUDLayer()
    -- 监听事件
    self:InitListenEvent()
end

--- 销毁时调用，做一些清理工作，避免重新加载的时候出现问题
function M:Destruct()
    self:RemoveListenEvent()
    -- 清理各个层的Widget
    for index, value in ipairs(UIConst.HierarchicalLayer) do
        local LayerNode = self[value.."_Overlay"]
        if (LayerNode) then
            LayerNode:ClearChildren()
        end
    end
end

---#region 提供给外部的接口

--- 重新初始化界面
function M:ReInit()
    -- 重新初始化HUD层
    self:ReInitHUDLayer()
end

--- 向HUD层添加Widget
---@param ChildWidget WBP_EMUserWidget_C 需要添加的Widget
---@param ParentNodeName string 父节点名称
---@param bAddToDeque boolean 是否将该Widget添加到Deque中（会根据一定的优先级来显示）
function M:AddWidgetToHUD(ChildWidget, ParentNodeName, bAddToDeque)
    if not ChildWidget then
        DebugPrint("WBP_SceneStart_C:AddWidgetToHUD ChildWidget 为空")
        return
    end

    if not self.HUDWidget then
        self.HUDWidget = UIManager(self):GetUIObj("BattleMain")
        if not self.HUDWidget then
            DebugPrint("WBP_SceneStart_C:AddWidgetToHUD 找不到 BattleMain 界面")
            return
        end
    end

    local PanretNode = self.HUDWidget[ParentNodeName]
    local ParentSlot = PanretNode:AddChildToOverlay(ChildWidget)
    ParentSlot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
    ParentSlot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
end

---#endregion

---#region 内部使用的接口
--- 初始化监听事件
function M:InitListenEvent()
    self:AddDispatcher(EventID.LoadUI, self, self.OnSystemUILoad)
    self:AddDispatcher(EventID.UnLoadUI, self, self.OnSystemUIUnLoad)
    self:ListenForInputAction("OpenGM", EInputEvent.IE_Pressed, false, {self, self.OpenGMPanel})
end

--- 移除监听事件
function M:RemoveListenEvent()
    self:StopListeningForInputAction("OpenGM", EInputEvent.IE_Pressed)
end

--- 初始化HUD层
function M:InitHUDLayer()
    self.HUDWidget = UIManager(self):LoadUINew("BattleMain")
end

--- 重新初始化HUD层
function M:ReInitHUDLayer()
    if self.HUDWidget then
        self.HUDWidget:Close()
        self.HUDWidget = nil
    end
    if self.GMWidget then
        self.GMWidget:Close()
        self.GMWidget = nil
    end
    self:AddTimer(0.5, self.InitHUDLayer)
end

--- 打开GM面板
function M:OpenGMPanel()
    self.GMWidget = UIManager(self):LoadUI(nil, "GMCommandPanel", UIConst.ZORDER_FOR_GM_PANEL)
end

---#endregion
AssembleComponents(M)
return M
