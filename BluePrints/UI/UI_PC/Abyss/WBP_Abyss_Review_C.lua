--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Abyss_Review_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.ListKeyToWidget = {
        CharId = "Character",
        MeleeWeaponId = "Melee",
        RangedWeaponId = "Range",
        PetId = "Pet",
        PhantomId1 = "Phantom01",
        PhantomWeaponId1 = "Phantom_Weapon01",
        PhantomId2 = "Phantom02",
        PhantomWeaponId2 = "Phantom_Weapon02",
    }
end

function M:InitUIInfo(Name, bInUIMode, EventList, ...)
    M.Super.InitUIInfo(self, Name, bInUIMode, EventList,...)
    self:SetFocus()
    self:InitAbyssInfo(...)
    self:InitButtons()
    AudioManager(self):PlayUISound(self, "event:/ui/common/season_review", nil, nil)
    -------------- 手柄端 --------------------
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        self:InitGamepadView()
    else
        self:InitKeyboardView()
    end
end

function M:InitAbyssInfo(...)
    local Params = ...
    self.LastFocus = Params.LastFocus
    ----- 固定文本 -----
    self.Text_Title:SetText(GText("Abyss_SeasonReview"))
    self.Text_Title_VX :SetText(GText("Abyss_SeasonReview"))
    self.Text_StarTitle:SetText(GText("Abyss_SeasonReview_RewardProgress"))
    self.Text_TeamTitle:SetText(GText("Abyss_SeasonReview_BestParty"))
    self.Text_FloorTitle:SetText(GText("Abyss_SeasonReview_BestLevel"))
    self.Text_Tip:SetText(GText("Abyss_SeasonReview_Tips1"))
    ----- 不固定内容 -----
    local Avatar = GWorld:GetAvatar()
    self.SeasonId = Params.SeasonId
    self.AbyssId = Params.AbyssId
    local StartTime = DataMgr.AbyssSeasonList[self.SeasonId].AbyssStartTime
    local EndTime = DataMgr.AbyssSeasonList[self.SeasonId].AbyssEndTime
    -- 时间
    self.Time01:SetTimeText(StartTime, UIConst.EnumTimeStyleType.YMD)
    self.Time02:SetTimeText(EndTime, UIConst.EnumTimeStyleType.YMD)
    local SeasonName = DataMgr.AbyssSeasonList[self.SeasonId].AbyssSeasonName
    self.Text_Season:SetText(GText(SeasonName))
    -- 上赛季星星数量
    local RotateAbyss = DataMgr.AbyssSeasonList[self.SeasonId].Abyss.Rotate
    local InfiniteAbyss = DataMgr.AbyssSeasonList[self.SeasonId].Abyss.Infinite
    local StarNum = Avatar.Abysses[RotateAbyss]:GetAllPassRoomCount() + Avatar.Abysses[InfiniteAbyss]:GetAllPassRoomCount()
    self.Text_Star:SetText(StarNum)

    -- 最高通关层数
    local MaxLevel = Avatar.Abysses[self.AbyssId].MaxAbyssProgress[1]
    local MaxLevelText = string.format(GText("Abyss_LevelName"), MaxLevel)
    local AbyssName = GText(DataMgr.AbyssSeason[self.AbyssId].AbyssIdName)
    self.Text_Floor:SetText(AbyssName .. "/" .. MaxLevelText)

    -- 上赛季最佳阵容 + 幕间名字
    self.Team01.Text_Name:SetText(GText("Abyss_DungeonA"))
    self.Team02.Text_Name:SetText(GText("Abyss_DungeonB"))
    local FastestTeamList = Avatar.Abysses[self.AbyssId].FastestTeamList
    for i = 1,2 do
        if not FastestTeamList[i] then
            self["Team0" .. i]:SetVisibility(UIConst.VisibilityOp.Collapsed)
            goto continue
        end
        local TeamData = FastestTeamList[i].UnitIdList
        for Id, Widget in pairs(self.ListKeyToWidget) do
            if not TeamData[Id] or TeamData[Id] == -1 then
                self["Team0" .. i][Widget]:SetVisibility(UIConst.VisibilityOp.Collapsed)
            else
                local Icon
                if string.match(Id, "Char") or string.match(Id, "PhantomId") then
                    Icon = DataMgr.Char[TeamData[Id]].Icon
                elseif string.match(Id, "Weapon") then
                    Icon = DataMgr.Weapon[TeamData[Id]].Icon
                elseif string.match(Id, "Pet") then
                    Icon = DataMgr.Pet[TeamData[Id]].Icon
                end
                self["Team0" .. i][Widget]:SetIcon(Icon)
                self["Team0" .. i][Widget].Icon_Empty:SetVisibility(UIConst.VisibilityOp.Collapsed)
                self["Team0" .. i][Widget].Icon_Item:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
                self["Team0" .. i][Widget]:UnBindButtonPerformances()
            end
        end
        ::continue::
    end
end

function M:InitButtons()
    self.Btn_Close:Init("Close", self, self.Close)
    self.Key_Back:CreateCommonKey(
        {
            KeyInfoList = {
                {
                    Type = "Img",
                    ImgShortPath = "B"
                }
            },
            Desc = GText("UI_BACK")
        }
    )
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if InKeyName == Const.GamepadFaceButtonRight then
        self:Close()
    end
    return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:InitGamepadView()
    self:SetFocus()
    self.WBox_Controller:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Btn_Close:SetVisibility(ESlateVisibility.Collapsed)
end

function M:InitKeyboardView()
    self.WBox_Controller:SetVisibility(ESlateVisibility.Collapsed)
    self.Btn_Close:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
    self.Super.OnUpdateUIStyleByInputTypeChange(self, CurInputType, CurGamepadName)
    if self.CurInputType ~= CurInputType then
        if CurInputType == ECommonInputType.Gamepad then
            self:InitGamepadView()
        else
            self:InitKeyboardView()
        end
    end
    self.CurInputType = CurInputType
end

function M:Close()
    if self.LastFocus then
        self.LastFocus:SetFocus()
    end
    M.Super.Close(self)
end


return M
