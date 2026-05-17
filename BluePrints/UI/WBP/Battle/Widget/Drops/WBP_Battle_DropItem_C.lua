--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR zhangdongxu
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Battle_DropItem_C
local M = Class({"BluePrints.Common.TimerMgr", "BluePrints.UI.BP_EMUserWidget_C"})

--function M:Initialize(Initializer)
--end

function M:Construct()
    if self.bShowing then
        return
    end
    self:CleanUp()
end

function M:Destruct()
    self:StopAllAnimations()
    self:CleanTimer()
    self:CleanUp()
end

function M:CleanUp()
    self.ItemId = nil
	self.ItemCount = nil
    self.Duration = -1
    self.bShowing = false
    -- self:SetVisibility(ESlateVisibility.Collapsed)
	self:StopListeningForAllInputActions()
    if self.Parent and self.Parent.ListView_Box then
        self.Parent.ListView_Box:RemoveItem(self.Content)
        self.Parent.ListView_Box:RequestRefresh()
    else
        DebugPrint("ZDX_掉落物UI未销毁成功")
    end
end

function M:OnListItemObjectSet(Content)
    self:SetVisibility(ESlateVisibility.Collapsed)
    self.Content = Content
    self.ItemId = Content.ItemId
    self.ItemCount = Content.ItemCount
    self.Duration = Content.Duration
    self.TableName = Content.TableName
    self.Content.SelfWidget = self
    self.Parent = self.Content.Parent
    self.Content.Parent.UsingItemList[self.Content] = 1
    self.Slot = UE4.UWidgetLayoutLibrary.SlotAsOverlaySlot(self.SizeBox_0)
    self.Slot:SetPadding(FMargin(0))
    self:UpdateTips(self.ItemId, self.ItemCount, self.Duration, self.TableName)
end

function M:UpdateTips(ItemId, ItemCount, Duration, TableName)
    self.bShowing = true
    self.OrdinaryMoveTime = -1
    -- local Padding = FMargin(0)
    -- self.Slot:SetPadding(Padding)
    -- self:SetVisibility(ESlateVisibility.SelfHitTestInvisible)

    if not Duration then
        Duration = 2.5
    end
    if not ItemCount then
        ItemCount = 1
    end
    self.bNotCallAnimationDel = true
    self:StopAllAnimations()
    self.bNotCallAnimationDel = false
    local ItemInfo = DataMgr[TableName][ItemId]
    assert(ItemInfo, "掉落物不存在："..TableName..ItemId)
    self.ICON:SetVisibility(ESlateVisibility.Collapsed)
    local DisName = ItemUtils:GetDropName(ItemId,TableName) .. string.format(" ×%d", ItemCount)
    self.Text_Reward:SetText(DisName)

    local ImagePath = ItemInfo.Icon
    if string.find(ImagePath, "/Game/") == nil then
        ImagePath = '/Game/'..ImagePath
    end

    self.CurrentIconPath = ImagePath
    self.LoadResourceID=nil
    local Handle = UE.UResourceLibrary.LoadObjectAsyncWithId(self,ImagePath,{self,M.OnIconLoadFinish})
    if Handle then
        self.LoadResourceID=Handle.ResourceID
    end
    -- UE.UResourceLibrary.LoadObjectAsync(self,ImagePath,{self,self.OnIconLoadFinish})


    self.Duration = Duration
    -- self:PlayAnimation(self["in"])
    -- AudioManager(self):PlayItemSound(self, self.ItemId,"Pick",self.TableName)
    -- self:AddTimer(self.Duration + 1, function()
    --     self:PlayOutAnimation()
    -- end, false, 0, "CloseSelf", true)
end

function M:AddItemCount(AddItemCount, Duration)
    if not Duration then
        Duration = 2.5
    end
    if not AddItemCount then
        AddItemCount = 1
    end
    self.Content.ItemCount = self.Content.ItemCount + AddItemCount
    local DisName = ItemUtils:GetDropName(self.Content.ItemId,self.Content.TableName) .. string.format(" ×%d", self.Content.ItemCount)
    self.Text_Reward:SetText(DisName)
    self.Content.Duration = Duration
    self:AddTimer(self.Content.Duration, function()
        self:PlayOutAnimation()
    end, false, 0, "PlayOutAnim", true)
end

function M:OnIconLoadFinish(Object, ResourceID)
    if not Object or not IsValid(self) or self.LoadResourceID~=ResourceID then-- 限制前后缀
        DebugPrint("ZDX_掉落物UIIcon加载失败")
        self:CloseSelf()
        return
    end

    if self.ICON then
        self.ICON:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.ICON:SetBrushResourceObject(Object)
        self:PlayAnimation(self["in"])
        AudioManager(self):PlayItemSound(self, self.ItemId,"Pick",self.TableName)
        -- self:AddTimer(self.Duration + 1, function()
        --     self:PlayOutAnimation()
        -- end, false, 0, "PlayOutAnim", true)
    end
end

function M:PlayOutAnimation()
    self:PlayAnimation(self.out, 0, 1, 0, 1, true)
    self.OrdinaryMoveTime = 0
    self:AddTimer(0.23, function ()
        self.OrdinaryMoveTime = -1
        self:CloseSelf()
    end, false, 0, "CloseSelf", true)
end


function M:OnAnimationFinished(InAnimation)
    if self.bNotCallAnimationDel then
        return
    end
    if InAnimation == self["in"] then
        self:AddTimer(self.Duration, function()
            self:PlayOutAnimation()
        end, false, 0, "PlayOutAnim", true)
    -- elseif InAnimation == self.out then
    --     self.OrdinaryMoveTime = -1
    --     self:CloseSelf()
    end
end

function M:CloseSelf()
    self:CleanUp()

    local BattleMain = UIManager(self):GetUIObj("BattleMain")
    local DropItemsUI
    if BattleMain and BattleMain.Pos_Drops then
        DropItemsUI = BattleMain.Pos_Drops:GetChildAt(0)
    end
    if DropItemsUI and DropItemsUI.OnTipsItemClose then
        DropItemsUI:OnTipsItemClose(self.Content)
    end
end
return M
