--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local NumberModel = require "BluePrints.UI.UI_PC.Archive.WBP_Archive_Number_Model"

---@type WBP_Archive_EntryChar_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

--function M:Initialize(Initializer)
--end

function M:Destruct()
    if self.NodeName then
        ReddotManager.RemoveListener(self.NodeName,self)
    end
end

function M:Construct()
    self.New:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function M:Init(Name, Type)
    self.Name = Name
    self.Type = Type
    self.MajorType = DataMgr.ArchiveInfo[self.Type].MajorType
    self.Text_Title:SetText(GText(DataMgr.ArchiveInfo[self.Type].ArchiveTitle))
    if self.Text_NamePlate then
        self.Text_NamePlate:SetText(GText("UI_Archive_Special"))
    end
    self.Btn_Click.OnClicked:Add(self, self.OnCellClicked)
    self.Name2SystemUIName = {
        Character = "ArchivePageChar",
        Ranged = "ArchivePageChar",
        Melee = "ArchivePageChar",
        Resource = "ArchivePageItem",
        Read = "ArchivePageItem",
        Enemy = "ArchivePageItem"
    }
    self:RefreshInfo()

    self.NodeName = nil
    if self.Type == 1001 then
        self.NodeName = DataMgr.ReddotNode.ArchiveNewChar.Name
    elseif self.Type == 1002 then
        self.NodeName = DataMgr.ReddotNode.ArchiveNewMelee.Name
    elseif self.Type == 1003 then
        self.NodeName = DataMgr.ReddotNode.ArchiveNewRanged.Name
    elseif self.Type == 1004 then
        self.NodeName = DataMgr.ReddotNode.ArchiveNewResource.Name
    elseif self.Type == 1005 then
        self.NodeName = DataMgr.ReddotNode.ArchiveNewReadBook.Name
    elseif self.Type == 1006 then
        self.NodeName = DataMgr.ReddotNode.ArchiveNewMonster.Name
    end
    if self.NodeName then
        if not ReddotManager.GetTreeNode(self.NodeName) then
            ReddotManager.AddNode(self.NodeName)
        end
        ReddotManager.AddListener(self.NodeName,self,self.RefreshReddot)
    end
end

function M:RefreshInfo()
    local CurrentNumber = NumberModel:GetCurrentNumber(self.Type)
    local SumNumber = NumberModel["Get"..self.Name.."SumNumber"](NumberModel)
    if CurrentNumber > SumNumber then
        CurrentNumber = SumNumber
    end
    self.Num_Now:SetText(CurrentNumber)
    self.Num_Total:SetText(SumNumber)
end

function M:HideHover()
    self:StopAnimation(self.Hover)
    self:PlayAnimation(self.UnHover)
    --UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self["Panel_Area"..string.format("%02d", i)]):SetZOrder(0)
end

function M:OnHoveredEntry()
	AudioManager(self):PlayUISound(self, "event:/ui/common/hover_btn_pic_large", nil, nil)
    self:StopAnimation(self.Normal)
    self:PlayAnimation(self.Hover)
    --UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self["Panel_Area"..string.format("%02d", self.SelectBtnIdx)]):SetZOrder(1)
end

function M:OnCellClicked()
	AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_pic_large", nil, nil)
    UIManager(self):LoadUINew(self.Name2SystemUIName[self.Name], self.Name, self.Type)
end

function M:RefreshReddot()
    local Node = ReddotManager.GetTreeNode(self.NodeName)
    if Node.Count > 0 then
        self.New:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
        self.New:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

return M
