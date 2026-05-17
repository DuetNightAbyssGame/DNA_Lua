--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"
local TimeUtils = require "Utils.TimeUtils"
-- local ItemPath = "/Game/UI/WBP/Armory/Widget/Record/WBP_Armory_Record_Item.WBP_Armory_Record_Item"
local ItemPath = "/Game/UI/WBP/Armory/Widget/Record/WBP_Armory_FileItem.WBP_Armory_FileItem"
local FileListPath = "/Game/UI/WBP/Armory/Widget/Record/WBP_Armory_FileList.WBP_Armory_FileList"
local ArmoryUtils = require "BluePrints.UI.WBP.Armory.ArmoryUtils"
local RecordTag = ArmoryUtils.FilesTabType[2]
local VoiceTag = ArmoryUtils.FilesTabType[1]
local CharModel = require "BluePrints.Common.MVC.Model.CharModel"
local SubItemIconPath = {
    [VoiceTag] = {
        [1] = "/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_NormalVoice.T_Tab_NormalVoice",
        [2] = "/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_BattleVoice.T_Tab_BattleVoice",
    },
    [RecordTag] = {
        [1] = "/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_File01.T_Tab_File01",
        [2] = "/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_File02.T_Tab_File02", 
        [3] = "/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_File03.T_Tab_File03",
        [4] = "/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_File04.T_Tab_File04",
        [5] = "/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_File05.T_Tab_File05",
    }
}
---@type WBP_Armory_File_P_C
local M = Class("BluePrints.UI.BP_UIState_C")
M._components = {
	"BluePrints.UI.WBP.Armory.MainComponent.Armory_PointerInputComponent",
}

function M:Initialize(Initializer)
    self.MainTabs = {
        {
            Text = GText(DataMgr.CharRecordTab[1].Text),
            IconPath = DataMgr.CharRecordTab[1].IconPath,
        },
        {
            Text = GText(DataMgr.CharRecordTab[2].Text),
            IconPath = DataMgr.CharRecordTab[2].IconPath,
        }
    }
    self.Languages = {
        CommonConst.SystemVoices.CN,
        CommonConst.SystemVoices.EN,
        CommonConst.SystemVoices.JP,
        CommonConst.SystemVoices.KR
    }
end

function M:Construct()
    M.Super.Construct(self)
    self.RecordTabs = {}
    for _, Data in ipairs(DataMgr.CharRecordType) do
        table.insert(self.RecordTabs,{Text = GText(Data.Text),Type = RecordTag})
    end
    self.RecordTabConfig = {
        Tabs = self.RecordTabs,
        SoundFunc = function()
            AudioManager(self):PlayUISound(self, "event:/ui/common/click_level_02", nil, nil)
        end,
    }
    self.CharVoiceTabs = {}
    for _, Data in ipairs(DataMgr.CharVoiceType) do
        table.insert(self.CharVoiceTabs,{Text = GText(Data.Text),Type = VoiceTag})
    end
    self.CharVoiceTabConfig = {
        Tabs = self.CharVoiceTabs,
        SoundFunc = function()
            AudioManager(self):PlayUISound(self, "event:/ui/common/click_level_02", nil, nil)
        end,
    }
    self.CurrentVoiceLanguage = CommonConst.SystemVoice
    self.OriginalVoiceLanguage = CommonConst.SystemVoice
    self.Tab_File:BindEventOnTabSelected(self,self.OnTopTabSelected)
    -- self:UnbindAllFromAnimationFinished(self.Auto_In)
    -- self:BindToAnimationFinished(self.Auto_In,{self,function ()
    --     self:BlockAllUIInput(false)
    -- end})
    self.Sort_Voice:BindEventOnSelectionsChanged(self,self.OnVoiceLanguageChanged)
    self:InitKeySetting()
    self:RefreshBaseInfo()
end

function M:Destruct()
    AudioManager(self):SetEventSoundParam(self, "CharVoice", {ToEnd=1})
    self:PlayAnimation(self.Out)
    if(self.Panel_File:IsVisible())then
        AudioManager(self):SetEventSoundParam(self, "CharRecord", {ToEnd=1})
        self:PlayAnimation(self.File_Out)
        self.Panel_File:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    if(self.Panel_Voice:IsVisible())then
        self:PlayAnimation(self.Voice_Out)
        self.Panel_Voice:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    local Language = AudioManager(self):GetLanguage(self.OriginalVoiceLanguage)
    UFMODBlueprintStatics.LoadBanksWithLanguage(Language)
    self.Super.Destruct(self)
end

function M:InitKeySetting()
    self.TopTabLeftKey = "Q"
    self.GamepadTopTabLeftKey = Const.GamepadLeftShoulder
    self.GamepadTopTabRightKey = Const.GamepadRightShoulder
    self.TopTabRightKey = "E"
    self.SubTabUpKey = "W"
    self.SubTabDownKey = "S"
    self.LeftMouseButton = "LeftMouseButton"
    self.Escape = "Escape"
    self.GamepadBackKey = Const.GamepadFaceButtonRight
    self.SortUpKey = Const.GamepadLeftThumbstick
    self.KeyDownEvent = {}
    self.KeyDownEvent[self.TopTabLeftKey] = self.OnTopTabLeftKeyDown
    self.KeyDownEvent[self.GamepadTopTabLeftKey] = self.OnTopTabLeftKeyDown
    self.KeyDownEvent[self.TopTabRightKey] = self.OnTopTabRightKeyDown
    self.KeyDownEvent[self.GamepadTopTabRightKey] = self.OnTopTabRightKeyDown
    self.KeyDownEvent[self.SubTabUpKey] = self.OnSubTabUpKeyDown
    self.KeyDownEvent[self.SubTabDownKey] = self.OnSubTabDownKeyDown
    self.KeyDownEvent[self.Escape] = self.OnBackKeyDown
    self.KeyDownEvent[self.GamepadBackKey] = self.OnBackKeyDown
    self.KeyDownEvent[self.LeftMouseButton] = self.OnMenuCloseKeyDown
    self.KeyDownEvent[self.SortUpKey] = self.OnSortUpKeyDown
end

function M:OnMenuCloseKeyDown()
    EventManager:FireEvent(EventID.OnMenuClose)
end

function M:OnMouseWheel(MyGeometry, MouseEvent)
    return self:OnMouseWheelScroll(MyGeometry, MouseEvent)
end

function M:OnMouseButtonDown(MyGeometry, MouseEvent)
    return self:OnPointerDown(MyGeometry, MouseEvent)
end

function M:OnMouseButtonUp(MyGeometry, MouseEvent)
    return self:OnPointerUp(MyGeometry, MouseEvent)
end

function M:OnMouseMove(MyGeometry, MouseEvent)
    return self:OnPointerMove(MyGeometry, MouseEvent)
end

function M:OnTouchEnded(MyGeometry, InTouchEvent)
    return self:OnPointerUp(MyGeometry, InTouchEvent)
end

function M:OnTouchMoved(MyGeometry, InTouchEvent)
    return self:OnPointerMove(MyGeometry, InTouchEvent)
end

function M:OnMouseCaptureLost()
    self:OnPointerCaptureLost()
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    self.Sort_Voice:ReceiveKeyDown_Lua(MyGeometry,InKeyEvent)
    if(self.KeyDownEvent[InKeyName])then
        EventManager:FireEvent(EventID.OnMenuClose)
        self.KeyDownEvent[InKeyName](self)
    end
    return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnTopTabLeftKeyDown()
    self.Tab_File:TabToLeft()
end

function M:OnTopTabRightKeyDown()
    self.Tab_File:TabToRight()
end

function M:OnBackKeyDown()
    if self.SelectedContent then
        if(self.SelectedContent.UI)then
            self.SelectedContent.UI:OnCellClicked()
        end
        self.SelectedContent = nil
    end
    -- self:BlockAllUIInput(true)
    -- if self.SelectedContent then
    --     if(self.SelectedContent.UI)then
    --         self.SelectedContent.UI:SetIsSelected(false)
    --     end
    --     self.SelectedContent = nil
    -- end
    --手柄语音返回
    if(self.CurInputDevice == ECommonInputType.Gamepad) and self.Panel_Voice:IsVisible() then
        self:PlayAnimation(self.Voice_Out)
        self:OnCharVoiceEnd()
        return
    end
    if(self.Panel_File:IsVisible()) and CommonUtils.GetDeviceTypeByPlatformName(self) ~= "Mobile" then
        AudioManager(self):SetEventSoundParam(self, "CharRecord", {ToEnd=1})
        self:PlayAnimation(self.File_Out)
        self:RefreshScrollGamepadVisibility(false)
        return
    end
    self:AddTimer(0.25,function()
        self:Close()
    end)
end

function M:OnBackBtnClicked()
    if self.SelectedContent then
        if(self.SelectedContent.UI)then
            self.SelectedContent.UI:SetIsSelected(false)
        end
        self.SelectedContent = nil
    end
    self:AddTimer(0.15,function()
        self:Close()
    end)
end

function M:Close()
    self:ClearPlayingVoice()
    CommonConst.ArmoryVoice = nil
    if(self.CurrentSubTabWidget)then
        if(self.CurrentTopTabType == RecordTag)then
            local len = self.Contents and #self.Contents or 0
            local Items = self.Contents
            for i=1,len do
                if(not Items[i].IsEmptyItem and not Items[i].IsLocked)then
                    ArmoryUtils:SetReddotRead(Items[i])
                end
            end
        end
    end
    self:RemoveReddotlisten()
    self.Super.Close(self)
    local ArmoryMain = UIManager(self):GetArmoryUIObj()
    if(ArmoryMain)then
        ArmoryMain:UpdateMontageAndCamera()
    end
    -- self:PlayAnimation(self.Out)
end

function M:InitUIInfo(Name, IsInUIMode, EventList, ...)
    M.Super.InitUIInfo(self, Name, IsInUIMode, EventList, ...)
    self.Parent,self.Char,self.InitTabName,self.bEnableReddot = ...
    local ArmoryMain = UIManager(self):GetArmoryUIObj()
    if(ArmoryMain)then
        self.ArmoryPlayer = ArmoryMain.ActorController.ArmoryPlayer
    end
    local Avatar = GWorld:GetAvatar()
    if Avatar.Sex == 1 then
        local Icon = LoadObject("Texture2D'/Game/UI/Texture/Dynamic/Image/Head/Mini/T_Normal_Mini_Nvzhu.T_Normal_Mini_Nvzhu'")
        self.Icon_Head_Main:SetBrushResourceObject(Icon)
    else
        local Icon = LoadObject("Texture2D'/Game/UI/Texture/Dynamic/Image/Head/Mini/T_Normal_Mini_Nanzhu.T_Normal_Mini_Nanzhu'")
        self.Icon_Head_Main:SetBrushResourceObject(Icon)
    end
    self:Init(self.Char)
    -- self:BlockAllUIInput(true)
    self.IsFirstOpen = true
    if(ArmoryUtils.FilesTabType[1] == self.InitTabName)then
        self.Tab_File:SelectTab(1)
    else
        self.Tab_File:SelectTab(2)
    end
    AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "CharVoice", nil)
end

function M:AddReddotListen()
    if not self.bEnableReddot then return end
    if not self.ReddotNames then self.ReddotNames = {} end
    local TabCallback = function(Count,TabConf,TabWidget,Type)
        TabConf[Type].IsNew = Count > 0
        if(TabWidget and TabWidget.Idx == Type) then
            TabWidget:SetReddot(Count>0)
        end
    end
    local CharId = self.Char.CharId
    ---档案子Tab红点监听
    local CharacterData = DataMgr.CharacterDataTarget[CharId]
    -- for RecordType ,_ in ipairs(self.RecordTabs) do
    --     if not CharacterData then break end
    --     local NodeName = table.concat({RecordTag, CharId, RecordType},"_")
    --     if ReddotManager.GetTreeNode(NodeName) then
    --         ReddotManager.AddListener(NodeName,self,function(self, Count)
    --             TabCallback(Count,self.RecordTabs, self.CurrentSubTabWidget, RecordType)
    --         end)
    --         self.ReddotNames[NodeName] = 1
    --     end
    -- end
    -- ---声音子Tab红点监听
    -- local CharVoiceData = DataMgr.CharVoice[CharId]
    -- for VoiceType, _ in ipairs(self.CharVoiceTabs) do
    --     if not CharVoiceData then break end
    --     local NodeName = table.concat({VoiceTag, CharId, VoiceType}, "_")
    --     if ReddotManager.GetTreeNode(NodeName) then
    --         ReddotManager.AddListener(NodeName,self,function(self, Count)
    --             TabCallback(Count,self.CharVoiceTabs, self.CurrentSubTabWidget, VoiceType)
    --         end)
    --         self.ReddotNames[NodeName] = 1
    --     end
    -- end
    ---主Tab红点监听
    for Idx, TabTag in ipairs(ArmoryUtils.FilesTabType) do
        if Idx==1 then
            goto continue
        end
        local LeafNodes = {}
        local NodeName = table.concat({TabTag,CharId}, "_")
        -- for VoiceType ,_ in ipairs(self.CharVoiceTabs) do
        --     if TabTag ~= VoiceTag then break end
        --     local LeafNodeName = table.concat({VoiceTag, CharId, VoiceType,}, "_")
        --     LeafNodes[LeafNodeName] = ReddotManager.GetTreeNode(LeafNodeName) and 1 or nil
        -- end
        for RecordType ,_ in ipairs(self.RecordTabs) do
            if TabTag ~= RecordTag then break end
            local LeafNodeName = table.concat({RecordTag,CharId, RecordType}, "_")
            LeafNodes[LeafNodeName] = ReddotManager.GetTreeNode(LeafNodeName) and 1 or nil
        end
        if not self.ReddotNames[NodeName] and not IsEmptyTable(LeafNodes) then
            ReddotManager.AddListener(NodeName, self, function(self, Count)
                TabCallback(Count, self.MainTabs, self.CurrentTopTabWidget, Idx)
            end, LeafNodes)
            self.ReddotNames[NodeName] = 1
        end
        ::continue::

    end
end

function M:RemoveReddotlisten()
    for NodeName,_ in pairs(self.ReddotNames or {}) do
        ReddotManager.RemoveListener(NodeName, self)
    end
end

function M:Init(Char)
    local ArmoryMain = UIManager(self):GetArmoryUIObj()
    if(ArmoryMain)then
        ArmoryMain.ActorController:SetArmoryCameraTag("Char","Files","Detail")
    end
    local AttrName = DataMgr.BattleChar[Char.CharId].Attribute
    self.Text_RoleName:SetText(GText(Char.CharName))
    self.RoleName = Char.CharName
    local IconName = "Armory_" .. AttrName
    local AttributeIcon = LoadObject('/Game/UI/Texture/Dynamic/Atlas/Armory/T_' .. IconName .. ".T_" ..IconName)
    self.Image_Attribute:SetBrushResourceObject(AttributeIcon or LoadObject('/Game/UI/Texture/Dynamic/Atlas/Armory/T_Armory_Default.T_Armory_Default'))
    local Info = DataMgr.BattleChar[Char.CharId].GuideIconImg
    local IconPath = '/Game/UI/Texture/Dynamic/Image/Head/Mini/'..'T_Normal_'..Info
    local Obj = LoadObject(IconPath)
    self.Icon_Head_Avatar:SetBrushResourceObject(Obj)
    self:AddReddotListen()

    self.TopTabConfigData = {
        TitleName = GText("UI_Armory_Information"),
        LeftKey = "Q",
        RightKey = "E",
        Tabs = self.MainTabs,
        DynamicNode={
            "Back",
            "ResourceBar",
            -- "Tip",
            "BottomKey",
        },
        BottomKeyInfo = {
            -- { 
            --     GamePadInfoList =  {{ Type="Img", ImgShortPath="RV", Owner=self }},
            --     Desc = GText("UI_Controller_Slide"),
            --     bLongPress = false,
            -- },
            {
                GamePadInfoList =  {{ Type="Img", ImgShortPath="A", Owner=self }},
                Desc = GText("UI_Tips_Ensure"),
                bLongPress = false,
            },
            {KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.OnBackBtnClicked, Owner=self}},
            GamePadInfoList = {{Type="Img", ImgShortPath="B", ClickCallback=self.OnBackKeyDown}},
            Desc = GText("UI_BACK"), bLongPress = false}
        },
        StyleName = CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" and "Armory" or "Text",
        BackCallback = self.OnBackBtnClicked,
        OwnerPanel = self,
    }
    self.LastTopTabType = nil
    self.CurrentTopTabType = nil
    self.LastSubTabWidget = nil
    self.CurrentSubTabWidget = nil
    self.Tab_File:Init(self.TopTabConfigData,true)
    self.Tab_File:PlayTabInAnim()
    self.Tab_File:UpdateReddots()
    self:InitCharInfos()
end

---初始化左下角色信息
function M:InitCharInfos()
    local CharData = DataMgr.CharacterData[self.Char.CharId]
    if(CharData)then
        self.Gender:SetText(GText("UI_Chardata_Char_Sex")..": ",GText((not CharData.CharSex and "UI_Chardata_Char_Male") or "UI_Chardata_Char_Female"))
        self.BirthPlace:SetText(GText("UI_Chardata_Char_BrithPlace")..": ",GText(CharData.CharBirth))
        local year,month,day = TimeUtils.ExcelTimestampToLuaData(CharData.CharBirthday)
        self.BirthDate:SetText(GText("UI_Chardata_Char_Brithday")..": ",GDate("Date_MD", {Year=year, Month=month, Day=day}, CommonConst.SystemLanguage))
        self.Force:SetText(GText("UI_Chardata_Char_Force")..": ",GText(CharData.CharForce))

        self.Language2Idx = {}
        self.LanguageDownloadedList = {}
        self.LanguageDisplayList = {}
        local CacheName = TArray("")
        for i, value in ipairs(self.Languages) do
            CacheName:Add(value)
        end
        local HotUpdateSubsystem = USubsystemBlueprintLibrary.GetGameInstanceSubsystem(self, UHotUpdateSubsystem)
        local VoiceDownloadedRes = HotUpdateSubsystem:IsVoicesDownloaded(CacheName):ToTable()
        for i, value in ipairs(self.Languages) do
            if VoiceDownloadedRes[value] then
                table.insert(self.LanguageDisplayList,GText("UI_Voice_Actor_" .. value) .. ": " .. GText(CharData["Cv" .. value .. "Name"] or ""))
                self.Language2Idx[value] = #self.LanguageDisplayList
                table.insert(self.LanguageDownloadedList, value)
            end
        end
        self.Sort_Voice:Init(self.LanguageDisplayList, "LS", self)
        self.Sort_Voice:SelectItem(self.Language2Idx[self.CurrentVoiceLanguage])
    end
end

function M:OnLoaded(...)
    self.Super.OnLoaded(self, ...)
    self:BlockAllUIInput(false)
    self:SetFocus()
end

---顶部Tab选中时
function M:OnTopTabSelected(TabWidget,Content)
    EventManager:FireEvent(EventID.OnMenuClose)
    self:ClearPlayingVoice()
    self.LastTopTabWidget = self.CurrentTopTabWidget
    self.CurrentTopTabWidget = TabWidget
    self.LastTopTabType = self.CurrentTopTabType
    self.CurrentTopTabType = ArmoryUtils.FilesTabType[TabWidget.Idx]
    if(self.SelectedSubTab)then
        self.SelectedSubTab.Widget:SetIsSelected(false)
        self.SelectedSubTab = nil
    end
    if self.SelectedContent then
        if(self.SelectedContent.UI)then
            self.SelectedContent.UI:SetIsSelected(false)
        end
        self.SelectedContent = nil
    end
    if self.IsFirstOpen then
        self:PlayAnimation(self.In)
    end

    self:AddTimer(0.15,function()
        self:InitSubTabs()
    end)
end

function M:InitSubTabs()
    local subTabs = self[self.CurrentTopTabType .. "Tabs"] or {}
    self.List_Tab:ClearListItems()
    self.List_Tab:SetVisibility(UIConst.VisibilityOp.Visible)
    
    -- 如果是Record类型，需要提前获取角色的CharDataTarget数据用于判断某个tab是否有内容
    local CharDataTarget = nil
    if self.CurrentTopTabType == RecordTag then
        CharDataTarget = DataMgr.CharacterDataTarget[self.Char.CharId]
    end
    
    local firstValidIdx = nil
    for i, subTab in ipairs(subTabs) do
        -- 如果是Record类型，检查该tab类型是否有数据
        local shouldAdd = true
        if self.CurrentTopTabType == RecordTag then
            shouldAdd = false
            if CharDataTarget then
                for _, Data in pairs(CharDataTarget) do
                    if Data.CharDataType == i then
                        shouldAdd = true
                        break
                    end
                end
            end
        end
        
        if shouldAdd then
            if not firstValidIdx then
                firstValidIdx = i
            end
            local Item = NewObject(UIUtils.GetCommonItemContentClass())
            Item.Idx = i  -- 保持原始索引，确保CharDataType筛选正确
            Item.Text = subTab.Text
            Item.Parent = self
            Item.OnClicked = self.OnSubTabClicked
            Item.OnAddedToFocusPath = {
                Obj = self,
                Callback = self.OnSubTabAddedToFocusPath,
                Params = Item
            }
            Item.IconPath = SubItemIconPath[subTab.Type][i]
            Item.Info = subTab
            Item.IsSelected = (i == firstValidIdx)
           -- Item.IsNew=ReddotManager.GetTreeNode(table.concat({subTab.Type, self.Char.CharId, i}, "_"))
            Item.TabType=self.CurrentTopTabType
            Item.CharId=self.Char.CharId
            self.List_Tab:AddItem(Item)
        end
    end

    self.List_Tab:RegenerateAllEntries()
    if not self.IsFirstOpen then
        self.List_Tab:RequestPlayEntriesAnim()
        self:PlayAnimation(self.Tab_Switch)
        self.IsTabSwitching = true
    end
    -- 默认选中第一个子Tab
    self:AddTimer(0.1, function()
        self.List_Tab:SetFocus()
        local firstItem = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Tab, 0)
        if firstItem then
            self.AutoSelectSubTab = true
            firstItem:Btn_Clicked()
        end
    end)
end

-- 处理子Tab点击事件
function M:OnSubTabClicked(Item)
    if not Item then return end
    if(self.SelectedSubTab == Item)then
        if self.AutoSelectSubTab then
            self.AutoSelectSubTab = false
        else
            if self.CurInputDevice == ECommonInputType.Gamepad then
                self.ScrollBox_File:SetFocus()
            end
        end
        return
    else
        if(self.SelectedSubTab)then
            self.SelectedSubTab.Widget:SetIsSelected(false)
        end
        Item.Widget:SetIsSelected(true)
        self.SelectedSubTab = Item
    end
    if not self.AutoSelectSubTab then
        AudioManager(self):PlayUISound(self, "event:/ui/armory/click_crystal_btn_tab", nil, nil)
    end
    if self.IsFirstOpen then
        self.IsFirstOpen = false
    else
        if self.IsTabSwitching then
            self.IsTabSwitching = false
        else
            self:PlayAnimation(self.List_Change)
        end
    end
    self:OnSubTabSelected(Item)
end

function M:OnSubTabAddedToFocusPath(Item)
    if not self.AutoSelectSubTab and self.CurInputDevice == ECommonInputType.Gamepad then
        self.AutoSelectSubTab = true
        Item.Widget:Btn_Clicked()
    end
end

---设置条目已读
function M:SetItemReddotRead(Content)
    ArmoryUtils:SetReddotRead(Content,true)
end

function M:ChangeSelectedContent(Content)
    if(self.SelectedContent == Content)then
        self.SelectedContent = nil
    else
        if(self.SelectedContent)then
            if(self.SelectedContent.UI)then
                self.SelectedContent.UI:SetIsSelected(false)
            end
        end
        self.SelectedContent = Content
    end
end

---资料子Tab选中时
function M:OnRecordSubTabSelected(TabWidget)
    self.Sort_Voice:SetVisibility(UIConst.VisibilityOp.Collapsed)
    if(self.Panel_Voice:IsVisible())then
        self:PlayAnimation(self.Voice_Out)
    end
    self.ScrollBox_File:ClearChildren()
    local CharDataTarget = DataMgr.CharacterDataTarget[self.Char.CharId]
    if(not CharDataTarget)then
        return
    end
    local UIMgr = UIManager(self)
    local FileList = UIMgr:CreateWidget(FileListPath)
    local CharDataType = TabWidget.Idx
    local Datas = {}
    for _, Data in pairs(CharDataTarget) do
        if(Data.CharDataType == CharDataType)then
            table.insert(Datas,Data)
        end
    end
    table.sort(Datas,function(a,b)
        return a.CharDataTarget < b.CharDataTarget
    end)
    
    local Params = {
        Parent = self,
        Title = TabWidget.Text,
        Datas = Datas,
    }
    FileList:Init(Params)
    self.ScrollBox_File:AddChild(FileList)
    local TypeIdx = 1
    local UIMgr = UIManager(self)
    self.Contents = {}
    for Idx, Data in ipairs(Datas) do
        local Obj = {}--NewObject(UIUtils.GetCommonItemContentClass())
        Obj.Type = RecordTag
        -- Obj.Title = GText(TabWidget.Info.Text) .. GText("UI_Chardata_Data_Of") .. GText("UI_Chardata_Data_Num_"..TypeIdx)
        local perfix = Data.CharDataName and Data.CharDataName[1] or " "
        local suffix = Data.CharDataName and Data.CharDataName[2] or " "
        if perfix == " " and suffix == " " then
            print("Error: 档案前后缀皆空")
        end
        Obj.Title = GText(perfix) .. GText(suffix)
        Obj.SubTitle = GText(Data.CharDataTargetDescribe)
        Obj.Parent = self
        Obj.OnClicked = self.OnListItemClicked
        Obj.IsLocked = false
        Obj.IsSelected = false
        Obj.IsLocked =not ArmoryUtils:CheckCharRecoedUnlock(Data.CharId,Data.CharDataTarget,CharModel)
        if(not Obj.IsLocked)then
            local WildcardSubsystem = UWildcardGameInstanceSubsystem.GetSubsystem(GWorld.GameInstance)
            Obj.Details = WildcardSubsystem:ReplaceWildcard(GText(Data.CharText))
        else
            if Data.CharDataTargetDescribe then
                Obj.Title=GText(Data.CharDataTargetDescribe)
            end
        end
        --Obj.IsNew = ArmoryUtils:TryAddNewRecordReddot(Data, table.concat({self.Char.CharId,Data.CharDataTarget},"_")) and self.bEnableReddot
        Obj.CharDataTarget = Data.CharDataTarget
        Obj.CharDataType=Data.CharDataType
        Obj.CharId = self.Char.CharId
        local Widget = UIMgr:CreateWidget(ItemPath)
        Widget:OnListItemObjectSet(Obj)
        FileList:AddToContentList(Widget)
        table.insert(self.Contents,Obj)
        TypeIdx = TypeIdx + 1
    end
    self.ScrollBox_File:ScrollToStart()
    if self.AutoSelectSubTab then
        self.AutoSelectSubTab = false
    else
        if self.CurInputDevice == ECommonInputType.Gamepad then
            self.ScrollBox_File:SetFocus()
        end
    end
end

---语音子Tab选中时
function M:OnCharVoiceSubTabSelected(TabWidget)
    if self.CurInputDevice == ECommonInputType.Gamepad then
        self.Sort_Voice:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    else
        self.Sort_Voice:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
    -- self.Panel_File:SetVisibility(UIConst.VisibilityOp.Collapsed)
    if(self.Panel_File:IsVisible())then
        AudioManager(self):SetEventSoundParam(self, "CharRecord", {ToEnd=1})
        self:PlayAnimation(self.File_Out)
    end
    self.ScrollBox_File:ClearChildren()
    local VoiceDatas = DataMgr.CharVoice[self.Char.CharId]
    if(not VoiceDatas)then
        return
    end
    local UIMgr = UIManager(self)
    local FileList = UIMgr:CreateWidget(FileListPath)
    local Params = {
        Parent = self,
        Title = TabWidget.Text,
    }
    FileList:Init(Params)
    self.ScrollBox_File:AddChild(FileList)
    
    local VoiceType = TabWidget.Idx
    local Avatar = GWorld:GetAvatar()
    local Datas = {}
    for _, Data in pairs(VoiceDatas) do
        if(Data.VoiceType == VoiceType)then
            table.insert(Datas,Data)
        end
    end
    table.sort(Datas,function(a,b)
        return a.VoiceId < b.VoiceId
    end)
    local UIMgr = UIManager(self)
    self.Contents = {}
    for Idx, Data in ipairs(Datas) do
        local Obj = {}--NewObject(UIUtils.GetCommonItemContentClass())
        Obj.Type = VoiceTag
        Obj.CharId = self.Char.CharId
        Obj.VoiceId = Data.VoiceId
        Obj.ReddotType = Data.VoiceType
        local Des = ""
        if(Data.VoiceDes)then
            for _, value in ipairs(Data.VoiceDes) do
                Des = Des .. GText(value)
            end
        end
        Obj.Parent = self
        Obj.OnClicked = self.OnListItemClicked
        Obj.IsLocked = false
        Obj.IsSelected = false
        Obj.IsPlaying = false
        Obj.Title = Des
        if Data.VoiceChar then   --有皮肤标识的语音，单独受皮肤影响
            local CurrentSkinTag = self:GetCharSkinTag()
            if Data.VoiceChar ~= CurrentSkinTag then goto continue end -- 皮肤不匹配，跳过
        end

        -- 如果有UnlockDialogue条件，检查是否需要锁定
        if Data.UnlockDialogue then
            Obj.UnlockDialogue = Data.UnlockDialogue
            local DialogueUnlocked = Avatar:CheckSignBoardNpcTalkIsRecord(Data.UnitId, Data.UnlockDialogue)
            -- 对话未解锁且无强制解锁条件时，设为锁定状态
            if not DialogueUnlocked and (not Data.UnlockOption or not ConditionUtils.CheckCondition(Avatar, Data.UnlockOption, false)) then
                Obj.IsLocked = true
                Obj.Title = GText(Data.LockedDes)
            end
        else
            if Data.UnlockOption then
                local IsUnlocked = ConditionUtils.CheckCondition(Avatar, Data.UnlockOption, false)
                if not IsUnlocked then
                    Obj.IsLocked = true
                    Obj.Title = GText(Data.LockedDes)
                end
            end
        end
        
        --Obj.IsNew = ArmoryUtils:TryAddNewCharVoiceReddot(Data, table.concat({self.Char.CharId, Data.VoiceId}, "_")) and self.bEnableReddot
        if(not Obj.IsLocked)then
            local WildcardSubsystem = UWildcardGameInstanceSubsystem.GetSubsystem(GWorld.GameInstance)
            Obj.Details = WildcardSubsystem:ReplaceWildcard(GText(Data.VoiceText and Data.VoiceText[1]))
            Obj.VoiceRes = Data.VoiceRes and Data.VoiceRes[1]
            -- local Dialogue = DataMgr.Dialogue[90030001]--TEST
            -- Obj.CharDetails = GText(Dialogue.Content)
            if Data.Dialogue then
                --如果有主角对话
                local Dialogue = DataMgr.Dialogue[Data.Dialogue]
                Obj.CharDetails = GText(Dialogue.Content)
            end
        end
        Obj.OnBtnClicked = self.OnPlayVoiceBtnClicked
        Obj.IsShowBtnPlay = true
        local Widget = UIMgr:CreateWidget(ItemPath)
        Widget:OnListItemObjectSet(Obj)
        FileList:AddToContentList(Widget)
        table.insert(self.Contents,Obj)
        ::continue::
    end

    self.ScrollBox_File:ScrollToStart()
    if self.AutoSelectSubTab then
        self.AutoSelectSubTab = false
    else
        if self.CurInputDevice == ECommonInputType.Gamepad then
            self.ScrollBox_File:SetFocus()
        end
    end
end

function M:GetCharSkinTag()
    local Appearance = self.Char:GetAppearance(self.Char.CurrentAppearanceIndex)
    if not Appearance then return nil end
    local SkinData = DataMgr.Skin[Appearance.SkinId]
    if SkinData and SkinData.SkinTag then
        return SkinData.SkinTag
    end
    return nil
end

-- function M:GetNpcIdByCharId(CharId)
--     local NPCDatas = DataMgr.Npc
--     for _, Data in pairs(NPCDatas) do
--         if(Data.CharId == CharId)then
--             return Data.ModelId
--         end
--     end
--     return nil
-- end

-- function M:FillEmptyItems(Count)
--     local UIMgr = UIManager(self)
--     for i = 1, Count do
--         local Obj = {}--NewObject(UIUtils.GetCommonItemContentClass())
--         Obj.IsEmptyItem = true
--         local Widget = UIMgr:CreateWidget(ItemPath)
--         Widget:OnListItemObjectSet(Obj)
--         -- self.ScrollBox:AddChild(Widget)
--     end
-- end
---列表项点击时
function M:OnListItemClicked(Content)
    -- EventManager:FireEvent(EventID.OnMenuClose)
    if(Content.IsLocked)then
        ConditionUtils.CheckCondition(GWorld:GetAvatar(),Content.UnlockCondition,true)
        return
    end
    if(Content.IsSelected)then
        AudioManager(self):PlayUISound(self, "event:/ui/armory/click_crystal_btn_content", nil, nil)
    end
    if(Content.IsNew)then
        self:SetItemReddotRead(Content)
    end
    self:ChangeSelectedContent(Content)
    if(self["On"..self.CurrentTopTabType .."ItemClicked"])then
        self["On"..self.CurrentTopTabType .."ItemClicked"](self,Content)
    end
end

function M:OnPlayVoiceBtnClicked(Content)
    if(not Content)then
        return
    end
    self:ChangeVoicePlayingContent(Content)
    if(not Content.IsPlaying)then
        self:OnCharVoiceEnd()
    else
        if self.VoiceEventInstance then self.VoiceEventInstance = nil end
        self:SetItemReddotRead(Content)
        local AudioManager = AudioManager(self)
        local Language = AudioManager:GetLanguage(self.CurrentVoiceLanguage)
        local OriginModelId = self.ArmoryPlayer.GetOriginModelId and self.ArmoryPlayer:GetOriginModelId() or 0
        local CharName = DataMgr.CharVoice[Content.CharId][Content.VoiceId].VoiceChar or AudioManager:GetPlayerName_CPP(OriginModelId, OriginModelId)
        self.VoiceEventInstance = AudioManager:PlayCharVoice(self.ArmoryPlayer, CharName,
        Content.VoiceRes,Language,"ArmoryRoleVoice",true)
    end
end

function M:OnCharVoiceItemClicked(Content)
    if(not Content)then
        return
    end
    if not Content.IsSelected then
        self:PlayAnimation(self.Voice_Out)
    else
        if(self.Panel_Voice:IsVisible() and not self:IsPlayingAnimation(self.Voice_Out))then
            self:PlayAnimation(self.Voice_Switch)
        else
            self:PlayAnimation(self.Voice_In)
        end
    end
    self.Text_Name:SetText(GText(self.RoleName))
    if Content.CharDetails then
        self.Text_Voice_Main:SetText(Content.CharDetails)
        self.Voice_Main:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
        self.Voice_Main:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    self.Text_Voice:SetText(Content.Details)
end

function M:OnRecordItemClicked(Content)
    if(not Content)then
        return
    end
    if not Content.IsSelected then
        AudioManager(self):SetEventSoundParam(self, "CharRecord", {ToEnd=1})
        self:PlayAnimation(self.File_Out)
        self:RefreshScrollGamepadVisibility(false)
    else
        AudioManager(self):PlayUISound(self, "event:/ui/common/reading_hud", "CharRecord", nil)
        if(self.Panel_File:IsVisible() and not self:IsPlayingAnimation(self.File_Out))then
            self:PlayAnimation(self.File_Change)
        else
            self:PlayAnimation(self.File_In)
        end
        self:AddTimer(self.File_In:GetEndTime(), function()
            self:RefreshScrollGamepadVisibility(true)
        end)
    end
    self.Text_FileTitle:SetText(Content.Title)
    self.Text_FileDetail:SetText(Content.Details)
    self.ScrollBox_FileDetail:ScrollToStart()
end

function M:RefreshScrollGamepadVisibility(bFileIn)
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then return end
    if bFileIn and UIUtils.CheckScrollBoxCanScroll(self.ScrollBox_FileDetail) then
            self.Tab_File:UpdateBottomKeyInfo({
                {
                    GamePadInfoList =  {{ Type="Img", ImgShortPath="RV", Owner=self }},
                    Desc = GText("UI_Controller_Slide"),
                    bLongPress = false,
                },
                {
                    GamePadInfoList =  {{ Type="Img", ImgShortPath="A", Owner=self }},
                    Desc = GText("UI_Tips_Ensure"),
                    bLongPress = false,
                },
                {KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.OnBackBtnClicked, Owner=self}},
                GamePadInfoList = {{Type="Img", ImgShortPath="B", ClickCallback=self.OnBackKeyDown}},
                Desc = GText("UI_BACK"), bLongPress = false}
        })
    else
        self.Tab_File:UpdateBottomKeyInfo({
            {
                GamePadInfoList =  {{ Type="Img", ImgShortPath="A", Owner=self }},
                Desc = GText("UI_Tips_Ensure"),
                bLongPress = false,
            },
            {KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.OnBackBtnClicked, Owner=self}},
            GamePadInfoList = {{Type="Img", ImgShortPath="B", ClickCallback=self.OnBackKeyDown}},
            Desc = GText("UI_BACK"), bLongPress = false}
        })
    end
end

function M:Tick()
    if(self.VoiceEventInstance)then
        local AudioManager = AudioManager(self)
        local Position = AudioManager:GetEventInstanceTimelinePosition(self.VoiceEventInstance)
        local Length = AudioManager:GetEventInstanceLength(self.VoiceEventInstance)
        if Position >= Length then
            self:OnCharVoiceEnd()
        end
    end
end

function M:ChangeVoicePlayingContent(Content)
    if not Content then return end
    if self.VoicePlayingContent and self.VoicePlayingContent ~= Content then
        self.VoicePlayingContent.IsPlaying = false
        self.VoicePlayingContent.UI:SetIsPlaying(false)
    end
    self.VoicePlayingContent = Content
    if Content.IsPlaying then
        Content.UI:SetIsPlaying(false)
        Content.IsPlaying = false
    else
        Content.UI:SetIsPlaying(true)
        Content.IsPlaying = true
    end
end

function M:ClearPlayingVoice()
    self:OnCharVoiceEnd()
end

function M:OnCharVoiceEnd()
    if(self.VoiceEventInstance)then
        AudioManager(self):StopSound(self.ArmoryPlayer,"ArmoryRoleVoice")
    end
    -- 语音结束清除选中
    if self.SelectedContent then
        if self.SelectedContent.UI then
            self.SelectedContent.UI:OnCellClicked()
        end
        self.SelectedContent = nil
    end
    self.VoiceEventInstance = nil
    self.VoicePlayingContent = nil
end

function M:OnVoiceLanguageChanged(VoiceActorIndex)
    self.CurrentVoiceLanguage =  self.LanguageDownloadedList[VoiceActorIndex]
    CommonConst.ArmoryVoice = self.CurrentVoiceLanguage
    local Language = AudioManager(self):GetLanguage(self.CurrentVoiceLanguage)
    UFMODBlueprintStatics.LoadBanksWithLanguage(Language)
    self:ClearPlayingVoice()
end

function M:OnSubTabSelected(TabWidget)
    self.SelectedContent = nil
    self.VoicePlayingContent = nil
    if self.Panel_File:IsVisible() then
        AudioManager(self):SetEventSoundParam(self, "CharRecord", {ToEnd=1})
        self:PlayAnimation(self.File_Out)
        self:RefreshScrollGamepadVisibility(false)
    end
    if self.Panel_Voice:IsVisible() then
        self:PlayAnimation(self.Voice_Out)
    end
    self:ClearPlayingVoice()
    self.LastSubTabWidget = self.CurrentSubTabWidget
    self.CurrentSubTabWidget = TabWidget
    if(self.LastSubTabWidget)then
        if(self.LastSubTabWidget.Info.Type == RecordTag)then
            --档案页整页设为已读
            local len = #self.Contents
            local Items = self.Contents
            for i=1,len do
                if(not Items[i].IsEmptyItem and not Items[i].IsLocked)then
                    --ArmoryUtils:SetReddotRead(Items[i],true)
                end
            end
           -- self.LastSubTabWidget.Widget:SetReddot(false)
        end
    end
    local TabType = self.CurrentTopTabType
    if(TabType and self["On" .. TabType .. "SubTabSelected"])then
        self["On" .. TabType .. "SubTabSelected"](self,TabWidget)
    end
end

function M:OnSubTabLeftKeyDown()
    self.Tab_File:TabToLeft()
end

function M:OnSubTabRightKeyDown()
    self.Tab_File:TabToRight()
end

function M:OnSubTabUpKeyDown()
    local SubTabIdx = self.SelectedSubTab.Idx
    if(SubTabIdx > 1)then
        local Item = self.List_Tab:GetItemAt(SubTabIdx - 2)
        if(Item)then
            self:OnSubTabClicked(Item)
        end
    end
end

function M:OnSubTabDownKeyDown()
    local SubTabIdx = self.SelectedSubTab.Idx
    if(SubTabIdx < self.List_Tab:GetNumItems())then
        local Item = self.List_Tab:GetItemAt(SubTabIdx)
        if(Item)then
            self:OnSubTabClicked(Item)
        end
    end
end

--region手柄
function M:OnFocusReceived(MyGeometry, InFocusEvent)
    -- if not self.List_Tab:HasAnyUserFocus() then
    --     self.List_Tab:SetFocus()
    -- end
    return M.Super.OnFocusReceived(self,MyGeometry, InFocusEvent)
end

function M:RefreshBaseInfo()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(self.GameInputModeSubsystem)) then
        self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end
    self:InitNavigationRules()
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    self.CurGamepadName = CurGamepadName
    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    local IsGamepad = CurInputDevice == ECommonInputType.Gamepad
    local ActiveWidgetIndex = IsUseKeyAndMouse and 0 or 1
    if (IsGamepad) then
        --手柄
        if self.CurrentTopTabType == VoiceTag then
            self.Sort_Voice:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        end
        self.ScrollBox_FileDetail:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    else
        if self.CurrentTopTabType == VoiceTag then
            self.Sort_Voice:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        end
        self.ScrollBox_FileDetail:SetVisibility(UIConst.VisibilityOp.Visible)
    end
    self.CurInputDevice = CurInputDevice
end

function M:InitNavigationRules()
    self.List_Tab:SetNavigationRuleBase(EUINavigation.Up,EUINavigationRule.Stop)
end

function M:OnSortUpKeyDown()
    if self.CurrentTopTabType == RecordTag then return end
    self.Sort_Voice:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Sort_Voice:FocusToSelf()
end

function M:BP_GetDesiredFocusTarget()
    if self.SelectedContent then
        return self.SelectedContent.UI
    else
        local Item = self.List_Tab:GetItemAt(0)
        if Item then
            return Item.Widget
        else
            return self
        end
    end
end

function M:OnAnalogValueChanged(MyGeometry,InAnalogInputEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local AddOffset = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 5
    if InKeyName == "Gamepad_RightY" then
        local CurScrollOffset = self.ScrollBox_FileDetail:GetScrollOffset()
        local ScrollOffset = math.clamp(CurScrollOffset - AddOffset,0, self.ScrollBox_FileDetail:GetScrollOffsetOfEnd())
        if UIUtils.CheckScrollBoxCanScroll(self.ScrollBox_FileDetail) then
            self.ScrollBox_FileDetail:SetScrollOffset(ScrollOffset)
        end
    end
    return UE4.UWidgetBlueprintLibrary.UnHandled()
end

--endregion
AssembleComponents(M)
return M
