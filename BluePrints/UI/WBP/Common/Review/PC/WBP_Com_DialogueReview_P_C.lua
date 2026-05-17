--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Com_DialogueReview_P_C
local M = Class("BluePrints.UI.BP_UIState_C")

--function M:Initialize(Initializer)
--end

--function M:PreConstruct(IsDesignTime)
--end

function M:Construct()
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        -- local KeyText = CommonUtils:GetKeyText(CommonUtils:GetActionMappingKeyName("OpenMenu"))
        local KeyText = CommonUtils:GetActionMappingKeyName("OpenMenu")
        self.Key_Close:CreateCommonKey({
            KeyInfoList = {
                {
                    Type = "Text",
                    Text = KeyText,
                    ClickCallback = self.CloseSelf,
                    Owner = self,
                },
            },
            Desc = GText("UI_Rouge_Event_ReviewESC")
        })
    end
    self.Btn_Close:Init("Close", self, self.CloseSelf)
end

--DialogueList = {
--    {
--        DialogueType = 0, -- 0是非主角说的，1是主角说的，2是选择选项的内容，3是旁白说的
--        SpeakerName = "", -- 说话者名字（旁白说的不需要名字）
--        DialogueContent = "", -- 说话内容
--    },
--}
function M:InitUIInfo(Name, IsInUIMode, EventList, DialogueList, ParentUI)
    self:SetFocus()
    AudioManager(self):PlayUISound(self, "event:/ui/roguelike/level_event_review_show", nil, nil)
    
    self:InitList(DialogueList)
    self.ParentUI = ParentUI
    self.Super.InitUIInfo(self, Name, IsInUIMode, EventList, DialogueList, ParentUI)
end

function M:InitList(DialogueList)
    self.ListView:ClearListItems()
    DebugPrint(#DialogueList)
    for i=1, #DialogueList do
        local Obj = NewObject(self.ListContentClass)
        Obj.DialogueType = DialogueList[i].DialogueType
        Obj.SpeakerName = DialogueList[i].SpeakerName
        Obj.DialogueContent = DialogueList[i].DialogueContent
        self.ListView:AddItem(Obj)
    end
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if InKeyName == "Escape" then
        self:CloseSelf()
    elseif InKeyName == "Tab" then
        self:CloseSelf()
    end
    return self.Super.OnPreviewKeyDown(self, MyGeometry, InKeyEvent)
end

function M:CloseSelf()
    if (not self.IsInit) then
        -- 没有完全初始化之前不允许关闭
        return
    end
    self:Close()
    if self.ParentUI then
        self.ParentUI:SetFocus() -- 小功能，关闭回顾界面之后重新Focus回主界面
    end
end

return M
