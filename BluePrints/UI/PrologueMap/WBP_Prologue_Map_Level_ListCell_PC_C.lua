--
-- 拼接关卡二级界面关卡列表
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
---@type Prologue_Map_Level_ListCell_PC_C
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:Construct()
    self.New_Tag:SetVisibility(ESlateVisibility.Collapsed)
    self.Common_GuidePoint_PC:SetVisibility(ESlateVisibility.Collapsed)
    self.Common_List_Subcell_PC:BindEventOnClicked(self, self.OnSubCellClicked)

	EventManager:AddEvent(EventID.TeamMatchTimingStart, self, self.RefreshBtnState)
	EventManager:AddEvent(EventID.TeamMatchTimingEnd, self, self.RefreshBtnState)
end

function M:Destruct()
	EventManager:RemoveEvent(EventID.TeamMatchTimingStart, self)
	EventManager:RemoveEvent(EventID.TeamMatchTimingEnd, self)
end

function M:BindEventOnClicked(Obj, Func, ...)
    if not Obj or not Func then
        return
    end
    self.Obj = Obj
    self.Func = Func
    self.Params = {...}
end

-- 初始化关卡信息
function M:InitDungeonInfo(DungeonId)
    self.DungeonId = DungeonId
    local Data = DataMgr.Dungeon[DungeonId]
    if not DungeonId then
        DebugPrint("ZDX_DungeonId is nil")
        return
    end

	-- 判断是否解锁
	if PageJumpUtils:CheckDungeonCondition(Data.Condition) then
		self:SetVisibility(ESlateVisibility.Visible)
		self.WidgetSwitcher:SetActiveWidget(self.Content)
		self.Image_Lock:SetVisibility(ESlateVisibility.Collapsed)
	else
		-- 标记通用ListCell不可交互，用于禁用ListCell点击相关动效
		self.Common_List_Subcell_PC.IsCantInteractable = true
		self.Image_Lock:SetVisibility(ESlateVisibility.Visible)
		self:PlayAnimation(self.Forbidden)
	end
    self.DungeonId = DungeonId
    self.Text_Limit:SetText(GText("UI_DUNGEON_LevelLimit"))
    self.Title_Level:SetText(GText(Data.DungeonName))
    if Data.DungeonLevel then
        self.Text_Lv:SetVisibility(ESlateVisibility.Visible)
        self.Text_Lv:SetText(GText(Data.DungeonLevel))
    else
        self.Text_Lv:SetVisibility(ESlateVisibility.Collapsed)
    end
end

---通用subcell点击响应方法
function M:OnSubCellClicked()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return false
    end

	if self:IsMatching() then
		return false
	end
	
    if PageJumpUtils:CheckDungeonCondition(DataMgr.Dungeon[self.DungeonId].Condition, true) then
		--self.IsSelect = true
        self:PlayAnimation(self.Select)
        if self.Obj and self.Func then
            self.Func(self.Obj, table.unpack(self.Params))
        end
    end
end

function M:IsMatching()
	local MatchTimingBar = UIManager(self):GetUIObj("DungeonMatchTimingBar")
	return MatchTimingBar and true
end

function M:RefreshBtnState(bIsMatching)
	if bIsMatching == nil then
		bIsMatching = self:IsMatching()
	end
	
	-- 判断是否解锁
	local Data = DataMgr.Dungeon[self.DungeonId]
	if PageJumpUtils:CheckDungeonCondition(Data.Condition) then
		if bIsMatching then
			self.Common_List_Subcell_PC.IsCantInteractable = true
		else
			self.Common_List_Subcell_PC.IsCantInteractable = false
		end

		if not self.Common_List_Subcell_PC.IsSelect then
			self:StopAllAnimations()
			self:PlayAnimation(bIsMatching and self.Forbidden or self.Normal)
		end
		
		self:SetVisibility(ESlateVisibility.Visible)
		self.WidgetSwitcher:SetActiveWidget(self.Content)
		self.Image_Lock:SetVisibility(ESlateVisibility.Collapsed)
	else
		-- 标记通用ListCell不可交互，用于禁用ListCell点击相关动效
		self.Common_List_Subcell_PC.IsCantInteractable = true
		self.Image_Lock:SetVisibility(ESlateVisibility.Visible)
		self:PlayAnimation(self.Forbidden)
	end
end

return M
