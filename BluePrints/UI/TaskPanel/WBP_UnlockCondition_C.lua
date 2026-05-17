--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type Task_UnlockCondition_C
local WBP_UnlockCondition_C = Class("BluePrints.UI.BP_UIState_C")

function WBP_UnlockCondition_C:Initialize(Initializer)
    self.Super.Initialize(self)
    self.ConditionType = nil
    self.Func = nil
    self.Obj = nil
end

function WBP_UnlockCondition_C:Init(IsFinish, Owner)
    self.Owner = Owner
    self.Finish = IsFinish
    if IsFinish then
        self.Image_CheckMark:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self:PlayAnimation(self.Text_Complete)
    else
        self.Image_CheckMark:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self:PlayAnimation(self.Text_Normal)
    end


    self.Icon_Link:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Btn_UnlockConditionClick:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

function WBP_UnlockCondition_C:SetConditionText(ConditionType, IsFinish, Param)
    local NeedCompleteText = nil
    if ConditionType ~= "ShowTime" then
        NeedCompleteText = GText(DataMgr.ConditionText[ConditionType].ConditionName)
    end
    if not NeedCompleteText and ConditionType ~= "ShowTime"  then
        return
    end
    self.WS_Text:SetActiveWidgetIndex(0)
    if ConditionType == "PlayerLevelMin" or ConditionType == "PlayerLevelMax" then
        self.Text_Condition:SetText(NeedCompleteText..tostring(Param))
    elseif ConditionType == "QuestChain" or ConditionType == "TrueQuestChain" then
        local QuestChainName = DataMgr.QuestChain[Param].QuestChainName
        if not IsFinish then
            self.Text_Condition:SetText(NeedCompleteText..GText(QuestChainName))
        else
            self.Text_Condition:SetText(GText(QuestChainName))
        end
    elseif ConditionType == "ShowTime" then
        self.WS_Text:SetActiveWidgetIndex(1)
        local RemainTimeDict, TimeCount = UIUtils.GetLeftTimeStrStyle2(Param)
        self.Text_Condition_TimeTitle:SetVisibility(UE4.ESlateVisibility.Collapsed)
        local Time = self:TimestampToDateString(Param)
        self.Com_Time.Text_TimeTitle:SetText(GText("UI_Quest_StartTime"))
        self.Com_Time.Text_TimeDesc:SetText(Time)
    elseif ConditionType == "HaveGotSoloTreasureScore" then
        self.Text_Condition:SetText(NeedCompleteText..Param[2])
    end

    if IsFinish then
        self.Text_CompleteDesc:SetText(GText("UI_QUEST_UNLOCKFINISH"))
        self.Text_CompleteDesc:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self.Text_CompleteDesc:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function WBP_UnlockCondition_C:TimestampToDateString(timestamp)
    -- 设置默认格式
    local dateFormat = "%Y-%m-%d %H:%M:%S"
    
    -- 将时间戳转换为日期字符串
    local dateString = os.date(dateFormat, timestamp)
    
    return dateString
end

function WBP_UnlockCondition_C:BindEventOnClicked(Obj,Func,...)
    if not Obj or not Func then return end
    self.Icon_Link:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Btn_UnlockConditionClick:SetVisibility(UE4.ESlateVisibility.Visible)
    self.Obj = Obj
    self.Func = Func
    self.Param = {...}
end

function WBP_UnlockCondition_C:OnButtonClick()
    self:StopAllAnimations()
    -- self:UnbindAllFromAnimationFinished(self.Btn_Click)
    -- self:BindToAnimationFinished(self.Btn_Click,{self,function() self.Func(self.Obj,table.unpack(self.Param)) end})
    self.Func(self.Obj,table.unpack(self.Param))
    self:PlayAnimation(self.Btn_Click)
end

function WBP_UnlockCondition_C:OnConditionHovered()
    self:StopAnimation(self.Btn_UnHover)
    self:StopAnimation(self.Btn_UnHover)
    self:PlayAnimation(self.Btn_Hover)
end

function WBP_UnlockCondition_C:OnConditionUnHovered()
    self:StopAnimation(self.Btn_Hover)
    self:PlayAnimation(self.Btn_UnHover)
end

function WBP_UnlockCondition_C:OnAddedToFocusPath(InFocusEvent)
    if self.Finish then
        self.Owner:InitTabPadKeyInfoForBack()
    else
        if self.CanClick == nil then
            self.Owner:InitTabPadKeyInfoForBack()
        else
            self.Owner:InitTabPadKeyInfoForCondition()
        end
    end
    return UIUtils.Handle
end

return WBP_UnlockCondition_C
