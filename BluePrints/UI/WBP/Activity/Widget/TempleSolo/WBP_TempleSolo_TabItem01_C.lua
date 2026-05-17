--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_Temple_Solo_Tab01_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self:BindButtonPerformances()

    self.New:SetVisibility(UE4.ESlateVisibility.Collapsed)
    if not self.ListenerAdded then
        self.ListenerAdded = true
        if not ReddotManager.GetTreeNode("TempleSoloNewLevel") then
            ReddotManager.AddNodeEx("TempleSoloNewLevel")
        end
        ReddotManager.AddListenerEx("TempleSoloNewLevel",self,self.UpdateReddot)
    end
end

function M:Destruct()
    self:UnbindButtonPerformances()
    ReddotManager.RemoveListener("TempleSoloNewLevel",self)
end

function M:BindButtonPerformances()
    self.Btn_Click.OnClicked:Add(self, self.OnButtonClicked)
end

function M:UnbindButtonPerformances()
    self.Btn_Click.OnClicked:Clear()
end

function M:OnListItemObjectSet(Content)
    self:Init(Content)
end

function M:Init(Content)
    self.Content = Content
    self.Parent = Content.Parent
    self.TempleTypeId = Content.TempleTypeId
    self.EventId = Content.EventId
    self.TempleTypeName = Content.TempleTypeName
    self.GUIPath = Content.GUIPath

    self.Text_Type:SetText(GText(Content.TempleTypeName))
    self.Text_Normal:SetText(Content.NormalStar.."/"..Content.MaxNormalStar)
    self.Text_Challenge:SetText(Content.HardStar.."/"..Content.MaxHardStar)
    local IconImage = LoadObject(self.GUIPath)
    
    self.Icon_Type:SetBrushResourceObject(IconImage)

    self.TEMPLE_TYPE_COLOR = {
        [1080011] = "Red",
        [1080012] = "Blue",
        [1080013] = "Yellow",
    }

    if Content.DelaySelected then
        self:SetSelected(true)
    end
    self:UpdateReddot()
    -- self:SetTextColor()
end

function M:OnButtonClicked()
    self.Parent:OnTabItemClicked(self.Content)
end

function M:OnMouseEnter(MyGeometry, MouseEvent)
    if not self.IsSelected then
        self:PlayAnimation(self.Hover)
        self.IsHoverState = true
    end
end

function M:OnMouseLeave(MouseEvent)
    if not self.IsSelected and self.IsHoverState then
        self:PlayAnimation(self.UnHover)
        self.IsHoverState = false
    end
end

function M:SetSelected(bIsSelected)
    if bIsSelected then
        self.IsSelected = true
        local Anim = "Click_"..self.TEMPLE_TYPE_COLOR[self.TempleTypeId]
        local Color = self.TEMPLE_TYPE_COLOR[self.TempleTypeId]
        self.CanvasPanel_0:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self:PlayAnimation(self[Anim])
        self.Parent:SetBGColor(Color)
    else
        self.IsSelected = false
        -- self:PlayAnimation(self.Received)
        self.CanvasPanel_0:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self:AddTimer(0.05, function()
            self:PlayAnimation(self.Received)
        end)
    end
end

function M:SetTextColor()
    local Color = self.TEMPLE_TYPE_COLOR[self.TempleTypeId]

    self.Icon_Type:SetColorAndOpacity(Color)
    self.Text_Type:SetColorAndOpacity(Color)
    self.Text_Normal:SetColorAndOpacity(Color)
    self.Text_Challenge:SetColorAndOpacity(Color)
end

function M:UpdateReddot()
    if not ReddotManager.GetTreeNode("TempleSoloNewLevel") then
        ReddotManager.AddNodeEx("TempleSoloNewLevel")
    end
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("TempleSoloNewLevel")
    local TempleEventInfo = DataMgr.TempleEventLevel
    for DungeonId, Info in pairs(TempleEventInfo) do
        if Info.TempleTypeId == self.TempleTypeId then
            if CacheDetail[DungeonId] and CacheDetail[DungeonId] == 1 then
                self.New:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
                return
            end
        end
    end
    self.New:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

return M
