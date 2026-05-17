--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Story_Review_Impression_P_C
local M = Class({
    "BluePrints.UI.WBP.StoryReview.StoryReviewWidget.WBP_Story_Review_ItemBase",
})

--function M:Initialize(Initializer)
--end

function M:Construct()
    self.Text_Lose:SetText(GText("Impression_UI_CheckFail"))
    self.Text_Win:SetText(GText("Impression_UI_CheckSucc"))
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function M:SetItemRenderOpacity(Opacity)
    self.List_Item_1:SetRenderOpacity(Opacity)
end

function M:InitData(Data, ParentWidget)
    self.TalkData = Data
    self.FatherWidget = ParentWidget
    self.CurValue = 0
end

function M:ListOtherOptions()
    if self.CloseListHandle then
        ULTweenBPLibrary.KillIfIsTweening(self, self.CloseListHandle)
        self.CloseListHandle = nil
    end
    self.List_Item_1:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.FatherWidget:UpdateCurrentFocusWidgetPos(3)
    self.ShowListHandle = ULTweenBPLibrary.FloatTo(self, {self, function(_, Value)
        self.CurValue = Value
        self.GameInputModeSubsystem:UpdateCurrentFocusWidgetPos()
        self:SetItemRenderOpacity(Value)
        if Value == 1 then
            self.ShowListHandle = nil
        end
    end }, self.CurValue, 1, (1 - self.CurValue) * 0.25, 0, 0)
    local LTweenActor = UE4.ALTweenActor.GetLTweenInstance(self.ShowListHandle)
    if LTweenActor then
        LTweenActor:SetTickableWhenPaused(true)
    end
end

function M:RemoveOtherOptions()
    if self.ShowListHandle then
        ULTweenBPLibrary.KillIfIsTweening(self, self.ShowListHandle)
        self.ShowListHandle = nil
    end
    self.CloseListHandle = ULTweenBPLibrary.FloatTo(self, {self, function(_, Value)
        self.CurValue = Value
        self:SetItemRenderOpacity(Value)
        self.GameInputModeSubsystem:UpdateCurrentFocusWidgetPos()
        if Value == 0 then
            self.List_1:SetVisibility(UE4.ESlateVisibility.Collapsed)
            self.CloseListHandle = nil
            self.FatherWidget:UpdateCurrentFocusWidgetPos(2)
        end
        self.GameInputModeSubsystem:UpdateCurrentFocusWidgetPos()
    end }, self.CurValue, 0, self.CurValue * 0.25, 0, 0)
    local LTweenActor = UE4.ALTweenActor.GetLTweenInstance(self.CloseListHandle)
    if LTweenActor then
        LTweenActor:SetTickableWhenPaused(true)
    end
end

return M
