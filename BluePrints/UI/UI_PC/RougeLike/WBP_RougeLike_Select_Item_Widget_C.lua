
local WBP_RougeLike_Select_Item_Widget_C = Class("BluePrints.UI.BP_UIState_C")

function WBP_RougeLike_Select_Item_Widget_C:Construct()
	self.BtnCD = 0.5 -- 发送rpc操作的内置CD
end


--Overriden
function WBP_RougeLike_Select_Item_Widget_C:OnLoaded()
	-- assert(Type == "Blessing" or Type == "Treasure", string.format("RougeLike_Select_Item_Widget传入的Type:【%s】不是有效的Type", tostring(Type)))
	self.Btn_Select:BindEventOnClicked(self, self.OnBtn_SelectClicked)
end

--Overriden
function WBP_RougeLike_Select_Item_Widget_C:SetInfo(Parent, InfoId, InfoData, AwardType)
	self.Parent = Parent
	self.InfoId = InfoId
	local Name = InfoData.Name
	self.Text_Name:SetText(GText(Name))

	local Desc = InfoData.Desc
	self.Text_Describe:SetText(GText(Desc))
	self.AwardType = AwardType
	
	self.Btn_Select:SetText(GText("UI_CONFIRM_SELECTION"))
	self.StartTime = UE4.UGameplayStatics.GetRealTimeSeconds(self)
end

function WBP_RougeLike_Select_Item_Widget_C:OnBtn_SelectClicked()
	self.CurrentTime = UE4.UGameplayStatics.GetRealTimeSeconds(self)
	DebugPrint("检测到按键按下")
	if(self.CurrentTime - self.StartTime < self.BtnCD) then
		return 
	end
	self.StartTime = UE4.UGameplayStatics.GetRealTimeSeconds(self)
	self.Parent:ChooseItem(self.InfoId, self)
end

-- Overridden
function WBP_RougeLike_Select_Item_Widget_C:Close()
	self.Super.Close(self)
end

return WBP_RougeLike_Select_Item_Widget_C