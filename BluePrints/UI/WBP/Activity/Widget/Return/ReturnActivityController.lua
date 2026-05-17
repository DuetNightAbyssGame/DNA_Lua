--- 回归活动Controller


--- @class ReturnActivityController :Controller
local M = Class("BluePrints.Common.MVC.Controller")

function M:Init()
    M.Super.Init(self)
end

function M:Destory()
    M.Super.Destory(self)
end

function M:GetModel()
    return nil
end

function M:GetEventName()
    return nil
end

function M:TryDisplayReturnWelcomBanner()
    local GameInstance = GWorld.GameInstance
    if GameInstance then
        local LoadingUI = GameInstance:GetLoadingUI()
        local LoginMainPage = UIManager(GameInstance):GetUIObj("LoginMainPage")
        DebugPrint("DisplayMonthCardPop", LoadingUI)
        if LoadingUI or LoginMainPage then
            self.DisplayReturnWelcomBannerCache = true 
            return
        end
    end
    self:DisplayReturnWelcomBanner()
end

function M:DisplayReturnWelcomBanner()
    local GameInstance = GWorld.GameInstance
    if GameInstance then
        UIManager(GameInstance):LoadUINew("ComBackWelcomeBanner", function()
            DebugPrint("lgc@OnComeBackActivityOpen Load Async Success")
        end, "Async")
    end
end

_G.ReturnActivityController = M
return M

