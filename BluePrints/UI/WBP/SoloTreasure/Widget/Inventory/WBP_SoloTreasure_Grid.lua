
local InventoryCommonConst = require("BluePrints.UI.WBP.SoloTreasure.Widget.Inventory.InventoryCommonConst")
local InventoryController = require("BluePrints.UI.WBP.SoloTreasure.Widget.Inventory.InventoryController")

---@type WBP_SoloTreasure_BagItem01_C
local M = Class({
    "BluePrints.UI.BP_EMUserWidget_C",
    "BluePrints.Common.TimerMgr",
    "BluePrints.Common.DelayFrameComponent",
})
M._components = {
    "BluePrints.UI.WBP.SoloTreasure.Widget.Inventory.InventoryDragInputComponent",
}

function M:Construct()
    self.bNormal = true
end

function M:Destruct()

end

function M:Init(Params)
    local PocketData = Params.PocketData
    if not PocketData then return end
    local GridDatas = InventoryController.InventoryModel.Grids[PocketData.Name]
    if not GridDatas then return end
    local GridData = GridDatas[self.Position.X] and GridDatas[self.Position.X][self.Position.Y]
    if not GridData then return end
    GridData.Grid = self
    GridData.TreasureData = GridData.TreasureData or Params.TreasureData
    
    self.PocketData = PocketData
    self.Inventory = PocketData.Inventory or self.Inventory
    self.bRecycle = PocketData.bRecycle or false
end

function M:OnHovered()
    if self.PocketData == nil then return end
    local GridData = InventoryController:GetGridData(self.PocketData.Name, self.Position)
    local TreasureData = GridData and GridData.TreasureData or nil
    local TreasureItem = TreasureData and TreasureData.Treasure or nil
    if UIUtils.IsMobileInput() then return end
    InventoryController:RequestSelectedGrid(self)
    if InventoryController.bDraging or InventoryController.bOpenItemDetails then return end
    if IsValid(TreasureItem) then
        TreasureItem:OnHovered(self)
    end
end

function M:OnUnHovered()
    if self.PocketData == nil then return end
    local GridData = InventoryController:GetGridData(self.PocketData.Name, self.Position)
    local TreasureData = GridData and GridData.TreasureData or nil
    local TreasureItem = TreasureData and TreasureData.Treasure or nil
    if UIUtils.IsMobileInput() then return end
    InventoryController:RequestUnSelectedGrid(self)
    if IsValid(TreasureItem) then
        TreasureItem:OnUnHovered(self)
    end
end

function M:OnPressed()
    if not self.PocketData then return end
    local GridData = InventoryController:GetGridData(self.PocketData.Name, self.Position)
    local TreasureData = GridData and GridData.TreasureData or nil
    local TreasureItem = TreasureData and TreasureData.Treasure or nil
    local bMobile = CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile"
    if bMobile then return end
    if IsValid(TreasureItem) then
        TreasureItem:OnPressed()
    end
end

function M:OnClicked()
    if not self.PocketData then return end
    if UIUtils.IsMobileInput() then
        local key = ("DoubleClickTimer_" .. self:GetName())
        if self:IsExistTimer(key) then
            self:RemoveTimer(key)
            self._DoubleClickTimerKey = nil
            self:OnDoubleClicked()
            return
        end
        self._DoubleClickTimerKey = key
        local interval = 0.25
        self:AddTimer(interval, function(self)
            if self._DoubleClickTimerKey == key then
                self._DoubleClickTimerKey = nil
            end
        end, false, 0, key)
    end
    local GridData = InventoryController:GetGridData(self.PocketData.Name, self.Position)
    local TreasureData = GridData and GridData.TreasureData or nil
    local TreasureItem = TreasureData and TreasureData.Treasure or nil
    if IsValid(TreasureItem) and TreasureItem.bSearched then
        TreasureItem:OnClicked()
    end
end

function M:OnDoubleClicked()
    if not self.PocketData then return false end
    local GridData = InventoryController:GetGridData(self.PocketData.Name, self.Position)
    local TreasureData = GridData and GridData.TreasureData or nil
    local TreasureItem = TreasureData and TreasureData.Treasure or nil
    if not IsValid(TreasureItem) or not TreasureItem.bSearched then return false end
    local bSuccess = false
    bSuccess = InventoryController:QuickTransferFromGrid(GridData, InventoryCommonConst.QuickTransferType.RightClick)
    return bSuccess
end

function M:CustomOnPreviewMouseButtonDown(MyGeometry, MouseEvent)
    local MouseButton = UE4.UKismetInputLibrary.PointerEvent_GetEffectingButton(MouseEvent)
    if self.PocketData == nil then return false end
    local GridData = InventoryController:GetGridData(self.PocketData.Name, self.Position)
    local TreasureData = GridData and GridData.TreasureData or nil
    if MouseButton.KeyName == "LeftMouseButton" and TreasureData then
        self:OnPressed()
    end
    return false
end

function M:CustomOnMouseButtonUp(MyGeometry, MouseEvent)
    if not self.PocketData then return false end
    local MouseButton = UE4.UKismetInputLibrary.PointerEvent_GetEffectingButton(MouseEvent)
    if MouseButton.KeyName == "RightMouseButton" and not UIUtils.IsMobileInput() then
        local bSuccess = self:OnDoubleClicked()
        if bSuccess then
            return true
        end
    elseif MouseButton.KeyName == "LeftMouseButton" then
        if not InventoryController.bDraging then
            local bAltDown = UKismetInputLibrary.InputEvent_IsAltDown(MouseEvent)
            if bAltDown and not self.bRecycle then
                local GridData = InventoryController:GetGridData(self.PocketData.Name, self.Position)
                local TreasureData = GridData and GridData.TreasureData or nil
                local TreasureItem = TreasureData and TreasureData.Treasure or nil
                if not IsValid(TreasureItem) or not TreasureItem.bSearched then return false end
                return InventoryController:QuickTransferFromGrid(GridData, InventoryCommonConst.QuickTransferType.AltAndLeftClick)
            else
                self:OnClicked()
            end
            return true
        end
    end
    return false
end

function M:CustomOnMouseEnter(MyGeometry, MouseEvent)
    self:OnHovered()
end

function M:CustomOnMouseLeave(MouseEvent)
    self:OnUnHovered()
end

function M:CustomOnMouseMove(MyGeometry, MouseEvent)
    return false
end


function M:CustomOnDragDetected()
    InventoryController.bDetectDrag = false
    InventoryController.StartDetectDragPos = nil
    InventoryController.StartDetectDragGrid = nil
    local GridData = InventoryController:GetGridData(self.PocketData.Name, self.Position)
    local TreasureData = GridData and GridData.TreasureData or nil
    local TreasureItem = TreasureData and TreasureData.Treasure or nil
    if not IsValid(TreasureItem) or not TreasureItem.bSearched then return end
    local Operation = NewObject(UIUtils.GetCommonDragDropOperationClass())
    Operation.Payload = self
    if not IsValid(TreasureItem.TreasureData.DefaultDragVisual) then
        TreasureItem:CreateDragWidget(TreasureItem.TreasureData)
    end
    Operation.DefaultDragVisual = TreasureItem.TreasureData.DefaultDragVisual
    if(not Operation.DefaultDragVisual)then
        return nil
    end
    InventoryController:CustomOnDragDetected(GridData, Operation)
end

function M:CustomOnDragEnter(MyGeometry, PointerEvent)
    if not self.PocketData then return false end
    local GridData = InventoryController:GetGridData(self.PocketData.Name, self.Position)
    InventoryController:CustomOnDragEnter(GridData, MyGeometry, PointerEvent)
end

function M:CustomOnDragLeave(PointerEvent)
    if not self.PocketData then return false end
    local GridData = InventoryController:GetGridData(self.PocketData.Name, self.Position)
    InventoryController:CustomOnDragLeave(GridData, PointerEvent)
    self.Quadrant = nil
end

function M:CustomOnDragOver(MyGeometry, PointerEvent)
    if not self.PocketData then return false end
    local ScreenPos = UE4.UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(PointerEvent)
    local LocalPos = UE4.USlateBlueprintLibrary.AbsoluteToLocal(MyGeometry, ScreenPos)
    local Size = UE4.USlateBlueprintLibrary.GetLocalSize(MyGeometry)
    local Center = FVector2D(Size.X / 2, Size.Y / 2)
    local RelX = LocalPos.X - Center.X
    local RelY = LocalPos.Y - Center.Y
    local NewQuadrant = nil
    if RelX >= 0 then
        if RelY >= 0 then
            NewQuadrant = 4
        else
            NewQuadrant = 1
        end
    else
        if RelY >= 0 then
            NewQuadrant = 3
        else
            NewQuadrant = 2
        end
    end
    self.CursorPosition = FVector2D(self.Position.X + RelX, self.Position.Y + RelY)
    if self.Quadrant ~= NewQuadrant then
        self.Quadrant = NewQuadrant
        local GridData = InventoryController:GetGridData(self.PocketData.Name, self.Position)
        InventoryController:CustomOnDragEnter(GridData, MyGeometry, PointerEvent)
    end
end

function M:CustomOnDrop(MyGeometry, PointerEvent, Operation)
    if not self.PocketData then return false end
    if self.bRecycle then return false end
    local GridData = InventoryController:GetGridData(self.PocketData.Name, self.Position)
    local bDropSuccess = InventoryController:CustomOnDrop(GridData)
    self:OnHovered()
    return bDropSuccess
end

---@param UpdateParams table
function M:UpdateView(UpdateParams)
    local bCanMove = UpdateParams.bCanMove
    local bReset = UpdateParams.bReset
    if bReset and not self.bNormal then
        self.bNormal = true
        self.bAble = false
        self.bDisable = false
        self:AddDelayFrameFunc(function()
            if not self or not self.bNormal or not self.MaskWidget or not self.MaskWidget.Normal then return end
            self.MaskWidget:StopAllAnimations()
            self.MaskWidget:PlayAnimation(self.MaskWidget.Normal)
        end, 2)
    elseif bCanMove and not self.bAble then
        self.bAble = true
        self.bNormal = false
        self.bDisable = false
        self:AddDelayFrameFunc(function()
            if not self or not self.bAble or not self.MaskWidget or not self.MaskWidget.Able then return end
            self.MaskWidget:StopAllAnimations()
            self.MaskWidget:PlayAnimation(self.MaskWidget.Able)
        end, 2)
    elseif not bCanMove and not self.bDisable then
        self.bDisable = true
        self.bNormal = false
        self.bAble = false
        self:AddDelayFrameFunc(function()
            if not self or not self.bDisable or not self.MaskWidget or not self.MaskWidget.DiaAble then return end
            self.MaskWidget:StopAllAnimations()
            self.MaskWidget:PlayAnimation(self.MaskWidget.DiaAble)
        end, 2)
    end
end

AssembleComponents(M)
return M
