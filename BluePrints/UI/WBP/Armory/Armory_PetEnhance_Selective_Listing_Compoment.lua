--
-- DESCRIPTION
-- 此脚本负责处理词条进阶界面背包的相关逻辑
-- @COMPANY **
-- @AUTHOR 叶轲
-- @DATE 2025.3.18
--
require "UnLua"
local ArmoryUtils = require "BluePrints.UI.WBP.Armory.ArmoryUtils"
---@type WBP_Armory_Selective_Listing_C
local Component = Class(
   -- {"BluePrints.Common.TimerMgr"}
)

function Component:Construct()
    self.EntryPets = {
        -- [entryid]={petsobj,petsobj2}
    } -- 指定词条的全部对应宠物
    self.ToCancelQueue ={}--取消队列，背包被关闭时取消选中会加入，在expanlist时真正取消
    self.IsListExpanded = false

    if (not IsValid(self.ItemDetailsWidget)) then
        self.ItemDetailsWidget = self:CreateWidgetNew("ItemDetailsMain")
        self.Selective_Listing:AttachTipsWidget(self.ItemDetailsWidget)
        self.ItemDetailsWidget.Btn_Locked:UnBindEventOnClickedByObj(self)
        self.ItemDetailsWidget:InitLockedEvent({
            LockedButtonClickCallBack = function()
                self:OnDetailLockBtnClickComp()
            end
        })
    end
    self.ItemDetailsWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Image_ClickNotPass.OnMouseButtonDownEvent:Bind(self, self.OnBackgroundClicked)
    -- 新增事件监听
    self:AddDispatcher(EventID.OnPetLocked, self, self.OnPetLocked)
    self.Selective_Listing.TileView_Select_Role.BP_OnEntryInitialized:Clear()
    self.Selective_Listing.TileView_Select_Role.BP_OnEntryInitialized:Add(self, self.OnListItemInited)

    self.Selective_Listing.bIsShowNavigateGuide=false--素材为空时不显示导航图标
    self:SetFocus()
end

--[[
收集并返回宠物匹配的有效词条ID列表
@param Pet 宠物对象
@param Entrys 目标词条ID集合
@return table 匹配的有效词条ID列表]]
function Component:CollectValidEntries(Pet, Entrys)
    if not Pet or not Pet.Entry then
        return {}
    end

    local validEntries = {}
    -- 使用哈希表快速查找
    local targetSet = {}
    for _, id in ipairs(Entrys) do
        targetSet[id] = true
    end

    -- 单次遍历同时完成匹配和收集
    for _, entryId in ipairs(Pet.Entry) do
        if targetSet[entryId] then
            if Pet ~= self.Pet then
                table.insert(validEntries, entryId)
            end
        end
    end
    return validEntries
end

--- 收集所有可以被当素材的宠物，存到对应词条的表self.EntryPets里
---@param Entrys 当前宠物拥有的词条
function Component:CreatePetItemContents(Entrys)
    if Entrys == nil then
        return
    end
    self.UseablePetItemContentsMap = {}
    self.UseablePetItemContentsArray = {}
    self.ResourcePetItemContentsMap = {}
    self.ResourcePetItemContentsArray = {}
    self.BP_PetItemContents:Clear()

    local RealAvatar = GWorld:GetAvatar()

    if (RealAvatar) then
        for _, petObj in pairs(RealAvatar.Pets) do
            -- 使用新的CollectValidEntries方法
            
            if RealAvatar.CurrentPet==petObj.UniqueId then
                goto continue
            end
            local validEntries = self:CollectValidEntries(petObj, Entrys)
            if #validEntries > 0 then
                -- 创建唯一数据对象（补充缺失的属性设置）
                local obj = ArmoryUtils:NewPetItemContentWithEntry(petObj)
                obj.bAllUseAsyncLoadWidget = false
                obj.IsChosen = false
                -- 统一使用 LockType，移除 IsLocked 赋值
                -- if obj.LockType and obj.LockType ~= 0 then
                --     obj.IsLocked = true
                -- end
                -- 加入总列表
                self.BP_PetItemContents:Add(obj)
                -- 遍历有效词条进行分类
                for _, entryId in ipairs(validEntries) do
                    if not self.EntryPets[entryId] then
                        self.EntryPets[entryId] = {}
                    end
                    table.insert(self.EntryPets[entryId], obj)
                end

                -- 资源/可用分类逻辑（保持原位置）
                if (obj.IsResourcePet) then
                    self.ResourcePetItemContentsMap[obj.UniqueId] = obj
                    table.insert(self.ResourcePetItemContentsArray, obj)
                else
                    self.UseablePetItemContentsMap[obj.UniqueId] = obj
                    table.insert(self.UseablePetItemContentsArray, obj)
                end

            end
            ::continue::
        end
    end

end
--- 更新指定词条的宠物列表（词条进阶后调用，增量收集）
---@param NewEntrys table @新的目标词条ID集合
function Component:UpdateEntryPets(NewEntrys)
    if not NewEntrys then
        return
    end

    local RealAvatar = GWorld:GetAvatar()
    if RealAvatar then
        for _, petObj in pairs(RealAvatar.Pets) do
            local validEntries = self:CollectValidEntries(petObj, NewEntrys)
            for _, entryId in ipairs(validEntries) do
                if not self.EntryPets[entryId] then
                    self.EntryPets[entryId] = {}
                end
                local obj = ArmoryUtils:NewPetItemContentWithEntry(petObj)
                obj.bAllUseAsyncLoadWidget = false
                obj.IsChosen = false
                -- 不再写入 IsLocked；统一以 LockType 判断
                self.BP_PetItemContents:Add(obj)
                table.insert(self.EntryPets[entryId], obj)
                if (obj.IsResourcePet) then
                    self.ResourcePetItemContentsMap[obj.UniqueId] = obj
                    table.insert(self.ResourcePetItemContentsArray, obj)
                else
                    self.UseablePetItemContentsMap[obj.UniqueId] = obj
                    table.insert(self.UseablePetItemContentsArray, obj)
                end
            end
        end
    end
end
-- 判断宠物是否有指定词条
function Component:IsPetHaveAnyUsefulEntry(Pet, Entrys)
    if not Pet or not Pet.Entry then
        return false
    end

    -- 遍历所有目标词条，任一匹配即返回true
    for _, EntryId in ipairs(Entrys) do
        if self:IfPetHaveEntry(Pet, EntryId) then
            return true
        end
    end
    return false
end
-- 获取拥有指定词条的宠物（优化后版本）
function Component:GetFilteredPet(EntryId)
    return self.EntryPets[EntryId] or {} -- 直接返回预分类数据
end
--- 判断宠物是否拥有指定词条
---@param Pet any 宠物对象
---@param EntryId any 词条ID
function Component:IfPetHaveEntry(Pet, EntryId)
    if Pet.Entry ~= nil then
        for _, entry in ipairs(Pet.Entry) do
            if entry == EntryId then
                return true
            end
        end
    else
        return false
    end

end

-- 移植expandlist的内容

-- end


function Component:InitUIInfo()
    -- 排序依据
    if (self.bFromArchive) then
        self.Arr_OrderBy = {"UI_RARITY_NAME"}
        self.CommonOrderByAttrNames = {"Rarity", "SortPriority", "UnitId"}
    else
        self.Arr_OrderBy = {"UI_LEVEL_SELECT", "UI_RARITY_NAME"}
        self.CommonOrderByAttrNames = {"Level", "Rarity", "SortPriority", "UnitId"}
    end

    self.PetOrderByDisplayNames = self.Arr_OrderBy

    self.PetOrderByAttrNames = self.CommonOrderByAttrNames
end

function Component:OnBackKeyDown()
    if (not self.IsListExpanded) then
        return
    end
    self:ExpandList(false)
end

function Component:SetChangeCamera(IsListExpanded)
    self.ActorController = UIManager(self):GetArmoryUIObj().ActorController
    local Avatar = GWorld:GetAvatar()
    local CameraTag1
    if(Avatar.Sex == 1)then
        CameraTag1 = "Nvzhu"
    else
        CameraTag1 = "Nanzhu"
    end
    if IsListExpanded then
        self.ActorController:SetArmoryCameraTag(CameraTag1,nil ,nil,"Pet")
    else
        self.ActorController:SetArmoryCameraTag(CameraTag1, "Entry", "LevelUp",CommonConst.ArmoryType.Pet)
    end
end
---开关列表
function Component:ExpandList(IsListExpanded)
    self.Selective_Listing:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    if (IsListExpanded) then
        --清除缓存的选择状态
        if next(self.ToCancelQueue) then
            for _,v in pairs(self.ToCancelQueue) do
                 v.IsChosen =false
                 if v.UI then
                    v.UI:SetItemSelect(false)
                    --v.UI:SetIsChosen(false)
                 end
        end 
        self.ToCancelQueue={}
    end
        self.IsListExpanded = true
        self.ExcelWeaponTags = nil
        if self.BP_PetItemContents:Num() == 0 then
            self:CreatePetItemContents(self.Pet.Entry)
        end
        self.Selective_Listing:BindEvents(self, {
            OnListItemClicked = self.PetMain_OnListItemClicked,
            SortFuncion = self.SortItemContents,
            FilterFunction = self.FilterItemContents
        })

        self.Selective_Listing:Init(self, {
            Filters = self.Filters,
            OrderByDisplayNames = self["PetOrderByDisplayNames"],
            SortType = CommonConst.DESC,
            ItemContents = self:GetFilteredPet(self.CurEntryContent.EntryId)
        })

        self.Selective_Listing:SetEmptyStateText(GText("AvailablePet_Empty"))
        self.Selective_Listing:PlayInAnim()
        --槽位移动
        if self.Change then
            self:PlayAnimation(self.Change)
        end
        self:SetChangeCamera(IsListExpanded)
    else
        if self.IsListExpanded==false then
            return
        end
        if self.bItemDetailsShowed then
            self:ShowItemDetails(false,nil,false)
        end
        self.Selective_Listing:PlayOutAnim()
        self.IsListExpanded = false
        if self.CurInputDeviceType == ECommonInputType.Gamepad then--电脑端专用
            self:SetOriginFocus()
        end
        --槽位移动
        if self.Change then
            self:PlayAnimationReverse(self.Change)
        end
        self:SetChangeCamera(IsListExpanded)
    end
    self:OnListExpand(IsListExpanded)
end

---显隐详情
-- @param bShow boolean 是否显示详情
-- @param Content table 宠物数据
-- @param bNotSelect boolean 是否不进行选择操作
function Component:ShowItemDetails(bShow, Content, bNotSelect)
    self.bItemDetailsShowed = bShow
    if (bShow) then
        self.ItemDetailsWidget:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        if (self.ItemDetailsContent ~= Content) then
            self.ItemDetailsWidget:RefreshItemInfo(Content, true)
            if (Content.LockType ~= 0) then
                self.ItemDetailsWidget.Switcher_Lock:SetActiveWidgetIndex(0)
            else
                self.ItemDetailsWidget.Switcher_Lock:SetActiveWidgetIndex(1)
            end
        end
        self.ItemDetailsWidget:PlayAnimation(self.ItemDetailsWidget.In)
        if not bNotSelect then
            if self.SelectItem and self.SelectItem~=Content then
                self.SelectItem.IsSelected = false
                if self.SelectItem.UI then
                    self.SelectItem.UI:SetSelected(false)
                end
            end
            Content.IsSelected = true
            self.SelectItem=Content
            if (Content.UI) then
                Content.UI:SetSelected(true)
            end
        end
    elseif self.ItemDetailsWidget then
        self.ItemDetailsWidget:PlayAnimation(self.ItemDetailsWidget.Out)
        -- self.ItemDetailsWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
        if (not bNotSelect and self.ItemDetailsContent) then
            self.ItemDetailsContent.IsSelected = false
            if (self.ItemDetailsContent.UI) then
                self.ItemDetailsContent.UI:SetSelected(false)
            end
        end
    end
    self.ItemDetailsContent = Content
    if (self.CurInputDeviceType == ECommonInputType.Gamepad) then
        self.ItemDetailsWidget.Panel_Controller:SetVisibility(ESlateVisibility.Collapsed)
    end
end
function Component:OnListItemInited(Content, EntryUI)
    Content.UI = EntryUI
    if Content.IsChosen==nil then
        return
    end
            if Content.IsChosen==nil then
            return
        end
        --Content.UI:SetIsChosen(Content.IsChosen)
        Content.UI:SetSelected(Content.IsChosen)


end

--- 宠物列表点击回调
---@param Content 宠物数据
function Component:PetMain_OnListItemClicked(Content)
    print("yklua,PetItemClick")
    if (not self.IsListExpanded) then
        return
    end
    if not Content.Uuid then
        return
    end
    -- 更新选中状态
    if Content.IsChosen then
        self:DeleteContent(Content)
        local DelIdx = self:FindSelectedContentIndex(Content)
        if DelIdx then
            self:DeleteConsumeContent(DelIdx)
        end
        return
    end
    -- 判断是否满宠
    if self:IsPetFull() then
        return
    end
    -- 处理锁定状态（统一用 LockType）
    if Content.LockType and Content.LockType ~= 0 then
        self:ShowItemDetails(true, Content, false)
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_Pet_Locked"))
        return
    end
    if Content.IsPremium or Content.Rarity >= 5 or Content.BreakNum>0 or #Content.PetEntry>1 then
        local CancelFunc = function()
            self:SetFocus()
        end
        local ConfirmFunc = function()
            -- self:BlockAllUIInput(true)
            ArmoryUtils:SetItemReddotRead(Content,true)
            self:SetContentChosen(Content)
        end
        UIManager():ShowCommonPopupUI(100174, {
            LeftCallbackFunction = CancelFunc,
            RightCallbackFunction = ConfirmFunc,
            CloseBtnCallbackFunction = CancelFunc
        }, self)
        return
    end
    if not Content.Uuid then return end
    ArmoryUtils:SetItemReddotRead(Content,true)
    -- 保持原有增强模式逻辑
    if Content then
        self:SetContentChosen(Content)
    end

end
--- func 设置宠物选中，同步到右测词条进阶面板 
---@param content 宠物item
function Component:SetContentChosen(Content, bForceChose)
    if self:TryAddConsumeContent(self:CopyItem(Content), bForceChose) == false then
        return
    end
    if Content.IsChosen then
        return
    end
    self:ShowItemDetails(true, Content)
    Content.IsChosen = true
    if Content.UI then
        Content.UI:SetItemSelect(true)

    end
    self.CurrentSelected = Content

end
--- 为了同步到词条界面，需要复制一个conteng
---@param Content any
function Component:CopyItem(Content)
    local Target = ArmoryUtils:GetPet(Content.Uuid)
    local Copyitem = ArmoryUtils:NewPetItemContentWithEntry(Target)
    Copyitem.Father = Content
    -- 继承 LockType（不再写 IsLocked）
    Copyitem.LockType = Content.LockType
    assert(Copyitem)
    return Copyitem
end
-- 在Construct方法中初始化容器 ↓↓↓
function Component:DeleteContent(content)
    -- self:DeleteConsumeContent() -- 同步到右侧为词条进阶面板
    content.IsChosen = false
    if content.UI then
        content.UI:SetItemSelect(false)
        content.UI:SetSelected(false)
    end
end
--- func desc  为了将取消选中同步到右侧为词条进阶面板，需要根据uuid找到index
function Component:FindSelectedContentIndex(Content)

    for i = 1, self.ConsumeCount do
        if self.ConsumeContents[i].Uuid == Content.Uuid then
            return i
        end
    end
end
--- 取消列表里宠物的选中，不要直接调用，应该从DeleteConsumeContent调过来.
---如果取消时列表被关闭，缓存下来，在列表打开时取消
---@param Content 宠物
function Component:CancelChosenContent(Content)
    if self.IsListExpanded == false then
        table.insert(self.ToCancelQueue, Content)
        return
    end
    if Content.UI then
        Content.UI:SetSelected(false)
        Content.UI:SetItemSelect(false)
    end
    Content.IsChosen = false
    -- self:DeleteConsumeContent() -- 同步到右侧为词条进阶面板
end
--- 对传入的内容数组进行排序
---@param InOutContentArray table 要排序的内容数组
---@param SortByIdx number 排序依据的索引
---@param SortType number 排序类型（升序或降序）
function Component:SortItemContents(InOutContentArray, SortByIdx, SortType)
    local FirtContent = self["Pet" .. "Main_CurContent"] or self["Pet" .. "Main_CmpContent"]
    local OrderByAttrNames = self["Pet" .. "OrderByAttrNames"]
    local SortByAttrNames = {OrderByAttrNames[SortByIdx]}
    for index, value in ipairs(OrderByAttrNames) do
        if (index ~= SortByIdx) then
            table.insert(SortByAttrNames, value)
        end
    end
    ArmoryUtils:SortItemContents(InOutContentArray, SortByAttrNames, SortType, FirtContent)
end

function Component:OnBackgroundClicked()
    if (self.IsListExpanded) then
        self:ExpandList(false)
    end
    return  UIUtils.Handled
end

-- 新增锁定核心逻辑 --------------------------------------------------
function Component:LockOrUnlockPet()
    if not self.ItemDetailsContent then
        return
    end

    local Avatar = GWorld:GetAvatar()
    -- 统一用 LockType
    if self.ItemDetailsContent.LockType and self.ItemDetailsContent.LockType ~= 0 then
        local CancelFunc = function()
            self:SetFocus()
        end
        local ConfirmFunc = function()
            SecondaryPasswordController:Pet_OpenSeconderyPassword(self.ItemDetailsContent.UniqueId, self)
        end

        UIManager(self):ShowCommonPopupUI(100019,{
            LeftCallbackFunction = CancelFunc,
            RightCallbackFunction = ConfirmFunc, 
            CloseBtnCallbackFunction = CancelFunc,
        },self)
    else
        Avatar:LockPet(self.ItemDetailsContent.UniqueId)
    end
end

function Component:OnPetLocked(ErrCode, UniqueId, IsLocked)

        local CurrentContent = self.ItemDetailsContent
        if not CurrentContent then
            return
        end
        if (not ErrorCode:Check(ErrCode)) then
            return
        end
        -- 按服务器结果设置 LockType（不再本地反转 IsLocked）
        CurrentContent.LockType = IsLocked and 1 or 0
        if(CurrentContent.UI)then
            CurrentContent.UI:SetLock(CurrentContent.LockType or 0)
        end
        if(self.ItemDetailsWidget)then
            if (CurrentContent.LockType ~= 0) then
                self.ItemDetailsWidget.Switcher_Lock:SetActiveWidgetIndex(0)
            else
                self.ItemDetailsWidget.Switcher_Lock:SetActiveWidgetIndex(1)
            end
        end
        if(CurrentContent.IsChosen and (CurrentContent.LockType ~= 0))then
            local DelIdx = self:FindSelectedContentIndex(CurrentContent)
            if DelIdx then
                self:DeleteConsumeContent(DelIdx)
            end
        end
    
end

--- 升级后移除宠物数据并刷新列表
---@param Content 宠物数据
function Component:RemoveConsumePet(Content)
    -- self.EntryPets[self.CurEntryContent.EntryId]
    -- 检查是否存在该词条的宠物列表
    for _, pets in pairs(self.EntryPets) do
        for i = #pets, 1, -1 do
            if pets[i] == Content then
                table.remove(pets, i)
            end
        end
    end

    self:ExpandList(false)

end
-- 完善现有回调方法
function Component:OnDetailLockBtnClickComp()
    self:LockOrUnlockPet()
    self:SetFocus() -- 保持焦点
end
return Component

