--
-- DESCRIPTION
-- 个人主页主界面 Mobile
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

local PersonInfoController = require "BluePrints.UI.WBP.PersonInfo.PersonInfoController"

local M = Class({"BluePrints.Common.TimerMgr", "BluePrints.UI.BP_EMUserWidget_C"})

M._components = {"BluePrints.UI.WBP.PersonInfo.Base.PersonInfoMainPageView"}

-- 界面初始化逻辑
function M:Construct()
    -- self.Super.Construct(self)
    self:InitBaseView()
end

-- 外部刷新界面的接口
function M:InitPage(Data)
    self:RefreshPageView(Data)
end
function M:ModelViewIni()
    self:FreshHideButton()
end
function M:FreshHideButton()
    if self.SelectCharIndex == -1 then
        PersonInfoController.MainPage.Com_BtnVisible:SetVisibility(UIConst.VisibilityOp.Collapsed)
    else
        PersonInfoController.MainPage.Com_BtnVisible:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
end
AssembleComponents(M)
return M
