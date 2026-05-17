-- --
-- -- DESCRIPTION
-- --
-- -- @COMPANY **
-- -- @AUTHOR zhangdongxu
-- -- @DATE ${date} ${time}
-- --
-- require "UnLua"

-- ---@type WBP_Play_Depute_RightItem_C
-- local M = Class("BluePrints.UI.BP_UIState_C")

-- function M:Construct()
--     self.Super.Construct(self)
--     --- 按钮绑定事件
--     self.Button_LeftClick.OnClicked:Add(self, self.OnClicked)
--     self.Button_RightClick.OnClicked:Add(self, self.OnClicked)

--     self.Button_LeftClick.OnPressed:Add(self, self.OnPressed)
--     self.Button_LeftClick.OnReleased:Add(self, self.OnReleased)
--     self.Button_LeftClick.OnHovered:Add(self, self.OnHovered)
--     self.Button_LeftClick.OnUnhovered:Add(self, self.OnUnhovered)

--     self.Button_RightClick.OnPressed:Add(self, self.OnPressed)
--     self.Button_RightClick.OnReleased:Add(self, self.OnReleased)
--     self.Button_RightClick.OnHovered:Add(self, self.OnHovered)
--     self.Button_RightClick.OnUnhovered:Add(self, self.OnUnhovered)

--     --- TextMap配置
--     self.Text_GetTask:SetText(GText("UI_DUNGEON_Enter"))
--     self.Text_GetTaskLock:SetText(GText("UI_DUNGEON_Locked"))
--     self.Text_RewardTitle:SetText(GText("UI_DUNGEON_ObtainType"))
-- end

-- --- 初始化关卡子Item信息
-- ---@param ChapterId number 委托Id
-- function M:InitItemContent(ChapterId, Parent)
--     local ChapterData = DataMgr.SelectDungeon[ChapterId]
--     if not ChapterData then
--         DebugPrint("ZDX_找不到关卡数据:", ChapterId)
--         return
--     end
--     self.ChapterId = ChapterId
--     self.Parent = Parent
--     --- 加载关卡图片
--     local ChapterIcon = LoadObject(ChapterData.Path)
--     local Material = self.Image_ItemIcon:GetDynamicMaterial()
--     if Material then
--         Material:SetTextureParameterValue("IconMap", ChapterIcon)
--     end
--     --- 加载关卡名称
--     self.Text_PlayName:SetText(GText(ChapterData.ChapterName))
--     --- 加载奖励信息
--     local RewardIcon = LoadObject(ChapterData.Icon)
--     self.Image_Icon:SetBrushResourceObject(RewardIcon)
--     self.Text_RewardItem:SetText(GText(ChapterData.ChapterSubName))

--     --- 加载关卡描述
--     self.Text_PlayDesc:SetText(GText(ChapterData.ChapterContent))

--     --- 判断是否解锁
--     self:PlayAnimation(self.In)
--     if PageJumpUtils:CheckDungeonCondition(ChapterData.Condition) then
--         self.IsUnLocked = false
--         self:PlayAnimation(self.Normal)
--         self.Group_Lock:SetVisibility(ESlateVisibility.Collapsed)
--     else
--         self.IsUnLocked = true
--         self:PlayAnimation(self.Forbidden)
--         self.Group_Lock:SetVisibility(ESlateVisibility.Visible)
--     end
-- end


-- function M:OnClicked()
--     if self:IsAnimationPlaying(self.In) then
--         return
--     end
--     local Avatar = GWorld:GetAvatar()
--     if not Avatar then
--         return false
--     end
--     local ChapterData = DataMgr.SelectDungeon[self.ChapterId]
--     if ChapterData and PageJumpUtils:CheckDungeonCondition(ChapterData.Condition, true) then
--         if not self.Parent.Root:IsAnimationPlaying(self.Parent.Root.Out) and not self:IsAnimationPlaying(self.Click) then
--             local Item = UIManager(self):GetUIObj("StyleOfPlay")
--             Item.IsOpenSelectLevel = true
--             self.Clicked = true
--             AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_large", nil, nil)
--             self:StopAllAnimations()
--             self:PlayAnimation(self.Click)
--         end
--     else
--         AudioManager(self):PlayUISound(self, "event:/ui/common/click_select_lock", nil, nil)
--     end
-- end

-- function M:OnPressed()
--     if self.IsUnLocked or self:IsAnimationPlaying(self.In) then
--         return
--     end
--     self:StopAllAnimations()
--     self:PlayAnimation(self.Press)
-- end

-- function M:OnReleased()
-- end

-- function M:OnHovered()
--     if self.IsUnLocked or self:IsAnimationPlaying(self.In) then
--         return
--     end
--     self:StopAllAnimations()
--     self:PlayAnimation(self.Hover)
-- end

-- function M:OnUnhovered()
--     if self.IsUnLocked or self:IsAnimationPlaying(self.In) then
--         return
--     end
--     self:StopAllAnimations()
--     self:PlayAnimation(self.Unhover)
-- end

-- function M:OnAnimationFinished(InAnimation)
--     if InAnimation == self.Click then
--         local Item = UIManager(self):GetUIObj("StyleOfPlay")
--         Item.IsOpenSelectLevel = false
--         local SelectLevel = Item:OpenSubUI({Idx = "DungeonSelect"}, nil, true)
--         local DungeonList = DataMgr.SelectDungeon[self.ChapterId].DungeonList
--         SelectLevel:InitLevelList(DungeonList)
--         Item:InitOtherPageTab({
--             DynamicNode = {"Back", "ResourceBar", "BottomKey"},
--             BottomKeyInfo = { { KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=SelectLevel.OnReturnKeyDown, Owner=SelectLevel}}, Desc = GText("UI_BACK"), bLongPress = false}},
--             OwnerPanel=SelectLevel,
--             BackCallback=SelectLevel.OnReturnKeyDown,
--             StyleName = "Text",
--             TitleName=GText("UI_Dungeon_TabName"),
-- 		    PopupInfoId = 100124,
--             InfoCallback = SelectLevel.ShowIntro
--         },nil,true)
--         self:AddTimer(0.5, function()
--             self:PlayAnimation(self.Normal)
--             self.Clicked = false
--         end, false, 0, "ResetLevelMain", true)
--     end
-- end

-- return M
