-- DESCRIPTION
-- 个人主页通用背景以及Tab PC
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

local M = Class("BluePrints.UI.BP_UIState_C", "BluePrints.Common.TimerMgr")
local PersonInfoController = require "BluePrints.UI.WBP.PersonInfo.PersonInfoController"
local PersonInfoModel = require "BluePrints.UI.WBP.PersonInfo.PersonInfoModel"
M._components = {"BluePrints.UI.WBP.PersonInfo.Base.PersonInfoEntryBaseView"}

function M:InitTabInfo()
    if  not PersonInfoModel:IsOwener()  then
        if  self.bHideCharTab  then
            self:InitTabOthers()
        else
            self:InitTabOthersWithChar()
        end
    elseif self.bHideCharTab  then
        self:InitTabWithOutChar()
    else
        self:InitTabWithChar()
    end

end
function M:InitTabOthers()
    local TabWithoutChar={
        Tabs = self.AllTabInfo,
        DynamicNode = {"Back", "Tip", "BottomKey"},
        BottomKeyInfo = {{
            KeyInfoList = {{
                Type = "Text",
                Text = "Esc",
                ClickCallback = self.OnReturnKeyDown,
                Owner = self
            }},
            GamePadInfoList = {{
                Type = "Img",
                ImgShortPath = "B",
                ClickCallback = self.OnReturnKeyDown,
                Owner = self
            }},
            Desc = GText("UI_BACK")

        }},
        StyleName = "Text",
        OwnerPanel = self,
        TitleName = GText("UI_PersonInfo_Name"),
        BackCallback = self.OnReturnKeyDown
    }
    if not self.bHideCharTab  then
        local TabWithChar={
            LeftKey = "NotShow",
            RightKey = "NotShow",
            Tabs = self.AllTabInfo,
            DynamicNode = {"Back", "Tip", "BottomKey"},
            BottomKeyInfo = {{
                KeyInfoList = {{
                    Type = "Text",
                    Text ="U",
                    ClickCallback = self.OnUKeyDown,
                    Owner = self
                }},
                GamePadInfoList = {{
                    Type = "Img",
                    ImgShortPath = "Y",
                    ClickCallback = self.OnUKeyDown,
                    Owner = self
                }},
                Desc = GText("UI_Dye_HideUI"),
                bLongPress = false
            }, {
                GamePadInfoList = {{
                    Type = "Img",
                    ImgShortPath = "RH",
                    -- ClickCallback = self.OnUKeyDown,
                    Owner = self
                }},
                Desc = GText("UI_CTL_RotatePreview"),
                bLongPress = false
    
            }, {
                KeyInfoList = {{
                    Type = "Text",
                    ImgShortPath = "Mouse_Button"
                }},
                GamePadInfoList = {
                    {
                        Type = "Or",
                        ImgShortPath = "RT",
                        Owner = self
                    },
                    GamePadSubKeyInfoList = {{
                        Type = "Img",
                        ImgShortPath = "LT",
                        Owner = self
                    }, {
                        Type = "Img",
                        ImgShortPath = "RT",
                        Owner = self
                    }}
    
                },
                Desc = GText("UI_Dye_Zoom"),
                bLongPress = false
    
            }, {
                GamePadInfoList = {{
                    Type = "Img",
                    ImgShortPath = "A",
                    Owner = self
                }},
                Desc = GText("UI_Controller_CheckDetails")
            }, {
                KeyInfoList = {{
                    Type = "Text",
                    Text = "Esc",
                    ClickCallback = self.OnReturnKeyDown,
                    Owner = self
                }},
                GamePadInfoList = {{
                    Type = "Img",
                    ImgShortPath = "B",
                    ClickCallback = self.OnReturnKeyDown,
                    Owner = self
                }},
                Desc = GText("UI_BACK")
            }},
            StyleName = "Text",
            OwnerPanel = self,
            TitleName = GText("UI_PersonInfo_Name"),
            BackCallback = self.OnReturnKeyDown
        }
    end
    self.Com_Tab:Init(TabWithoutChar)
    self.Com_Tab:SetSingleBottomKeyInfoVisibility(3,   UIConst.VisibilityOp.HitTestInvisible)
    self.KeyAindex = 1
end
function M:InitTabOthersWithChar()
    local TabWithChar={
        LeftKey = "NotShow",
        RightKey = "NotShow",
        Tabs = self.AllTabInfo,
        DynamicNode = {"Back", "Tip", "BottomKey"},
        BottomKeyInfo = {{
            KeyInfoList = {{
                Type = "Text",
                Text ="U",
                ClickCallback = self.OnUKeyDown,
                Owner = self
            }},
            GamePadInfoList = {{
                Type = "Img",
                ImgShortPath = "Y",
                ClickCallback = self.OnUKeyDown,
                Owner = self
            }},
            Desc = GText("UI_Dye_HideUI"),
            bLongPress = false
        }, {
            GamePadInfoList = {{
                Type = "Img",
                ImgShortPath = "RH",
                -- ClickCallback = self.OnUKeyDown,
                Owner = self
            }},
            Desc = GText("UI_CTL_RotatePreview"),
            bLongPress = false

        }, {
            KeyInfoList = {{
                Type = "Text",
                ImgShortPath = "Mouse_Button"
            }},
            GamePadInfoList = {
                {
                    Type = "Or",
                    ImgShortPath = "RT",
                    Owner = self
                },
                GamePadSubKeyInfoList = {{
                    Type = "Img",
                    ImgShortPath = "LT",
                    Owner = self
                }, {
                    Type = "Img",
                    ImgShortPath = "RT",
                    Owner = self
                }}

            },
            Desc = GText("UI_Dye_Zoom"),
            bLongPress = false

        }, {
            GamePadInfoList = {{
                Type = "Img",
                ImgShortPath = "A",
                Owner = self
            }},
            Desc = GText("UI_Controller_CheckDetails")
        }, {
            KeyInfoList = {{
                Type = "Text",
                Text = "Esc",
                ClickCallback = self.OnReturnKeyDown,
                Owner = self
            }},
            GamePadInfoList = {{
                Type = "Img",
                ImgShortPath = "B",
                ClickCallback = self.OnReturnKeyDown,
                Owner = self
            }},
            Desc = GText("UI_BACK")
        }},
        StyleName = "Text",
        OwnerPanel = self,
        TitleName = GText("UI_PersonInfo_Name"),
        BackCallback = self.OnReturnKeyDown
    }
    self.Com_Tab:Init(TabWithChar)
    self.Com_Tab:SetSingleBottomKeyInfoVisibility(3,   UIConst.VisibilityOp.HitTestInvisible)
    self.KeyAindex = 4
end
function M:InitTabWithChar()
    self.bIsHide = false
    local TabWithChar={
        LeftKey = "NotShow",
        RightKey = "NotShow",
        Tabs = self.AllTabInfo,
        DynamicNode = {"Back", "Tip", "BottomKey"},
        BottomKeyInfo = {{
            KeyInfoList = {{
                Type = "Text",
                Text ="U",
                ClickCallback = self.OnUKeyDown,
                Owner = self
            }},
            GamePadInfoList = {{
                Type = "Img",
                ImgShortPath = "Y",
                ClickCallback = self.OnUKeyDown,
                Owner = self
            }},
            Desc = GText("UI_Dye_HideUI"),
            bLongPress = false
        }, {
            GamePadInfoList = {{
                Type = "Img",
                ImgShortPath = "RH",
                -- ClickCallback = self.OnUKeyDown,
                Owner = self
            }},
            Desc = GText("UI_CTL_RotatePreview"),
            bLongPress = false

        }, {
            KeyInfoList = {{
                Type = "Text",
                ImgShortPath = "Mouse_Button"
            }},
            GamePadInfoList = {
                {
                    Type = "Or",
                    ImgShortPath = "RT",
                    Owner = self
                },
                GamePadSubKeyInfoList = {{
                    Type = "Img",
                    ImgShortPath = "LT",
                    Owner = self
                }, {
                    Type = "Img",
                    ImgShortPath = "RT",
                    Owner = self
                }}

            },
            Desc = GText("UI_Dye_Zoom"),
            bLongPress = false

        }, {
            GamePadInfoList = {{
                Type = "Img",
                ImgShortPath = "A",
                Owner = self
            }},
            Desc = GText("UI_Controller_CheckDetails")
        }, {
            KeyInfoList = {{
                Type = "Text",
                Text = "Esc",
                ClickCallback = self.OnReturnKeyDown,
                Owner = self
            }},
            GamePadInfoList = {{
                Type = "Img",
                ImgShortPath = "B",
                ClickCallback = self.OnReturnKeyDown,
                Owner = self
            }},
            Desc = GText("UI_BACK")
        }},
        StyleName = "Text",
        OwnerPanel = self,
        TitleName = GText("UI_PersonInfo_Name"),
        BackCallback = self.OnReturnKeyDown
    }
    self.Com_Tab:Init(TabWithChar)
    self.KeyAindex = 4
    self.Com_Tab:SetSingleBottomKeyInfoVisibility(3,   UIConst.VisibilityOp.HitTestInvisible)
end
function M:InitTabWithOutChar()
    local TabWithoutChar={
        Tabs = self.AllTabInfo,
        DynamicNode = {"Back", "Tip", "BottomKey"},
        BottomKeyInfo = {{
            GamePadInfoList = {{
                Type = "Img",
                ImgShortPath = "A",
                -- ClickCallback = self.OnReturnKeyDown,
                Owner = self
            }},
            Desc = GText("UI_CTL_Add")
        }, {
            KeyInfoList = {{
                Type = "Text",
                Text = "Esc",
                ClickCallback = self.OnReturnKeyDown,
                Owner = self
            }},
            GamePadInfoList = {{
                Type = "Img",
                ImgShortPath = "B",
                ClickCallback = self.OnReturnKeyDown,
                Owner = self
            }},
            Desc = GText("UI_BACK")

        }},
        StyleName = "Text",
        OwnerPanel = self,
        TitleName = GText("UI_PersonInfo_Name"),
        BackCallback = self.OnReturnKeyDown
    }
    self.Com_Tab:Init(TabWithoutChar)
    --self.Com_Tab:SetSingleBottomKeyInfoVisibility(3,   UIConst.VisibilityOp.HitTestInvisible)
    self.KeyAindex = 1
end


function M:Hideui()
    self.bIsHide = true
    self.HideUI_Key:SetVisibility(UIConst.VisibilityOp.Visible)
    self.PersonInfoMainPage.MainPanel:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.Com_Tab:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self:Playanimation(self.HideUi)

    local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
    if GameInputModeSubsystem then
        GameInputModeSubsystem:SetNavigateWidgetOpacity(0)
    end

end

function M:Recoverui()
    self.bIsHide = false
    self.HideUI_Key:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.PersonInfoMainPage.MainPanel:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Com_Tab:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self:Playanimation(self.ShowUi)
    local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
    if GameInputModeSubsystem then
        GameInputModeSubsystem:SetNavigateWidgetOpacity(1)
    end
end
function M:Close()
    -- TODO 界面关闭逻辑

    M.Super.Close(self)
end

function M:InitListenEvent()
    -- TODO 监听相关事件
end
-- function M:Construct()

-- end
function M:OnLoaded()
    M.Super.OnLoaded(self)
    self:InitTabInfo()
    self:InitListenEvent()
  
end
---
function M:RefreshBaseInfo()
    -- 刷新一些基础数据
    self.HideUI_Key:CreateCommonKey({
        KeyInfoList = {{
            Type = "Text",
            Text = CommonUtils:GetKeyText("U"),
            ClickCallback = self.OnUKeyDown,
            Owner = self
        }},
        GamePadInfoLst = {{
            Type = "Img",
            ImgShortPath = "Y",
            ClickCallback = self.OnUKeyDown,
            Owner = self
        }},
        Desc = GText("UI_Dye_HideUI"),
        bLongPress = false
    })

    self.PersonInfoMainPage = self:CreatePersonInfoMainPage({
        PCBluePrint = "WidgetBlueprint'/Game/UI/WBP/PersonalInfo/PC/WBP_PersonalInfo_Main_P.WBP_PersonalInfo_Main_P'"
    })
    if (self.PersonInfoMainPage) then
        -- self.PersonInfoMainPage:InitPage(PageData)
        self.PersonInfoMainPage:PlayAnimation(self.PersonInfoMainPage.In)
    end
    self.PersonInfoMainPage.RootPage = self
    if (self.bIsHide == true) then
        self:Hideui()
    else
        self:Recoverui()
    end
    self:OnMainPageLoaded()
end
function M:CreatHideUiKey(IsGamePad)
    local MyKeyInfoList = {}
    if IsGamePad then

        MyKeyInfoList = {{
            Type = "Img",
            ImgShortPath = "Y",
            ClickCallback = self.OnUKeyDown,
            Owner = self
        }}
    else
        MyKeyInfoList = {{
            Type = "Text",
            Text = CommonUtils:GetKeyText("U"),
            ClickCallback = self.OnUKeyDown,
            Owner = self
        }}
    end

    self.HideUI_Key:CreateCommonKey({
        KeyInfoList = MyKeyInfoList,
        Desc = GText("UI_Dye_HideUI"),
        bLongPress = false
    })

end
function M:OnMainPageLoaded()
    if self.CurInputDeviceType == ECommonInputType.Gamepad then
        self:FreshViewByInputDevice(true)
    end
    self.PersonInfoMainPage.Btn_EditSign.OnHovered:Add(self, function()
        if self.CurInputDeviceType == ECommonInputType.Gamepad then
            self:UpdataGamePadBottomAInfo(4)
        end
    end)
end
function M:OnReturnKeyDown()
    -- 返回上一级
    if (not self:CheckIsCanCloseSelf()) then
        return
    end

    -- UIUtils.PlayCommonBtnSe(self)
    self:PlayOutAnim()
end

--------------------------输入交互--------------------------------
function M:OnUKeyDown()
    self.bIsHide = not self.bIsHide
    if (self.bIsHide == true) then
        self:Hideui()
    else
        self:Recoverui()
    end
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
        if (InKeyName == "U") then
            if self.bHideCharTab then
                return UE4.UWidgetBlueprintLibrary.Handled()
            end
            self:OnUKeyDown()
        end
        if (InKeyName == "Escape") then
            if (self.bIsHide ~= true) then
                self:OnReturnKeyDown()
            else
                if self.bHideCharTab then
                    return UE4.UWidgetBlueprintLibrary.Handled()
                end
                self.bIsHide = not self.bIsHide
                self:Recoverui()
            end
            IsEventHandled = true
        end
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
end
-- 手柄长按专用
-- 完成镜头拉近拉远功能和旋转模型功能。
function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if self.bHideCharTab then
        return UE4.UWidgetBlueprintLibrary.Handled()
    end
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        if InKeyName == "Gamepad_RightTriggerAxis" then
            self.PersonInfoMainPage:ZoomCamare(-0.2)
            IsEventHandled = true
        elseif InKeyName == "Gamepad_LeftTriggerAxis" then
            self.PersonInfoMainPage:ZoomCamare(0.2)
            IsEventHandled = true
        else
            local MoveDeltaX = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
            if InKeyName == "Gamepad_RightX" and MoveDeltaX ~= nil then
                if self.PersonInfoMainPage then
                    self.PersonInfoMainPage:RotateActorForGamePad(MoveDeltaX)
                end
                IsEventHandled = true

            end
        end

    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
end
---处理手柄交互
function M:OnGamePadDown(InKeyName)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
    local s = self.GameInputModeSubsystem:GetCurrentLocalPlayerFocusWidgetType()
    local IsEventHandled = self.Com_Tab:Handle_KeyEventOnGamePad(InKeyName)

    if InKeyName == UIConst.GamePadKey.FaceButtonTop then
        if  self.bHideCharTab then
            return UE4.UWidgetBlueprintLibrary.Handled()
        end
        self:OnUKeyDown() -- 尝试隐藏/恢复ui
    elseif self.bIsHide == true then
        return false
    elseif InKeyName == "Gamepad_Special_Left" then
        if not self.PersonInfoMainPage.IsEditOpen then
            self.PersonInfoMainPage:OnCopyUID()
        end
    elseif InKeyName ==  UIConst.GamePadKey.SpecialRight then
        if not self.PersonInfoMainPage.IsEditOpen then
            self.PersonInfoMainPage:OnClickOpenDataPage()
        end
    elseif InKeyName == UIConst.GamePadKey.FaceButtonLeft then
        if not self.PersonInfoMainPage.IsEditOpen then
            self.PersonInfoMainPage:OnClickOpenEditPage()
            if self.PersonInfoMainPage.IsEditOpen == false then
                DebugPrint("聚焦的保存的widget")
                self:FocusToSavedWidget()
                self.PersonInfoMainPage:FreshFocusLeaveEditListView()
            end
            if self.PersonInfoMainPage.Panel_Edit:HasFocusedDescendants() then
                DebugPrint("Panel_Edit还有聚焦，聚焦回去")
                self:SetFocus()
            end
        end
    elseif InKeyName == "Gamepad_LeftThumbstick" then
        if  not PersonInfoModel:IsOwener() then
            return UE4.UWidgetBlueprintLibrary.Handled()
        end
        if not self.PersonInfoMainPage.IsEditOpen then
            self.PersonInfoMainPage:OnClickEdit()
            self:UpdataGamePadBottomAInfo(4)
            self:SaveCurrentFocusedWidget()
            self:AddTimer(0.1, function()
                local firstUi = self.PersonInfoMainPage:GetFisrtEditItem()
                if firstUi then
                    DebugPrint("聚焦到第一个ui")
                    -- firstUi:SetFocus()
                    firstUi:SetFocus()
                    self.PersonInfoMainPage.Edit_List:SetSelectedIndex(0)
                    if self.PersonInfoMainPage.Panel_Edit:HasFocusedDescendants() then -- 确保聚焦过去才切换样式
                        self.PersonInfoMainPage:FreshFocusOnEditListView()
                    end
                end
            end)
            -- 添加return处理返回值
        else
            self.PersonInfoMainPage:OnClickEdit()
            if self.PersonInfoMainPage.IsEditOpen == false then
                DebugPrint("聚焦到保存的widget")
                self:FocusToSavedWidget()
                if self.PersonInfoMainPage.Panel_Edit:HasFocusedDescendants() then
                    DebugPrint("尝试关闭界面，聚焦回来")
                    self:SetFocus()
                end
                self.PersonInfoMainPage:FreshFocusLeaveEditListView()
            end
        end

    end
    return IsEventHandled
end

-- 检测到输入设备变化，初始化手柄focus，由于编辑界面不是uistate，所以也在这里处理
function M:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
    self.CurInputDeviceType = CurInputType
    if PersonInfoController.CurPage == PersonInfoController.PageEnum.EditPage and IsValid(PersonInfoController.EditPage) then
        PersonInfoController.EditPage:SetFocus()
        PersonInfoController.EditPage:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
    elseif  PersonInfoController.CurPage == PersonInfoController.PageEnum.MainPage and IsValid(PersonInfoController.MainPage) then
     -- 个人主页主界面
        if not self:HasAnyFocus() then
            return
        end

        --ScreenPrint("检测到输入设备变化，初始化手柄focus，由于编辑界面不是uistate，所以也在这里处理")
        self.PersonInfoMainPage.CurInputDeviceType = CurInputType
        if CurInputType == ECommonInputType.Gamepad then
            if self.PersonInfoMainPage then
                if not UIManager(self):GetUIObj("CommonDialog") then -- 弹窗时不修改聚焦
                    self.PersonInfoMainPage:SetOriginFocus()
                end
                self:FreshViewByInputDevice(true)
                self:CreatHideUiKey(true)
            end
        else
            self:CreatHideUiKey(false)
            self:FreshViewByInputDevice(false)
        end
    end

end
--- 根据输入方式刷新主界面样式
---@param bIsGamePad 是否使用手柄
function M:FreshViewByInputDevice(bIsGamePad)
    if not self.PersonInfoMainPage then
        return
    end

    if bIsGamePad then
        if PersonInfoModel:IsOwener() then
            self.PersonInfoMainPage.Key_Controller:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
            self.PersonInfoMainPage.Key_ControllerImg:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        end
        self.PersonInfoMainPage.WS_Copy:SetActiveWidgetIndex(1)
        self.PersonInfoMainPage:SetOriginFocus()
    else
        self.PersonInfoMainPage.Key_Controller:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.PersonInfoMainPage.Key_ControllerImg:SetVisibility(UIConst.VisibilityOp.Collapsed)
        -- self.PersonInfoMainPage.Key_Edit:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.PersonInfoMainPage.WS_Copy:SetActiveWidgetIndex(0)
    end

end
function M:Handle_KeyDownOnGamePad()
    -- 处理手柄相关的交互事件
    return true
end
--- 使用手柄时，更新底部A按键信息,传空隐藏A
function M:UpdataGamePadBottomAInfo(KindNum)
    local keytable = {}
    if KindNum then
        local Kind2KeyTable = {"UI_CTL_Add", "UI_Controller_CheckDetails", "UI_Controller_Switch", "UI_Tips_Ensure"}
        keytable = {
            GamePadInfoList = {{
                Type = "Img",
                ImgShortPath = "A",
                Owner = self
            }},
            Desc = GText(Kind2KeyTable[KindNum]),
            bLongPress = false
        }
    end
    self.Com_Tab:SetSingleBottomKeyInfo(self.Com_Tab.BottomKeyWidget[self.KeyAindex], keytable)
    return
end

-- 编辑界面关闭弹窗后有时会异常地focus到这个控件，强制focus回去
function M:OnFocusReceived(MyGeometry, InFocusEvent)
    M.Super.OnFocusReceived(self, MyGeometry, InFocusEvent)
    if PersonInfoController.CurPage == PersonInfoController.PageEnum.EditPage and IsValid(PersonInfoController.EditPage) then
        PersonInfoController.EditPage:SetFocus()
    elseif PersonInfoController.CurPage == PersonInfoController.PageEnum.DataPage then
        DebugPrint("统计界面打开中，聚焦到统计界面")
        PersonInfoController.DataPage:SetFocus()
    else
        DebugPrint("主界面打开中，聚焦到主界面")
        if self.PersonInfoMainPage then
            self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
           -- self:OnUpdateUIStyleByInputTypeChange(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
            --self.PersonInfoMainPage:SetOriginFocus()
            self.GameInputModeSubsystem:SetNavigateWidgetOpacity(1)
        end

    end

    return UIUtils.Handled
end
--- 用于监视导航焦点变化，从弹窗回来后需要通过此函数聚焦到主界面
---@param InFocusEvent any
function M:OnAddedToFocusPath(InFocusEvent)
    self:AddTimer(0.1, function()
        if self.PersonInfoMainPage and self.CurInputDeviceType == ECommonInputType.Gamepad and
            not self:HasFocusedDescendants() then
                self:FocusToSavedWidget()
                self.PersonInfoMainPage:FreshFocusLeaveEditListView()
            if not self:HasFocusedDescendants() then
                self.PersonInfoMainPage:SetOriginFocus()
            end
            DebugPrint("Yklua1111  OnAddedToFocusPath")
        end
    end)
end
---
function M:OnItemFocus()
    if self.CurInputDeviceType == ECommonInputType.Gamepad then
        self:UpdataGamePadBottomAInfo(1)
    end
end
---切换按钮被聚焦
function M:OnCheckBoxFocus()
    if self.CurInputDeviceType == ECommonInputType.Gamepad then
        self:UpdataGamePadBottomAInfo(3)
    end
end
function M:GamePadOpenEditList()
end

AssembleComponents(M)
return M
