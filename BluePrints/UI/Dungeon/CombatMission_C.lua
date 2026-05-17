---@type Battle_Combat_Mission_C
local Battle_Combat_Mission_C = Class("BluePrints.UI.BP_UIState_C")

function Battle_Combat_Mission_C:OnLoaded(...)
    self.Super.OnLoaded(self, ...)

	self.Panel_Mission01:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
	self:ShowOrHideCompltetPanel(false)
	self:ShowOrHideNewTaskPanel(false)
	self.bFirstShow = true
	self.Status = true
	self:InitListenEvent()
	self:PlayAnimation(self.Get_in)
	self.SubTaskWidgetsTable = {}
end

function Battle_Combat_Mission_C:Construct()
    self.Super.Construct(self)
	if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
		self.Button_Area.OnClicked:Add(self, self.OnClickedBtnArea)
	end
end

function Battle_Combat_Mission_C:Destruct()
    self.Super.Destruct(self)
	if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
		self.Button_Area.OnClicked:Clear()
	end
end

function Battle_Combat_Mission_C:InitListenEvent()
	self:AddDispatcher(EventID.OnReceiveTask, self, self.SetTaskIconAndName)
end

function Battle_Combat_Mission_C:RefreshGuideInfo()
	local GameState = UE4.URuntimeCommonFunctionLibrary.GetCurrentGameState(self)
	if GameState then
		GameState:TryShowDungeonFirstGuide(GameState.GameModeType)
	end
end

function Battle_Combat_Mission_C:SetTaskIconAndName(WidgetType, TaskIconPath, TextTitle, TaskContent, bNeedAnimation)
	local AfterAnim = 
	function ()
		if not TaskIconPath then
			return
		end
		if not TextTitle then
			return
		end
		if not TaskContent then
			return
		end
		local Title = GText(TextTitle)
		local Content = GText(TaskContent)
		if not Title then
			return
		end
		if not Content then
			return
		end
		if WidgetType == ""  then
			return
		end

		local Avatar = GWorld:GetAvatar()
		if not Avatar then
			return
		end

		local SetVisibilitySafe = function (Target,Type)
			if Target and Type then
				Target:SetVisibility(Type)
			end
		end

		self.TextBlock_TaskName:SetText(Title)
		local Animation = nil
		if self.Status then
			self.TextBlock_TaskContent:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
			self.TextBlock_TaskContent:SetText(Content)
			Animation = self.L2_To_A
		else
			self.TextBlock_TaskContent_3:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
			self.TextBlock_TaskContent_3:SetText(Content)
			Animation = self.L2_To_B
		end

		local UIManager = GWorld.GameInstance:GetGameUIManager()
		local BattleMainUI = UIManager:GetUIObj("BattleMain")
		if not BattleMainUI then
			return
		end
		if BattleMainUI.Pos_TaskBar:GetChildAt(0).Visibility == ESlateVisibility.Collapsed then
			BattleMainUI.Pos_TaskBar:GetChildAt(0):SetVisibility(ESlateVisibility.SelfHitTestInvisible)
		end

		local WidgetClassPath = UIConst.DUNGEONINDICATOR[WidgetType]
		if WidgetType == "Guide_Point" or WidgetType == "Evacuation" or WidgetType == "Annihilate_L" then --@lhq 20240126: CBT1临时处理
			WidgetClassPath = "/Game/UI/UI_PC/Common/Common_GuidePoint_PC.Common_GuidePoint_PC"
		end
		local WidgetClass = LoadClass(WidgetClassPath)
		local Widget = UE4.UWidgetBlueprintLibrary.Create(self, WidgetClass)

		local IsInEnterRouge = Avatar:IsInEnterRougeLike()
		local IsInRouge = Avatar:IsInRougeLike()
		if IsInRouge or IsInEnterRouge then
			self.Panel_Button:SetVisibility(ESlateVisibility.Collapsed)
			self.Button_Guide:SetVisibility(ESlateVisibility.Collapsed)
		else
			self.Panel_Button:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
			self.Button_Guide:SetVisibility(ESlateVisibility.Visible)
		end
		if Widget then
			self.Common_GuidePoint_PC:SetVisibility(ESlateVisibility.Collapsed)
			self.Guide_Icon:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
			self.Guide_Icon:ClearChildren()
			self.Guide_Icon:AddChildToOverlay(Widget)
			-- if Widget.Slot and (WidgetType == "Guide_Point" or WidgetType == "Evacuation" or WidgetType == "Annihilate_L") then
			-- 	Widget.Slot:SetAlignment(FVector2D(0.5, 0.5))
			-- end
			-- SetVisibilitySafe(Widget.Guide_Node,ESlateVisibility.SelfHitTestInvisible)
			-- local WidgetPanelName = "Panel_" .. WidgetType
			-- SetVisibilitySafe(Widget[WidgetPanelName],ESlateVisibility.SelfHitTestInvisible)
			-- SetVisibilitySafe(Widget.Annihilate_L_Arrows,ESlateVisibility.Collapsed)
			-- SetVisibilitySafe(Widget.Text_Distance,ESlateVisibility.Collapsed)
			-- SetVisibilitySafe(Widget.Common_Arrows,ESlateVisibility.Collapsed)
			-- if Widget.DisableTick then
			-- 	-- rawset(Widget, "UpdateIndicator", nil)
			-- 	Widget:DisableTick()
			-- end
			if WidgetType == "Guide_Point" and Widget.Img_GuidePoint_Icon then
				local Texture = LoadObject(TaskIconPath)
				Widget.Img_GuidePoint_Icon:SetBrushResourceObject(Texture)
			elseif (WidgetType == "Evacuation" or WidgetType == "Annihilate_L") and Widget.Img_GuidePoint_Icon then
				if WidgetType == "Evacuation" then
					TaskIconPath = "/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_Evacuation.T_Gp_Evacuation"
				elseif WidgetType == "Annihilate_L" then
					TaskIconPath = "/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_DefeatMission.T_Gp_DefeatMission"
				end
				local Texture = LoadObject(TaskIconPath)
				Widget.Img_GuidePoint_Icon:SetBrushResourceObject(Texture)
			end
		end
		self:PlayAnimation(Animation)
		self.Status = self.Status and false or true
	end
	self.TextBlock_TaskContent:SetText("")
	self.TextBlock_TaskContent_3:SetText("")
	self.TextBlock_TaskContent:SetVisibility(ESlateVisibility.Collapsed)
	self.TextBlock_TaskContent_3:SetVisibility(ESlateVisibility.Collapsed)
	AfterAnim() -- Tips: 原本切换任务靠L2_Out和L2_In，所以有下面这段逻辑，现在改成L2_To_A/B，靠上面的函数就足够
	
	-- if self.bFirstShow then
	-- 	AfterAnim()
	-- 	self.bFirstShow = false
	-- else
	-- 	local _, Proxy = UWidgetAnimationPlayCallbackProxy.CreatePlayAnimationProxyObject(nil, self, self.L2_Out, 0, 1, 0)
	-- 	Proxy.Finished:Add(self, AfterAnim)
	-- end
end

-------主线任务面板调用----------
function Battle_Combat_Mission_C:RefreshTaskInfo(TaskContentData, ContentStatus)
    self:SetTaskContentText(ContentStatus, TaskContentData.TaskDescribe)
	if self.Guide_Icon:GetChildrenCount() then
		self.Guide_Icon:ClearChildren()
	end
	self.Common_GuidePoint_PC:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
	self.Button_Guide:SetVisibility(ESlateVisibility.Collapsed)
	-- if WidgetType == "Guide_Point" and Widget.Img_GuidePoint_Icon then
	-- 	local Texture = LoadObject(TaskIconPath)
	-- 	Widget.Img_GuidePoint_Icon:SetBrushResourceObject(Texture)
	-- end
    self.TextBlock_TaskName:SetText(TaskContentData.TaskName)
    self.LevelGuidance:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.CurTaskPath = self:GetTypeImagePath(ContentStatus)
    if (self.CurTaskPath ~= nil) then
        local TaskGuidePanel = self[self.CurTaskPath]
        if (TaskGuidePanel ~= nil) then
            -- if (TaskGuidePanel.In ~= nil) then
            --     TaskGuidePanel:UnbindAllFromAnimationFinished(TaskGuidePanel.In)
            --     if (TaskGuidePanel.Loop ~= nil) then
            --         local function PlayAnimFinished(Obj)
            --             Obj:PlayAnimation(Obj.Loop, 0, 0)
            --         end
            --         TaskGuidePanel:BindToAnimationFinished(TaskGuidePanel.In, {TaskGuidePanel, PlayAnimFinished})
            --     end
            --     TaskGuidePanel:PlayAnimation(TaskGuidePanel.In)
            -- end
            -- TaskGuidePanel.Common_Arrows:SetVisibility(UE4.ESlateVisibility.Collapsed)
            -- TaskGuidePanel.Annihilate_L_Arrows:SetVisibility(UE4.ESlateVisibility.Collapsed)
            -- TaskGuidePanel.Text_Distance:SetVisibility(UE4.ESlateVisibility.Collapsed)
            TaskGuidePanel.Panel_Guide_Point:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            -- TaskGuidePanel.Guide_Node:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        end
    end
    if (TaskContentData.AnimAction and self[TaskContentData.AnimAction]) then
		if self:IsAnimationPlaying(self.L2_To_A) then
			self:StopAnimation(self.L2_To_A)
		end

		if self:IsAnimationPlaying(self.L2_To_B) then
			self:StopAnimation(self.L2_To_B)
		end

        self:PlayAnimation(self[TaskContentData.AnimAction])
    end
end

function Battle_Combat_Mission_C:PlayMissionStateChange()
	AudioManager(self):PlayUISound(self, "event:/ui/common/mission_state_change", nil, nil)
end

function Battle_Combat_Mission_C:PlayGetInAudio()
	AudioManager(self):PlayUISound(self, "event:/ui/common/mission_update", nil, nil)
end

function Battle_Combat_Mission_C:SetTaskContentText(Status, Text)
    if Status == nil then
        Status = true
    end
    if Status then
        self.TextBlock_TaskContent:SetText(Text)
        self.Panel_Mission01:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self.TextBlock_TaskContent_3:SetText(Text)
        self.Panel_Mission01_2:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
end

function Battle_Combat_Mission_C:GetTypeImagePath(Status)
    if Status == nil then
        Status = true
    end
    if Status == true then
        return "Common_GuidePoint_PC"
    else
        return "Common_GuidePoint_PC_1"
    end
end

function Battle_Combat_Mission_C:CheckOpacity(Status)
    if Status == nil then
        Status = true
    end
    if Status == true and self.Panel_Mission01:GetRenderOpacity() < 0.000001 then
        self.Panel_Mission01:SetRenderOpacity(1.0)
		self.TextBlock_TaskContent:SetRenderOpacity(1.0)
        self.Panel_Mission01_2:SetRenderOpacity(0)
		self.TextBlock_TaskContent_3:SetRenderOpacity(0)
    elseif Status == false and self.Panel_Mission01_2:GetRenderOpacity() < 0.000001 then
        self.Panel_Mission01:SetRenderOpacity(0)
		self.TextBlock_TaskContent:SetRenderOpacity(0)
        self.Panel_Mission01_2:SetRenderOpacity(1.0)
		self.TextBlock_TaskContent_3:SetRenderOpacity(1.0)
    end
end

function Battle_Combat_Mission_C:OnClickedBtnArea()
	local UIManager = GWorld.GameInstance:GetGameUIManager()
	local UI = UIManager:LoadUINew("TaskIndicator")
		if UI then
			UI.Guide_Icon_Guide_Point:PlayAnimation(UI.Guide_Icon_Guide_Point.Loop)
		end
end

function Battle_Combat_Mission_C:ResetTaskContent()
	local Text=self.TextBlock_TaskContent_3:GetText()
	self.TextBlock_TaskContent:SetText(Text)
end

function Battle_Combat_Mission_C:ResetPosition()
	self.Panel_Mission01:SetRenderTranslation(FVector2D(0,0))
	self.Panel_Mission01_2:SetRenderTranslation(FVector2D(-50,0))
end

function Battle_Combat_Mission_C:PlayFinishAnimWithComplete(IsComplete)
	self:ShowOrHideCompltetPanel(false)
	if IsComplete then
		self:ShowOrHideCompltetPanel(true)
		self:BindToAnimationFinished(self.Finsh_Out,function ()
			self:ShowOrHideCompltetPanel(false)
		end)
	end
	self:PlayAnimation(self.Finsh_Out)
	DebugPrint("LHQ_Battle_Combat_Mission_C:PlayFinishAnimWithComplete:Complete")
	AudioManager(self):PlayUISound(self, "event:/ui/common/mission_complete", nil, nil)
end


-------------------------------------------------------------------------

function Battle_Combat_Mission_C:ShowOrHideCompltetPanel(IsShow)
	if IsShow then
		self.Panel_Complete:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
		self.Panel_CompleteText:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
	else
		self.Panel_Complete:SetVisibility(UE4.ESlateVisibility.Collapsed)
		self.Panel_CompleteText:SetVisibility(UE4.ESlateVisibility.Collapsed)
	end
end

function Battle_Combat_Mission_C:ShowOrHideNewTaskPanel(IsShow)
	if IsShow then
		self.Panel_NewTask:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
	else
		self.Panel_NewTask:SetVisibility(UE4.ESlateVisibility.Collapsed)
	end
end

return Battle_Combat_Mission_C
