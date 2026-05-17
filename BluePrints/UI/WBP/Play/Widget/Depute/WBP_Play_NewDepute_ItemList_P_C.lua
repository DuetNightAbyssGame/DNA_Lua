--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR shilei
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Play_Depute_ItemList_P_C
local M = Class({ "BluePrints.UI.BP_UIState_C" })

--function M:Initialize(Initializer)
--end

function M:Construct()
    self.Super.Construct(self)
    self:AddInputMethodChangedListen()
    --self:InitGameInputMode()
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

-- function M:Destruct()
--     self.Super.Destruct(self)
--     self:RemoveInputMethodChangedListen()
-- end

function M:InitContent(Parent)
    self.List_Depute:ClearListItems()
    local DungeonData = CommonUtils.DeepCopy(DataMgr.SelectDungeon)
    table.sort(DungeonData, function(A, B)
        return A.Sequence < B.Sequence
    end)

    local loadedItemCount = 0 -- 计数器 判断List_Depute是否加载完成
    self.List_Depute:SetScrollbarVisibility(UIConst.VisibilityOp.Visible)
    for i = 1, #DungeonData, 1 do
        self:AddTimer(self.IntervalTime * (i), function()
            local Content = NewObject(self.LevelCellContentClass)
            Content.ChapterId = DungeonData[i].ChapterId
            Content.Parent = Parent
            self.List_Depute:AddItem(Content)

            -- 手机端，一直显示；PC端自动控制
            if CommonUtils.GetDeviceTypeByPlatformName() == "Mobile" then
                self.List_Depute:SetScrollbarVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
                self.List_Depute:SetControlScrollbarInside(false)
            else
                self.List_Depute:SetControlScrollbarInside(true)
            end

             -- 增加已加载项的计数
            loadedItemCount = loadedItemCount + 1

            if loadedItemCount > 0  then--#DungeonData
                self.List_Depute:NavigateToIndex(0)
            end
        end, false, 0, nil, true)
    end
end

-- function M:InitGameInputMode()
--     DebugPrint("InitGameInputMode  List_Depute")

--     local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
--     self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
--     if (IsValid(self.GameInputModeSubsystem)) then
--         self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
--         self.GameInputModeSubsystem.OnInputMethodChanged:Add(self,self.RefreshOpInfoByInputDevice)
--     end
-- end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
 if (CurInputDevice == ECommonInputType.Touch) then
        -- 触控模式即默认样式，不需要刷新
        return
    end
    --- 输入设备切换通知
    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    local ActiveWidgetIndex = IsUseKeyAndMouse and 0 or 1
    if (IsUseKeyAndMouse) then
        -- PC逻辑
        return
    else
        if self:HasFocusedDescendants() or self:HasAnyUserFocus() then
            self.List_Depute:NavigateToIndex(0)
        end
    end

    --self.Super.RefreshOpInfoByInputDevice(self, CurInputDevice, CurGamepadName)
end


return M
