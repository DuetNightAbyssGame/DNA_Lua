require "UnLua"
require "DataMgr"
local EMCache = require "EMCache.EMCache"

local WBP_Piano_Main = Class("BluePrints.UI.BP_UIState_C")

function WBP_Piano_Main:OnLoaded(...)
    WBP_Piano_Main.Super.OnLoaded(self, ...)
    self:PlayAnimation(self.In)
    self.isPC = CommonUtils.GetDeviceTypeByPlatformName()=="PC"
    self.InputDevice = UIUtils.UtilsGetCurrentInputType()
    self.IsClosing = false
    self.BtnMusicCanClick = false
    -- 切换乐谱时不显示按钮，一定要Hover过Item才显示
    self.BtnCouldShow = false
    self:AddDispatcher(EventID.ChangeMusicItemNewState, self, self.OnMusicItemNewStateChange)
    self:OnLoaded_InitParam()
    self:OnLoaded_GetData()
    self:OnLoaded_InitUI()
    self:BindInputMethodChangedDelegate()
    self.List_Item:SetNavigationRuleCustom(UE4.EUINavigation.Right, {self, self.List_Item_NavRight})
    AudioManager(self):PlayUISound(self, "event:/ui/common/music_savor_open", "PianoSystemOpen", nil)
    self.Book = UE4.UGameplayStatics.GetActorOfClass(self, LoadClass("/Game/AssetDesign/Level/Prop/BP_PianoTab.BP_PianoTab"))
    self.IsFirstOpen = true
    self:AddTimer(0.05, function()
        self.List_Item:ScrollIndexIntoView(self.Init_Select_ItemIndex)
        self.List_Music:ScrollIndexIntoView(self.Init_Select_MusicIndex)
    end)
end

function WBP_Piano_Main:Close()
    self.IsClosing = true
    -- 结束与机关的交互
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(GWorld.GameInstance, 0)
    local Player = PlayerController:GetMyPawn()
    local Eid = Player.MechanismEid
    local Mechanism = Battle(self):GetEntity(Eid)
    if Mechanism then
        Mechanism:EndInteractive(Player, true)
    end
    AudioManager(self):PlayCustomBGM(DataMgr.Music[self.CurrentHomeBaseBGM].Event)
    AudioManager(self):StopPianoSystemBGM()
    self:PlayAnimation(self.Out)
    AudioManager(self):SetEventSoundParam(self, "PianoSystemOpen", { ToEnd = 1 })
    WBP_Piano_Main.Super.Close(self)
end

-- 更新EMCache
function WBP_Piano_Main:SaveCacheData()
    local ReadMusicItemIds = EMCache:Get("PianoSystem_ReadMusicIds", true) or {}
    for NeedStoreMusicId,_ in pairs(self.ReadMusicItems) do
        ReadMusicItemIds[NeedStoreMusicId] = 1
    end
    EMCache:Set("PianoSystem_ReadMusicIds", ReadMusicItemIds, true)
end

function WBP_Piano_Main:Destruct()
    self:SaveCacheData()
    self.UnLockMusicScores = nil
    self.UnLockMusicScoreToItems = nil
    self.UnLockMusicScoreToItems_Sort = nil
    self.AllMusicScoreToMusic = nil
    self.UnreadMusicItems = nil
    self.ReadMusicItems = nil
    self.MusicScoreUnreadNum = nil
    self.CurrentSelectMusicScore = nil
    self.List_Item:ClearListItems()
    self.List_Music:ClearListItems()
    self.Btn_Music.OnClicked:Remove(self, self.OnBtnClicked)
    self:UnBindInputMethodChangedDelegate()
    -- self:ListMusicUnBindSelectChangeDelegate()
    WBP_Piano_Main.Super.Destruct(self)
end

-- 初始化self参数
function WBP_Piano_Main:OnLoaded_InitParam()
    -- 已解锁的乐谱 {[1]=ScoreId1, [2]=ScoreId2, ...}
    self.UnLockMusicScores = {}
    -- 已解锁的乐谱及其乐曲 {[Score1]={Music1_1=1, Music1_2=1, ...}, ...}
    self.UnLockMusicScoreToItems = {}
    -- 排序用 {[Score1]={[1]=Music1_1, [2]=Music1_2, ...}, ...}
    self.UnLockMusicScoreToItems_Sort = {}
    -- 所有的乐谱乐曲关系，记录这个主要是为了在切MusicScore的时候直接用
    self.AllMusicScoreToMusic = {}
    -- 当前设置的HomeBaseBGM [Music] [NeedStore]
    self.CurrentHomeBaseBGM = 0
    -- 当前选中的乐曲Id
    self.Cur_SelectMusicId = nil
    -- 当前播放的乐曲Id
    self.Cur_PlayMusicId = nil
    -- 初始化选中的ListItem_Index
    self.Init_Select_ItemIndex = nil
    self.Init_Select_MusicIndex = nil
    -- 需要显示New的MusicItem Id
    self.UnreadMusicItems = {}
    -- 关闭时存到EMCache的已读MusicId
    self.ReadMusicItems = {}
    -- MusicScore有多少个New子项
    self.MusicScoreUnreadNum = {}
    -- 当前选中的MusiceScoreId
    self.CurrentSelectMusicScore = nil

    -- 当前选中的乐曲是否是Lock的
    self.IsShowingLockText = nil
    -- 当前选中的乐曲是否是CustomBGM
    self.BtnMusic_IsSet = nil
    -- 当前文字的折叠状态是否需要强制更新
    self.TextShowNeedForceUpdate = false
end

--region 初始化数据和UI
function WBP_Piano_Main:OnLoaded_GetData()
    self:GetMusicScoreToMusicDatas()
    self:GetAvatarUnLockMusic()
end

function WBP_Piano_Main:OnLoaded_InitUI()
    self:InitList_Item()
    self:InitOtherWidget()
end

function WBP_Piano_Main:GetMusicScoreToMusicDatas()
    for MusicId, MusicInfo in pairs(DataMgr.Music) do
        if not self.AllMusicScoreToMusic[MusicInfo.MusicScoreId] then
            self.AllMusicScoreToMusic[MusicInfo.MusicScoreId] = {}
        end
        table.insert(self.AllMusicScoreToMusic[MusicInfo.MusicScoreId], MusicId)
    end
    for _, MusicIds in pairs(self.AllMusicScoreToMusic) do
        table.sort(MusicIds,  function(a, b)
            return a < b
        end)
    end
end

function WBP_Piano_Main:GetAvatarUnLockMusic()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        self:Close()
        return
        -- Avatar = {}
        -- Avatar.HomeBaseBGM = 1001004
        -- Avatar.BGMs = {
        --     [1001001] = 1,
        --     [1001002] = 1,
        --     [1001003] = 1,
        --     [1001004] = 1,
        --     [1002001] = 1,
        --     [1002002] = 1,
        -- }
    end
    -- 当前选中的BGM
    self.CurrentHomeBaseBGM = Avatar.HomeBaseBGM
    self.Cur_SelectMusicId = self.CurrentHomeBaseBGM
    self.Cur_PlayMusicId = self.CurrentHomeBaseBGM
    local ReadMusicItemIds = EMCache:Get("PianoSystem_ReadMusicIds", true)
    local UnLockMusicScoreId = nil
    local MarkUnLockMusicScore = {}
    -- 已解锁的乐谱
    for UnLockMusicId, _ in pairs(Avatar.BGMs) do
        UnLockMusicScoreId = DataMgr.Music[UnLockMusicId].MusicScoreId
        if not MarkUnLockMusicScore[UnLockMusicScoreId] then
            MarkUnLockMusicScore[UnLockMusicScoreId] = 1
            table.insert(self.UnLockMusicScores, UnLockMusicScoreId)
            self.UnLockMusicScoreToItems[UnLockMusicScoreId] = {}
            self.UnLockMusicScoreToItems_Sort[UnLockMusicScoreId] = {}
            self.MusicScoreUnreadNum[UnLockMusicScoreId] = 0
        end
        self.UnLockMusicScoreToItems[UnLockMusicScoreId][UnLockMusicId] = 1
        table.insert(self.UnLockMusicScoreToItems_Sort[UnLockMusicScoreId], UnLockMusicId)
        if not ReadMusicItemIds or not ReadMusicItemIds[UnLockMusicId] then
            self.UnreadMusicItems[UnLockMusicId] = 1
            self.MusicScoreUnreadNum[UnLockMusicScoreId] = self.MusicScoreUnreadNum[UnLockMusicScoreId] + 1
        end
    end
    table.sort(self.UnLockMusicScores,  function(a, b)
        return a < b
    end)
    for _, MusicIds in pairs(self.UnLockMusicScoreToItems_Sort) do
        table.sort(MusicIds,  function(a, b)
            return a < b
        end)
    end
end

-- 读表格数据，全部加载，且上锁
function WBP_Piano_Main:InitList_Item()
    local AllMusicScoreInfos = DataMgr.MusicScore
    local MusicScoreIndex = 0
    local MusicScoreMarkTable = {}
    local CurHomeBaseBGMMusicScoreId = DataMgr.Music[self.CurrentHomeBaseBGM].MusicScoreId
    for _, UnLockMusicScoreId in pairs(self.UnLockMusicScores) do
        MusicScoreMarkTable[UnLockMusicScoreId] = 1
        local NewMusicScoreData = NewObject(UE4.LoadClass(UIConst.PianoMusicScoreData))
        NewMusicScoreData.Owner = self
        NewMusicScoreData.MusicScoreId = UnLockMusicScoreId
        NewMusicScoreData.bIsLocked = false
        NewMusicScoreData.Index = MusicScoreIndex
        NewMusicScoreData.ReddotNum = self.MusicScoreUnreadNum[UnLockMusicScoreId]
        NewMusicScoreData.bIsEmptyMusicScore = false
        self.List_Item:AddItem(NewMusicScoreData)
        if UnLockMusicScoreId == CurHomeBaseBGMMusicScoreId then
            self.Init_Select_ItemIndex = MusicScoreIndex
        end
        MusicScoreIndex = MusicScoreIndex + 1
    end
    for MusicScoreId, _ in pairs(AllMusicScoreInfos) do
        if not MusicScoreMarkTable[MusicScoreId] then
            local NewMusicScoreData = NewObject(UE4.LoadClass(UIConst.PianoMusicScoreData))
            NewMusicScoreData.Owner = self
            NewMusicScoreData.MusicScoreId = MusicScoreId
            NewMusicScoreData.bIsLocked = true
            NewMusicScoreData.Index = MusicScoreIndex
            NewMusicScoreData.ReddotNum = self.MusicScoreUnreadNum[MusicScoreId]
            NewMusicScoreData.bIsEmptyItem = false
            self.List_Item:AddItem(NewMusicScoreData)
            MusicScoreIndex = MusicScoreIndex + 1
        end
    end
    if MusicScoreIndex < 3 then
        local ExtraMusicItemNum = 3 - MusicScoreIndex
        for i= 1,ExtraMusicItemNum do
            local NewMusicScoreData = NewObject(UE4.LoadClass(UIConst.PianoMusicScoreData))
            NewMusicScoreData.bIsEmptyMusicScore = true
            self.List_Item:AddItem(NewMusicScoreData)
        end
    end
end

-- 设置其他UI控件绑定逻辑
function WBP_Piano_Main:InitOtherWidget()
    if self.Key_GamePad then
        self.Key_GamePad:CreateCommonKey(
            {
                KeyInfoList =
                {
                    {
                        Type = "Img",
                        Text = nil,
                        ImgShortPath = "Y",
                    }
                }
            }
        )
    end
    self.Btn_Music.OnClicked:Add(self, self.OnBtnClicked)
    self:InitCommonTab()
end

-- 根据platform和input device初始化 CommonTab
function WBP_Piano_Main:InitCommonTab()
    local TabConfigData = {
        TitleName = GText("HomePiano_HomePiano"),
        BackCallback = self.Close,
        OwnerPanel = self,
        DynamicNode = {"Back", "BottomKey"},
    }
    if self.isPC then
        TabConfigData["BottomKeyInfo"] = {
            {
                -- KeyInfoList = {{Type="Text", Text="非手柄不显示"}},
                GamePadInfoList = {{Type="Img", ImgShortPath="A"}},
                Desc=GText("HomePiano_PlayMusic")
            },
            {
                KeyInfoList = {{Type="Text", Text="Esc"}},
                GamePadInfoList = {{Type="Img", ImgShortPath="B"}},
                Desc=GText("HomePiano_GoBack")
            },
        }
    end
    self.Tab_Piano:Init(TabConfigData)
    self:RefreshIconAndGamePadVisibility()
end
--endregion


--region MusicScoreList点击逻辑
function WBP_Piano_Main:UpdateMusicScoreTextShow(NewIndex)
    if self.IsClosing then
        return
    end
    local SelectItem = self.List_Item:GetItemAt(NewIndex)
    if not SelectItem then
        return
    end
    self.BtnCouldShow = false
    self.BtnMusicCanClick = false
    self:UpdateMusicScoreRelatedUI(SelectItem.MusicScoreId)
end

function WBP_Piano_Main:OnSelectMusicScoreChanged(NewIndex)
    if self.IsClosing then
        return
    end
    local SelectItem = self.List_Item:GetItemAt(NewIndex)
    if not SelectItem then
        return
    end
    self.CurrentSelectMusicScore = SelectItem.MusicScoreId
    EventManager:FireEvent(EventID.ChangeSelectMusicScore, SelectItem.MusicScoreId)
    self:UpdateListMusic(SelectItem.MusicScoreId)
end

function WBP_Piano_Main:UpdateMusicScoreRelatedUI(NewMusicScoreId)
    self.Text_Title:SetText(GText(DataMgr.MusicScore[NewMusicScoreId].MusicScoreName))
    self:CollapseMusicItemDescribe()
end

-- 切换MusicScore更新List_Music
function WBP_Piano_Main:UpdateListMusic(NewMusicScoreId)
    self.List_Music:ClearListItems()
    local MusicIndex = 0
    if self.UnLockMusicScoreToItems[NewMusicScoreId] then
        for _, UnLockMusicId in pairs(self.UnLockMusicScoreToItems_Sort[NewMusicScoreId]) do
            local NewMusicData = NewObject(UE4.LoadClass(UIConst.PianoMusicItemData))
            NewMusicData.Owner = self
            NewMusicData.MusicId = UnLockMusicId
            NewMusicData.bIsLocked = false
            NewMusicData.Index = MusicIndex
            NewMusicData.NeedReddot = self.UnreadMusicItems[UnLockMusicId]
            self.List_Music:AddItem(NewMusicData)
            if UnLockMusicId == self.CurrentHomeBaseBGM then
                self.Init_Select_MusicIndex = MusicIndex
            end
            MusicIndex = MusicIndex + 1
        end
    end
    for _, MusicId in pairs(self.AllMusicScoreToMusic[NewMusicScoreId]) do
        if not self.UnLockMusicScoreToItems[NewMusicScoreId][MusicId] then
            local NewMusicData = NewObject(UE4.LoadClass(UIConst.PianoMusicItemData))
            NewMusicData.Owner = self
            NewMusicData.MusicId = MusicId
            NewMusicData.bIsLocked = true
            NewMusicData.Index = MusicIndex
            NewMusicData.NeedReddot = false
            self.List_Music:AddItem(NewMusicData)
            MusicIndex = MusicIndex + 1
        end
    end
end
--endregion


--region MusicList点击逻辑
function WBP_Piano_Main:UpdateMusicItemTextShow(NewIndex)
    if self.IsClosing then
        return
    end
    local SelectItem = self.List_Music:GetItemAt(NewIndex)
    if not SelectItem then
        return
    end
    self.BtnCouldShow = true
    self.BtnMusicCanClick = false
    self.Cur_SelectMusicId = SelectItem.MusicId
    if SelectItem.bIsLocked then
        self:UpdateMusicItemDescribe(DataMgr.Music[SelectItem.MusicId].PathDes, true)
    else
        self:UpdateMusicItemDescribe(DataMgr.Music[SelectItem.MusicId].MusicDes, false)
    end
    self:PlayAnimation(self.Switch_item)
end

function WBP_Piano_Main:ChangeCurrentPlayedMusicItem(NewIndex)
    if self.IsClosing then
        return
    end
    local SelectItem = self.List_Music:GetItemAt(NewIndex)
    if not SelectItem then
        return
    end
    if not SelectItem.bIsLocked then
        self.Cur_PlayMusicId = SelectItem.MusicId
        EventManager:FireEvent(EventID.ChangePlayedMusicItem, SelectItem.MusicId)
    end
    if self.BtnCouldShow then
        self:UpdateBtnVisbility()
        if self.InputDevice == ECommonInputType.Gamepad then
            self.Tab_Piano.BottomKeyWidget[1]:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        end
    end
    self.Book:FlipBook()
    if self.Cur_PlayMusicId == self.CurrentHomeBaseBGM then
        self:ChangeBtnMusicState(true)
    else
        self:ChangeBtnMusicState(false)
    end
    self:StopAnimation(self.Click)
end
--endregion


--region Btn_Music点击逻辑+Text

-- 将当前选中的Music设为据点默认BGM+修改文本+Forbid
function WBP_Piano_Main:OnBtnClicked()
    if self.IsClosing or not self.BtnMusicCanClick then
        return
    end
    if self.CurrentHomeBaseBGM == self.Cur_SelectMusicId then
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("HomePiano_SetAsHomeAlready"), 5)
        return
    end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    if not self.BtnMusic_IsSet then
        self:PlayAnimation(self.Click)
    end
    AudioManager(self):PlayUISound(self, "event:/ui/common/music_savor_change_btn_click", nil, nil)
    self.CurrentHomeBaseBGM = self.Cur_SelectMusicId
    Avatar:SetHomeBaseBGM(self.CurrentHomeBaseBGM)
    EventManager:FireEvent(EventID.ChangeStoredCustomBGM, self.CurrentHomeBaseBGM)
    self:ChangeBtnMusicState(true)
end

-- 已设置|设为据点音乐
function WBP_Piano_Main:ChangeBtnMusicState(bSet)
    if bSet == self.BtnMusic_IsSet then
        return
    end
    if bSet then
        self.TEXT_Btn:SetText(GText("HomePiano_AlreadySet"))
        self.Btn_Music:SetForbidden(true)
    else
        self.TEXT_Btn:SetText(GText("HomePiano_SetAsHome"))
        self.Btn_Music:SetForbidden(false)
    end
    self.BtnMusic_IsSet = bSet
end
--endregion Btn_Music点击逻辑


--region 乐曲文字+Lock状态+Btn显示状态
function WBP_Piano_Main:UpdateMusicItemDescribe(UpdateText, IsLocked)
    if IsLocked then
        self.Text_Lock:SetText(GText(UpdateText))
    else
        self.Text_Describe:SetText(GText(UpdateText))
    end
    self:UpdateLockState(IsLocked)
    self:UpdateBtnVisbility()
    self:RefreshTabShow(self.Cur_SelectMusicId, IsLocked)
end

function WBP_Piano_Main:UpdateLockState(bIsLock)
    if not self.TextShowNeedForceUpdate and bIsLock == self.IsShowingLockText then
        return
    end
    if bIsLock then
        self.Text_Describe:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        self.Panel_Btn:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        self.Hb_Lock:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    else
        self.Text_Describe:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        self.Panel_Btn:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        self.Hb_Lock:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end
    self.IsShowingLockText = bIsLock
    self.TextShowNeedForceUpdate = false
end

function WBP_Piano_Main:CollapseMusicItemDescribe()
    if self.TextShowNeedForceUpdate then
        return
    end
    self.Text_Describe:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    self.Panel_Btn:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    self.Hb_Lock:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    if self.InputDevice == ECommonInputType.Gamepad then
        self.Tab_Piano.BottomKeyWidget[1]:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end
    self.TextShowNeedForceUpdate = true
end

function WBP_Piano_Main:UpdateBtnVisbility()
    if self.Cur_SelectMusicId~=self.Cur_PlayMusicId then
        self.Panel_Btn:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        self.BtnMusicCanClick = false
    else
        self.Panel_Btn:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        self.BtnMusicCanClick = true
    end
end
--endregion

function WBP_Piano_Main:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if InKeyName == "Escape" then
        self:Close()
    end
    if InKeyName == UIConst.GamePadKey.FaceButtonRight then
        self:Close()
    end
    if InKeyName == UIConst.GamePadKey.FaceButtonTop then
        self:OnBtnClicked()
    end
    return UE4.UWidgetBlueprintLibrary.Handled()
end

--region GamePad and CommonTab

-- 绑定输入设备切换的委托
function WBP_Piano_Main:BindInputMethodChangedDelegate()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(GameInputModeSubsystem)) then
        GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.OnInputMethodChanged)
    end
end

function WBP_Piano_Main:UnBindInputMethodChangedDelegate()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(GameInputModeSubsystem)) then
        GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.OnInputMethodChanged)
    end
end

-- 输入设备切换触发的委托
function WBP_Piano_Main:OnInputMethodChanged(NewGameInputType, NewGamepadName)
    self.InputDevice = NewGameInputType
    self:RefreshIconAndGamePadVisibility()
end

function WBP_Piano_Main:RefreshIconAndGamePadVisibility()
    if not self.isPC then
        return
    end
    if self.InputDevice == ECommonInputType.Gamepad then
        -- self:ListMusicBindSelectChangeDelegate()
        if self.Key_GamePad then
            self.Key_GamePad:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        end
        self.Tab_Piano.BottomKeyWidget[1]:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    else
        -- self:ListMusicUnBindSelectChangeDelegate()
        if self.Key_GamePad then
            self.Key_GamePad:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        end
        self.Tab_Piano.BottomKeyWidget[1]:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end
    self:RefreshTabShow(self.Cur_SelectMusicId, self.IsShowingLockText)
end

-- A 播放 查看 消失
function WBP_Piano_Main:RefreshTabShow(SelectMusicId, IsLocked, SelectIndex)
    if self.InputDevice ~= ECommonInputType.Gamepad then
        return
    end
    if SelectMusicId==self.Cur_PlayMusicId then
        self.Tab_Piano.BottomKeyWidget[1]:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        if SelectIndex then
            self:ChangeCurrentSelectMusicItem(SelectIndex)
        end
    elseif IsLocked then
        self.Tab_Piano.BottomKeyWidget[1]:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    else
        self.Tab_Piano.BottomKeyWidget[1]:SetDescription(GText("HomePiano_PlayMusic"))
        self.Tab_Piano.BottomKeyWidget[1]:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    end
end
--endregion

-- Reddot
function WBP_Piano_Main:OnMusicItemNewStateChange(MusicId)
    self.UnreadMusicItems[MusicId] = nil
    self.ReadMusicItems[MusicId] = 1
end

function WBP_Piano_Main:List_Item_NavRight(NavigationDirection)
    if not self.Cur_PlayMusicId then
        self.List_Music:NavigateToIndex(0)
        return URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Music,0)
    end
    local MusicData = DataMgr.Music[self.Cur_PlayMusicId]
    if not MusicData or not MusicData.MusicScoreId then
        self.List_Music:NavigateToIndex(0)
        return URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Music,0)
    end
    local Cur_PlayMusicScoreId = MusicData.MusicScoreId
    if self.CurrentSelectMusicScore == Cur_PlayMusicScoreId then
        local temp_items = self.List_Music:GetListItems()
        for _,item in pairs(temp_items) do
            if item.MusicId == self.Cur_PlayMusicId then
                self.List_Music:BP_NavigateToItem(item)
                return URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Music,item.Index)
            end
        end
    end
    self.List_Music:NavigateToIndex(0)
    return URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Music,0)
end

return WBP_Piano_Main