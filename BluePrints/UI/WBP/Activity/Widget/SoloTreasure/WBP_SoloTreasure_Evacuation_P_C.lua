--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local InventoryController = require("BluePrints.UI.WBP.SoloTreasure.Widget.Inventory.InventoryController")
local TimeUtils = require "Utils.TimeUtils"

---@type WBP_SoloTreasure_Evacuation_P_C
local M = Class({"BluePrints.UI.BP_UIState_C", "BluePrints.Common.TimerMgr"})

---仅初始化lua变量时使用，千万不要有控件操作！！
function M:Initialize(Initializer)
end

function M:Construct()
    self:BindToAnimationFinished(self.Out, {self, self.OnOutAnimationFinished})
end

function M:InitUIInfo(Name, IsInUIMode, EventList, ...)
    self.Super.InitUIInfo(self, Name, IsInUIMode, EventList, ...)
    self:SetAllUIVisibility(true)  -- 将结算界面以外的其他界面隐藏
    -- 初始化倒计时
    self:InitExitCountDown()
end

function M:OnLoaded(...)
    -- 接收并处理外部参数，一些通用的界面加载完成之后的统一逻辑可以放在这, 子类如有一些Load完成之后的逻辑可以重写该方法
    DebugPrint("yly test OnLoaded")

    --设备切换监听
    self:InitDeviceInfo()
    self:InitListenEvent()

    -- 获取服务器传来的搜打撤结算信息
    -- local LogicServerInfo = ...
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if not GameMode then
        GWorld.logger.error("Can't Get GameMode!")
        return true 
    end
    self.SolotreasurePreInitInfo = GameMode.PreInitInfo
    if self.SolotreasurePreInitInfo == nil then
        GWorld.logger.error("Can't Get PreInitInfo! ")
        return true
    end
    self.EventId = self.SolotreasurePreInitInfo.EventDungeonId -- 活动Id
    self.BagId = self.SolotreasurePreInitInfo.BagId  -- 背包Id
    self.IsStory = self.SolotreasurePreInitInfo.IsStory -- 剧情or复刷关
    self.IsEasy = self.SolotreasurePreInitInfo.IsEasy  -- 简单or困难模式
    -- 复刷关 额外获得相关比例和上限
    self.ScoreToResourceRatio = nil
    self.ResourceUpperLimit = nil
    if not self.IsStory then
        if self.IsEasy then
            self.ScoreToResourceRatio = DataMgr.TreasureHuntRepeatDungeon[self.EventId].EasyScoreToResource
            self.ResourceUpperLimit = DataMgr.TreasureHuntRepeatDungeon[self.EventId].EasyMaxConvertResource
        else
            self.ScoreToResourceRatio = DataMgr.TreasureHuntRepeatDungeon[self.EventId].HardScoreToResource
            self.ResourceUpperLimit = DataMgr.TreasureHuntRepeatDungeon[self.EventId].HardMaxConvertResource
        end
    end
    -- 服务器传给的信息
    -- 临时测试
    -- LogicServerInfo = {true, 91801, {}, 5000, 1403668, 3001, 100}
    -- local GameState = UE4.UGameplayStatics.GetGameState(self)
    -- local LogicServerInfo = GameState.soloTreasureEvacuationInfo
    local LogicServerInfo = ...
    self.IsWin, self.DungeonId, self.Rewards, self.DungeonRewards, self.PlayerTime, self.GameTime, self.ClientRes = table.unpack(LogicServerInfo)
    self.KillMonsterScore = self.ClientRes.KillMonsterScore or 0
    self.TreasureScore = self.ClientRes.TreasureScore or 0
    if not self.IsWin then
        -- 失败结算的消息包里积分可能不为0，这里客户端处理下
        self.KillMonsterScore = 0
        self.TreasureScore = 0
    end
    self.TicketId = self.ClientRes.Ticket or -1
    -- self.BeginTimeStamp = self.ClientRes.BeginTimeStamp

    -- 正确获得EvacuationTime的方法
    if GWorld.GameInstance.CombatData == nil then
        GWorld.logger.error("Can't Get CombatData!")
        return
    end
    self.EvacuationTime = GWorld.GameInstance.CombatData.EvacuationTime

    -- 初始化背包
    self:InitBag()

    -- 初始化再玩消费
    if self.IsStory then
        self.playAgainCosts = DataMgr.TreasureHuntStoryDungeon[self.EventId].Fee
        self.playAgainCostsIconId = DataMgr.TreasureHuntStoryDungeon[self.EventId].FeeResource
    else
        self.playAgainCostsIconId = DataMgr.TreasureHuntRepeatDungeon[self.EventId].FeeResource
        if self.IsEasy then
            self.playAgainCosts = DataMgr.TreasureHuntRepeatDungeon[self.EventId].EasyModeFee
        else
            self.playAgainCosts = DataMgr.TreasureHuntRepeatDungeon[self.EventId].HardModeFee
        end
    end

    --初始化UI
    self:InitUIContent()

    -- 成功通过复刷关额外获得动画
    self.AddExtraResourceId = 1
    self.AddExtraResourceNum = 0
    self.AddExtraResourceTbl = self.ClientRes.AddExtraResource or {} -- {"101":100}
    for key, value in pairs(self.AddExtraResourceTbl) do
        self.AddExtraResourceId = key
        self.AddExtraResourceNum = value
    end
    self.Panel_TransCoin:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    -- yly test
    -- self.AddExtraResourceId = 101
    -- self.AddExtraResourceNum = 100000
    -- self.ResourceUpperLimit = 100000

    --播放胜利或者失败动画
    if self.IsWin then
        self:UnbindAllFromAnimationFinished(self.Victory_In)
        self:BindToAnimationFinished(self.Victory_In, {self, function()
            DebugPrint("yly Victory")
            self:InitSettlementBuff()
            self:PlayExtraRewardsAnim()
        end})
        self:PlayAnimation(self.Victory_In)
        -- AudioManager(self):PlayUISound(nil, "event:/ui/activity/drama_challenge_finish_fx", nil, nil)
    else
        DebugPrint("yly Defeated")
        self:PlayAnimation(self.Defeat_In)
        -- AudioManager(self):PlayUISound(nil, "event:/ui/activity/drama_challenge_unfinish_fx", nil, nil)
    end
end

-- 播放复刷关胜利额外奖励动画
function M:PlayExtraRewardsAnim()
    if (not self.IsStory) and (self.AddExtraResourceNum > 0) and (self.ResourceUpperLimit~=nil) then
        self.Text_Num_Coin:SetText(Utils.FormatNumber(0, false)) -- 初始值
        self:SetImage(self.AddExtraResourceId, self.Image_6)
        self.Panel_TransCoin:SetVisibility(UIConst.VisibilityOp["HitTestInvisible"])
        self:BindToAnimationFinished(self.TransCoin_In, {self, function()
            DebugPrint("yly TransCoin_In Animation Ended.")
            UIUtils.RollingNumberEffect(self, self.Text_Num_Coin, 0, self.AddExtraResourceNum)
        end})
        self:BindToAnimationFinished(self.TransCoin_Out, {self, function()
            DebugPrint("yly TransCoin_Out Animation Ended.")
            if self.AddExtraResourceNum >= self.ResourceUpperLimit then
                self.Max:SetVisibility(UIConst.VisibilityOp["HitTestInvisible"])
            else
                self.Max:SetVisibility(UIConst.VisibilityOp["Collapsed"])
            end
        end})
        self:PlayAnimation(self.TransCoin_In)
        self:AddTimer(1.0, function()
            self:PlayAnimation(self.TransCoin_Out)
        end)
    end
end

function M:Destruct()
    DebugPrint("yly test Destruct")
    if self:IsExistTimer("CountDown") then
        self:RemoveTimer("CountDown")
    end
end

-- function M:Tick(MyGeometry, InDeltaTime)
--     DebugPrint("yly test Tick")
-- end

--是否需要弹窗
function M:CheckNeedShowWindow()
    local IsNoMorePrompts = EMCache:Get("IsConfirmPopupNoMorePrompts", true) or false
    if TimeUtils and IsNoMorePrompts then
        local CachedTimestamp = EMCache:Get("IsConfirmPopupTimestamp", true)
        local intervalTime = TimeUtils.GetIntervalDay(CachedTimestamp, TimeUtils.NowTime())
        IsNoMorePrompts = intervalTime == 0
    end
    return not IsNoMorePrompts
end

function M:OnPlayAgain()
    DebugPrint("Btn_Continue is Clicked")
    if self.ownPoints and (self.ownPoints >= self.playAgainCosts) then
        if self:CheckNeedShowWindow() then
            -- 弹确认弹窗
            self:ShowPlayAgainConfirmPopup()
        else
            -- 直接下本
            self:PlayAgainSoloTreasure()
        end
    else
        if self.ScoreToResourceRatio ~= nil then
            -- 说明是铜币关，toast提示门票不足
            UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_SoloTreausre_Toast_LackofTicket"))
        else
            -- toast提示积分不足
            UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_Extraction_TM_31"))
        end
    end
end

function M:ExitSoloTreasure()
    self:BlockAllUIInput(true)
    local Avatar = GWorld:GetAvatar()
    Avatar:ExitDungeonSettlement()
    EventManager:AddEvent(EventID.OnExitDungeon, self, self.DefaultExit)
    -- 如果是复刷关，退出之后自动回到选关界面并选中对应关卡
    if self.IsStory == false then
        self.ExitDungeonData = {
            Type = "SoloTreasure",
            EventId = nil,
            Mode = 1,
            EventDungeonId = self.EventId
        }
        GWorld.GameInstance:SetExitDungeonData(self.ExitDungeonData)
    end
end

function M:DefaultExit()
    EventManager:RemoveEvent(EventID.OnExitDungeon, self)
    self:BlockAllUIInput(false)
    self:CloseSelf()
end

-- 关闭UI
function M:CloseSelf()
    DebugPrint("yly     CloseSelf")
    if self:IsAnimationPlaying(self.Out) then
        return
    end
    self:PlayAnimation(self.Out)
    self:SetAllUIVisibility(false)
end

function M:OnOutAnimationFinished()
    self:Close()
end

function M:InitBag()
    local ControllerInitParams = {
        MainWidget = self,
        -- BagId = self.BagId,
    }
    -- self.InventoryController = InventoryController
    InventoryController:Init(ControllerInitParams)
    InventoryController:OnMainWidgetLoaded(ControllerInitParams)
end

function M:InitUIContent()
    self.Text_AllValue:SetText(GText('UI_Extraction_TotalScore'))
    self:SetImage(DataMgr.GlobalConstant["SoloTreasureCurrent"].ConstantValue, self.Image_86)
    self.Text_AllValue_1:SetText(GText('UI_Extraction_TM_30'))
    self.Text_AllCoin:SetText(GText('UI_SoloTreasure_ExtraReward'))
    -- <上限>角标
    self.Max.Text_Max:SetText(GText('UI_SoloTreasure_MaxExtraReward'))
    -- 积分数
    self.Text_Score01:SetText(GText('UI_Extraction_BattleScore'))
    self.Text_Score01_1:SetText(GText('UI_Extraction_TreasureScore'))
    self.Text_Num:SetText(Utils.FormatNumber(self.KillMonsterScore + self.TreasureScore, false))
    self.Text_Score01_Num:SetText(Utils.FormatNumber(self.KillMonsterScore, false))
    self.Text_Score01_Num_1:SetText(Utils.FormatNumber(self.TreasureScore, false))
    --《再次进行》按钮文本
    self.Btn_Continue:SetText(string.format(GText("Abyss_Battle_Again")))
    --《再次进行》按钮绑定
    self.Btn_Continue:SetDefaultGamePadImg("X")
    self.Btn_Continue.Button_Area.OnClicked:Add(self, self.OnPlayAgain)
    --《退出关卡》按钮文本
    self.Btn_Exit:SetText(string.format(GText("UI_Extraction_TM_47")))
    --《退出关卡》按钮绑定
    self.Btn_Exit:SetDefaultGamePadImg("B")
    self.Btn_Exit.Button_Area.OnClicked:Add(self, self.ExitSoloTreasure)
    -- 撤离Text
    self.Text_Title_Success:SetText(GText("UI_Extraction_TM_25"))
    self.Text_Title_Fail:SetText(GText("UI_Extraction_TM_26"))
    if self.IsWin then
        self.Text_Title_Success:SetVisibility(UIConst.VisibilityOp["Visible"])
        self.Text_Title_Fail:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    else
        self.Text_Title_Success:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        self.Text_Title_Fail:SetVisibility(UIConst.VisibilityOp["Visible"])
    end

    -- 初始化撤离的关卡名称和难度
    self:InitDungeonInfo()

    -- PlayAgainCost初始化
    self:InitPlayAgainCost()

    -- 初始化背包UI
    self:InitBagContent()

    -- 初始化撤离用时 
    self:InitEvacuationTime()

    -- 先隐藏彩票栏（等界面打开动画结束再显示）
    self:HideSettlementBuff()
end

function M:InitDungeonInfo()
    if self.DungeonId == nil then
        return
    end
    local dungeonInfo = DataMgr.Dungeon[self.DungeonId]
    local difficultyInfo = DataMgr.SoloTreasure[self.DungeonId].DifficultyDesc
    self.Text_Title02:SetText(GText(dungeonInfo.DungeonTypeShow) .. "-" .. GText(difficultyInfo))
end

function M:InitEvacuationTime()
    local seconds = math.max(0, math.floor(self.EvacuationTime))

    local min = math.floor(seconds / 60)
    local sec = seconds % 60

    self.Text_Time:SetText(string.format("%02d:%02d", min, sec))
end

function M:InitPlayAgainCost()
    -- 获取玩家持有的积分数量(或铜币数量)
    local Avatar = GWorld:GetAvatar()
    self.ownPoints = 0
    if Avatar and self.playAgainCostsIconId then
        self.ownPoints = Avatar:GetResourceNum(self.playAgainCostsIconId)
    end
    
    self.Panel_Cost:SetVisibility(UIConst.VisibilityOp["Visible"])
    
    local Params = {
        ResourceId = self.playAgainCostsIconId,
        bShowDenominator = true,
        Numerator = self.ownPoints,         -- 背包里的物品数
        Denominator = self.playAgainCosts,  -- 再玩需要消耗的物品数
        Owner = self,
        ItemMenuAnchorChangedCallback = self.OnCostTipsStateChanged
        -- KeyIconName = "RS",
        -- UIName = "ImpressionMainUI",
    }
    self.Cost:InitContent(Params)
    self.Cost.Common_Item_Icon.HandleKeyDown = true  -- Cost里传的ResourceId不为nil时，HandleKeyDown会被设成false，导致打开的tips不能聚焦，这里做特殊处理

    if self.ownPoints >= self.playAgainCosts then
        self.Btn_Continue:SetRenderOpacity(1.0)
    else
        self.Btn_Continue:SetRenderOpacity(0.5)
    end
end

function M:InitBagContent()
    if self.IsWin then
        self.HorizontalBox_1:SetVisibility(UIConst.VisibilityOp["Visible"])
        self.Switch_BagType:SetVisibility(UIConst.VisibilityOp["HitTestInvisible"]) -- 屏蔽交互
        self.WBP_Com_EmptyBg:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    else
        self.HorizontalBox_1:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        self.Switch_BagType:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        self.WBP_Com_EmptyBg.Text_Empty:SetText(GText('UI_Extraction_TM_48')) -- 无收获
        self.WBP_Com_EmptyBg:SetVisibility(UIConst.VisibilityOp["Visible"])
    end
end

function M:HideSettlementBuff()
    self.WrapBox_0:SetVisibility(UIConst.VisibilityOp["Collapsed"])
end

function M:InitSettlementBuff()
    if self.IsWin and self.TicketId ~= -1 then
        -- 彩票装填
        local ticketInfo = DataMgr.ExtractionLottery[self.TicketId]
        local highQualityBuffItem = self.WrapBox_0:GetChildAt(2)
        local midQualityBuffItem = self.WrapBox_0:GetChildAt(1)
        local lowQualityBuffItem = self.WrapBox_0:GetChildAt(0)
        if ticketInfo.Quality == 1 then
            highQualityBuffItem:SetVisibility(UIConst.VisibilityOp["Collapsed"])
            midQualityBuffItem:SetVisibility(UIConst.VisibilityOp["Collapsed"])
            lowQualityBuffItem:SetVisibility(UIConst.VisibilityOp["Visible"])
            lowQualityBuffItem:InitData({Description = ticketInfo.Desc})
        elseif ticketInfo.Quality == 2 then
            highQualityBuffItem:SetVisibility(UIConst.VisibilityOp["Collapsed"])
            midQualityBuffItem:SetVisibility(UIConst.VisibilityOp["Visible"])
            midQualityBuffItem:InitData({Description = ticketInfo.Desc})
            lowQualityBuffItem:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        elseif ticketInfo.Quality == 3 then
            highQualityBuffItem:SetVisibility(UIConst.VisibilityOp["Visible"])
            highQualityBuffItem:InitData({Description = ticketInfo.Desc})
            midQualityBuffItem:SetVisibility(UIConst.VisibilityOp["Collapsed"])
            lowQualityBuffItem:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        else
            DebugPrint("yly     Ticket's Quality not Exists!")
        end
        self.WrapBox_0:SetVisibility(UIConst.VisibilityOp["Visible"])
        if ticketInfo.Quality == 1 then
            lowQualityBuffItem:PlayAnimation(lowQualityBuffItem.In)
        elseif ticketInfo.Quality == 2 then
            midQualityBuffItem:PlayAnimation(midQualityBuffItem.In)
        elseif ticketInfo.Quality == 3 then
            highQualityBuffItem:PlayAnimation(highQualityBuffItem.In)
        end
    else
        self.WrapBox_0:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end
end

-- 退出倒计时初始化
function M:InitExitCountDown()
    self.exitTimeleft = DataMgr.GlobalConstant.SoloTreasureEvacuationExitTime.ConstantValue
    self.Text_ExitTime:SetText(string.format(GText("UI_Text_ExitTime"), self.exitTimeleft))
    self.timer = self:AddTimer(1, self.UpdateCountDownUI, true, 0, "CountDown", false)
end

function M:UpdateCountDownUI()
    if self.exitTimeleft > 0 then
        self.exitTimeleft = self.exitTimeleft - 1
    else
        self.exitTimeleft = 0
        if self:IsExistTimer("CountDown") then
            self:RemoveTimer("CountDown")
        end
        self:ExitSoloTreasure()
    end
    self.Text_ExitTime:SetText(string.format(GText("UI_Text_ExitTime"), self.exitTimeleft))
end

function M:ShowPlayAgainConfirmPopup()
    local CommonDialogParams = {}
    CommonDialogParams.RightCallbackFunction = function(_, Data, PopupUI)
        -- 下本，再次挑战
        DebugPrint("yly     PlayAgain")
        PopupUI.DontPlayOutAnimation = true
        self:PlayAgainSoloTreasure()
        self:UpdateSelectedInfo(Data)
    end
    CommonDialogParams.LeftCallbackFunction = function(_, Data, PopupUI)
        PopupUI.DontPlayOutAnimation = false
        self:UpdateSelectedInfo(Data)
    end
    UIManager(self):ShowCommonPopupUI(100317, CommonDialogParams, self.Parent)
end

function M:PlayAgainSoloTreasure()
    DebugPrint("yly      PlayAgainSoloTreasure")
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local CustomParams = {
        EventDungeonId = self.EventId,
        BagId = self.BagId,
        IsStory = self.IsStory,
        IsEasy = self.IsEasy
    }
    Avatar:EnterDungeonAgain(nil, nil, CustomParams)
end

function M:UpdateSelectedInfo(Data)
    local IsSelected = Data.SelectHint.IsSelected
    local CurTimestamp = TimeUtils.NowTime()

    EMCache:Set("IsConfirmPopupNoMorePrompts", IsSelected, true)
    EMCache:Set("IsConfirmPopupTimestamp", CurTimestamp, true)
end

local _RealSetIcon = function(self,Texture,Img)
    if(Texture)then
        Img:SetBrushResourceObject(Texture)
    end
end

function M:SetImage(resourceId, Img) 
    local resource = DataMgr.Resource[resourceId]
    local IconObj = LoadObject(resource.Icon)
    if(type(IconObj) == "string")then
        self:LoadTextureAsync(IconObj,function(Texture)
            if not Texture then
                Texture = LoadObject("Texture2D'/Game/UI/Texture/Dynamic/Image/Head/Monster/T_Head_Empty.T_Head_Empty'")
                DebugPrint(ErrorTag,string.format("用错图标路径了！！！这里用默认的图标顶一下\n 错误的路径是：%s",IconObj))
            end
            _RealSetIcon(self,Texture,Img)
        end,"LoadIcon")
    else
        _RealSetIcon(self,IconObj,Img)
    end
end

function M:LoadTextureAsync(TexturePath, cb, TaskName)
    rawset(self, "LoadResourceID", nil)
    local Handle = UE.UResourceLibrary.LoadObjectAsyncWithId(self, TexturePath, {self, function (self, Texture, ResourceID)
            if not IsValid(self) or (ResourceID ~= nil and rawget(self, "LoadResourceID") ~= ResourceID) then
                return
            end
            cb(Texture)
        end})
    if Handle then
        rawset(self, "LoadResourceID", Handle.ResourceID)
    end
end

function M:SetAllUIVisibility(IsHide)
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManger = GameInstance:GetGameUIManager()
    if UIManger then
        UIManger:HideAllUI_EX({self:GetName(), "DungeonMatchTimingBar"}, IsHide, self.HideUITag, false)
    end
    local BattleWarningUI = UIManger:GetUIObj(UIConst.DestroyAlarmName)
    if BattleWarningUI then
        AudioManager(self):StopSound(BattleWarningUI, "BattleWarning")
    end
end

--------------------------------------------------------------- 手柄相关---------------------------------------------------------------
function M:InitDeviceInfo()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(self.GameInputModeSubsystem)) then
        self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end
end

function M:InitListenEvent()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self,self.RefreshOpInfoByInputDevice)
    end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    DebugPrint("yly     CurGamepadName", CurGamepadName)
    DebugPrint("yly     CurInputDevice", CurInputDevice)

    if (self.CurInputDeviceType == CurInputDevice) then
        -- 已经显示的是该输入模式，不需要进行刷新
        DebugPrint("thy    已经显示的是该输入模式，不需要进行刷新")
        return
    end

    --更新输入模式
    self.CurInputDeviceType = CurInputDevice
    self.CurGamepadName = CurGamepadName

    --更新UI
    self:UpdateBtnUI()
end

function M:UpdateBtnUI()
    self:UpdateScrollViewTip()

    if not self.IsNotFirstUpdateMainUI then
        self.IsNotFirstUpdateMainUI = true
        return
    end
    if not self.CurInputDeviceType then
        self.CurInputDeviceType = UIUtils.UtilsGetCurrentInputType()
    end
    -- body
    if self.CurInputDeviceType == ECommonInputType.Touch then
        DebugPrint("yly    IsMoblie")
        return
    end
    if not self:HasFocusedDescendants() and not self:HasAnyUserFocus() then
        DebugPrint("yly@ 已聚焦至上级界面 不聚焦到结算界面")
        local CommonDialog = UIManager(self):GetUI("CommonDialog")
        if CommonDialog then
            DebugPrint("yly@ 已聚焦至弹窗 不聚焦到结算界面")
            return
        end
    end
    --先聚焦到界面上，以免在切换设备时后续丢失聚焦
    self:SetFocus()
end

function M:UpdateScrollViewTip()
    if self.Key_Check == nil then
        return
    end
    if self.CurInputDeviceType == ECommonInputType.MouseAndKeyboard or self.CurInputDeviceType == ECommonInputType.Touch then
        self.Key_Check:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    else
        self.Key_Check:CreateCommonKey({
            KeyInfoList = {
                {
                    Type = "Img",
                    ImgShortPath = UIConst.GamePadImgKey.RightTriggerAnalog,
                }
            },
            Desc = GText("UI_Controller_Slide")
        })
        local bCanScroll = UIUtils.CheckScrollBoxCanScroll(self.EMScrollBox_62)
        if bCanScroll then
            self.Key_Check:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        else
            self.Key_Check:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        end
    end
end

function M:Handle_OnGamePadDown(InKeyName)
    if (InKeyName == "Gamepad_FaceButton_Left") then -- 《再次进行》按钮绑 手柄按键 X
        if self.Btn_Continue:IsVisible() then
            self.Btn_Continue:OnBtnClicked()
            self:OnPlayAgain()
        end
        return true
    elseif (InKeyName == "Gamepad_FaceButton_Right") then -- 《退出关卡》按钮绑 手柄按键 B
        if self.Btn_Exit:IsVisible() then
            self.Btn_Exit:OnBtnClicked()
            self:ExitSoloTreasure()
        end
        return true
    elseif (InKeyName == "Gamepad_LeftThumbstick") then  -- 打开Cost的tips绑 手柄左摇杆按钮
        if self.Cost:IsVisible() then
            self.Cost:SetFocus()
            -- self:TempUpdateGamePadUI(true)
        end
    end
    return false
end

function M:Handle_OnPCDown(InKeyName)
    if (InKeyName == "Escape") then -- 防止呼出esc菜单
        return true
    end
    return false
end

--监听PC/手柄按键
function M:OnKeyDown(MyGeometry, InKeyEvent)
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        DebugPrint("yly    Key_IsGamepadKey", InKeyName)
        IsEventHandled = self:Handle_OnGamePadDown(InKeyName)
    else
        DebugPrint("yly    Key_IsPC", InKeyName)
        IsEventHandled = self:Handle_OnPCDown(InKeyName) 
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()    
    end
end

-- 监听手柄右摇杆滑动
function M:OnAnalogValueChanged(MyGeometry,InAnalogInputEvent)
    if not self.EMScrollBox_62 then
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
    local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local AddOffset = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 5
    if InKeyName == "Gamepad_RightY" then
        local CurScrollOffset = self.EMScrollBox_62:GetScrollOffset()
        local ScrollOffset = math.clamp(CurScrollOffset - AddOffset,0, self.EMScrollBox_62:GetScrollOffsetOfEnd())
        self.EMScrollBox_62:SetScrollOffset(ScrollOffset)
    end
    return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:TempUpdateGamePadUI(bTipsOpen)
    if bTipsOpen then
        --再次进行按钮图标更新
        self.Btn_Continue:SetGamePadVisibility(UIConst.VisibilityOp["Collapsed"])
        self.Btn_Continue:SetIconPanelVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        --退出关卡按钮图标更新
        self.Btn_Exit:SetGamePadVisibility(UIConst.VisibilityOp["Collapsed"])
        self.Btn_Exit:SetIconPanelVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    else
        --再次进行按钮图标更新
        self.Btn_Continue:SetGamePadVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        self.Btn_Continue:SetIconPanelVisibility(UIConst.VisibilityOp["Collapsed"])
        --退出关卡按钮图标更新
        self.Btn_Exit:SetGamePadVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        self.Btn_Exit:SetIconPanelVisibility(UIConst.VisibilityOp["Collapsed"])
    end
end

function M:OnCostTipsStateChanged(IsOpen)
    DebugPrint("yly WBP_Solotreasure_evacuation OnCostTipsStateChanged IsOpen = ", IsOpen)
    if IsOpen then
        if self.CurInputDeviceType == ECommonInputType.Gamepad then
            self:TempUpdateGamePadUI(true)
        end
        -- local CommonDialog = UIManager(self):GetUI("CommonDialog")
        -- if CommonDialog then
        --     DebugPrint("yly WBP_Solotreasure_evacuation OnCostTipsStateChanged GetCommonDialog Success")
        --     -- if CommonDialog.CloseBtnCallbackFunction then
        --     --     local Data = CommonDialog:PackageResult()
        --     --     CommonDialog.CloseBtnCallbackFunction(CommonDialog.CloseBtnCallbackObj,Data)
        --     -- end
        --     -- CommonDialog:Close()
        -- end
    else
        if self.CurInputDeviceType == ECommonInputType.Gamepad then
            self:TempUpdateGamePadUI(false)
        end
        self:SetFocus()
    end
end

return M