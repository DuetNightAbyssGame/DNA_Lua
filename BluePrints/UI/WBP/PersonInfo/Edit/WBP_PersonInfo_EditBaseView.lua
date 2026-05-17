require "UnLua"

local PersonInfoCommon = require "BluePrints.UI.WBP.PersonInfo.PersonInfoCommon"
local PersonInfoController = require "BluePrints.UI.WBP.PersonInfo.PersonInfoController"
local EditModel = PersonInfoController:GetEdirModel()
local ArmoryUtils = require "BluePrints.UI.WBP.Armory.ArmoryUtils"
local PersonInfoModel = PersonInfoController:GetModel()
local M = Class( --   {"BluePrints.UI.BP_EMUserWidget_C"}
)
M._components = { -- "BluePrints.UI.WBP.Armory.MainComponent.Armory_ExpandListComponent", 
"BluePrints.UI.WBP.PersonInfo.PersonInfo_ExpandListCompoment", "BluePrints.Common.TimerMgr"}

function M:Initialize()
    self.IsEditPage = true

    -- 当前选中的tab，listitem许多地方用到，注意，选中武器时，CurMainTab.name会被强制修改成Melee或者Ranged
    self.CurMainTab = nil
    -- 武器类型子选项，近战或者远程
    self.SelectedWeaeponTab = nil
    self.SelectBoxIdx = nil -- 不要手动设置，使用OnBoxItemClick
    -- 缓存的展览数据，点击保存后上传
    self.TempCharShowPlan = nil
    self.TempWeaponShowPlan = nil
    -- 选中的item
    self.SelectItem = nil;
    -- 检测是否修改过过数据，若修改过不能直接退出
    self.bHaveChange = false
    -- tips打开时，按esc键和点击空白处关闭
    self.bIsTipsopen = false

    self.TempBoxItem = {} -- 缓存box对应的item，以便取消选择
end

function M:Construct()
    -- 以下两个函数一起调用
    EditModel:InitEditData(self)
    self:InitEditData()
    
    self.TileView_Select_Role.BP_OnItemClicked:Clear()
    self.TileView_Select_Role.BP_OnItemClicked:Add(self, self.OnListItemClicked)
    self.TileView_Select_Role.BP_OnEntryInitialized:Clear()
    self.TileView_Select_Role.BP_OnEntryInitialized:Add(self, self.OnListItemInited)
    self.EMListView_Filter.BP_OnItemClicked:Clear()
    self.Btn_Confirm.Button_Area.OnClicked:Add(self, self.ReallySaveModelData)
    self.Btn_Cancel.Button_Area.OnClicked:Add(self, self.OnReturnKeyDown)
    self.Type_Melee.Btn_Click.OnClicked:Add(self, self.OnMeleeSelect)
    self.Type_Range.Btn_Click.OnClicked:Add(self, self.OnRangedSelect)
    self.EMListView_Filter.BP_OnItemClicked:Add(self, self.OnFilterListItemClicked)

    for i = 1, 3 do
        self["Edit_AvatarItem_" .. i].Btn_Click.OnClicked:Add(self, function()
            self:OnBoxItemClick(i)
        end)

        self["Edit_AvatarItem_" .. i].Btn_Removes.Button_Area.OnClicked:Add(self, function()
            self:OnBoxItemRemoveClick(i)
        end)

    end
end
-- BoxIndex默认选择的boxid
function M:InitBaseView(TabName, BoxIndex)
    self.Btn_Cancel.Text_Button:SetText(GText("UI_PATCH_CANCEL"))
    self.Btn_Confirm.Text_Button:SetText(GText("UI_RegionMap_Save"))
    self.WBP_PersonalInfo_Edit_Tips:SetComfirmCallball(self.OnClickChangePlan, self)
    self.WBP_PersonalInfo_Edit_Tips.Root:SetRenderOpacity(0)
    self.WBP_PersonalInfo_Edit_Tips:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Btn_Confirm:ForbidBtn(true)
    self.Btn_Confirm:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    if BoxIndex then
        self.FixedBoxindex = BoxIndex
    end
    self:InitTabContent(TabName)
end
---初始化列表中武器角色的勾选状态的
function M:InitItemSelected()
    local bisWeaopn, str
    if self.CurMainTab.Name == "Char" then
        bisWeaopn = false
        str = "Char"
    else
        bisWeaopn = true
        str = "Weapon"
    end
    for i = 1, 3 do
        local Uuid = PersonInfoModel:GetDisplayItemsUuid(bisWeaopn, i)
        local plan = PersonInfoModel:GetTemporModelBoxItemData(bisWeaopn, i, self)
        if plan ~= nil and plan[str .. "Id"] ~= nil then
            Uuid = plan[str .. "Id"]
        end
        if Uuid ~= -1 then
            local str
            if bisWeaopn then
                str = plan.Tag[1]
            else
                str = self.CurMainTab.Name
            end
            local item = EditModel[str .. "ItemContentsMap"][Uuid]
            if item ~= nil then
                item.IsChosen = true
                item.ChosenBoxIdx = i
            end
        end
    end
end
-- 初始化展位样式，如果填了则选择中指定box，没选中自动选中第一个空展柜，如果满则选择第一个。
function M:InitBoxView()
    local FirstEmptyBox = nil
    local bisWeaopn
    if self.CurMainTab.Name == "Char" then
        bisWeaopn = false
    else
        bisWeaopn = true
    end

    for i = 1, 3 do
        -- 尝试加载修改后缓存的展览方案，若没有则从model加载
        local data = PersonInfoModel:GetTemporModelBoxItemData(bisWeaopn, i, self)
        self:FreshBoxView(i, data)
    end
    FirstEmptyBox = self:FindFirstEmptyBoxIndex(bisWeaopn)
    local Index = self.FixedBoxindex or FirstEmptyBox -- 如果打开界面时指定了展柜，就选中指定的展柜，否则选中第一个空展柜
    self:OnBoxItemClick(Index)
    if self.FixedBoxindex then
        self.FixedBoxindex = nil
    end
    if Index then
        self["Edit_AvatarItem_" .. Index]:OnItemClick()
    end
end
--- 
--- 找到第一个空展柜，如果满则选择第一个
---@param bIsWeapon 是否是武器展柜
function M:FindFirstEmptyBoxIndex(bIsWeapon)
    local FirstEmptyBox = nil
    for i = 1, 3 do
        -- 尝试加载修改后缓存的展览方案，若没有则从model加载
        local data = PersonInfoModel:GetTemporModelBoxItemData(bIsWeapon, i, self)
        if data == nil and FirstEmptyBox == nil then -- 选择第一个空展柜，若展柜满，选择第一个
            FirstEmptyBox = i
        end
        if bIsWeapon and data then
            data.TagImage = self[data.Tag[1] .. "2Icon"][data.Tag[2]]
        end
        -- self:FreshBoxView(i, data)
    end
    if FirstEmptyBox == nil then
        FirstEmptyBox = 1
    end
    return FirstEmptyBox
end

-- 展柜点击回调函数，取消旧展柜的选择
function M:OnBoxItemClick(index)
    if index == self.SelectBoxIdx then
        return
    end
    if self.SelectBoxIdx then
        local oldBoxItem = self["Edit_AvatarItem_" .. self.SelectBoxIdx]
        oldBoxItem:PlayAnimation(oldBoxItem.Normal)
        oldBoxItem.Btn_Click:SetVisibility(UIConst.VisibilityOp.Visible)
    end

    self.SelectBoxIdx = index
    self["Edit_AvatarItem_" .. self.SelectBoxIdx]:PlayAnimation(self["Edit_AvatarItem_" .. self.SelectBoxIdx].Click)
    self["Edit_AvatarItem_" .. self.SelectBoxIdx].Btn_Click:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)

end
-- 删除指定展柜，同时缓存数据
function M:OnBoxItemRemoveClick(index)
    local bisWeaopn
    if self.CurMainTab.Name == "Char" then
        bisWeaopn = false
    else
        bisWeaopn = true
    end
    self:OnChangeBoxData(index, nil)

    if bisWeaopn then
        if self.TempWeaponShowPlan == nil then
            self.TempWeaponShowPlan = {}
        end
        if self.TempWeaponShowPlan[index] == nil then
            self.TempWeaponShowPlan[index] = {}
        end
        self.TempWeaponShowPlan[index].WeaponId = -1

    else
        if self.TempCharShowPlan == nil then
            self.TempCharShowPlan = {}
        end
        if self.TempCharShowPlan[index] == nil then
            self.TempCharShowPlan[index] = {}
        end
        self.TempCharShowPlan[index].CharId = -1
    end
    --

    self:OnChangeData()
end
-- 进入展柜页面时锁住保存，修改后解锁
function M:OnChangeData()
    if not self.bHaveChange then
        self.Btn_Confirm:ForbidBtn(false)
        -- self.Btn_Confirm:PlayButtonNormalAnim()
        self.Btn_Confirm:PlayButtonUnForbidAnim()
        self.Btn_Confirm:SetVisibility(UIConst.VisibilityOp.Visible)
        self.bHaveChange = true
    end
end
--- 点击背景
function M:OnBGClick()
    self:TryToCloseTips()
    return UIUtils.Unhandled
end
--- 刷新指定Box的数据
---@param index 展柜索引
---@param data 展柜数据·需要有data.image, data.name, data.lv, data.Rarity, data.Uuid
function M:FreshBoxView(index, data)
    if data == nil then
        self["Edit_AvatarItem_" .. index]:SetEmpty()
    else
        self["Edit_AvatarItem_" .. index]:FreshView(data.image, data.name, data.lv, data.Rarity, data.Uuid)
    end
end
--- 更改展柜数据
---@param index number 展柜索引
---@param data table 展柜数据，需要有data.image, data.name, data.lv, data.Rarity, data.Uuid
---@param bNotCancel boolean 是否取消选择已选中的物品，默认为false
function M:OnChangeBoxData(index, data, bNotCancel)
    if self["Edit_AvatarItem_" .. index].bIsEmpty == false and self["Edit_AvatarItem_" .. index].Uuid ~= nil and
        bNotCancel ~= true then
        self:CancelSelectItem(self["Edit_AvatarItem_" .. index].Uuid)
    end
    self:FreshBoxView(index, data)
end
-- 点击确定按钮，缓存展览方案,只缓存啊修改过的地方
function M:OnClickChangePlan(ModIndex, AppearanceIdx)
    local OldBoxIndex -- 当前选中的item原本储存的box
    if self.SelectItem.IsChosen == true then
        OldBoxIndex = self.SelectItem.ChosenBoxIdx

    end

    if self.CurMainTab.Name == "Char" then
        if (self.TempCharShowPlan == nil) then
            self.TempCharShowPlan = {}
        end

        self.TempCharShowPlan[self.SelectBoxIdx] = {
            CharId = self.SelectItem.Uuid,
            AppearancePlan = AppearanceIdx,
            ModPlan = ModIndex
        }
        if OldBoxIndex and OldBoxIndex ~= self.SelectBoxIdx then
            self.TempCharShowPlan[OldBoxIndex] = {
                CharId = -1,
                AppearancePlan = -1,
                ModPlan = -1
            }
        end

    else
        if (self.TempWeaponShowPlan == nil) then
            self.TempWeaponShowPlan = {}
        end

        self.TempWeaponShowPlan[self.SelectBoxIdx] = {
            WeaponId = self.SelectItem.Uuid,
            ModPlan = ModIndex
        }
        if OldBoxIndex and OldBoxIndex ~= self.SelectBoxIdx then
            self.TempWeaponShowPlan[OldBoxIndex] = {
                WeaponId = -1,
                ModPlan = -1
            }
        end

    end

    self:OnChangeData()

    -- self.bIsTipsopened = false
    -- self.bHaveChange=true
    self:TryToCloseTips(false)
    ArmoryUtils:SetItemIsSelected(self.SelectItem, false)
    if self.SelectItem.UI then
        self.SelectItem.UI:SetItemSelect(true)
    end
    self.SelectItem.IsChosen = true
    self.SelectItem.ChosenBoxIdx = self.SelectBoxIdx
    local bisWeaopn
    if self.CurMainTab.Name ~= "Char" then
        bisWeaopn = true
    end

    -- 读取数据，刷新boxview
    local data = PersonInfoModel:GetTempEditBoxItemData(bisWeaopn, self.SelectBoxIdx, self)

    if bisWeaopn then
        data.TagImage = self[self.CurMainTab.Name .. "2Icon"][data.Tag]
    end
    local bNotCancel = false

    -- 三种逻辑 1.新增展品，之刷新新的
    -- 2.切换展品位置，刷新新的，置空旧的
    -- 3.切换展品方案，刷新新的，但不取消item选中
    if OldBoxIndex ~= nil and OldBoxIndex ~= self.SelectBoxIdx then
        self:OnChangeBoxData(OldBoxIndex, nil, true) -- case2
    end
    if OldBoxIndex ~= nil and OldBoxIndex == self.SelectBoxIdx then
        self:OnChangeBoxData(self.SelectBoxIdx, data, true) -- case3

    else
        self:OnChangeBoxData(self.SelectBoxIdx, data) -- case1,2

    end
    local NextSelectBox
    for i = 1, 3 do
        if self["Edit_AvatarItem_" .. i].bIsEmpty == true then
            if NextSelectBox == nil then
                NextSelectBox = i
            end
        end
    end
    if NextSelectBox ~= nil then
        self:OnBoxItemClick(NextSelectBox)
    end
    if self.SelectItem.UI then -- self.SelectItem 置空前恢复交互
        self.SelectItem.UI:SetVisibility(UIConst.VisibilityOp.Visible)
    end
    self.SelectItem = nil -- 保存后取消选中

end
function M:CancelSelectItem(Uuid)
    local str
    local item
    if self.CurMainTab.Name ~= "Char" then
        item = EditModel["Melee" .. "ItemContentsMap"][Uuid] or EditModel["Ranged" .. "ItemContentsMap"][Uuid]
    else
        str = "Char"
        item = EditModel[str .. "ItemContentsMap"][Uuid]
    end

    if item then
        item.IsChosen = false
        if item.UI then
            item.UI:SetVisibility(UIConst.VisibilityOp.Visible)
            item.UI:SetItemSelect(false)
            item.ChosenBoxIdx = false

        end

    end

end
-- 应用本地缓存到服务端
function M:ReallySaveModelData()
    if self.Btn_Confirm and self.Btn_Confirm.IsBtnForbidden and self.Btn_Confirm:IsBtnForbidden() then
        return
    end
    if not self.bHaveChange then
        return
    end
    self.bHaveChange = false

    PersonInfoModel:SaveShowPlan(self.TempCharShowPlan, self.TempWeaponShowPlan)
    UIManager(self):ShowUITip("CommonToastMain", GText("UI_PersonInfo_Saved"))
    PersonInfoController:CloseEditView()
end
-- 二级tab近战武器被选中
function M:OnMeleeSelect()
    local kind = "Melee"
    if (self.SelectedWeaeponTab == "Ranged") then
        self.Type_Range:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.Type_Range:SetSwitchOn(false)

    end

    self.SelectedWeaeponTab = kind
    self.Type_Melee:PlayAnimation(self.Type_Melee.Click)
    self.CurMainTab.Name = kind -- Armory_ExpandListComponent，需要武器界面的CurMainTab是近战或远程
    self:ExpandList(true)
    self.Type_Melee:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self:TryToCloseTips() -- 切换页签时关闭tips
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_level_02", nil, nil)

end
-- 二级tab远程武器被选中
function M:OnRangedSelect()
    local kind = "Ranged"
    if (self.SelectedWeaeponTab == "Melee") then
        -- self.Type_Melee:PlayAnimation(self.Type_Melee.Normal)
        self.Type_Melee:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.Type_Melee:SetSwitchOn(false)
        -- self:PlayAnimation(self.RoleList_In)
    end

    self.SelectedWeaeponTab = kind
    self.Type_Range:PlayAnimation(self.Type_Range.Click)
    self.CurMainTab.Name = kind -- Armory_ExpandListComponent，需要武器界面的CurMainTab是近战或远程
    self:ExpandList(true)
    self.Type_Range:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self:TryToCloseTips()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_level_02", nil, nil)
end
--- 一级tab被选中
---@param TabWidget any
---@param TabData any
function M:OnTabItemSelected(TabWidget, TabData)
    local InTabId = TabData.TabId
    self.CurMainTab = TabData
    if InTabId == 1 then
        self.CurMainTab.Name = "Char"
        self:FreshCharBoxView()
        if CommonUtils.GetDeviceTypeByPlatformName() == "PC" then
            self.Text_DetailTitle:SetText(GText("UI_PersonInfo_ShowCase_Char"))
        end
    else
        self.CurMainTab.Name = "Weapon"
        self:OnMeleeSelect()
        self:FreshWeaponBoxView()
        if CommonUtils.GetDeviceTypeByPlatformName() == "PC" then
            self.Text_DetailTitle:SetText(GText("UI_PersonInfo_ShowCase_Weapon"))
        end

    end
    self:InitBoxView()
    self:InitItemSelected() -- 必须要在OnMeleeSelect之后
    self:TryToCloseTips()

    if self.CurInputDeviceType == ECommonInputType.Gamepad and self.RefreshFocusItem then -- pc专用
        self:RefreshFocusItem()
    end
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_level_01", nil, nil)
end

--- func 如果tips打开则关闭
---@param bNotCancelSelect  是否取消选中 默认true
function M:TryToCloseTips(bNotCancelSelect)
    if self.bIsTipsopened then -- 切换页签时关闭tips
        self.bIsTipsopened = false
        self.WBP_PersonalInfo_Edit_Tips:PlayAnimation(self.WBP_PersonalInfo_Edit_Tips.Out)
        self:PlayAnimation(self.Tips_Out)
        self.WBP_PersonalInfo_Edit_Tips:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        if self.SelectItem and bNotCancelSelect ~= false then
            ArmoryUtils:SetItemIsSelected(self.SelectItem, false)
            if self.SelectItem.UI then
                self.SelectItem.UI:SetVisibility(UIConst.VisibilityOp.Visible)
            end
            self.SelectItem = nil
        end
        if self.CurInputDeviceType == ECommonInputType.Gamepad and self.LastSelectedListContent.UI and
            CommonUtils.GetDeviceTypeByPlatformName() == "PC" then
            self.LastSelectedListContent.UI:SetFocus()
            self:UpdataGamePadBottomAInfo(1)
            self.Common_Sort_List:SetControllerKeyHidden(false)
        end
        return true
    end

    return false

end
function M:OpenTips()
    if not self.bIsTipsopened then
        self.WBP_PersonalInfo_Edit_Tips:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.WBP_PersonalInfo_Edit_Tips:PlayAnimation(self.WBP_PersonalInfo_Edit_Tips.In)
        self:PlayAnimation(self.Tips_In)
        self.bIsTipsopened = true
    else
        self.WBP_PersonalInfo_Edit_Tips:PlayAnimation(self.WBP_PersonalInfo_Edit_Tips.In)
    end
    -- self.Common_Sort_List:SetControllerKeyHidden(false)
end

function M:FreshWeaponBoxView()
    self.Group_Tab:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Image_WeaponBG:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Text_Empty:SetText(GText("UI_Armory_Weapon_Empty"))

end
function M:FreshCharBoxView()
    self.Image_WeaponBG:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Group_Tab:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Text_Empty:SetText(GText("UI_Armory_Char_Empty"))

    self:ExpandList(true)
end

function M:OnReturnKeyDown()
    if self:TryToCloseTips() then
        return
    end
    if self.bHaveChange == true then
        local Params = {}
        Params.RightCallbackFunction = PersonInfoController.CloseEditView
        Params.RightCallbackObj = PersonInfoController

        -- 防止ecs按键不断累积产许多弹窗
        if UIManager(self):GetUIObj("CommonDialog") == nil then
            UIManager(self):ShowCommonPopupUI(100169, Params, self)
        end
    else
        PersonInfoController:CloseEditView()
    end
end

-- 展览柜初始化相关，从Armory_ExpandListComponent调用而来
function M:InitEditData()
    self.MeleeItemContentsArray = self.MeleeItemContentsCache:ToTable()
    self.RangedItemContentsArray = self.RangedItemContentsCache:ToTable()
    self.CharItemContentsArray = self.CharItemContentsCache:ToTable()
end
---排序依据选项选中时
function M:OnSortListSelectionsChanged()
    local SortByIdx, SortType = self.Common_Sort_List:GetSortInfos()
    if (self.Event_SortFuncion) then
        self.Event_SortFuncion(self.EventReceiver, self.FilteredContents, SortByIdx, SortType)
        self:FillListView()
    end
end

---升序降序改变时
function M:OnSortTypeChanged()
    local SortByIdx, SortType = self.Common_Sort_List:GetSortInfos()
    if (self.Event_SortFuncion) then
        self.Event_SortFuncion(self.EventReceiver, self.FilteredContents, SortByIdx, SortType)
        self:FillListView()
    end
end

function M:OnListItemInited(Content, EntryUI)
    Content.UI = EntryUI
    EntryUI:SetItemSelect(Content.IsChosen)
    EntryUI:SetVisibility(UIConst.VisibilityOp.Visible) -- 清除之前选中的影响
    if (self.Event_OnEntryInitialized) then
        self.Event_OnEntryInitialized(self.EventReceiver, Content, EntryUI)
    end
end
-- 切换到对应的xx_OnListItemClicked
function M:OnListItemClicked(Content)
    if (self.Event_OnListItemClicked) then
        self.Event_OnListItemClicked(self.EventReceiver, Content)
    end

end

function M:OnListItemClickedCommon(Content)
    self:OpenTips()
    self.bIsTipsopened = true
    --  end
    ArmoryUtils:SetItemIsSelected(self.SelectItem, false)
    if self.SelectItem and self.SelectItem.UI then
        self.SelectItem.UI:SetVisibility(UIConst.VisibilityOp.Visible)
    end

    self.SelectItem = Content
    Content.UI:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    ArmoryUtils:SetItemIsSelected(Content, true)
end
function M:CharMain_OnListItemClicked(Content)
    AudioManager(self):PlayUISound(self, "event:/ui/armory/click_select_role", nil, nil)

    local SelectFashionId, SelectModId
    if Content.IsChosen then
        local plan = PersonInfoModel:GetTemporModelPlan(false, Content.ChosenBoxIdx, self)
        SelectFashionId = plan.AppearancePlan
        SelectModId = plan.ModPlan

    end
    self.WBP_PersonalInfo_Edit_Tips:FreahCharView(Content.UnitName, Content.Rarity, SelectFashionId, SelectModId,
        Content.Uuid)
    self:OnListItemClickedCommon(Content)
end
function M:WeaponMain_OnListItemClicked(Content)
    AudioManager(self):PlayUISound(self, "event:/ui/armory/click_select_weapon", nil, nil)
    local SelectModId
    if Content.IsChosen then
        local plan = PersonInfoModel:GetTemporModelPlan(true, Content.ChosenBoxIdx, self)
        -- SelectFashionId=
        SelectModId = plan.ModPlan

    end
    self.WBP_PersonalInfo_Edit_Tips:FreahWeaponView(Content.UnitName, Content.Rarity,
        PersonInfoModel:GetItemUuid(Content), SelectModId)
    self:OnListItemClickedCommon(Content)
end
function M:MeleeMain_OnListItemClicked(Content)
    self:WeaponMain_OnListItemClicked(Content)
end
function M:RangedMain_OnListItemClicked(Content)
    self:WeaponMain_OnListItemClicked(Content)
end
---列表内聚焦改变时
function M:OnListItemSelectionChanged(Content, IsSelected)
    self:UpdataGamePadBottomAInfo(1)
    if (IsSelected) then
        self.LastSelectedListContent = Content
    end
    if (self.Event_OnListItemSelectionChanged) then
        self.Event_OnListItemSelectionChanged(self.EventReceiver, Content, IsSelected)
    end
end

function M:OnItemIsHoverChanged(Content)
    if (self.Event_OnItemIsHoverChanged) then
        self.Event_OnItemIsHoverChanged(self.EventReceiver, Content)
    end
end
---筛选列表被点击
function M:OnFilterListItemClicked(Content)
    self.LastSelectedFilterContent = Content
    if (self.FilterMod == "Single") then
        if (Content.IsSelected) then
            return
        end
        for Tag, Value in pairs(self.SelectedFilterContents) do
            if (Value ~= Content) then
                self:SetFilterContentIsSelected(Value, false)
                self.SelectedFilterContents[Tag] = nil
            end
        end
        if (self.FilterContentObj_All ~= Content) then
            self:SetFilterContentIsSelected(self.FilterContentObj_All, false)
        end
        self:SetFilterContentIsSelected(Content, true)
    end
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_sort_tab", nil, nil)
    self:UpdateFilterInfos()
    local FilterIdxes = self.FilterIdxes
    if (self.Event_FilterFunction) then
        self.FilteredContents = self.Event_FilterFunction(self.EventReceiver, self.AllItemContents, FilterIdxes) or {}
        if (self.Event_SortFuncion) then
            local SortByIdx, SortType = self.Common_Sort_List:GetSortInfos()
            self.Event_SortFuncion(self.EventReceiver, self.FilteredContents, SortByIdx, SortType)
        end
        if self:FillListView() == false then
            self:OnFilterListItemClicked(Content)
        end
    end
end
-- 有时会obj会失效，重新加载一边
---To Do待优化，目前obj明明被蓝图引用，不知为什么还是可能被Gc
function M:FreshAgain()
    local FilterIdxes = self.FilterIdxes
    if (self.Event_FilterFunction) then

        -- 重新组织数据
        self.AllItemContents = self[self.CurMainTab.Name .. "ItemContentsArray"]
        self.FilteredContents = {}
        if (self.AllItemContents) then
            for index, value in ipairs(self.AllItemContents) do
                table.insert(self.FilteredContents, value)
            end
        end
        if #FilterIdxes ~= 0 then
            self.FilteredContents = self.Event_FilterFunction(self.EventReceiver, self.AllItemContents, FilterIdxes) or
                                        {}
            if (self.Event_FilterFunction) then
                self.FilteredContents =
                    self.Event_FilterFunction(self.EventReceiver, self.AllItemContents, FilterIdxes) or {}
            end
        end
        -- 应该只有切换tab时数据可能是失效，所以只需要默认排序
        if (self.Event_SortFuncion) then
            self.Event_SortFuncion(self.EventReceiver, self.FilteredContents, 1, 2)
        end

        self:FillListView(false) -- 标记为false不需要再刷新，防止出现死循环
    end

end

function M:SetFilterContentIsSelected(Content, IsSelected)
    Content.IsSelected = IsSelected
    if (Content.UI) then
        Content.UI:SetIsSelected(Content.IsSelected)
    end
    if (Content.Tag) then
        self.SelectedFilterContents[Content.Tag] = Content
    end
end
---角色武器列表初始化
function M:InitEditListView(Parent, Params)
    self.Parent = Parent
    self.Params = Params
    self.Filters = Params.Filters or {}
    self.FilterMod = Params.FilterMod or "Single"
    self.FilterIdxes = {}
    self.OrderByDisplayNames = Params.OrderByDisplayNames
    self.SortType = Params.SortType
    self.AllItemContents = Params.ItemContents
    self.EMListView_Filter:ClearListItems()
    self.SelectedFilterContents = {}
    self.FilteredContents = {}
    if (self.AllItemContents) then
        for index, value in ipairs(self.AllItemContents) do
            table.insert(self.FilteredContents, value)
        end
    end
    self.LastSelectedFilterContent = nil
    self.FilterContentObj_All = nil
    if (#self.Filters > 0) then
        self.FilterContentObj_All = NewObject(UIUtils.GetCommonItemContentClass())
        self.FilterContentObj_All.IsSelecte = true
        self.FilterContentObj_All.Index = 0
        self.FilterContentObj_All.Icon = '/Game/UI/Texture/Static/Atlas/Armory/T_Armory_Select.T_Armory_Select'
        self.FilterContentObj_All.IsSelected = true
        self.LastSelectedFilterContent = self.FilterContentObj_All
        self.EMListView_Filter:AddItem(self.FilterContentObj_All)
        self.Panel_FilterTab:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        -- self:SetTitle(GText("UI_ALL"))
    else
        -- self:SetTitle(nil)
        self.Panel_FilterTab:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end

    for Index, Tag in ipairs(self.Filters) do
        local Obj = NewObject(UIUtils.GetCommonItemContentClass())
        for key, value in pairs(Tag) do
            Obj[key] = value
        end
        Obj.Index = Index

        self.EMListView_Filter:AddItem(Obj)
    end

    self.Common_Sort_List:Init(self.Root, self.OrderByDisplayNames, self.SortType or CommonConst.DESC, {
        OnGetBackFocusWidget = function(_self, MyGeometry, InKeyEvent)
            return self:OnSortListWidgetBack(MyGeometry, InKeyEvent)
        end,
        OnAddedToFocusPath = function()
            self:OnSortListAddedToFocusPath()
        end,
        OnRemovedFromFocusPath = function()
            self:OnSortListRemovedFromFocusPath()
        end
    })

    -- self.Common_Sort_List:Init(self.Parent, self.OrderByDisplayNames, self.SortType or CommonConst.DESC)
    self.Common_Sort_List:BindEventOnSelectionsChanged(self, self.OnSortListSelectionsChanged)
    self.Common_Sort_List:BindEventOnSortTypeChanged(self, self.OnSortTypeChanged)
    self.WS_List:SetActiveWidgetIndex(0)
    -- self.Com_EmptyBg:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Event_SortFuncion(self.EventReceiver, self.FilteredContents, 1, 2)
    self:FillListView()
    self:InitNavigationRules()
end
----展览柜初始化相关，从Armory_ExpandListComponent调用而来
function M:BindEvents(EventReceiver, Events)
    self.EventReceiver = EventReceiver
    self.Event_OnListItemClicked = Events.OnListItemClicked
    self.Event_OnListItemSelectionChanged = Events.OnListItemSelectionChanged
    self.Event_SortFuncion = Events.SortFuncion
    self.Event_FilterFunction = Events.FilterFunction
    self.Event_OnListItemInited = Events.OnListItemInited
    self.Event_OnEntryInitialized = Events.OnEntryInitialized
    self.Event_OnItemIsHoverChanged = Events.OnItemIsHoverChanged
end
function M:FillListView(bfresh) -- item失效后再次填充
    self:PlayAnimation(self.List_Change)
    self.TileView_Select_Role:ClearListItems()
    self.LastSelectedListContent = nil

    if (not self.LastSelectedListContent) then
        self.LastSelectedListContent = self.FilteredContents[1]
    end
    for index, value in ipairs(self.FilteredContents) do

        if IsValid(value) then
            self.TileView_Select_Role:AddItem(value)
        else
            if bfresh == false then
                return
            end
            self.TileView_Select_Role:ClearListItems()
            EditModel:InitEditData(self)
            self:InitEditData()
            DebugPrint("Item失效，尝试重新创建", index)
            UKismetSystemLibrary.PrintString(nil, index .. "Item失效，尝试重新创建", true, false,
                FLinearColor(1, 0, 0, 1), 2)
            self:FreshAgain()
            return
        end
    end
    if (#self.FilteredContents <= 0) then
        self.WS_List:SetActiveWidgetIndex(1)
        self.Common_Sort_List:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.TileView_Select_Role:SetVisibility(UIConst.VisibilityOp.Collapsed)
    else
        self.WS_List:SetActiveWidgetIndex(0)
        -- self.Com_EmptyBg:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Common_Sort_List:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.TileView_Select_Role:SetVisibility(UIConst.VisibilityOp.Visible)
        self:AddTimer(0.001, function()
            if GWorld.GameInstance:GetGameUIManager():GetWidgetRenderSize(self.TileView_Select_Role).X == 0 then
                return -- 如果玩家打开页面后秒按esc退出，接下来的执行会报错。
            end
            local ItemUIs = self.TileView_Select_Role:GetDisplayedEntryWidgets()
            local XCount, YCount = UIUtils.GetTileViewContentMaxCount(self.TileView_Select_Role, "XY")
            local ItemLen = ItemUIs:Length()
            local RestCount = XCount * YCount - ItemLen
            if (RestCount <= 0) then
                RestCount = XCount - #self.FilteredContents % XCount
            end
            self:FillEmptyItems(RestCount)
            -- 注掉这句话是因为ListView生成Item期间再重新生成一次而且Icon异步加载失败的话会导致Icon错乱
            -- self.TileView_Select_Role:RegenerateAllEntries()
            self.TileView_Select_Role:ScrollToTop()
            if self.Event_OnListItemInited then
                self.Event_OnListItemInited(self.EventReceiver)
            end
        end, false, 0, "DelayAddEmptyItem", true)
    end
end
function M:UpdateFilterInfos()
    local Indexes = {}
    local bHasItem = (next(self.SelectedFilterContents) ~= nil)
    local Items = self.EMListView_Filter:GetListItems()
    local Len = Items:Length()
    if (bHasItem) then
        for i = 2, Len do
            if (self.SelectedFilterContents[Items[i].Tag]) then
                table.insert(Indexes, Items[i].Index)
            end
        end
    else
        for i = 2, Len do
            table.insert(Indexes, Items[i].Index)
        end
    end
    self.FilterIdxes = Indexes
    return self.FilterIdxes
end
function M:FillEmptyItems(Count)
    for i = 1, Count do
        self.TileView_Select_Role:AddItem(NewObject(UIUtils.GetCommonItemContentClass()))
    end
end
function M:CallFunctionByName(FunctionName, ...)
    if (self[FunctionName]) then
        return self[FunctionName](self, ...)
    end
end
function M:Destruct()
    self.MeleeItemContentsCache:Clear()
    self.RangedItemContentsCache:Clear()
    self.CharItemContentsCache:Clear()
end
---手柄相关-----
function M:InitNavigationRules()
    -- 设置角色列表导航规则
    self.TileView_Select_Role:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
    self.TileView_Select_Role:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
    self.TileView_Select_Role:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
    self.TileView_Select_Role:SetNavigationRuleCustom(EUINavigation.Left, {self, self.OnRoleListNavigation})

    -- 设置筛选列表导航规则
    self.EMListView_Filter:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
    self.EMListView_Filter:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
    self.EMListView_Filter:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
    self.EMListView_Filter:SetNavigationRuleCustom(EUINavigation.Left, {self, self.OnFilterListNavigation})

    -- 启用水平循环导航
    self.TileView_Select_Role.bWrapHorizontalNavigation = not self.Panel_FilterTab:IsVisible()
end

function M:OnRoleListNavigation(NavigationDirection)
    if (NavigationDirection == EUINavigation.Left) then
        self.EMListView_Filter:BP_SetSelectedItem(self.LastSelectedFilterContent)
        self.EMListView_Filter:BP_NavigateToItem(self.LastSelectedFilterContent)
        return self.EMListView_Filter
    end
    return self.TileView_Select_Role
end

function M:OnFilterListNavigation(NavigationDirection)
    if (NavigationDirection == EUINavigation.Right) then
        self.TileView_Select_Role:BP_SetSelectedItem(self.LastSelectedListContent)
        self.TileView_Select_Role:BP_NavigateToItem(self.LastSelectedListContent)
        return self.TileView_Select_Role
    end
    return self.EMListView_Filter
end

function M:OnSortListRemovedFromFocusPath()
end
function M:OnSortListAddedToFocusPath()
    if (UIUtils.HasAnyFocus(self.EMListView_Filter)) then
        self.LastFocusList = self.EMListView_Filter
    else
        self.LastFocusList = self.TileView_Select_Role
    end
end
function M:SetFocusToList()
    self.TileView_Select_Role:SetFocus()
    if (self.LastSelectedListContent) then
        self.TileView_Select_Role:BP_SetSelectedItem(self.LastSelectedListContent)
        self.TileView_Select_Role:BP_NavigateToItem(self.LastSelectedListContent)
    else
        error("LastSelectedListContent is nil")
    end
    if not self.TileView_Select_Role:HasFocusedDescendants() then
        local items = self.TileView_Select_Role:GetListItems()
        if items[1] then
            -- 获取第一个 Item
            local firstItem = items[1]
            local ReturnWidget = firstItem.SelfWidget or firstItem.ParentWidget or firstItem.UI
            ReturnWidget:SetFocus()
            -- error("LastSelectedListContent is nil")
        end
    end
end
AssembleComponents(M)
return M
