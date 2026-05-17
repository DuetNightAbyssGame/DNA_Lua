require "UnLua"
local UIUtils = require "Utils.UIUtils"
local View =
    Class(
    {
        "BluePrints.UI.BP_UIState_C",
        "BluePrints.Common.TimerMgr"
    }
)
local Model = require "BluePrints.UI.AutoChess.AutoChessDataModel"

View.FocusState = {
    Focus1 = 1,
    Focus2 = 2,
    Focus3 = 3
}

function View:OnLoaded(MissionId)
    self:Init(MissionId)
    self:BindBtnEvent()
    self:InitKeyImg()
    self:SetFocus()
end

-- Init函数 通过数据接口拿到数据
function View:Init(MissionId)
    DebugPrint("------------初始化怪物界面------------")
    self.bClosing = false
    self.List_Tab:ClearListItems()
    self:GetDataFromModel(MissionId)
    self:InitMonsterList()
    self:DefaultShowFirstItem()
    AudioManager(self):PlayUISound(self, "event:/ui/common/npc_info_panel", "DeputeMonsterInfo", nil)
    self:PlayAnimation(self.In)
end

-- MosterInfoData格式
-- {
--   "MonsterId" = 1,
--   "MonsterInfo" = {
--      "MonsterName": "M" ,
--      "MonsterIcon": "Path",
--     ...
--   }
--   "EquipList" = {1, 2}
-- }
function View:GetDataFromModel(MissionId)
    local MosterInfoData = Model:GetMonsterInfoByMissionId(MissionId)
    if MosterInfoData then
        self.MosterInfoData = MosterInfoData
    else
        DebugPrint("-----------------------MosterInfoData nil--------------------------")
    end
end

function View:InitMonsterList()
    if self.MosterInfoData and #self.MosterInfoData > 0 then
        for Index = 1, #self.MosterInfoData do
            local Row = self.MosterInfoData[Index]
            local Obj = NewObject(UIUtils.GetCommonItemContentClass())
            -- 新存储一份在List中的Index
            Obj.Index = Index
            -- 保存一份自己的数据
            Obj.Data = Row
            -- 显示Btn详细信息
            Obj.MonsterIcon = Row.MonsterInfo.MonsterIcon
            Obj.PositionIcon = Row.MonsterInfo.PositionIcon
            Obj.EquipList = Row.EquipList
            -- 传入Btn事件参数
            Obj.OnBtnClickedCallback = function(Index, EntryWidget)
                self:OnMonsterItemClicked(Index, EntryWidget)
            end
            Obj.OnFocusReceivedCallback = function()
                if UIUtils.IsGamepadInput() then
                    self.CurrentIndex = Index
                    self:SelectMonsterItem(Index)
                    DebugPrint("-----------------聚焦到：", self.CurrentIndex)
                end
            end
            -- 设置选中标志
            Obj.IsSelected = false

            -- 默认选择第一个
            if Index == 1 then
                Obj.IsSelected = true
            end

            self.List_Tab:AddItem(Obj)
        end
    else
        DebugPrint("-----------MosterInfoData 无效或长度小于等于 0，无法执行循环。------------")
        return
    end

    if self.Text_Tips then
        self.Text_Tips:SetText(GText("UI_TRAIN_CLOSE"))
    end
end

-- 选择怪物item
function View:SelectMonsterItem(Index)
    -- 1) 防止重复选中
    if self.OldIndex == Index then
        return
    end

    local PrevIndex = self.OldIndex

    -- 2) 关闭装备详情界面
    if self.Tips then
        self.Tips:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end

    -- 3) 刷新详情面板
    self:ShowPanelMonsterInfo(Index)

    -- 4) 播放切换动画
    if self.Switch then
        self:PlayAnimation(self.Switch)
    end

    self.OldIndex = Index

    self:ChangeHightlight(Index, PrevIndex)
    -- 5) 更新当前选中的 MonsterId
    -- self.CurrentMonsterId = MonsterId
end

-- 怪物item点击事件
function View:OnMonsterItemClicked(Index, EntryWidget)
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_mid", "", nil)
    DebugPrint("-------------------------点击怪物：", tostring(Index))
    self.CurrentIndex = Index
    self:SelectMonsterItem(Index)
end

-- 刷新怪物详情界面
function View:ShowPanelMonsterInfo(Index)
    if not self.MosterInfoData then
        return
    end

    local TargetRow = self.MosterInfoData[Index]

    if not TargetRow or not TargetRow.MonsterInfo then
        DebugPrint("------------------------------ShowMonsterDetail 找不到怪物Index:", tostring(Index))
        return
    end

    local EquipInfos = Model:GetMonsterEquipByEquipList(TargetRow.EquipList)

    local Info = TargetRow.MonsterInfo
    if not Info then
        DebugPrint("------------------Selected Monster Item Data is nil------------------")
        return
    end

    -- 怪物信息详情
    if self.Monster_Name then
        if not Info.CombatChessName then
            DebugPrint("------------------CombatChessName Data is nil------------------")
            return
        end
        self.Monster_Name:SetText(GText(Info.CombatChessName))
    end

    if self.Text_Content then
        if not Info.MonsterDes then
            DebugPrint("------------------MonsterDes Data is nil------------------")
            return
        end
        self.Text_Content:SetText(GText(Info.MonsterDes))
    end

    if self.Icon_Type then
        if not Info.PositionIcon then
            DebugPrint("------------------PositionIcon Data is nil------------------")
            return
        end
        local IconObj = LoadObject(Info.PositionIcon)
        self.Icon_Type:SetBrushFromTexture(IconObj)
    end

    if self.Icon_Monster_Head and Info.MonsterIcon then
        if not Info.MonsterIcon then
            DebugPrint("------------------MonsterIcon Data is nil------------------")
            return
        end
        local IconObj = LoadObject(Info.MonsterIcon)
        if IconObj then
            local MID = self.Icon_Monster_Head:GetDynamicMaterial()
            if MID then
                MID:SetTextureParameterValue("MainTex", IconObj)
            else
                DebugPrint("Icon_Monster_Head:GetDynamicMaterial() 失败")
            end
        end
    end

    -- 刷新装备Icon
    if not EquipInfos then
        DebugPrint("------------------Selected Monster EquipInfos Data is nil------------------")
        return
    end
    self:RefreshEquipUI(EquipInfos)
end

-- EquipInfo在ShowPanelMonsterInfo里面拿到
function View:BuildEquipContent(EquipInfo)
    if not EquipInfo then
        return nil
    end

    return {
        Id = EquipInfo.EquipId,
        Icon = EquipInfo.EquipIcon, -- 必填
        Rarity = EquipInfo.EquipRarity, -- 必填
        ------------------------------------
        -- ItemName = EquipInfo.EquipName, -- 可选
        Desc = Model:CalcEquipExtraDesc(EquipInfo.EquipId), -- 可选
        -- 点击事件
        OnMouseButtonUpEvents = {
            Obj = self,
            Callback = self.OnEquipItemClicked,
            Params = {EquipInfo}
        }
    }
end

-- 更新怪物装备栏显示
function View:RefreshEquipUI(EquipInfos)
    if not self.Equipment then
        return
    end

    local Count = (EquipInfos and #EquipInfos) or 0
    if Count > 2 then
        Count = 2
    end

    local Panel = self.Equipment.Panel_Equipment
    local Equip01 = self.Equipment.Equipment_01
    local Equip02 = self.Equipment.Equipment_02
    local Empty01 = self.Equipment.Empty_01
    local Empty02 = self.Equipment.Empty_02

    -- 0件：隐藏整个面板
    if Count == 0 then
        if Panel then
            Panel:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
        return
    end

    -- Count>0：显示面板
    if Panel then
        Panel:SetVisibility(UE4.ESlateVisibility.Visible)
    end

    -- 默认：两个槽位都显示空态，装备都隐藏
    if Equip01 then
        Equip01:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    if Equip02 then
        Equip02:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    if Empty01 then
        Empty01:SetVisibility(UE4.ESlateVisibility.Visible)
    end
    if Empty02 then
        Empty02:SetVisibility(UE4.ESlateVisibility.Visible)
    end

    -- 1件：填充1号槽
    if Count >= 1 and Equip01 then
        Equip01:SetVisibility(UE4.ESlateVisibility.Visible)
        if Empty01 then
            Empty01:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end

        local Content = self:BuildEquipContent(EquipInfos[1])
        if Content then
            Equip01:Init(Content)
        end
    end

    -- 2件：填充2号槽
    if Count >= 2 and Equip02 then
        Equip02:SetVisibility(UE4.ESlateVisibility.Visible)
        if Empty02 then
            Empty02:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end

        local Content = self:BuildEquipContent(EquipInfos[2])
        if Content then
            Equip02:Init(Content)
        end
    end
end

-- 装备点击事件 手柄也会走这个
function View:OnEquipItemClicked(EquipInfo)
    DebugPrint("点击装备:", EquipInfo.EquipId)
    if self.Tips then
        self.Tips:Show(EquipInfo)
        self:SetMouseCursorVisible(false)
        AudioManager(self):PlayUISound(self, "event:/ui/common/combat_bag_cell_place_common", "", nil)
        if UIUtils.IsGamepadInput() then
            self:SetFocusState(self.FocusState.Focus3)
        end
    end
end

function View:SetMouseCursorVisible(bVisible)
    local PC = UE4.UGameplayStatics.GetPlayerController(self, 0)
    if not PC then
        return
    end

    PC.bShowMouseCursor = bVisible
    PC.bEnableClickEvents = bVisible
    PC.bEnableMouseOverEvents = bVisible
end

-- 默认展示第一个item
function View:DefaultShowFirstItem()
    self.CurrentIndex = 1
    self.OldIndex = 0
    local ObjData = self.List_Tab:GetItemAt(0)
    if not ObjData or not ObjData.Data then
        return
    end

    local MonsterIndex = ObjData.Index
    if not MonsterIndex then
        return
    end

    self:SelectMonsterItem(MonsterIndex)
end

-- 配合按钮选择item
function View:MoveSelection(Delta)
    if not self.MosterInfoData or #self.MosterInfoData <= 0 then
        return
    end

    local Count = #self.MosterInfoData
    self.CurrentIndex = self.CurrentIndex or 1

    local NewIndex = self.CurrentIndex + Delta

    -- 循环
    NewIndex = ((NewIndex - 1) % Count) + 1

    if NewIndex == self.CurrentIndex then
        return
    end
    self.CurrentIndex = NewIndex

    local ObjData = self.List_Tab:GetItemAt(self.CurrentIndex - 1) -- 0-based
    if not ObjData then
        return
    end

    local MonsterId = ObjData.Data and ObjData.Data.MonsterId
    if not MonsterId then
        return
    end

    DebugPrint("------------当前怪物Id：", MonsterId)
    DebugPrint("------------当前序号：", self.CurrentIndex)

    self:SelectMonsterItem(self.CurrentIndex)

    if self.List_Tab.NavigateToIndex then
        self.List_Tab:NavigateToIndex(self.CurrentIndex - 1)
    end
end

function View:ChangeHightlight(NewMonsterIndex, OldMonsterIndex)
    local NewMonsterData = self.List_Tab:GetItemAt(NewMonsterIndex - 1)
    local OldMonsterData = self.List_Tab:GetItemAt(OldMonsterIndex - 1)

    if OldMonsterData then
        OldMonsterData.IsSelected = false
    end
    if NewMonsterData then
        NewMonsterData.IsSelected = true
    end

    local AllDisplayedEntries = self.List_Tab:GetDisplayedEntryWidgets()
    -- 高亮新的Item
    for _, Entry in pairs(AllDisplayedEntries) do
        local Idx = Entry.Content.Index
        if Idx == OldMonsterData.Index then
            Entry:SetSelected(OldMonsterData.IsSelected)
        elseif Idx == NewMonsterData.Index then
            Entry:SetSelected(NewMonsterData.IsSelected)
        end
    end
end

-- 手柄切换检测
function View:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
    if UIUtils.IsKeyboardInput() then
        DebugPrint("------------键盘输入切换:更换按键图标-------------")
        self:ChangeKeyImg(0)
        self:SetFocus()
        self.Key_Return:SetVisibility(UE4.ESlateVisibility.Visible)
    elseif UIUtils.IsGamepadInput() then
        self:ChangeKeyImg(1)
        self:SetFocusState(self.FocusState.Focus1)
        self:RefreshKeyTips()
        self.Key_Return:SetVisibility(UE4.ESlateVisibility.Collapsed)
        if self:IsTipsVisible() then
            self.Tips:Hide()
        end
    end
end

function View:ChangeKeyImg(Index)
    DebugPrint("------------手柄输入切换:更换按键图标-------------")
    if Index == 0 then
        if self.WidgetSwitcher_L then
            self.WidgetSwitcher_L:SetActiveWidgetIndex(Index)
        end
        if self.WidgetSwitcher_R then
            self.WidgetSwitcher_R:SetActiveWidgetIndex(Index)
        end
        if self.WidgetSwitcher_MP then
            self.WidgetSwitcher_MP:SetActiveWidgetIndex(Index)
        end
        if self.Equipment.Controller_Equipment then
            self.Equipment.Controller_Equipment:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
    elseif Index == 1 then
        if self.WidgetSwitcher_L then
            self.WidgetSwitcher_L:SetActiveWidgetIndex(Index)
        end
        if self.WidgetSwitcher_R then
            self.WidgetSwitcher_R:SetActiveWidgetIndex(Index)
        end
        if self.WidgetSwitcher_MP then
            self.WidgetSwitcher_MP:SetActiveWidgetIndex(Index)
        end
        if self.Equipment.Controller_Equipment then
            self.Equipment.Controller_Equipment:SetVisibility(UE4.ESlateVisibility.Visible)
        end
    else
        return
    end
end

-- 手柄端
-------------------------------------------------
function View:SetFocusState(State)
    self.CurFocusState = State
    self:RefreshKeyTips() -- 按键显示的切换
    self:ChangeFocusObj() -- 设置每个状态需要聚焦的UI对象
end

function View:RefreshKeyTips()
    if not UIUtils.IsGamepadInput() then
        return
    end
    local Key01 = self.Key_Check_GamePad
    local Key02 = self.Key_Close_GamePad
    Key01:SetVisibility(UE4.ESlateVisibility.Collapsed)
    Key02:SetVisibility(UE4.ESlateVisibility.Collapsed)

    if self.CurFocusState == self.FocusState.Focus1 then
        Key01:SetVisibility(UE4.ESlateVisibility.Visible)
        Key02:SetVisibility(UE4.ESlateVisibility.Visible)
        -- Key01：滚动查看
        Key01:CreateCommonKey(
            {
                KeyInfoList = {{Type = "Img", ImgShortPath = UIConst.GamePadImgKey.RightTriggerAnalog}},
                Desc = GText("UI_Controller_Slide")
            }
        )

        -- Key02：返回
        Key02:CreateCommonKey(
            {
                KeyInfoList = {{Type = "Img", ImgShortPath = UIConst.GamePadImgKey.FaceButtonRight}},
                Desc = GText("UI_Tips_Close")
            }
        )
        self.Key_Left_GamePad:SetVisibility(UE4.ESlateVisibility.Visible)
        self.Key_Left_GamePad:CreateCommonKey(
            {
                KeyInfoList = {
                    {
                        Type = "Img",
                        ImgShortPath = UIConst.GamePadImgKey.LeftShoulder
                    }
                }
            }
        )
        self.Key_Right_GamePad:SetVisibility(UE4.ESlateVisibility.Visible)
        self.Key_Right_GamePad:CreateCommonKey(
            {
                KeyInfoList = {
                    {
                        Type = "Img",
                        ImgShortPath = UIConst.GamePadImgKey.RightShoulder
                    }
                }
            }
        )
        self.Equipment.Controller_Equipment:SetVisibility(UE4.ESlateVisibility.Visible)
        self.Equipment.Controller_Equipment:CreateCommonKey(
            {
                KeyInfoList = {
                    {
                        Type = "Img",
                        ImgShortPath = UIConst.GamePadImgKey.LeftThumb
                    }
                }
            }
        )
    elseif self.CurFocusState == self.FocusState.Focus2 then
        -- Key01：确认
        Key01:SetVisibility(UE4.ESlateVisibility.Visible)
        Key01:CreateCommonKey(
            {
                KeyInfoList = {{Type = "Img", ImgShortPath = UIConst.GamePadImgKey.FaceButtonBottom}}, -- A
                Desc = GText("UI_Tips_Ensure")
            }
        )

        -- Key02：返回
        Key02:SetVisibility(UE4.ESlateVisibility.Visible)
        Key02:CreateCommonKey(
            {
                KeyInfoList = {{Type = "Img", ImgShortPath = UIConst.GamePadImgKey.FaceButtonRight}}, -- B
                Desc = GText("UI_Tips_Close")
            }
        )

        self.Key_Left_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Key_Right_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Equipment.Controller_Equipment:SetVisibility(UE4.ESlateVisibility.Collapsed)
    elseif self.CurFocusState == self.FocusState.Focus3 then
        -- 只显示一个返回
        Key01:SetVisibility(UE4.ESlateVisibility.Visible)
        Key02:SetVisibility(UE4.ESlateVisibility.Collapsed)
        Key01:CreateCommonKey(
            {
                KeyInfoList = {{Type = "Img", ImgShortPath = UIConst.GamePadImgKey.FaceButtonRight}}, -- B
                Desc = GText("UI_Tips_Close")
            }
        )
    end
end

function View:ChangeFocusObj()
    if self.CurFocusState == self.FocusState.Focus1 then
        if self.List_Tab then
            self.List_Tab:SetFocus()
        end
    elseif self.CurFocusState == self.FocusState.Focus2 then
        -- 装备栏第一个格子
        if self.Equipment then
            self.Equipment.Equipment_01:SetFocus()
        end
    elseif self.CurFocusState == self.FocusState.Focus3 then
        if self.Tips then
            self.Tips:SetFocus() -- Focus3唯一焦点锚点(Test)
        end
    end
end

function View:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    -- 键盘
    if InKey == UE4.EKeys.Q then
        AudioManager(self):PlayUISound(self, "event:/ui/common/click_mid", "", nil)
        self:MoveSelection(-1)
        return UE4.UWidgetBlueprintLibrary.Handled()
    end

    if InKey == UE4.EKeys.E then
        AudioManager(self):PlayUISound(self, "event:/ui/common/click_mid", "", nil)
        self:MoveSelection(1)
        return UE4.UWidgetBlueprintLibrary.Handled()
    end

    if (InKeyName == "Escape") then
        self:OnBackBtnClicked()
        return UE4.UWidgetBlueprintLibrary.Handled()
    end
    -- 手柄

    if not UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
        return UE4.UWidgetBlueprintLibrary.Unhandled()
    end
    -- Focus1，2，3: B返回
    if InKeyName == Const.GamepadFaceButtonRight then
        if self.CurFocusState == self.FocusState.Focus1 then
            self:OnBackBtnClicked()
        elseif self.CurFocusState == self.FocusState.Focus2 then
            self:SetFocusState(self.FocusState.Focus1)
        elseif self.CurFocusState == self.FocusState.Focus3 then
            self.Tips:SetVisibility(UE4.ESlateVisibility.Collapsed)
            self:SetFocusState(self.FocusState.Focus2)
        end
        return UE4.UWidgetBlueprintLibrary.Handled()
    end

    -- Focus1: LB/RB 切列表
    if self.CurFocusState == self.FocusState.Focus1 then
        if InKeyName == Const.GamepadLeftShoulder then
            AudioManager(self):PlayUISound(self, "event:/ui/common/click_mid", "", nil)
            self:MoveSelection(-1)
            return UE4.UWidgetBlueprintLibrary.Handled()
        elseif InKeyName == Const.GamepadRightShoulder then
            AudioManager(self):PlayUISound(self, "event:/ui/common/click_mid", "", nil)
            self:MoveSelection(1)
            return UE4.UWidgetBlueprintLibrary.Handled()
        elseif InKeyName == Const.GamepadLeftThumbstick then -- L3
            self:SetFocusState(self.FocusState.Focus2)
            return UE4.UWidgetBlueprintLibrary.Handled()
        elseif InKeyName == Const.RightStickUp then
            self:ScrollMonsterDesc(-1) -- 向上滚
            DebugPrint("-----------向上滚------------")
            return UE4.UWidgetBlueprintLibrary.Handled()
        elseif InKeyName == Const.RightStickDown then
            self:ScrollMonsterDesc(1) -- 向下滚
            DebugPrint("-----------向下滚------------")
            return UE4.UWidgetBlueprintLibrary.Handled()
        end
    end

    -- Focus2: A 打开Tips 这里同样走OnEquipItemClicked
    -- if self.CurFocusState == self.FocusState.Focus2 then
    --     if InKeyName == Const.GamepadFaceButtonDown then -- A
    --         DebugPrint("-------------显示Tips面板---------------")
    --         self.Tips:Show(self.CurEquipInfo)
    --         self:SetFocusState(self.FocusState.Focus3)
    --         return UE4.UWidgetBlueprintLibrary.Handled()
    --     end
    -- end
    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function View:InitKeyImg()
    if UIUtils.IsMobileInput() then
        self:HideBtnOnMobile()
        return
    end
    self.Key_Left:CreateCommonKey(
        {
            KeyInfoList = {
                {
                    Type = "Text",
                    Text = "Q"
                }
            }
        }
    )
    self.Key_Right:CreateCommonKey(
        {
            KeyInfoList = {
                {
                    Type = "Text",
                    Text = "E"
                }
            }
        }
    )
    self.Key_Return:CreateCommonKey(
        {
            KeyInfoList = {
                {
                    Type = "Text",
                    Text = "Esc"
                }
            },
            Desc = GText("UI_Tips_Close")
        }
    )
end

function View:HideBtnOnMobile()
    if self.Key_Left then
        self.Key_Left:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end

    if self.Key_Right then
        self.Key_Right:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end

    if self.Key_Return then
        self.Key_Return:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function View:OnAnimationFinished(Animation)
    if Animation == self.Out then
        self:Close()
    end
end

function View:BindBtnEvent()
    if self.Button_Back then
        -- 关闭
        self.Button_Back.OnClicked:Remove(self, self.OnBackBtnClicked)
        self.Button_Back.OnClicked:Add(self, self.OnBackBtnClicked)
    end

    if self.Arrow_Right then
        -- 箭头向右
        self.Arrow_Right.OnClicked:Remove(self, self.OnArrowRightBtnClicked)
        self.Arrow_Right.OnClicked:Add(self, self.OnArrowRightBtnClicked)
    end

    if self.Arrow_Left then
        -- 箭头向左
        self.Arrow_Left.OnClicked:Remove(self, self.OnArrowLeftBtnClicked)
        self.Arrow_Left.OnClicked:Add(self, self.OnArrowLeftBtnClicked)
    end
end

function View:OnBackBtnClicked()
    if self.Tips and self:IsTipsVisible() then
        self.Tips:Hide()
    else
        if self.bClosing then
            return
        end
        self.bClosing = true
        -- 返回按钮
        self:PlayAnimation(self.Out)
        AudioManager(self):SetEventSoundParam(self, "DeputeMonsterInfo", {ToEnd = 1})
    end
end

function View:OnArrowRightBtnClicked()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", "", nil)
    -- 向右箭头按钮
    DebugPrint("----------------向右箭头按钮----------------")
    self:MoveSelection(1)
end

function View:OnArrowLeftBtnClicked()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", "", nil)
    -- 向左箭头按钮
    DebugPrint("----------------向左箭头按钮----------------")
    self:MoveSelection(-1)
end

function View:ScrollMonsterDesc(Dir)
    local SB = self.EMScrollBox_1
    if not SB then
        return
    end

    local Step = 40
    local Cur = SB:GetScrollOffset()
    local NewOffset = Cur + Dir * Step
    SB:SetScrollOffset(NewOffset)
    DebugPrint("Scroll: Cur=", Cur, " New=", NewOffset, " After=", SB:GetScrollOffset())
end

function View:IsTipsVisible()
    if not self.Tips then
        return false
    end

    local Vis = self.Tips:GetVisibility()
    return Vis == UE4.ESlateVisibility.Visible or Vis == UE4.ESlateVisibility.HitTestInvisible or
        Vis == UE4.ESlateVisibility.SelfHitTestInvisible
end

return View
