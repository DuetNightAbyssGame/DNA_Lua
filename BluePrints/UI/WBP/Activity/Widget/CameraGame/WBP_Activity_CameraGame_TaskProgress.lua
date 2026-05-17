require "UnLua"
local CameraGameUtils = require "BluePrints.UI.WBP.Activity.PC.CameraGame.CameraGameUtils"

local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})


function M:Construct()
    self.Text_Title:SetText(GText("UI_PhotoEvent_Progress"))
    self.Btn_Area.OnClicked:Add(self, self.OnButtonClicked)
end

function M:Destruct()
end

function M:Update()
    self:PlayAnimation(self.In)
end

-- 通用接口
function M:InitPage(EventId)
    self:PlayAnimation(self.In)
    self:InitPhotoProgress(EventId)
end

-- 初始化拍照进度
function M:InitPhotoProgress(EventId)
    local CurCount, TotalCount = CameraGameUtils.GetPhotoProgress()
    self.Text_Num01:SetText(CurCount)
    self.Text_Num02:SetText("/"..TotalCount)
end

-- 跳转到详情页
function M:OnButtonClicked()
    if self.ParentWidget and self.ParentWidget.GoToTargetPageClick then
        self.ParentWidget:GoToTargetPageClick()
    end
end

return M