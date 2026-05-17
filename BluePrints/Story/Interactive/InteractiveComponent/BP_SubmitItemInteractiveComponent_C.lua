local M = Class("BluePrints.Story.Interactive.InteractiveComponent.BP_InteractiveBaseComponent_C")

local LuaConst = require("EMLuaConst")
local PopupId = 100301

function M:BtnPressed(PlayerActor)
    local Owner = self:GetOwner()
    if not IsValid(Owner) then return end

    DebugPrint("BP_SubmitItemInteractiveComponent_C: BtnPressed, Open UI")
    
    self:OpenSubmitUI(self.SubmitId)
end

function M:SetSubmitId(SubmitId)
    self.SubmitId = SubmitId
end

function M:BindSuccessCallback(SuccessCallback)
    self.SuccessCallback = SuccessCallback
end

function M:IsCanInteractive(PlayerActor)
    if not IsValid(PlayerActor) then
        return false
    end
    if self.InteractiveDistance and self.InteractiveDistance > 0 then
        if LuaConst.OpenComputeInteractive then
            return self:GetDistanceCheckResult()
        end
        return self:DistanceCheckComponent(PlayerActor, self.InteractiveDistance)
    end
    return true
end

function M:OpenSubmitUI(SubmitId)
    DebugPrint("BP_SubmitItemInteractiveComponent_C: Open UI for SubmitId", SubmitId)
    
    -- 使用通用弹窗 100301 (ResourceUseConfirm) 
    -- 脚本位置:Common_Dialog_LuaModel_CommitItem.lua
    local Params = {
        SubmitId = SubmitId,
        ItemList = {},                      -- 物品列表传入空table防止报错
        OnSubmitConfirmed = function(Res)
            if (Res) then
                if (self.SuccessCallback) then
                    self.SuccessCallback()
                end
            end
        end,
        DontCloseWhenRightBtnClicked = true, -- 禁用点击确定自动关闭
        ShortText = GText("UI_SubmitItem_Confirm"), -- 提交物品确认文本
        LargeSizeItem = true, -- 使用大尺寸物品图标
    }
    UIManager(self):ShowCommonPopupUI(PopupId, Params)
end

return M
