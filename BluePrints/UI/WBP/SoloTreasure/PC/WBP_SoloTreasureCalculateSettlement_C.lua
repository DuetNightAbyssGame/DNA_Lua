--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_SoloTreasure_Settlement_P_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function M:InitUIInfo(Name, IsInUIMode, EventList, ...)
    self.Super.InitUIInfo(self, Name, IsInUIMode, EventList, ...)
    self:InitDeviceInfo()
    self:InitListenEvent()
end

function M:OnLoaded(...)
    self.DungeonSettlementInfo = ...
    --获取数据
    local DungeonId, IsWin, Rewards, DungeonRewards, PlayerTime, GameTime,  ClientRes = table.unpack(self.DungeonSettlementInfo, 1, self.DungeonSettlementInfo.n)
    self.SoloTreasureInfo = ClientRes
    --SoloTreasureInfo拿不到值，先用测试数据
    if not self.SoloTreasureInfo then
        ScreenPrint("SoloTreasureInfo is nil, use test data !!!!!!!!!!!")
        self.SoloTreasureInfo = {ItemList = {}, 
        Ticket = -1}
    end
    self.ItemList = self.SoloTreasureInfo.ItemList
    self.TicketId = self.SoloTreasureInfo.Ticket
    --初始化积分
    self.SoloTreasureScore = 0
    --初始化文本
    self:InitText()
    --初始化按钮
    self:InitBtn()
    --初始化彩票
    self:InitTicketInfo()
    --初始化物资信息
    self:InitItemListInfo()
    --给listview添加空态
    self:FillEmptyItem()
    --播放动画In，之后开始计算物资积分
    --绑定事件，播放完后开始计算物资积分
    self:UnbindAllFromAnimationFinished(self.In)
    self:BindToAnimationFinished(self.In, {self, function()
        self:StartToShowItem()
    end})
    self:PlayAnimation(self.In)
end

--给listview添加空态
function M:FillEmptyItem()
    --local ItemNumEachRow, RowNum = UIUtils.GetTileViewContentMaxCount(self.List_Items, "XY", true)
    local RowNum = math.ceil(#self.ItemShowInfo/5)
    RowNum = math.max(3, RowNum)
    local EmptyItemNums = 5 * RowNum - #self.ItemShowInfo
    for i = 1, 5 * RowNum, 1 do
        local Content =  NewObject(UIUtils.GetCommonItemContentClass())
        Content.IsEmpty = true
        self.List_Items:AddItem(Content)
    end
end

--开始展示收集到的物资
function M:StartToShowItem()
    if not self.ItemShowInfo or (self.ItemShowInfo and #self.ItemShowInfo < 1) then
        --self.List_Items:ClearListItems()
        return
    end
    self.CurIndex = 1
    self.RealShowItemList = {}
    self:AddTimer(self.ItemInterval, function()
        if self.CurIndex > #self.ItemShowInfo then
            if not self.TicketId or self.TicketId <= 0 then
                self:RemoveTimer("ShowItem")
                return
            end
            --检查彩票类型是否为整体加分的，是的话需要再进行计算
            local LotteryInfo = self.TicketId and DataMgr.ExtractionLottery[self.TicketId]
            local AddScore = 0
            if LotteryInfo then
                if self.TicketType == 3 then
                    if self.SoloTreasureScore >= LotteryInfo.Param[1] then
                        AddScore = self.SoloTreasureScore * (LotteryInfo.EffectParam - 1)
                    end
                elseif self.TicketType == 4 then
                    if self:GetItemNumByType("TreasureType", LotteryInfo.Param[1], LotteryInfo.Param[2]) then
                        AddScore = self.SoloTreasureScore * (LotteryInfo.EffectParam - 1)
                    end
                elseif self.TicketType == 5 then
                    if self:GetItemNumByType("TreasureRarity", LotteryInfo.Param[1], LotteryInfo.Param[2]) then
                        AddScore = self.SoloTreasureScore * (LotteryInfo.EffectParam - 1)
                    end
                end
            end
            if AddScore > 0 then
                self.WBP_Buff02:PlayAnimation(self.WBP_Buff02.Buff_Add)
                self.SoloTreasureScore = UIUtils.RollingNumberEffect(self, self.Text_TitleNum, self.SoloTreasureScore, AddScore)
            end
            self:RemoveTimer("ShowItem")
        else
            local ItemInfo = self.ItemShowInfo[self.CurIndex]
            if not ItemInfo then
               return
            end
            --self.List_Items:ClearListItems()

            --local Content =  NewObject(UIUtils.GetCommonItemContentClass())
            local Content =  {}
            Content.ItemIndex = self.CurIndex
            Content.Icon = ItemInfo.Icon
            Content.Rarity = ItemInfo.TreasureRarity
            Content.Value = ItemInfo.TreasureValue
            Content.TreasureType = ItemInfo.TreasureType
            Content.BuffRarity = self.TicketRarity -- 彩票稀有度
            Content.BuffRate = self.TicketRate -- 彩票倍率
            Content.BuffType = self.TicketType -- 彩票类型
            Content.BuffParam1 = self.TicketParam1 -- 彩票对象参数1
            Content.BuffParam2 = self.TicketParam2 -- 彩票对象参数2
            Content.Owner = self

            table.insert(self.RealShowItemList, Content)
            if #self.RealShowItemList > 1 then
                table.sort(self.RealShowItemList, function(a, b)
                    return a.ItemIndex > b.ItemIndex
                end)
            end

            for Index, value in ipairs(self.RealShowItemList) do
                --self.List_Items:AddItem(value)
                self.List_Items:GetItemAt(Index - 1).SelfWidget:LoadItem(value)
            end

            local AddScore = 0
            self:AddDelayFrameFunc(function()
                if self.CurWidget then
                    AddScore = self.CurWidget:GetItemRealValue()
                end
                self.SoloTreasureScore = UIUtils.RollingNumberEffect(self, self.Text_TitleNum, self.SoloTreasureScore, AddScore)
            end, 5, "CalGameScore")

            self.CurIndex = self.CurIndex + 1
        end
    end, true, 0, "ShowItem", true)
end

function M:GetItemNumByType(ItemType, Type1, Type2)
    local ItemNum = 0
    for _, ItemInfo in pairs(self.RealShowItemList) do
        if ItemInfo[ItemType] == Type1 then
            ItemNum = ItemNum + 1
        end
    end
    return ItemNum >= Type2
end

function M:InitItemListInfo()
    -- 根据id获取item信息
    local SoloTreasureData =  DataMgr.ExtractionTreasure
    self.List_Items:ClearListItems()
    if not SoloTreasureData then
        return
    end
    self.ItemShowInfo = {}
    for _, ItemId in pairs(self.ItemList) do
        if SoloTreasureData[ItemId] then
            table.insert(self.ItemShowInfo, SoloTreasureData[ItemId])
        end
    end
    if #self.ItemShowInfo > 1 then
        table.sort(self.ItemShowInfo, function(a, b)
            if a.TreasureRarity == b.TreasureRarity then
                return a.TreasureValue < b.TreasureValue
            end
            return a.TreasureRarity < b.TreasureRarity
        end)
    end
end

function M:InitTicketInfo()
    -- 根据id获取彩票信息
    if not self.TicketId or self.TicketId <= 0 then
        self.WBP_Buff02:SetVisibility(ESlateVisibility.Collapsed)
        return
    end
    local TicketInfo = DataMgr.ExtractionLottery[self.TicketId]
    if TicketInfo then
        --彩票的稀有度
        self.TicketRarity = TicketInfo.Quality
        -- 获取彩票的倍率
        self.TicketRate = TicketInfo.EffectParam
        -- 获取彩票的类型
        self.TicketType = TicketInfo.LotteryType
        --彩票目标参数1
        self.TicketParam1 = TicketInfo.Param[1]
        --彩票目标参数2
        self.TicketParam2 = TicketInfo.Param[2]
        --彩票的描述
        self.TicketDesc = TicketInfo.Desc
        --初始化彩票ui
        self:UpdateBuffUI()
    else
        self.WBP_Buff02:SetVisibility(ESlateVisibility.Collapsed)
    end
end

--初始化彩票ui
function M:UpdateBuffUI()
    self.WBP_Buff02:SetBuffType(self.TicketRarity - 1)
    self.WBP_Buff02:InitData({Description = self.TicketDesc})
end

function M:InitBtn()
    self.Btn_Check:SetText(GText("UI_Extraction_TM_29"))
    self.Btn_Check:SetDefaultGamePadImg("A")
    self.Btn_Check.Button_Area.OnClicked:Add(self, self.LoadRealSettlement)
end

function M:LoadRealSettlement()
    UIManager(self):LoadUINew("SoloTreasureEvacuation", self.DungeonSettlementInfo)
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem:SetNavigateWidgetOpacity(1)
    end
    self:Close()
end

function M:InitText()
    self.Text_Title:SetText(GText("UI_Extraction_TM_27"))
    self.Text_TitleNum:SetText("0")
    self.Text_Details:SetText(GText("UI_Extraction_TM_28"))
end

function M:InitDeviceInfo()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem:SetNavigateWidgetOpacity(0)
        self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end
end

function M:InitListenEvent()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self,self.RefreshOpInfoByInputDevice)
    end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    --更新输入模式
    self.CurInputDeviceType = CurInputDevice
    self.CurGamepadName = CurGamepadName
    self.IsSwitchDevice = true
    --更新UI
    self:UpdateUI()
end

function M:UpdateUI()
    if self.CurInputDeviceType == ECommonInputType.MouseAndKeyboard or self.CurInputDeviceType == ECommonInputType.Touch then
        if self.Key_Check_GamePad then
            self.Key_Check_GamePad:SetVisibility(ESlateVisibility.Collapsed)
        end
    else
        if self.Key_Check_GamePad then
            self.Key_Check_GamePad:CreateCommonKey({
                KeyInfoList={
                    {
                        Type = "Img",
                        ImgShortPath = "RV",
                    },
                },
                Desc = GText("UI_Controller_Slide")
            })
            self.Key_Check_GamePad:SetVisibility(ESlateVisibility.Visible)
        end
    end
end

function M:OnAnalogValueChanged(MyGeometry,InAnalogInputEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (InKeyName == UIConst.GamePadKey.RightAnalogY) then
        if math.abs(UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)) >= 0.5 then
            local DeltaOffset = (-1) * UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 5
            local CurrentOffset = self.EMScrollBox_0:GetScrollOffset()
            local NextOffset = math.clamp(CurrentOffset + DeltaOffset,0, self.EMScrollBox_0:GetScrollOffsetOfEnd())
            self.EMScrollBox_0:SetScrollOffset(NextOffset)
            return UIUtils.Handled
        end
    end
    return UIUtils.Unhandled
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        IsEventHandled = self:Handle_OnGamePadDown(InKeyName)
    else
        IsEventHandled = self:Handle_OnPCDown(InKeyName) 
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()    
    end
end

function M:Handle_OnGamePadDown(InKeyName)
    if InKeyName == "Gamepad_FaceButton_Bottom" then
        self:LoadRealSettlement()
        return true
    end
    return false
end

function M:Handle_OnPCDown(InKeyName)
    -- if InKeyName == "Escape" then
    --     self:LoadRealSettlement()
    --     return true
    -- end
    return false
end

return M
