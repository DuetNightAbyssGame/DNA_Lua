--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Abyss_Dialog
local M = Class("Blueprints.UI.BP_UIState_C")

--function M:Initialize(Initializer)
--end

--function M:PreConstruct(IsDesignTime)
--end

function M:Construct()

end

function M:OnLoaded(...)
    self.Super.OnLoaded(self,...)
    --self.Btn_Close.btn_close.OnClicked:Add(self,self.CloseSelf)
    self.Btn_Close:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.ConfigData=...
    if self.ConfigData.Type==1 then
        self.Text_Title:SetText(GText("Abyss_Buff_1"))
    elseif self.ConfigData.Type==2 then
        self.Text_Title:SetText(GText("Abyss_Buff_2"))
    else
        self.Text_Title:SetText(GText("Abyss_Buff"))
    end
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        self.Btn_Click.OnClicked:Add(self,self.CloseSelf)
    else
        self.Btn_Click:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    self.Text_Tips:SetText(GText("UI_RougeLike_End__ClickEmpty"))
    if self.ConfigData.Type==4 then
        self.Text_Title:SetText(GText("UI_Wiki_EntryUnlock"))
        self.Text_Title01:SetText(GText("Abyss_Buff_1"))
        self.Text_Title02:SetText(GText("Abyss_Buff_2"))
        self.Text_Title01:SetVisibility(UIConst.HitTestInvisible)
        self.Text_Title02:SetVisibility(UIConst.HitTestInvisible)
        self.Panel_Level01:SetVisibility(UIConst.HitTestInvisible)
        self.Panel_Level02:SetVisibility(UIConst.HitTestInvisible)
    else
        self.Panel_Level01:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Panel_Level02:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    self:InitItems()
    if self.ConfigData.Type==2 or self.ConfigData.Type==4 then
        self.ReddotName="AbyssEntry2"
        self:DecreaseReddotDetail(self.ReddotName)
    end
    if self.ConfigData.Type==1 or self.ConfigData.Type==4 then
        self.ReddotName="AbyssEntry1"
        self:DecreaseReddotDetail(self.ReddotName)
    end
    self:RefreshBaseInfo()
    -- ConfigData={

    --         LevelId="",对应的LevelId
    --         Type=1,2,3,4 为3则加载全部词条，1，2为对应关卡的词条,4为新解锁弹窗
    --         AbyssId=1,环境Id
    -- }
    AudioManager(self):PlayUISound(self, "event:/ui/roguelike/affix_info_panel_show", "AbyssEntry", nil)
end

function M:DecreaseReddotDetail()
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(self.ReddotName)
    if CacheDetail and CacheDetail[self.ConfigData.AbyssId] then
        CacheDetail[self.ConfigData.AbyssId] = nil
        ReddotManager.DecreaseLeafNodeCount(self.ReddotName)
    end
end

function M:OnTouchStarted(MyGeometry, InTouchEvent)
    self:CloseSelf()
end

function M:InitItems()
    self.List_Entry:ClearListItems()
    self.List_Entry02:ClearListItems()
    self.List_Entry:DisableScroll(true)
    self.List_Entry02:DisableScroll(true)
    if not self.ConfigData then
        return
    end
    local AbyssLevel = DataMgr.AbyssLevel
    if self.ConfigData.Type==3 then
        local SeasonData=DataMgr.AbyssSeason[self.ConfigData.AbyssId]
        if SeasonData then
            local AllAbyssBuffIDs={}
            local Id=SeasonData.AbyssLevelId[#SeasonData.AbyssLevelId]
            local DungeonId1=AbyssLevel[Id].AbyssDungeon1
            local DungeonId2=AbyssLevel[Id].AbyssDungeon2
            if DungeonId1 then
                local Dungeon1BuffIds=DataMgr.AbyssDungeon[DungeonId1].AbyssBuffID
                if Dungeon1BuffIds then
                    for _, value in pairs(Dungeon1BuffIds) do
                        table.insert(AllAbyssBuffIDs,value)
                    end
                end
            end
            if DungeonId2 then
                local Dungeon2BuffIds=DataMgr.AbyssDungeon[DungeonId2].AbyssBuffID
                if Dungeon2BuffIds then
                    for _, value in pairs(Dungeon2BuffIds) do
                        if not self:Find(AllAbyssBuffIDs,value) then
                            table.insert(AllAbyssBuffIDs,value)
                        end
                    end
                end
            end
            self:IntiListItems(AllAbyssBuffIDs)
        end
    else
        local NowLevel=self.ConfigData.LevelId
        local PreLevel=NowLevel-1
        if self.ConfigData.Type==4 then
            PreLevel=self.ConfigData.LevelId
            NowLevel=PreLevel+1
        end
        local SeasonData=DataMgr.AbyssSeason[self.ConfigData.AbyssId]
        if SeasonData then
            local Id=SeasonData.AbyssLevelId[#SeasonData.AbyssLevelId]
            if self.ConfigData.Type==1 or self.ConfigData.Type==4 then
                local DungeonId1=AbyssLevel[Id].AbyssDungeon1
                if DungeonId1 then
                    local Dungeon1BuffIds=DataMgr.AbyssDungeon[DungeonId1].AbyssBuffID
                    local NowDungeonId1=AbyssLevel[NowLevel].AbyssDungeon1
                    local NowDungeon1BuffIds=DataMgr.AbyssDungeon[NowDungeonId1].AbyssBuffID
                    local PreDungeon1BuffIds={}
                    if AbyssLevel[PreLevel] then
                        local PreDungeonId1=AbyssLevel[PreLevel].AbyssDungeon1
                        PreDungeon1BuffIds=DataMgr.AbyssDungeon[PreDungeonId1].AbyssBuffID
                    end
                    self:IntiListItems(Dungeon1BuffIds,NowDungeon1BuffIds,PreDungeon1BuffIds,true)
                end
            end
            if self.ConfigData.Type==2 or self.ConfigData.Type==4 then
                local DungeonId2=AbyssLevel[Id].AbyssDungeon2
                if DungeonId2 then
                    local Dungeon2BuffIds=DataMgr.AbyssDungeon[DungeonId2].AbyssBuffID
                    local NowDungeonId2=AbyssLevel[NowLevel].AbyssDungeon2
                    local NowDungeon2BuffIds=DataMgr.AbyssDungeon[NowDungeonId2].AbyssBuffID
                    self:IntiListItems(Dungeon2BuffIds, NowDungeon2BuffIds,nil,false)
                end
            end
        end
    end
    local Params={}
    if self.ConfigData.Type==4 then
        Params={AnimName="UnLock"}
        self.List_Entry02:SetRenderOpacity(0)
        self:AddTimer(0.1, function()
        self.List_Entry02:SetRenderOpacity(1)
            UIUtils.PlayListViewFramingInAnimation(self, self.List_Entry02,Params)
        end)
    end
    
    self.List_Entry:SetRenderOpacity(0)
    self:AddTimer(0.1, function()
    self.List_Entry:SetRenderOpacity(1)
        UIUtils.PlayListViewFramingInAnimation(self, self.List_Entry,Params)
    end)
end

function M:IntiListItems(AllAbyssBuffIDs,NowDungeonBuffIds,PreDungeon1BuffIds,IsDungeon1)
    for _, value in pairs(AllAbyssBuffIDs) do
        local ClassPath = UIUtils.GetCommonItemContentClass()
        local MenuContent = NewObject(ClassPath)
        local AbyssBuffData=DataMgr.AbyssBuff[value]
        local ItemConfigData=self:InitConfig(AbyssBuffData)
        ItemConfigData.Unlocked=false
        ItemConfigData.Islocked=false
        if NowDungeonBuffIds  then
            local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("AbyssEntry1")
            if self.ConfigData.Type==2 or not IsDungeon1 then
                CacheDetail = ReddotManager.GetLeafNodeCacheDetail("AbyssEntry2")
            end
            if not self:Find(NowDungeonBuffIds,value) then
                ItemConfigData.Islocked=true
            else
                if CacheDetail[self.ConfigData.AbyssId] and CacheDetail[self.ConfigData.AbyssId][tostring(value)] then
                    ItemConfigData.Unlocked=true
                end
            end
        end
        MenuContent.Owner=self
        MenuContent.ConfigData=ItemConfigData
        if self.ConfigData.Type==4 then
            if ItemConfigData.Unlocked then
                if IsDungeon1 then
                    self.List_Entry:AddItem(MenuContent)
                else
                    self.List_Entry02:AddItem(MenuContent)
                end
            end
        else
            self.List_Entry:AddItem(MenuContent)
        end
    end
    self.List_Entry:SetRenderOpacity(0)
    local Num=self.List_Entry02:GetNumItems()
    if Num==0 then
        self.VerticalBox:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.List_Entry02:SetVisibility(UIConst.VisibilityOp.Collapsed)
    else
        self.VerticalBox:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.List_Entry02:SetVisibility(UIConst.VisibilityOp.Visible)
    end
end

function M:Find(Table,Check)
    for _, value in pairs(Table) do
        if value==Check then
            return true
        end
    end
    return false
end

function M:InitConfig(AbyssBuffData)
    local ItemConfigData={}
    ItemConfigData.BuffInfo=AbyssBuffData.BuffInfo
    ItemConfigData.BuffId=AbyssBuffData.AbyssBuffID
    ItemConfigData.AbyssBuffType=AbyssBuffData.AbyssBuffType
    ItemConfigData.AbyssBuffName=AbyssBuffData.AbyssBuffName
    ItemConfigData.Icon=AbyssBuffData.Icon
    ItemConfigData.AbyssBuffDes=AbyssBuffData.AbyssBuffDes
    ItemConfigData.BuffLockToast=AbyssBuffData.BuffLockToast
    ItemConfigData.AbyssBuffParameter=AbyssBuffData.AbyssBuffParameter
    return ItemConfigData
end

function M:CloseSelf()
    self:Close()
    -- if self:IsAnimationPlaying(self.In) then
    --     return
    -- end
    -- local function PlayAnimFinished()
    --     self:UnbindAllFromAnimationFinished(self.Out)
    --     self:Close()
    -- end
    -- self:BindToAnimationFinished(self.Out, {self, PlayAnimFinished})
    -- self:PlayAnimation(self.Out)
    AudioManager(self):SetEventSoundParam(self, "AbyssEntry", {ToEnd = 1})
end


function M:RefreshBaseInfo()
    -- 刷新设备热键信息
    local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
    if (IsValid(GameInputModeSubsystem)) then
        self:RefreshOpInfoByInputDevice(GameInputModeSubsystem:GetCurrentInputType())
        GameInputModeSubsystem.OnInputMethodChanged:Add(self,self.RefreshOpInfoByInputDevice) 
    end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    self:UpdateUIVisibility(IsUseKeyAndMouse )
    self.Super.RefreshOpInfoByInputDevice(self, CurInputDevice, CurGamepadName)
    if (IsUseKeyAndMouse) then
        -- PC逻辑
    else
        self:InitGamepadView()
    end
end

function M:InitGamepadView()
    if self:HasFocusedDescendants() or self:HasAnyUserFocus() then
       self.List_Entry:SetFocus()
    end
end
function M:UpdateUIVisibility(IsUseKeyAndMouse )
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
        return
    end
    if not IsUseKeyAndMouse  then
        self.Switch_Mode:SetActiveWidgetIndex(1)
        self.List_Entry:SetFocus()
        self.Gamepad_Shortcut02:SetVisibility(UIConst.VisibilityOp.Visible)
        self.Gamepad_Shortcut02:CreateCommonKey({
            KeyInfoList = {
                {
                    Type = "Img",
                    ImgShortPath = "B"
                }
            },
            Desc = GText("UI_CharTrial_ClosePop")
        })
    else
        self.Switch_Mode:SetActiveWidgetIndex(0)
        self.Text_Tips:SetText(GText("UI_RougeLike_End__ClickEmpty"))
    end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)

    if (InKeyName == "Escape" or InKeyName== UIConst.GamePadKey.FaceButtonRight) then
        self:CloseSelf()

    end
end



-- function M:OnNavigateUp(Content)
--     local Id=Content.Id-1
--     if Id>=0 then
--         local Item = Content.OwnerList:GetItemAt(Id)
--         Content.OwnerList:NavigateToIndex(Id)
--         Item.SelfWidget:SetFocus()
--         return Item.SelfWidget
--     end
-- end

-- function M:OnNavigateDown(Content)
--     local Id=Content.Id+1
--     local AllItemCount = Content.OwnerList:GetNumItems()-1
--     if Id<=AllItemCount then
--         local Item = Content.OwnerList:GetItemAt(Id)
--         Content.OwnerList:NavigateToIndex(Id)
--         Item.SelfWidget:SetFocus()
--         return Item.SelfWidget
--     end
-- end

function M:OnAnalogValueChanged(MyGeometry,InAnalogInputEvent)
    if UIUtils.UtilsGetCurrentInputType()==ECommonInputType.Gamepad then
        local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
        local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
        local AddOffset = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 10
        if InKeyName == "Gamepad_LeftY" then
            local CurScrollOffset = self.EMScrollBox_0:GetScrollOffset()
                self.EMScrollBox_0:SetScrollOffset(CurScrollOffset -AddOffset)
        end
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
end


--function M:Tick(MyGeometry, InDeltaTime)
--end

return M
