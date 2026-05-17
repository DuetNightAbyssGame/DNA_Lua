--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"
require "Utils"
local UIUtils = require "Utils.UIUtils"

local WBP_NpcSwitchMain_PC_C = Class({"BluePrints.UI.BP_UIState_C"})

WBP_NpcSwitchMain_PC_C._components = {
    "BluePrints.UI.UIComponent.CoroutineComponent",
    "BluePrints.UI.UI_PC.Common.LSFocusComp",
}

function WBP_NpcSwitchMain_PC_C:Initialize(Initializer)
    self.Super.Initialize(self)
    self.SignBoardNpcState ={}          -- 记录看板娘摆放状态
    self.SignBoardNums = 0              -- 看板数量
    self.FullListNpcNums = 20
    self.SelectedUnitId = CommonConst.UnsetState  -- 当前选中的NpcId
    self.NpcIndexWithUnitId = {}        -- Npc的UnitId对应下标
    self.AnimTime = 0.033
    self.DisplayName = {"ShowNpc"..string.sub(DataMgr.TextMap.UI_SHOWNPC_NAME_SCENE1.TextMapId,-7),
                        "ShowNpc"..string.sub(DataMgr.TextMap.UI_SHOWNPC_NAME_SCENE2.TextMapId,-7),
                        "ShowNpc"..string.sub(DataMgr.TextMap.UI_SHOWNPC_NAME_SCENE3.TextMapId,-7),}
    self.CameraInfo = {}                -- 摄像机位置旋转信息
    self.Camera = nil
    self.OwnedChar = {}                 -- 当前账号所拥有的角色
    self.SortByReserveOrder = true      -- 默认倒序
    self.FilterInitParams = {}          -- 排序选择初始大小以及位置
    self.CurSortType = {}               -- 当前选择的排序类型
    self.OpenUI = nil                   -- 当前打开的UI,Main or
    self.MontageTime = 0.01             -- Npc预览动作播放的时间
    self.PreviewNpcLoadComplete = true        -- 预览Npc加载完成
    self.CurNpcContent = nil
    self.ErrorContent = nil
    self.CancelCurrentNpc = false
    self.DelegateIsBind = false
end

function WBP_NpcSwitchMain_PC_C:OnLoaded(...)
    self.Super.OnLoaded(self, ...)
    self:Reset()
    self:InitStaticCreator()
    self:InitNowTabId()
    self:InitNpcInfo()
    self:InitSpecialEffectActor()
    --self:InitCameraTab()
    self:InitNpcTab(false)
    self:PlayInAnim()
    -- self:InitSortItem()
    self:AddTimer(0.033, function()
        self:EnableNpcDitherAlpha(false)
    end)
    self:OnOpenMain(false)
    self:AddDispatcher(EventID.UpdateSignBoardNpc,self, self.UpdateSignBoardNpc)
    -- self:AddLSFocusTarget(nil, self.Panel_Selected.WBP_Com_FilterSort, nil, true)
end

function WBP_NpcSwitchMain_PC_C:InitUIInfo(Name, IsInUIMode, EventList, ...)
    self.Super.InitUIInfo(self, Name, IsInUIMode, EventList, ...)
    AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "NpcSwitchMain", nil)
end

function WBP_NpcSwitchMain_PC_C:Reset()
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self,0)
    self.PlayerCurrentTag = Player:GetCharacterTag()
    Player:SetActorHideTag("Npc", true)
    -- Player:SetCharacterTag('Idle')
    -- Player:SetCharacterTag('Interactive')
    Player:SetCanInteractiveTrigger(false)
    --Player:SetBrushStaticMeshScalarParameter(0.0)  --控制场景内模型刷光
    self.Platform = CommonUtils.GetDeviceTypeByPlatformName(self)  --移动端还是PC端
    self.CommonTabInfo = {}   --Tab信息
    for key,TabInfo in pairs(DataMgr.ShowNpcTab) do
        self.CommonTabInfo[key] = {
            Text = GText(TabInfo.TabName),
            IconPath = TabInfo.IconPathPhone,
            TabId = TabInfo.TabId,
            NpcId = nil,
        }
    end
    local Avatar = GWorld:GetAvatar()
    if(Avatar == nil)then
        self.SignBoardNpcState = {CommonConst.UnsetState,CommonConst.UnsetState,CommonConst.UnsetState}
        self.SignBoardNums = #self.SignBoardNpcState
    else
        self.SignBoardNums = Avatar.SignBoardNpc:Length()
        for i=1,self.SignBoardNums do
            self.SignBoardNpcState[i] = Avatar.SignBoardNpc[i]
            if Avatar.SignBoardNpc[i] ~= CommonConst.UnsetState then
                self.CommonTabInfo[i].NpcId = Avatar.SignBoardNpc[i]
            else
                self.CommonTabInfo[i].NpcId = nil
            end
        end
    end
    self.SelectedUnitId = self.SignBoardNpcState[self.NowTabId]
    local CharInfo = Avatar.Chars
    for key,value in pairs(CharInfo) do
        self.OwnedChar[value.CharId] = true
    end
    self.Img_ForClick:SetRenderOpacity(0.0)
    self.Btn_ChangeNpc:SetText(GText("UI_SHOWNPC_NAME_SYSTEM"))
    self.Switch_Icon:SetActiveWidgetIndex(0)
    self.Btn_ChangeNpc:BindEventOnClicked(self,self.OnBtnChangeNpcClicked)
    self.Btn_ChangeNpc:SetDefaultGamePadImg("Y")
    self.Panel_Selected:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.PressedBtn = {}
    -- self.Panel_Selected.List_Character.BP_OnItemClicked:Add(self, self.OnNpcListItemClicked)
end

function WBP_NpcSwitchMain_PC_C:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false
    if (UE4.UKismetStringLibrary.StartsWith(InKeyName, "GamePad")) then
        IsEventHandled = self:OnGamePadDown(InKeyName, MyGeometry, InKeyEvent)
    elseif (InKeyName == "Escape") then
        self:CloseNpcSwitchMain()
    elseif InKeyName == "Q" then
        if self.OpenUI == "Main" then
            self.Common_Tab_PC:TabToLeft()
        end
    elseif InKeyName == "E" then
        if self.OpenUI == "Main" then
            self.Common_Tab_PC:TabToRight()
        end
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
end

function WBP_NpcSwitchMain_PC_C:OnKeyUp(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        IsEventHandled = self:OnGamePadUp(InKeyName, MyGeometry, InKeyEvent)
    end
    if (IsEventHandled) then
        return UIUtils.Handled()
    else
        return UIUtils.Unhandled()
    end
end

function WBP_NpcSwitchMain_PC_C:OnGamePadUp(InKeyName, MyGeometry, InKeyEvent)
    local IsEventHandled = false
    if not self.PressedBtn[InKeyName] then return end
    if InKeyName == Const.GamepadFaceButtonUp and self.PressedBtn[InKeyName] then
        self.Btn_ChangeNpc:OnBtnReleased()
        self.Btn_ChangeNpc:OnBtnClicked()
        IsEventHandled = true
    elseif InKeyName == Const.GamepadFaceButtonRight then
        self:CloseNpcSwitchMain()
    end
    if self.PressedBtn[InKeyName] then
        self.PressedBtn[InKeyName] = nil
    end
    return IsEventHandled
end

function WBP_NpcSwitchMain_PC_C:OnGamePadDown(InKeyName, MyGeometry, InKeyEvent)
    local IsEventHandled = false
    if self.OpenUI == "Main" then
        IsEventHandled = self.Common_Tab_PC:Handle_KeyEventOnGamePad(InKeyName)
    elseif self.OpenUI == "List" and self:OnKeyDownForLSComp(MyGeometry, InKeyEvent) then
        IsEventHandled = true
    end
    if IsEventHandled then return IsEventHandled end
    if self.PressedBtn[InKeyName] then return end  
    if InKeyName == Const.GamepadFaceButtonUp then
        self.Btn_ChangeNpc:OnBtnPressed()
        IsEventHandled = true
    end
    if InKeyName == Const.GamepadFaceButtonRight then
        IsEventHandled = true
    end
    self.PressedBtn[InKeyName] = true
    return IsEventHandled
end

function WBP_NpcSwitchMain_PC_C:OnMouseButtonDown(MyGeometry, InKeyEvent)
    if UE4.UKismetInputLibrary.PointerEvent_IsMouseButtonDown(InKeyEvent, UE4.EKeys.RightMouseButton) then
        --self:CloseNpcSwitchMain()
    else
        EventManager:FireEvent(EventID.OnMenuClose)
    end
    return UE4.UWidgetBlueprintLibrary.Handled()
end

--初始化镜头的位置和旋转
function WBP_NpcSwitchMain_PC_C:InitNpcInfo()
    self.CameraLocation = {}
    self.CameraRotation = {}
    for i = 1 ,self.SignBoardNums do
        if i == 3 then
            self.CameraLocation[i] = self.NpcLocation[i] - UE4.FVector(360,300,-50)
            self.CameraRotation[i] = self.NpcRotation[i] + UE4.FRotator(0,180,0)
        elseif self.NpcRotation[i].Yaw < -90 then
            self.CameraLocation[i] = self.NpcLocation[i] - UE4.FVector(300,0,-50)
            self.CameraRotation[i] = self.NpcRotation[i] + UE4.FRotator(0,180,0)
        else
            self.CameraLocation[i] = self.NpcLocation[i] - UE4.FVector(0,300,-50)
            self.CameraRotation[i] = self.NpcRotation[i] + UE4.FRotator(0,180,0)
        end

    end
end

function WBP_NpcSwitchMain_PC_C:InitNowTabId()
    self.NowTabId = 1                    -- 当前的TabId，默认是第一个拜访点
    local CurrentMinDis = 501            -- 触发距离 5 米
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self,0)
    local PlayerLocation = Player:K2_GetActorLocation()
    for key, value in pairs(self.NpcLocation) do
        local Distance = UE4.UKismetMathLibrary.Vector_Distance(value,PlayerLocation)
        if Distance < CurrentMinDis then
            self.NowTabId = key
            CurrentMinDis = Distance
        end
    end
    self.LastTabId = self.NowTabId
end

function WBP_NpcSwitchMain_PC_C:UpdateBottomKeyInfo()
    if not IsValid(self.GameInputModeSubsystem) then return end
    if self.GameInputModeSubsystem:GetCurrentInputType() ~= ECommonInputType.Gamepad then return end
    if not self.Common_Tab_PC.ConfigData then return end
    local BottomInfo
    if self.OpenUI == "Main" then
        BottomInfo = 
            {
                {
                    KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.CloseNpcSwitchMain, Owner=self}},
                    GamePadInfoList = {{Type="Img", ImgShortPath="B", ClickCallback=self.CloseNpcSwitchMain, Owner=self}},
                    Desc = GText("UI_BACK")
                }
            }

    else
        BottomInfo = 
			{
                {
                    GamePadInfoList = {{Type="Img", ImgShortPath="A", Owner=self}},
                    Desc = GText("UI_Tips_Ensure")
                },
                {
                    KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.CloseNpcSwitchMain, Owner=self}},
                    GamePadInfoList = {{Type="Img", ImgShortPath="B", ClickCallback=self.CloseNpcSwitchMain, Owner=self}},
                    Desc = GText("UI_BACK")
                }
            }
        
    end
    self.Common_Tab_PC:UpdateBottomKeyInfo(BottomInfo)
end

function WBP_NpcSwitchMain_PC_C:InitNpcTab(DontPlayInAnim)
    if self.Platform == "PC" then
        self.Common_Tab_PC = self.WBP_Com_Tab_P
        self.Common_Tab_PC:Init({LeftKey = "Q", RightKey = "E", Tabs = self.CommonTabInfo, DynamicNode = {"Back","BottomKey"},
                            BottomKeyInfo = {{KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.CloseNpcSwitchMain, Owner=self}},
                            GamePadInfoList = {{Type="Img", ImgShortPath="B", ClickCallback=self.CloseNpcSwitchMain, Owner=self}},
                            Desc = GText("UI_BACK")}},
                            TitleName = GText("MAIN_UI_NPCSWITCH"),
                            StyleName = "TextImage", OwnerPanel = self, BackCallback = self.CloseNpcSwitchMain},DontPlayInAnim)
    else
        self.Common_Tab_PC = self.WBP_Com_Tab_M
        self.Common_Tab_PC:Init({Tabs = self.CommonTabInfo, DynamicNode = {"Back"},
                            TitleName = GText("MAIN_UI_NPCSWITCH"),
                            StyleName = "TextImage", OwnerPanel = self, BackCallback = self.CloseNpcSwitchMain},DontPlayInAnim)
    end
    self.Common_Tab_PC:BindEventOnTabSelected(self,self.OnTabSelected)
    self.Common_Tab_PC:UpdateTopTitle(GText("MAIN_UI_NPCSWITCH"))
    self.Common_Tab_PC:SelectTab(self.NowTabId)
end

-- function WBP_NpcSwitchMain_PC_C:InitSortItem()
--     --筛选器的排序依据
--     self.Filters1 = {"UI_SHOWNPC_LIST_CONT_1"}
--     --筛选器的筛选项
--     --self.Filters2 = {"UI_Attr_Water_Name","UI_Attr_Fire_Name","UI_Attr_Thunder_Name","UI_Attr_Wind_Name","UI_Attr_Default_Name"}
--     self.Panel_Selected.WBP_Com_FilterSort:Init(self,self.Filters1,CommonConst.DESC)
--     self.Panel_Selected.WBP_Com_FilterSort:BindEventOnSelectionsChanged(self,self.OnOptionItemClicked)
--     self.Panel_Selected.WBP_Com_FilterSort:BindEventOnSortTypeChanged(self,self.OnButtonOrderClicked)
-- end

function WBP_NpcSwitchMain_PC_C:OnTabSelected(TabWidget)
    if self.NowTabId ~= TabWidget.Idx then
        local Player = UE4.UGameplayStatics.GetPlayerCharacter(self,0)
        AudioManager(self):StopSound(Player,"NpcSwitchVoice")
    end
    self.LastTabId = self.NowTabId
    self.NowTabId = TabWidget.Idx
    self:PlayBlackScreenIn()
    -- self:InitCameraTab()
    self:OnOpenMain(false)
end

--初始化看板娘列表
function WBP_NpcSwitchMain_PC_C:InitNpcList(IsByFrame)
    self:StopAttrListFramingIn()
    self.Panel_Selected.List_Character:ClearListItems()
    local ShowNpc={}
    for key,value in pairs(DataMgr.Npc) do
        if value.NpcType=="Show" then
            if self.OwnedChar[value.CharId] == true then
                local ShowNpcContent = {}
                ShowNpcContent.IsShow = 0
                ShowNpcContent.UnitId = value.UnitId
                ShowNpcContent.ParentWidget = self
                ShowNpcContent.IsSelected = false
                ShowNpcContent.IsSetted = false
                ShowNpcContent.IsShowInCurrentTab = 0
                if self.SelectedUnitId == value.UnitId then
                    ShowNpcContent.IsSelected = true
                    ShowNpcContent.IsShowInCurrentTab = 1
                end
                for i=1,self.SignBoardNums do
                    if self.SignBoardNpcState[i] == value.UnitId then
                        ShowNpcContent.IsSetted = true
                        ShowNpcContent.IsShow = 1
                        --if i == self.NowTabId then
                        --    ShowNpcContent.IsShowInCurrentTab = 1
                        --end
                    end
                end
                ShowNpcContent.Rarity = DataMgr.Char[value.CharId].CharRarity
                table.insert(ShowNpc,ShowNpcContent)
            end
        end
    end
    local SortedShowNpc = {}
    self.NpcNums = #ShowNpc
    if self.NpcNums > 1 then
        SortedShowNpc = self:SortAllNpc(ShowNpc)
    else
        SortedShowNpc = ShowNpc
    end
    for i=1 ,self.NpcNums do
        SortedShowNpc[i].Id = i
        self.NpcIndexWithUnitId[SortedShowNpc[i].UnitId] = i - 1
        local NpcObj = self:CreateNpcContent(SortedShowNpc[i])
        self.Panel_Selected.List_Character:AddItem(NpcObj)
    end
    self:AddTimer(0.01, function()
        local XCount, YCount = UIUtils.GetTileViewContentMaxCount(self.Panel_Selected.List_Character, "XY")
        local EmptyItemNum
        if (self.NpcNums - XCount * YCount <= 0) then
            EmptyItemNum = XCount * YCount - self.NpcNums
        else
            EmptyItemNum = XCount - self.NpcNums % XCount
        end
        for i = 1, EmptyItemNum do
            local NpcObj = NewObject(UIUtils.GetCommonItemContentClass())
            NpcObj.IsEmpty = true
            self.Panel_Selected.List_Character:AddItem(NpcObj)
        end
        self:AddTimer(0.01, function()
            self:PlayAttrListFramingIn()
        end)
        self.Panel_Selected.List_Character:NavigateToIndex(0)
    end)
    self.Panel_Selected.List_Character:ScrollToTop()
end

function WBP_NpcSwitchMain_PC_C:PlayListAnim()
    UIUtils.PlayListViewFramingInAnimation(self, self.Panel_Selected.List_Character, {Visibility=UIConst.VisibilityOp.HitTestInvisible})
end

function WBP_NpcSwitchMain_PC_C:PlayAttrListFramingIn()
    self.Panel_Selected.List_Character:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self._ListAttrAnimTimerKeys = UIUtils.PlayListViewFramingInAnimation(self, self.Panel_Selected.List_Character, {
        Interval = 0.033, Visibility=UIConst.VisibilityOp.Visible, Callback = function()
        self.Panel_Selected.List_Character:SetVisibility(UIConst.VisibilityOp.Visible)
    end})
end

function WBP_NpcSwitchMain_PC_C:StopAttrListFramingIn()
    UIUtils.StopListViewFramingInAnimation(self.Panel_Selected.List_Character, {UIState=self, TimerKeys=self._ListAttrAnimTimerKeys})
end

function WBP_NpcSwitchMain_PC_C:CreateNpcContent(NpcInfo)
    local NpcObj = NewObject(UIUtils.GetCommonItemContentClass())
    NpcObj.Id = NpcInfo.Id
    NpcObj.UnitId = NpcInfo.UnitId
    NpcObj.bSet = NpcInfo.IsSetted
    NpcObj.IsSelected = NpcInfo.IsSelected
    local ShowNpc = DataMgr.Npc[NpcInfo.UnitId]
    NpcObj.Icon = DataMgr.Char[ShowNpc.CharId].Icon
    NpcObj.Rarity = DataMgr.Char[ShowNpc.CharId].CharRarity
    NpcObj.Parent = self
    NpcObj.Type = 'Npc'
    NpcObj.OnMouseButtonUpEvents = {
        Obj = self,
        Callback = self.OnNpcListItemClicked,
        Params = {NpcObj}
    }
    return NpcObj
end

--获取三个看板娘静态刷新点
function WBP_NpcSwitchMain_PC_C:InitStaticCreator()
    self.NpcLocation = {}
    self.NpcRotation = {}
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    local CreatorMap = GameState.StaticCreatorMap:ToTable()
    self.NpcStaticCreator = {}
    for i = 1 ,self.SignBoardNums do
        for _, v in pairs(CreatorMap) do
            if (string.lower(v:GetDisplayName()) == string.lower(self.DisplayName[i])) then
                self.NpcStaticCreator[i] = v
                self.NpcLocation[i] = v:K2_GetActorLocation()
                self.NpcRotation[i] = v:K2_GetActorRotation()
                break
            end
        end
    end
    self.SequenceFile = {
        Empty = {
            [1] = "/Game/AssetDesign/Story/Sequence/HomeBaseGossip/HomebaseGossip_Empty_Camera1.HomebaseGossip_Empty_Camera1",
            [2] = "/Game/AssetDesign/Story/Sequence/HomeBaseGossip/HomebaseGossip_Empty_Camera2.HomebaseGossip_Empty_Camera2",
            [3] = "/Game/AssetDesign/Story/Sequence/HomeBaseGossip/HomebaseGossip_Empty_Camera3.HomebaseGossip_Empty_Camera3",
        },
        NpcGirl = {
            [1] = "/Game/AssetDesign/Story/Sequence/HomeBaseGossip/HomebaseGossip_Camera1.HomebaseGossip_Camera1",
            [2] = "/Game/AssetDesign/Story/Sequence/HomeBaseGossip/HomebaseGossip_Camera2.HomebaseGossip_Camera2",
            [3] = "/Game/AssetDesign/Story/Sequence/HomeBaseGossip/HomebaseGossip_Camera3.HomebaseGossip_Camera3",
        },
        NpcMan = {
            [1] = "/Game/AssetDesign/Story/Sequence/HomeBaseGossip/HomebaseGossip_Camera1_Man.HomebaseGossip_Camera1_Man",
            [2] = "/Game/AssetDesign/Story/Sequence/HomeBaseGossip/HomebaseGossip_Camera2_Man.HomebaseGossip_Camera2_Man",
            [3] = "/Game/AssetDesign/Story/Sequence/HomeBaseGossip/HomebaseGossip_Camera3_Man.HomebaseGossip_Camera3_Man",
        },
        NpcLady = {
            [1] = "/Game/AssetDesign/Story/Sequence/HomeBaseGossip/HomebaseGossip_Camera1_Lady.HomebaseGossip_Camera1_Lady",
            [2] = "/Game/AssetDesign/Story/Sequence/HomeBaseGossip/HomebaseGossip_Camera2_Lady.HomebaseGossip_Camera2_Lady",
            [3] = "/Game/AssetDesign/Story/Sequence/HomeBaseGossip/HomebaseGossip_Camera3_Lady.HomebaseGossip_Camera3_Lady",
        },
        NpcLoli = {
            [1] = "/Game/AssetDesign/Story/Sequence/HomeBaseGossip/HomebaseGossip_Camera1_Loli.HomebaseGossip_Camera1_Loli",
            [2] = "/Game/AssetDesign/Story/Sequence/HomeBaseGossip/HomebaseGossip_Camera2_Loli.HomebaseGossip_Camera2_Loli",
            [3] = "/Game/AssetDesign/Story/Sequence/HomeBaseGossip/HomebaseGossip_Camera3_Loli.HomebaseGossip_Camera3_Loli",
        }
    }
    self.LevelSequenceActor = self:GetWorld():SpawnActor(ALevelSequenceActor:StaticClass())
end

function WBP_NpcSwitchMain_PC_C:EnableNpcDitherAlpha(bEnable)
    local GameInstance = GWorld.GameInstance
    local GameState = UE4.UGameplayStatics.GetGameState(GameInstance)
    for _,v in pairs(self.NpcStaticCreator) do
        GameState:GetNpcInfoAsync(v.UnitId, function(Npc)
            if Npc then
                local FC = Npc:GetComponentByClass(UFashionComponent)
                if FC then
                    FC:EnableDitherAlpha(bEnable)
                end
            end
        end)
    end
end

--加载特效
function WBP_NpcSwitchMain_PC_C:InitSpecialEffectActor()
    local SpecialEffectPath = UE4.UClass.Load("/Game/UI/WBP/Invitation/Widget/NpcSpecialEffect.NpcSpecialEffect")
    self.SpecialEffectActor = self:GetWorld():SpawnActor(SpecialEffectPath, UE4.ESpawnActorCollisionHandlingMethod.AlwaysSpawn)
    self.SpecialEffectActor:K2_SetActorLocation(self.NpcLocation[self.NowTabId], false, nil, false)
    UE4.URuntimeCommonFunctionLibrary.SetActorHidden(self.SpecialEffectActor, false)
end

--初始化摄像头参数
function WBP_NpcSwitchMain_PC_C:InitCameraTab()
    if self.RestoreNpc then
        self:TriggerNpcStaticCreator(true)
        self.RestoreNpc = false
        self:SwitchNpcPose(self.NpcStaticCreator[self.NowTabId].UnitId,true,true,false)
    end
    --local character=UE4.UGameplayStatics.GetPlayerCharacter(self,0)
    --local PlayerCameraComponent=character:GetComponentByClass(UCameraComponent:StaticClass())
    --local lookat = UE4.UKismetMathLibrary.FindLookAtRotation(FVector(0,0,0),self.NpcInfo[self.NowTabId].Location)
    local LocalTransform = UE4.UKismetMathLibrary.MakeTransform(self.CameraLocation[self.NowTabId], self.CameraRotation[self.NowTabId], UE4.FVector(1, 1, 1))
    if self.Camera == nil then
        self.Camera = self:GetWorld():SpawnActor(ACineCameraActor:StaticClass(),LocalTransform)
        -- self.Camera = UGameplayStatics.GetActorOfClass(self, self.CameraClass)
    end
    local GameUserSettings = UE4.UGameUserSettings:GetGameUserSettings()
    local Resolution = GameUserSettings:GetScreenResolution()
    local ResolutionSize = Resolution.X / Resolution.Y
    self.Camera.CameraComponent.Filmback.SensorHeight = CommonConst.SensorHeight
    self.Camera.CameraComponent.Filmback.SensorWidth = CommonConst.SensorHeight * ResolutionSize
    self.Camera.CameraComponent.FocusSettings.FocusMethod = CommonConst.FocusMethod --设置聚焦方法为不重载
    self.Camera.CameraComponent:SetConstraintAspectRatio(false) --设置是否适应高宽比
    -- local ViewportSize = UIManager(self):GetViewportSize()
    -- if self.NpcSwitchRT.SizeX ~= ViewportSize.X or self.NpcSwitchRT.SizeY ~= ViewportSize.Y then
    --     URuntimeCommonFunctionLibrary.RenderTarget2DResize(self.NpcSwitchRT, ViewportSize.X,ViewportSize.Y)
    -- end
    --self.Camera.SceneCaptureComponent2D.TextureTarget
    -- self.Camera.SceneCaptureComponent2D:CaptureScene()
    --self.Img_RT:SetRenderOpacity(1.0)
    self.Camera:K2_SetActorTransform(LocalTransform, false, nil, false)
    -- if (self.LastTabId == 3 or self.NowTabId == 3) and self.LastTabId ~= self.NowTabId then
        -- self:PlayAnimation(self.Change)
    -- end
    -- self.Camera.CameraComponent:SetFieldOfView()
    local controller=UE4.UGameplayStatics.GetPlayerController(self,0)
    controller:SetViewTargetWithBlend(self.Camera,0,UE4.EViewTargetBlendFunction.VTBlend_Linear,0,false)
    self:InitLevelSequence()
end

function WBP_NpcSwitchMain_PC_C:PlayBlackScreenIn()
    self:BlockAllUIInput(true,"SP_DisplayOnly")
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    --UIManager:LoadUINew("CommonBlackScreen",self,self.InitCameraTab)
    local Params = {}
    Params.BlackScreenHandle = "NPCSwitch"
    Params.InAnimationObj = self
    Params.InAnimationCallback = self.InitCameraTab
    Params.InAnimationPlayTime = 0.1
    Params.OutAnimationObj = self
    Params.OutAnimationCallback = self.CloseBlackScreen
    Params.OutAnimationPlayTime = 0.1
    Params.OutAnimationBPSetting = "NPC_Switch"
    UIManager:ShowCommonBlackScreen(Params)
end

function WBP_NpcSwitchMain_PC_C:PlayBlackScreenOut()
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    -- local BlackUI = UIManager:GetUI("CommonBlackScreen")
    -- if BlackUI then
    --     BlackUI:PlayOutAnim(self,self.CloseBlackScreen)
    -- end
    UIManager:HideCommonBlackScreen("NPCSwitch")
end

function WBP_NpcSwitchMain_PC_C:CloseBlackScreen()
    self:BlockAllUIInput(false)
    -- local UIManager = GWorld.GameInstance:GetGameUIManager()
    -- UIManager:UnLoadUI("CommonBlackScreen")
end

function WBP_NpcSwitchMain_PC_C:InitLevelSequence()
    if self.Sequence_Player then
        self.Sequence_Player:Stop()
    end
    local Sequence
    if self.SignBoardNpcState[self.NowTabId] == CommonConst.UnsetState then
        Sequence = LoadObject(self.SequenceFile['Empty'][self.NowTabId])
    else
        local NpcInfo = DataMgr.Npc[self.SignBoardNpcState[self.NowTabId]]
        local NpcModelInfo = DataMgr.Model[NpcInfo.ModelId]
        local NpcTag = NpcModelInfo.ModelTag
        local CurTag = 'Empty'
        for index,Tag in pairs(NpcTag) do
            if self.SequenceFile[Tag] then
                CurTag = Tag
            end
        end
        Sequence = LoadObject(self.SequenceFile[CurTag][self.NowTabId])
    end
    -- self.LevelSequenceActor.bOverrideInstanceData = true --改成wc之后，不需要重载实例了
    -- local DefaultInstanceData = self.LevelSequenceActor.DefaultInstanceData
    -- DefaultInstanceData.TransformOriginActor = self.NpcStaticCreator[self.NowTabId]
    self.LevelSequenceActor:SetSequence(Sequence)
    local BindingArray = TArray(AActor)
    BindingArray:Add(self.Camera)
    self.LevelSequenceActor:SetBindingByTag("ShowNpc", BindingArray, false)
    self.Sequence_Player = self.LevelSequenceActor.SequencePlayer
    -- local FrameDuration = self.Sequence_Player:GetFrameDuration()
    -- local FrameRate = self.Sequence_Player:GetFrameRate()
    -- local Duration = FrameDuration / FrameRate.Numerator
    self.IsReverse = false  --当前是否是倒放
    local PlaySequence = function()
        if self.NowTabId == 3 then
            return
        end
        if self.IsReverse then
            self.IsReverse = false
            self.Sequence_Player:Play()
        else
            self.IsReverse = true
            self.Sequence_Player:PlayReverse()
        end
    --    self.Btn_ChangeNpc:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    --    self.Btn_ChangeNpc:PlayAnimation(self.Btn_ChangeNpc.Btn_in)
    end
    if not self.DelegateIsBind then
        self.DelegateIsBind = true
        self.Sequence_Player.OnFinished:Add(self, PlaySequence)
    end

    if self.NowTabId == 3 then
        self.Sequence_Player:PlayLooping(-1)
    else
        self.Sequence_Player:Play()
    end
    self:PlayBlackScreenOut()
end

function WBP_NpcSwitchMain_PC_C:CreateSortItemContent(Content,ClassPath)
    if(Content == nil)then
        return
    end
    if(ClassPath == nil)then
        ClassPath = '/Game/UI/UI_Phone/Bag/Bag_SortItem_Content.Bag_SortItem_Content_C'
    end
    local SortObj = NewObject(UIUtils.GetCommonItemContentClass())
    SortObj.GridIndex = Content.GridIndex
    SortObj.SortName = Content.SortName
    SortObj.IsSelected = Content.IsSelected
    return SortObj
end

--看板娘列表排序
function WBP_NpcSwitchMain_PC_C:SortAllNpc(DataTable)
    table.sort(DataTable,function(Data1,Data2)
        if Data1.IsShowInCurrentTab ~= Data2.IsShowInCurrentTab then
            return Data1.IsShowInCurrentTab > Data2.IsShowInCurrentTab
        elseif Data1.IsShow ~= Data2.IsShow then
            return Data1.IsShow > Data2.IsShow
        end
    end)
    return DataTable
end

function WBP_NpcSwitchMain_PC_C:OnButtonAddClicked()
    if self.OpenUI == "Main" then
        self:OnOpenList()
    end
end

--打开系统主界面
function WBP_NpcSwitchMain_PC_C:OnOpenMain(PlayTabInAnim)
    if self.NowTabId == 3 then
        self.SpecialEffectActor:K2_SetActorLocation(self.NpcLocation[self.NowTabId], false, nil, false)
        self.SpecialEffectActor:K2_SetActorRotation(FRotator(0, 130, 0), false)
    else
        self.SpecialEffectActor:K2_SetActorLocation(self.NpcLocation[self.NowTabId], false, nil, false)
        self.SpecialEffectActor:K2_SetActorRotation(FRotator(0, 0, 0), false)
    end

    self.OpenUI = "Main"
    local UnitName = "UI_SHOWNPC_UNSETTLED"
    if self.SignBoardNpcState[self.NowTabId] ~= CommonConst.UnsetState then
        UnitName = DataMgr.Npc[self.SignBoardNpcState[self.NowTabId]].UnitName
        self:SetTextNpcName(true)
    else
        self:SetTextNpcName(false)
    end
    self.Common_Tab_PC:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Common_Tab_PC.Panel_Tab:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    -- if self.Platform == "PC" then
    --     self.Common_Tab_PC.Title_Tab:SetVisibility(UE4.ESlateVisibility.Collapsed)
    -- end
    self.Text_NpcName:SetText(GText(UnitName))
    self.Text_WorldText:SetText(EnText(UnitName))
    self.Text_WorldText:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Text_NpcName:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Panel_Selected:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Btn_ChangeNpc:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    if PlayTabInAnim then
        self.Common_Tab_PC:StopAnimation(self.Common_Tab_PC.Panel_Tab_Out)
        self.Common_Tab_PC:PlayAnimation(self.Common_Tab_PC.Panel_Tab_In)
    end
    self:CheckSignBoardNpcState()
    self:UpdateBottomKeyInfo()
    if self:HasAnyFocus() then
        self:BP_GetDesiredFocusTarget():SetFocus()
    end

    --self:HideNavigateWidget(true)
end

--打开看板娘选择界面
function WBP_NpcSwitchMain_PC_C:OnOpenList()
    self.OpenUI = "List"
    self.Panel_Selected.Panel_Selected:SetRenderOpacity(1.0)
    self.Panel_Selected:StopAnimation(self.Panel_Selected.Out)
    self.Panel_Selected:PlayAnimation(self.Panel_Selected.In)
    self.Common_Tab_PC:StopAnimation(self.Common_Tab_PC.Panel_Tab_In)
    self.Common_Tab_PC:PlayAnimation(self.Common_Tab_PC.Panel_Tab_Out)
    -- if self.Platform == "PC" then
    --     self.Common_Tab_PC.Title_Tab:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    -- end
    self.SelectedUnitId = self.SignBoardNpcState[self.NowTabId]
    local UnitName = "UI_SHOWNPC_SELECT"
    if self.SignBoardNpcState[self.NowTabId] ~= CommonConst.UnsetState then
        UnitName = DataMgr.Npc[self.SignBoardNpcState[self.NowTabId]].UnitName
        self:SetTextNpcName(true)
    else
        self:SetTextNpcName(false)
    end
    --self.Common_Tab_PC.Panel_Tab:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Text_NpcName:SetText(GText(UnitName))
    self.Text_WorldText:SetText(EnText(UnitName))
    self.Panel_Selected:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self:CheckSignBoardNpcState()
    self.Panel_Selected.List_Character:ClearListItems()
    self:SetCannotClose(self.Panel_Selected.In:GetEndTime())
    --local InitNpc = function()
        self:InitNpcList(true)
    --end
    --local InitNpcTime = self.Panel_Selected.In:GetEndTime()
    --self:AddTimer(InitNpcTime, InitNpc,false,0,"InitNpc")
    self:UpdateBottomKeyInfo()
    if self:HasAnyFocus() then
        self:BP_GetDesiredFocusTarget():SetFocus()
    end
    -- self:BP_GetDesiredFocusTarget():SetFocus()
end

function WBP_NpcSwitchMain_PC_C:SetTextNpcName(IsName)
    local Font = self.Text_NpcName.Font
    local SlateColor = self.Text_NpcName.ColorAndOpacity
    if IsName then
        Font.FontMaterial = self.NameFontMaterial
        SlateColor.SpecifiedColor = UE4.FLinearColor(1,1,1,1)
        self.Text_NpcName:SetColorAndOpacity(SlateColor)
    else
        Font.FontMaterial = nil
        SlateColor.SpecifiedColor = UE4.FLinearColor(1,1,1,0.8)
        self.Text_NpcName:SetColorAndOpacity(SlateColor)
    end
    self.Text_NpcName:SetFont(Font)
end

function WBP_NpcSwitchMain_PC_C:CheckSignBoardNpcState()
    self.CancelCurrentNpc = false
    if self.SignBoardNpcState[self.NowTabId] == CommonConst.UnsetState then
        UE4.URuntimeCommonFunctionLibrary.SetActorHidden(self.SpecialEffectActor, false)
        if self.OpenUI == "Main" then
            self.Btn_ChangeNpc:SetText(GText("UI_SHOWNPC_NAME_SYSTEM"))
            self.Switch_Icon:SetActiveWidgetIndex(0)
        elseif self.OpenUI == "List" then
            self.Btn_ChangeNpc:SetText(GText("UI_SHOWNPC_BUTTON_1"))
            self.Switch_Icon:SetActiveWidgetIndex(0)
        end
    else
        UE4.URuntimeCommonFunctionLibrary.SetActorHidden(self.SpecialEffectActor, true)
        if self.OpenUI == "Main" then
            self.Btn_ChangeNpc:SetText(GText("UI_SHOWNPC_BUTTON_2"))
            self.Switch_Icon:SetActiveWidgetIndex(2)
        elseif self.OpenUI == "List" then
            self.Btn_ChangeNpc:SetText(GText("UI_SHOWNPC_BUTTON_3"))
            self.Switch_Icon:SetActiveWidgetIndex(1)
        end
        self.CancelCurrentNpc = true
    end
end

function WBP_NpcSwitchMain_PC_C:ClearListSelectedState()
    for i = 0,self.Panel_Selected.List_Character:GetNumItems() - 1 do
        local Item = self.Panel_Selected.List_Character:GetItemAt(i)
        if Item.SelfWidget and Item.SelfWidget.Content.IsSelect then
            Item.SelfWidget:SetSelected(false)
        end
    end
end

function WBP_NpcSwitchMain_PC_C:OnNpcListItemClicked(Content)
    if Content.IsEmpty then
        return
    end
    AudioManager(self):PlayUISound(self, "event:/ui/armory/click_select_role", nil, nil)
    for i = 1,self.SignBoardNums do
        if i ~= self.NowTabId and self.SignBoardNpcState[i] == Content.UnitId then
            UIManager(self):ShowError(5002,nil, UIConst.Tip_CommonToast)
            -- self:ClearListSelectedState()
            Content.SelfWidget:SetSelected(false)
            -- if self.NpcStaticCreator[self.NowTabId].UnitId ~= 0 then
            --     self.CurNpcContent.SelfWidget:SetSelected(true)
            -- end
            return
        end
    end
    if self.CurNpcContent and self.CurNpcContent ~= Content then
        if self.CurNpcContent.SelfWidget then
            self.CurNpcContent.SelfWidget:SetSelected(false)
        else
            self.CurNpcContent.IsSelect = false
        end
    end
    self.CurNpcContent = Content
    if self.NpcStaticCreator[self.NowTabId].UnitId == self.CurNpcContent.UnitId then
        if self.SignBoardNpcState[self.NowTabId] == self.CurNpcContent.UnitId then
            self.Btn_ChangeNpc:SetText(GText("UI_SHOWNPC_BUTTON_3"))
            self.Switch_Icon:SetActiveWidgetIndex(1)
            self.CancelCurrentNpc = true
        end
        return
    end
    self.PreviewNpcLoadComplete = false
    if self.NpcStaticCreator[self.NowTabId].UnitId == 0 then
        self.PreviewNpcLoadComplete = true
    else
        for i = 1, self.NpcStaticCreator[self.NowTabId].ChildEids:Length() do
            local NpcInfo = Battle(self):GetEntity(self.NpcStaticCreator[self.NowTabId].ChildEids:GetRef(i))
            if IsValid(NpcInfo) then
                self.PreviewNpcLoadComplete = true
            end
        end
    end
    if self.PreviewNpcLoadComplete == false then
        -- self:ClearListSelectedState()
        self.CurNpcContent.SelfWidget:SetSelected(false)
        local Item = self.Panel_Selected.List_Character:GetItemAt(self.NpcIndexWithUnitId[self.NpcStaticCreator[self.NowTabId].UnitId])
        if Item.SelfWidget then
            Item.SelfWidget:SetSelected(true)
        end
        return
    end
    -- self:ClearListSelectedState()
    Content.SelfWidget:SetSelected(true)
    self:SwitchNpcPose(self.NpcStaticCreator[self.NowTabId].UnitId,false,false,true)
    self.SelectedUnitId = self.CurNpcContent.UnitId
    local UnitName = DataMgr.Npc[self.SelectedUnitId].UnitName
    self:SetTextNpcName(true)
    self.Text_WorldText:SetText(EnText(UnitName))
    self.Text_NpcName:SetText(GText(UnitName))
    UE4.URuntimeCommonFunctionLibrary.SetActorHidden(self.SpecialEffectActor, true)
    self:TriggerNpcStaticCreator(false)
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self,0)
    AudioManager(self):StopSound(Player,"NpcSwitchVoice")
    self.NpcStaticCreator[self.NowTabId].UnitId = self.SelectedUnitId
    self.CancelCurrentNpc = false
    if self.SelectedUnitId == self.SignBoardNpcState[self.NowTabId] then
        self.CancelCurrentNpc = true
        self.Btn_ChangeNpc:SetText(GText("UI_SHOWNPC_BUTTON_3"))
        self.Switch_Icon:SetActiveWidgetIndex(1)
    elseif self.SignBoardNpcState[self.NowTabId] == CommonConst.UnsetState then
        self.Btn_ChangeNpc:SetText(GText("UI_SHOWNPC_BUTTON_1"))
        self.Switch_Icon:SetActiveWidgetIndex(0)
    else
        self.Btn_ChangeNpc:SetText(GText("UI_SHOWNPC_BUTTON_2"))
        self.Switch_Icon:SetActiveWidgetIndex(2)
    end
    self:TriggerNpcStaticCreator(true)
    
    local GameInstance = GWorld.GameInstance
	local GameState = UE4.UGameplayStatics.GetGameState(GameInstance)
    GameState:GetNpcInfoAsync(self.NpcStaticCreator[self.NowTabId].UnitId, function(Npc) 
        Npc:GetMovementComponent().GravityScale = 0
        Npc.CharacterMovement.Velocity = FVector(0, 0, 0)
    end)

    self:SwitchNpcPose(self.NpcStaticCreator[self.NowTabId].UnitId,true,true)
end

function WBP_NpcSwitchMain_PC_C:TriggerNpcStaticCreator(IsActive)
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    local StaticIds = TArray(0)
    StaticIds:Add(self.NpcStaticCreator[self.NowTabId].StaticCreatorId)
    if IsActive then
        GameMode:TriggerActiveStaticCreator(StaticIds)
    else
        GameMode:TriggerInactiveStaticCreator(StaticIds)
    end
end

function WBP_NpcSwitchMain_PC_C:SwitchNpcPose(NpcId,IsSet,PlayAppear,PlayDisappear)
    local NpcInfo = DataMgr.Npc[NpcId]
    if NpcInfo == nil then
        return
    end
    local ShowAnimation = NpcInfo.ShowAnimationId
    if ShowAnimation == nil then
        return
    end
    local ShowAnimationId = ShowAnimation[self.NowTabId]
    local GameInstance = GWorld.GameInstance
	local GameState = UE4.UGameplayStatics.GetGameState(GameInstance)

    self:BlockAllUIInput(true,"SP_DisplayOnly")
    GameState:GetNpcInfoAsync(self.NpcStaticCreator[self.NowTabId].UnitId, function(Npc) 
        self:BlockAllUIInput(false)
        Npc:InitNpcAccessories(NpcInfo.CharId)
        if ShowAnimationId == 'Sit' and IsSet and self.NowTabId ~= 3 then
            Npc:SetSitPoseInteractive()
        else
            Npc:SetIdlePose(false)
        end
        if PlayAppear and Npc.FXComponent then
            Npc.FXComponent:PlayEffectByIDParams(301, {
                bTickEvenWhenPaused = true,
                NotAttached = true
            })
            AudioManager(self):PlayUISound(self, "event:/ui/common/role_appear", nil, nil)
        end
        if PlayDisappear and Npc.FXComponent then
            Npc.FXComponent:PlayEffectByIDParams(302, {
                bTickEvenWhenPaused = true,
                NotAttached = true
            })
            AudioManager(self):PlayUISound(self, "event:/ui/common/role_disappear", nil, nil)
        end
    end)

    -- local Npc = GameState.NpcCharacterMap:Find(NpcId)
    -- local FindNpc = function()
    --     local NpcRes = GameState.NpcCharacterMap:Find(NpcId)
    --     if NpcRes then
    --         if ShowAnimationId == 'Sit' and IsSet and self.NowTabId ~= 3 then
    --             NpcRes:SetSitPoseInteractive()
    --         else
    --             NpcRes:SetIdlePose(false)
    --         end
    --         if PlayAppear and NpcRes.FXComponent then
    --             NpcRes.FXComponent:PlayEffectByIDParams(301, {
    --                 bTickEvenWhenPaused = true,
    --                 NotAttached = true
    --             })
    --             AudioManager(self):PlayUISound(self, "event:/ui/common/role_appear", nil, nil)
    --         end
    --         if PlayDisappear and NpcRes.FXComponent then
    --             NpcRes.FXComponent:PlayEffectByIDParams(302, {
    --                 bTickEvenWhenPaused = true,
    --                 NotAttached = true
    --             })
    --             AudioManager(self):PlayUISound(self, "event:/ui/common/role_disappear", nil, nil)
    --         end
    --         NpcRes:InitNpcAccessories(NpcInfo.CharId)
    --         self:BlockAllUIInput(false)
    --         self:RemoveTimer("FindNpc")
    --     end
    -- end
    -- if Npc == nil then
    --     self:BlockAllUIInput(true)
    --     self:AddTimer(self.MontageTime,FindNpc,true,0,"FindNpc",true)
    -- else
    --     self:BlockAllUIInput(false)
    --     if ShowAnimationId == 'Sit' and IsSet and self.NowTabId ~= 3 then
    --         Npc:SetSitPoseInteractive()
    --     else
    --         Npc:SetIdlePose(false)
    --     end
    --     if PlayAppear and Npc.FXComponent then
    --         Npc.FXComponent:PlayEffectByIDParams(301, {
    --             bTickEvenWhenPaused = true,
    --             NotAttached = true
    --         })
    --         AudioManager(self):PlayUISound(self, "event:/ui/common/role_appear", nil, nil)
    --     end
    --     if PlayDisappear and Npc.FXComponent then
    --         Npc.FXComponent:PlayEffectByIDParams(302, {
    --             bTickEvenWhenPaused = true,
    --             NotAttached = true
    --         })
    --         AudioManager(self):PlayUISound(self, "event:/ui/common/role_disappear", nil, nil)
    --     end
    --     Npc:InitNpcAccessories(NpcInfo.CharId)
    -- end
end

function WBP_NpcSwitchMain_PC_C:OnBtnChangeNpcClicked()
    if self.OpenUI == "Main" then
        self:OnOpenList()
    elseif self.OpenUI == "List" then
        local Avatar = GWorld:GetAvatar()
        if Avatar == nil then
            return
        end
        --卸下看板娘
        if self.SignBoardNpcState[self.NowTabId] == self.SelectedUnitId and self.SelectedUnitId ~= CommonConst.UnsetState then
            self:BlockAllUIInput(true)
            Avatar:UpdateSignBoardNpc(self.NowTabId,CommonConst.UnsetState)
            return
        end
        --判断所选看板娘是否已被摆放
        for i=1,self.SignBoardNums do
            if i ~= self.NowTabId and self.SelectedUnitId == self.SignBoardNpcState[i] and self.SignBoardNpcState[i]~=CommonConst.UnsetState then
                UIManager(self):ShowError(5002,nil, UIConst.Tip_CommonToast)
                return
            end
        end
        if self.SelectedUnitId ~=  self.SignBoardNpcState[self.NowTabId] and self.SelectedUnitId~=CommonConst.UnsetState then
            self:BlockAllUIInput(true)
            Avatar:UpdateSignBoardNpc(self.NowTabId,self.SelectedUnitId)
        else
            UIManager(self):ShowError(5004,nil, UIConst.Tip_CommonToast)
        end
    end
end

function WBP_NpcSwitchMain_PC_C:OnOptionItemClicked()
    --TODO 排序等后续Common资源更新
end

function WBP_NpcSwitchMain_PC_C:OnButtonOrderClicked()
    self.SortByReserveOrder = not self.SortByReserveOrder
    self:InitNpcList(true)
end

function WBP_NpcSwitchMain_PC_C:PlayNpcVoice()
    local NpcId = self.SignBoardNpcState[self.NowTabId]
    local NpcInfo = DataMgr.Npc[NpcId]
    local PlayerName
    if NpcInfo and NpcInfo.CharId then
        local CharId = NpcInfo.CharId
        local CharInfo = DataMgr.BattleChar[CharId]
        local PlayerInfo = DataMgr.Model[CharInfo.ModelId].MontagePrefix
        PlayerName = self:SplitPlayerInfo(PlayerInfo)
    end
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self,0)
    AudioManager(self):PlayCharVoice(Player, PlayerName, "vo_idle",nil,"NpcSwitchVoice",true)
end

function WBP_NpcSwitchMain_PC_C:SplitPlayerInfo(PlayerInfo)
    if not PlayerInfo then
        return ""
    end
    if string.sub(PlayerInfo, -1) == "_" then
        return string.sub(PlayerInfo, 1, -2)
    end
    return PlayerInfo
end

function WBP_NpcSwitchMain_PC_C:UpdateSignBoardNpc(Ret,Index,NpcId)
    if Ret == ErrorCode.RET_SUCCESS then
        self.SignBoardNpcState[Index] = NpcId
        if NpcId ~= CommonConst.UnsetState then
            self.CommonTabInfo[Index].NpcId = NpcId
        else
            self.CommonTabInfo[Index].NpcId = nil
        end
        if self.CancelCurrentNpc then
            AudioManager(self):PlayUISound(self, "event:/ui/common/invite_unequip", nil, nil)
            local Player = UE4.UGameplayStatics.GetPlayerCharacter(self,0)
            AudioManager(self):StopSound(Player,"NpcSwitchVoice")
            self.CancelCurrentNpc = false
            self:SwitchNpcPose(self.NpcStaticCreator[self.NowTabId].UnitId,false)
            self:TriggerNpcStaticCreator(false)
            self.NpcStaticCreator[self.NowTabId].UnitId = 0
            self.ErrorContent = nil
        else
            AudioManager(self):PlayUISound(self, "event:/ui/common/invite_equip", nil, nil)
            self:PlayNpcVoice()
            self.ErrorContent = nil
        end
        self:CloseNpcSwitchMain()
        -- self:InitNpcTab()
    elseif DataMgr.ErrorCode[Ret] then
        self:UpdateSignBoardNpcFailed()
        UIManager(self):ShowError(Ret, nil, UIConst.Tip_CommonToast)
    else
        local ErrorText = "Unknown_Error"
        self:UpdateSignBoardNpcFailed()
        UIManager(self):ShowUITip("CommonToastMain", GText(ErrorText), 1.5)
    end
    self.SelectedUnitId = self.SignBoardNpcState[self.NowTabId]
    self:BlockAllUIInput(false)
end

function WBP_NpcSwitchMain_PC_C:UpdateSignBoardNpcFailed()
    local Avatar = GWorld:GetAvatar()
    for i=1,self.SignBoardNums do
        self.SignBoardNpcState[i] = Avatar.SignBoardNpc[i]
    end
    self:SwitchNpcPose(self.NpcStaticCreator[self.NowTabId].UnitId,false)
    self:TriggerNpcStaticCreator(false)
    if self.SignBoardNpcState[self.NowTabId] ~= CommonConst.UnsetState then
        self.NpcStaticCreator[self.NowTabId].UnitId = self.SignBoardNpcState[self.NowTabId]
        self:TriggerNpcStaticCreator(true)
        self:SwitchNpcPose(self.NpcStaticCreator[self.NowTabId].UnitId,true)
    else
        self.NpcStaticCreator[self.NowTabId].UnitId = 0
    end
    self:OnOpenList()
    self:InitNpcTab(true)
end

function WBP_NpcSwitchMain_PC_C:CloseNpcSwitchMain()
    if self.OpenUI == "List" then
        self:CloseList()
    elseif self.OpenUI == "Main" then
        self:CloseMain()
    end
end

function WBP_NpcSwitchMain_PC_C:CloseList()
    self.RestoreNpc = false
    if self.SelectedUnitId ~= self.SignBoardNpcState[self.NowTabId] and self.SelectedUnitId ~=CommonConst.UnsetState then
        self:SwitchNpcPose(self.NpcStaticCreator[self.NowTabId].UnitId,false,false,true)
        self:TriggerNpcStaticCreator(false)
        --self.SelectedUnitId = self.SignBoardNpcState[1]
        self.SelectedUnitId = CommonConst.UnsetState
        if self.SignBoardNpcState[self.NowTabId] ~= CommonConst.UnsetState then
            self.NpcStaticCreator[self.NowTabId].UnitId = self.SignBoardNpcState[self.NowTabId]
            self.RestoreNpc = true --需要恢复原有的NPC
        else
            self.NpcStaticCreator[self.NowTabId].UnitId = 0
        end
    end
    self:BlockAllUIInput(true,"SP_DisplayOnly")
    self.Panel_Selected:StopAnimation(self.Panel_Selected.In)
    self.Panel_Selected:PlayAnimation(self.Panel_Selected.Out)
    local OpenMain = function()
        self:BlockAllUIInput(false)
        self:InitNpcTab(true)
        self:OnOpenMain(true)
    end
    local OpenMainTime = self.Panel_Selected.Out:GetEndTime()
    self:AddTimer(OpenMainTime, OpenMain,false,0,"OpenMain",true)
end

function WBP_NpcSwitchMain_PC_C:CloseMain()
    if (self:IsExistTimer("PlaySequence")) then
        self:RemoveTimer("PlaySequence")
    end
    if self.Sequence_Player then
        self.Sequence_Player:Stop()
    end
    local controller=UE4.UGameplayStatics.GetPlayerController(self,0)
    local Player=UE4.UGameplayStatics.GetPlayerCharacter(self,0)
    controller:SetViewTargetWithBlend(Player,0,UE4.EViewTargetBlendFunction.VTBlend_Linear,0,false)
    Player:SetActorHideTag("Npc", false)
    -- Player:SetCharacterTagIdle()
    Player:SetCanInteractiveTrigger(true)
    --Player:SetBrushStaticMeshScalarParameter(1.0)
    self.SpecialEffectActor:K2_DestroyActor()
    self:PlayOutAnim()
end

function WBP_NpcSwitchMain_PC_C:SetCannotClose(time)
    --设置暂时不可关闭，一般是等待动画播完
    self:BlockAllUIInput(true,"SP_DisplayOnly")
    local func = function()
        self:BlockAllUIInput(false)
    end
    self:AddTimer(time or 1,func,false,0,"SetCanClose",true)
end

function WBP_NpcSwitchMain_PC_C:PlayInAnim()
    self:PlayAnimation(self.Main_In)
    self.Common_Tab_PC:PlayInAnim()
    local MainInTime = self.Main_In:GetEndTime()
    self:SetCannotClose(MainInTime)
end

function WBP_NpcSwitchMain_PC_C:PlayOutAnim()
    self:PlayAnimation(self.Main_Out)
    local MainOutTime = self.Main_Out:GetEndTime()
    self:SetCannotClose(MainOutTime)
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self,0)
    AudioManager(self):StopSound(Player,"NpcSwitchVoice")
    self.Common_Tab_PC:PlayOutAnim()
    self:EnableNpcDitherAlpha(true)
    self:BindToAnimationFinished(self.Main_Out,{self,self.Close})
    AudioManager(self):SetEventSoundParam(self, "NpcSwitchMain", {ToEnd=1})
end

function WBP_NpcSwitchMain_PC_C:BP_GetDesiredFocusTarget()
    if self.OpenUI == "List" and not self.Panel_Selected:IsAnimationPlaying(self.Panel_Selected.Out) then
        return self.Panel_Selected.List_Character
    else
        return self
    end
end

AssembleComponents(WBP_NpcSwitchMain_PC_C)
return WBP_NpcSwitchMain_PC_C

