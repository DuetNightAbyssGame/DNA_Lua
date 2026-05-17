require "UnLua"
local ShowPopupUIAsyncProxy = Class()

function ShowPopupUIAsyncProxy:ShowPopup_Impl(PopupId)
    local Params = {
        LeftCallbackFunction = function()
            self:HandleResult(false)
        end,
        
        RightCallbackFunction = function()
            self:HandleResult(true)
        end,

        OnCloseCallbackFunction = function()
            self:HandleResult(false)
        end,
    }

    UIManager(self):ShowCommonPopupUI(PopupId, Params)
end

return ShowPopupUIAsyncProxy