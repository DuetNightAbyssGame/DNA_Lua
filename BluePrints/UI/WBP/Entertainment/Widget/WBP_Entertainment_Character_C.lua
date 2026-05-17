require "UnLua"

local FEntertainmentUtils = require "BluePrints.UI.WBP.Entertainment.EntertainmentUtils"

---@class WBP_Entertainment_Character : WBP_Entertainment_Character_C, BP_UIState_C
local M = Class({"BluePrints.UI.BP_UIState_C"})
M._components = {
    "BluePrints.UI.UI_PC.Common.LSFocusComp",
}
-- public:

function M:OpenPanel()
	if (self:IsPanelOpened()) then
		return
	end
	self:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
	self:StopAllAnimations()
	self:PlayAnimation(self.In)

	if self.bNeedRefresh then
		self:RefreshCharacterTileView(true)
	else
		self:AddTimer(0.1, function()
			self:EnsureCharacterTileViewFullPage()
			-- self.List_Character:SetFocus()
		end)
	end
	self.List_Character:NavigateToIndex(0)
	self:AddTimer(0.1, function()
		self.List_Character:RequestPlayEntriesAnim()
	end)

	self:AddLSFocusTarget(nil, self.FilterSort, nil, true)
	self.bNeedRefresh = false
end

function M:ClosePanel(OnPanelClosed)
	if (not self:IsPanelOpened()) then
		return
	end
	self:SetOnPanelClosed(OnPanelClosed)
	self:StopAllAnimations()
	self:PlayAnimation(self.Out)

	self.List_Character:RequestPlayEntriesAnim()
end

function M:IsPanelOpened()
	return self:GetVisibility() ~= ESlateVisibility.Collapsed
end

function M:SetDisplayCharacter(SettedCharacterData, OwnedCharacterDataMap)
	if (not SettedCharacterData) then
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.Invite, "设置展示角色失败", "设置展示角色失败，SettedCharacterData 为空。")
		return
	end
	if (not OwnedCharacterDataMap) then
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.Invite, "设置展示角色失败", "设置展示角色失败，OwnedCharacterDataMap 为空。")
		return
	end

	self:SetOwnedCharacterDataMap(OwnedCharacterDataMap)
	self:SetSettedCharacterData(SettedCharacterData, true)
end

function M:SetReverseSorting(bNewReverseSorting)
	self.bReverseSorting = bNewReverseSorting
	self:RefreshCharacterTileView(true)
end

function M:RefreshRedDot()
	local CharacterContentList = self.CharacterContentList
	if not CharacterContentList then return end
	for _, Content in pairs(CharacterContentList) do
		local Upgradeable = FEntertainmentUtils:IsCharacterShowRedDot(Content.Id)
		if Upgradeable then
			Content.RedDotType = UIConst.RedDotType.CommonRedDot
		else
			Content.RedDotType = nil
		end
		if Content.SelfWidget and Content.SelfWidget.SetReddot then
			Content.SelfWidget:SetReddot(Content.RedDotType)
		end
	end
end

function M:RefreshCharacterTileView(bRefreshSort)
	local SettedCharacterItem, CharacterItemArray
	if not self.CharacterContentList then
		SettedCharacterItem, CharacterItemArray = self:CreateCharacterItemInfo()
	else
		SettedCharacterItem, CharacterItemArray = self:RefreshCharacterItemInfo()
	end
	self.CharacterContentList = CharacterItemArray
	self:SetSelectedCharacterItem(SettedCharacterItem)
	self.bNeedRefresh = true
	if bRefreshSort then
		self.List_Character:ClearListItems()
		self:SortCharacterItemArray(CharacterItemArray)
		self:FillCharacterTileView(CharacterItemArray)
		self.List_Character:NavigateToIndex(0)
		self.bNeedRefresh = false
		self.List_Character:RegenerateAllEntries() -- 重建下List，避免动画播放时出现顺序问题
	end

	self:AddTimer(0.1, function()
		self:EnsureCharacterTileViewFullPage()
	end)
end

function M:BindOnSettedCharacterDataChanged(OnSettedCharacterDataChanged)
	self.OnSettedCharacterDataChanged = OnSettedCharacterDataChanged
end

function M:ExecuteOnSettedCharacterDataChanged(CharacterData)
	if (self.OnSettedCharacterDataChanged) then
		self.OnSettedCharacterDataChanged(CharacterData)
	end
end

function M:BindOnSelectedCharacterDataChanged(OnSelectedCharacterDataChanged)
	self.OnSelectedCharacterDataChanged = OnSelectedCharacterDataChanged
end

function M:ExecuteOnSelectedCharacterDataChanged(CharacterData)
	if (self.OnSelectedCharacterDataChanged) then
		self.OnSelectedCharacterDataChanged(CharacterData)
	end
end

function M:SetOnPanelClosed(OnPanelClosed)
	self.OnPanelClosed = OnPanelClosed
end

function M:ExecuteOnPanelClosed()
	if (self.OnPanelClosed) then
		self.OnPanelClosed()
	end
end

function M:BindOnCloseButtonClicked(OnCloseButtonClicked)
	self.OnCloseButtonClicked = OnCloseButtonClicked
end

function M:ExecuteOnCloseButtonClicked()
	if (self.OnCloseButtonClicked) then
		self.OnCloseButtonClicked()
	end
end

-- protected:

function M:Initialize(Initializer)
	M.Super.Initialize(self, Initializer)

	self.ChangeCharacterButtonText = GText("UI_Character_Replacement")

	self.SortRules = {"UI_SHOWNPC_LIST_CONT_1"}
	self.SortType = CommonConst.DESC
	self.bReverseSorting = false

	self.CurrentSettedCharacterData = nil
	self.OwnedCharacterDataMap = nil
	self.OnCharacterChanged = nil
	self.OnPanelClosed = nil
	self.CurrentSelectedCharacterItem = nil
	self.CurrentSettedCharacterItem = nil

	self.SelectCharacterSound = "event:/ui/armory/click_select_role"
	self.ChangeCharacterSound = "event:/ui/common/role_replace"
end

function M:Construct()
	self:BindToAnimationFinished(self.In, {self, self.HandleOnInAnimationFinished})
	self:BindToAnimationFinished(self.Out, {self, self.HandleOnOutAnimationFinished})

	self.Btn_Close.OnClicked:Add(self, self.HandleOnCloseButtonClicked)
	--self.List_Character.BP_OnItemClicked:Add(self, self.HandleOnCharacterItemClicked)
end

function M:Init(Parent)
	self.FilterSort:Init(Parent, self.SortRules, self.SortType)
	self.FilterSort:BindEventOnSortTypeChanged(self, self.HandleOnSortTypeChanged)
end

function M:Destruct()
	self:UnbindFromAnimationFinished(self.In, {self, self.HandleOnInAnimationFinished})
	self:UnbindFromAnimationFinished(self.Out, {self, self.HandleOnOutAnimationFinished})

	--self.List_Character.BP_OnItemClicked:Remove(self, self.HandleOnCharacterItemClicked)
	self.CharacterContentList = nil
end

-- private:

function M:HandleOnInAnimationFinished()
end

function M:HandleOnOutAnimationFinished()
	self:SetVisibility(ESlateVisibility.Collapsed)
	self:ExecuteOnPanelClosed()
end

function M:HandleOnCloseButtonClicked()
	self:ExecuteOnCloseButtonClicked()
end

function M:HandleOnCharacterItemClicked(CharacterItem)
	if (CharacterItem.IsEmpty) then
		return
	end
	local CharacterData = self.OwnedCharacterDataMap[CharacterItem.Id]
	self:HandleOnChangeNPCButtonClicked(CharacterData)
	self:ExecuteOnSelectedCharacterDataChanged(CharacterData)
	self:ExecuteOnSettedCharacterDataChanged(CharacterData)
	-- AudioManager(self):PlayUISound(self, self.SelectCharacterSound, nil, nil)
	AudioManager(self):PlayUISound(self, self.ChangeCharacterSound, nil, nil)
end

function M:HandleOnSortTypeChanged()
	self:SetReverseSorting(not self.bReverseSorting)
end

function M:HandleOnChangeNPCButtonClicked(CharacterData)
	self:SetSettedCharacterData(CharacterData)
end

function M:CreateCharacterItemInfo()
	local SettedCharacterItem = nil
	local CharacterItemArray = {}
	for _, CharacterData in pairs(self.OwnedCharacterDataMap) do
		local CharacterItem = nil
		if (CharacterData.Id == self.CurrentSettedCharacterData.Id) then
			CharacterItem = self:CreateCharacterItem(CharacterData, true)
			SettedCharacterItem = CharacterItem
		else
			CharacterItem = self:CreateCharacterItem(CharacterData)
		end
		table.insert(CharacterItemArray, CharacterItem)
	end
	return SettedCharacterItem, CharacterItemArray
end

function M:RefreshCharacterItemInfo()
	local SettedCharacterItem = nil
	local CharacterItemArray = self.CharacterContentList
	local CurrentSettedCharacterDataId = self.CurrentSettedCharacterData.Id
	local OwnedCharacterDataMap = self.OwnedCharacterDataMap
	for _, Content in pairs(CharacterItemArray) do
		local ContentId = Content.Id
		local CharacterData = OwnedCharacterDataMap[ContentId]
		if (ContentId == CurrentSettedCharacterDataId) then
			SettedCharacterItem = Content 
			Content = self:CreateCharacterItem(CharacterData, true, Content)
		else
			Content = self:CreateCharacterItem(CharacterData, nil,  Content)
		end
	end
	return SettedCharacterItem, CharacterItemArray
end

function M:SortCharacterItemArray(CharacterItemArray)
	table.sort(CharacterItemArray, function(a, b)
		if a.bPriority and not b.bPriority then
			return true
		elseif not a.bPriority and b.bPriority then
			return false
		end
		if (a.IsSelect == b.IsSelect) then
			if (a.Rarity == b.Rarity) then
				return a.Id > b.Id
			else
				-- 目前只有稀有度，因此默认稀有度使用倒序
				if (self.bReverseSorting) then
					return a.Rarity < b.Rarity
				else
					return a.Rarity > b.Rarity
				end
			end
		else
			return a.IsSelect
		end
	end)
end

function M:FillCharacterTileView(CharacterItemArray)
	for _, CharacterItem in pairs(CharacterItemArray) do
		self.List_Character:AddItem(CharacterItem)
	end
end

function M:EnsureCharacterTileViewFullPage()
	local ItemNum = self.List_Character:GetNumItems()
	local FullPageCharacterCount = UIUtils.GetTileViewContentMaxCount(self.List_Character)
	for i = ItemNum + 1, FullPageCharacterCount do
		local CharacterItem = self:CreateCharacterItem(nil)
		self.List_Character:AddItem(CharacterItem)
	end
end

function M:CreateCharacterItem(CharacterData, IsSelected, Item)
	local CharacterItem = Item
	if not Item then
		local Class = UIUtils.GetCommonItemContentClass()
		CharacterItem = NewObject(Class)
	end
	if (not CharacterData) then
		CharacterItem.IsEmpty = true
		return CharacterItem
	end

	CharacterItem.Parent = self
	CharacterItem.Type = 'Npc'
	CharacterItem.IsSelect = IsSelected or false
	--CharacterItem.SettedTipText = GText("UI_State_Replaced")
	CharacterItem.Id = CharacterData.Id
	CharacterItem.Name = CharacterData.Name
	CharacterItem.WorldName = CharacterData.WorldName
	CharacterItem.Icon = CharacterData.IconPath
	CharacterItem.Rarity = CharacterData.Rarity
	CharacterItem.HandleMouseDown = true
	local Upgradeable = FEntertainmentUtils:IsCharacterShowRedDot(CharacterData.Id)
	if Upgradeable then
		CharacterItem.RedDotType = UIConst.RedDotType.CommonRedDot
	end
	CharacterItem.bPriority = CharacterData.bPriority
	CharacterItem.OnMouseButtonUpEvents = {
		Obj = self,
		Callback = function(obj)
			obj:HandleOnCharacterItemClicked(CharacterItem)
		end
	}
	return CharacterItem
end

function M:SetSettedCharacterData(NewSettedCharacterData, bRefreshSort)
	self.CurrentSettedCharacterData = NewSettedCharacterData
	self:RefreshCharacterTileView(bRefreshSort)
end

function M:SetOwnedCharacterDataMap(NewOwnedCharacterDataMap)
	self.OwnedCharacterDataMap = NewOwnedCharacterDataMap
end

function M:SetSelectedCharacterItem(NewSelectedCharacterItem)
	if (self.CurrentSelectedCharacterItem == NewSelectedCharacterItem) then
		return
	end
	if (self.CurrentSelectedCharacterItem) then
		self.CurrentSelectedCharacterItem.IsSelect = false
		if (self.CurrentSelectedCharacterItem.SelfWidget) then
			self.CurrentSelectedCharacterItem.SelfWidget:SetSelected(false)
		end
	end

	if (NewSelectedCharacterItem) then
		NewSelectedCharacterItem.IsSelect = true
		if (NewSelectedCharacterItem.SelfWidget) then
			NewSelectedCharacterItem.SelfWidget:SetSelected(true)
		end
	end

	self.CurrentSelectedCharacterItem = NewSelectedCharacterItem
end

function M:OnGamePadKeyDown(MyGeometry, InKeyEvent)
	return self:OnKeyDownForLSComp(MyGeometry, InKeyEvent)
end

function M:BP_GetDesiredFocusTarget()
	return self.List_Character
end

AssembleComponents(M)

return M
