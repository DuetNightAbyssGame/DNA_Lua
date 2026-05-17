--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Build_Armory_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function M:InitItemContent(SquadInfo, Parent)
    self.SquadInfo = SquadInfo
    self.Parent = Parent
    self.IsSelected = false
    self:PlayAnimation(self.Normal)
    -- 设置空图标
    local function SetEmptyIcon(Widget, EmptyMethod, Type)
        if Widget and Widget[EmptyMethod] then
            Widget[EmptyMethod](Widget, nil, Type)
        end
    end

    -- 设置图标
    local function SetIcon(Widget, Info)
        if not Widget or not Info then return end

        local DataEntry = Info.DataTable and Info.DataTable[Info.Id]
        if Info.Id and DataEntry then
            local IconPath = DataEntry.Icon

            -- 处理 MiniIcon头像
            if Info.IsMiniIcon then
                local MiniIconPath = "/Game/UI/Texture/Dynamic/Image/Head/Mini/"
                local PhantomGuideIconImg = DataMgr.BattleChar[Info.Id].GuideIconImg
                local NormalIconName = "T_Normal_" .. PhantomGuideIconImg
                IconPath = MiniIconPath .. NormalIconName .. "." .. NormalIconName
            end
            Widget[Info.SetMethod](Widget, IconPath, Info.Level)
        else
            SetEmptyIcon(Widget, Info.EmptyMethod, Info.Type)
        end
    end

    -- 统一处理图标
    local SquadIcons = {
        { Widget = self.Character, DataTable = DataMgr.Char,   Id = self.SquadInfo.CharId,           SetMethod = "SetCharIcon",   EmptyMethod = "SetEmptyIcon",    Level = self.SquadInfo.CharLevel },
        { Widget = self.Melee,     DataTable = DataMgr.Weapon, Id = self.SquadInfo.MeleeWeaponId,    SetMethod = "SetWeaponIcon", EmptyMethod = "SetEmptyIcon",    Level = self.SquadInfo.MeleeWeaponLevel },
        { Widget = self.Range,     DataTable = DataMgr.Weapon, Id = self.SquadInfo.RangedWeaponId,   SetMethod = "SetWeaponIcon", EmptyMethod = "SetEmptyIcon",    Level = self.SquadInfo.RangedWeaponLevel },
        { Widget = self.Pet,       DataTable = DataMgr.Pet,    Id = self.SquadInfo.PetId,            SetMethod = "SetPetIcon",    EmptyMethod = "SetEmptyPetIcon", Level = self.SquadInfo.PetLevel },
    }

    for _, Info in ipairs(SquadIcons) do
        SetIcon(Info.Widget, Info)
    end

    -- 轮盘图标设置
    if self.SquadInfo.WheelIndex then
        self.Roulette:SetWheelIcon(nil, self.SquadInfo.WheelIndex)
    else
        self.Roulette:SetWheelIcon(nil, 1)
    end

    self.IsComMissing = not self.SquadInfo.CharId
        or not self.SquadInfo.MeleeWeaponId
        or not self.SquadInfo.RangedWeaponId

    -- if self.Parent.CurrentSquad == 0 then
    --     self:UpSelected()
    -- end
end

-- function M:OnMouseButtonDown(MyGeometry, MouseEvent)
--     AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_large", nil, nil)
--     self:PlayAnimation(self.Click)
--     self.IsSelected = true
--     self.Parent:UpdatKeyDisplay("Selected")
--     self.Parent:UpdateCurrentDungeonSquad(0)
--     return UWidgetBlueprintLibrary.Unhandled()
--     --return UE4.UWidgetBlueprintLibrary.Handled()
-- end
function M:OnTouchEnded(MyGeometry, InTouchEvent)
    return self:OnMouseButtonUp(MyGeometry, InTouchEvent)
end

function M:OnMouseButtonDown(MyGeometry, MouseEvent)

    if  not self.IsSelected then
        self:PlayAnimation(self.Press)
    end
    return UWidgetBlueprintLibrary.Unhandled()
    --return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:UpSelected()
    self.IsSelected = true
    self.Parent:UpdatKeyDisplay("Selected")
    --self.Parent:UpdateCurrentDungeonSquad(0)
    self:OnMouseEnter()
    self:StopAllAnimations()
    self:PlayAnimation(self.Click)
end

function M:OnMouseButtonUp(MyGeometry, MouseEvent)

    if self.IsSelected then return end
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_large", nil, nil)
    self:PlayAnimation(self.Click)
    self.IsSelected = true
    self.Parent:UpdatKeyDisplay("Selected")
    self.Parent:UpdateCurrentDungeonSquad(0)
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, "UI_Squad_ChangeSuccess_Tips")
    return UWidgetBlueprintLibrary.Unhandled()
end

function M:OnMouseEnter(MyGeometry, MouseEvent)
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        if  self.IsSelected then
            self.Parent:UpdatKeyDisplay("Selected")
        else
            self.Parent:UpdatKeyDisplay("NotSelected")
        end
    end
    if self.IsSelected then return end
    self:PlayAnimation(self.Hover)
end

function M:OnMouseLeave(MyGeometry, MouseEvent)
    -- if (UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad) then
    --     return
    -- end
    --self:StopAllAnimations()
    if not self.IsSelected then
        self:PlayAnimation(self.Unhover)
    end
end

-- function M:OnFocusReceived(MyGeometry, InFocusEvent)

--     return UE4.UWidgetBlueprintLibrary.Unhandled()
-- end


return M
