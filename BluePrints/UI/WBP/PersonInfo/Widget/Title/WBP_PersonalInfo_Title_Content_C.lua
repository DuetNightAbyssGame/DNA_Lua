--
-- DESCRIPTION
-- 弹窗整体脚本
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_PersonalInfo_Title_Content_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

-- local M = Class({"BluePrints.UI.UIstate"})
local Unhandled = UE4.UWidgetBlueprintLibrary.Unhandled()
local Handled = UE4.UWidgetBlueprintLibrary.Handled()
---仅初始化lua变量时使用，千万不要有控件操作！！
function M:Initialize(Initializer)
    self.SuffixTitleID = nil
    self.PrefixTitleId = nil
    self.CurrentTitleFrameID=nil
end
local StyleBPPath =
    "BluePrints.UI.WidgetBlueprint'/Game/UI/WBP/PersonalInfo/Widget/Title/WBP_PersonalInfo_Title_TypeContent.WBP_PersonalInfo_Title_TypeContent'"
local ContentBPPath =
    "WidgetBlueprint'/Game/UI/WBP/PersonalInfo/Widget/Title/WBP_PersonalInfo_Title_TitleContent.WBP_PersonalInfo_Title_TitleContent'"
function M:InitContent()
    self.CurrentTitleWidget = nil -- 选中的标题
    self.CurrentTitleFrameID = nil -- 选中的标题ID

    self.TitleWidgetMap = {}
    self:SetFocus()
    self:LoadData()

    self.Dialog = UIManager(self):GetUIObj("CommonDialog")
    self.Tab = self.Dialog.DialogTitle
    if self.Tab then
        self:InitTab()
    end
    self.Btn_Change.Text_Button:SetText(GText("UI_PersonalPage_Title_Equip"))
    self.Btn_Change.Button_Area.OnClicked:Add(self, self.OnComfirmBtnClick)
    self.Btn_Random.Button_Area.OnClicked:Add(self, self.OnRandomBtnClick)
    self.Btn_Random:TryOverrideSoundFunc(function(Widget)
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)    end)
    self.Btn_Change:TryOverrideSoundFunc(function(Widget)
            AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_confirm", nil, nil)    end)  
    self.Key_Random:CreateGamepadKey(UIConst.GamePadImgKey.FaceButtonLeft)

    self.Text_DetailTitle:SetText(GText("UI_PersonalPage_Title_Frame"))
    self.Text_Lock:SetText(GText("UI_PersonalPage_Title_NeedEquip"))

    self:AddTimer(0.01, function()
        self:LatenInit()
    end)

    self.Text_Empty:SetText(GText("UI_PersonalPage_Title_NoEquip"))
    self.Com_Hint.WidgetSwitcher_State:SetActiveWidgetIndex( 2)
end
---加载表中配置的可选称号
function M:LoadData()
    local Avatar = GWorld:GetAvatar()
    self.UsedFrameId = Avatar.TitleFrame
    self.PrefixTitleId = Avatar.TitleBefore
    self.SuffixTitleID = Avatar.TitleAfter
    local FrameId = Avatar.TitleFrame
    if FrameId then
        if DataMgr["TitleFrame"] and DataMgr["TitleFrame"][FrameId] and DataMgr["TitleFrame"][FrameId].Name then
            local FrameData = DataMgr["TitleFrame"][FrameId]
            self.Text_DetailType:SetText(GText(FrameData.Name))
        else
            ScreenPrint("没有找到佩戴的头像 ID为" .. FrameId or "空")
        end
    end
    self.TitleFrameDatas = DataMgr["TitleFrame"]
    -- 初始化称号
    self:OnTietleStyleChange(self.UsedFrameId)
end
function M:InitTitleFrame()
    self.Title:ClearChildren()
    self:OnTietleStyleChange(self.CurrentTitleWidget)
end
function M:InitTab()
    local Tabs = {}
    Tabs[1] = {
        Text = GText("UI_PersonalPage_Title_Name"),
        Idx = 1
    }
    Tabs[2] = {
        Text = GText("UI_PersonalPage_Title_Frame"),
        Idx = 2
    }

    local ConfigData = {
        Owner = self,
        LeftKey = "Q",
        RightKey = "E",
        LeftGamePadKey = "LeftShoulder",
        RightGamePadKey = "RightShoulder",
        -- ChildWidgetName = "ModArchiveTabSubItem",
        Tabs = Tabs,
        SoundFuncReceiver = self,
        SoundFunc =function()
            AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_sort_tab", "TitleClose", nil)
        end
    }

    self.Tab.Com_Tab:Init(ConfigData)

    self.Tab.Com_Tab:BindEventOnTabSelected(self, self.OnTabChange)
    local TabId = 1
    self.Tab.Com_Tab:SelectTab(TabId)

    ReddotManager.AddListenerEx("TitleTab", self, self.OnTitleTabReddotChange)
    ReddotManager.AddListenerEx("TitleFrameTab", self, self.OnTitleFrameTabReddotChange)
end
function M:OnTabChange(TabWidget)
    
    self.TabId = TabWidget.Idx
    local Idx = TabWidget.Idx
    if Idx == 1 then
        if self.TitleStylePage then
            self.TitleStylePage:SetVisibility(ESlateVisibility.Collapsed)
            self.TitleStylePage:ResetEquipFrame()
        end
        --ScreenPrint("WBP_PersonalInfo_Title_Content_C:OnTabChange 1")
        if self.TitleContentPage == nil then
            self.TitleContentPage = UIManager(self):CreateWidget(ContentBPPath, false)
            self.Content:AddChildToOverlay(self.TitleContentPage)
            self.TitleContentPage:InitBaseView()
            self.TitleContentPage.FatherPage = self
        else

            self.TitleContentPage:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        end
        self:OnTitleContentPageSwitch()
    elseif Idx == 2 then
        if self.TitleContentPage then
            self.TitleContentPage:SetVisibility(ESlateVisibility.Collapsed)
        end
        --ScreenPrint("WBP_PersonalInfo_Title_Content_C:OnTabChange 2")
        if self.TitleStylePage == nil then
            self.TitleStylePage = UIManager(self):CreateWidget(StyleBPPath, false)
            self.Content:AddChildToOverlay(self.TitleStylePage)
            self.TitleStylePage:InitBaseView()
            self.TitleStylePage.FatherPage = self
        else
            self.TitleStylePage:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        end
        self:OnTitleStylePageSwitch()

    end
end
function M:LatenInit()
    self.SwitchBtnIdx = self.Dialog:InitGamepadShortcut({
        KeyInfoList = {{
            Type = "Img",
            ImgShortPath = "LH"
        }},
        Desc = GText("UI_Controller_Switch")
    }, 2)

    self.AdjustBtnIdx = self.Dialog:InitGamepadShortcut({
        KeyInfoList = {{
            Type = "Img",
            ImgShortPath = "LV"
        }},
        Desc = GText("UI_CTL_Adjust")
    }, 3)
end
function M:InitBaseView()
    --ScreenPrint("WBP_PersonalInfo_Title_Content_C:InitBaseView")
end
---称号选择界面选中
function M:OnTitleContentPageSwitch()
    --ScreenPrint("WBP_PersonalInfo_Title_Content_C:OnTitleContentPageSwitch")
    local Avatar = GWorld:GetAvatar()
    local PrefixTitleId = Avatar.TitleBefore
    local SuffixTitleID = Avatar.TitleAfter
    self.WS:SetActiveWidgetIndex(0)
    local PrefixTitleTable, SuffixTitleTable = UIUtils.GetSortedTitleTable(PrefixTitleId, SuffixTitleID)
    if #PrefixTitleTable > 1 and #SuffixTitleTable > 1 then
        self.Btn_Random:ForbidBtn(false)
        self.Btn_Random:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
        self.Btn_Random:ForbidBtn(true)
        self.Btn_Random:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    end
    self.TitleContentPage:SetFocus()
    if self.IsGamePad then
        self.TitleContentPage:InitGamepadView()
    else
        self.TitleContentPage:InitKeyboardView()
    end
    self.Dialog:ShowGamepadShortcut(self.AdjustBtnIdx)
    self.Dialog:ShowGamepadShortcut(self.SwitchBtnIdx)
    self:FreshBtnStatebyTitle()
    if self.PrefixTitleId == -1 and self.SuffixTitleID == -1 then
        self.WS_Detail:SetActiveWidgetIndex(1) 
    else
        self.WS:SetActiveWidgetIndex(0)
    end
    self.WS_Btn:SetActiveWidgetIndex(0) --取消显示获取途径
end
function M:OnTitleStylePageSwitch()

    --离开称号选择界面需要重置
    self.TitleContentPage:InitSelect(false)

    -- 禁用快捷键手柄
    self.Dialog:HideGamepadShortcut(self.AdjustBtnIdx)
    self.Dialog:HideGamepadShortcut(self.SwitchBtnIdx)
    -- 按钮修改
    self.Btn_Random:SetVisibility(UIConst.VisibilityOp.Collapsed)

    if self.IsGamePad then
        self.TitleStylePage:InitGamepadView()
    else
        self.TitleStylePage:InitKeyboardView()
    end

    if self.PrefixTitleId == -1 and self.SuffixTitleID == -1 then
        self.WS:SetActiveWidgetIndex(1)
    else
        self.WS:SetActiveWidgetIndex(0)
    end

    self.WS_Detail:SetActiveWidgetIndex(0)
    

    self:FreshBtnStatebyFrame()
end

function M:OnRandomBtnClick()
    --ScreenPrint("WBP_PersonalInfo_Title_Content_C:OnRandomBtnClick")
    self.TitleContentPage:RandomSelectTitle()
end

-- 称号内容修改预览
function M:OnTietleContentChange(PrefixTitleId, SuffixTitleID)
    self.PrefixTitleId = PrefixTitleId
    self.SuffixTitleID = SuffixTitleID
    -- ScreenPrint("WBP_PersonalInfo_Title_Content_C:OnTietleContentChange" .. (PrefixTitleId or " kong ") ..
    --                 (SuffixTitleID or " kong "))
    self:FreshTitleText()
    local Avatar = GWorld:GetAvatar()
    if Avatar.TitleBefore == PrefixTitleId and Avatar.TitleAfter == SuffixTitleID then
        self.Btn_Change:ForbidBtn(true)
        self.Btn_Change:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        self.Btn_Change.Text_Button:SetText(GText("UI_PersonalPage_Title_Equipped"))
    else
        self.Btn_Change:ForbidBtn(false)
        self.Btn_Change.Text_Button:SetText(GText("UI_PersonalPage_Title_Equip"))
        self.Btn_Change:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end

    self:FreshBtnStatebyTitle()
end
---刷新按钮状态
function M:FreshBtnStatebyTitle()
    local Avatar = GWorld:GetAvatar()
    if Avatar.TitleBefore == self.PrefixTitleId and Avatar.TitleAfter == self.SuffixTitleID then
        self.Btn_Change:ForbidBtn(true)
        self.Btn_Change:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        self.Btn_Change.Text_Button:SetText(GText("UI_PersonalPage_Title_Equipped"))
    else
        self.Btn_Change:ForbidBtn(false)
        self.Btn_Change.Text_Button:SetText(GText("UI_PersonalPage_Title_Equip"))
        self.Btn_Change:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
end
---根据称号框刷新称号样式
function M:FreshBtnStatebyFrame()
    local Avatar = GWorld:GetAvatar()
    -- 选中已装备按钮的禁用逻辑
    if Avatar.TitleFrame == self.CurrentTitleFrameID then
        self.Btn_Change:ForbidBtn(true)
        self.Btn_Change:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        self.Btn_Change.Text_Button:SetText(GText("UI_PersonalPage_Title_Equipped"))
    else
        self.Btn_Change:ForbidBtn(false)
        self.Btn_Change.Text_Button:SetText(GText("UI_PersonalPage_Title_Equip"))
        self.Btn_Change:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end

    if not Avatar.TitleFrames[self.CurrentTitleFrameID] then
        self.WS_Btn:SetActiveWidgetIndex(1)
        local TitleFrameData = DataMgr["TitleFrame"][self.CurrentTitleFrameID]
        if TitleFrameData then
            self.Com_Hint.Text_Hint_Locked:SetText(GText(TitleFrameData.AccessText))
            self.WS:SetActiveWidgetIndex(0)
        end
    else
        if self.PrefixTitleId == -1 and self.SuffixTitleID == -1 then
            self.WS:SetActiveWidgetIndex(1) --请先佩戴称号
        else
            self.WS:SetActiveWidgetIndex(0) --恢复
        end
        self.WS_Btn:SetActiveWidgetIndex(0) --取消显示获取途径
    end
end


function M:IsCanChangeTitle()
    return self.Btn_Change:IsBtnForbidden()==false and self.WS:GetActiveWidgetIndex() ==0 and self.WS_Btn:GetActiveWidgetIndex() ==0
end
function M:IsRandomBtnCanClick()
    return self.Btn_Random:IsBtnForbidden()==false
end
---标题修改预览
function M:OnTietleStyleChange(FrameId)

    if self.CurrentTitleFrameID == FrameId then
        return
    end
    if self.CurrentTitleWidget then
        self.CurrentTitleWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    local FrameData = self.TitleFrameDatas[FrameId]
    if self.TitleWidgetMap[FrameId] then
        self.TitleWidgetMap[FrameId]:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.CurrentTitleWidget = self.TitleWidgetMap[FrameId]
        self.CurrentTitleFrameID = FrameId
        self:FreshTitleText()
    else
        if FrameData then
            if not self.TitleWidgetMap[FrameId] then
                local FramePath = FrameData.FramePath
                local Widget = UIManager(self):LoadTitleFrameWidget(FrameId)
                if Widget then
                    self.Title:AddChildToOverlay(Widget)
                    self.CurrentTitleWidget = Widget
                    self.CurrentTitleFrameID = FrameId
                    self:FreshTitleText()
                    self.TitleWidgetMap[FrameId] = Widget
                else
                    ScreenPrint("WBP_PersonalInfo_Title_Content_C:OnTietleStyleChange FramePath is Worng")
                end
            end
        else
            ScreenPrint("WBP_PersonalInfo_Title_Content_C:OnTietleStyleChange FrameData is nil")
        end
    end
    if  self.CurrentTitleWidget and self.CurrentTitleWidget.In then
        self.CurrentTitleWidget:PlayAnimation(self.CurrentTitleWidget.In)
    end
    if FrameId then
        if DataMgr["TitleFrame"] and DataMgr["TitleFrame"][FrameId] and DataMgr["TitleFrame"][FrameId].Name then
            local FrameData = DataMgr["TitleFrame"][FrameId]
            self.Text_DetailType:SetText(GText(FrameData.Name))
        else
            ScreenPrint("没有找到佩戴的头像 ID为" .. FrameId or "空")
        end
    end
    self:FreshBtnStatebyFrame()
end
function M:FreshTitleText()
    if self.PrefixTitleId == -1 and self.SuffixTitleID == -1 then
        if self.TabId == 1 then
            self.WS_Detail:SetActiveWidgetIndex(1)
        else
            self.CurrentTitleWidget:SetTitleContent("——","——")
        end
        self.CurrentTitleWidget:SetEmpty()
    else
        self.WS_Detail:SetActiveWidgetIndex(0)
        self.CurrentTitleWidget:SetTitleContent(self.PrefixTitleId, self.SuffixTitleID)
    end
end
function M:OnComfirmBtnClick()
    if self.Avatar == nil then
        self.Avatar = GWorld:GetAvatar()
    end
    if self.TabId == 1 then
        local NowTitleBefor = self.Avatar.TitleBefore
        local NowTitleAfter = self.Avatar.TitleAfter
        local NewTitleBefor, NewTitleAfter = self.TitleContentPage:GetCurrentSelectTitle()
        -- if NewTitleBefor ~= NowTitleBefor then
            
        self.Avatar:ChangeTitleBefore(NewTitleBefor)
        -- ScreenPrint("更改前缀称号" .. (NowTitleBefor or " kong ") .. "  变成了  " ..
        --                 (NewTitleAfter or " kong "))
        self.Avatar:ChangeTitleAfter(NewTitleAfter)
        -- ScreenPrint("更改后缀称号" .. (NowTitleBefor or " kong ") .. "  变成了  " ..
        --                 (NewTitleAfter or " kong "))
        -- end
    else
        --local NowTitleFrame = self.Avatar.TitleFrame
        local NewTitleFrame = self.CurrentTitleFrameID
        self.Avatar:ChangeTitleFrame( NewTitleFrame)
        self.TitleStylePage:EquipSelectedTitleFrame()
    end

    self.Btn_Change:ForbidBtn(true)
    self.Btn_Change:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.Btn_Change.Text_Button:SetText(GText("UI_PersonalPage_Title_Equipped"))
    UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("UI_Change_Success"))
end
-- function M:Tick(MyGeometry, InDeltaTime)
-- end

function M:Destruct()
    ReddotManager.RemoveListener("TitleTab", self)
    ReddotManager.RemoveListener("TitleFrameTab", self)
end
function M:OnContentPreviewKeyDown(MyGeometry, InKeyEvent)
    -- ScreenPrint("WBP_PersonalInfo_Title_Content_C:OnContentPreviewKeyDown")
end
function M:OnContentAnalogValueChanged(MyGeometry, InAnalogInputEvent)
    -- ScreenPrint("WBP_PersonalInfo_Title_Content_C:OnContentAnalogValueChanged")
end

function M:InitGamepadView()
    self.IsGamePad = true
    if self.TabId == 1 then
        self.TitleContentPage:InitGamepadView()
    else
        self.TitleStylePage:InitGamepadView()
    end
    self.Key_Random:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)

end
function M:InitKeyboardView()
    self.IsGamePad = false

    if self.TabId == 1 then
        self.TitleContentPage:InitKeyboardView()
    else
        self.TitleStylePage:InitKeyboardView()
    end
    self.Key_Random:SetVisibility(UIConst.VisibilityOp.Collapsed)
end
function M:OnKeyDown(MyGeometry, InKeyEvent)
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        -- self.PersonInfoMainPage:RotateActorForGamePad()
        self.IsGamePad = true
        IsEventHandled = self:OnGamePadDown(InKeyName)
    else
        self.IsGamePad = false

    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
    
end
function M:OnGamePadDown(InKeyName)
    -- if (InKeyName == UIConst.GamePadKey.LeftShoulder) then
    --     self.Tab.Com_Tab:ClickTab(1)
    --     IsEventHandled = true
    -- end
    -- if (InKeyName == UIConst.GamePadKey.RightShoulder) then
    --     self.Tab.Com_Tab:ClickTab(2)
    --     IsEventHandled = true   
    -- end
end
function M:OnTitleTabReddotChange( Count, RdType, RdName)
        self.Tab.Com_Tab:ShowTabRedDot(1,Count>0 )
end
function M:OnTitleFrameTabReddotChange(Count, RdType, RdName)
        self.Tab.Com_Tab:ShowTabRedDot(2,Count>0 )
end
return M
