--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR 叶轲
-- @DATE ${date} ${time}
-- UI_Armory_Toast_Material
require "UnLua"
local ArmoryUtils = require "BluePrints.UI.WBP.Armory.ArmoryUtils"
local SkillUtils = require "Utils.SkillUtils"
local M = Class({})

M._components = {"BluePrints.UI.WBP.Armory.Armory_PetEnhance_Selective_Listing_Compoment"}
function M:Initialize()
    self.EntryContents = nil -- 当前宠物的所有词条
    self.CurEntryContent = nil -- 当前选择的词条0
    self.EntryItemWidgets = nil -- 排好序的EntryItemWidgets，内有ContentIdx
    self.SelectedItemIdx = nil -- 选中的素材宠物格子索引
    self.ConsumeCount = nil -- 需要消耗的材料数量
    self.ConsumeContents = {{}, {}, {}} -- 准备被消耗的宠物内容，数量不会超过ConsumeCount
end

function M:Construct()
    for i = 1, 4 do
        self["EntryItem_" .. i].Button_Area.OnClicked:Add(self, function()
            AudioManager(self):PlayUISound(self, "event:/ui/common/pet_potential_click", nil, nil)
            self:OnEntryClicked(i)
        end)
        self["EntryItem_" .. i].WidgetIndex = i
    end
    self.Btn_Enhance.Text_Button:SetText(GText("Pet_Affix_Break"))
    self.Text_Same:SetText(GText("Pet_Break_CostToast"))
    self.Selective_Listing:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Btn_Enhance.Button_Area.OnClicked:Add(self, self.OnEnhanceClicked)
    self.Btn_Enhance:SetDefaultGamePadImg("X")
    self.Selective_Listing.bIsShowNavigateGuide = false
    self.SuccessToast.Text_Success:SetText(GText("Pet_Affix_Break_Success"))
    self.Hint_Pet.Text_Hint_Positive:SetText(GText("Pet_LevelUp_LevelMax"))
end

---@param Pet 用于升级的宠物
---@param CurEntryContent 当前选中的词条，如果不填默认选中第一个
function M:OnLoaded(Pet, CurEntryContent)
    self.Pet = Pet
    self.CurEntryContentIdx = CurEntryContent and CurEntryContent.Index
    if not self.CurEntryContentIdx then
        self.CurEntryContentIdx = self:FindFirstNoMaxEntryIdx()
    end

    self:InitTabInfo()
    self:RefreshBaseInfo()
    self.ActorController = UIManager(self):GetArmoryUIObj().ActorController
    local Avatar = GWorld:GetAvatar()
    local CameraTag1
    if (Avatar.Sex == 1) then
        CameraTag1 = "Nvzhu"
    else
        CameraTag1 = "Nanzhu"
    end
    self.ActorController:SetArmoryCameraTag(CameraTag1, "Entry", "LevelUp", CommonConst.ArmoryType.Pet)
end

function M:FindFirstNoMaxEntryIdx()
    for i,v in ipairs(self.Pet.Entry) do
        if v ~= 0 then
            local EntryData = DataMgr.PetEntry[v]
            if EntryData and EntryData.PetEntryUPID then
                return i
            end
        end
    end
    return 1
end
function M:RefreshBaseInfo()
    -- 刷新一些基础数据
    self:UpdateEntryInfos(self.Pet)
    self.ConsumeCount = 3
    self:ChanegeSelectEntry(self.EntryItemWidgets[self.CurEntryContentIdx].WidgetIndex)
end
--function M:Init
-- 根据宠物初始化词条相关信息
function M:UpdateEntryInfos(Pet, beNotChangeView)
    if (not Pet or not Pet.Entry) then
        error("没有传入宠物")
        return
    end
    local Data
    local EntryId
    local BreakData = DataMgr.PetBreak[Pet.PetId]
    local MaxEntry = 0
    if (BreakData) then
        MaxEntry = BreakData[#BreakData].EntryNum or 0
    end
    local UnlockedEntryNum = BreakData[Pet.BreakNum].EntryNum or 0

    if (Pet:IsResourcePet()) then
        MaxEntry = 1
        for i = 1, 4 do
            self["EntryItem_" .. i]:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
        self.EntryItemWidgets = {self.EntryItem_3}
        self.EntryItem_3:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
        for i = 1, 4 do
            self["EntryItem_" .. i]:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        end
        if (Pet:IsPremium()) then
            self.EntryItemWidgets = {self.EntryItem_1, self.EntryItem_3, self.EntryItem_4, self.EntryItem_2}
        else
            self.EntryItemWidgets = {self.EntryItem_1, self.EntryItem_3, self.EntryItem_2}
            self.EntryItem_4:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
    end
    self.EntryContents = {}

    -- 设置ui和content的对应关系
    for i, Widget in ipairs(self.EntryItemWidgets) do
        Widget.ContentIdx = i -- widget到content的映射
    end

    local HasAnyEntry = false
    for i, Widget in ipairs(self.EntryItemWidgets) do
        EntryId = Pet.Entry[i]
        Data = DataMgr.PetEntry[EntryId]
        local Content = {
            index = i,
            Owner = self
        }
        if (Data) then
            Content.EntryId = EntryId
            Content.Name = GText(Data.PetEntryName)
            Content.IconPath = GText(Data.Icon)
            Content.Rarity = Data.Rarity
            Content.Desc = SkillUtils.CalcPetEntryDesc(EntryId)
        end

        if EntryId == 0 or EntryId == nil then
            Content.IsEmpty = true
        else
            Content.IsEmpty = false
        end
        Content.IsLocked = i > UnlockedEntryNum
        if (EntryId) then
            HasAnyEntry = true
        end
        if (self.EntryItemWidgets[i] and not beNotChangeView) then
            self.EntryItemWidgets[i]:Init(Content)
        end
        table.insert(self.EntryContents, Content)
    end
    self.CurEntryContent = self.EntryContents[self.CurEntryContentIdx]
    if self.EntryItemWidgets[self.CurEntryContent.index].SetIsSelected then
        self.EntryItemWidgets[self.CurEntryContent.index]:SetIsSelected(true)
    else
        self.EntryItemWidgets[self.CurEntryContent.index]:SetSelected(true)
    end
end
-- function M:
-- 浮动的宠物词条点击
--- func desc
---@param WidgetInex any
function M:OnEntryClicked(WidgetIndex)

    ArmoryUtils:SetContentIsSelected(self.CurEntryContent, false)
    self.CurEntryContent = self.EntryContents[self["EntryItem_" .. WidgetIndex].ContentIdx]
    ArmoryUtils:SetContentIsSelected(self.CurEntryContent, true)
    self:ChanegeSelectEntry()
end
-- 待消耗的宠物格子点击
---@param WidgetInex  格子索引
function M:OnPetItemClicked(WidgetInex)
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_mid", nil, nil)
    if self.IsListExpanded == false then
        self:ExpandList(true) -- 接下来执行的逻辑在Armory_PetEnhance_Selective_Listing_Compoment
        self:FocusListItem()
    else
        local FilteredPets = self:GetFilteredPet(self.CurEntryContent.EntryId)
        if FilteredPets and #FilteredPets == 0 then
            UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("AvailablePet_Empty")) -- 没有素材
        else
            UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_Armory_Toast_Material")) -- 请选择材料
        end
    end
end
-- 根据词条属性切换对应面板样式
---@param bNotPlayAni 是否禁止播放切词条动画
function M:ChanegeSelectEntry(bNotPlayAni)
    for i = 1, 3 do -- 先清除消耗宠物，不然背包有残留
        if next(self.ConsumeContents[i]) then
            self:CancelChosenContent(self.ConsumeContents[i].Father)
        end
    end
    if self.CurEntryContent.IsLocked then -- 宠物词条槽位未解锁
        self:InitLockedEntry()
    elseif self.CurEntryContent.IsEmpty then -- 宠物词条为空
        self:InitLNullEntry()
    elseif self.CurEntryContent.EntryId and DataMgr.PetEntry[self.CurEntryContent.EntryId].PetEntryUPID == nil then
        -- 宠物词条已满级
        self:InitMaxEntry()
        if not bNotPlayAni then
            self:PlayAnimation(self.PromptLevelUp) -- 该特效现在用于换词条
        end
    else -- 宠物词条可升级
        self:InitEnhaceEntry()
        -- self:InitMaxEntry()
        if not bNotPlayAni then
            self:PlayAnimation(self.PromptLevelUp) -- 该特效现在用于换词条
        end
    end

end

--- func 词条升级面板
function M:InitEnhaceEntry()
    -- 恢复被其他面板隐藏的控件
    self.HB_Entry:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Preview:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.WB_Item:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.WidgetSwitcher_Btn:SetActiveWidgetIndex(0)
    self.Panel_Hint:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)

    local EntryId = self.CurEntryContent.EntryId
    local NewEntryId = DataMgr.PetEntry[EntryId].PetEntryUPID
    local OriginContent = {
        Rarity = DataMgr.PetEntry[EntryId].Rarity,
        Name = GText(DataMgr.PetEntry[EntryId].PetEntryName),
        IconPath = DataMgr.PetEntry[EntryId].IconS
    }
    local NewContent = {
        Rarity = DataMgr.PetEntry[NewEntryId].Rarity,
        Name = GText(DataMgr.PetEntry[NewEntryId].PetEntryName),
        IconPath = DataMgr.PetEntry[EntryId].IconS
    }

    self.EntryTag_Now:Init(OriginContent)
    self.EntryTag_Preview:Init(NewContent)

    self.Text_Detail:SetText(SkillUtils.CalcPetEntryEnhanceDesc(EntryId, DataMgr.PetEntry[EntryId].PetEntryUPID))

    self.ConsumeCount = DataMgr.PetEntry[EntryId].PetEntryUPCount or 0
    self.FirstEmptyItemIndex = 1

    self.Text_Total:SetText("/" .. self.ConsumeCount)
    self.ConsumeContents = {{}, {}, {}}
    self:RebuildSlots()
    -- 重新计算一下按钮状态
    self:OnPetNumChange()

end
-- 词条满级面板
function M:InitMaxEntry()
    self.HB_Entry:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Preview:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Text_Detail:SetText(SkillUtils.CalcPetEntryDesc(self.CurEntryContent.EntryId))
    self.WB_Item:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.WidgetSwitcher_Btn:SetActiveWidgetIndex(1)
    self.Hint_Pet.WidgetSwitcher_State:SetActiveWidgetIndex(1)
    self.Panel_Hint:SetVisibility(UIConst.VisibilityOp.Hidden)
    local EntryId = self.CurEntryContent.EntryId
    local OriginContent = {
        Rarity = DataMgr.PetEntry[EntryId].Rarity,
        Name = GText(DataMgr.PetEntry[EntryId].PetEntryName),
        IconPath = DataMgr.PetEntry[EntryId].Icon
    }
    self.EntryTag_Now:Init(OriginContent)
end
-- 词条未解锁面板
function M:InitLockedEntry()

    self.WB_Item:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.WidgetSwitcher_Btn:SetActiveWidgetIndex(0)
    self.Hint_Pet.Text_Hint_Normal:SetText(GText(""))
    self.HB_Entry:SetVisibility(UIConst.VisibilityOp.Collapsed)
   -- self.Panel_Text:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Panel_Hint:SetVisibility(UIConst.VisibilityOp.Hidden)
    self.Btn_Enhance:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.Btn_Enhance:ForbidBtn(true)
    self.Text_Detail:SetText(GText("Pet_AffixSlot_LockToast"))
    self:ClearConsumeContent()

end
-- 空槽位词条面板
function M:InitLNullEntry()

    self.WB_Item:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.WidgetSwitcher_Btn:SetActiveWidgetIndex(0)
    self.Hint_Pet.Text_Hint_Normal:SetText(GText(""))
    self.HB_Entry:SetVisibility(UIConst.VisibilityOp.Collapsed)
  --  self.Panel_Text:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Panel_Hint:SetVisibility(UIConst.VisibilityOp.Hidden)
    self.Btn_Enhance:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.Btn_Enhance:ForbidBtn(true)
    self.Text_Detail:SetText(GText("UI_Pet_Affix_Without"))
    self:ClearConsumeContent()
end

---
-- 词条进阶的过渡态，过度完后会刷新
function M:InitTransition()
    -- 先行更新当前词条
    local EntryId = self.CurEntryContent.EntryId
    local NewEntryId = DataMgr.PetEntry[EntryId].PetEntryUPID
    local NewContent = {
        Rarity = DataMgr.PetEntry[NewEntryId].Rarity,
        Name = GText(DataMgr.PetEntry[NewEntryId].PetEntryName)
    }
    self.EntryTag_Now:Init(NewContent)
    -- 通用item置为空态

    self:ClearConsumeContent()

    -- 禁用按钮
    self.Btn_Enhance:ForbidBtn(true)
    self.Btn_Enhance:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    -- 宠物数量文字
    --self.Panel_Hint:SetVisibility(UIConst.VisibilityOp.Hidden)
    -- 隐藏词条预览
    self.Preview:SetVisibility(UIConst.VisibilityOp.Collapsed)

end
--- 判断是否宠物列表已满，满了就不能添加
function M:IsPetFull()
    local emptyIndex = nil
    for i = 1, self.ConsumeCount do
        if not next(self.ConsumeContents[i]) then
            emptyIndex = i
            break
        end
    end
    if emptyIndex == nil then
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("Pet_LevelUp_AddMax"))
        return true
    end
    return false

end

--- func desc 尝试增加item，如果已满则返回,如果
---@param Content any
---@param bForceChose boolean 是否无视珍贵提示强制选择，珍贵提示回调用
function M:TryAddConsumeContent(Content, bForceChose)
    Content.IsSelected = false
    -- 查找第一个空位
    local emptyIndex = nil
    for i = 1, self.ConsumeCount do
        if not next(self.ConsumeContents[i]) then
            emptyIndex = i
            break
        end
    end

    if emptyIndex then
        -- 填充内容并更新UI
        self.ConsumeContents[emptyIndex] = Content
        self:SetSlotContent(emptyIndex, Content)
        self:OnPetNumChange()
        return true
    else
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("Pet_LevelUp_AddMax"))
        return false
    end

end

--- 删除指定槽位的消耗宠物
---@param index integer @槽位索引(1-based)
---@return void
-- 逻辑流程：
-- 1. 取消当前槽位内容的选择状态
-- 2. 清空目标槽位
-- 3. 前移后续非空槽位内容（保留顺序）
-- 4. 触发数量变更事件
-- 5. 重建所有槽位UI
function M:DeleteConsumeContent(index)
    -- 移除指定位置内容
    self:CancelChosenContent(self.ConsumeContents[index].Father)
    self.ConsumeContents[index] = {}
    -- 前移后续内容
    for i = index, self.ConsumeCount - 1 do
        if next(self.ConsumeContents[i + 1]) then
            self.ConsumeContents[i] = self.ConsumeContents[i + 1]
            self.ConsumeContents[i + 1] = {}
        end
    end
    self:OnPetNumChange()
    -- 重建所有槽位
    self:RebuildSlots()
end
-- 清除选择宠物并同步到右侧背包
function M:ClearConsumeContent()
    for i = 1, 3 do
        if next(self.ConsumeContents[i]) and self.ConsumeContents[i].Father then
            self:CancelChosenContent(self.ConsumeContents[i].Father)
        end
    end
    self.ConsumeContents = {{}, {}, {}}
    self:RebuildSlots(true)
end
--- 根据self.ConsumeCount重建所有槽位
---@param bReSetAdd  是否强制不让添加add，槽位被禁用时填true
function M:RebuildSlots(bForceNoAdd)
    for i = 1, 3 do
        local Content = self.ConsumeContents[i]
        if Content == nil then
            Content = {}
        end
        if next(Content) and Content.bIsEmpty ~= true then
            self:SetSlotContent(i, Content)
        else -- 槽位没有初始化或内容为空
            if not next(Content) then -- 没有初始化或者已经初始化但是需要检查add
                local bCanAdd = false
                if i <= self.ConsumeCount and bForceNoAdd ~= true then
                    bCanAdd = true
                else
                    bCanAdd = false
                end
                self:SetEmptySlot(i, bCanAdd)
            end

        end
    end
end

--- 根据内容设置槽位的view
---@param Index 槽位索引
---@param Content 宠物内容
function M:SetSlotContent(Index, Content)
    Content.IsChosen = false
    Content.Index = Index -- 更新索引
    Content.OnMouseButtonUpEvents = {
        Obj = self,
        Callback = function()
            self:DeleteConsumeContent(Index)
        end,
        Params = {Index}
    }
    Content.OnBtnAddClicked = function()
        self:DeleteConsumeContent(Index)
    end
    Content.bAllUseAsyncLoadWidget=false
    self["Item_" .. Index]:OnListItemObjectSet(Content)
    self["Item_" .. Index]:SetItemSelect(false)
    self["Item_" .. Index]:SetAdd(false)
    self["Item_" .. Index]:SetItemMinus(true)
    -- self["Item_" .. Index]:SetMinusBtn(true, self, function()
    --     self:DeleteConsumeContent(Index)
    -- end)
    local Widget = self["Item_" .. Index]
    local MinusBtn = Widget.MinusWidget and Widget.MinusWidget.Btn_Minus
    if not MinusBtn then
        return
    end
    MinusBtn.ClickLogics={}
    MinusBtn:BindEventOnClicked(self, self.DeleteConsumeContent, Index)
end
--- 设置空槽位的view
---@param Index 槽位索引
---@param bCanAdd 是否能添加
function M:SetEmptySlot(Index, bCanAdd)
    if bCanAdd == nil then
        bCanAdd = false -- 默认不能添加
    end
    local EmptyContent = NewObject(UIUtils.GetCommonItemContentClass())
    EmptyContent.bAllUseAsyncLoadWidget=false
    EmptyContent.Index = Index
    if bCanAdd then
        EmptyContent.OnMouseButtonUpEvents = {

            Obj = self,
            Callback = function()
                self:OnPetItemClicked(Index)
            end,
            Parms = {Index}
        }
    end

    EmptyContent.bIsEmpty = true
    self["Item_" .. Index]:OnListItemObjectSet(EmptyContent)
    self["Item_" .. Index]:SetAdd(bCanAdd)

end
--- 消耗宠物数量变化是修改，同步
function M:OnPetNumChange()
    local num = 0
    for i = 1, 3 do
        if self.ConsumeContents[i] and self.ConsumeContents[i].Uuid then
            num = num + 1
        end
    end
    self.Text_Num:SetText(num)
    if num == self.ConsumeCount then
        self.Btn_Enhance:ForbidBtn(false)
        self.Btn_Enhance:SetVisibility(UIConst.VisibilityOp.Visible)
    else
        self.Btn_Enhance:ForbidBtn(true)
        self.Btn_Enhance:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    end
end

--- 进阶按钮点击回调
function M:OnEnhanceClicked()
    -- 播放动画A并在完成后播放动画B
    self:ExpandList(false)
    -- 保留原有RPC调用逻辑
    local Avatar = GWorld:GetAvatar()
    local ConsumePetUniqueIds = {}
    for i = 1, 3 do
        if self.ConsumeContents[i] and self.ConsumeContents[i].Uuid then
            table.insert(ConsumePetUniqueIds, self.ConsumeContents[i].UniqueId)
        end
    end
    local InAniStr = "LevelUp_In"
    local OutAniStr = "LevelUp_Out"
    local NewEntryId = DataMgr.PetEntry[self.CurEntryContent.EntryId].PetEntryUPID
    local bIsMax = false
    if NewEntryId and DataMgr.PetEntry[NewEntryId].PetEntryUPID == nil then
        InAniStr = "LevelUp_Max_In"
        OutAniStr = "LevelUp_Max_Out"
        bIsMax = true
    end

    local Callback = function(ErrCode)
        self:BlockAllUIInput(false)
        if ErrCode ~= ErrorCode.RET_SUCCESS then
            local ErrorCodeData = DataMgr.ErrorCode[ErrCode]
            UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText(ErrorCodeData.ErrorCodeContent))
            return
        end
        self:BindToAnimationFinished(self[InAniStr], function()
            self:UnbindAllFromAnimationFinished(self[InAniStr])
            ScreenPrint("播放out动画")
            self:PlayAnimation(self[OutAniStr])
        end)
        self:UnbindAllFromAnimationFinished(self[OutAniStr])
        self:BindToAnimationFinished(self[OutAniStr], function()
            self:ChanegeSelectEntry(true)
            if bIsMax then
                ---动画中通过SetPadding控制box的隐藏，而代码中使用visibility来控制，在动画结束后用恢复Padding
                self:AddTimer(0.01, function()
                    --ScreenPrint("播放out动画完毕")
                    local slot = UE4.UWidgetLayoutLibrary.SlotAsVerticalBoxSlot(self.WB_Item)
                    if slot then
                        slot:SetPadding(FMargin(0, 0, 0, 0))
                    end
                    self.WB_Item:SetRenderOpacity(1)

                end)
            end
            if self.CurInputDeviceType == ECommonInputType.Gamepad then -- 播完动画恢复光标
                self.GameInputModeSubsystem:SetNavigateWidgetOpacity(1)
            end
            self:FreshEntryUi()
            self:AddTimer(0.2, function() -- 播完In动画会恢复visible，要延时一点处理
                self.EntryItemWidgets[self.CurEntryContent.index]:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
            end)
        end)
        if self.CurInputDeviceType == ECommonInputType.Gamepad then
            self.GameInputModeSubsystem:SetNavigateWidgetOpacity(0) -- 播动画时希望隐藏光标
        end

        self:PlayAnimation(self[InAniStr])

        for i = 1, 3 do
            if self.ConsumeContents[i] and self.ConsumeContents[i].Uuid then
                self:RemoveConsumePet(self.ConsumeContents[i].Father)
            end
        end
        self:InitTransition() ---需要放在RemoveConsumePet之后，否则会有bug
        -- 遍历当前放置的宠物并删除

        self:UpgradeEntry(self.CurEntryContent)
        AudioManager(self):PlayUISound(nil, "event:/ui/common/same_card_strengthen_success", nil, nil)
        if (self.ActorController) then
            self.ActorController:PlayPetVoice("vo_happy")
        end
    end
    self:AddTimer(5, function() --弱网下太久没收到回调就解锁输入限制
        ScreenPrint("解除输入限制")
        self:BlockAllUIInput(false)
    end)
    self:BlockAllUIInput(true)
    Avatar:PetEntryUp(self.Pet.UniqueId, self.CurEntryContent.index, ConsumePetUniqueIds, Callback)
end

--- 升级后更新词条信息，暂时不同步到UI
---@param EntryContent 待更新的词条
function M:UpgradeEntry(EntryContent)

    local NewEntryId = DataMgr.PetEntry[EntryContent.EntryId].PetEntryUPID

    local Data = DataMgr.PetEntry[NewEntryId]

    if (Data) then
        EntryContent.EntryId = NewEntryId
        EntryContent.Name = GText(Data.PetEntryName)
        EntryContent.IconPath = GText(Data.Icon)
        EntryContent.Rarity = Data.Rarity
        EntryContent.Desc = SkillUtils.CalcPetEntryDesc(NewEntryId)
    end
    -- self.EntryItemWidgets[self.CurEntryContent.index]:Init(self.CurEntryContent)
    -- self:InitEnhaceEntry()
    -- 收进阶后集新词条的宠物
    local Entry = {self.CurEntryContent.EntryId}
    self:UpdateEntryPets(Entry)
    -- self:CollectValidEntries(self.Pet,entry)
end
-- 播完动画后显示ui
function M:FreshEntryUi()
    self.EntryItemWidgets[self.CurEntryContent.index]:PlayAnimation(
self.EntryItemWidgets[self.CurEntryContent.index].RefreshColor)
    self.EntryItemWidgets[self.CurEntryContent.index]:Init(self.CurEntryContent)
    self.EntryItemWidgets[self.CurEntryContent.index]:SetIsSelected(true)

end
function M:PlayInAnim()
    self:PlayAnimation(self.In)
end

function M:PlayOutAnim()
    if self.ActorController then
        self.ActorController:SetMontageAndCamera(CommonConst.ArmoryType.Pet, "Pet", nil, nil)
    end
    self:BindToAnimationFinished(self.Out, {self, self.Close})
    self:PlayAnimationForward(self.Out)
end
function M:Close()
    EventManager:FireEvent(EventID.OnPetEntryUpReturn)
end
function M:CheckIsCanCloseSelf()
    if (self:IsAnimationPlaying(self.In)) then
        return false
    end
    if self:IsAnimationPlaying(self.LevelUp_Max_Out) or self:IsAnimationPlaying(self.LevelUp_Out) or self:IsAnimationPlaying(self.LevelUp_In) or self:IsAnimationPlaying(self.LevelUp_Max_In) then
        return false
    end
    return true
end
function M:OnListExpand(bExpand)
    if bExpand then
        self.Image_ClickNotPass:SetVisibility(UIConst.VisibilityOp.Visible)
    else
        self.Image_ClickNotPass:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end
function M:FocusListItem()
    local TileView = self.Selective_Listing.TileView_Select_Role
    if TileView:GetNumItems() > 0 then
        local SelectedItem = TileView:BP_GetSelectedItem()
        TileView:NavigateToIndex(0)
    end
    if self.CurInputDeviceType == ECommonInputType.Gamepad and self.SetSingleBottomKeyInfo then
        self:SetSingleBottomKeyInfo(1)
    end
end
AssembleComponents(M)
return M
