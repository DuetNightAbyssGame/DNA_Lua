--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local TimeUtils = require "Utils.TimeUtils"

---@type Common_ItemDetails_Resource_C
local M = Class("BluePrints.UI.BP_UIState_C")

function M:InitItemInfo(ItemType, ItemId, UnitId, Content)
    Content = Content or {}
    self.JumpReturnCallBack = Content and Content.JumpReturnCallBack
    self.GameInputModeSubsystem = UIManager(self):GetGameInputModeSubsystem()
    self.Panel_TimeLimit:SetVisibility(ESlateVisibility.Collapsed)
    self.Panel_Title:SetVisibility(ESlateVisibility.Collapsed)
    if ItemType == "Tips" then
        self:InitTipsInfo(self.ParentWidget.Content)
        return
    end
    self:SetFocus()

    if ItemType == "TreasureGroup" then
        self.ParentWidget.Panel_Hold:SetVisibility(ESlateVisibility.Collapsed)
        local TreasureGroupInfo = DataMgr[ItemType][ItemId]
        if not self.ParentWidget.Content.bGuide then
            if self.ParentWidget.Content.bActive then
                self.Text_Describe:SetText(GText("已激活"))
            else
                self.Text_Describe:SetText(GText("未激活"))
            end
        else
            self.Text_Describe:SetVisibility(ESlateVisibility.Collapsed)
        end
        self.Text_LongDescribe:SetText(GText(TreasureGroupInfo.GroupEffectDesc))
        return
    end

    if ItemType == "CharPartMesh" or ItemType == "Skin" or ItemType == "WeaponSkin" or ItemType == "Title" or ItemType == "TitleFrame" then
        assert(DataMgr[ItemType][ItemId], "未找到对应CharPartMesh信息：", ItemType, ItemId)
        local CharPartMeshInfo = DataMgr[ItemType][ItemId]
        self.ParentWidget.Panel_Hold:SetVisibility(ESlateVisibility.Collapsed)
        if ItemType == "WeaponSkin" then
            self.Text_Describe:SetText(GText(CharPartMeshInfo.Dec))
        else
            self.Text_Describe:SetText(GText(CharPartMeshInfo.Des))
        end
        if ItemType == "TitleFrame" then
            self.Panel_Title:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            local Widget = UIManager(self):LoadTitleFrameWidget(ItemId)
            if Widget then
                self.Pos_Title:AddChild(Widget)
                local Avatar = GWorld:GetAvatar()
                if not Avatar then
                    return
                end
                local TitleBefore = Avatar.TitleBefore
                local TitleAfter = Avatar.TitleAfter
                local TitleText = UIUtils.CalculateHoleTitle(TitleBefore, TitleAfter)
                Widget.Text_Title:SetText(TitleText)
            end
        end
        self.Text_LongDescribe:SetVisibility(ESlateVisibility.Collapsed)
        return
    end

    --- 配饰复用resource的tips
    if ItemType == "CharAccessory" or ItemType == "WeaponAccessory" then
        assert(DataMgr[ItemType][ItemId], "未找到对应配饰信息：", ItemType, ItemId)
        local CharAccessoryInfo = DataMgr[ItemType][ItemId]
        self.ParentWidget.Panel_Hold:SetVisibility(ESlateVisibility.Collapsed)
        if CharAccessoryInfo.AccessoryType then
            assert(UIConst.AccessoryTypeTextMap[CharAccessoryInfo.AccessoryType], "未知的配饰部位："..CharAccessoryInfo.AccessoryType)
            self.Text_Describe:SetText(GText(UIConst.AccessoryTypeTextMap[CharAccessoryInfo.AccessoryType]))
            self.Text_Describe:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        else
            self.Text_Describe:SetVisibility(ESlateVisibility.Collapsed)
        end
        self.Text_LongDescribe:SetText(GText(CharAccessoryInfo.Des))

        if not self.ParentWidget.Content.bCustomStype then
            local CallBack = {
                ButtonClickCallBack = function()
                    if self.ParentWidget and self.ParentWidget.Content and self.ParentWidget.Content.UIName and DataMgr.SystemUI[self.ParentWidget.Content.UIName] and DataMgr.SystemUI[self.ParentWidget.Content.UIName].IsBanAccess then
                        UIManager(self):ShowUITip("CommonToastMain", GText("UI_COMMONPOP_TITLE_100059"))
                    else
                        PageJumpUtils:CloseFrontDialog()
                        UIManager(self):LoadUINew("ArmorySkin", {Type = string.sub(ItemType, 1, string.find(ItemType, "Accessory") - 1), AccessoryId = ItemId, OnCloseCallback = self.JumpReturnCallBack and self.JumpReturnCallBack.CallBack})
                    end
                end,
                ButtonClickText = "UI_Preview_Title",
                ButtonIcon = 1
            }
            self.ParentWidget:InitButtonEvent(CallBack)
        end
        return
    end

    -- 自选包新增预览
    if DataMgr[ItemType][ItemId] and DataMgr[ItemType][ItemId].MaterialClassify == 7 then
        -- 当前武器、角色、皮肤（非通皮）、宠物暂不支持此预览，先手动屏蔽一下
        local OptInfo = DataMgr[ItemType][ItemId]
        local UseEffectType = DataMgr[ItemType][ItemId].UseEffectType
        if UseEffectType ~= CommonConst.ResUseEffectType.SelectWeapon and UseEffectType ~= CommonConst.ResUseEffectType.SelectCharacter and UseEffectType ~= CommonConst.ResUseEffectType.SelectSkin 
            and UseEffectType ~= CommonConst.ResUseEffectType.SelectPet then
            self.ParentWidget.Panel_Hold:SetVisibility(ESlateVisibility.Collapsed)
            local CallBack = {
                ButtonClickCallBack = function()
                    if UseEffectType == "RandomSelectPack" then
                        local ResourceConfig = DataMgr[ItemType][ItemId]
                        local CommonDialogParams = {}
                        CommonDialogParams.Title = GText(ResourceConfig.ResourceName)
                        CommonDialogParams.AutoFocus = true
                        CommonDialogParams.ParentWidget = self
                        CommonDialogParams.ResourceId = ResourceConfig.ResourceId
                        CommonDialogParams.UseParam = ResourceConfig.UseParam

                        UIManager(self):ShowCommonPopupUI(100344, CommonDialogParams, self, nil, 102)   
                    else
                        PageJumpUtils:CloseFrontDialog()
                        UIManager(self):LoadUINew("CharSkinPreview", {Type = UseEffectType, OptRewardId = OptInfo.UseParam, ResourceId = ItemId, Mode = "Preview"})
                    end
                end,
                ButtonClickText = "UI_Preview_Title",
                ButtonIcon = 1
            }
            self.ParentWidget:InitButtonEvent(CallBack)
        end
    end

    if ItemType == "Mount" then
        assert(DataMgr[ItemType][ItemId], "未找到对应坐骑信息：", ItemType, ItemId)
        local MountInfo = DataMgr[ItemType][ItemId]
        self.ParentWidget.Panel_Hold:SetVisibility(ESlateVisibility.Collapsed)
        self.Text_Describe:SetVisibility(ESlateVisibility.Collapsed)
        self.Text_LongDescribe:SetText(GText(MountInfo.MountDes))
        return
    end

    if ItemType == "HeadSculpture" or ItemType == "HeadFrame" then
        assert(DataMgr[ItemType][ItemId], "未找到对应配饰信息：", ItemType, ItemId)
        local HeadInfo = DataMgr[ItemType][ItemId]
        self.ParentWidget.Panel_Hold:SetVisibility(ESlateVisibility.Collapsed)
        if ItemType == "HeadSculpture" then
            self.Text_Describe:SetText(GText("UI_HeadFrame_Head"))
        else
            self.Text_Describe:SetText(GText("UI_HeadFrame_Frame"))
        end
        self.Text_LongDescribe:SetText(GText(HeadInfo.Des))
        return
    end

    --- 刻印、宝物复用Resource的tips
    if ItemType == "RougeLikeBlessing" or ItemType == "RougeLikeTreasure" then
        self.ParentWidget.Panel_Hold:SetVisibility(ESlateVisibility.Collapsed)
        local Desc
        if ItemType == "RougeLikeBlessing" then
            if ItemId then
                local RougeLikeManager = GWorld.RougeLikeManager
                local Level = math.max(RougeLikeManager:GetBlessingLevel(ItemId) - 1, 0)
                Desc = UIUtils.GenRougeBlessingDesc(ItemId,Level)
            else
                Desc = "RLBlessingGroup_Desc_unknown"
            end
        elseif ItemType == "RougeLikeTreasure" then
            if ItemId then
                Desc = UIUtils.GenRougeTreasureDesc(ItemId)
            else
                Desc = "RLTreasure_Desc_Unknown"
            end
        end
        self.Text_Describe:SetText(GText(Desc))
        self.Text_LongDescribe:SetVisibility(ESlateVisibility.Collapsed)
        return
    end

    if ItemType == "Resource" and DataMgr.LimitedTimeResource[ItemId] then
        local LimitedData = ItemUtils.GetItemLimitedInfo(ItemId)
        if LimitedData then
            local diff = os.difftime(LimitedData.EndTime.GetTime(), TimeUtils.NowTime())
            if diff < (60 * 60 * 24)  then
                self.BG_TimeLimit:SetColorAndOpacity(self.Color_Red)
            else
                self.BG_TimeLimit:SetColorAndOpacity(self.Color_Orange)
            end
            self.Panel_TimeLimit:SetVisibility(ESlateVisibility.Visible)
            local RemainTimeDict, TimeCount = UIUtils.GetLeftTimeStrStyle2(LimitedData.EndTime.GetTime(), TimeUtils.NowTime())
            self.Time_CountDown:SetTimeText(nil, RemainTimeDict)
            self.Text_Expiration:SetText(GText("UI_Date_End"))
            self.Time_Expiration:SetTimeText(LimitedData.EndTime.GetTime(), UIConst.EnumTimeStyleType.YMDAndHMS)
        end
    end

    if Content.ResourceSType=="MountItem" then
        self:FreshMountInfo(ItemId)
    end
    --- 如果是阅读物，显示阅读按钮，并且点击阅读按钮打开阅读界面
    local ResourceInfo = DataMgr.Resource[ItemId]
    if ResourceInfo.Type == "Read" then
        local Content = {
            ButtonClickCallBack = function()
                local CommonDialog = UIManager(self):GetUI("CommonDialog");
                if CommonDialog then
                    CommonDialog:Close()
                end
                UIManager(self):LoadUINew("ItemInformation", ItemId, "Read", self)
            end,
            ButtonClickText = "UI_BAG_Read",
            ButtonIcon = 1
        }
        self.ParentWidget:InitButtonEvent(Content)
    end
    
    if ResourceInfo.ResourceSType == "GestureItem" and not UIConst.LimitPreviewResource[ResourceInfo.ResourceId] then
        local Content = {
            ButtonClickCallBack = function()
                if self.ParentWidget and self.ParentWidget.Content and self.ParentWidget.Content.UIName and DataMgr.SystemUI[self.ParentWidget.Content.UIName].IsBanAccess then
                    UIManager(self):ShowUITip("CommonToastMain", GText("UI_COMMONPOP_TITLE_100059"))
                else
                    local CommonDialog = UIManager(self):GetUI("CommonDialog");
                    if CommonDialog then
                        CommonDialog:Close()
                    end
                    local ItemData = {}
                    ItemData.ItemType = "Resource"
                    ItemData.TypeId = ItemId
                    ItemData.SinglePreview = true
                    ItemData.HidePurchase = true
                    UIManager(self):LoadUINew("SkinPreview", ItemData, self)
                end
            end,
            ButtonClickText = "UI_Preview_Title",
            ButtonIcon = 0
        }
        self.ParentWidget:InitButtonEvent(Content)
    end

    if ResourceInfo.HoldDisplayRule == "Hide" then
        self.ParentWidget.Panel_Hold:SetVisibility(ESlateVisibility.Collapsed)
    else
        self.ParentWidget.Panel_Hold:SetVisibility(ESlateVisibility.Visible)
    end

    local PlayerAvatar = GWorld:GetAvatar()
    if (type(ItemId) =="string") then
        ItemId = math.tointeger(ItemId)
    end
    local ResourceServerData = PlayerAvatar.Resources[ItemId]
    -- 描述
    self.Text_Describe:SetVisibility(ResourceInfo.FunctionDes == nil and ESlateVisibility.Collapsed or ESlateVisibility.Visible)
    self.Text_LongDescribe:SetVisibility(ResourceInfo.DetailDes == nil and ESlateVisibility.Collapsed or ESlateVisibility.Visible)
    self.Text_Describe:SetText(GText(ResourceInfo.FunctionDes))
    self.Text_LongDescribe:SetText(GText(ResourceInfo.DetailDes))
    -- 数量
    local Count = 0
    if ResourceServerData then
        Count = ResourceServerData.Count
    end
    if ResourceInfo.HoldDisplayRule == "ActionPoint" then
        local Avatar = GWorld:GetAvatar()
        if not Avatar then
            return
        end
        Count = Avatar.ActionPoint
    end
    self.ParentWidget.Text_Hold02:SetText(Count)
end

-- 背包内初始化Resource信息（为了支持铸造图纸进背包，传统接口里有很多操作ParentWidget的逻辑，背包里没法用）
function M:InitItemInfoInBag(ItemType, ItemId, UnitId, Content)
    Content = Content or {}
    self.JumpReturnCallBack = Content and Content.JumpReturnCallBack
    self.GameInputModeSubsystem = UIManager(self):GetGameInputModeSubsystem()
    self.Panel_TimeLimit:SetVisibility(ESlateVisibility.Collapsed)
    self.Panel_Title:SetVisibility(ESlateVisibility.Collapsed)
    if ItemType == "Tips" then
        self:InitTipsInfo(Content)
        return
    end

    if ItemType == "TreasureGroup" then
        local TreasureGroupInfo = DataMgr[ItemType][ItemId]
        if not Content.bGuide then
            if Content.bActive then
                self.Text_Describe:SetText(GText("已激活"))
            else
                self.Text_Describe:SetText(GText("未激活"))
            end
        else
            self.Text_Describe:SetVisibility(ESlateVisibility.Collapsed)
        end
        self.Text_LongDescribe:SetText(GText(TreasureGroupInfo.GroupEffectDesc))
        return
    end

    if ItemType == "CharPartMesh" or ItemType == "Skin" or ItemType == "WeaponSkin" or ItemType == "Title" or ItemType == "TitleFrame" then
        assert(DataMgr[ItemType][ItemId], "未找到对应CharPartMesh信息：", ItemType, ItemId)
        local CharPartMeshInfo = DataMgr[ItemType][ItemId]
        if ItemType == "WeaponSkin" then
            self.Text_Describe:SetText(GText(CharPartMeshInfo.Dec))
        else
            self.Text_Describe:SetText(GText(CharPartMeshInfo.Des))
        end
        if ItemType == "TitleFrame" then
            self.Panel_Title:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            local Widget = UIManager(self):LoadTitleFrameWidget(ItemId)
            if Widget then
                self.Pos_Title:AddChild(Widget)
                local Avatar = GWorld:GetAvatar()
                if not Avatar then
                    return
                end
                local TitleBefore = Avatar.TitleBefore
                local TitleAfter = Avatar.TitleAfter
                local TitleText = UIUtils.CalculateHoleTitle(TitleBefore, TitleAfter)
                Widget.Text_Title:SetText(TitleText)
            end
        end
        self.Text_LongDescribe:SetVisibility(ESlateVisibility.Collapsed)
        return
    end

    --- 配饰复用resource的tips
    if ItemType == "CharAccessory" or ItemType == "WeaponAccessory" then
        assert(DataMgr[ItemType][ItemId], "未找到对应配饰信息：", ItemType, ItemId)
        local CharAccessoryInfo = DataMgr[ItemType][ItemId]
        if CharAccessoryInfo.AccessoryType then
            assert(UIConst.AccessoryTypeTextMap[CharAccessoryInfo.AccessoryType], "未知的配饰部位："..CharAccessoryInfo.AccessoryType)
            self.Text_Describe:SetText(GText(UIConst.AccessoryTypeTextMap[CharAccessoryInfo.AccessoryType]))
            self.Text_Describe:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        else
            self.Text_Describe:SetVisibility(ESlateVisibility.Collapsed)
        end
        self.Text_LongDescribe:SetText(GText(CharAccessoryInfo.Des))

        if not Content.bCustomStype then
            local CallBack = {
                ButtonClickCallBack = function()
                    if self.ParentWidget and Content.UIName and DataMgr.SystemUI[Content.UIName].IsBanAccess then
                        UIManager(self):ShowUITip("CommonToastMain", GText("UI_COMMONPOP_TITLE_100059"))
                    else
                        PageJumpUtils:CloseFrontDialog()
                        UIManager(self):LoadUINew("ArmorySkin", {Type = string.sub(ItemType, 1, string.find(ItemType, "Accessory") - 1), AccessoryId = ItemId, OnCloseCallback = self.JumpReturnCallBack and self.JumpReturnCallBack.CallBack})
                    end
                end,
                ButtonClickText = "UI_Preview_Title",
                ButtonIcon = 1
            }
        end
        return
    end

    if ItemType == "Mount" then
        assert(DataMgr[ItemType][ItemId], "未找到对应坐骑信息：", ItemType, ItemId)
        local MountInfo = DataMgr[ItemType][ItemId]
        self.Text_Describe:SetVisibility(ESlateVisibility.Collapsed)
        self.Text_LongDescribe:SetText(GText(MountInfo.MountDes))
        return
    end

    if ItemType == "HeadSculpture" or ItemType == "HeadFrame" then
        assert(DataMgr[ItemType][ItemId], "未找到对应配饰信息：", ItemType, ItemId)
        local HeadInfo = DataMgr[ItemType][ItemId]
        if ItemType == "HeadSculpture" then
            self.Text_Describe:SetText(GText("UI_HeadFrame_Head"))
        else
            self.Text_Describe:SetText(GText("UI_HeadFrame_Frame"))
        end
        self.Text_LongDescribe:SetText(GText(HeadInfo.Des))
        return
    end

    --- 刻印、宝物复用Resource的tips
    if ItemType == "RougeLikeBlessing" or ItemType == "RougeLikeTreasure" then
        self.ParentWidget.Panel_Hold:SetVisibility(ESlateVisibility.Collapsed)
        local Desc
        if ItemType == "RougeLikeBlessing" then
            if ItemId then
                local RougeLikeManager = GWorld.RougeLikeManager
                local Level = math.max(RougeLikeManager:GetBlessingLevel(ItemId) - 1, 0)
                Desc = UIUtils.GenRougeBlessingDesc(ItemId,Level)
            else
                Desc = "RLBlessingGroup_Desc_unknown"
            end
        elseif ItemType == "RougeLikeTreasure" then
            if ItemId then
                Desc = UIUtils.GenRougeTreasureDesc(ItemId)
            else
                Desc = "RLTreasure_Desc_Unknown"
            end
        end
        self.Text_Describe:SetText(GText(Desc))
        self.Text_LongDescribe:SetVisibility(ESlateVisibility.Collapsed)
        return
    end

    if ItemType == "Resource" and DataMgr.LimitedTimeResource[ItemId] then
        local LimitedData = ItemUtils.GetItemLimitedInfo(ItemId)
        if LimitedData then
            local diff = os.difftime(LimitedData.EndTime.GetTime(), TimeUtils.NowTime())
            if diff < (60 * 60 * 24)  then
                self.BG_TimeLimit:SetColorAndOpacity(self.Color_Red)
            else
                self.BG_TimeLimit:SetColorAndOpacity(self.Color_Orange)
            end
            self.Panel_TimeLimit:SetVisibility(ESlateVisibility.Visible)
            local RemainTimeDict, TimeCount = UIUtils.GetLeftTimeStrStyle2(LimitedData.EndTime.GetTime(), TimeUtils.NowTime())
            self.Time_CountDown:SetTimeText(nil, RemainTimeDict)
            self.Text_Expiration:SetText(GText("UI_Date_End"))
            self.Time_Expiration:SetTimeText(LimitedData.EndTime.GetTime(), UIConst.EnumTimeStyleType.YMDAndHMS)
        end
    end

    if Content.ResourceSType=="MountItem" then
        self:FreshMountInfo(ItemId)
    end
    --- 如果是阅读物，显示阅读按钮，并且点击阅读按钮打开阅读界面
    local ResourceInfo = DataMgr.Resource[ItemId]
    if ResourceInfo.Type == "Read" then
        local Content = {
            ButtonClickCallBack = function()
                local CommonDialog = UIManager(self):GetUI("CommonDialog");
                if CommonDialog then
                    CommonDialog:Close()
                end
                UIManager(self):LoadUINew("ItemInformation", ItemId, "Read", self)
            end,
            ButtonClickText = "UI_BAG_Read",
            ButtonIcon = 1
        }
    end
    
    if ResourceInfo.ResourceSType == "GestureItem" and not UIConst.LimitPreviewResource[ResourceInfo.ResourceId] then
        local Content = {
            ButtonClickCallBack = function()
                if self.ParentWidget and self.ParentWidget.Content and self.ParentWidget.Content.UIName and DataMgr.SystemUI[self.ParentWidget.Content.UIName].IsBanAccess then
                    UIManager(self):ShowUITip("CommonToastMain", GText("UI_COMMONPOP_TITLE_100059"))
                else
                    local CommonDialog = UIManager(self):GetUI("CommonDialog");
                    if CommonDialog then
                        CommonDialog:Close()
                    end
                    local ItemData = {}
                    ItemData.ItemType = "Resource"
                    ItemData.TypeId = ItemId
                    ItemData.SinglePreview = true
                    ItemData.HidePurchase = true
                    UIManager(self):LoadUINew("SkinPreview", ItemData, self)
                end
            end,
            ButtonClickText = "UI_Preview_Title",
            ButtonIcon = 0
        }
    end

    local PlayerAvatar = GWorld:GetAvatar()
    if (type(ItemId) =="string") then
        ItemId = math.tointeger(ItemId)
    end
    local ResourceServerData = PlayerAvatar.Resources[ItemId]
    -- 描述
    self.Text_Describe:SetVisibility(ResourceInfo.FunctionDes == nil and ESlateVisibility.Collapsed or ESlateVisibility.Visible)
    self.Text_LongDescribe:SetVisibility(ResourceInfo.DetailDes == nil and ESlateVisibility.Collapsed or ESlateVisibility.Visible)
    self.Text_Describe:SetText(GText(ResourceInfo.FunctionDes))
    self.Text_LongDescribe:SetText(GText(ResourceInfo.DetailDes))
end

---@todo ZDX 商品详情Tips暂时用改蓝图显示, 商城物品Tips正式接入后，删除
function M:InitTipsInfo(ItemInfo)
    local Itemdata = DataMgr[ItemInfo.Type][ItemInfo.ItemId]
    self.ParentWidget:InitItemBaseInfo(Itemdata)
    self.Text_Describe:SetText(GText(self.ParentWidget.Content.Tips))
    self.Text_LongDescribe:SetVisibility(ESlateVisibility.Collapsed)
    local PlayerAvatar = GWorld:GetAvatar()
    local Count = 0
    if self.ParentWidget.Content.Type == "Mod" then
        for _, Mod in pairs(PlayerAvatar.Mods) do
            if Mod.ModId == ItemInfo.ItemId and Mod.IsOriginal then
                Count = Count + Mod.Count
            end
        end
        local ModName = GText(Itemdata.TypeName)..GText(Itemdata.Name)
        self.ParentWidget.Text_ItemName:SetText(ModName)
    elseif self.ParentWidget.Content.Type == "Weapon" then
        for _, Weapon in pairs(PlayerAvatar.Weapons) do
            if Weapon.WeaponId == ItemInfo.ItemId then
                Count = Count + 1
            end
        end
    else
        local ResourceServerData = PlayerAvatar.Resources[ItemInfo.ItemId]
        if ResourceServerData then
            Count = ResourceServerData.Count
        end
    end
    self.ParentWidget.Text_Hold02:SetText(Count)
end

function M:FreshMountInfo(ItemId)
    local ItemInfo=DataMgr.Resource[ItemId] 
    if not ItemInfo then
        ScreenPrint("没找到对应坐骑物品 ItemId:"..tostring(ItemId))
        return
    end
    local MountId=DataMgr.Resource[ItemId].FunctionVars and DataMgr.Resource[ItemId].FunctionVars.Id
    if not MountId then
         ScreenPrint("没找到坐骑物品对应的坐骑Id,检查FunctionVars是否填入的ID这一项 ItemId:"..tostring(ItemId).."  FunctionVars:"..CommonUtils:ToStringEx(DataMgr.Resource[ItemId].FunctionVars))
    end
    local MountInfo=DataMgr.Mount[MountId]
    if not MountInfo then
        ScreenPrint("没找到对应坐骑信息 MountId:"..tostring(MountId))
        return
    end
    local MountText = MountInfo.UseLimitDes
    if MountText then
        self.Panel_Message:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        self.Text_Message:SetText(GText(MountText))
    else
        DebugPrint("没找到对应坐骑信息的使用限制描述UseLimitDes   --- MountId:"..tostring(MountId))
    end
end

return M