require "UnLua"
local Common_Dialog_ContentBase = Class("BluePrints.UI.BP_UIState_C") 

---预初始化，一般用于绑定事件
---@class Common_Dialog_ContentBase: BP_UIState
function Common_Dialog_ContentBase:PreInitContent(Params, PopupData, Owner)
    ---@type WBP_Common_Dialog_PC_C
    self.Owner = Owner
end

function Common_Dialog_ContentBase:InitContent(Params, PopupData, Owner) 
    ---@type WBP_Common_Dialog_PC_C
    self.Owner = Owner
end

function Common_Dialog_ContentBase:PostInitContent(Params, PopupData, Owner)
end

-- 处理弹窗被聚焦事件，若有返回控件，则会聚焦在返回控件上
function Common_Dialog_ContentBase:HandleDialogFocused()
    return nil
end

-- 监听鼠标按下事件
function Common_Dialog_ContentBase:OnContentMouseButtonDown(MyGeometry, InPointerEvent)
end

-- 监听键盘按下事件
function Common_Dialog_ContentBase:OnContentPreviewKeyDown(MyGeometry, InPointerEvent)
end

-- 用于监听键盘按下事件
function Common_Dialog_ContentBase:OnContentKeyDown(MyGeometry, InKeyEvent)
end

-- 用于监听键盘抬起事件
function Common_Dialog_ContentBase:OnContentKeyUp(MyGeometry, InKeyEvent)
end

-- 用于监听摇杆移动事件

function Common_Dialog_ContentBase:OnContentAnalogValueChanged(MyGeometry, InAnalogInputEvent)
end

-- 监听事件
function Common_Dialog_ContentBase:BindDialogEvent(EventName, EventFunc)
    if self.Owner then 
        self.Owner:AddEventListener(EventName, self, EventFunc)
    end
end

-- 移除监听事件
function Common_Dialog_ContentBase:UnbindDialogEvent(EventName)
    if self.Owner then 
        self.Owner:RemoveEventListener(EventName)
    end
end

-- 广播事件
function Common_Dialog_ContentBase:BroadcastDialogEvent(EventName, ...) 
    if self.Owner then 
        self.Owner:BroadcastDialogEvent(EventName, ...)
    end
end

function Common_Dialog_ContentBase:PackageData()
    DebugPrint("Tianyi@ PackageData is not implemented")
    return nil
end

function Common_Dialog_ContentBase:SetContentWidgetName(Name)
    self.ContentWidgetName = Name
end

function Common_Dialog_ContentBase:GetContentWidgetName()
    return self.ContentWidgetName
end

-----------------------------------------------------------------
---手柄端
-----------------------------------------------------------------

function Common_Dialog_ContentBase:InitGamepadView()

end

function Common_Dialog_ContentBase:InitKeyboardView()

end

-- 显隐手柄端左右侧按钮的按键提示
function Common_Dialog_ContentBase:SetGamepadBtnKeyVisibility(IsShow)
    if self.Owner then 
        self.Owner:SetGamepadBtnKeyVisibility(IsShow)
    end
end

-- 显示手柄滚动提示
function Common_Dialog_ContentBase:ShowGamepadScrollBtn(bIsShow)
    if self.Owner then 
        self.Owner:ShowGamepadScrollBtn(bIsShow)
    end
end

-- 增加手柄快捷键提示
function Common_Dialog_ContentBase:ShowGamepadShortcutBtn(Params)
    if self.Owner then 
        return self.Owner:InitGamepadShortcut(Params)
    end
end

-- 隐藏手柄快捷键提示
function Common_Dialog_ContentBase:HideGamepadShortcut(Index)
    if self.Owner and Index then 
        self.Owner:HideGamepadShortcut(Index)
    end
end

-- 隐藏所有手柄快捷键
function Common_Dialog_ContentBase:HideAllGamepadShortcut(Index)
    if self.Owner then 
        self.Owner:HideAllGamepadShortcut()
    end
end

-- 显示手柄快捷键提示
function Common_Dialog_ContentBase:ShowGamepadShortcut(Index)
    if self.Owner then 
        self.Owner:ShowGamepadShortcut(Index)
    end
end

-- 显示所有手柄快捷键
function Common_Dialog_ContentBase:ShowAllGamepadShortcut()
    -- 使用提示：若为跨场景/跨内容进入后直接调用 ShowAll，为避免恢复旧索引
    -- 请在合适的时机先调用 Owner:ClearAllGamepadShortcutContent()
    if self.Owner and self.Owner.ShowAllGamepadShortcut then
        self.Owner:ShowAllGamepadShortcut()
    end
end

-- 显示手柄按B关闭提示
function Common_Dialog_ContentBase:ShowGamepadCloseBtn(bShow)
    if self.Owner then
        self.Owner:ShowGamepadCloseBtn(bShow)
    end
end
--更改关闭按钮的Text
function Common_Dialog_ContentBase:ChangeCloseShortKeyText(Text)
    local Key= self.Owner:GetGamepadShortcutByIndex(self.Owner.GamepadCloseBtnIndex)
    if Key then
        Key:SetDescription(Text)
    end
end


-----------------------------------------------------------------
-----------------------------------------------------------------

return Common_Dialog_ContentBase 
