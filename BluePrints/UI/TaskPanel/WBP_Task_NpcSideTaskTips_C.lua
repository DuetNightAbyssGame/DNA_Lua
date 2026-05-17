-- 对应蓝图WBP_Task_NpcSideTaskTips
-- 和BluePrints\UI\UI_PC\LevelMap\Widget\Wild\LevelMap_Task_Widget_C.lua基本相同，但细节不一样，比如SetWatchTaskContentGamePadKeys

require "UnLua"

---@type WBP_Task_NpcSideTaskTips_C
local WBP_Task_NpcSideTaskTips_C = Class("BluePrints.UI.BP_UIState_C")
local TaskUtils = require "BluePrints.UI.TaskPanel.TaskUtils"

function WBP_Task_NpcSideTaskTips_C:Initialize(Initializer)
    self.Super.Initialize(self)
end

function WBP_Task_NpcSideTaskTips_C:OnLoaded(...)
    self.Super.OnLoaded(self, ...)
    self.ReceiveNode = ...

    self:PlayAnimation(self.In)
    local TextTitle = GText("UI_QUEST_SUBTAB_NAME_SIDE")
    if DataMgr.QuestChain[self.ReceiveNode.SideQuestChainId] and DataMgr.QuestChain[self.ReceiveNode.SideQuestChainId].QuestChainType == Const.SpecialSideQuestChainType then
        TextTitle = GText("UI_QUEST_SUBTAB_NAME_SpecialSlide")
    end

    self.Text_Title:SetText(TextTitle)
    if DataMgr.QuestChain[self.ReceiveNode.SideQuestChainId] then
        local BranchQuestChainName = DataMgr.QuestChain[self.ReceiveNode.SideQuestChainId].QuestChainName or "UI_QUEST_UNKNOWN"
        local BranchQuestNpcNameId = DataMgr.QuestChain[self.ReceiveNode.SideQuestChainId].QuestNpcId or "UI_QUEST_UNKNOWN"
        local Avatar = GWorld:GetAvatar()
        if Avatar then
            local SignTexture = TaskUtils:GetGrayIconTextureByQuestChainType(self.ReceiveNode.SideQuestChainId)
            if SignTexture then
                self.Image_Sign:SetBrushResourceObject(SignTexture)
            end
        end

        local NpcName = nil
        if BranchQuestNpcNameId ~= "UI_QUEST_UNKNOWN" then
            NpcName = DataMgr.Npc[BranchQuestNpcNameId].UnitName
        end
        self.Text_SideTitleName:SetText(GText(BranchQuestChainName))
        if NpcName ~= nil then
            self.Text_NPCName:SetText(GText(NpcName))
        end
    else
        self.Text_SideTitleName:SetText(GText("UI_QUEST_UNKNOWN"))
        self.Text_NPCName:SetText("NICKNAME")
    end
    local BranchQuestTitle = "UI_QUEST_CONTENT"
    local BranchQuestDetail = DataMgr.QuestChain[self.ReceiveNode.SideQuestChainId].QuestDetail or "UI_QUEST_UNKNOWN"
    self.Text_MissionDetailTitle:SetText(GText(BranchQuestTitle))
    self.Text_TaskDetail:SetText(GText(BranchQuestDetail))
    self.Text_RewardDetailTitle:SetText(GText("UI_QUEST_REWARDS"))
    self.Btn_Start:SetText(GText("UI_Quest_TakeQuest"))
    self.Btn_Start:BindEventOnClicked(self, self.Approve)
    self.Btn_Close:BindEventOnClicked(self, self.Cancel)
    
    self:InitRewardList()

    self.EMScrollBox_3:ScrollToStart()
    self:SetFocus()
    self.Key_TitleRewards:CreateCommonKey({
        KeyInfoList = {
            {
                Type = "Img",
                ImgShortPath = "LS"
            }
        },
    })
    self:InitCommonWidget()
    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType())

    AudioManager(self):PlayUISound(self, "event:/snapshot/ui/filter_talk_stage", "OpenNpcSideTips", nil)
    AudioManager(self):PlayUISound(self, "event:/ui/common/sub_task_panel_show", "OpenNpcSideTips_Extra", nil)
end

function WBP_Task_NpcSideTaskTips_C:Destruct()
    self.Super.Destruct(self)
    AudioManager(self):SetEventSoundParam(self, "OpenNpcSideTips", {ToEnd = 1})
end

function WBP_Task_NpcSideTaskTips_C:InitRewardList()
    local RewardList = DataMgr.QuestChain[self.ReceiveNode.SideQuestChainId].QuestChainReward
    local TempRewardRetTable = {}
    if RewardList then
        for _, RewardId in pairs(RewardList) do
            local RewardInfo = DataMgr.Reward[RewardId]
            if RewardInfo then
                local Ids = RewardInfo.Id or {}
                local RewardCount = RewardInfo.Count or {}
                local TableName = RewardInfo.Type or {}
                for i = 1, #Ids do
                    local ItemId = Ids[i]
                    local Count = RewardUtils:GetCount(RewardCount[i])
                    local Icon = ItemUtils.GetItemIconPath(ItemId, TableName[i])
                    local Rarity = ItemUtils.GetItemRarity(ItemId, TableName[i])
                    local ItemType = TableName[i]
                    local RewardContent = TaskUtils:CreateRewardContent(
                        {Id = ItemId, Count = Count, OwnerWidget = self, Icon = Icon, Rarity = Rarity, IsShowDetails = true,ItemType = ItemType}
                    )
                    RewardContent.OnMenuOpenChangedEvents =
                    {
                        Obj = self,
                        Callback = self.OnRewardItemMenuAnchorChanged
                    }
                    table.insert(TempRewardRetTable, RewardContent)
                end
            end
        end
    end
    if not IsEmptyTable(TempRewardRetTable) then
        table.sort(TempRewardRetTable, function(a, b)
            return a.Rarity > b.Rarity
        end)
        for _, v in pairs(TempRewardRetTable) do
            self.List_Reward:AddItem(v)
        end
    end
end

function WBP_Task_NpcSideTaskTips_C:Approve()
    self.ReceiveNode:FinishAction("ApproveOut")
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_confirm_positive", nil, nil)
end

function WBP_Task_NpcSideTaskTips_C:Cancel()
    self.ReceiveNode:FinishAction("CancelOut")
end

function WBP_Task_NpcSideTaskTips_C:CloseTips()
    self.List_Reward:ClearListItems()
    self:BindToAnimationFinished(self.Out,{self,function ()
        self:UnbindAllFromAnimationFinished(self.Out)
        self:Close()
    end})
    self:PlayAnimation(self.Out)
end

function WBP_Task_NpcSideTaskTips_C:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local KeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
     -- 手柄端LS选中/离开奖励栏
    if KeyName == UIConst.GamePadKey.LeftThumb then
        local Visible = self.Key_TitleRewards:GetVisibility()
        if Visible == UE4.ESlateVisibility.Collapsed then
            self:ShowGamepadRewardKey(true)
            self:TileViewQuit()
            self:SetWatchTaskContentGamePadKeys()
            self.Btn_Start:SetGamePadVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        elseif Visible == UE4.ESlateVisibility.Visible then
            self:ShowGamepadRewardKey(false)
            self:TileViewSelectFirst()
            self.Com_MidKeyTips:UpdateKeyInfo(self.SelectTaskRewardGamePadKeys)
            self.Btn_Start:SetGamePadVisibility(UIConst.VisibilityOp["Collapsed"])
        end
        return UWidgetBlueprintLibrary.Handled()
    -- 手柄键B
    elseif KeyName == UIConst.GamePadKey.FaceButtonRight then
        -- 离开奖励栏
        if self.List_Reward:HasAnyUserFocus()
            or self.List_Reward:HasFocusedDescendants() then
            self:ShowGamepadRewardKey(true)
            self:TileViewQuit()
            self:SetWatchTaskContentGamePadKeys()
            self.Btn_Start:SetGamePadVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
            return UWidgetBlueprintLibrary.Handled()
        -- 关闭任务接取界面
        else
            self:Cancel()
        end
    -- 手柄键A
    elseif KeyName == UIConst.GamePadKey.FaceButtonBottom then
        self:Approve()
    end

    return UWidgetBlueprintLibrary.UnHandled()
end

-- 这个界面手柄端需要接收A键来确认。但是我如果focus到emscrollbox，就接收不到A键了，所以我只能focus到根节点。根节点才有那个
-- "是否自行捕捉手柄确认键"选项。但是我不focus到emscrollbox的话，emscrollbox滚动功能是正常的，就是无法显示滚动条。
-- 两个方案都可以：
-- 1.在focus到emscrollbox的时候也能接收到A键
-- 2.emscrollbox在手柄模式下不需要focus也能根据内容是否溢出显示滚动条
-- 和赖晓杨讨论后，使用方案2。
function WBP_Task_NpcSideTaskTips_C:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if CurInputDevice == ECommonInputType.Gamepad then
        self.EMScrollBox_3:SetControlScrollbarInside(false)
        if self.EMScrollBox_3:HasAnyUserFocus() then
            self:SetFocus()
        end

        if self.List_Reward:HasAnyUserFocus() then
            self.Com_MidKeyTips:UpdateKeyInfo(self.SelectTaskRewardGamePadKeys)
            self:ShowGamepadRewardKey(false)
            self.Btn_Start:SetGamePadVisibility(UIConst.VisibilityOp["Collapsed"])
        elseif self.List_Reward:HasFocusedDescendants() then
            self.Com_MidKeyTips:UpdateKeyInfo({})
            self:ShowGamepadRewardKey(false)
            self.Btn_Start:SetGamePadVisibility(UIConst.VisibilityOp["Collapsed"])
        else
            self:SetWatchTaskContentGamePadKeys()
            self:ShowGamepadRewardKey(true)
            self.Btn_Start:SetGamePadVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        end
    else
        UIUtils.SetUpScrollBox(self.EMScrollBox_3)

        self:ShowGamepadRewardKey(false)
        self.Com_MidKeyTips:UpdateKeyInfo({})
    end
end

-- 奖励详情弹窗打开/关闭
function WBP_Task_NpcSideTaskTips_C:OnRewardItemMenuAnchorChanged(bIsOpen)
    if self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad then
        if bIsOpen then
            self.Com_MidKeyTips:UpdateKeyInfo({})
        else
            self.Com_MidKeyTips:UpdateKeyInfo(self.SelectTaskRewardGamePadKeys)
        end
    end
end

-- 根据滚动框是否需要滚动显示按键提示
function WBP_Task_NpcSideTaskTips_C:SetWatchTaskContentGamePadKeys()
    if not self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad then
        return
    end
    local ContentHeight = self.EMScrollBox_3:GetDesiredSize().Y
    local VisibleHeight = USlateBlueprintLibrary.GetLocalSize(self.EMScrollBox_3:GetTickSpaceGeometry()).Y
    -- 存上一帧的VisibleHeight
    self.LastVisibleHeight = self.LastVisibleHeight or VisibleHeight
    -- 延迟到下一帧
    if VisibleHeight == 0 then
        self:AddTimer(1e-3, self.SetWatchTaskContentGamePadKeys, false, 0, "WBP_Task_NpcSideTaskTips", true)
        return
    else
        -- VisibleHeight还在变化，说明动画还没结束，继续延迟
        if math.abs(VisibleHeight - self.LastVisibleHeight) > 1e-3 then
            self.LastVisibleHeight = VisibleHeight
            self:AddTimer(1e-3, self.SetWatchTaskContentGamePadKeys, false, 0, "WBP_Task_NpcSideTaskTips", true)
            return
        end
    end
    if ContentHeight - VisibleHeight > 1e-3 then
        self.EMScrollBox_3:SetScrollBarVisibility(UIConst.VisibilityOp.Visible)
        self.Com_MidKeyTips:UpdateKeyInfo(self.WatchTaskContentGamePadKeys)
    else
        self.EMScrollBox_3:SetScrollBarVisibility(UIConst.VisibilityOp.Collapsed)
        self.Com_MidKeyTips:UpdateKeyInfo(self.BackGamePadKey)
    end
end


function WBP_Task_NpcSideTaskTips_C:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
    -- 手柄键RS滚动任务内容
    local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local AddOffset = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 5
    if InKeyName == UIConst.GamePadKey.RightAnalogY then
        local CurScrollOffset = self.EMScrollBox_3:GetScrollOffset()
        local ScrollOffset = math.clamp(CurScrollOffset - AddOffset,0, self.EMScrollBox_3:GetScrollOffsetOfEnd())
        self.EMScrollBox_3:SetScrollOffset(ScrollOffset)
    end
    return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function WBP_Task_NpcSideTaskTips_C:TileViewSelectFirst()
    local Items = self.List_Reward:GetListItems()
    if Items and Items:Num() > 0 then
        self.List_Reward:SetFocus()
        self.List_Reward:SetSelectedIndex(0)
        self.List_Reward:NavigateToIndex(0)
    end
end

function WBP_Task_NpcSideTaskTips_C:TileViewQuit()
    self:SetFocus()
end

-- 手柄端需要显示手柄按键图标，键鼠端不需要显示
function WBP_Task_NpcSideTaskTips_C:ShowGamepadRewardKey(flag)
    if flag then
        self.Key_TitleRewards:SetVisibility(UE4.ESlateVisibility.Visible)
        self.EMScrollBox_3:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self.Key_TitleRewards:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.EMScrollBox_3:SetVisibility(UE4.ESlateVisibility.Visible)
    end
end

function WBP_Task_NpcSideTaskTips_C:InitCommonWidget()
    -- 查看任务内容
    self.WatchTaskContentGamePadKeys = {
        {
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "RV"
                }
            },
            Desc = GText("UI_Controller_Slide"),
        },
        {
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "B"
                }
            },
            Desc = GText("UI_UIGUIDE_CLOSE"),
        },
    }
    self.BackGamePadKey = {
        {
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "B"
                }
            },
            Desc = GText("UI_UIGUIDE_CLOSE"),
        },
    }
    self.SelectTaskRewardGamePadKeys = {
        {
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "A"
                }
            },
            Desc = GText("UI_Controller_CheckDetails"),
        },
        {
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "B"
                }
            },
            Desc = GText("UI_BACK"),
        },
    }
end

return WBP_Task_NpcSideTaskTips_C
