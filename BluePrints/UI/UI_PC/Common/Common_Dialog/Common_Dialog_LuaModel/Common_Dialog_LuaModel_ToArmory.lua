require "UnLua"
local Common_Dialog_LuaModel_ToArmory = Class("BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_LuaModel.Common_Dialog_LuaModel_Base")

function Common_Dialog_LuaModel_ToArmory:Initialize()
    self.DialogWidget = UIManager(self):GetUIObj("CommonDialog")
     local OpenArmoryFromPopup = function(Obj, Data, DialogWidget)
        DebugPrint("yklua OpenArmoryFromPopup")
        DialogWidget.ClickResult = true
    end
--用OnDialogClosedCallback而不是RightCallbackFunction的原因是军械库界面会暂停弹窗关闭动画，导致关闭界面后还有老的弹窗残留
    local OnDialogClosedCallback = function(Obj, Data, DialogWidget)
        DebugPrint("yklua OnDialogClosedCallback")

        if DialogWidget.ClickResult == true then
            PageJumpUtils:JumpToTargetPageByJumpId(52)
            local ArmoryMain = UIManager(self):GetUIObj("ArmoryMain")
            if ArmoryMain then
                UIManager(self):GetUIObj("ArmoryMain").OnCloseDelegate = {nil, function()
                    -- local DialogWidget = UIManager(self):GetUIObj("CommonDialog")
                    -- DialogWidget.RightBtnClickedCallback=nil
                    -- DialogWidget.OnCloseCallbackFunction=nil
                    UIUtils:OpenPopupToArmory()
                end, self}
            else
                DebugPrint("没有找到军械库界面，关闭界面后不会打开弹窗。")
            end

        end
    end
    -- local Parms = {
    --     RightCallbackFunction = OpenArmoryFromPopup,
    --     RightCallbackObj = self,
    --     OnCloseCallbackFunction = OnDialogClosedCallback
    -- }
    ---STL里占用了回调函数，所以不能直接用覆盖，包裹一下执行
    if  self.OnCloseCallbackFunction  then
        local OriginFunc= self.OnCloseCallbackFunction
        local NewFunc=function(Obj, Data, DialogWidget)
            OnDialogClosedCallback(Obj, Data, DialogWidget)
            OriginFunc(Obj, Data, DialogWidget)
            --UIManager(self):GetUIObj("CommonDialog").OnCloseCallbackFunction=nil
        end
        self.DialogWidget.OnCloseCallbackFunction=NewFunc
    else
        self.OnCloseCallbackFunction=OnDialogClosedCallback
    end
    self.OnCloseCallbackObj=self
    self.RightBtnCallbackObj=self
    if  self.DialogWidget.RightBtnClickedCallback then
        local OriginFunc= self.DialogWidget.RightBtnClickedCallback
        local NewFunc=function(Obj, Data, DialogWidget)
            OpenArmoryFromPopup(Obj, Data, DialogWidget)
            OriginFunc(Obj, Data, DialogWidget)
            self.OriginFunc=nil
            self.RightBtnClickedCallback=nil
            self.DialogWidget.RightBtnClickedCallback=nil
        end
        self.DialogWidget.RightBtnClickedCallback=NewFunc
    else
        self.RightBtnClickedCallback=OpenArmoryFromPopup
    end
  
end

return Common_Dialog_LuaModel_ToArmory