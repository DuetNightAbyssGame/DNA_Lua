require "UnLua"

-- local Component = {}

-- return Component
---目前个人主页和ESC界面混用，但是两者随着迭代逻辑差异越来越大，未来或需要分离
require "UnLua"

local UIUtils = require "Utils.UIUtils"
local Component = {}
local TimeUtils = require "Utils.TimeUtils"

function Component:Initialize()
    self.BtnName = {'UI_PersonInfo_Name', 'UI_Menu_Option_ChangeHead', 'UI_COMMONPOP_TITLE_100054',
                    'UI_COMMONPOP_TITLE_100055','UI_PersonalPage_Title_Change', 'UI_COMMONPOP_TITLE_100056', 'UI_Menu_Option_CopyUID'}
    self.ClickFunction = {"OnClickPersonalInfo", "OnClickChangePortrait", "OnClickChangeName", "OnClickChangeSignature",'OnClickChangeTitle',
                          "OnClickChangeBirthday", "OnCopyUID"}
    self.CommunityBtnName = {"UI_OPTION_CustomerService", "UI_OPTION_ExchangeCode"}
    self.CommunityClickFunction = {"OnClickServece", "OnExchangeCodeClicked"}
    local Avatar = GWorld:GetAvatar()
    if Avatar and self.IsPersonInfoPage then
        local AvatarBirth = {}
        AvatarBirth[1], AvatarBirth[2], AvatarBirth[3] = Avatar:GetAvatarBirthday()
        if AvatarBirth[3] <= 0  then
            table.remove(self.BtnName, 6)
            table.remove(self.ClickFunction, 6)
            self.BirthDayRemoved = true
        end
    end
    if (self.IsPersonInfoPage) then
        table.remove(self.BtnName, 1)
        table.remove(self.ClickFunction, 1)
       -- table.insert(self.BtnName, 1, 'UI_PersonalPage_Title_Change')
       -- table.insert(self.ClickFunction, 1, 'OnClickChangeTitle')
    end
    self.BtnIdx = 0
end

-- 点击空白处
function Component:OnLoaded()
    self:InitBaseView()
end

function Component:InitBaseView()

    self.Edit_List.BP_OnItemClicked:Add(self, self.OnListBtnClicked)
    if self.List_Community then
        self.List_Community.BP_OnItemClicked:Add(self, self.OnListBtnClicked)
    end
    self.Button_Edit.New:SetRenderOpacity(1)
    self.Button_Edit.AudioEventPath = "event:/ui/common/click_btn_small"
    self.Button_Edit.Button_Area.OnClicked:Add(self, self.OnClickEdit)
    if self.Close_Area then
        self.Close_Area.OnClicked:Add(self, self.CloseEdit) -- 个人主页
    end

    self:InitBtnList()
    -- 需求，先屏蔽
    -- self:InitCommmunity()
    local Avatar = GWorld:GetAvatar()
    local Month, Day = Avatar:GetAvatarBirthday()
    -- self.Text_Birth:SetText(GDate("Date_MD", {
    --     Month = Month,
    --     Day = Day
    -- }))
end

function Component:InitBtnList()
    self.Edit_List:ClearListItems()
    -- local ClassPath = UE4.LoadClass('/Game/UI/WBP/Menu/Widget/Menu_Btn_Cell_Content_PC.Menu_Btn_Cell_Content_PC')
    local ClassPath = UIUtils.GetCommonItemContentClass()
    for i = 1, #self.BtnName do
        local MenuContent = NewObject(ClassPath)
        MenuContent.Id = i
        if self.BtnName[i] == 'UI_Menu_Option_ChangeHead' then
            MenuContent.ReddotName = "EscPortrait"
        end
        if self.BtnName[i]=='UI_PersonalPage_Title_Change' then
            MenuContent.ReddotName = "TitleBtn"
        end
        if self.IsPersonInfoPage then
            MenuContent.BtnName = GText(self.BtnName[i])
        else
            MenuContent.BtnName = self.BtnName[i]
        end

        MenuContent.ParentWidget = self
        if self.ClickFunction[i] ~= nil then
            MenuContent.OnClickFunction = self.ClickFunction[i]
        end
        if self.IsPersonInfoPage and self.ClickFunction[i] ~= nil then
            MenuContent.BtnClickFunction = function()
                self:OnListBtnClicked(MenuContent)
            end
        end
        self.Edit_List:AddItem(MenuContent)
        if self.BtnName[i] == 'UI_PersonInfo_Name' and self.Btn_PersonalInfo then
            self.Btn_PersonalInfo.Button_Area:SetVisibility(UIConst.VisibilityOp.Visible)
            self.Btn_PersonalInfo.Button_Area.OnClicked:Add(self.Btn_PersonalInfo, self.Btn_PersonalInfo.OnClicked)
            self.Btn_PersonalInfo:OnListItemObjectSet(MenuContent)
        elseif self.BtnName[i] == 'UI_Menu_Option_ChangeHead' and self.Btn_Head then
            self.Btn_Head.Button_Area:SetVisibility(UIConst.VisibilityOp.Visible)
            self.Btn_Head.Button_Area.OnClicked:Add(self.Btn_Head, self.Btn_Head.OnClicked)
            self.Btn_Head:OnListItemObjectSet(MenuContent)
        elseif self.BtnName[i] == 'UI_COMMONPOP_TITLE_100054' and self.Btn_Name then
            self.Btn_Name.Button_Area:SetVisibility(UIConst.VisibilityOp.Visible)
            self.Btn_Name.Button_Area.OnClicked:Add(self.Btn_Name, self.Btn_Name.OnClicked)
            self.Btn_Name:OnListItemObjectSet(MenuContent)
        elseif self.BtnName[i] == 'UI_COMMONPOP_TITLE_100055' and self.Btn_Signature then
            self.Btn_Signature.Button_Area:SetVisibility(UIConst.VisibilityOp.Visible)
            self.Btn_Signature.Button_Area.OnClicked:Add(self.Btn_Signature, self.Btn_Signature.OnClicked)
            self.Btn_Signature:OnListItemObjectSet(MenuContent)
        elseif self.BtnName[i] == 'UI_PersonalPage_Title_Change'and self.Btn_Title then
            self.Btn_Title.Button_Area:SetVisibility(UIConst.VisibilityOp.Visible)
            self.Btn_Title.Button_Area.OnClicked:Add(self.Btn_Title, self.Btn_Title.OnClicked)
            self.Btn_Title:OnListItemObjectSet(MenuContent)
        end
    end

    -- local items = self.Edit_List:GetListItems()
    -- for i = 1, items:Num() do
    --     local item = items[i]
    --     if item then
    --         local widget = item.SelfWidget or item.ParentWidget
    --         if widget then
    --             widget.bDecendantPreviouslyFocused = true
    --         end
    --     end
    -- end
    -- self.Edit_List:SetSelectedIndex(self.BtnIdx)
end

function Component:InitCommmunity()
    if not self.List_Community then
        return
    end
    self.List_Community:SetVisibility(UIConst.VisibilityOp.Visible)
    self.List_Community:ClearListItems()
    local ClassPath = UIUtils.GetCommonItemContentClass()
    for i = 1, #self.CommunityBtnName do
        local MenuContent = NewObject(ClassPath)
        MenuContent.BtnName = self.CommunityBtnName[i]
        MenuContent.ParentWidget = self
        if self.ClickFunction[i] ~= nil then
            MenuContent.OnClickFunction = self.CommunityClickFunction[i]
        end
        self.List_Community:AddItem(MenuContent)
    end
end

function Component:OnListBtnClicked(Content)
    self:StopPress()
    UIUtils.PlayCommonBtnSe(self)
    local ListUI = Content.SelfWidget
    if Content.Id then
        self.BtnIdx = Content.Id - 1
    end
    local function PlayAnimFinished()
        if Content.Id then
            self.BtnIdx = Content.Id - 1
        end
        if self[Content.OnClickFunction] == nil then
            return
        end
        self[Content.OnClickFunction](self)
        if ListUI then
            ListUI:UnbindAllFromAnimationFinished(ListUI.Click)
        end
    end
    if self.IsEditOpen then
        self.IsEditOpen = false
        self:PlayAnimation(self.Edit_List_Out)

    end
    if self.IsPersonInfoPage then
        -- self:SetOriginFocus()
        -- local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
        -- GameInputModeSubsystem:SetNavigateWidgetOpacity(0)
    end
    if ListUI then
        local AnimObj = ListUI:GetAnimationByName("Click")
        ListUI:PlayAnimation(AnimObj)
        ListUI:BindToAnimationFinished(AnimObj, {self, PlayAnimFinished})
    else
        PlayAnimFinished()
    end
end

function Component:OnClickEdit()
    self:StopPress()
    -- AudioManager(self):PlayUISound(nil,"event:/ui/common/click_btn_small", nil, nil)
    if self:IsPlayingAnimation(self.Edit_List_In) then
        return
    end
    if not self.IsEditOpen then
        if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad and self.Btn_PersonalInfo then
            self.Btn_PersonalInfo.Button_Area:SetFocus()
            if  self.Com_KeyTips then
                self.Com_KeyTips:UpdateKeyInfo({{
                    KeyInfoList = {{
                        Type = "Img",
                        ImgShortPath = "A"
                    }},
                    Desc = GText("UI_Tips_Ensure")
                }, {
                    KeyInfoList = {{
                        Type = "Img",
                        ImgShortPath = "B"
                    }},
                    Desc = GText("UI_Tips_Close")
                }})
            end
        end
        self.IsEditOpen = true
        self:PlayAnimation(self.Edit_List_In)
        self.Button_Edit.New:SetRenderOpacity(0)
        -- 暂时的
        self.Panel_Edit:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Panel_Edit:SetRenderOpacity(1)
        if self.IsPersonInfoPage and self.CurInputDeviceType == ECommonInputType.Gamepad then
            self:FreshFocusOnEditListView()
        end
    else
        if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
            if self.GameInputModeSubsystem and self.Head_Player then
                self.GameInputModeSubsystem:SetTargetUIFocusWidget(self.Head_Player.Button_Area)
                self.GameInputModeSubsystem:UpdateCurrentFocusWidgetPos()
            end
            if self.Com_KeyTips then
                self.Com_KeyTips:UpdateKeyInfo({{
                    KeyInfoList = {{
                        Type = "Img",
                        ImgShortPath = "X"
                    }},
                    Desc = GText("UI_CTL_ESC_Exit"),
                    bLongPress = true
                }, {
                    KeyInfoList = {{
                        Type = "Img",
                        ImgShortPath = "A"
                    }},
                    Desc = GText("UI_Tips_Ensure")
                }, {
                    KeyInfoList = {{
                        Type = "Img",
                        ImgShortPath = "B"
                    }},
                    Desc = GText("UI_Tips_Close")
                }})
            end
        end
        self.IsEditOpen = false
        self:PlayAnimation(self.Edit_List_Out)
        self.Button_Edit.New:SetRenderOpacity(1)
        self.Panel_Edit:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Panel_Edit:SetRenderOpacity(0)
        if self.IsPersonInfoPage and self.CurInputDeviceType == ECommonInputType.Gamepad then
            self:FreshFocusLeaveEditListView()
        end
    end
end

function Component:CloseEdit()
    self.Button_Edit.New:SetRenderOpacity(1)
    self:StopPress()
    if self:IsPlayingAnimation(self.Edit_List_Out) then
        return
    end
    if self.IsEditOpen then
        self.IsEditOpen = false
        self:PlayAnimation(self.Edit_List_Out)
    else
        if (self.IsPersonInfoPage == nil) then
            self:Close()
        end
    end
end

function Component:SetCurIndexContent()
    self:ClearAllIndexContent()
    local CurContent = self.Edit_List:GetItemAt(self.BtnIdx)
    if CurContent and CurContent.SelfWidget then
        CurContent.SelfWidget:SetStyle(true)
    end
end

function Component:ClearAllIndexContent()
    for i = 0, self.Edit_List:GetNumItems() do
        local CurContent = self.Edit_List:GetItemAt(i)
        if CurContent and CurContent.SelfWidget and CurContent.Id == self.BtnIdx then
            CurContent.SelfWidget:StopAllAnimations()
        end
    end
end

function Component:StopPress()
    if (self.IsPersonInfoPage == true) then -- StopPress只有在个人主页才调用，原因是留在Menu_World_PC_C的StopPress没删除，不止个人信息编辑list要用
        if not CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
            self:StopAnimation(self.Press)
            self:PlayAnimation(self.Normal)
        end
    end
end

function Component:OnClickChangePortrait()
    self:StopPress()
    local Params = {}
    Params.TabConfigData = {
        TitleName = GText("UI_Armory_Information"),
        LeftKey = "A",
        RightKey = "D",
        Tabs = {{
            Text = GText("UI_HeadFrame_Head"),
            RedDotTreeName = "Portrait",
            TabId = 1
        }, {
            Text = GText("UI_HeadFrame_Frame"),
            RedDotTreeName = "PortraitFrame",
            TabId = 2

        }},
        --     -- DynamicNode={
        --     --     "Back",
        --     --     "ResourceBar",
        --     --     "Tip",
        --     --     "BottomKey",
        --     -- },
        --    BottomKeyInfo = { { KeyInfoList = {{Type="Text", Text=CommonUtils:GetKeyText("Escape"), ClickCallback=self.OnBackKeyDown, Owner=self}}, Desc = GText("UI_BACK"), bLongPress = false}},
        --     StyleName = "Text",
        FreshCallback = function(IsFrame, HeadOrFrameId) -- 该函数为个人主页专用，ESC界面不用
            local selftemp = self
            if (self.IsPersonInfoPage) then
                selftemp:FreshHeadAndFrames(IsFrame, HeadOrFrameId)
            end
        end,
        FreshCallbackObj = self,
        OwnerPanel = self
    }

    -- UIManager(self):LoadUI(UIConst.PORTRAIT, "ChangePortrait", self.ZOrder+5,nil,true)
    UIManager(self):ShowCommonPopupUI(100140, Params, self)
    if self.IsEditOpen then
        -- self.IsEditOpen = false
        -- self:PlayAnimation(self.Edit_List_Out)
        self:OnClickEdit()
    end
    UIUtils.TrySubReddotCacheDetail("EscPortrait", "EscPortrait")
end

function Component:OnClickChangeName()
    if self.CheckChangeNameCd() then
        local Params = {}
        Params.ChangeName = true
        Params.FirstInit = true
        Params.UseReName = true
        Params.Title = GText("UI_COMMONPOP_TITLE_100054")

        if self.IsPersonInfoPage then
            Params.OnNotSensitiveCallbackFunction = function(self2, Data)
                if self.Text_PlayerName then
                    self.Text_PlayerName:SetText(Data)
                end
            end
        end
        UIManager(self):ShowCommonPopupUI(100133, Params, self)
    else
        if self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad then
            self:SetFocus_Lua()
        end
    end
end
function Component:CheckChangeNameCd()

    local Avatar = GWorld:GetAvatar()
    if Avatar then
        local ChangeTime = Avatar.NicknameChangeTime
        if ChangeTime > 0 and TimeUtils.NowTime() - ChangeTime < DataMgr.GlobalConstant.PlayerNicknameCD.ConstantValue *
            24 * 60 * 60 then
            UIManager(GWorld.GameInstance):ShowUITip("CommonToastMain", string.format(
                GText("UI_COMMONPOP_TEXT_100054_2"), DataMgr.GlobalConstant.PlayerNicknameCD.ConstantValue))
            return false
        end
    end
    return true
end
function Component:OnClickChangeSignature()
    AudioManager(self):PlayUISound(nil, "event:/ui/common/click_input_bar", nil, nil)
    local Params = {}
    Params.ChangeName = false
    Params.FirstInit = true
    Params.UseReName = true
    Params.OnNotSensitiveCallbackFunction = function(self2, Data)
        if self.IsPersonInfoPage then
            if self.Switcher_Input:GetActiveWidgetIndex() ~= 1 then
                self.Switcher_Input:SetActiveWidgetIndex(1)
            end
            self.Text_Input:SetText(Data)
        end
    end
    Params.RightCallbackFunction = function(self2, Data)
        -- 仅仅个人主页需要，ecs界面修改后会自动刷新所有数据
        -- if self.IsPersonInfoPage then
        --     if self.Switcher_Input:GetActiveWidgetIndex() ~= 1 then
        --         self.Switcher_Input:SetActiveWidgetIndex(1)
        --     end

        --     -- self.Text_Input:SetText(Data.Content_1.Text)
        -- end

    end
    if self.Switcher_Input:GetActiveWidgetIndex() == 1 then
        Params.Signature = self.Text_Input:GetText()
    end
    Params.Title = GText("UI_COMMONPOP_TITLE_100055")
    UIManager(self):ShowCommonPopupUI(100133, Params, self)
    -- UIManager(self):LoadUI("/Game/UI/UI_PC/SelectRole/SelectRole_Page_PC.SelectRole_Page_PC_C", "changename", 52)
end
function Component:OnClickChangeBirthday()
    ---@type Common_Dialog_Params
    local Params = {}
    -- Params.DontCloseWhenRightBtnClicked = true 
    Params.RightCallbackFunction = self.OnBirthdaySubmitted
    Params.RightCallbackObj = self
    UIManager(self):ShowCommonPopupUI(100056, Params, self)
end
function Component:OnBirthdaySubmitted(Result)
    Result = Result["Birthday"]
    if Result then
        DebugPrint("Tianyi@ OmBirthdaySubmitted: " .. Result.Month .. ' ' .. Result.Day)
        ---@type Common_Dialog_Params 
        local Params = {}
        Params.ShortText = string.format(GText("UI_COMMONPOP_TEXT_100057"), GDate("Date_MD", {
            Month = Result.Month,
            Day = Result.Day
        }))
        Params.RightCallbackFunction = function()
            self:ChangeBirthday(Result.Month, Result.Day)
        end
        Params.LeftCallbackFunction = function()
            local Params = {}
            Params.RightCallbackFunction = self.OnBirthdaySubmitted
            Params.RightCallbackObj = self
            UIManager(self):ShowCommonPopupUI(100056, Params, self)
        end
        UIManager(self):ShowCommonPopupUI(100057, Params, self)
    end
end

function Component:ChangeBirthday(Month, Day)
    local Avatar = GWorld:GetAvatar()
    Avatar:SetAvatarBirthday(math.floor(Month), math.floor(Day), function(Res)
        self:OnAvatarBirthdayChanged(Res)

    end)
end

function Component:OnAvatarBirthdayChanged(Res)
    DebugPrint("Tianyi@ OnAvatarBirthdaySet")

    if Res then
        UIManager(self):ShowUITip("CommonToastMain", GText("UI_Change_Success"))
        local Avatar = GWorld:GetAvatar()
        local Month, Day = Avatar:GetAvatarBirthday()
        if self.Text_Birth then
            self.Text_Birth:SetText(GDate("Date_MD", {
                Month = Month,
                Day = Day
            }))
        end
        if not self.BirthDayRemoved then
            table.remove(self.BtnName,5 )
            table.remove(self.ClickFunction, 5)
            self:InitBtnList()
        end
    end

end

function Component:OnCopyUID()
    if (self.IsPersonInfoPage == true) then -- OnCopyUID只有在个人主页才调用，原因是留在Menu_World_PC_C的OnCopyUID没删除，不止个人信息编辑list要用
        local CopyStr = self.Text_UID:GetText()
        UE.UUIFunctionLibrary.ClipboardCopy(CopyStr)
        if self.RootPage and self.RootPage.CurInputDeviceType == ECommonInputType.Gamepad and
            self.Panel_Edit:HasFocusedDescendants() then
            -- self:SetOriginFocus()
            -- self:SetFocus()
            self.RootPage:FocusToSavedWidget()
        end
        UIManager(self):ShowUITip("CommonToastMain", GText("UI_Tosat_Menu_CopyUID"))
    end
end
function Component:OnClickPersonalInfo()
    local PersonInfoController = require "BluePrints.UI.WBP.PersonInfo.PersonInfoController"
    -- PersonInfoController:Init()
    PersonInfoController:OpenView()

end

function Component:GetFisrtEditItem()
    if self.Edit_List then
        -- 获取 ListView 中的所有 Item
        local items = self.Edit_List:GetListItems()
        if items[1] then
            -- 获取第一个 Item
            local firstItem = items[1]
            local ReturnWidget = firstItem.SelfWidget or firstItem.ParentWidget
            if firstItem.SelfWidget or ReturnWidget then
                return ReturnWidget
            else
                DebugPrint("item没有对应ui")
            end
        else
            DebugPrint("ListView 中没有 Item。")
        end
    else
        DebugPrint("ListView 引用无效。")
    end

end

function Component:OnExchangeCodeClicked()
    local Params = {}
    Params.IsExchangeCode = true
    Params.FirstInit = true
    Params.UseReName = true
    Params.Title = GText("UI_COMMONPOP_TITLE_100127")
    UIManager(self):ShowCommonPopupUI(100133, Params, self)
end

function Component:OnCustomerServiceClicked()
    HeroUSDKSubsystem(self):OpenService()
end
function Component:OnClickChangeTitle()
    ReddotManager.ClearLeafNodeCount("TitleBtn", true)
    UIManager(self):ShowCommonPopupUI(100239, {}, self)
end
return Component
