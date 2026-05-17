--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Chapter_Transition02_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

function M:OnLoaded(...)
    self.Super.OnLoaded(self, ...)
    self.ChapterName, self.CantoName, self.Title , self.AudioPath, self.Func= ...

    local TS = TalkSubsystem()
    local IsInTalk = false
    if TS and TS:IsInImmersiveStory() then
        IsInTalk = true
    end

    local UIManager = UE4.UGameplayStatics.GetGameInstance(self):GetGameUIManager()
    if UIManager ~= nil and not IsInTalk then
        self:HideAllUIWithOutSelf(true, "Chapter_Transition")
    end
   -- self.QuestChainId = tonumber(...)
    -- local EpisodeName = DataMgr.QuestChain[self.QuestChainId].EpisodeName
    -- local Index = EpisodeName:sub(-1)
    AudioManager(self):PlayUISound(self, self.AudioPath, nil, nil)
    self:SetSwitchIndex()
    if self.In then
        self:UnbindAllFromAnimationFinished(self.In)
        self:BindToAnimationFinished(self.In, {self, self.OnEnd})
        self:PlayAnimation(self.In)
    end

end

function M:OnEnd()
    if self.Out then
        self:UnbindAllFromAnimationFinished(self.Out)
        self:BindToAnimationFinished(self.Out, {self, function()
            self:HideAllUIWithOutSelf(false, "Chapter_Transition")
            if self.Func then
                self.Func()
                self.Func = nil
            end
            self:Close()
        end})
        self:PlayAnimation(self.Out)
    end

end



function M:SetSwitchIndex()
    local Language = CommonConst.SystemLanguage
    if Language == CommonConst.SystemLanguages.CN  then
        self.WS_TopTextSign:SetActiveWidgetIndex(0)
        self.WS_BottomSubTitle:SetActiveWidgetIndex(0)
        self:SetText(self.Text_TopTextSign_ZH_CHS, self.Text_BottomSubTitle_ZH_CHS)
        -- self.Text_TopTextSign_ZH_CHS:SetText(GText("Name_100302"))
        -- self.Text_BottomSubTitle_ZH_CHS:SetText(GText("Episode_02_01"))
    elseif Language == CommonConst.SystemLanguages.TC then
        self.WS_TopTextSign:SetActiveWidgetIndex(1)
        self.WS_BottomSubTitle:SetActiveWidgetIndex(1)
        self:SetText(self.Text_TopTextSign_ZH_CHT, self.Text_BottomSubTitle_ZH_CHT)
        -- self.Text_TopTextSign_ZH_CHT:SetText(GText("Name_100302"))
        -- self.Text_BottomSubTitle_ZH_CHT:SetText(GText("Episode_02_01"))
    elseif Language == CommonConst.SystemLanguages.EN then
        self.WS_TopTextSign:SetActiveWidgetIndex(2)
        self.WS_BottomSubTitle:SetActiveWidgetIndex(2)
        self:SetText(self.Text_TopTextSign_EN, self.Text_BottomSubTitle_EN)
        -- self.Text_TopTextSign_EN:SetText(GText("Name_100302"))
        -- self.Text_BottomSubTitle_EN:SetText(GText("Episode_02_01"))
    elseif Language == CommonConst.SystemLanguages.JP then
        self.WS_TopTextSign:SetActiveWidgetIndex(3)
        self.WS_BottomSubTitle:SetActiveWidgetIndex(3)
        self:SetText(self.Text_TopTextSign_JA, self.Text_BottomSubTitle_JA)
        -- self.Text_TopTextSign_JA:SetText(GText("Name_100302"))
        -- self.Text_BottomSubTitle_JA:SetText(GText("Episode_02_01"))
    elseif Language == CommonConst.SystemLanguages.KR then  
       self.WS_TopTextSign:SetActiveWidgetIndex(4)
       self.WS_BottomSubTitle:SetActiveWidgetIndex(4)
       self:SetText( self.Text_TopTextSign_KR, self.Text_BottomSubTitle_KR)
    --    self.Text_TopTextSign_KR:SetText(GText("Name_100302"))
    --    self.Text_BottomSubTitle_KR:SetText(GText("Episode_02_01"))
    end
end

function M:SetText(TopText, BottomText)
    -- if Index == "1" then
    --     TopText:SetText(GText("Name_100301"))
    --     BottomText:SetText(GText("Episode_02_01"))
    -- elseif Index == "2" then
    --     TopText:SetText(GText("Name_100302"))
    --     BottomText:SetText(GText("Episode_02_02"))
    -- elseif Index == "3" then
    --     TopText:SetText(GText("Name_100303"))
    --     BottomText:SetText(GText("Episode_02_03"))
    -- elseif Index == "4" then
    --     TopText:SetText(GText("Name_100304"))
    --     BottomText:SetText(GText("Episode_02_04"))
    -- elseif Index == "5" then
    --     TopText:SetText(GText("Name_100305"))
    --     BottomText:SetText(GText("Episode_02_05"))
    -- elseif Index == "6" then
    --     TopText:SetText(GText("Name_100306"))
    --     BottomText:SetText(GText("Episode_02_06"))
    -- elseif Index == "7" then
    --     TopText:SetText(GText("Name_100307"))
    --     BottomText:SetText(GText("Episode_02_07"))
    -- end
    TopText:SetText(GText(self.Title))
    BottomText:SetText(GText(self.CantoName))
end


return M


