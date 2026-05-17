---@class WBP_CharSkinPreview_C:BP_UIState_C
local M = Class("BluePrints.UI.BP_UIState_C")
M._components = {
    "BluePrints.UI.WBP.Armory.MainComponent.Armory_PointerInputComponent",
    "BluePrints.UI.WBP.Armory.ActorController.PreviewActorComponent",
}

M.State_Tab = 1
M.State_List = 2

local OBTAIN_SKIN_POP = 100210
local HAS_SKIN_ALERT_POP = 100264

M.PreviewBehaviorType =
{
    BattlePassPreview = "BattlePassPreview",
    SelectGeneralSkin = "SelectGeneralSkin",
    SelectWeaponSkin = "SelectWeaponSkin",
    SelectCharAccessory = "SelectCharAccessory", 
    SelectWeaponAccessory = "SelectWeaponAccessory",
    SelectGestureItem = "SelectGestureItem",
    ShopRecommend = "ShopRecommend",
}

local ArmoryUtils = require "BluePrints.UI.WBP.Armory.ArmoryUtils"
local BattlePassController = require "BluePrints.UI.WBP.BattlePass.Controller.BattlePassController"

function M:Construct(...)
    M.Super.Construct(self, ...)
    self.KeyDownEvents = self.KeyDownEvents or {}
    self.RepeatKeyDownEvents = self.RepeatKeyDownEvents or {}
    self.EscapeKey = (EKeys and EKeys.Escape and EKeys.Escape.KeyName) or "Escape"
    if UIConst.GamePadKey then
        self.GamePadBackKey = UIConst.GamePadKey.FaceButtonRight
        self.GamePadConfirmKey = UIConst.GamePadKey.FaceButtonBottom
        self.GamePadHideUIKey = UIConst.GamePadKey.FaceButtonLeft
        self.LeftTriggerKey = UIConst.GamePadKey.LeftTriggerThreshold
        self.RightTriggerKey = UIConst.GamePadKey.RightTriggerThreshold
        self.RightThumbstickX = "Gamepad_RightX"   -- 模拟旋转(已在 OnAnalogValueChanged 使用)
    end
    self.ZoomKey = "Mouse_Button"  -- 与商店展示一致（PC提示）
    -- 内部状态
    self.bSelfHidden = false
    -- 消耗条目焦点标志
    self.bConsumeFocused = false

    self.EMListView_Role.BP_OnItemClicked:Clear()
    self.EMListView_Role.BP_OnItemClicked:Add(self,function(self,Content)
        self:OnRoleListItemClicked(Content)
    end)

    self.CurRoleContent = nil
    self.EMListView_Role.BP_OnItemSelectionChanged:Clear()
    self.EMListView_Role.BP_OnItemSelectionChanged:Add(self, function(self, Content, bIsSelected)
        if bIsSelected and self:IsGamepadInput() and Content and Content ~= self.CurRoleContent then
            self:OnRoleListItemClicked(Content)
        end
    end)
    self.EMListView_Role.BP_OnEntryInitialized:Clear()
    self.EMListView_Role.BP_OnEntryInitialized:Add(self,self.OnRoleListEntryInitialized)

    -- 直接绑定，不再做存在性判断
    self.Btn_List:UnBindEventOnClicked(self)
    self.Btn_List:BindEventOnClicked(self, function()
        self:ToggleRoleListPanel()
    end)

    self.Btn_Confirm:UnBindEventOnClicked(self)
    self.Btn_Confirm:SetText(GText("UI_CONFIRM_SELECTION"))
    self.Btn_Confirm:BindEventOnClicked(self, self.OnConfirmClicked)

    self.TileView_Pendant.BP_OnItemClicked:Clear()
    self.TileView_Pendant.BP_OnItemClicked:Add(self,self.OnAccessoryItemClicked)
    self.TileView_Pendant.BP_OnItemSelectionChanged:Clear()
    self.TileView_Pendant.BP_OnItemSelectionChanged:Add(self, function(self, Content, bIsSelected)
        if bIsSelected and self:IsGamepadInput() and Content and Content ~= self.CurRoleContent then
            self:OnAccessoryItemClicked(Content)
        end
    end)

    self.List_Skin.BP_OnItemClicked:Clear()
    self.List_Skin.BP_OnItemClicked:Add(self,self.OnSkinItemClicked)
    self.List_Skin.BP_OnItemSelectionChanged:Clear()
    self.List_Skin.BP_OnItemSelectionChanged:Add(self, function(self, Content, bIsSelected)
        if bIsSelected and self:IsGamepadInput() and Content and Content ~= self.CurRoleContent then
            self:OnSkinItemClicked(Content)
        end
    end)

    self.List_Skin.OnCreateEmptyContent:Bind(self, function(self)
        local Obj = NewObject(UIUtils.GetCommonItemContentClass())
        rawset(Obj,"IsEmpty",true)
        return Obj
    end)
    self.TileView_Pendant.OnCreateEmptyContent:Bind(self, function(self)
        local Obj = NewObject(UIUtils.GetCommonItemContentClass())
        rawset(Obj,"IsEmpty",true)
        return Obj
    end)

    self.Tab_Change.Text_Alive:SetText(GText("UI_Armory_Meleeweapon"))
    self.Tab_Change.Text_Dying:SetText(GText("UI_Armory_Longrange"))
end

function M:OnLoaded(...)
    self.Super.OnLoaded(self, ...)

    DebugPrint("gmy@WBP_CharSkinPreview_C M:OnLoaded", ...)

    self.Params = ...
    self.bIsFocusable = true
    self:SetFocus()

    if self.Params.Type == "SelectCharAccessory" then
        self:InitAccessoryParams()
    elseif self.Params.Type == "SelectWeaponAccessory" then
        self:InitWeaponAccessoryParams()
    elseif self.Params.Type == "SelectWeaponSkin" then
        self:InitWeaponParams()
    elseif self.Params.Type == "SelectSkin" then
        self:InitCharParams()
    elseif self.Params.Type == "SelectGestureItem" then
        self:InitGestureItemParams()
    else
        self:InitParams()
    end

    self:InitTabInfo()
    self:InitSelectiveListing()
    self:InitInputSettings()

    -- 初始隐藏角色列表（若设计为默认关闭）
    self.bRoleListOpen = false
    self.CurState = M.State_Tab  -- 初始为 Tab 状态
    self:PlayAnimation(self.In)

    -- 初始刷新详情面板
    if self.Params.Type == "SelectGeneralSkin" or self.Params.Type ==  "BattlePassPreview" or self.Params.Type == "ShopRecommend" then 
        self:InitRoleList()
        self:RefreshDetailPanel()
        if self.CurRoleContent then
            local SelectedRoleContent = self.CurRoleContent
            self.CurRoleContent = nil
            self:OnRoleListItemClicked(SelectedRoleContent)
        end
    end

    if self.Params.Type == "SelectWeaponAccessory" then
        self.Tab_Change:SetVisibility(ESlateVisibility.Visable)
    else
        self.Tab_Change:SetVisibility(ESlateVisibility.Collapsed)
    end

    -- 初始化按键映射（需在控件/状态初始化后）
    self:InitKeySetting()

    -- 应用列表可见性以确保相关控件(含筛选器)初始被隐藏不遮挡点击
    self:ApplyRoleListVisibility()

    --初始化消耗信息
    self:InitConsumeInfo()

    self.Tab_Change:Init({
        Parent = self,
        TabIdx = 1,
        OnTabClicked = self.OnTabChangeClicked,
    })
end

function M:InitParams()
    self.Switch_Type:SetActiveWidgetIndex(0)
    if self.Params then
        self.BehaviorType = self.Params.Type
        self.InitSkinId = self.Params.SkinId
        self.OptRewardId = self.Params.OptRewardId
        self.ResourceId = self.Params.ResourceId
        self.SkinSeriesId = self.Params.SkinSeriesId
        self.bInitSkinIdExplicit = (self.Params.SkinId ~= nil)

        DebugPrint("gmy@WBP_CharSkinPreview_C M:InitParams", self.BehaviorType, self.InitSkinId, self.SkinSeriesId, self.OptRewardId)
        -- 优先：若传入 OptRewardId
        if self.OptRewardId then
            local OptCfg = DataMgr.OptReward and DataMgr.OptReward[self.OptRewardId]
            if OptCfg and OptCfg.Type and OptCfg.Id then
                local bHasSkinType = false
                for _, t in pairs(OptCfg.Type) do
                    if t == "Skin" then bHasSkinType = true break end
                end
                if bHasSkinType then
                    self.bUseOptRewardSkinList = true
                    -- 若未显式传入 InitSkinId，则从奖励里挑一个：优先当前角色匹配，其次最小Id
                    if not self.InitSkinId then
                        local Avatar = GWorld:GetAvatar()
                        local CurChar = Avatar and Avatar.Chars and Avatar.Chars[Avatar.CurrentChar]
                        local CurCharId = CurChar and CurChar.CharId
                        local FirstSkinId
                        local MinSkinId
                        for _, sid in pairs(OptCfg.Id) do
                            if not FirstSkinId then FirstSkinId = sid end
                            if (not MinSkinId) or sid < MinSkinId then MinSkinId = sid end
                            local SkinData = DataMgr.Skin[sid]
                            if CurCharId and SkinData and SkinData.CharId == CurCharId then
                                self.InitSkinId = sid
                                break
                            end
                        end
                        if not self.InitSkinId then
                            self.InitSkinId = MinSkinId or FirstSkinId
                        end
                    end
                else
                    DebugPrint("gmy@WBP_CharSkinPreview_C M:InitParams OptReward Type not Skin", self.OptRewardId)
                end
            else
                DebugPrint("gmy@WBP_CharSkinPreview_C M:InitParams OptReward cfg missing", self.OptRewardId)
            end
        end

        -- 若没有通过 OptReward 设置 InitSkinId，且有 InitSkinId 但未给出系列，则补全 SkinSeriesId（旧逻辑保留）
        if (not self.bUseOptRewardSkinList) and self.InitSkinId and self.SkinSeriesId == nil then
            local SkinData = DataMgr.Skin[self.InitSkinId]
            self.SkinSeriesId = SkinData and SkinData.SkinSeries
        end
    end

    -- 自选包controller与战令界面区分
    local Avatar = GWorld:GetAvatar()
    if Avatar and Avatar.Chars and Avatar.CurrentChar then
        local CurrentChar = Avatar.Chars[Avatar.CurrentChar]
        local CurrentSkinId = CurrentChar and CurrentChar:GetAppearance().SkinId
        local PreviewSkinId
        -- 优先：若使用奖励皮肤列表，直接使用 InitSkinId（上面已经选定）
        if self.bUseOptRewardSkinList and self.InitSkinId then
            PreviewSkinId = self.InitSkinId
        elseif self.SkinSeriesId then
            -- 旧：系列筛选
            local PreferredId
            local MinId
            for SkinId, Info in pairs(DataMgr.Skin) do
                if Info.SkinSeries == self.SkinSeriesId then
                    if Info.CharId == (CurrentChar and CurrentChar.CharId) then
                        PreferredId = SkinId
                        break
                    end
                    if (not MinId) or SkinId < MinId then
                        MinId = SkinId
                    end
                end
            end
            PreviewSkinId = PreferredId or MinId
        end
        -- 回退：若系列/奖励未找到或未传，则使用当前角色外观皮肤
        PreviewSkinId = PreviewSkinId or self.InitSkinId or CurrentSkinId
        -- 如果原本没有 InitSkinId（题意假设为空），写回用于角色列表选中逻辑
        if not self.InitSkinId then
            self.InitSkinId = PreviewSkinId
        end
        local PreviewParams = {
            Type = "Char",
            SkinId = PreviewSkinId,
            EPreviewSceneType = CommonConst.EPreviewSceneType.PreviewCommon,
            ViewUI = self,
        }
        local Target = self:CreatePreviewTargetData(PreviewParams)
        PreviewParams.Target = Target
        self.ActorController = self:CreatePreviewActor(PreviewParams)
        BattlePassController:SetModelData("BagActorController", self.ActorController)
        BattlePassController:GetModelData("BagActorController"):OnOpened()
        BattlePassController:GetModel():AddModelDataRefCount("BagActorController")
        self.IsPreviewMode = true
    end
end

-- 初始化角色列表入口
function M:InitRoleList()
    self:BuildRoleItemContents()
    self.EMListView_Role:ClearListItems()
    -- 去除 nil 防御，让异常直接暴露
    for _, Content in ipairs(self.RoleItemContentsArray) do
        self.EMListView_Role:AddItem(Content)
        if Content.IsSelect then
            self.EMListView_Role:BP_ScrollItemIntoView(Content)
            self.CurRoleContent = Content
        end
    end
    self.EMListView_Role:RegenerateAllEntries()
end

-- 构建角色数据内容（根据系列皮肤过滤 / 奖励皮肤过滤）
function M:BuildRoleItemContents()
    local Avatar = GWorld:GetAvatar()
    if not Avatar or not Avatar.Chars then return end
    self.RoleItemContentsMap = {}
    self.RoleItemContentsArray = {}
    self.CharId2SkinId = {}
    self.UnownedCharContentMap = {}

    -- 计算需要排除的主角ID & 过滤函数
    local ExcludeCharId
    local Gender2RoleIds = Const and Const.DefaultAttributeMaster
    if Avatar and Gender2RoleIds and Avatar.Sex ~= nil then
        -- 性别 0/1, 取相反性别的主角ID作为排除
        ExcludeCharId = Gender2RoleIds[1 - Avatar.Sex]
    end
    local function ShouldIncludeChar(CharId)
        if not CharId then return false end
        if ExcludeCharId and CharId == ExcludeCharId then return false end
        local CharCfg = DataMgr.Char and DataMgr.Char[CharId]
        if not CharCfg then return false end
        if CharCfg.IsNotOpen then return false end
        return true
    end

    local TargetCharIds

    -- 优先：按奖励皮肤 Id 列表构建
    if self.bUseOptRewardSkinList and self.OptRewardId then
        local OptCfg = DataMgr.OptReward and DataMgr.OptReward[self.OptRewardId]
        if OptCfg and OptCfg.Id and OptCfg.Type then
            local bHasSkinType = false
            for _, t in pairs(OptCfg.Type) do if t == "Skin" then bHasSkinType = true break end end
            if bHasSkinType then
                TargetCharIds = {}
                for _, SkinId in pairs(OptCfg.Id) do
                    local SkinData = DataMgr.Skin[SkinId]
                    local CharId = SkinData and SkinData.CharId
                    if CharId and ShouldIncludeChar(CharId) then
                        TargetCharIds[CharId] = true
                        if not self.CharId2SkinId[CharId] then
                            self.CharId2SkinId[CharId] = SkinId
                        end
                    else
                        DebugPrint("WBP_CharSkinPreview_C BuildRoleItemContents 奖励过滤排除", SkinId, CharId)
                    end
                end
                DebugPrint("gmy@WBP_CharSkinPreview_C M:BuildRoleItemContents UseOptReward", self.OptRewardId)
            else
                DebugPrint("gmy@WBP_CharSkinPreview_C M:BuildRoleItemContents OptReward Type not Skin", self.OptRewardId)
            end
        end
    end

    -- 次之：按系列过滤（旧逻辑）
    if (not TargetCharIds) and self.SkinSeriesId then
        local SkinConverter = DataMgr.SkinConverter
        local SkinSeries2SkinId = SkinConverter and SkinConverter.SkinSeries2SkinId
        local SkinIdList = SkinSeries2SkinId and SkinSeries2SkinId[tostring(self.SkinSeriesId)]
        if SkinIdList then
            TargetCharIds = {}
            for _, SkinId in pairs(SkinIdList) do
                local SkinData = DataMgr.Skin[SkinId]
                local CharId = SkinData and SkinData.CharId
                if CharId and ShouldIncludeChar(CharId) then
                    TargetCharIds[CharId] = true
                    self.CharId2SkinId[CharId] = SkinId
                else
                    DebugPrint("WBP_CharSkinPreview_C BuildRoleItemContents 系列过滤排除", SkinId, CharId)
                end
            end
        end
    end

    -- 收集已拥有角色 (过滤未开放与排除ID)
    local OwnedCharIds = {}
    for Uuid, Char in pairs(Avatar.Chars) do
        if Char and ShouldIncludeChar(Char.CharId) and ((not TargetCharIds) or TargetCharIds[Char.CharId]) then
            local Content = ArmoryUtils:NewCharOrWeaponItemContent(Char, CommonConst.ArmoryType.Char, CommonConst.ArmoryTag.Char, nil)
            Content.Level = nil
            Content.IsOwned = true

            local SkinIdForChar = self.CharId2SkinId[Char.CharId]
            local bHasSkin = false
            if SkinIdForChar then
                bHasSkin = self:HasSkin(Char.CharId, SkinIdForChar)
            end
            Content.bHideLevelPanel = not bHasSkin
            Content.CharSkinPreViewLockType = bHasSkin and 2 or 0
            Content.LockType = 0
            Content.GotType = bHasSkin
            Content.bHideRarity = true
            Content.bSet = bHasSkin
            Content.SetOwnText = bHasSkin and GText("UI_Skin_HasSkin_Short") or nil
            Content.bShadow = bHasSkin
            Content.SortHasSkin = bHasSkin
            Content.SortIsOwned = true
            Content.SortSkinId = SkinIdForChar
            Content.CharId = Char.CharId

            self.RoleItemContentsMap[Uuid] = Content
            table.insert(self.RoleItemContentsArray, Content)
            OwnedCharIds[Char.CharId] = true
        end
    end

    if TargetCharIds then
        ArmoryUtils:DontResetUuid(true)
        -- 未拥有角色
        for CharId, _ in pairs(TargetCharIds) do
            if ShouldIncludeChar(CharId) and not OwnedCharIds[CharId] then
                local DummyAvatar = ArmoryUtils:CreateNewDummyAvatar(ArmoryUtils.PreviewTargetStates.Prime,{CharIds={CharId}})
                local _, DummyChar = next(DummyAvatar.Chars)
                if DummyChar then
                    -- 根据当前角色可预览皮肤映射判断是否已拥有对应皮肤（未拥有角色一般为 false）
                    local SkinIdForChar = self.CharId2SkinId[CharId]
                    local bHasSkin = false
                    if SkinIdForChar then
                        bHasSkin = self:HasSkin(CharId, SkinIdForChar)
                    end
                    
                    local Content = ArmoryUtils:NewCharOrWeaponItemContent(DummyChar, CommonConst.ArmoryType.Char, CommonConst.ArmoryTag.Char, true)
                    Content.IsOwned = false
                    Content.CharSkinPreViewLockType = 2
                    Content.LockType = bHasSkin and 0 or 2
                    Content.GotType = bHasSkin
                    Content.bHideRarity = true
                    Content.bSet = bHasSkin
                    Content.SetOwnText = bHasSkin and GText("UI_Skin_HasSkin_Short") or nil
                    Content.bShadow = bHasSkin
                    Content.Level = nil
                    Content.Target = DummyChar -- 记录真实 Dummy 角色
                    Content.Avatar = DummyAvatar
                    Content.SortHasSkin = bHasSkin
                    Content.SortIsOwned = false
                    Content.SortSkinId = SkinIdForChar
                    Content.CharId = CharId

                    self.RoleItemContentsMap[Content.Uuid] = Content
                    self.UnownedCharContentMap[CharId] = Content
                    table.insert(self.RoleItemContentsArray, Content)
                end
            end
        end
        ArmoryUtils:DontResetUuid(false)
    end

    -- 修改排序规则: 1) 未拥有皮肤在前 2) 已拥有角色在前 3) 皮肤ID升序
    table.sort(self.RoleItemContentsArray, function(a,b)
        local AHasSkin = a.SortHasSkin and 1 or 0
        local BHasSkin = b.SortHasSkin and 1 or 0
        local AOwned = a.SortIsOwned and 1 or 0
        local BOwned = b.SortIsOwned and 1 or 0
        local function Group(Owned, HasSkin)
            if Owned == 1 then
                if HasSkin == 0 then return 1 else return 2 end
    else
                if HasSkin == 0 then return 3 else return 4 end
    end
        end
        local GroupA = Group(AOwned, AHasSkin)
        local GroupB = Group(BOwned, BHasSkin)
        if GroupA ~= GroupB then return GroupA < GroupB end
        local ASkinId = a.SortSkinId or math.huge
        local BSkinId = b.SortSkinId or math.huge
        if ASkinId ~= BSkinId then return ASkinId < BSkinId end
        local ACharId = a.CharId or (a.Char and a.Char.CharId) or a.UnitId or 0
        local BCharId = b.CharId or (b.Char and b.Char.CharId) or b.UnitId or 0
        if ACharId ~= BCharId then return ACharId < BCharId end
        local AUuid = tostring(a.Uuid or "")
        local BUuid = tostring(b.Uuid or "")
        return AUuid < BUuid
    end)

    local SelectedContent

    -- if self.InitSkinId then
    --     local InitSkinData = DataMgr.Skin[self.InitSkinId]
    --     local InitCharId = InitSkinData and InitSkinData.CharId
    --     if InitCharId and ShouldIncludeChar(InitCharId) then
    --         for _, Content in ipairs(self.RoleItemContentsArray) do
    --             if (Content.Char and Content.Char.CharId == InitCharId) or (Content.CharId == InitCharId) then
    --                 SelectedContent = Content
    --                 break
    --             end
    --         end
    --     end
    -- end

    -- if not SelectedContent then
    --     local CurrentUuid = Avatar.CurrentChar
    --     local CurContent = CurrentUuid and self.RoleItemContentsMap[CurrentUuid]
    --     if CurContent and CurContent.Char and ShouldIncludeChar(CurContent.Char.CharId) then
    --         SelectedContent = CurContent
    --     else
    --         SelectedContent = self.RoleItemContentsArray[1]
    --     end
    -- end

    -- 仅在“显式传入 InitSkinId”时，才按 InitSkinId 定位默认选中
    if self.bInitSkinIdExplicit and self.InitSkinId then
        local InitSkinData = DataMgr.Skin[self.InitSkinId]
        local InitCharId = InitSkinData and InitSkinData.CharId
        if InitCharId and ShouldIncludeChar(InitCharId) then
            for _, Content in ipairs(self.RoleItemContentsArray) do
                if (Content.Char and Content.Char.CharId == InitCharId) or (Content.CharId == InitCharId) then
                    SelectedContent = Content
                    break
                end
            end
        end
    end

    if not SelectedContent then
        if not self.bInitSkinIdExplicit then
            -- 未显式传入：直接选左侧列表第一个（按当前排序结果）
            SelectedContent = self.RoleItemContentsArray[1]
        else
            -- 显式传入但未匹配到时，保留旧兜底
            local CurrentUuid = Avatar.CurrentChar
            local CurContent = CurrentUuid and self.RoleItemContentsMap[CurrentUuid]
            if CurContent and CurContent.Char and ShouldIncludeChar(CurContent.Char.CharId) then
                SelectedContent = CurContent
            else
                SelectedContent = self.RoleItemContentsArray[1]
            end
        end
    end

    if SelectedContent then
        ArmoryUtils:SetItemIsSelected(SelectedContent, true)
        SelectedContent.IsSelect = true
        self.CurRoleContent = SelectedContent
    end

    if self.RoleItemContentsArray then
        for _, Content in ipairs(self.RoleItemContentsArray) do
            Content.RedDotType = nil
        end
    end
end

function M:OnRoleListEntryInitialized(_Content, _Widget)
    local Content, Widget = _Content, _Widget
    if Content then
        Content.RedDotType = nil
    end
    if Widget then
        if Widget.SetReddot then
            Widget:SetReddot(nil)
        else
            if Widget.Reddot and Widget.Reddot.SetVisibility then
                Widget.Reddot:SetVisibility(UIConst.VisibilityOp.Collapsed)
            end
            if Widget.New and Widget.New.SetVisibility then
                Widget.New:SetVisibility(UIConst.VisibilityOp.Collapsed)
            end
        end
    end
end

-- 点击角色条目
function M:OnRoleListItemClicked(Content)
    if self.CurRoleContent == Content then return end
    if self.CurRoleContent then
        ArmoryUtils:SetItemIsSelected(self.CurRoleContent, false)
        self.CurRoleContent.IsSelect = false
        if self.CurRoleContent.Widget and self.CurRoleContent.Widget.SetIsSelected then
            self.CurRoleContent.Widget:SetIsSelected(false)
        end
    end
    
    ArmoryUtils:SetItemIsSelected(Content, true)
    Content.IsSelect = true
    if Content.Widget and Content.Widget.SetIsSelected then
        Content.Widget:SetIsSelected(true)
    end
    self.CurRoleContent = Content
    self:UpdatePreviewSkinActorForContent(Content)
    self:RefreshDetailPanel()
end

-- 根据选中角色更新预览模型
function M:UpdatePreviewSkinActorForContent(Content)
    local RealAvatar = GWorld:GetAvatar()
    local RealChar = RealAvatar.Chars[Content.Uuid]
    local CharId
    if RealChar then
        CharId = RealChar.CharId or Content.CharId or Content.UnitId
        BattlePassController:GetModelData("BagActorController"):ChangeCharModel(RealChar)
    elseif Content.Target then
        if Content.Avatar then
            BattlePassController:GetModelData("BagActorController"):SetAvatar(Content.Avatar)
        end
        BattlePassController:GetModelData("BagActorController"):ChangeCharModel(Content.Target)
        CharId = (Content.Target and Content.Target.CharId) or Content.CharId or Content.UnitId
        BattlePassController:GetModelData("BagActorController"):SetAvatar(RealAvatar)
    end
    if CharId then
        self:ApplyCurrentSkinAppearance(CharId)
    end
    self:EnterSkinCameraAnimation()
end

function M:Close()
    M.Super.Close(self)
    
    DebugPrint("gmy@@@WBP_CharSkinPreview_C M:Close111")
    -- 只在战令界面时触发事件，自选包界面不执行
    if self.BehaviorType == M.PreviewBehaviorType.BattlePassPreview then
        EventManager:FireEvent(EventID.BattlePassSkinClose)
    end
end

function M:Destruct(...)
    if IsValid(self.GameInputModeSubsystem) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.OnUpdateUIStyleByInputTypeChange)
    end
    local UIBattleMain = UIManager(self):GetUI("BattlePassMain")
    if UIBattleMain then
        if self.BehaviorType == M.PreviewBehaviorType.BattlePassPreview and self.InitSkinId and BattlePassController:GetModelData("BagActorController") then
            local SkinData = DataMgr.Skin[self.InitSkinId]
            local Avatar = GWorld:GetAvatar()
            local RestoreChar
            for _, C in pairs(Avatar.Chars) do
                if C.CharId == SkinData.CharId then
                    RestoreChar = C
                    break
                end
            end
            if RestoreChar then
                BattlePassController:GetModelData("BagActorController"):ChangeCharModel(RestoreChar)
                local AppearanceInfo = { CharId = SkinData.CharId, SkinId = self.InitSkinId, AccessorySuit = {} }
                BattlePassController:GetModelData("BagActorController"):ChangeCharAppearance(AppearanceInfo)
            end
        end
    end
    M.Super.Destruct(self, ...)
    BattlePassController:GetModel():RemoveModelDataRefCount("BagActorController", function(Target)
        if not Target or not IsValid(Target) then return end
        Target:OnClosed()
        Target:OnDestruct()
    end)
end

function M:InitTabInfo()
    -- 仿照商店皮肤预览的Tab初始化方式，构建统一样式配置
    self.MainTabsStyle = {
        TitleName = GText('UI_Armory_Appearance'),
        LeftKey = 'NotShow',
        RightKey = 'NotShow',
        Tabs = {},
        DynamicNode = { 'Back', 'BottomKey' },
        BottomKeyInfo = {},
        StyleName = 'Text',
        OwnerPanel = self,
        LastFocusWidget = self,
        BackCallback = self.ExitSkin,
    }

    -- （其余旧的按键提示初始化逻辑保留, 在 BuildBottomKeyInfo 中会被重写）
    --self.ConfirmKeyInfoList = {
    --    GamePadInfoList = {
    --        { Type = 'Img', ImgShortPath = 'A', Owner = self }
    --    },
    --    Desc = GText('UI_Controller_Check'),
    --    bLongPress = false,
    --}
    self.BackKeyInfoList = {
        KeyInfoList = { { Type = 'Text', Text = 'Esc', ClickCallback = self.ExitSkin, Owner = self } },
        GamePadInfoList = { { Type = 'Img', ImgShortPath = 'B', ClickCallback = self.ExitSkin, Owner = self } },
        Desc = GText('UI_BACK'),
    }
    --self.ToggleListKeyInfoList = {
    --    GamePadInfoList = { { Type = 'Img', ImgShortPath = 'Y', Owner = self } },
    --    Desc = GText('UI_Controller_Switch'),
    --}
    -- 初始化 Tab（底部按键将在 InitKeySetting -> BuildBottomKeyInfo 时填充）
    self.Tab_SkinPreview:Init(self.MainTabsStyle)
end

function M:ExitSkin()
    self:BindToAnimationFinished(self.Out, {self, self.Close})
    self:PlayAnimation(self.Out)
end

--region ------------------------------------预览模型相关------------------------------------
function M:UpdatePreviewSkinActor()
    local RealAvatar = GWorld:GetAvatar()
    local CharUuid = RealAvatar.CurrentChar
    if self.CurRoleContent and self.CurRoleContent.Uuid then
        CharUuid = self.CurRoleContent.Uuid
    end
    local RealChar = RealAvatar.Chars[CharUuid]
    local CharId
    if RealChar then
        CharId = RealChar.CharId
        BattlePassController:GetModelData("BagActorController"):ChangeCharModel(RealChar)
    elseif self.CurRoleContent and self.CurRoleContent.Target then
        if self.CurRoleContent.Avatar then
            BattlePassController:GetModelData("BagActorController"):SetAvatar(self.CurRoleContent.Avatar)
        end
        BattlePassController:GetModelData("BagActorController"):ChangeCharModel(self.CurRoleContent.Target)
        CharId = (self.CurRoleContent.Target and self.CurRoleContent.Target.CharId) or self.CurRoleContent.CharId or self.CurRoleContent.UnitId
        BattlePassController:GetModelData("BagActorController"):SetAvatar(RealAvatar)
    end
    if CharId then
        self:ApplyCurrentSkinAppearance(CharId)
    end
    self:EnterSkinCameraAnimation()
end

function M:EnterSkinCameraAnimation()
    BattlePassController:GetModelData("BagActorController"):SetMontageAndCamera(CommonConst.ArmoryType.Char)
end

-- 获取角色需要预览的皮肤Id
function M:GetPreviewSkinIdForChar(CharId)
    if not CharId then return nil end
    local SkinId
    if self.CharId2SkinId then
        SkinId = self.CharId2SkinId[CharId]
    end
    if (not SkinId) and self.InitSkinId then
        local Data = DataMgr.Skin[self.InitSkinId]
        if Data and Data.CharId == CharId then
            SkinId = self.InitSkinId
        end
    end
    return SkinId
end

-- 应用当前选中角色对应皮肤
function M:ApplyCurrentSkinAppearance(CharId)
    if not (BattlePassController:GetModelData("BagActorController") and CharId) then return end
    local SkinId = self:GetPreviewSkinIdForChar(CharId)
    if not SkinId then return end
    local AppearanceInfo = { CharId = CharId, SkinId = SkinId, AccessorySuit = {} }
    BattlePassController:GetModelData("BagActorController"):ChangeCharAppearance(AppearanceInfo)
end
--endregion ------------------------------------预览模型相关----

function M:InitInputSettings()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if IsValid(self.GameInputModeSubsystem) then
        -- 防重复先移除再添加
        self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.OnUpdateUIStyleByInputTypeChange)
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.OnUpdateUIStyleByInputTypeChange)
    end
    self:OnUpdateUIStyleByInputTypeChange(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    self.Image_Click.OnMouseButtonDownEvent:Unbind()
    self.Image_Click.OnMouseButtonDownEvent:Bind(self, self.On_Image_Click_MouseButtonDown)

    self.Key_List_GamePad:CreateCommonKey({
        KeyInfoList = {{Type = "Img", ImgShortPath = "View", }},
        Desc = GText("UI_CTL_ExpandList"),
    })
    -- 消耗选择 左摇杆按下快捷键显示
    if self.Key_Consume_GamePad then
        self.Key_Consume_GamePad:CreateCommonKey({
            KeyInfoList = {{Type = "Img", ImgShortPath = "LS"}},
        })
    end
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
    DebugPrint("gmy@WBP_CharSkinPreview_C M:OnUpdateUIStyleByInputTypeChange", CurInputDevice, CurGamepadName)
    if CurInputDevice == ECommonInputType.Gamepad then
        self.WidgetSwitcher_MP:SetActiveWidgetIndex(1)
        self:FocusFirstForInputMode()
        if self.Key_Consume_GamePad then
            if self.bRoleListOpen then
                self.Key_Consume_GamePad:SetVisibility(ESlateVisibility.Collapsed)
            else
                self.Key_Consume_GamePad:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            end
        end
        -- 切到手柄输入时，同步 Btn_Confirm 的手柄图标显隐（列表打开隐藏，关闭显示）
        if self.bRoleListOpen then
            self.Btn_Confirm:SetGamePadVisibility(UIConst.VisibilityOp["Collapsed"])
        else
            self.Btn_Confirm:SetGamePadVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        end
    else
        self.WidgetSwitcher_MP:SetActiveWidgetIndex(0)
        if self.Key_Consume_GamePad then
            self.Key_Consume_GamePad:SetVisibility(ESlateVisibility.Collapsed)
        end
        self.Btn_Confirm:SetGamePadVisibility(UIConst.VisibilityOp["Collapsed"])
    end
end

-- 手柄模式下聚焦当前打开区域的第一项（Tab 或 List）
function M:FocusFirstForInputMode()
    DebugPrint("gmy@WBP_CharSkinPreview_C M:FocusFirstForInputMode111")
    if self.Params.Type == "SelectWeaponSkin" or self.Params.Type == "SelectSkin" then
        if self:HasAnyFocus() then
            self.List_Skin:SetFocus()
            self.List_Skin:SetSelectedIndex(0)
        end
    elseif self.Params.Type == "SelectWeaponAccessory" or self.Params.Type == "SelectCharAccessory" or self.Params.Type == "SelectGestureItem" then
        if self:HasAnyFocus() then
            self.TileView_Pendant:SetFocus()
            self.TileView_Pendant:SetSelectedIndex(0)
        end
    elseif self.bRoleListOpen then
        local Target = self.CurRoleContent
        if Target then
            self.TileView_Select_Role:BP_SetSelectedItem(Target)
            self.TileView_Select_Role:BP_ScrollItemIntoView(Target)
        end

        if self:HasAnyFocus() then
            self.TileView_Select_Role:SetFocus()
        end
    else
        local Target = self.CurRoleContent
        if Target then
            if self.EMListView_Role.BP_SetSelectedItem then
                self.EMListView_Role:BP_SetSelectedItem(Target)
            end
            self.EMListView_Role:BP_ScrollItemIntoView(Target)
        end

        if self:HasAnyFocus() then
            self.EMListView_Role:SetFocus()
        end
    end
    self.bConsumeFocused = false
end


function M:OnMouseWheel(MyGeometry, MouseEvent)
    return self:OnMouseWheelScroll(MyGeometry, MouseEvent)
end


function M:On_Image_Click_MouseButtonDown(MyGeometry, MouseEvent)
    DebugPrint("gmy@WBP_CharSkinPreview_C M:On_Image_Click_MouseButtonDown")
    -- 若当前在列表展开状态，点击空白区域执行与 ESC 相同的“从 List 返回 Tab”行为，只关闭列表不退出
    if self.bRoleListOpen then
        self:CloseRoleListPanel()
        return UE4.UWidgetBlueprintLibrary.Handled()
    end
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

function M:OnKeyDown(_, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)

    -- 优先: 若当前聚焦消费条目且按下返回键(B/Escape)，仅回到角色列表，不触发通用映射
    if self.bConsumeFocused and self.Item_Consume and (InKeyName == "Escape" or InKeyName == self.EscapeKey or InKeyName == self.GamePadBackKey or InKeyName == Const.GamepadFaceButtonRight) then
        if self.bRoleListOpen and self.TileView_Select_Role then
            self.TileView_Select_Role:SetFocus()
        elseif self.EMListView_Role then
            self.EMListView_Role:SetFocus()
        end
        self.bConsumeFocused = false
        return UE4.UWidgetBlueprintLibrary.Handled()
    end
    DebugPrint("gmy@WBP_CharSkinPreview_C M:OnKeyDown", InKeyName)
    -- 通用映射 (包括 B/Escape 的返回逻辑)
    if self.KeyDownEvents and self.KeyDownEvents[InKeyName] then
        local func = self.KeyDownEvents[InKeyName]
        if func then func(self) return UE4.UWidgetBlueprintLibrary.Handled() end
    end

    DebugPrint("gmy@WBP_CharSkinPreview_C M:OnKeyDown", InKeyName)
    -- 兼容旧逻辑 (Esc/B 返回; Y 开关列表; A 确认)
    if (InKeyName == "Escape" or InKeyName == Const.GamepadFaceButtonRight) then
        if self.bRoleListOpen then
            self:CloseRoleListPanel()
            return UE4.UWidgetBlueprintLibrary.Handled()
        end
        self:ExitSkin()
        return UE4.UWidgetBlueprintLibrary.Handled()
    end
    if InKeyName == Const.GamepadFaceButtonBottom then
        if self.Btn_Confirm.IsEnabled ~= false or self.Params.Mode == "Preview" then
            self:OnConfirmClicked()
            return UE4.UWidgetBlueprintLibrary.Handled()
        end
    end
    if InKeyName == Const.GamepadFaceButtonTop then
        self:ToggleRoleListPanel()
        return UE4.UWidgetBlueprintLibrary.Handled()
    end
    if InKeyName == Const.GamepadRightTrigger then
        self:OnTabChangeClicked(2)
        return UE4.UWidgetBlueprintLibrary.Handled()
    elseif InKeyName == Const.GamepadLeftTrigger then
        self:OnTabChangeClicked(1)
        return UE4.UWidgetBlueprintLibrary.Handled()
    end

    return UE4.UWidgetBlueprintLibrary.UnHandled()
end


-- 重复按键处理（触发缩放）
function M:OnRepeatKeyDown(_MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local func = self.RepeatKeyDownEvents and self.RepeatKeyDownEvents[InKeyName]
    if func then func(self) return UIUtils.Handled end
    return UIUtils.Unhandled
end

function M:InitKeySetting()
    -- 基础按下事件（去除判空，若为 nil 则运行期抛错以便暴露问题）
    self.KeyDownEvents[self.EscapeKey] = self.OnBackKeyDown
    self.KeyDownEvents[self.GamePadBackKey] = self.OnBackKeyDown
    self.KeyDownEvents[self.GamePadHideUIKey] = self.OnHideUIKeyDown
    self.KeyDownEvents[self.GamePadConfirmKey] = self.OnConfirmKeyDown
    self.KeyDownEvents["U"] = self.OnHideUIKeyDown
    self.KeyDownEvents[Const.GamepadSpecialLeft] = function(self) self:ToggleRoleListPanel() end
    -- 左摇杆点击：列表展开时聚焦排序组件并隐藏消费快捷键；列表关闭时聚焦消费组件并显示消费快捷键
    self.KeyDownEvents[Const.GamepadLeftThumbstick] = function(self)
        if self.bRoleListOpen then
            --self.Common_Sort_List:SetFocus()
            if self.Key_Consume_GamePad then
                self.Key_Consume_GamePad:SetVisibility(ESlateVisibility.Collapsed)
            end
            self.bConsumeFocused = false
        else
            self.Item_Consume:SetFocus()
            self.bConsumeFocused = true
            if self.Key_Consume_GamePad then
                if self:IsGamepadInput() then
                    self.Key_Consume_GamePad:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
                else
                    self.Key_Consume_GamePad:SetVisibility(ESlateVisibility.Collapsed)
                end
            end
        end
    end
    -- 重复触发缩放（去除判空）
    self.RepeatKeyDownEvents[self.LeftTriggerKey] = self.OnCameraScrollBackwardKeyDown
    self.RepeatKeyDownEvents[self.RightTriggerKey] = self.OnCameraScrollForwardKeyDown
    -- 底部按键信息
    self:BuildBottomKeyInfo()
end

function M:BuildBottomKeyInfo()
    -- ESC / 返回
    self.ESCKeyInfoList = {
        KeyInfoList = {
            {Type="Text", Text=CommonUtils:GetKeyText(self.EscapeKey), ClickCallback=self.OnBackKeyDown, Owner=self},
        },
        GamePadInfoList = {
            {Type="Img", ImgShortPath="B", ClickCallback=self.OnBackKeyDown, Owner=self},
        },
        Desc = GText("UI_BACK"),
    }
    -- 隐藏UI
    self.HideUI_KeyInfoList = {
        KeyInfoList = {
            {Type="Text", Text=CommonUtils:GetKeyText("U"), ClickCallback=self.OnHideUIKeyDown, Owner=self},
        },
        GamePadInfoList = {
            {Type="Img", ImgShortPath="X"},
        },
        Desc = GText("UI_Dye_HideUI"),
    }
    -- 缩放
    self.ZoomKeyInfoList = {
        KeyInfoList = {
            {Type="Text", Text = CommonUtils:GetKeyText(self.ZoomKey), Owner=self},
        },
        GamePadInfoList = {
            {Type="Or"},
            GamePadSubKeyInfoList = {
                {Type="Img", ImgShortPath="LT", Owner=self},
                {Type="Img", ImgShortPath="RT", Owner=self},
            }
        },
        Desc = GText("UI_Dye_Zoom"),
        bLongPress = false,
    }
    -- 旋转
    self.RightThumbstickAnalogBottomKeyInfoList = {
        GamePadInfoList = {
            {Type="Img", ImgShortPath="RH"},
        },
        Desc = GText("UI_CTL_RotatePreview"),
    }
    -- 确认
    --self.ConfirmKeyInfoList = self.ConfirmKeyInfoList or {
    --    GamePadInfoList = {{Type='Img', ImgShortPath='A', Owner=self}},
    --    Desc = GText('UI_Controller_Check'),
    --    bLongPress = false,
    --}
    ---- 角色列表开关 (Y)
    --self.ToggleListKeyInfoList = self.ToggleListKeyInfoList or {
    --    GamePadInfoList = {{Type='Img', ImgShortPath='View', Owner=self}},
    --    Desc = GText('UI_Controller_Switch'),
    --}
    -- 重建 BottomKeyInfo 顺序: 确认, 列表, 隐藏UI, 缩放, 旋转, 返回
    self.BottomKeyInfo = {}
    --table.insert(self.BottomKeyInfo, self.ConfirmKeyInfoList)
    --table.insert(self.BottomKeyInfo, self.ToggleListKeyInfoList)
    table.insert(self.BottomKeyInfo, self.HideUI_KeyInfoList)
    table.insert(self.BottomKeyInfo, self.ZoomKeyInfoList)
    table.insert(self.BottomKeyInfo, self.RightThumbstickAnalogBottomKeyInfoList)
    table.insert(self.BottomKeyInfo, self.ESCKeyInfoList)
    if self.Tab_SkinPreview and self.Tab_SkinPreview.UpdateBottomKeyInfo then
        self.Tab_SkinPreview:UpdateBottomKeyInfo(self.BottomKeyInfo)
    end
end

-- Back 处理（供按键映射调用）
function M:OnBackKeyDown()
    if self.bSelfHidden then
        self:OnHideUIKeyDown()
    elseif self.bRoleListOpen then
        self:CloseRoleListPanel()
    else
        self:ExitSkin()
    end
end

-- 确认键回调包装
function M:OnConfirmKeyDown()
    if self.Btn_Confirm.IsEnabled ~= false and not self.bSelfHidden then
        self:OnConfirmClicked()
    end
end

function M:OnGamepadConfirmKeyDonw(Content)
    if self:IsGamepadInput() then
        self:OnConfirmKeyDown()
    else
        self:OnSkinItemClicked(Content)
    end
end

-- 隐藏 UI
function M:OnHideUIKeyDown()
    self.bSelfHidden = not self.bSelfHidden
    if self.bSelfHidden then
        self:SetRenderOpacity(0)
        if self.Image_Click and self.Image_Click.Slot then
            self.Image_Click.Slot:SetZOrder(10)
        end
        self:AddDelayFrameFunc(function()
            if UIUtils.IsGamepadInput() then
                self.GameInputModeSubsystem:SetNavigateWidgetVisibility(false)
                self.Switch_Type:SetVisibility(ESlateVisibility.Collapsed)
            end
        end, 2)
    else
        self:SetRenderOpacity(1)
        if self.Image_Click and self.Image_Click.Slot then
            self.Image_Click.Slot:SetZOrder(-1)
        end
        if UIUtils.IsGamepadInput() then
            self.GameInputModeSubsystem:SetNavigateWidgetVisibility(true)
        end
        self.Switch_Type:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        local CurActiveWidgetIndex = self.Switch_Type:GetActiveWidgetIndex()
        if CurActiveWidgetIndex == 0 then 
            self.EMListView_Role:SetFocus()
        elseif CurActiveWidgetIndex == 1 then
            self.List_Skin:SetFocus()
        elseif CurActiveWidgetIndex == 2 then
            self.TileView_Pendant:SetFocus()
        end
    end
end

-- 触发缩放（与商店逻辑保持）
function M:OnCameraScrollBackwardKeyDown()
    if not self.bSelfHidden then
        self:ScrollCamera(1)
    end
end
function M:OnCameraScrollForwardKeyDown()
    if not self.bSelfHidden then
        self:ScrollCamera(-1)
    end
end

function M:InitSelectiveListing()
    if self.bSelectiveInited then return end
    self.bSelectiveInited = true

    self.TileView_Select_Role.BP_OnItemClicked:Clear()
    self.TileView_Select_Role.BP_OnItemClicked:Add(self, function(self, Content)
        self:OnTileRoleItemClicked(Content)
    end)
    -- 手柄模式下移动焦点即切换（选择式 TileView）
    self.TileView_Select_Role.BP_OnItemSelectionChanged:Clear()
    self.TileView_Select_Role.BP_OnItemSelectionChanged:Add(self, function(self, Content, bIsSelected)
        if bIsSelected and self:IsGamepadInput() and Content and Content ~= self.CurRoleContent then
            self:OnRoleListItemClicked(Content)
        end
    end)

    self.CharFilterTags, self.CharFilterNames = UIUtils.GetAllElementTypes()
    self.CharFilterIcons = {}
    for _, Tag in pairs(self.CharFilterTags) do
        local IconName = "Armory_" .. Tag
        table.insert(self.CharFilterIcons, "/Game/UI/Texture/Dynamic/Atlas/Armory/T_" .. IconName .. ".T_" .. IconName)
    end
    -- 初始化过滤器相关属性
    self.Filters = self:CreateFilters(
            self["CharFilterTags"],
            self["CharFilterNames"],
            self["CharFilterIcons"],
            self.ExcelWeaponTags)


    self.FilterMod = "Single"
    self.FilterIdxes = {}
    self.SelectedFilterContents = {}
    self.LastSelectedFilterContent = nil

    -- 绑定 EMListView_Filter 事件
    self.EMListView_Filter.BP_OnItemClicked:Clear()
    self.EMListView_Filter.BP_OnItemClicked:Add(self, self.OnFilterListItemClicked)
    
    --self.EMListView_Filter.BP_OnEntryInitialized:Clear()
    --self.EMListView_Filter.BP_OnEntryInitialized:Add(self, self.OnFilterEntryInitialized)
    --
    --self.EMListView_Filter.BP_OnItemIsHoveredChanged:Clear()
    --self.EMListView_Filter.BP_OnItemIsHoveredChanged:Add(self, function(self, Content, bIsHovered)
    --    DebugPrint("gmy@WBP_CharSkinPreview_C M:InitSelectiveListing", Content and Content.Text, bIsHovered)
    --    if bIsHovered and self:IsGamepadInput() then
    --        self:OnFilterListItemClicked(Content)
    --    end
    --end)

    local OrderByDisplayNames = {
        GText("UI_RARITY_NAME"),
    }
    --self.Common_Sort_List:Init(self, OrderByDisplayNames, CommonConst.DESC, {
    --    OnGetBackFocusWidget = function()
    --        return self.TileView_Select_Role
    --    end,
    --    OnAddedToFocusPath = function() end,
    --    OnRemovedFromFocusPath = function() end,
    --})
    --self.Common_Sort_List:BindEventOnSelectionsChanged(self, self.OnSelectiveSortChanged)
    --self.Common_Sort_List:BindEventOnSortTypeChanged(self, self.OnSelectiveSortChanged)

    self:BuildFilterContents()
    self:FillSelectiveTileView()
end

function M:BuildFilterContents()
    self.EMListView_Filter:ClearListItems()
    self.FilterContents = {}
    self.SelectedFilterContents = {}

    -- 创建 "全部" 选项
    self.FilterContentObj_All = NewObject(UIUtils.GetCommonItemContentClass())
    self.FilterContentObj_All.IsSelect = true
    self.FilterContentObj_All.Index = 0
    self.FilterContentObj_All.Tag = "ALL"
    self.FilterContentObj_All.Text = GText("UI_ALL")
    self.FilterContentObj_All.Icon = '/Game/UI/Texture/Static/Atlas/Armory/T_Armory_Select.T_Armory_Select'
    self.FilterContentObj_All.IsSelected = true
    self.FilterContentObj_All.Owner = self
    self.LastSelectedFilterContent = self.FilterContentObj_All
    table.insert(self.FilterContents, self.FilterContentObj_All)
    self.EMListView_Filter:AddItem(self.FilterContentObj_All)

    -- 添加其他过滤器选项（如果有的话）
    for Index, FilterData in ipairs(self.Filters) do
        local Obj = NewObject(UIUtils.GetCommonItemContentClass())
        if type(FilterData) == "table" then
            for Key, Value in pairs(FilterData) do
                Obj[Key] = Value
            end
        else
            Obj.Text = FilterData
            Obj.Tag = FilterData
        end
        Obj.Index = Index
        Obj.IsSelected = false
        Obj.Owner = self
        table.insert(self.FilterContents, Obj)
        self.EMListView_Filter:AddItem(Obj)
        DebugPrint("gmy@WBP_CharSkinPreview_C M:BuildFilterContents", Obj.Text, Obj.Tag)
    end

    self.CurrentFilterTag = "ALL"
    self.EMListView_Filter:RegenerateAllEntries()
end

-- 过滤项条目初始化（设置初始选中状态 & 保存 UI 引用）
function M:OnFilterEntryInitialized(Content, Widget)
    if Widget and Widget.SetIsSelected then
        Widget:SetIsSelected(Content.IsSelected == true)
        Content.UI = Widget
    end

    --if Widget and Widget.OnAddedToFocusPathEvent then
    --    Widget.OnAddedToFocusPathEvent:Unbind(self)
    --    Widget.OnAddedToFocusPathEvent:Bind(self, function()
    --        if self:IsGamepadInput() and Content and Content.Tag ~= self.CurrentFilterTag then
    --            self:OnFilterListItemClicked(Content)
    --        end
    --    end)
    --end
    --
    --if Widget and Widget.BindEventOnHovered then
    --    Widget:BindEventOnHovered(self, function()
    --        if Content and Content.Tag ~= self.CurrentFilterTag then
    --            self:OnFilterListItemClicked(Content)
    --        end
    --    end)
    --elseif Widget and Widget.OnHovered then
    --    Widget.OnHovered:Add(self, function(selfWidget)
    --        if Content and Content.Tag ~= self.CurrentFilterTag then
    --            self:OnFilterListItemClicked(Content)
    --        end
    --    end)
    --end
end

function M:GetSelectiveSourceContents()
    return self.RoleItemContentsArray or {}
end

function M:FillSelectiveTileView()
    local Source = self:GetSelectiveSourceContents()
    local FilterTag = self.CurrentFilterTag
    self.TileView_Select_Role:ClearListItems()
    self.SelectiveDisplayedContents = {}
    for _, Content in ipairs(Source) do
        local CharId = Content.CharId or (Content.Char and Content.Char.CharId) or Content.UnitId
        local Attr = DataMgr.BattleChar[CharId].Attribute
        if (FilterTag == "ALL") or (Attr == FilterTag) then
            Content.OnFocusReceivedEvent = {
                Obj = self,
                Callback = self.OnFocusReceivedEvent
            }
            table.insert(self.SelectiveDisplayedContents, Content)
            self.TileView_Select_Role:AddItem(Content)
        end
    end
    if self.CurRoleContent then
        local bKeep = false
        for _, c in ipairs(self.SelectiveDisplayedContents) do if c == self.CurRoleContent then bKeep = true break end end
        if bKeep then
            self.TileView_Select_Role:BP_SetSelectedItem(self.CurRoleContent)
            self.TileView_Select_Role:BP_ScrollItemIntoView(self.CurRoleContent)
        else
            local NewContent = self.SelectiveDisplayedContents[1]
            if NewContent then
                self:OnRoleListItemClicked(NewContent)
                self.TileView_Select_Role:BP_SetSelectedItem(NewContent)
                self.TileView_Select_Role:BP_ScrollItemIntoView(NewContent)
            end
        end
    end
    self:SetIsEmpty(#self.SelectiveDisplayedContents == 0)
    if #self.SelectiveDisplayedContents == 0 then
        self.TileView_Select_Role:SetVisibility(UIConst.VisibilityOp.Collapsed)
    else
        self.TileView_Select_Role:SetVisibility(UIConst.VisibilityOp.Visible)
    end
end

function M:SetIsEmpty(bIsEmpty)
    if bIsEmpty then
        self.Com_EmptyBg:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
        self.Com_EmptyBg:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

function M:OnTileRoleItemClicked(Content)
    self:OnRoleListItemClicked(Content)
end

function M:OnFilterListItemClicked(Content)
    if Content.Tag == self.CurrentFilterTag then return end
    -- 取消旧选中
    local Items = self.EMListView_Filter:GetListItems()
    local Len = Items:Length()
    for I = 1, Len do
        local Item = Items[I]
        if Item.Tag == self.CurrentFilterTag then
            Item.IsSelected = false
            if Item.UI and Item.UI.SetIsSelected then
                Item.UI:SetIsSelected(false)
            end
            break
        end
    end
    -- 设置新选中
    self.CurrentFilterTag = Content.Tag
    Content.IsSelected = true
    if Content.UI and Content.UI.SetIsSelected then
        Content.UI:SetIsSelected(true)
    end
    self:FillSelectiveTileView()
end

function M:OnSelectiveSortChanged()
    --local SortByIdx, SortType = self.Common_Sort_List:GetSortInfos()
    --if(self.Event_SortFuncion)then
    --    self.Event_SortFuncion(self.EventReceiver,self.FilteredContents,SortByIdx, SortType)
    --    self:FillListView()
    --end
end

function M:CreateFilters(InTags,InTexts,InIcons,ExcelWeaponTags)
    local Filters = {}
    for i, value in ipairs(InTags) do
        table.insert(Filters,{
            Tag = value,
            Text = InTexts[i],
            Icon = InIcons[i],
            bShowRecommend = ExcelWeaponTags and CommonUtils.HasValue(ExcelWeaponTags,value)
        })
    end
    return Filters
end

-- 统一判断是否已拥有某角色皮肤
function M:HasSkin(CharId, SkinId)
    if not CharId or not SkinId then return false end
    local Avatar = GWorld:GetAvatar()
    if not Avatar or not Avatar.CommonChars then return false end
    local CommonChar = Avatar.CommonChars[CharId]
    local OtherCharSkins = Avatar.OtherCharSkins[CharId]

    if CommonChar and CommonChar.OwnedSkins then
        for Id, _ in pairs(CommonChar.OwnedSkins) do
            if Id == SkinId then
                return true
            end
        end
    end

    if OtherCharSkins then
        for _, Id in pairs(OtherCharSkins) do
            if Id == SkinId then
                return true
            end
        end
        
    end
    
    return false
end

-- 统一判断是否已拥有某武器皮肤
function M:HasWeaponSkin(SkinId)
    if not SkinId then return false end
    local Avatar = GWorld:GetAvatar()
    if Avatar.OwnedWeaponSkins[SkinId] then
        return true
    else
        return false
    end
end

function M:HasAccessory(Type, Id)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return false end
    local AccessoryList = Avatar[Type.."s"]
    if AccessoryList then
        for _, AccessoryId in pairs(AccessoryList) do
            if AccessoryId == Id then
                return true
            end
        end
    end
    return false
end

function M:RefreshDetailPanel()
    local Content = self.CurRoleContent
    local CharId = Content.UnitId
    local SkinId = self.CharId2SkinId and self.CharId2SkinId[CharId] or self.InitSkinId

    DebugPrint("gmy@WBP_CharSkinPreview_C M:RefreshDetailPanel", self.CurRoleContent, CharId, SkinId)
    local SkinData = DataMgr.Skin[SkinId]
    local CharCfg = DataMgr.Char[CharId]

    self.Text_CharName:SetText(GText(CharCfg.CharName))
    self.Text_SkinName:SetText(GText(SkinData.SkinName))
    local SkinNameFont = { nil, nil, "Font_Blue", "Font_Purple", "Font_Gold", "Font_Red"} --分别对应稀有度1，2，3，4，5，6
    if SkinData.Rarity and SkinNameFont[SkinData.Rarity] and self[SkinNameFont[SkinData.Rarity]] then
        self.Text_SkinName:SetFont(self[SkinNameFont[SkinData.Rarity]])
    end
    self.Text_SkinName_World:SetText(EnText(SkinData.SkinName))
    self.Text_Info:SetText(GText(SkinData.SkinDescribe))
    self.Tag_Quality:Init(SkinData.Rarity)
    self.Tag_Quality:SetVisibility(ESlateVisibility.SelfHitTestInvisible)

    local ElementType = DataMgr.BattleChar[CharId].Attribute
    if ElementType then
        local IconName = "Armory_" .. ElementType
        local AttributeIcon = LoadObject('/Game/UI/Texture/Dynamic/Atlas/Armory/T_' .. IconName .. '.T_' .. IconName)
        self.Icon_Element:SetBrushResourceObject(AttributeIcon)
        self.Icon_Element:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
        self.Icon_Element:SetVisibility(ESlateVisibility.Collapsed)
    end

    DebugPrint("gmy@WBP_CharSkinPreview_C M:RefreshDetailPanel IsOwned", Content.IsOwned)
    if Content.IsOwned then
        self.Text_Char_None:SetVisibility(ESlateVisibility.Collapsed)
    else
        self.Text_Char_None:SetText(GText("UI_SkinPreview_CharNotOwned"))
        self.Text_Char_None:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end

    local bHasSkin = self:HasSkin(CharId, SkinId)

    local bHasChar = Content.IsOwned
    DebugPrint("SkinOwnCheck", CharId, SkinId, bHasSkin)
    if bHasSkin then
        self.Text_Consume:SetText(GText("UI_Already_Have_Char_Skin"))

    elseif not bHasChar then
        self.Text_Consume:SetText(GText("UI_Skin_Not_Have_Char"))
    else
        self.Text_Consume:SetText(GText("UI_Consume_Select_Skin"))
    end

    if bHasChar and not bHasSkin then
        self.Icon_Hint:SetVisibility(ESlateVisibility.Collapsed)
    else
        self.Icon_Hint:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end

    self:PlayAnimation(self.Change)
    if self.OptRewardId and self.Params.Mode ~= "Preview" then
        self.Panel_Consume:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Btn_Confirm:SetVisibility(ESlateVisibility.Visible)
    else
        self.Panel_Consume:SetVisibility(ESlateVisibility.Collapsed)
        self.Btn_Confirm:SetVisibility(ESlateVisibility.Collapsed)
        return
    end

    local SkinIconPath = SkinData and SkinData.Icon
    local Rarity = SkinData and SkinData.Rarity or 0
    if SkinIconPath then
        DebugPrint("gmy@WBP_CharSkinPreview_C M:RefreshDetailPanel", SkinId)
        local ConsumeContent = {
            Id = SkinId,            -- 使用皮肤 Id
            ItemType = "Skin",     -- 标记类型为皮肤
            Rarity = Rarity,
            Icon = SkinIconPath,
            bAsyncLoadIcon = true,
            IsShowDetails = true,
            bDisableCommonClick = true,
            Des = GText("ASJHKAJKADSJFSJKDF")
        }
        -- 若已有内容但不是同一个皮肤则刷新；否则尝试更新图标
        if (not self.Item_Consume.Content) or self.Item_Consume.Content.Id ~= SkinId then
            if self.Item_Consume.Init then
                self.Item_Consume:Init(ConsumeContent)
            elseif self.Item_Consume.OnListItemObjectSet then
                self.Item_Consume:OnListItemObjectSet(ConsumeContent)
            end
        else
            if self.Item_Consume.SetIcon then
                self.Item_Consume:SetIcon(SkinIconPath)
            end
        end

        self.Item_Consume:SetIsGot(bHasSkin)
    else
        DebugPrint("WBP_CharSkinPreview_C RefreshDetailPanel 皮肤缺少图标", SkinId)
    end
end


-- 占位：确认按钮点击逻辑（待补充）
function M:OnConfirmClicked()
    local ConfirmId
    if self.Params.Type == "SelectGeneralSkin" then
        local Content = self.CurRoleContent
        local CharId = Content.UnitId
        local SkinId = self.CharId2SkinId[CharId] or self.InitSkinId

        local bHasChar = Content.IsOwned == true
        local bHasSkin = self:HasSkin(CharId, SkinId)

        ConfirmId = OBTAIN_SKIN_POP

        local CharName = GText(DataMgr.Char[CharId].CharName)
        local SkinName = GText(DataMgr.Skin[SkinId].SkinName)


        DebugPrint("gmy@WBP_CharSkinPreview_C M:OnConfirmClicked111", CharId, SkinId, bHasChar, bHasSkin, ConfirmId)
        local ConfirmText
        local ItemList = nil
        if bHasSkin then
            -- 已拥有皮肤, 重复获取
            ConfirmText = string.format(GText("UI_Consumable_Choose_Confirm_Have_Skin"), SkinName)
            ConfirmId = HAS_SKIN_ALERT_POP

            local RegainItemNum = DataMgr.Skin[SkinId].RegainItemNum
            local RegainItemId = DataMgr.Skin[SkinId].RegainItemId
            if RegainItemId and RegainItemNum then
                ItemList =
                {{
                    ItemId = RegainItemId,
                    ItemType = CommonConst.ItemType.Resource,
                    ItemNum = RegainItemNum,
                }}
            end
        elseif bHasChar then
            -- 已拥有角色但未拥有皮肤(正常)
            ConfirmText = string.format(GText("UI_Consumable_Choose_Confirm"), SkinName)
        else
            -- 未拥有角色
            ConfirmText = string.format(GText("UI_Skin_CharHasnotGottenReminder"), CharName, SkinName)
        end

        DebugPrint("WBP_CharSkinPreview_C OnConfirmClicked", ConfirmId, CharId, SkinId, bHasChar, bHasSkin, ConfirmText)

        local Params = {
            CharId = CharId,
            SkinId = SkinId,
            bHasChar = bHasChar,
            bHasSkin = bHasSkin,
            SkinOptRewardId = self.OptRewardId,
            ResourceId = self.ResourceId,
            Content = Content,
        }

        local PopupParams = {
            RightCallbackObj = self,
            RightCallbackFunction = function()
                if self._ApplyingSkin then return end
                self._ApplyingSkin = true
                self:DoApplySkinOptReward(Params)
                self._ApplyingSkin = nil
            end,
            LeftCallbackObj = self,
            LeftCallbackFunction = function() end,
            CloseBtnCallbackObj = self,
            CloseBtnCallbackFunction = function() end,
            ShortText = ConfirmText,
            LongText = ConfirmText,
        }
        PopupParams.ItemList = ItemList
        
        self.SecondConfirmPopup = UIManager(self):ShowCommonPopupUI(ConfirmId, PopupParams, self.EMListView_Role)
    elseif self.Params.Type == "SelectWeaponSkin" then
        self:OnConfirmClicked_WeaponSkin()
        return
    elseif self.Params.Type == "SelectCharAccessory" or self.Params.Type == "SelectWeaponAccessory" then
        self:OnConfirmClicked_Accessory()
        return
    elseif self.Params.Type == "SelectSkin" then
        self:OnConfirmClicked_CharSkin()
        return
    elseif self.Params.Type == "SelectGestureItem" then
        self:OnConfirmClicked_Gesture()
        return
    end

    -- if ConfirmId == HAS_SKIN_ALERT_POP then
    --     self:PopupUIGamepadSetting()
    -- end
end

function M:OnConfirmClicked_WeaponSkin()
    if self.Params.Type == "SelectWeaponSkin" then
        local Content = self.CurRoleContent
        local SkinId = Content.Id

        local bHasSkin = self:HasWeaponSkin(SkinId)

        local ConfirmId = OBTAIN_SKIN_POP

        -- local CharName = GText(DataMgr.Char[CharId].CharName)
        local SkinName = GText(DataMgr.WeaponSkin[SkinId].Name)


        DebugPrint("gmy@WBP_CharSkinPreview_C M:OnConfirmClicked111", SkinId, bHasSkin, ConfirmId)
        local ConfirmText
        local ItemList = nil
        if bHasSkin then
            -- 已拥有皮肤, 重复获取
            ConfirmText = string.format(GText("UI_Consumable_Choose_Confirm_Have_Skin"), SkinName)
            ConfirmId = HAS_SKIN_ALERT_POP

            local RegainItemNum = DataMgr.WeaponSkin[SkinId].RegainItemNum
            local RegainItemId = DataMgr.WeaponSkin[SkinId].RegainItemId
            if RegainItemId and RegainItemNum then
                ItemList =
                {{
                    ItemId = RegainItemId,
                    ItemType = CommonConst.ItemType.Resource,
                    ItemNum = RegainItemNum,
                }}
            end
        else
            -- 未拥有皮肤
            ConfirmText = string.format(GText("UI_Skin_CharHasnotGottenReminder"), SkinName, SkinName)
        end

        DebugPrint("WBP_CharSkinPreview_C OnConfirmClicked", ConfirmId, SkinId, bHasSkin, ConfirmText)

        local Params = {
            SkinId = SkinId,
            bHasSkin = bHasSkin,
            WeaponSkinOptRewardId = self.OptRewardId,
            ResourceId = self.ResourceId,
            Content = Content,
        }

        local PopupParams = {
            RightCallbackObj = self,
            RightCallbackFunction = function()
                if self._ApplyingSkin then return end
                self._ApplyingSkin = true
                self:DoApplyWeaponSkinOptReward(Params)
                self._ApplyingSkin = nil
            end,
            LeftCallbackObj = self,
            LeftCallbackFunction = function() end,
            CloseBtnCallbackObj = self,
            CloseBtnCallbackFunction = function() end,
            ShortText = ConfirmText,
            LongText = ConfirmText,
        }
        PopupParams.ItemList = ItemList

        self.SecondConfirmPopup = UIManager(self):ShowCommonPopupUI(ConfirmId, PopupParams, self.List_Skin)
        
        -- if ConfirmId == HAS_SKIN_ALERT_POP then
        --     self:PopupUIGamepadSetting()
        -- end
    end
end

function M:OnConfirmClicked_CharSkin()
    if self.Params.Type == "SelectSkin" then
        local Content = self.CurRoleContent
        local SkinId = Content.SkinId
        local CharId = Content.CharId

        local bHasSkin = self:HasSkin(CharId, SkinId)

        local ConfirmId = OBTAIN_SKIN_POP

        local SkinName = GText(DataMgr.Skin[SkinId].SkinName)


        DebugPrint("gmy@WBP_CharSkinPreview_C M:OnConfirmClicked111", SkinId, bHasSkin, ConfirmId)
        local ConfirmText
        local ItemList = nil
        if bHasSkin then
            -- 已拥有皮肤, 重复获取
            ConfirmText = string.format(GText("UI_Consumable_Choose_Confirm_Have_Skin"), SkinName)
            ConfirmId = HAS_SKIN_ALERT_POP

            local RegainItemNum = DataMgr.Skin[SkinId].RegainItemNum
            local RegainItemId = DataMgr.Skin[SkinId].RegainItemId
            if RegainItemId and RegainItemNum then
                ItemList =
                {{
                    ItemId = RegainItemId,
                    ItemType = CommonConst.ItemType.Resource,
                    ItemNum = RegainItemNum,
                }}
            end
        else
            -- 未拥有皮肤
            ConfirmText = string.format(GText("UI_Skin_CharHasnotGottenReminder"), SkinName, SkinName)
        end

        DebugPrint("WBP_CharSkinPreview_C OnConfirmClicked", ConfirmId, SkinId, bHasSkin, ConfirmText)

        local Params = {
            SkinId = SkinId,
            bHasSkin = bHasSkin,
            CharSkinOptRewardId = self.OptRewardId,
            ResourceId = self.ResourceId,
            Content = Content,
        }

        local PopupParams = {
            RightCallbackObj = self,
            RightCallbackFunction = function()
                if self._ApplyingSkin then return end
                self._ApplyingSkin = true
                self:DoApplyCharSkinOptReward(Params)
                self._ApplyingSkin = nil
            end,
            LeftCallbackObj = self,
            LeftCallbackFunction = function() end,
            CloseBtnCallbackObj = self,
            CloseBtnCallbackFunction = function() end,
            ShortText = ConfirmText,
            LongText = ConfirmText,
        }
        PopupParams.ItemList = ItemList

        self.SecondConfirmPopup = UIManager(self):ShowCommonPopupUI(ConfirmId, PopupParams, self.List_Skin)
        
        -- if ConfirmId == HAS_SKIN_ALERT_POP then
        --     self:PopupUIGamepadSetting()
        -- end
    end
end

function M:OnConfirmClicked_Accessory()
    if self.Params.Type == "SelectCharAccessory" or self.Params.Type == "SelectWeaponAccessory" then
        local Content = self.CurRoleContent
        local SkinId = Content.Id
        local Type = self.Params.Type == "SelectCharAccessory" and "CharAccessory" or "WeaponAccessory"
        local bHasSkin = self:HasAccessory(Type, SkinId)

        local ConfirmId = OBTAIN_SKIN_POP

        -- local CharName = GText(DataMgr.Char[CharId].CharName)
        local SkinName = GText(DataMgr[Type][SkinId].Name)


        DebugPrint("gmy@WBP_CharSkinPreview_C M:OnConfirmClicked111", SkinId, bHasSkin, ConfirmId)
        local ConfirmText
        local ItemList = nil
        if bHasSkin then
            -- 已拥有皮肤, 重复获取
            ConfirmText = string.format(GText("UI_Consumable_Choose_Confirm_Have_Skin"), SkinName)
            ConfirmId = HAS_SKIN_ALERT_POP

            local RegainItemNum = DataMgr[Type][SkinId].RegainItemNum
            local RegainItemId = DataMgr[Type][SkinId].RegainItemId
            if RegainItemId and RegainItemNum then
                ItemList =
                {{
                    ItemId = RegainItemId,
                    ItemType = CommonConst.ItemType.Resource,
                    ItemNum = RegainItemNum,
                }}
            end
        else
            -- 未拥有皮肤
            ConfirmText = string.format(GText("UI_Skin_CharHasnotGottenReminder"), SkinName, SkinName)
        end

        DebugPrint("WBP_CharSkinPreview_C OnConfirmClicked", ConfirmId, SkinId, bHasSkin, ConfirmText)

        local Params = {
            SkinId = SkinId,
            bHasSkin = bHasSkin,
            AccessoryOptRewardId = self.OptRewardId,
            ResourceId = self.ResourceId,
            Content = Content,
            Type = Type,
        }

        local PopupParams = {
            RightCallbackObj = self,
            RightCallbackFunction = function()
                if self._ApplyingSkin then return end
                self._ApplyingSkin = true
                self:DoApplyAccessoryOptReward(Params)
                self._ApplyingSkin = nil
            end,
            LeftCallbackObj = self,
            LeftCallbackFunction = function() end,
            CloseBtnCallbackObj = self,
            CloseBtnCallbackFunction = function() end,
            ShortText = ConfirmText,
            LongText = ConfirmText,
        }
        PopupParams.ItemList = ItemList

        self.SecondConfirmPopup = UIManager(self):ShowCommonPopupUI(ConfirmId, PopupParams, self.TileView_Pendant)
        
        -- if ConfirmId == HAS_SKIN_ALERT_POP then
        --     self:PopupUIGamepadSetting()
        -- end
    end
end

function M:OnConfirmClicked_Gesture()
    if self.Params.Type == "SelectGestureItem" then
        local Avatar = GWorld:GetAvatar() 
        if not Avatar then return end
        local Content = self.CurRoleContent
        local GestureId = Content.Id
        local Type = Content.ItemType

        -- local bHasSkin = self:HasAccessorySkin(GestureId)
        local bHasSkin = Avatar.Resources[GestureId] and Avatar.Resources[GestureId].Count > 0

        local ConfirmId = OBTAIN_SKIN_POP

        -- local CharName = GText(DataMgr.Char[CharId].CharName)
        local SkinName = GText(Content.Name)


        DebugPrint("gmy@WBP_CharSkinPreview_C M:OnConfirmClicked111", GestureId, bHasSkin, ConfirmId)
        local ConfirmText
        local ItemList = nil
        if bHasSkin then
            -- 已拥有皮肤, 重复获取
            ConfirmText = string.format(GText("UI_Consumable_Choose_Confirm_Have_Skin"), SkinName)
            ConfirmId = HAS_SKIN_ALERT_POP

            local RegainItemNum = DataMgr[Type][GestureId].RegainItemNum
            local RegainItemId = DataMgr[Type][GestureId].RegainItemId
            if RegainItemId and RegainItemNum then
                ItemList =
                {{
                    ItemId = RegainItemId,
                    ItemType = CommonConst.ItemType.Resource,
                    ItemNum = RegainItemNum,
                }}
            else
                Traceback(ErrorTag, string.format("商品Id %s 不存在，策划还没配重复获取的相关信息，别急",GestureId))
            end
        else
            -- 未拥有皮肤
            ConfirmText = string.format(GText("UI_Skin_CharHasnotGottenReminder"), SkinName, SkinName)
        end

        DebugPrint("WBP_CharSkinPreview_C OnConfirmClicked", ConfirmId, GestureId, bHasSkin, ConfirmText)

        local Params = {
            SkinId = GestureId,
            bHasSkin = bHasSkin,
            GeatureOptRewardId = self.OptRewardId,
            ResourceId = self.ResourceId,
            Content = Content,
            Type = Type,
        }

        local PopupParams = {
            RightCallbackObj = self,
            RightCallbackFunction = function()
                if self._ApplyingSkin then return end
                self._ApplyingSkin = true
                self:DoApplyGestureOptReward(Params)
                self._ApplyingSkin = nil
            end,
            LeftCallbackObj = self,
            LeftCallbackFunction = function() end,
            CloseBtnCallbackObj = self,
            CloseBtnCallbackFunction = function() end,
            ShortText = ConfirmText,
            LongText = ConfirmText,
        }
        PopupParams.ItemList = ItemList

        self.SecondConfirmPopup = UIManager(self):ShowCommonPopupUI(ConfirmId, PopupParams, self.TileView_Pendant)
        
        -- if ConfirmId == HAS_SKIN_ALERT_POP then
        --     self:PopupUIGamepadSetting()
        -- end
    end
end
    
function M:DoApplySkinOptReward(Content)
    DebugPrint("WBP_CharSkinPreview_C DoApplySkinOptReward", Content.CharId, Content.SkinId, Content.SkinOptRewardId, Content.bHasSkin)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        DebugPrint("WBP_CharSkinPreview_C DoApplySkinOptReward 无法获取 Avatar")
        return
    end
    local ResourceId = Content.ResourceId
    local SkinOptRewardId = Content.SkinOptRewardId
    local SkinId = Content.SkinId
    local bHasSkin = Content.bHasSkin
    if not (ResourceId and SkinOptRewardId and SkinId) then
        DebugPrint("WBP_CharSkinPreview_C DoApplySkinOptReward 参数缺失", ResourceId, SkinOptRewardId, SkinId)
        return
    end
    local OptCfg = DataMgr.OptReward and DataMgr.OptReward[SkinOptRewardId]
    if not (OptCfg and OptCfg.Id) then
        DebugPrint("WBP_CharSkinPreview_C DoApplySkinOptReward 找不到自选奖励配置", SkinOptRewardId)
        return
    end
    -- 找到皮肤在配置 Id 列表中的索引(ChooseIndex)
    local ChooseIndex
    for idx, id in ipairs(OptCfg.Id) do
        if id == SkinId then
            ChooseIndex = idx
            break
        end
    end
    if not ChooseIndex then
        DebugPrint("WBP_CharSkinPreview_C DoApplySkinOptReward 未找到对应皮肤索引", SkinId)
        return
    end
    local OptIdxList = { ChooseIndex }
    DebugPrint("WBP_CharSkinPreview_C DoApplySkinOptReward 调用RPC UseOptResourceInBag", ResourceId, ChooseIndex)
    local function OnFinish(ErrCode)
        DebugPrint("WBP_CharSkinPreview_C DoApplySkinOptReward 回调成功", ErrCode, ResourceId, SkinId, ChooseIndex, bHasSkin)
        
        if ErrCode == ErrorCode.RET_SUCCESS then
            local BagMainPage = UIManager(self):GetUIObj("BagMain")
            if BagMainPage then
                BagMainPage:AddTimer(0.3, function()
                    -- 根据服务端要求，领取数据由客户端自己获取
                    if bHasSkin then
                        local RegainItemId = DataMgr.Skin[SkinId].RegainItemId
                        local RegainItemNum = DataMgr.Skin[SkinId].RegainItemNum
                        UIUtils.ShowGetItemPage(CommonConst.ItemType.Resource, RegainItemId, RegainItemNum, nil, nil, nil, nil, true, true)
                    else
                        UIUtils.ShowGetItemPage("Skin", SkinId, 1, nil, nil, nil, nil, true, true)
                    end
                end)
            else
                local ArmorySkinPage = UIManager(self):GetUIObj("ArmorySkin")
                if ArmorySkinPage then
                    -- 军械库跳转使用自选包
                    ArmorySkinPage:AddTimer(0.3, function()
                        UIUtils.ShowGetItemPage("Skin", SkinId, 1, nil, nil, nil, nil, true, true)
                    end)
                end
            end
        end
        
        self:Close()
    end

    Avatar:UseOptResourceInBag(ResourceId, OptIdxList, OnFinish)

    -- 直接关闭，防止连续点击
    self:Close()
end

function M:DoApplyWeaponSkinOptReward(Content)
    DebugPrint("WBP_CharSkinPreview_C DoApplyWeaponSkinOptReward", Content.SkinId, Content.WeaponSkinOptRewardId, Content.bHasSkin)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        DebugPrint("WBP_CharSkinPreview_C DoApplyWeaponSkinOptReward 无法获取 Avatar")
        return
    end
    local ResourceId = Content.ResourceId
    local WeaponSkinOptRewardId = Content.WeaponSkinOptRewardId
    local SkinId = Content.SkinId
    local bHasSkin = Content.bHasSkin
    if not (ResourceId and WeaponSkinOptRewardId and SkinId) then
        DebugPrint("WBP_CharSkinPreview_C DoApplyWeaponSkinOptReward 参数缺失", ResourceId, WeaponSkinOptRewardId, SkinId)
        return
    end
    local OptCfg = DataMgr.OptReward and DataMgr.OptReward[WeaponSkinOptRewardId]
    if not (OptCfg and OptCfg.Id) then
        DebugPrint("WBP_CharSkinPreview_C DoApplyWeaponSkinOptReward 找不到自选奖励配置", WeaponSkinOptRewardId)
        return
    end
    -- 找到皮肤在配置 Id 列表中的索引(ChooseIndex)
    local ChooseIndex
    for idx, id in ipairs(OptCfg.Id) do
        if id == SkinId then
            ChooseIndex = idx
            break
        end
    end
    if not ChooseIndex then
        DebugPrint("WBP_CharSkinPreview_C DoApplyWeaponSkinOptReward 未找到对应皮肤索引", SkinId)
        return
    end
    local OptIdxList = { ChooseIndex }
    DebugPrint("WBP_CharSkinPreview_C DoApplyWeaponSkinOptReward 调用RPC UseOptResourceInBag", ResourceId, ChooseIndex)
    local function OnFinish(ErrCode)
        DebugPrint("WBP_CharSkinPreview_C DoApplyWeaponSkinOptReward 回调成功", ErrCode, ResourceId, SkinId, ChooseIndex, bHasSkin)
        
        if ErrCode == ErrorCode.RET_SUCCESS then
            local BagMainPage = UIManager(self):GetUIObj("BagMain")
            if BagMainPage then
                BagMainPage:AddTimer(0.3, function()
                    -- 根据服务端要求，领取数据由客户端自己获取
                    if bHasSkin then
                        local RegainItemId = DataMgr.WeaponSkin[SkinId].RegainItemId
                        local RegainItemNum = DataMgr.WeaponSkin[SkinId].RegainItemNum
                        UIUtils.ShowGetItemPage(CommonConst.ItemType.Resource, RegainItemId, RegainItemNum, nil, nil, nil, nil, true, true)
                    else
                        UIUtils.ShowGetItemPage("WeaponSkin", SkinId, 1, nil, nil, nil, nil, true, true)
                    end
                end)
            else
                local ArmorySkinPage = UIManager(self):GetUIObj("ArmorySkin")
                if ArmorySkinPage then
                    -- 军械库跳转使用自选包
                    ArmorySkinPage:AddTimer(0.3, function()
                        UIUtils.ShowGetItemPage("WeaponSkin", SkinId, 1, nil, nil, nil, nil, true, true)
                    end)
                end
            end
        end
        
        self:Close()
    end

    Avatar:UseOptResourceInBag(ResourceId, OptIdxList, OnFinish)

    -- 直接关闭，防止连续点击
    self:Close()
end

function M:DoApplyCharSkinOptReward(Content)
    DebugPrint("WBP_CharSkinPreview_C DoApplyWeaponSkinOptReward", Content.SkinId, Content.CharSkinOptRewardId, Content.bHasSkin)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        DebugPrint("WBP_CharSkinPreview_C DoApplyWeaponSkinOptReward 无法获取 Avatar")
        return
    end
    local ResourceId = Content.ResourceId
    local CharSkinOptRewardId = Content.CharSkinOptRewardId
    local SkinId = Content.SkinId
    local bHasSkin = Content.bHasSkin
    if not (ResourceId and CharSkinOptRewardId and SkinId) then
        DebugPrint("WBP_CharSkinPreview_C DoApplyWeaponSkinOptReward 参数缺失", ResourceId, CharSkinOptRewardId, SkinId)
        return
    end
    local OptCfg = DataMgr.OptReward and DataMgr.OptReward[CharSkinOptRewardId]
    if not (OptCfg and OptCfg.Id) then
        DebugPrint("WBP_CharSkinPreview_C DoApplyWeaponSkinOptReward 找不到自选奖励配置", CharSkinOptRewardId)
        return
    end
    -- 找到皮肤在配置 Id 列表中的索引(ChooseIndex)
    local ChooseIndex
    for idx, id in ipairs(OptCfg.Id) do
        if id == SkinId then
            ChooseIndex = idx
            break
        end
    end
    if not ChooseIndex then
        DebugPrint("WBP_CharSkinPreview_C DoApplyWeaponSkinOptReward 未找到对应皮肤索引", SkinId)
        return
    end
    local OptIdxList = { ChooseIndex }
    DebugPrint("WBP_CharSkinPreview_C DoApplyWeaponSkinOptReward 调用RPC UseOptResourceInBag", ResourceId, ChooseIndex)
    local function OnFinish(ErrCode)
        DebugPrint("WBP_CharSkinPreview_C DoApplyWeaponSkinOptReward 回调成功", ErrCode, ResourceId, SkinId, ChooseIndex, bHasSkin)
        
        if ErrCode == ErrorCode.RET_SUCCESS then
            local BagMainPage = UIManager(self):GetUIObj("BagMain")
            if BagMainPage then
                BagMainPage:AddTimer(0, function()
                    -- 根据服务端要求，领取数据由客户端自己获取
                    if bHasSkin then
                        local RegainItemId = DataMgr.Skin[SkinId].RegainItemId
                        local RegainItemNum = DataMgr.Skin[SkinId].RegainItemNum
                        UIUtils.ShowGetItemPage(CommonConst.ItemType.Resource, RegainItemId, RegainItemNum, nil, nil, nil, nil, true, true)
                    else
                        UIUtils.ShowGetItemPage("Skin", SkinId, 1, nil, nil, nil, nil, true, true)
                    end
                end)
            else
                local ArmorySkinPage = UIManager(self):GetUIObj("ArmorySkin")
                if ArmorySkinPage then
                    -- 军械库跳转使用自选包
                    ArmorySkinPage:AddTimer(0.3, function()
                        UIUtils.ShowGetItemPage("Skin", SkinId, 1, nil, nil, nil, nil, true, true)
                    end)
                end
            end
        end
        
        self:Close()
    end

    Avatar:UseOptResourceInBag(ResourceId, OptIdxList, OnFinish)

    -- 直接关闭，防止连续点击
    self:Close()
end

function M:DoApplyAccessoryOptReward(Content)
    DebugPrint("WBP_CharSkinPreview_C DoApplyAccessoryOptReward", Content.SkinId, Content.AccessoryOptRewardId, Content.bHasSkin)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        DebugPrint("WBP_CharSkinPreview_C DoApplyAccessoryOptReward 无法获取 Avatar")
        return
    end
    local ResourceId = Content.ResourceId
    local AccessoryOptRewardId = Content.AccessoryOptRewardId
    local SkinId = Content.SkinId
    local bHasSkin = Content.bHasSkin
    local Type = Content.Type
    if not (ResourceId and AccessoryOptRewardId and SkinId) then
        DebugPrint("WBP_CharSkinPreview_C DoApplyAccessoryOptReward 参数缺失", ResourceId, AccessoryOptRewardId, SkinId)
        return
    end
    local OptCfg = DataMgr.OptReward and DataMgr.OptReward[AccessoryOptRewardId]
    if not (OptCfg and OptCfg.Id) then
        DebugPrint("WBP_CharSkinPreview_C DoApplyAccessoryOptReward 找不到自选奖励配置", AccessoryOptRewardId)
        return
    end
    -- 找到皮肤在配置 Id 列表中的索引(ChooseIndex)
    local ChooseIndex
    for idx, id in ipairs(OptCfg.Id) do
        if id == SkinId then
            ChooseIndex = idx
            break
        end
    end
    if not ChooseIndex then
        DebugPrint("WBP_CharSkinPreview_C DoApplyAccessoryOptReward 未找到对应皮肤索引", SkinId)
        return
    end
    local OptIdxList = { ChooseIndex }
    DebugPrint("WBP_CharSkinPreview_C DoApplyAccessoryOptReward 调用RPC UseOptResourceInBag", ResourceId, ChooseIndex)
    local function OnFinish(ErrCode)
        DebugPrint("WBP_CharSkinPreview_C DoApplyWeaponSkinOptReward 回调成功", ErrCode, ResourceId, SkinId, ChooseIndex, bHasSkin)
        
        if ErrCode == ErrorCode.RET_SUCCESS then
            local BagMainPage = UIManager(self):GetUIObj("BagMain")
            if BagMainPage then
                BagMainPage:AddTimer(0.3, function()
                    -- 根据服务端要求，领取数据由客户端自己获取
                    if bHasSkin then
                        local RegainItemId = DataMgr[Type][SkinId].RegainItemId
                        local RegainItemNum = DataMgr[Type][SkinId].RegainItemNum
                        UIUtils.ShowGetItemPage(CommonConst.ItemType.Resource, RegainItemId, RegainItemNum, nil, nil, nil, nil, true, true)
                    else
                        UIUtils.ShowGetItemPage(Type, SkinId, 1, nil, nil, nil, nil, true, true)
                    end
                end)
            else
                local ArmorySkinPage = UIManager(self):GetUIObj("ArmorySkin")
                if ArmorySkinPage then
                    -- 军械库跳转使用自选包
                    ArmorySkinPage:AddTimer(0.3, function()
                        UIUtils.ShowGetItemPage(Type, SkinId, 1, nil, nil, nil, nil, true, true)
                    end)
                end
            end
        end
        
        self:Close()
    end

    Avatar:UseOptResourceInBag(ResourceId, OptIdxList, OnFinish)

    -- 直接关闭，防止连续点击
    self:Close()
end

function M:DoApplyGestureOptReward(Content)
    DebugPrint("WBP_CharSkinPreview_C DoApplyAccessoryOptReward", Content.SkinId, Content.ResourceId, Content.bHasSkin)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        DebugPrint("WBP_CharSkinPreview_C DoApplyAccessoryOptReward 无法获取 Avatar")
        return
    end
    local ResourceId = Content.ResourceId
    local SkinId = Content.SkinId
    local bHasSkin = Content.bHasSkin
    local Type = Content.Type
    local GestureOptRewardId = Content.GeatureOptRewardId
    if not (ResourceId and SkinId) then
        DebugPrint("WBP_CharSkinPreview_C DoApplyAccessoryOptReward 参数缺失", ResourceId, SkinId)
        return
    end
    local OptCfg = DataMgr.OptReward and DataMgr.OptReward[GestureOptRewardId]
    if not (OptCfg and OptCfg.Id) then
        DebugPrint("WBP_CharSkinPreview_C DoApplyAccessoryOptReward 找不到自选奖励配置", GestureOptRewardId)
        return
    end
    -- 找到皮肤在配置 Id 列表中的索引(ChooseIndex)
    local ChooseIndex
    for idx, id in ipairs(OptCfg.Id) do
        if id == SkinId then
            ChooseIndex = idx
            break
        end
    end
    if not ChooseIndex then
        DebugPrint("WBP_CharSkinPreview_C DoApplyAccessoryOptReward 未找到对应皮肤索引", SkinId)
        return
    end
    local OptIdxList = { ChooseIndex }
    DebugPrint("WBP_CharSkinPreview_C DoApplyAccessoryOptReward 调用RPC UseOptResourceInBag", ResourceId, ChooseIndex)
    local function OnFinish(ErrCode)
        DebugPrint("WBP_CharSkinPreview_C DoApplyWeaponSkinOptReward 回调成功", ErrCode, ResourceId, SkinId, ChooseIndex, bHasSkin)
        
        if ErrCode == ErrorCode.RET_SUCCESS then
            local BagMainPage = UIManager(self):GetUIObj("BagMain")
            if BagMainPage then
                BagMainPage:AddTimer(0.3, function()
                    -- 根据服务端要求，领取数据由客户端自己获取
                    if bHasSkin then
                        local RegainItemId = DataMgr[Type][SkinId].RegainItemId
                        local RegainItemNum = DataMgr[Type][SkinId].RegainItemNum
                        UIUtils.ShowGetItemPage(CommonConst.ItemType.Resource, RegainItemId, RegainItemNum, nil, nil, nil, nil, true, true)
                    else
                        UIUtils.ShowGetItemPage(Type, SkinId, 1, nil, nil, nil, nil, true, true)
                    end
                end)
            else
                local ArmorySkinPage = UIManager(self):GetUIObj("ArmorySkin")
                if ArmorySkinPage then
                    -- 军械库跳转使用自选包
                    ArmorySkinPage:AddTimer(0.3, function()
                        UIUtils.ShowGetItemPage(Type, SkinId, 1, nil, nil, nil, nil, true, true)
                    end)
                end
            end
        end
        
        self:Close()
    end

    Avatar:UseOptResourceInBag(ResourceId, OptIdxList, OnFinish)

    -- 直接关闭，防止连续点击
    self:Close()
end
--endregion


function M:ToggleRoleListPanel()
    if self.bRoleListOpen then
        self:CloseRoleListPanel()
    else
        self:OpenRoleListPanel()
    end
end


-- 统一播放列表展开动画的方法，方便后续替换动画资源
function M:PlayRoleListAnimation()
    -- 仅负责播放列表展开动画
    DebugPrint("gmy@WBP_CharSkinPreview_C M:PlayRoleListAnimation", self.Change_List)
    self:StopAllAnimations()
    if self.Change_List then
        self:PlayAnimation(self.Change_List)
    end
end

-- 回到Tab状态时播放的动画
function M:PlayTabAnimation()
    DebugPrint("gmy@WBP_CharSkinPreview_C M:PlayTabAnimation", self.Change_Tab)
    self:StopAllAnimations()
    if self.Change_Tab then
        self:PlayAnimation(self.Change_Tab)
    end
end

-- 在展开列表时重置筛选为默认“全部”
function M:ResetFilterToDefault()
    DebugPrint("gmy@WBP_CharSkinPreview_C M:ResetFilterToDefault", self.CurrentFilterTag)
    if not self.EMListView_Filter or not self.EMListView_Filter.GetListItems then
        self.CurrentFilterTag = "ALL"
        self:FillSelectiveTileView()
        return
    end

    local Items = self.EMListView_Filter:GetListItems()
    if not Items then
        self.CurrentFilterTag = "ALL"
        self:FillSelectiveTileView()
        return
    end

    -- 若当前已是 ALL，确保 UI 状态正确并刷新 TileView
    if self.CurrentFilterTag == "ALL" then
        local LenA = Items:Length()
        for i = 1, LenA do
            local It = Items[i]
            if It and It.Tag == "ALL" then
                It.IsSelected = true
                if It.UI and It.UI.SetIsSelected then
                    It.UI:SetIsSelected(true)
                end
                break
            end
        end
        self:FillSelectiveTileView()
        return
    end

    -- 查找 ALL 项并走统一点击逻辑
    local Len = Items:Length()
    local AllItem
    for i = 1, Len do
        local It = Items[i]
        if It and It.Tag == "ALL" then
            AllItem = It
            break
        end
    end

    if AllItem then
        self:OnFilterListItemClicked(AllItem)
    else
        -- 兜底：直接设置
        self.CurrentFilterTag = "ALL"
        if self.FilterContentObj_All then
            self.FilterContentObj_All.IsSelected = true
            if self.FilterContentObj_All.UI and self.FilterContentObj_All.UI.SetIsSelected then
                self.FilterContentObj_All.UI:SetIsSelected(true)
            end
        end
        self:FillSelectiveTileView()
    end
end

function M:OpenRoleListPanel()
    if self.bRoleListOpen then return end
    self.bRoleListOpen = true
    self.CurState = M.State_List
    self:ApplyRoleListVisibility()

    -- 切换到 TileView_Select_Role 时重置筛选为默认“全部”
    self:ResetFilterToDefault()

    self:PlayRoleListAnimation()

    if self.CurRoleContent then
        self.TileView_Select_Role:BP_SetSelectedItem(self.CurRoleContent)
        self.TileView_Select_Role:BP_ScrollItemIntoView(self.CurRoleContent)
    end
    self.TileView_Select_Role:SetFocus()
    self.bConsumeFocused = false
end

function M:CloseRoleListPanel()
    if not self.bRoleListOpen then return end
    self.bRoleListOpen = false
    self.CurState = M.State_Tab
    self:ApplyRoleListVisibility()
    self:PlayTabAnimation()

    if self.CurRoleContent then
        if self.EMListView_Role.BP_SetSelectedItem then
            self.EMListView_Role:BP_SetSelectedItem(self.CurRoleContent)
        end
        self.EMListView_Role:BP_ScrollItemIntoView(self.CurRoleContent)
    end
    if self.EMListView_Role then
        self.EMListView_Role:SetFocus()
    end
    self.bConsumeFocused = false
end

function M:ApplyRoleListVisibility()
    DebugPrint("gmy@WBP_CharSkinPreview_C M:ApplyRoleListVisibility", self.bRoleListOpen)

    local bShow = self.bRoleListOpen
    local VisShow = ESlateVisibility.SelfHitTestInvisible
    local VisHide = ESlateVisibility.Collapsed
    self.Panel_List:SetVisibility(bShow and VisShow or VisHide)
    self.Panel_List_L:SetVisibility(bShow and VisShow or VisHide)
    self.WS_List:SetActiveWidgetIndex(bShow and 0 or 1)
    self.EMListView_Filter:SetVisibility(bShow and VisShow or VisHide)

    self.TileView_Select_Role:SetVisibility(bShow and VisShow or VisHide)
    self.EMListView_Role:SetVisibility((not bShow) and VisShow or VisHide)

    -- 同步消费快捷键显示：列表展开时隐藏；列表关闭时按输入设备显示
    if self.Key_Consume_GamePad then
        if bShow then
            self.Key_Consume_GamePad:SetVisibility(ESlateVisibility.Collapsed)
        else
            if self:IsGamepadInput() then
                self.Key_Consume_GamePad:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            else
                self.Key_Consume_GamePad:SetVisibility(ESlateVisibility.Collapsed)
            end
        end
    end

    -- 列表展开时禁用确认按钮并屏蔽手柄 A；列表关闭时恢复
    if bShow then
        self.Btn_Confirm.IsEnabled = false
    else
        self.Btn_Confirm.IsEnabled = true
    end
    
    -- 同步手柄图标显隐：仅在手柄输入时处理；展开时折叠，关闭时显示
    if self:IsGamepadInput() then
        if bShow then
            self.Btn_Confirm:SetGamePadVisibility(UIConst.VisibilityOp["Collapsed"])
        else
            self.Btn_Confirm:SetGamePadVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        end
    else
        self.Btn_Confirm:SetGamePadVisibility(UIConst.VisibilityOp["Collapsed"])
    end
end

function M:OnAnalogValueChanged(_MyGeometry, InAnalogInputEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if InKeyName == "Gamepad_RightX" and BattlePassController:GetModelData("BagActorController") then
        local DeltaX = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 10
        BattlePassController:GetModelData("BagActorController"):OnDragViewActor({X = DeltaX})
        return UIUtils.Handled
    end
    return UIUtils.Unhandled
end

-- 判断当前是否为手柄输入模式
function M:IsGamepadInput()
    return self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad
end

function M:PopupUIGamepadSetting()
    -- self.SecondConfirmPopup.OpenTipsButtonIndex = self.SecondConfirmPopup:InitGamepadShortcut({
    --     KeyInfoList={
    --         {
    --             Type = "Img",
    --             ImgShortPath = UIConst.GamePadImgKey.LeftThumb
    --         },
    --     },
    --     Desc = GText("UI_Controller_CheckDetails"),
    -- })
    -- self.SecondConfirmPopup.ConfirmButtonIndex = self.SecondConfirmPopup:InitGamepadShortcut({
    --     KeyInfoList={
    --         {
    --             Type = "Img",
    --             ImgShortPath = UIConst.GamePadImgKey.FaceButtonBottom
    --         },
    --     },
    --     Desc = GText("UI_Tips_Ensure"),
    -- })
    -- self.SecondConfirmPopup.CancelButtonIndex = self.SecondConfirmPopup:InitGamepadShortcut({
    --     KeyInfoList={
    --         {
    --             Type = "Img",
    --             ImgShortPath = UIConst.GamePadImgKey.FaceButtonRight
    --         },
    --     },
    --     Desc = GText("UI_BACK"),
    -- })
    -- self.SecondConfirmPopup:HideGamepadShortcut(self.SecondConfirmPopup.ConfirmButtonIndex)
    -- self.SecondConfirmPopup:HideGamepadShortcut(self.SecondConfirmPopup.CancelButtonIndex)

    -- local ItemWidget = self.SecondConfirmPopup:GetContentWidgetByName("ItemSubsize")
    -- if ItemWidget then
    --     ItemWidget.OnContentKeyDown = self.OnContentKeyDown
    --     local Item = ItemWidget.Item:GetChildAt(0)
    --     if Item then
    --         Item:BindEventOnMenuOpenChanged(self, self.ItemMenuAnchorChanged)
    --     end
    -- end
end

function M:OnContentKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)

    local IsEventHandled = false
    local Item = self.Item:GetChildAt(0)
    if InKeyName == UIConst.GamePadKey.LeftThumb then
        if Item then
            Item:SetFocus()
            self.Owner.ButtonBar:SetGamepadBtnKeyVisibility(false)
            self.Owner:ShowGamepadShortcut(self.Owner.ConfirmButtonIndex)
            self.Owner:ShowGamepadShortcut(self.Owner.CancelButtonIndex)
            self.Owner:HideGamepadShortcut(self.Owner.OpenTipsButtonIndex)
            IsEventHandled = true
        end
    elseif InKeyName == UIConst.GamePadKey.FaceButtonRight then
        if (Item:HasAnyUserFocus() or Item:HasFocusedDescendants()) then
            self.Owner.ButtonBar:SetGamepadBtnKeyVisibility(true)
            self.Owner:HideGamepadShortcut(self.Owner.ConfirmButtonIndex)
            self.Owner:HideGamepadShortcut(self.Owner.CancelButtonIndex)
            self.Owner:ShowGamepadShortcut(self.Owner.OpenTipsButtonIndex)
            self.Owner:SetFocus()
            IsEventHandled = true
        end
    end
    return IsEventHandled
end

function M:OnFocusReceivedEvent()
    self.IsFromListContent = true
end

--武器皮肤相关
function M:InitWeaponParams()
    self.Switch_Type:SetActiveWidgetIndex(1)
    if self.Params then
        self.BehaviorType = self.Params.Type
        self.OptRewardId = self.Params.OptRewardId
        self.ResourceId = self.Params.ResourceId
        self.PreSelectSkinId = self.Params.SkinId
    end

    local Avatar = GWorld:GetAvatar()
    if Avatar then
        local OptReward = DataMgr.OptReward[self.OptRewardId]
        local PreviewSkinId = OptReward and OptReward.Id[1]
        local PreviewParams = {
            Type = "Weapon",
            SkinId = PreviewSkinId,
            EPreviewSceneType = CommonConst.EPreviewSceneType.PreviewCommon,
            ViewUI = self,
        }
        local Target = self:CreatePreviewTargetData(PreviewParams)
        PreviewParams.Target = Target
        self.ActorController = self:CreatePreviewActor(PreviewParams)
        BattlePassController:SetModelData("BagActorController", self.ActorController)
        BattlePassController:GetModelData("BagActorController"):OnOpened()
        BattlePassController:GetModel():AddModelDataRefCount("BagActorController")
        self.IsPreviewMode = true
    end

    self:InitWeaponSkinList()
end

function M:InitWeaponSkinList()
    self.WeaponSkinContents = {}
    local OptReward = DataMgr.OptReward[self.OptRewardId]
    for Index, Id in pairs(OptReward.Id) do
        local SkinData = DataMgr.WeaponSkin[Id]
        if(SkinData)then
            local Content = NewObject(UIUtils.GetCommonItemContentClass())
            Content.ItemType = CommonConst.DataType.WeaponSkin
            Content.Icon = SkinData.Icon or ""
            Content.IconPath = SkinData.LongIcon
            Content.Id = SkinData.SkinID
            Content.SortPriority = SkinData.SortPriority or 0
            Content.IsHide = SkinData.IsHide
            Content.LockType = false
            Content.Rarity= SkinData.Rarity or 0
            Content.bSelectTag = false
            Content.IsSelect = false
            Content.Parent = self
            Content.Name = SkinData.Name
            Content.Des = SkinData.Dec
            Content.ApplicationType = SkinData.ApplicationType
            Content.IsOwned = false -- temp
            Content.Owner = self
            Content.IsPreviewMode = false
            Content.OnClicked = self.OnGamepadConfirmKeyDonw
            Content.IsNew = false
            Content.bHasGot = self:HasWeaponSkin(SkinData.SkinID)
            table.insert(self.WeaponSkinContents, Content)
        end
    end

    --优先级：已拥有 > Id 
    --暂不对稀有度进行排序
    table.sort(self.WeaponSkinContents, function(a, b)
        local aOwn = a.bHasGot and 1 or 0
        local bOwn = b.bHasGot and 1 or 0
        if aOwn ~= bOwn then
            return aOwn < bOwn
        end
        local aId = a.Id or 0
        local bId = b.Id or 0
        return aId < bId 
    end)
    self:InitSkinList(self.WeaponSkinContents)
end

function M:InitSkinList(FilteredContents)
    self.FilteredContents = FilteredContents
    self.List_Skin:ClearListItems()
    -- self:UpdateAccessoryDetails(FilteredContents[1])
    self.List_Skin:SetVisibility(UIConst.VisibilityOp.Visible)
    --无配饰放在前面
    -- self.List_Skin:AddItem(self.NoneAccessory)
    local SelectFirstItem = false
    local PreSelectSkinContent = nil
    for _, Content in ipairs(FilteredContents) do
        if(self.JumpToAccessoryId)then
            if(self.JumpToAccessoryId == Content.AccessoryId)then
                self.ComparedContent = Content
            end
        end
        if(Content.bSelectTag)then
            self.CurrentContent = Content
            if(self.IsCharacterTrialMode) then
                Content.TryOutText = GText("UI_CharPreview_Accessory_In_Trial")
            end
        end
        if not SelectFirstItem then
            Content.IsSelect = true
            SelectFirstItem = true
        end
        if self.PreSelectSkinId and Content.SkinId == self.PreSelectSkinId then
            PreSelectSkinContent = Content
        end
        self.List_Skin:AddItem(Content)
    end
    self.List_Skin:RequestFillEmptyContent()
    -- self.List_Skin:RequestPlayEntriesAnim()

    -- 模拟点击list_skin的第一个元素，触发详情面板刷新
    if PreSelectSkinContent then
        self:AddDelayFrameFunc(function()
            self:OnSkinItemClicked(PreSelectSkinContent)
            if PreSelectSkinContent.SelfWidget then
                PreSelectSkinContent.SelfWidget:SetFocus()
            end
        end, 3)
    else
        local FirstItem = self.List_Skin:GetListItems()[1]
        if FirstItem then
            self:OnSkinItemClicked(FirstItem)
        end
    end
end
--endregion

--角色皮肤相关
function M:InitCharParams()
    self.Switch_Type:SetActiveWidgetIndex(1)
    if self.Params then
        self.BehaviorType = self.Params.Type
        self.OptRewardId = self.Params.OptRewardId
        self.ResourceId = self.Params.ResourceId
        self.PreSelectSkinId = self.Params.SkinId
    end

    local Avatar = GWorld:GetAvatar()
    if Avatar then
        local OptReward = DataMgr.OptReward[self.OptRewardId]
        local PreviewSkinId = OptReward and OptReward.Id[1]
        local PreviewParams = {
            Type = "Char",
            SkinId = PreviewSkinId,
            EPreviewSceneType = CommonConst.EPreviewSceneType.PreviewCommon,
            ViewUI = self,
        }
        local Target = self:CreatePreviewTargetData(PreviewParams)
        PreviewParams.Target = Target
        self.ActorController = self:CreatePreviewActor(PreviewParams)
        BattlePassController:SetModelData("BagActorController", self.ActorController)
        BattlePassController:GetModelData("BagActorController"):OnOpened()
        BattlePassController:GetModel():AddModelDataRefCount("BagActorController")
        self.IsPreviewMode = true
    end

    self:InitCharSkinList()
end

function M:InitCharSkinList()
    self.CharSkinContents = {}
    local OptReward = DataMgr.OptReward[self.OptRewardId]
    for Index, Id in pairs(OptReward.Id) do
        local SkinData = DataMgr.Skin[Id]
        if(SkinData)then
            local Content = NewObject(UIUtils.GetCommonItemContentClass())
            Content.ItemType = CommonConst.DataType.Skin
            Content.Icon = SkinData.Icon or ""
            Content.IconPath = SkinData.LongIcon
            Content.SkinId = SkinData.SkinId
            Content.CharId = SkinData.CharId
            Content.SortPriority = SkinData.SortPriority or 0
            Content.IsHide = SkinData.IsHide
            Content.LockType = false
            Content.Rarity= SkinData.Rarity or 0
            Content.IsSelect = false
            Content.Parent = self
            Content.Name = SkinData.SkinName
            Content.Des = SkinData.SkinDescribe
            Content.ApplicationType = SkinData.ApplicationType
            Content.Owner = self
            Content.OnClicked = self.OnGamepadConfirmKeyDonw
            Content.IsPreviewMode = false
            Content.IsOwned = false
            Content.bHasGot = self:HasSkin(SkinData.CharId, SkinData.SkinId)
            table.insert(self.CharSkinContents, Content)
        end
    end

    --优先级：已拥有 > Id 
    --暂不对稀有度进行排序
    table.sort(self.CharSkinContents, function(a, b)
        local aOwn = a.bHasGot and 1 or 0
        local bOwn = b.bHasGot and 1 or 0
        if aOwn ~= bOwn then
            return aOwn < bOwn
        end
        local aId = a.Id or 0
        local bId = b.Id or 0
        return aId < bId 
    end)
    self:InitSkinList(self.CharSkinContents)
end
--endregion

--角色配饰相关
function M:InitAccessoryParams()
    self.Switch_Type:SetActiveWidgetIndex(2)
    if self.Params then
        self.BehaviorType = self.Params.Type
        self.OptRewardId = self.Params.OptRewardId
        self.ResourceId = self.Params.ResourceId
        self.PreSelectAccessoryId = self.Params.AccessoryId
    end
    local OptReward = DataMgr.OptReward[self.Params.OptRewardId]
    local Type = OptReward and OptReward.Type[1]
    self.AccessoryContents = {}
    self.Map_AccessoryContents = {}
    local Avatar = GWorld:GetAvatar()
    for Index, Id in pairs(OptReward.Id) do
        local Content = self:CreateCharAccessoryContent(DataMgr.CharAccessory[Id])
        if (Content) then
            Content.SoundDataName = "CharAccessory"
            table.insert(self.AccessoryContents, Content)
            self.Map_AccessoryContents[Id] = Content
        end
    end

    local Avatar = GWorld:GetAvatar()
    if Avatar then
        local PreviewAccessoryId = OptReward and OptReward.Id[1]
        local PreviewParams = {
            Type = "Char",
            -- SkinId = PreviewSkinId,
            EPreviewSceneType = CommonConst.EPreviewSceneType.PreviewCommon,
            ViewUI = self,
            SkinId = self.Params.SkinId,
        }
        local Target = self:CreatePreviewTargetData(PreviewParams)
        PreviewParams.Target = Target
        self.ActorController = self:CreatePreviewActor(PreviewParams)
        BattlePassController:SetModelData("BagActorController", self.ActorController)
        BattlePassController:GetModelData("BagActorController"):OnOpened()
        BattlePassController:GetModel():AddModelDataRefCount("BagActorController")
        self.IsPreviewMode = true
    end
    self:InitAccessoryList()
end

function M:CreateCharAccessoryContent(Data)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    if(Data.AccessoryType)then
        local bCreateContent = true
        if(bCreateContent)then
            local Obj = NewObject(UIUtils.GetCommonItemContentClass())
            Obj.ItemType = CommonConst.DataType.CharAccessory
            Obj.Icon = Data.Icon or ""
            Obj.Id = Data.AccessoryId
            Obj.AccessoryId = Data.AccessoryId
            Obj.SortPriority = Data.SortPriority or 0
            Obj.IsHide = Data.IsHide
            Obj.LockType = 0
            Obj.Rarity= Data.Rarity or 0
            Obj.bSelectTag = false
            Obj.IsSelect = false
            Obj.AccessoryType = Data.AccessoryType
            Obj.PartName = Data.PartName
            Obj.UnlockOptionText = GText(Data.UnlockOption or "")
            Obj.Parent = self
            Obj.Name = Data.Name
            Obj.Des = Data.Des
            Obj.ItemName = self:HasAccessory(CommonConst.DataType.CharAccessory, Data.AccessoryId) and GText("UI_SHOP_ALREADYOWNED")
            Obj.OnMouseButtonDownEvent = {
                Obj = self,
                Callback = self.OnGamepadConfirmKeyDonw,
                Params = {
                    Content = Obj,
                    bIgnoreRightMouseDown = true,
                }
            }
            return Obj
        end
    end
end

function M:InitAccessoryList()
    local Len = #self.AccessoryContents
    local FilteredContents = {}
    for i = 1,Len do
        local Content = self.AccessoryContents[i]
        if(Content.AccessoryId)then
            table.insert(FilteredContents,Content)
        end
    end
    self:InitList(FilteredContents)
end

function M:InitList(FilteredContents)
    self.FilteredContents = FilteredContents
    self.TileView_Pendant:ClearListItems()
    --优先级：已拥有 > Id
    --暂不对稀有度进行排序
    table.sort(FilteredContents, function(a, b)
        local aOwn = (a.ItemName and a.ItemName ~= "") and 1 or 0
        local bOwn = (b.ItemName and b.ItemName ~= "") and 1 or 0
        if aOwn ~= bOwn then
            return aOwn < bOwn
        end
        local aId = a.Id or 0
        local bId = b.Id or 0
        return aId < bId
    end)
    -- self:UpdateAccessoryDetails(FilteredContents[1])
    self.TileView_Pendant:SetVisibility(UIConst.VisibilityOp.Visible)
    --无配饰放在前面
    -- self.TileView_Pendant:AddItem(self.NoneAccessory)
    local PreSelectAccessoryContent = nil
    for _, Content in ipairs(FilteredContents) do
        if(self.JumpToAccessoryId)then
            if(self.JumpToAccessoryId == Content.AccessoryId)then
                self.ComparedContent = Content
            end
        end
        if(Content.bSelectTag)then
            self.CurrentContent = Content
            if(self.IsCharacterTrialMode) then
                Content.TryOutText = GText("UI_CharPreview_Accessory_In_Trial")
            end
        end
        if self.PreSelectAccessoryId and self.PreSelectAccessoryId == Content.AccessoryId then
            PreSelectAccessoryContent = Content
        end
        self.TileView_Pendant:AddItem(Content)
    end
    self.TileView_Pendant:RequestFillEmptyContent()
    -- self.TileView_Pendant:RequestPlayEntriesAnim()

    -- 模拟点击TileView_Pendant的第一个元素，触发详情面板刷新
    if PreSelectAccessoryContent then
        self:AddDelayFrameFunc(function()
            self:OnAccessoryItemClicked(PreSelectAccessoryContent)
            if PreSelectAccessoryContent.SelfWidget then
                PreSelectAccessoryContent.SelfWidget:SetFocus()
            end
        end, 3)
    else
        local FirstItem = self.TileView_Pendant:GetListItems()[1]
        if FirstItem then
            self:OnAccessoryItemClicked(FirstItem)
        end
    end
end
--endregion

--武器配饰相关
function M:InitWeaponAccessoryParams()
    self.Switch_Type:SetActiveWidgetIndex(2)
    if self.Params then
        self.BehaviorType = self.Params.Type
        self.OptRewardId = self.Params.OptRewardId
        self.ResourceId = self.Params.ResourceId
        self.PreSelectAccessoryId = self.Params.AccessoryId
    end
    local OptReward = DataMgr.OptReward[self.Params.OptRewardId]
    local Type = OptReward and OptReward.Type[1]
    self.AccessoryContents = {}
    self.Map_AccessoryContents = {}
    local Avatar = GWorld:GetAvatar()
    for Index, Id in pairs(OptReward.Id) do
        local Content = self:CreateWeaponAccessoryContent(DataMgr.WeaponAccessory[Id])
        if (Content) then
            Content.SoundDataName = "WeaponAccessory"
            -- self.BP_AccessoryContents:Add(Content)
            table.insert(self.AccessoryContents, Content)
            self.Map_AccessoryContents[Id] = Content
        end
    end

    local Avatar = GWorld:GetAvatar()
    if Avatar then
        local PreviewAccessoryId = OptReward and OptReward.Id[1]
        local PreviewParams = {
            Type = "Weapon",
            -- SkinId = PreviewSkinId,
            EPreviewSceneType = CommonConst.EPreviewSceneType.PreviewCommon,
            ViewUI = self,
        }
        local Target = self:CreatePreviewTargetData(PreviewParams)
        PreviewParams.Target = Target
        self.ActorController = self:CreatePreviewActor(PreviewParams)
        BattlePassController:SetModelData("BagActorController", self.ActorController)
        BattlePassController:GetModelData("BagActorController"):OnOpened()
        BattlePassController:GetModel():AddModelDataRefCount("BagActorController")
        self.IsPreviewMode = true
    end
    self:InitAccessoryList()
end

function M:CreateWeaponAccessoryContent(Data)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    if(Data)then
        local bCreateContent = true
        if(bCreateContent)then
            local Obj = NewObject(UIUtils.GetCommonItemContentClass())
            Obj.ItemType = CommonConst.DataType.WeaponAccessory
            Obj.Icon = Data.Icon or ""
            Obj.Id = Data.WeaponAccessoryId
            Obj.AccessoryId = Data.WeaponAccessoryId
            Obj.SortPriority = Data.SortPriority or 0
            Obj.IsHide = Data.IsHide
            Obj.LockType = 0
            Obj.Rarity= Data.Rarity or 0
            Obj.bSelectTag = false
            Obj.IsSelect = false
            Obj.AccessoryType = "WeaponAccessory"
            Obj.PartName = Data.PartName
            Obj.UnlockOptionText = GText(Data.UnlockOption or "")
            Obj.Parent = self
            Obj.Name = Data.Name
            Obj.Des = Data.Des
            Obj.ItemName = self:HasAccessory(CommonConst.DataType.WeaponAccessory, Data.WeaponAccessoryId) and GText("UI_SHOP_ALREADYOWNED")
            Obj.OnMouseButtonDownEvent = {
                Obj = self,
                Callback = self.OnGamepadConfirmKeyDonw,
                Params = {
                    Content = Obj,
                    bIgnoreRightMouseDown = true,
                }
            }
            return Obj
        end
    end
end
--endregion

--region 轮盘动作相关
function M:InitGestureItemParams()
    self.Switch_Type:SetActiveWidgetIndex(2)
    if self.Params then
        self.BehaviorType = self.Params.Type
        self.OptRewardId = self.Params.OptRewardId
        self.ResourceId = self.Params.ResourceId
        self.PreSelectAccessoryId = self.Params.GestureId
    end
    local OptReward = DataMgr.OptReward[self.Params.OptRewardId]
    local Type = OptReward and OptReward.Type[1]
    self.GestureContents = {}
    self.Map_GestureContents = {}
    local Avatar = GWorld:GetAvatar()
    for Index, Id in pairs(OptReward.Id) do
        local Content = self:CreateGestureContent(DataMgr.Resource[Id])
        if (Content) then
            Content.SoundDataName = "WeaponAccessory"
            table.insert(self.GestureContents, Content)
            self.Map_GestureContents[Id] = Content
        end
    end

    local Avatar = GWorld:GetAvatar()
    if Avatar then
        local PreviewGestureId = OptReward and OptReward.Id[1]
        local PreviewParams = {
            Type = "Char",
            -- SkinId = PreviewSkinId,
            EPreviewSceneType = CommonConst.EPreviewSceneType.PreviewCommon,
            ViewUI = self,
        }
        local Target = self:CreatePreviewTargetData(PreviewParams)
        PreviewParams.Target = Target
        self.ActorController = self:CreatePreviewActor(PreviewParams)
        BattlePassController:SetModelData("BagActorController", self.ActorController)
        BattlePassController:GetModelData("BagActorController"):OnOpened()
        BattlePassController:GetModel():AddModelDataRefCount("BagActorController")
        self.IsPreviewMode = true
    end
    self:InitGestureList()
end

function M:CreateGestureContent(Data)
    if(Data)then
        local bCreateContent = true
        local Avatar = GWorld:GetAvatar()
        if not Avatar then return end
        if(bCreateContent)then
            local Obj = NewObject(UIUtils.GetCommonItemContentClass())
            Obj.Id = Data.ResourceId
            Obj.ItemType = CommonConst.DataType.Resource
            Obj.Icon = Data.Icon or ""
            Obj.SortPriority = Data.SortPriority or 0
            Obj.IsHide = Data.IsHide
            Obj.LockType = 0
            Obj.Rarity= Data.Rarity or 0
            Obj.bSelectTag = false
            Obj.IsSelect = false
            Obj.AccessoryType = "Gesture"
            Obj.UnlockOptionText = GText(Data.UnlockOption or "")
            Obj.Parent = self
            Obj.Name = Data.ResourceName
            Obj.Des = Data.DetailDes
            Obj.ItemName = Avatar.Resources[Data.ResourceId] and Avatar.Resources[Data.ResourceId].Count > 0 and GText("UI_SHOP_ALREADYOWNED")
            Obj.OnMouseButtonDownEvent = {
                Obj = self,
                Callback = self.OnGamepadConfirmKeyDonw,
                Params = {
                    Content = Obj,
                    bIgnoreRightMouseDown = true,
                }
            }
            return Obj
        end
    end
end

function M:InitGestureList()
    local Len = #self.GestureContents
    local FilteredContents = {}
    for i = 1,Len do
        local Content = self.GestureContents[i]
        if(Content.Id)then
            table.insert(FilteredContents,Content)
        end
    end
    self:InitList(FilteredContents)
end
--endregion

---配饰点击时
function M:OnAccessoryItemClicked(Content)
    if Content.AccessoryType == "Gesture" then
        self:TrySelectGestureItem(Content)
    else
        self:TrySelectAccessoryItem(Content)
    end
end

function M:TrySelectAccessoryItem(Content)
    if(self.ComparedContent == Content or not Content.Icon)then
        return
    end
    AudioManager(self):PlayUISound(self, "event:/ui/common/click", nil, nil)
    if(Content.AccessoryId)then
        AudioManager(self):PlayItemSound(self,Content.AccessoryId,"Equip",Content.SoundDataName)
    end
    self:SelectAccessoryItem(Content)
end

function M:SelectAccessoryItem(Content)
    ArmoryUtils:SetItemIsSelected(self.ComparedContent,false)
    self.ComparedContent = Content
    ArmoryUtils:SetItemIsSelected(self.ComparedContent,true)
    self.CurRoleContent = Content
    self:UpdateAccessoryDetails(Content)
    if(self.Params.Type == "SelectCharAccessory")then
        self:ClearCharAccessoryPreview()
        self.ActorController:DestoryPlayerMeleeWeapon()
        BattlePassController:GetModelData("BagActorController"):StopPlayerFX()
        BattlePassController:GetModelData("BagActorController"):StopPlayerMontage()
        self.ActorController:HidePlayerActor("CharSkinPreview", false)
        if UIConst.FXAccessoryTypes[Content.AccessoryType] then
            BattlePassController:GetModelData("BagActorController"):ShowPlayerFXAccessory(Content.AccessoryId, Content.AccessoryType)
            if UIConst.HidePlayerAccessoryTypes[Content.AccessoryType] then
                self.ActorController:HidePlayerActor("CharSkinPreview", true)
            end
        else
            BattlePassController:GetModelData("BagActorController"):ChangeCharAccessory(Content.AccessoryId,Content.AccessoryType)
        end
        self.ActorController:SetArmoryCameraTag("Char", Content.AccessoryType, "")
    else
        BattlePassController:GetModelData("BagActorController"):ChangeWeaponAccessory(Content.AccessoryId,CommonConst.WeaponAccessoryTypes.Accessory)
    end
end

function M:UpdateAccessoryDetails(Content)
    if not Content then
        Content = self.TileView_Pendant:GetItemAt(0)
    end
    self.Text_SkinName:SetText(GText(Content.Name))
    self:UpdateSkinNameFontByRarity(Content.Rarity)
    if(Content.ItemType == "CharAccessory")then
        local Name = DataMgr.CharAccessory[Content.AccessoryId] or DataMgr.CharPartMesh[Content.AccessoryId]
        self.Text_CharName:SetText(GText(UIConst.AccessoryTypeTextMap[Name.AccessoryType] or ""))
    else
        local Name = DataMgr.WeaponAccessory[Content.AccessoryId]
        self.Text_CharName:SetText(GText(UIConst.AccessoryTypeTextMap["WeaponAccessory"]))
    end
    self.Text_Char_None:SetVisibility(ESlateVisibility.Collapsed)
    self.Text_Info:SetText(GText(Content.Des))
    self.Tag_Quality:Init(Content.Rarity)

    local AccessoryIconPath = ArmoryUtils:GetCharNoneAccessoryIconPaths()[Content.AccessoryType]
    if AccessoryIconPath then
        local AccessoryIcon = LoadObject(AccessoryIconPath)
        self.Icon_Element:SetBrushResourceObject(AccessoryIcon)
        self.Icon_Element:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
        self.Icon_Element:SetVisibility(ESlateVisibility.Collapsed)
    end

    local IconPath = Content and Content.Icon or ""
    local Rarity = Content and Content.Rarity or 0
    if IconPath then
        DebugPrint("gmy@WBP_CharSkinPreview_C M:RefreshDetailPanel", Content.Id)
        local ConsumeContent = {
            Id = Content.Id,            -- 使用皮肤 Id
            ItemType = "CharAccessory",     -- 标记类型为皮肤
            Rarity = Rarity,
            Icon = IconPath,
            bAsyncLoadIcon = true,
            IsShowDetails = true,
            bDisableCommonClick = true,
            Des = GText("ASJHKAJKADSJFSJKDF")
        }
        -- 若已有内容但不是同一个皮肤则刷新；否则尝试更新图标
        if (not self.Item_Consume.Content) or self.Item_Consume.Content.Id ~= Content.Id then
            if self.Item_Consume.Init then
                self.Item_Consume:Init(ConsumeContent)
            elseif self.Item_Consume.OnListItemObjectSet then
                self.Item_Consume:OnListItemObjectSet(ConsumeContent)
            end
        else
            if self.Item_Consume.SetIcon then
                self.Item_Consume:SetIcon(IconPath)
            end
        end
    end
end

function M:TrySelectGestureItem(Content)
    if(self.ComparedContent == Content or not Content.Icon)then
        return
    end
    AudioManager(self):PlayUISound(self, "event:/ui/common/click", nil, nil)
    if(Content.Id)then
        AudioManager(self):PlayItemSound(self,Content.Id,"Equip",Content.SoundDataName)
    end
    self:SelectGestureItem(Content)
end

function M:SelectGestureItem(Content)
    ArmoryUtils:SetItemIsSelected(self.ComparedContent,false)
    self.ComparedContent = Content
    ArmoryUtils:SetItemIsSelected(self.ComparedContent,true)
    self.CurRoleContent = Content
    local ItemData = {}
    ItemData.ItemType = Content.ItemType
    ItemData.TypeId = Content.Id
    ItemData.SinglePreview = true
    ItemData.HidePurchase = true

    self:UpdateGesturePreview(Content)
    self:UpdateGestureDetails(Content)
end

function M:UpdateGestureDetails(Content)
    if not Content then
        Content = self.TileView_Pendant:GetItemAt(0)
    end
    self.Text_SkinName:SetText(GText(Content.Name))
    self:UpdateSkinNameFontByRarity(Content.Rarity)
    local Name = DataMgr.Resource[Content.Id]
    self.Text_CharName:SetText(GText(Name.ResourceName))
    self.Text_Char_None:SetVisibility(ESlateVisibility.Collapsed)
    self.Text_Info:SetText(GText(Content.Des))
    self.Tag_Quality:Init(Content.Rarity)

    local AccessoryIconPath = ArmoryUtils:GetCharNoneAccessoryIconPaths()[Content.AccessoryType]
    if AccessoryIconPath then
        local AccessoryIcon = LoadObject(AccessoryIconPath)
        self.Icon_Element:SetBrushResourceObject(AccessoryIcon)
        self.Icon_Element:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
        self.Icon_Element:SetVisibility(ESlateVisibility.Collapsed)
    end

    local IconPath = Content and Content.Icon or ""
    local Rarity = Content and Content.Rarity or 0
    if IconPath then
        DebugPrint("gmy@WBP_CharSkinPreview_C M:RefreshDetailPanel", Content.Id)
        local ConsumeContent = {
            Id = Content.Id,            -- 使用皮肤 Id
            ItemType = "GeatureItem",     -- 标记类型为皮肤
            Rarity = Rarity,
            Icon = IconPath,
            bAsyncLoadIcon = true,
            IsShowDetails = true,
            bDisableCommonClick = true,
            Des = GText("")
        }
        -- 若已有内容但不是同一个皮肤则刷新；否则尝试更新图标
        if (not self.Item_Consume.Content) or self.Item_Consume.Content.Id ~= Content.Id then
            if self.Item_Consume.Init then
                self.Item_Consume:Init(ConsumeContent)
            elseif self.Item_Consume.OnListItemObjectSet then
                self.Item_Consume:OnListItemObjectSet(ConsumeContent)
            end
        else
            if self.Item_Consume.SetIcon then
                self.Item_Consume:SetIcon(IconPath)
            end
        end
    end
end

function M:UpdateGesturePreview(Content)
    local ResourceData = DataMgr.Resource[Content.Id]
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    if ResourceData then
        if ResourceData.ResourceSType == "GestureItem" then
            self.ActorController:ChangeWeaponModel(Avatar.Weapons[Avatar.MeleeWeapon])
            self.ActorController:ChangeWeaponModel(Avatar.Weapons[Avatar.RangedWeapon])

            self.EffectCreatureHideTags = {}
            if self.ActorController.ArmoryPlayer.EffectCreatureHideTags then
                for k, v in pairs(self.ActorController.ArmoryPlayer.EffectCreatureHideTags) do
                    self.EffectCreatureHideTags[k] = v
                    self.ActorController.ArmoryPlayer:HideAllEffectCreature(k, false)
                end
            end
            self.ActorController:SetArmoryMontageTag("Armory")
            self.ActorController:SetArmoryCameraTag(ResourceData.CameraName or "Char", "", "")
            self.ActorController:PlayResourceMotion(Content.Id)
        elseif ResourceData.ResourceSType == "MountItem" then
            -- TODO 坐骑预览
        end
    end
end
--endregion

--皮肤点击时
function M:OnSkinItemClicked(Content)
    self:TrySelectSkinItem(Content)
end

function M:TrySelectSkinItem(Content)
    if(self.ComparedContent == Content or not Content.Icon)then
        return
    end
    AudioManager(self):PlayUISound(self, "event:/ui/common/click", nil, nil)
    if(Content.AccessoryId)then
        AudioManager(self):PlayItemSound(self,Content.AccessoryId,"Equip",Content.SoundDataName)
    end
    self:SelectSkinItem(Content)
end

function M:SelectSkinItem(Content)
    if(not Content)then return end
    local SelectedContent = self.CurRoleContent
    if(SelectedContent)then
        SelectedContent.IsSelect = false
        if(SelectedContent.Widget)then
            SelectedContent.Widget:SetIsSelected(SelectedContent.IsSelect)
        end
    end
    SelectedContent = Content
    if(SelectedContent)then
        SelectedContent.IsSelect = true
        if(SelectedContent.Widget)then
            SelectedContent.Widget:SetIsSelected(SelectedContent.IsSelect)
        else
            self:AddTimer(0.01, function()
                SelectedContent.Widget:SetIsSelected(SelectedContent.IsSelect)
            end)
        end
    end

    self.ComparedContent = Content
    self.CurRoleContent = Content
    if Content.ItemType == "WeaponSkin" then
        self:UpdatePreviewWeaponSkinActorForContent(Content)
        self:UpdateWeaponSkinDetails(Content)
    else
        self:UpdatePreviewCharSkinActorForContent(Content)
        self:UpdateCharSkinDetails(Content)
    end
end

-- 根据选中武器皮肤更新预览模型
function M:UpdatePreviewWeaponSkinActorForContent(Content)
    local WeaponData = self:CreatePreviewTargetData({
        Type = "Weapon", 
        SkinId = Content.Id, 
        EPreviewSceneType = CommonConst.EPreviewSceneType.PreviewCommon,
        ViewUI = self,})
    BattlePassController:GetModelData("BagActorController"):ChangeSingleWeapon(WeaponData)
    self.IsPreviewMode = true
    -- self:EnterSkinCameraAnimation()
end

--根据选中角色皮肤更新预览模型
function M:UpdatePreviewCharSkinActorForContent(Content)
    local CharData = self:CreatePreviewTargetData({
        Type = "Char", 
        SkinId = Content.SkinId,
    })
    local AppearanceInfo = {CharId = Content.CharId, SkinId = Content.SkinId, AccessorySuit = {}}
    BattlePassController:GetModelData("BagActorController").bStandaloneWeapon = false
    BattlePassController:GetModelData("BagActorController").ArmoryHelper:SetOriginalRotation(FRotator(0, 90, 0))
    BattlePassController:GetModelData("BagActorController").ExCameraOffset = FVector(0, 0, 0)
    BattlePassController:GetModelData("BagActorController"):ChangeCharModel(CharData)
    BattlePassController:GetModelData("BagActorController").ArmoryHelper:SetPlayer(BattlePassController:GetModelData("BagActorController").ArmoryPlayer)
    BattlePassController:GetModelData("BagActorController").DelayFrame = 30
    BattlePassController:GetModelData("BagActorController"):SetMontageAndCamera("Char", nil, nil)
    BattlePassController:GetModelData("BagActorController"):ChangeCharAppearance(AppearanceInfo)
    self.IsPreviewMode = true
end

function M:UpdateWeaponSkinDetails(Content)
    if not Content then
        Content = self.List_Skin:GetItemAt(0)
    end

    local WeaponTypeInfo = DataMgr.WeaponTypeContrast[Content.ApplicationType]
    if not WeaponTypeInfo then
        return
    end
    -- 设置武器种类名称和图标
    self:PlayAnimation(self.Change)
    self.Text_CharName:SetText(string.format(GText("UI_SkinPreview_WeaponType"), GText(WeaponTypeInfo.WeaponTagTextmap)))
    if WeaponTypeInfo.Icon then
        local TagIcon = LoadObject(WeaponTypeInfo.Icon)
        self.Icon_Element:SetBrushResourceObject(TagIcon)
        self.Icon_Element:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    else
        self.Icon_Element:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end
    self.Text_SkinName:SetText(GText(Content.Name))
    self:UpdateSkinNameFontByRarity(Content.Rarity)
    self.Text_Char_None:SetVisibility(ESlateVisibility.Collapsed)
    self.Text_Info:SetText(GText(Content.Des))
    self.Tag_Quality:Init(Content.Rarity)

    local IconPath = Content and Content.Icon or ""
    local Rarity = Content and Content.Rarity or 0
    if IconPath then
        DebugPrint("gmy@WBP_CharSkinPreview_C M:RefreshDetailPanel", Content.Id)
        local ConsumeContent = {
            Id = Content.Id,            -- 使用皮肤 Id
            ItemType = "WeaponSkin",     -- 标记类型为皮肤
            Rarity = Rarity,
            Icon = IconPath,
            bAsyncLoadIcon = true,
            IsShowDetails = true,
            bDisableCommonClick = true,
            Des = GText(Content.Des)
        }
        -- 若已有内容但不是同一个皮肤则刷新；否则尝试更新图标
        if (not self.Item_Consume.Content) or self.Item_Consume.Content.Id ~= Content.Id then
            if self.Item_Consume.Init then
                self.Item_Consume:Init(ConsumeContent)
            elseif self.Item_Consume.OnListItemObjectSet then
                self.Item_Consume:OnListItemObjectSet(ConsumeContent)
            end
        else
            if self.Item_Consume.SetIcon then
                self.Item_Consume:SetIcon(IconPath)
            end
        end
    end
end

function M:UpdateCharSkinDetails(Content)
    local SkinData = DataMgr.Skin[Content.SkinId]
    if not SkinData then return end

    local CharInfo = DataMgr.Char[Content.CharId]
    if not CharInfo then return end

    self.Text_CharName:SetText(GText(CharInfo.CharName))
    self.Text_SkinName:SetText(GText(SkinData.SkinName))
    self:UpdateSkinNameFontByRarity(SkinData.Rarity)
    self.Text_Info:SetText(GText(SkinData.SkinDescribe))
    self.Tag_Quality:Init(SkinData.Rarity)
    -- self:UpdateSkinNameFontByRarity(SkinData.Rarity)
    -- self:HideZoomKey(false)

    self.Tag_Quality:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    -- self.HorizontalBox_Color:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    -- self.Tab_Change:SetVisibility(ESlateVisibility.Collapsed)

    -- 设置角色元素图标
    local ElementType = DataMgr.BattleChar[SkinData.CharId].Attribute
    if ElementType then
        local IconName = "Armory_" .. ElementType
        local AttributeIcon = LoadObject('/Game/UI/Texture/Dynamic/Atlas/Armory/T_' .. IconName .. ".T_" .. IconName)
        self.Icon_Element:SetBrushResourceObject(AttributeIcon)
        self.Icon_Element:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
        self.Icon_Element:SetVisibility(ESlateVisibility.Collapsed)
    end

    -- 角色玩家是否拥有
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    if Avatar:CheckCharEnough({[SkinData.CharId] = 1}) then
        self.Text_Char_None:SetVisibility(ESlateVisibility.Collapsed)
    else
        self.Text_Char_None:SetText(GText("UI_SkinPreview_CharNotOwned"))
        self.Text_Char_None:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end

    local IconPath = Content and Content.Icon or ""
    local Rarity = Content and Content.Rarity or 0
    if IconPath then
        local ConsumeContent = {
            Id = Content.SkinId,            -- 使用皮肤 Id
            ItemType = "CharSkin",     -- 标记类型为皮肤
            Rarity = Rarity,
            Icon = IconPath,
            bAsyncLoadIcon = true,
            IsShowDetails = true,
            bDisableCommonClick = true,
            Des = GText(Content.Des)
        }
        -- 若已有内容但不是同一个皮肤则刷新；否则尝试更新图标
        if (not self.Item_Consume.Content) or self.Item_Consume.Content.Id ~= Content.Id then
            if self.Item_Consume.Init then
                self.Item_Consume:Init(ConsumeContent)
            elseif self.Item_Consume.OnListItemObjectSet then
                self.Item_Consume:OnListItemObjectSet(ConsumeContent)
            end
        else
            if self.Item_Consume.SetIcon then
                self.Item_Consume:SetIcon(IconPath)
            end
        end
    end
end
--endregion

function M:InitConsumeInfo()
    if self.Params.Type == "BattlePassPreview" or self.Params.Type == "ShopRecommend" then
        return
    end
    if self.Params.Mode and self.Params.Mode == "Preview" then
        self.Switch_Coin:SetVisibility(ESlateVisibility.Collapsed)
        self.Btn_Confirm:SetVisibility(ESlateVisibility.Collapsed)
    else
        self.Switch_Coin:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
    self.Switch_Coin:SetActiveWidgetIndex(1)
    self.Panel_Buy:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    --参数说明
    --ResourceId:资源Id
    --bShowDenominator:显示消耗结构的分母
    --CostText:显示分母时的提示文本
    --Denominator:消耗结构分母
    --Numerator:消耗结构分子
    --KeyIconName:打开提示的快捷键名称
    --Owner:父蓝图
    local Params = {
        ResourceId = self.ResourceId,
        -- bShowDenominator
        CostText = GText("UI_Armory_Trace_Cost"),
        -- Denominator
        Numerator = 1,
        -- KeyIconName
        Owner = self,
    }
    self.WBP_Com_Cost:InitContent(Params)
    self.WBP_Com_Cost.Key:SetVisibility(ESlateVisibility.Collapsed)
end

--- 武器近战/远程切换回调
function M:OnTabChangeClicked(TabIdx)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    if self.SwitchSuitChecked then
        self.CheckBox_Preview:OnBtnClicked()
    else
        if self.SwitchWeaponAccessoryPreview then
            self:SwitchWeaponAccessoryPreview(TabIdx)
        end
    end
end

function M:UpdateSkinNameFontByRarity(Rarity)
    local rarityFontMap = {
        [6] = self.Font_Red,
        [5] = self.Font_Gold,
        [4] = self.Font_Purple,
        [3] = self.Font_Blue,
    }

    local fontToSet = rarityFontMap[Rarity]
    if fontToSet then
        self.Text_SkinName:SetFont(fontToSet)
    end
end

AssembleComponents(M)
return M
