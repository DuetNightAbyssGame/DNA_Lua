--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_PersonalInfo_Title_TitleContentItem_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
-- function M:Initialize(Initializer)
-- end

function M:Construct()
    self.Btn_ChangeTitle.OnClicked:Add(self, self.OnClickChangeTitle)
    self.Btn_SetTitle.OnClicked:Add(self, self.OnClickChangeTitle)
    EventManager:AddEvent(EventID.OnChangeTitle, self, self.OnTitleChange)
    self.IsSelf = true
    self.Text_Set:SetText(GText("UI_PersonalPage_Title_Set"))
end
-- 个人主页用，查看他人主页需要不同样式
function M:Init(Isself)
    self.IsSelf = Isself
    if self.IsSelf == false then
        self:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    end
end
function M:OnTitleChange()
    local Avatar = GWorld:GetAvatar()
    local TitleBefore = Avatar.TitleBefore
    local TitleAfter = Avatar.TitleAfter
    local TitleFrame = Avatar.TitleFrame
    self:Freshtitle(TitleBefore, TitleAfter, TitleFrame)
end
function M:Freshtitle(TitleBefore, TitleAfter, TitleFrame)
    if self.IsSelf then
        if TitleBefore == -1 and TitleAfter == -1 then
            self.WS_Title:SetActiveWidgetIndex(1)
        else
            self.WS_Title:SetActiveWidgetIndex(2)
            local TileFrameWidget = UIManager(self):LoadTitleFrameWidget(TitleFrame)
            if not TileFrameWidget then
                return
            end
            local TitleText = UIUtils.CalculateHoleTitle(TitleBefore, TitleAfter)
            TileFrameWidget.Text_Title:SetText(TitleText)
            self.Group_Title:ClearChildren()
            self.Group_Title:AddChildToOverlay(TileFrameWidget)
        end
    else
        if TitleBefore == -1 and TitleAfter == -1 then
            self.WS_Title:SetActiveWidgetIndex(0)
        else
            self.WS_Title:SetActiveWidgetIndex(2)
            local TileFrameWidget = UIManager(self):LoadTitleFrameWidget(TitleFrame)
            if not TileFrameWidget then
                return
            end
            local TitleText = UIUtils.CalculateHoleTitle(TitleBefore, TitleAfter)
            TileFrameWidget.Text_Title:SetText(TitleText)
            self.Group_Title:ClearChildren()
            self.Group_Title:AddChildToOverlay(TileFrameWidget)
        end
    end
end
function M:Destruct()
    EventManager:RemoveEvent(EventID.OnChangeTitle, self)
end
function M:OnClickChangeTitle()
    ReddotManager.ClearLeafNodeCount("TitleBtn", true)
    AudioManager(self):PlayUISound(self, "event:/ui/common/click", nil, nil)
    AudioManager(self):PlayUISound(self, "event:/ui/common/title_setting_panel_expand", "title_setting_panel_expand_sfx", nil)
    UIManager(self):ShowCommonPopupUI(100239, {
        CloseBtnCallbackObj = self,
        CloseBtnCallbackFunction = function(self)
            ScreenPrint("OnClickChangeTitle")
            AudioManager(self):SetEventSoundParam(self, "title_setting_panel_expand_sfx", {
                ToEnd = 1
            })
        end
    }, self)
end
-- function M:Tick(MyGeometry, InDeltaTime)
-- end

-- function M:Destruct()
-- end

return M
