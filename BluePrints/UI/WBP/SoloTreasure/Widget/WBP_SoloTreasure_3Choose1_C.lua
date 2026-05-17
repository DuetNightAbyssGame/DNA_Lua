--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_SoloTreasure_Choice_P_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.BtnCD = 0.5 -- 发送rpc操作的内置CD
    self.Choices = {
        self.Choice_1,
        self.Choice_2,
        self.Choice_3
    }
    self.KillScoreIcon = "Texture2D'/Game/UI/Texture/Dynamic/Image/Prop/Activity/SoloTreasure/T_Activity_SoloTreasure_26.T_Activity_SoloTreasure_26'"
end


function M:InitUIInfo(Name, IsInUIMode, EventList, ...)
    self.Super.InitUIInfo(self, Name, IsInUIMode, EventList, ...)
    self:GetMechanismInfo()
    self:InitResourceBar()
    self:InitChoices()
    self:InitButtons()
    self:InitText()
    self:PlayInAnimation()
    self:AddDispatcher(EventID.OnSoloTreasureRefreshTickets, self, self.OnRefreshTickets)
    self:AddDispatcher(EventID.OnUpdateGameScore, self, self.OnUpdateGameScore)
    self:AddDispatcher(EventID.OnSoloTreasureGetTicket, self, self.OnGetTicket)
    self:AddDispatcher(EventID.OnPlayShowDamageEffect, self, self.PlayHitAnim)
    EventManager:FireEvent(EventID.ShowCountDownTips)
    ------------------ 手柄端 -----------------------
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        self:InitGamepadView()
    elseif UIUtils.UtilsGetCurrentInputType() == ECommonInputType.MouseAndKeyboard then
        self:InitKeyboardView()
    end
end

function M:GetMechanismInfo()
    local ServerEntity = GWorld:GetServerEntity()
    if not ServerEntity then
        return
    end
    self.DungeonObject = ServerEntity:GetDungeonObject()
    self.ActivatedTicketId = self.DungeonObject.SoloTreasureTicketId
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(GWorld.GameInstance, 0)
    if not PlayerController then
        DebugPrint("@zyh 彩票三选一界面拿不到PlayerController")
    end
    
    local Player = PlayerController:GetMyPawn()
    local Eid = Player.MechanismEid
    self.Mechanism = Battle(self):GetEntity(Eid)
    if not self.Mechanism then
        DebugPrint("@zyh 彩票三选一界面拿不到彩票Mechanism")
    end
    self.IsFirstOpen = not self.Mechanism.MechanismInfo.IsUnlock
    self.Uid = self.Mechanism.MechanismInfo.UniqueId
    self.MechanismId = self.Mechanism.MechanismInfo.UnitId
end

function M:InitText()
    self.Text_Choose:SetText(GText("UI_Extraction_ChooseLottery"))
end

-- 初始化资源栏
function M:InitResourceBar()
    self.Score:InitWidgetUI(true)
end

-- 初始化三个选项
function M:InitChoices()
    for Index, Choice in ipairs(self.Choices) do
        local ChoiceInfo = {
            Parent = self,
            LotteryId = self.Mechanism.MechanismInfo.TicketInfo.TicketList[Index],
            Owned = self.ActivatedTicketId == self.Mechanism.MechanismInfo.TicketInfo.TicketList[Index],
        }
        Choice:InitInfo(ChoiceInfo)
    end
end

function M:InitButtons()
    if self.Key_Esc then
        self.Key_Esc:CreateCommonKey({
            KeyInfoList = {{
                               Type = "Text",
                               Text = "Esc",
                               ClickCallback = self.Close,
                               Owner = self,
                           }},
            Desc = GText("UI_Extraction_ChooseNothing"),
        })
    end
    if self.Controller_Esc then
        self.Controller_Esc:CreateCommonKey({
            KeyInfoList = {{
                               Type = "Img",
                               ImgShortPath = "B",
                           }},
            Desc = GText("UI_Extraction_ChooseNothing"),
        })
    end
    if self.Btn_Esc then
        self.Btn_Esc.Btn_Click.OnClicked:Add(self, self.Close)
        self.Text_Esc:SetText(GText("UI_Extraction_ChooseNothing"))
    end
    self:InitConfirmBtn()
    self:InitRefreshBtn()
end

function M:InitConfirmBtn()
    self.Btn_Confirm.Key_GamePad:CreateCommonKey({KeyInfoList = {{Type = "Img", ImgShortPath = "A"}}})
    self.Btn_Confirm:InitButton({Text = GText("UI_Extraction_ConfirmSelection")})
    self.Btn_Confirm.Btn_Area.OnClicked:Add(self, self.OnConfirmBtnClicked)
    self.Btn_Confirm:SetForbid(true)
end

function M:OnConfirmBtnClicked()
    if not self.CurSelectId then
        UIManager(GWorld.GameInstance):ShowUITip("CommonToastMain", GText("UI_Extraction_TM_19"))
    elseif self.ActivatedTicketId and self.ActivatedTicketId == self.CurSelectId then
        UIManager(GWorld.GameInstance):ShowUITip("CommonToastMain", GText("UI_Extraction_TM_45"))
    end
    if self.Btn_Confirm.IsForbid then
        return
    end
    -- 发rpc记得加CD
    self.CurrentTime = UE4.UGameplayStatics.GetRealTimeSeconds(self)
    if self.ConfirmStartTime and (self.CurrentTime - self.ConfirmStartTime < self.BtnCD) then
        return
    end
    self.ConfirmStartTime = UE4.UGameplayStatics.GetRealTimeSeconds(self)
    DebugPrint("@zyh 确认按钮按下")
    if not self.ActivatedTicketId then
        self:SendTicketSelectRPC()
    else
        local Params = {
            OldBuffId = self.ActivatedTicketId,
            NewBuffId = self.CurSelectId,
            Parent = self,
        }
        UIManager(self):LoadUINew("SoloTreasureReplaceBuff", Params)
    end
end

function M:SendTicketSelectRPC()
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if not GameMode then return end
    if not self.CurSelectId then return end
    GameMode:NotifyServerDungeonEvent("SoloTreasureTicketSelect", self.Uid, self.CurSelectId)
end

function M:InitRefreshBtn()
    self.Btn_Refresh.Key_GamePad:CreateCommonKey({KeyInfoList = {{Type = "Img", ImgShortPath = "X"}}})
    self.Btn_Refresh:InitButton({Text = GText("UI_Extraction_Refresh")})
    self.Btn_Refresh.Btn_Area.OnClicked:Add(self, self.OnRefreshBtnClicked)
    self.CurrentScore = self.DungeonObject.KillMonsterScore or 0
    DebugPrint("@zyh 当前的杀怪积分为", self.CurrentScore)
    self.RenewalTimes = self.Mechanism.MechanismInfo.TicketInfo.RenewalTimes + 1
    self.RenewalPoint = DataMgr.ExtractionTreasureTicket[self.MechanismId].RenewalPoint
    self.RefreshCost = self.RenewalPoint[math.min(self.RenewalTimes, #self.RenewalPoint)]
    self.Com_Cost:InitContent({
        Icon = self.KillScoreIcon,
        bShowDenominator = false,
        Numerator = self.RefreshCost,
        HandleMouseDown = false,
        NotInteractive = true,
    })
    self.Com_Cost:SetIsEnough(self.RefreshCost <= self.CurrentScore)
    self.Com_Cost.Key:SetVisibility(ESlateVisibility.Collapsed)
    self.Btn_Refresh:SetForbid(self.RefreshCost > self.CurrentScore)
end

function M:OnRefreshTickets(TicketList)
    self.RenewalTimes = self.RenewalTimes + 1
    self.RefreshCost = self.RenewalPoint[math.min(self.RenewalTimes, #self.RenewalPoint)]
    self.Com_Cost:InitContent({
        Icon = self.KillScoreIcon,
        bShowDenominator = false,
        Numerator = self.RefreshCost,
        HandleMouseDown = false,
        NotInteractive = true,
    })
    self.Com_Cost:SetIsEnough(self.RefreshCost <= self.CurrentScore)
    self.Btn_Refresh:SetForbid(self.RefreshCost > self.CurrentScore)

    self.CurSelectId = nil
    self.CurSelectItem = nil
    self.Btn_Confirm:SetForbid(true)
    
    for Index, Choice in ipairs(self.Choices) do
        local ChoiceInfo = {
            Parent = self,
            LotteryId = TicketList[Index],
            Owned = TicketList[Index] == self.ActivatedTicketId,
        }
        Choice:InitInfo(ChoiceInfo)
        if Choice.IsSelected then
            Choice:PlayAnimation(Choice.Select_Out)
        end
        Choice.IsSelected = false
        Choice:PlayAnimation(Choice.First_In)
    end
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        self:AddDelayFrameFunc(function()
            self.Choice_1:SetFocus()
        end, 2)
    end
end

function M:OnRefreshBtnClicked()
    if self.Btn_Refresh.IsForbid then
        UIManager(GWorld.GameInstance):ShowUITip("CommonToastMain", GText("UI_Extraction_TM_8"))
        return
    end
    -- 发rpc记得加CD
    self.CurrentTime = UE4.UGameplayStatics.GetRealTimeSeconds(self)
    if self.RefreshStartTime and (self.CurrentTime - self.RefreshStartTime < self.BtnCD) then
        return
    end
    self.RefreshStartTime = UE4.UGameplayStatics.GetRealTimeSeconds(self)
    DebugPrint("@zyh 刷新按钮按下")
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if not GameMode then return end
    
    GameMode:NotifyServerDungeonEvent("SoloTreasureRandomTicket", self.Uid)
end

function M:OnLoaded(...)
    self.Super.OnLoaded(...)
    
end

function M:PlayInAnimation()
    if self.IsFirstOpen then
        self:PlayAnimation(self.First_In)
    else
        self:PlayAnimation(self.In)
    end
end

function M:SelectItem(Item)
    if not Item then
        self.CurSelectItem = nil
        self.Btn_Confirm:SetForbid(true)
        return
    end
    self.CurSelectItem = Item
    self.CurSelectId= Item.LotteryId
    self:UnSelectOther(Item)
    if self.ActivatedTicketId and self.ActivatedTicketId == self.CurSelectId then
        self.Btn_Confirm:SetForbid(true)
    else
        self.Btn_Confirm:SetForbid(false)
    end
end

function M:UnSelectOther(Item)
    for _, Choice in ipairs(self.Choices) do
        if Choice ~= Item and Choice.IsSelected then
            Choice:UnSelect()
        end
    end
end

function M:OnUpdateGameScore(Score)
    self.CurrentScore = self.DungeonObject.KillMonsterScore or 0
    self.Com_Cost:SetIsEnough(self.RefreshCost <= self.CurrentScore)
    self.Btn_Refresh:SetForbid(self.RefreshCost > self.CurrentScore)
end

function M:OnGetTicket(TicketId)
    if UIManager(self):GetUIObj("SoloTreasureReplaceBuff") then
        return
    end
    self:CloseAndPlayToast(TicketId)
end

function M:CloseAndPlayToast(TicketId)
    self.Mechanism:AddTimer(0.2, function()
        UIManager(self.Mechanism):LoadUINew("SoloTreasureBuffToast", TicketId)
    end)
    self:Close()
end

function M:PlayHitAnim()
    if not self:IsAnimationPlaying(self.Hit) then
        self:PlayAnimation(self.Hit)
    end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if InKeyName == "Escape" or InKeyName == Const.GamepadFaceButtonRight then
        self:Close()
    elseif InKeyName == Const.GamepadFaceButtonDown then
        self:OnConfirmBtnClicked()
    elseif InKeyName == Const.GamepadFaceButtonLeft then
        self:OnRefreshBtnClicked()
    end
    return UE4.UWidgetBlueprintLibrary.Handled()
end

--------------------手柄端部分--------------------------
function M:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
    self.Super.OnUpdateUIStyleByInputTypeChange(self, CurInputType, CurGamepadName)
    if CurInputType == ECommonInputType.Gamepad then
        self:InitGamepadView()
    else
        self:InitKeyboardView()
    end
    
end

function M:InitGamepadView()
    --self.Btn_Confirm.Key_GamePad:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    --self.Btn_Refresh.Key_GamePad:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    if self.CurSelectItem then
        self.CurSelectItem:SetFocus()
    else
        self.Choice_1:SetFocus()
    end
    if self.WS_Key then
        self.WS_Key:SetActiveWidgetIndex(1)
    end
end

function M:InitKeyboardView()
    self:SetFocus()
    --self.Btn_Confirm.Key_GamePad:SetVisibility(ESlateVisibility.Collapsed)
    --self.Btn_Refresh.Key_GamePad:SetVisibility(ESlateVisibility.Collapsed)
    if self.WS_Key then
        self.WS_Key:SetActiveWidgetIndex(0)
    end
end
    
function M:RegainFocus()
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        if self.CurSelectItem then
            self.CurSelectItem:SetFocus()
        else
            self.Choice_1:SetFocus()
        end
    else
        self:SetFocus()
    end
end

function M:Close()
    self.Super.Close(self)
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(GWorld.GameInstance, 0)
    if PlayerController then
        local Player = PlayerController:GetMyPawn()
        local Eid = Player.MechanismEid
        local Mechanism = Battle(self):GetEntity(Eid)
        if Mechanism then
            Mechanism:EndInteractive(Player, true)
        end
    end
end

return M
