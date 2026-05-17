--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR zhangdongxu
-- @DATE 2025-1-6 15:18:22
--
require "UnLua"
local TimeUtils = require "Utils.TimeUtils"
local StrLib             = require "BluePrints.Common.DataStructure"
local Deque              = StrLib.Deque

---@type WBP_Com_Item_M_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C","BluePrints.UI.BP_EMUserWidgetUtils_C","BluePrints.Common.DelayFrameComponent"})

----------------------------开发规范----------------------------
--- 通用道具框分为三个部分：
--- 1、通用默认表现 (InitCommonView())
--- 2、各个系统中道具框的自身特定的默认表现 (InitCompView())
--- 3、一些可选的状态表现
--- 对于各个系统中道具框采用继承通用默认表现 + 自身特定表现的方式加载，即重写 InitCompView 方法
--- 对于所有可选状态表现都作为方法去调用
-------------------------------------------------------------

function M:Init(Content)
    self:OnListItemObjectSet(Content)
end

---@param Content SmallContent
function M:OnListItemObjectSet(Content)
    Content.SelfWidget = self
    self.WidgetMap = self.WidgetMap or {}
    self:RemoveAllEvent()
    self:InitData(Content)
    self:InitCompView()
    self:InitNavigationRule()

    if self.AfterInitCallback then 
        self.AfterInitCallback(self)
    end
end

--region 公用的一些方法：如初始化

---@class ItemContent
---必填
---@field Id number                         @道具ID
---@field ItemType number                   @道具类型
---@field Rarity number                     @稀有度
---@field Icon string                       @图标(路径)
---选填
---@field Uuid string                       @Tips时所使用的Uuid
---数量相关
---@field Count number                      @数量
---@field NeedCount number                  @所需数量，如果有，采用 Count / NeedCount 的形式显示
---@field MaxCount number                   @最大数量，如果有，采用 Count ~ MaxCount 的形式显示
---@field NotCountFormat boolean            @是否格式化显示数字
---@field bShowNotHaveStyle boolean         @是否需要显示未拥有样式
---@field CountTextRed boolean              @只传一个Count时，数量文本是否变红
---@field CountTextWhite boolean            @Count数量小于NeedCount时，文本是否依旧显示白色
---动效相关
---@field NotInteractive boolean           @是否不能交互(Hover, UnHover, Click, Select)
---@field bPlayInAnim boolean               @是否播放In动画
---@field bSpecial boolean                  @是否显示特殊动效In动效 VX_xxx_In
---@field bCanReceive boolean               @是否可领取（In时播放Receive_On动效，需打开bPlayInAnim）
---@field HandleMouseDown boolean           @OnMouseButtonDown是否返回Handle
---Tips相关
---@field IsShowDetails boolean             @是否启用Tips
---@field MenuPlacement EMenuPlacement      @Tips菜单锚点
---@field UINames string                    @Item所在页面在SystemUI中对应的UIName(用于控制弹出的tips的获取途径是否可跳转)
---标识相关
---@field RedDotType string|number          @红点类型，参数：CommonRedDot(正常红点) NewRedDot(New红点) GreyRedDot(灰色红点) Number(计数红点)
---@field bHasGot boolean                   @是否显示已领取状态
---@field BonusType number                  @显示奖励标识类型，参数: 1、额外奖励  2、首通奖励标识
---@field bSold boolean                     @是否显示购入标识
---@field bAsyncLoadIcon boolean            @是否需要异步加载图标
---回调相关
---@field AfterInitCallback function        @初始化结束后回调
---@field OnMouseButtonUpEvents table       @点击事件回调方法 {Obj = , Callback = , Params =}
--- 数据初始化
---@param Content ItemContent 
function M:InitData(Content)
    self.Content = Content
    ---@type WBP_Com_Item_M_C
    self.ParentWidget = Content.ParentWidget
    ------------------------------------必填------------------------------------
    self.Id = Content.Id or Content.UnitId
    self.ItemType = Content.ItemType                    -- 道具类型
    self.Rarity = Content.Rarity                        -- 稀有度
    self.Icon = Content.Icon                            -- 图标 (需要传路径)

    ------------------------------------可选------------------------------------
    self.Uuid = Content.Uuid                            -- Tips时所使用的Uuid
    -- 数量相关
    self.Count = Content.Count                          -- 数量
    self.NeedCount = Content.NeedCount                  -- 所需数量，如果有，采用 Count / NeedCount 的形式显示
    self.MaxCount = Content.MaxCount                    -- 最大数量，如果有，采用 Count ~ MaxCount 的形式显示
    self.NotCountFormat = Content.NotCountFormat        -- 是否格式化显示数字
    self.SelectNeedCount = Content.SelectNeedCount      -- 选择数量
    self.SelectTotalCount = Content.SelectTotalCount     -- 选择数量
    self.bShowNotHaveStyle = Content.bShowNotHaveStyle  -- 是否需要显示未拥有状态
    self.PetEntryId = Content.PetEntryId                -- 宠物词条Id
    self.CountTextRed = Content.CountTextRed            -- 只传一个Count时，数量文本是否变红
    self.CountTextWhite = Content.CountTextWhite        -- Count数量小于NeedCount时，文本是否依旧显示白色
    -- 文本提示相关
    self.ItemName = Content.ItemName                    -- 道具框显示名称
    self.Level = Content.Level                          -- 道具框显示等级 Lv.
    -- 动效相关
    self.NotInteractive = Content.NotInteractive        -- 是否不能交互 (Hover, UnHover, Click, Select)
    self.bPlayInAnim = Content.bPlayInAnim              -- 是否播放In动画
    self.bSpecial = Content.bSpecial                    -- 是否显示特殊动效In动效 VX_xxx_In
    self.bCanGet = Content.bCanGet                      -- 是否显示可领取状态
    self.CanGetStyle = Content.CanGetStyle              -- 可领取状态的样式 填字符串，可选项有：Gold,White,Purple,Blue

    self.bHideGamePad = Content.bHideGamePad            -- 是否隐藏手柄
    -- Tips相关
    self.IsShowDetails = Content.IsShowDetails          -- 是否启用Tips
    self.MenuPlacement = Content.MenuPlacement          -- Tips菜单锚点
    self.UIName = Content.UIName                        -- Item所在页面在SystemUI中对应的UIName(用于控制弹出的tips的获取途径是否可跳转)
    self.bNotShowAccess = Content.bNotShowAccess              -- Tips是否显示获取途径
    self.bCustomStype = Content.bCustomStype            -- Tips是否关闭自定义样式
    self.ItemDetailsButton01EventInfo = Content.ItemDetailsButton01EventInfo
    self.ItemDetailsButton02EventInfo = Content.ItemDetailsButton02EventInfo
    self.ItemDetailsLockEventInfo = Content.ItemDetailsLockEventInfo
    self.Item.ItemDetails_MenuAnchor.ParentWidget = self
    self.ItemDetailKeyDownEvent = Content.ItemDetailKeyDownEvent
    self.ItemDetailHandleKeyDown = Content.ItemDetailHandleKeyDown
    self.bNoJumpPreview = Content.bNoJumpPreview        -- 是否禁用预览跳转

    self.Content.IsShowTips = false                     -- 当前是否显示tips

    -- 标识相关
    self.RedDotType = Content.RedDotType                -- 红点类型： 参数：UIConst.RedDotType.CommonRedDot(正常红点) UIConst.RedDotType.NewRedDot(New红点) UIConst.RedDotType.GreyRedDot(灰色红点暂未支持)
    self.bHasGot = Content.bHasGot                      -- 是否显示已领取状态
    self.BonusType = Content.BonusType or 0             -- 显示奖励标识类型，参数: 1、额外奖励  2、首通奖励标识
    self.ExtraBonusText = Content.ExtraBonusText        -- 额外的奖励标识文本
    self.bSold = Content.bSold                          -- 是否显示购入标识
    self.LockType = Content.LockType                    -- 显示锁定标识，参数：1、右上角角标  2、中心锁定
    self.bShadow = Content.bShadow                      -- 显示阴影遮罩
    self.bOutline = Content.bOutline                    -- 显示轮廓剪影
    self.bAsyncLoadIcon = Content.bAsyncLoadIcon        -- 是否需要异步加载图标
    self.bUnrevealed = Content.bUnrevealed
    self.bRare = Content.bRare
    self.bInGear = Content.bInGear
    self.WeaponMiniPhantomIconCharId = Content.WeaponMiniPhantomIconCharId
    self.TryOutText = Content.TryOutText
    self.SquadBuildTryOutText = Content.SquadBuildTryOutText
    self.TimeLimitData = Content.TimeLimitData          -- 限时标记信息 {TimeText = , Type = ,} Type = 1:橙色 Type = 2:红色
    -- 其他
    self.bAdd = Content.bAdd                            -- 显示加号
    -- 回调相关
    self.HandleMouseDown = Content.HandleMouseDown          -- OnMouseDown时是否返回Handle
    self.bDisableCommonClick = Content.bDisableCommonClick      -- 禁用通用点击后执行方法：1、核桃点击打开核桃详情 2、角色点击打开角色详情
    self.AfterInitCallback = Content.AfterInitCallback          -- 初始化结束后回调
    self.OnFocusReceivedEvent = Content.OnFocusReceivedEvent    -- 点击事件回调方法 {Obj = , Callback = , Params =}
    self.OnAddedToFocusPathEvent = Content.OnAddedToFocusPathEvent  -- 添加到聚集路径回调方法 {Obj = , Callback = , Params =}
    self.OnRemovedFromFocusPathEvent = Content.OnRemovedFromFocusPathEvent  -- 从聚集路径移除回调方法 {Obj = , Callback = , Params =}

    self.OnMouseEnterEvent = Content.OnMouseEnterEvent              -- 事件回调方法 {Obj = , Callback = , Params =}
    self.OnMouseLeaveEvent = Content.OnMouseLeaveEvent              -- 事件回调方法 {Obj = , Callback = , Params =}
    self.OnMouseButtonDownEvent = Content.OnMouseButtonDownEvent    -- 事件回调方法 {Obj = , Callback = , Params =}

    self.JumpReturnCallBack = Content.JumpReturnCallBack
    self.OnMouseButtonUpEvents = Content.OnMouseButtonUpEvents      -- 点击事件回调方法 {Obj = , Callback = , Params =}
    self.OnMenuOpenChangedEvents = Content.OnMenuOpenChangedEvents  -- Tips打开关闭回调方法 {Obj = , Callback =}
    if self.OnMenuOpenChangedEvents then
        self:BindEventOnMenuOpenChanged(self.OnMenuOpenChangedEvents.Obj, self.OnMenuOpenChangedEvents.Callback)
    end
    if self.OnMouseButtonUpEvents then
        self:BindEventOnMouseButtonUp(self.OnMouseButtonUpEvents.Obj, self.OnMouseButtonUpEvents.Callback, self.OnMouseButtonUpEvents.Params)
    end

    ----如果觉得列表滑动太卡的话，试试这个选项，它会保留所有动态添加的子UI,仅控制显隐，避免频繁增删UI节点的操作，可以提高列表交互的流畅性
    self.bDontRemoveSubWidget = true
     --是否开启所有道具框子项的异步加载，毕竟有些子项还是需要即时获取，不好完全改异步
    if Content.bAllUseAsyncLoadWidget ~= nil then
        self.bAllUseAsyncLoadWidget = Content.bAllUseAsyncLoadWidget
    else
        self.bAllUseAsyncLoadWidget = true
    end
end

--自定义item的导航规则
function M:InitNavigationRule()
    if self.NavigationRule then
        self.NavigationRule.UINavigationRuleFunc(self.Content.SelfWidget, self.NavigationRule.UINavigation, self.NavigationRule.FocusWidget)
    end
end

--- 初始化通用的表现
function M:InitCommonView()
    self:ClearBackGroundHeight()
    ------------------------------------复原Item状态------------------------------------
    --- 关闭菜单锚
    if self.Item.ItemDetails_MenuAnchor then
        self.Item.ItemDetails_MenuAnchor:CloseItemDetailsWidget()
    end
    self:SetOutline(false)
    
    ------------------------------------加载Item表现------------------------------------
    --- 显示为＋号图标
    if self.bAdd then
        self:SetAdd(self.bAdd)
        return
    end
    --- Id为空或0时，显示空道具框
    if not self.Id or self.Id == 0 then
        self.Item.WidgetSwitcher_State:SetActiveWidgetIndex(1)
        return
    else
        self.Item.WidgetSwitcher_State:SetActiveWidgetIndex(0)
    end

    self:SetIcon(self.Icon)
    self:SetRarity(self.Rarity)
    self:SetSelected(self.Content.IsSelect)
    self:SetDraftType(self.ItemType == "Draft")

    --- 播放动画
    if self.bPlayInAnim then
        self:PlayInAnimation()
    end
end

function M:SetIcon(IconPath)
    --- 如果是核桃类型，需显示核桃表对应的Icon
    if self.ItemType == "Walnut" then
        IconPath = DataMgr.Walnut[self.Id].Icon
        self:SetWalnutNum(self.Id)
    end

	if self.Item.SetBgMaterialByItemType then
        if self.ItemType == "Hair" and self.Rarity == 0 then
            local Material = self.Item.HairMatIns
            if Material then
                self.Item.Item_BG:SetBrushFromMaterial(Material)
            end
        else
    	    self.Item:SetBgMaterialByItemType(self.ItemType, "HeadSculpture")
        end
	end

    -- 是否需要异步加载图标
    if(self.bAsyncLoadIcon)then
        -- self.Item.Item_BG:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self:LoadTextureAsync(IconPath,function(Texture)
            if not Texture then
                Texture = LoadObject("Texture2D'/Game/UI/Texture/Dynamic/Image/Head/Monster/T_Head_Empty.T_Head_Empty'")
                DebugPrint(ErrorTag,string.format("用错图标路径了！！！这里用默认的图标顶一下\n 错误的路径是：%s",IconPath))
            end
            if(Texture)then
                local __IconDynaMaterial = self.Item.Item_BG:GetDynamicMaterial()
                if(__IconDynaMaterial)then
                    __IconDynaMaterial:SetTextureParameterValue("IconMap", Texture)
                end
                -- self.Item.Item_BG:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
            end
        end,"LoadIcon")
    else
        local Type = self.ItemType and tostring(self.ItemType) or "nil"
        local Id = self.ItemType and tostring(self.Id) or "nil"
        -- assert(IconPath, "道具框传入Icon路径为空， ItemType:"..Type.."Id:"..Id)
        if IconPath == nil then
            IconPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/Head/Monster/T_Head_Empty.T_Head_Empty'"
            ScreenPrint(string.format("ItemType为：%s ，Id为：%s 的通用道具框没配IconPath！！！，辛苦对应策划配一下", Type, Id))
        end
        local Icon = LoadObject(IconPath)
        if not Icon then
            Icon = LoadObject("Texture2D'/Game/UI/Texture/Dynamic/Image/Head/Monster/T_Head_Empty.T_Head_Empty'")
            DebugPrint(ErrorTag,string.format("用错图标路径了！！！这里用默认的图标顶一下\n 错误的路径是：%s",IconPath))
        end
        local DynamicMaterial = self.Item.Item_BG:GetDynamicMaterial()
        if not IsValid(DynamicMaterial) then
            DebugPrint("ZDX_DynamicMaterial不合法")
        end
        DynamicMaterial:SetTextureParameterValue("IconMap", Icon)
    end
end

function M:SetDraftType(IsDraftType)
    local Callback = function(CoroutineObj)
        if self.DraftItemWidget and not IsValid(self.DraftItemWidget) then
            self.WidgetMap[self.DraftItemWidget] = nil
        end
        if IsDraftType then
            if not self.WidgetMap[self.DraftItemWidget] and not IsValid(self.DraftItemWidget) then
                self.DraftItemWidget = self:CreateWidgetAsync("DraftCompendiumItem",CoroutineObj)
            end
            self:AddWidgetToNode(self.DraftItemWidget)
        else
            if self.DraftItemWidget and self.WidgetMap[self.DraftItemWidget] then
                self:RemoveWidgetFromNode(self.DraftItemWidget)
            end
        end
    end

    self:AsyncLoadWidgetCommon("DraftItemWidget", "SetDraftTypeTask", Callback)
end

function M:LoadTextureAsync(TexturePath, cb, TaskName)
    rawset(self, TaskName, nil)
    local Handle = UE.UResourceLibrary.LoadObjectAsyncWithId(self, TexturePath, {self, function (self, Texture, ResourceID)
            if not IsValid(self) or (ResourceID ~= nil and rawget(self, TaskName) ~= ResourceID) then
                return
            end
            cb(Texture)
        end})
    if Handle then
        rawset(self, TaskName, Handle.ResourceID)
    end
    -- self.CoTasks = self.CoTasks or {}
    -- if(self.CoTasks[TaskName])then
    --     coroutine.close(self.CoTasks[TaskName])
    -- end
    -- local Co_Handle = coroutine.create(function(co)
    --     local TextureObj
    --     UResourceLibrary.LoadObjectAsync(self, TexturePath, {self, function(self, Texture)
    --         TextureObj = Texture
    --         if(coroutine.status(co) == "suspended")then
    --             coroutine.resume(co,co)
    --         end
    --     end})
    --     coroutine.yield()
    --     cb(TextureObj)
    -- end)
    -- self.CoTasks[TaskName] = Co_Handle
    -- coroutine.resume(Co_Handle,Co_Handle)
end

function M:SetRarity(Rarity)
    local Item_BG=self.Item.Item_BGPanel or  self.Item.Item_BG  --通用道具框的品质色用Item_BGPanel
    local DynamicMaterial =Item_BG:GetDynamicMaterial()
    DynamicMaterial:SetScalarParameterValue("IconOpacity", 1)
    if not IsValid(DynamicMaterial) then
        DebugPrint("ZDX_DynamicMaterial不合法")
    end
    --- 无品质
    if not Rarity or Rarity < 1 or Rarity > 6 then
        --DynamicMaterial:SetVectorParameterValue("BGPanelColor", self.Item.Color_NoQuality)
        --DynamicMaterial:SetScalarParameterValue("HasQualityLight", 0)
        --DynamicMaterial:SetScalarParameterValue("QualityLineHeight", 0)
        -- if self.Item.Img_Hover_0 then
        --     DynamicMaterial:SetTextureParameterValue("HoverTex", self.Item.Img_Hover_0)
        -- else
        --     DebugPrint(ErrorTag, Traceback(ErrorTag,"道具框"..tostring(self.Item).."  缺少Img_Hover_0，找蓝图去加一个", true))
        -- end
        DynamicMaterial:SetScalarParameterValue("Index",0)
        return
    end
    DynamicMaterial:SetScalarParameterValue("Index",Rarity)
    --DynamicMaterial:SetVectorParameterValue("BGPanelColor", self.Item.Color_HasQuality)
    --DynamicMaterial:SetScalarParameterValue("HasQualityLight", 1)
    --DynamicMaterial:SetScalarParameterValue("QualityLineHeight", 0.09)
    ---local ImgHover = self.Item["Img_Hover_"..Rarity]
    --local QualityLine_Color = self.Item["Line_"..Rarity]
    --local QualityLight_Color = self.Item["Light_"..Rarity]
    ---DynamicMaterial:SetTextureParameterValue("HoverTex", ImgHover)
    --DynamicMaterial:SetVectorParameterValue("QualityLineColor", QualityLine_Color)
    --DynamicMaterial:SetVectorParameterValue("QualityLightColor", QualityLight_Color)
    self:_SetMostRarityFX(Rarity,DynamicMaterial)
end

function M:_SetMostRarityFX(Rarity,DynamicMaterial)
    if not DynamicMaterial then
        local Item_BG = self.Item.Item_BGPanel or self.Item.Item_BG
        DynamicMaterial = Item_BG:GetDynamicMaterial()
    end
    if Rarity ~= 6 then
        if self.WidgetMap[self._MostRarityFX] then
            self:RemoveWidgetFromNode(self._MostRarityFX)
        end
        DynamicMaterial:SetScalarParameterValue("Colorful_Alpha",0.35) 
        DynamicMaterial:SetScalarParameterValue("AddOpacity",0)
        DynamicMaterial:SetScalarParameterValue("IconAddOpacity",0)
        return    
    end
    if not self._MostRarityFX then
        self:CreateWidgetAsync(nil, function(MostRarityFX)
            if not MostRarityFX then return end
            self._MostRarityFX = MostRarityFX
            if not self.WidgetMap[self._MostRarityFX] then
                self:AddWidgetToNode(self._MostRarityFX)
                self:CheckWidgetIsTop(self._MostRarityFX)
            end
        end, '/Game/UI/WBP/Common/Item/Widget/WBP_Com_Item_RedVX.WBP_Com_Item_RedVX')
    else
        self:AddWidgetToNode(self._MostRarityFX)
        self:CheckWidgetIsTop(self._MostRarityFX)
    end
    DynamicMaterial:SetScalarParameterValue("Colorful_Alpha",0.8) 
    DynamicMaterial:SetScalarParameterValue("AddOpacity",1)
    DynamicMaterial:SetScalarParameterValue("IconAddOpacity",1)
    --self._MostRarityFX:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
end

--- 添加核桃编号
function M:SetWalnutNum(ItemId)
    -- self:AsyncLoadWidgetCommon(nil, "SetWalnutNumTask", function(CoroutineObj)
    --     assert(DataMgr.Walnut[ItemId], "核桃不存在：", ItemId)
    --     local WalnutNum = DataMgr.Walnut[ItemId].WalnutNumber
    --     local WalnutNumWidget = self:CreateWidgetAsync("ComItemWalnutNum",CoroutineObj)
    --     if ItemId then
    --         WalnutNumWidget.Walnut_Number:InitWalnutNumber(ItemId)
    --         WalnutNumWidget.Walnut_Number:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    --     else
    --         WalnutNumWidget.Walnut_Number:SetVisibility(UE4.ESlateVisibility.Collapsed)
    --     end
    --     self:AddWidgetToNode(WalnutNumWidget)
    -- end)
end

function M:BP_OnEntryReleased()
    if (self.Content) then
        self.Content.SelfWidget = nil
    end
end

--- 交互逻辑
function M:OnMouseEnter(MyGeometry, MouseEvent)
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
        return
    end
    if not self.Content or self.NotInteractive or self.Content.IsSelect or self.Content.IsShowTips or self:IsInAnimationPlaying() then
        return 
    end
    if self.OnMouseEnterEvent and self.OnMouseEnterEvent.Callback then
        self.OnMouseEnterEvent.Callback(self.OnMouseEnterEvent.Params)
    end
    self.Item:StopAllAnimations()
    self.Item:PlayAnimation(self.Item.Hover)
end

function M:OnMouseLeave(MyGeometry, MouseEvent)
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
        return
    end
    if not self.Content or  self.NotInteractive or self.Content.IsSelect or self.Content.IsShowTips or self:IsInAnimationPlaying() then
        return
    end
    if self.OnMouseLeaveEvent and self.OnMouseLeaveEvent.Callback then
        self.OnMouseLeaveEvent.Callback(self.OnMouseLeaveEvent.Obj, self.OnMouseLeaveEvent.Params)
    end
    self.bMouseButtonDown = false
    self.Item:StopAllAnimations()
    self.Item:PlayAnimation(self.Item.UnHover)
end
function M:OnMouseButtonDown(MyGeometry, MouseEvent)
    local HandleResult = UWidgetBlueprintLibrary.Unhandled()
    if self.HandleMouseDown then
        HandleResult = UWidgetBlueprintLibrary.Handled()
    end
    -- 点击显示Tips，且Tips已经显示时
    if self.NotInteractive or (self.IsShowDetails and self.Item.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor:IsOpen()) or self:IsInAnimationPlaying() then
        return HandleResult
    end
    self:StopAllAnimations()
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        self.Item:PlayAnimation(self.Item.Press)
    end
    local CanCallBack = true
    if self.OnMouseButtonDownEvent and self.OnMouseButtonDownEvent.Params and self.OnMouseButtonDownEvent.Params.bIgnoreRightMouseDown then
        if UE4.UKismetInputLibrary.PointerEvent_GetEffectingButton(MouseEvent) == UE4.EKeys.RightMouseButton then
            CanCallBack = false
        end
    end
    if self.OnMouseButtonDownEvent and self.OnMouseButtonDownEvent.Callback and CanCallBack then
        self.OnMouseButtonDownEvent.Callback(self.OnMouseButtonDownEvent.Obj, self.OnMouseButtonDownEvent.Params)
    end
    self.bMouseButtonDown = true
    return HandleResult
end

function M:OnMouseButtonUp(MyGeometry, MouseEvent)
    if self.NotInteractive or self:IsInAnimationPlaying() or not self.bMouseButtonDown then
        return UWidgetBlueprintLibrary.Unhandled()
    end

    self.bMouseButtonDown = false
    if self.ItemType == CommonConst.ArmoryType.Mod then
        AudioManager(self):PlayItemSound(self, self.Content.UnitId or self.Id, "Click", self.ItemType)
    else
        AudioManager(self):PlayItemSound(self, self.Id, "Click", self.ItemType)
    end

    if not self.bDisableCommonClick then
        if self.ItemType == "Walnut" then
            -- PageJumpUtils:CloseFrontDialog()
            self:OpenWalnutRewardDialog()
            return UWidgetBlueprintLibrary.Handled()
        end
        if (self.ItemType == "Skin" or self.ItemType == "WeaponSkin" or self.ItemType == "Mount") and not self.bNoJumpPreview then
            if DataMgr.SystemUI[self.UIName] and DataMgr.SystemUI[self.UIName].IsBanAccess then
                UIManager(self):ShowUITip("CommonToastMain", GText("UI_COMMONPOP_TITLE_100059"))
                return UWidgetBlueprintLibrary.Handled()
            end
            if (not self.Id) or (not self.ItemType) then
                return UWidgetBlueprintLibrary.Handled()
            end
            PageJumpUtils:CloseFrontDialog()
            local Content = {}
            Content.TypeId = self.Id
            Content.ItemType = self.ItemType
            Content.SinglePreview = true
            Content.HidePurchase = true
            UIManager(self):LoadUINew("SkinPreview", Content, self.ParentWidget)
            return UWidgetBlueprintLibrary.Handled()
        end
    end
    if self.IsShowDetails and not self.OwningList then
        -- 点击显示Tips，且Tips已经显示时
        if self.Item.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor:IsOpen() then
            return UWidgetBlueprintLibrary.Unhandled()
        end
        self:OpenItemMenu()
    end
    if not self.IsShowDetails then
        self.Item:PlayAnimation(self.Item.Click)
    end
    -- AudioManager(self):PlayItemSound(self, self.Id, "Click", self.ItemType)
    self.Item:PlayAnimation(self.Item.Click)
    if self.OnMouseButtonUpEvent then 
        for Obj, Callback in pairs(self.OnMouseButtonUpEvent) do 
            if self.OnMouseButtonUpEventParam[Obj] then
                Callback(Obj, table.unpack(self.OnMouseButtonUpEventParam[Obj]))
            else
                Callback(Obj)
            end
        end
    end

    return UWidgetBlueprintLibrary.Unhandled()
end

function M:OnTouchEnded(MyGeometry, TouchEvent)
    return self:OnMouseButtonUp(MyGeometry, TouchEvent)
end

function M:OnTouchStarted(MyGeometry, TouchEvent)
    return self:OnMouseButtonDown(MyGeometry, TouchEvent)
end

function M:BindEventOnMouseButtonUp(Obj, Callback, Params)
    if not self.OnMouseButtonUpEvent then 
        self.OnMouseButtonUpEvent = {}
        self.OnMouseButtonUpEventParam = {}
    end

    self.OnMouseButtonUpEvent[Obj] = Callback
    self.OnMouseButtonUpEventParam[Obj] = Params
end

function M:ClearEventOnMouseButtonUp(Obj)
    if not self.OnMouseButtonUpEvent then return end 
    self.OnMouseButtonUpEvent[Obj] = nil
    self.OnMouseButtonUpEventParam[Obj] = nil
end

function M:RemoveAllEvent()
    self.OnMouseButtonUpEvent = {}
    self.OnMouseButtonUpEventParam = {}
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    if self.OnFocusReceivedEvent then 
        local Obj = self.OnFocusReceivedEvent.Obj
        local Callback = self.OnFocusReceivedEvent.Callback
        Callback(Obj)
    end
    
    return UIUtils.Handled
end

function M:OnAddedToFocusPath(InFocusEvent)
    if(self.OnAddedToFocusPathEvent)then
        local Obj = self.OnAddedToFocusPathEvent.Obj
        local Callback = self.OnAddedToFocusPathEvent.Callback
        local Params = self.OnAddedToFocusPathEvent.Params
        Callback(Obj,Params)
    end
end

function M:OnRemovedFromFocusPath(InFocusEvent)
    if(self.OnRemovedFromFocusPathEvent)then
        local Obj = self.OnRemovedFromFocusPathEvent.Obj
        local Callback = self.OnRemovedFromFocusPathEvent.Callback
        local Params = self.OnRemovedFromFocusPathEvent.Params
        Callback(Obj,Params)
    end
end

function M:Construct()
    if self.Node_Widget then
        self.Node_Widget:ClearChildren()
    end
    self.WidgetMap = {}
    self.Item.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor.OnMenuOpenChanged:Add(self,self.OnMenuOpenChanged)
end

function M:Destruct()
    self.Item.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor.OnMenuOpenChanged:Remove(self,self.OnMenuOpenChanged)
    --self.FirstTimeAdjustBackGroundInterval = nil
    for TaskName, _ in pairs(self.ComItemAsyncTasks or {}) do
        ForceStopAsyncTask(self,TaskName)
    end
    self.ComItemAsyncTasks = nil
    self.bMaxHeight = nil
end

function M:OnMenuOpenChanged(bIsOpen)
    self.Content.IsShowTips = bIsOpen
    self.Content.IsSelect = bIsOpen
    if(self.Event_OnMenuOpenChanged)then
        self.Event_OnMenuOpenChanged(self.Obj,bIsOpen,self.Content)
    end
end

function M:BindEventOnMenuOpenChanged(Obj, Callback)
    if not Obj or not Callback then
        return
    end
    local Event = {}
    Event.OnMenuOpenChanged = Callback
    self:BindEvents(Obj, Event)
end

function M:BindEvents(Obj,Events)
    Events = Events or {}
    self.Obj = Obj
    self.Event_OnMenuOpenChanged = Events.OnMenuOpenChanged
end

---@param WidgetPtr FWeakObjectPtr
function M:AddWidgetToNode(Widget, WidgetPtr)
    if not self.Node_Widget or (not Widget and not WidgetPtr) then
        return
    end
    if not self.WidgetMap then
        self.WidgetMap = {}
    end

    if Widget then
        if (nil == self.WidgetMap[Widget]) then
            local Slot = self.Node_Widget:AddChild(Widget)
            if (Slot ~= nil) then
                Slot:SetVerticalAlignment(EVerticalAlignment.HAlign_Fill)
                Slot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
            end
        end
        Widget:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.WidgetMap[Widget] = true
    end
    if WidgetPtr then
        if WidgetPtr:IsValid() then
            if (nil == self.WidgetMap[WidgetPtr]) then
                local Slot = self.Node_Widget:AddChild(WidgetPtr:Get())
                Slot:SetVerticalAlignment(EVerticalAlignment.HAlign_Fill)
                Slot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
            end
            WidgetPtr:Get():SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        end
        self.WidgetMap[WidgetPtr] = true
    end
end

---@param WidgetPtr FWeakObjectPtr
function M:RemoveWidgetFromNode(Widget, bForce, WidgetPtr)
    if not self.Node_Widget or (not Widget and not WidgetPtr) then
        return
    end
    if self.bDontRemoveSubWidget and (not bForce) then
        if Widget then
            Widget:SetVisibility(UIConst.VisibilityOp.Collapsed)
            -- value被弃用，统一设为true，防止其他地方将false误判为nil，导致重复创建
            self.WidgetMap[Widget] = true
        end
        if WidgetPtr then
            if WidgetPtr:IsValid() then
                WidgetPtr:Get():SetVisibility(UIConst.VisibilityOp.Collapsed)
            end
            self.WidgetMap[WidgetPtr] = true
        end
    else
        if Widget then
            if self.WidgetMap[Widget] then
                Widget:RemoveFromParent()
            end
            self.WidgetMap[Widget] = nil
        end
        if WidgetPtr then
            if self.WidgetMap[WidgetPtr] and WidgetPtr:IsValid() then
                WidgetPtr:Get():RemoveFromParent()
            end
            self.WidgetMap[WidgetPtr] = nil
        end
    end
end

--region 供Component重载的函数

--- 初始化各个系统道具框特有的表现
function M:InitCompView()
    self:InitCommonView()
    self.OwningList = UE4.UUserListEntryLibrary.GetOwningListView(self)
    if(self.OwningList)then
        self.OwningList.BP_OnItemClicked:Remove(self,self.OnOwningListItemClicked)
        self.OwningList.BP_OnItemClicked:Add(self,self.OnOwningListItemClicked)
    end
end

function M:OnOwningListItemClicked(Content)
    if(Content ~= self.Content) or self.NotInteractive then
        return
    end
    if(self.IsShowDetails)then
        self:OpenItemMenu()
    end
end

function M:OpenItemMenu()
    if self.Item.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor:IsOpen() then
        return
    end
    local Content = {Type= self.Content.Type, ItemType = self.ItemType, ItemId = self.Id, Uuid = self.Uuid, MenuPlacement = self.MenuPlacement, UIName = self.UIName,  bNotShowAccess = self.bNotShowAccess, bCustomStype = self.bCustomStype,KeyDownEvent = self.ItemDetailKeyDownEvent,HandleKeyDown = self.ItemDetailHandleKeyDown, bHideGamePad = self.bHideGamePad, JumpReturnCallBack = self.JumpReturnCallBack}
    self.Item.ItemDetails_MenuAnchor:OpenItemDetailsWidget(false, Content)
    if self.Item.ItemDetails_MenuAnchor.CommonItemDetails then
        self.Item.ItemDetails_MenuAnchor.CommonItemDetails:InitButtonEvent(self.ItemDetailsButton02EventInfo)
        self.Item.ItemDetails_MenuAnchor.CommonItemDetails:InitButton01Event(self.ItemDetailsButton01EventInfo)
        self.Item.ItemDetails_MenuAnchor.CommonItemDetails:InitLockedEvent(self.ItemDetailsLockEventInfo)
    end
end

function M:OpenWalnutRewardDialog()
    UIManager(self):LoadUINew("WalnutRewardDialog", self.Id, self.UIName)
end

--- 播放加载动画In
function M:PlayInAnimation()
end

--- 是否正在播放In动画
function M:IsInAnimationPlaying()
end

function M:OnAnimationFinished(InAnimation)
    if InAnimation == self.Click and not self.NotInteractive then

    end
end

--region 一些可选状态的设置方法

--- 供外部调用设置选中的方法
function M:SetSelected(IsSelected)
    if self.NotInteractive then
        return
    end
    if self.Content then 
        self.Content.IsSelect = IsSelected
    end

    self.Item:StopAllAnimations()
    if IsSelected then
        self.Item:PlayAnimation(self.Item.Click)
    else
        self.Item:PlayAnimation(self.Item.Normal)
    end 
end

---设置领取状态
---@param IsGot boolean @是否已领取
function M:SetIsGot(IsGot)
    local Callback = function(CoroutineObj)
        self.Content.bHasGot = IsGot
        if IsGot then
            if not self.WidgetMap[self.IsGotWidget] and not IsValid(self.IsGotWidget) then
                self.IsGotWidget = self:CreateWidgetAsync("ComItemHasGot",CoroutineObj)
            end
            self:AddWidgetToNode(self.IsGotWidget)
        elseif self.WidgetMap[self.IsGotWidget] then
            self:RemoveWidgetFromNode(self.IsGotWidget)
        end 
    end
    if IsGot then
        self:AsyncLoadWidgetCommon("IsGotWidget", "SetIsGotTask", Callback)
    else
        Callback()
    end
end

---设置可领取状态
---@param IsCanGet boolean @是否可领取
---@param StyleStr string 可选项有：Gold,White,Purple,Blue
function M:SetIsCanGet(IsCanGet, StyleStr)
    local Callback = function(CoroutineObj)
        self.Content.bCanGet = IsCanGet
        self.Content.CanGetStyle = StyleStr
        if IsCanGet then
            if not self.WidgetMap[self.CanGetWidget] and not IsValid(self.CanGetWidget) then
                self.CanGetWidget = self:CreateWidgetAsync("ComItemCanGet",CoroutineObj)
            end
			self:AddWidgetToNode(self.CanGetWidget)
            self.CanGetWidget:SetStyle(StyleStr)
        elseif self.WidgetMap[self.CanGetWidget] then
            self:RemoveWidgetFromNode(self.CanGetWidget)
        end 
    end
    if IsCanGet then
        self:AsyncLoadWidgetCommon("CanGetWidget", "SetIsCanGetTack", Callback)
    else
        Callback()
    end
end

---设置锁定表示
---@param LockType number @锁定类型 0：取消锁定显示 1：右上角 2：中心
function M:SetLock(LockType)
    self:AsyncLoadWidgetCommon(nil , "SetLockTack", function(CoroutineObj)
        if LockType ~= 1  then
            self:RemoveGroupWidget("ComItemLock")
        end
        if self.WidgetMap[self.LockedCenterWidget] and LockType ~= 2 then
            self:RemoveWidgetFromNode(self.LockedCenterWidget)
        end
        if LockType == 1 then
            self.LockedRightWidget = self:GetOrCreateGroupWidget("ComItemLock", CoroutineObj)
        elseif LockType == 2 then
            if not self.LockedCenterWidget then
                self.LockedCenterWidget = self:CreateWidgetAsync("ComItemLockCenter",CoroutineObj)
            end
            self:AddWidgetToNode(self.LockedCenterWidget)
        end
    end)
end

---设置Item数量
---@param Count number @数量
---@param NeedCount number @所需数量
---@param MaxCount number @最大数量
---@param bNotCountFormat boolean @是否格式化显示数字
---@param bShowNotHaveStyle boolean @是否需要数量为0时候显示未拥有样式
function M:SetCount(Count, NeedCount, MaxCount, bNotCountFormat, bShowNotHaveStyle)
    local Callback = function(CoroutineObj)
        if self.WidgetMap[self.CountWidget] then
            self:RemoveWidgetFromNode(self.CountWidget, true)
            self:ClearBackGroundHeight(true)
        end
        if DataMgr.RewardType[self.ItemType] and DataMgr.RewardType[self.ItemType].UniqueType then
            return
        end
        if not Count then
            self:ClearBackGroundHeight(true)
            return
        end
        local bCountFormat = not bNotCountFormat
        --- 所需数量，Count / NeedCount
        if NeedCount then
            self.CountWidget = self:CreateWidgetAsync("ComItemNeedCount",CoroutineObj)
            self.CountWidget.Text_Hold:SetText(FormatNumber(Count, bCountFormat))
            self.CountWidget.Text_Total:SetText("/" .. tostring(FormatNumber(NeedCount, bCountFormat)))
            if (Count >= NeedCount) or self.CountTextWhite then
                self.CountWidget.Text_Hold:SetColorAndOpacity(UE4.UUIFunctionLibrary.StringToSlateColor("FFFFFFFF"))
            else
                self.CountWidget.Text_Hold:SetColorAndOpacity(UE4.UUIFunctionLibrary.StringToSlateColor("D82E30FF")) 
            end
        --- 最大数量，Min ~ Max
        elseif MaxCount then
            self.CountWidget = self:CreateWidgetAsync("ComItemNumber",CoroutineObj)
            local NumStr = FormatNumber(Count, bCountFormat)
            NumStr = NumStr .. "~" .. FormatNumber(MaxCount, bCountFormat)
            self.CountWidget.Text_Num:SetText(NumStr)
        elseif Count then
            self.CountWidget = self:CreateWidgetAsync("ComItemNumber",CoroutineObj)
            local NumStr = FormatNumber(Count, bCountFormat)
            self.CountWidget.Text_Num:SetText(NumStr)
            if self.CountTextRed then
                self.CountWidget.Text_Num:SetColorAndOpacity(UE4.UUIFunctionLibrary.StringToSlateColor("D82E30FF"))
            end
        end
        -- Fix 2025.6.24 蓝图说后续这个控件删了不用了
        -- self.CountWidget.Spacer_Switch:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        -- if not self.Rarity or self.Rarity < 1 or self.Rarity > 5 then
        --     self.CountWidget.Spacer_Switch:SetVisibility(ESlateVisibility.Collapsed)
        -- end
        if (bShowNotHaveStyle and Count <= 0) then
            self:SetItemGreyStyle(self.CountWidget, true)
        else
            self:SetItemGreyStyle(self.CountWidget, false)
        end
        if self.ItemType ~= "Walnut" or not self.Count or self.Count > 0 then
            self:AddWidgetToNode(self.CountWidget)
        else
            self:SetItemGreyStyle(self.CountWidget, true)
        end
        self:AdjustBackGroundHeight(self.CountWidget, "SetCount  "..Count)
    end

    if self.bAllUseAsyncLoadWidget then
        self:AsyncLoadWidgetCommon(nil , "SetCountTask",Callback)
    else
        Callback()
    end
end

---设置额外奖励显示状态
---@param BonusType number  @参数: 1、额外奖励  2、首通奖励标识  3、核桃奖励标识
function M:SetBonus(BonusType, ExtraText)
    self:AsyncLoadWidgetCommon(nil , "SetBonusTask", function(CoroutineObj)
        if self.WidgetMap[self.BonusWidget] then
            self:RemoveWidgetFromNode(self.BonusWidget)
        end
        if not BonusType or BonusType == 0 then
            return
        end
        if BonusType == 1 then
            self.BonusWidget = self:CreateWidgetAsync("ComItemBonus",CoroutineObj)
            if not ExtraText then 
                ExtraText = GText("UI_Reward_Bonus")
            end
            self.BonusWidget.Text_Bonus:SetText(ExtraText)
        elseif BonusType == 2 then
            self.BonusWidget = self:CreateWidgetAsync("ComItemBonus",CoroutineObj)
            if not ExtraText then
                ExtraText = GText("UI_Dungeon_First_Reward_Tag")
            end
            self.BonusWidget.Text_Bonus:SetText(ExtraText)
        elseif BonusType == 3 then
            self.BonusWidget = self:CreateWidgetAsync("ComItemWalnutTag",CoroutineObj)
        end
        self:AddWidgetToNode(self.BonusWidget)
    end)
end

---设置道具框名称
---@param Name string  @道具框名称
function M:SetName(Name)
    self:AsyncLoadWidgetCommon("NameWidget" , "SetNameTask", function(CoroutineObj)
        if Name then
            if not self.WidgetMap[self.NameWidget] and not IsValid(self.NameWidget) then
                self.NameWidget = self:CreateWidgetAsync("ComItemName",CoroutineObj)
            end
            if (type(Name) == "number") then
                self.NameWidget.Text_Name:SetText(Name)
            else
                self.NameWidget.Text_Name:SetText(GText(Name))
            end
            self:AddWidgetToNode(self.NameWidget)
            self:AdjustBackGroundHeight(self.NameWidget, "SetName   "..Name)
        elseif self.WidgetMap[self.NameWidget] then
            self:RemoveWidgetFromNode(self.NameWidget)
            self:ClearBackGroundHeight(true)
        end
    end)
end

---设置道具框名称
---@param Level number  @道具框等级
function M:SetLevel(Level)
    local Callback = function(CoroutineObj)
        --等级标记提前，不然会有层级bug
        if not self.WidgetMap[self.LevelWidget] and not IsValid(self.LevelWidget) then
            self.LevelWidget = self:CreateWidgetAsync("ComItemLevel",CoroutineObj)
        end
        if Level then
            self.LevelWidget.Text_Lv:SetText(Level)
            self.LevelWidget:SetVisibility(UIConst.VisibilityOp.Visible)
            self:AdjustBackGroundHeight(self.LevelWidget, "SetLevel  "..Level)
            self:AddWidgetToNode(self.LevelWidget)
        elseif self.WidgetMap[self.LevelWidget] then
            self:RemoveWidgetFromNode(self.LevelWidget)
            self:ClearBackGroundHeight(true)
        end
    end
    if self.bAllUseAsyncLoadWidget then
        self:AsyncLoadWidgetCommon("LevelWidget" , "SetLevelTask", Callback)
    else
        Callback()
    end
end

---设置红点
---@param RedDotType RedDotType  @参数 UIConst.RedDotType.CommonRedDot(正常红点) UIConst.RedDotType.NewRedDot(New红点) UIConst.RedDotType.GreyRedDot(灰色红点暂未支持)
function M:SetRedDot(RedDotType)
    self:AsyncLoadWidgetCommon(nil , "SetRedDotTask", function(CoroutineObj)
        if self.WidgetMap[self.ComItemReddot] then
            self:RemoveWidgetFromNode(self.ComItemReddot)
        end
        if self.WidgetMap[self.ComItemNewReddot] then
            self:RemoveWidgetFromNode(self.ComItemNewReddot)
        end
        if RedDotType == UIConst.RedDotType.CommonRedDot then
            if not self.ComItemReddot then
                self.ComItemReddot = self:CreateWidgetAsync("ComItemReddot",CoroutineObj)
            end
            self:AddWidgetToNode(self.ComItemReddot)
            self:CheckWidgetIsTop(self.ComItemReddot)
        elseif RedDotType == UIConst.RedDotType.NewRedDot then
            if not self.ComItemNewReddot then
                self.ComItemNewReddot = self:CreateWidgetAsync("ComItemNewReddot",CoroutineObj)
            end
            self:AddWidgetToNode(self.ComItemNewReddot)
            self:CheckWidgetIsTop(self.ComItemNewReddot)
        elseif RedDotType == UIConst.RedDotType.GreyRedDot then
            if not self.ComItemReddot then
                self.ComItemReddot = self:CreateWidgetAsync("ComItemReddot",CoroutineObj)
            end
            self.ComItemReddot:EMShowReddot(true, EReddotType.Gray)
            self:AddWidgetToNode(self.ComItemReddot)
            self:CheckWidgetIsTop(self.ComItemReddot)
        end
    end)
end
--- 置灰态
function M:SetShadow(bShadow)
    self:AsyncLoadWidgetCommon(nil , "SetShadowTask", function(CoroutineObj)
        if self.WidgetMap[self.ShadowWidget] then
            self:RemoveWidgetFromNode(self.ShadowWidget, true)
        end
        if bShadow then
            if not self.WidgetMap[self.ShadowWidget] and not IsValid(self.ShadowWidget) then
                self.ShadowWidget = self:CreateWidgetAsync("ComItemShadow",CoroutineObj)
            end
            self:AddWidgetToNode(self.ShadowWidget)
        end
    end)
end
--- 剪影态
function M:SetOutline(bOutline)
    self.Item:SetIconShadow(bOutline)
end

--- 显示为加号状态道具框
function M:SetAdd(bAdd)
    if bAdd then
        local Callback = function(CoroutineObj)
            local DynamicMaterial = self.Item.Item_BG:GetDynamicMaterial()
            self:SetRarity(0)
            DynamicMaterial:SetScalarParameterValue("IconOpacity", 0)
            self.Item.WidgetSwitcher_State:SetActiveWidgetIndex(0)
            if not self.AddWidget then
                self.AddWidget = self:CreateWidgetAsync("ComItemAdd",CoroutineObj)
            end
            self:AddWidgetToNode(self.AddWidget)
            self:ClearBackGroundHeight(true)
        end
        if self.bAllUseAsyncLoadWidget then
            self:AsyncLoadWidgetCommon(nil , "SetAddTask", Callback)
        else
            Callback()
        end
    end
end

--- 显示选择数量
function M:SetSelectNum(SelectNeedCount, SelectTotalCount)
    local Callback = function(CoroutineObj)
        if SelectNeedCount or SelectTotalCount then
            if not self.WidgetMap[self.SelectCountWidget] and not IsValid(self.SelectCountWidget) then
                self.SelectCountWidget = self:CreateWidgetAsync("ComItemSelectCount",CoroutineObj)
            end
            self.SelectCountWidget.Text_Hold:SetText(SelectNeedCount)
            self.SelectCountWidget.Text_Total:SetText(SelectTotalCount)
            self:AddWidgetToNode(self.SelectCountWidget)
            if not (SelectNeedCount and SelectTotalCount) then
                self.SelectCountWidget.Split_1:SetVisibility(ESlateVisibility.Collapsed)
            else
                self.SelectCountWidget.Split_1:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            end
        elseif self.WidgetMap[self.SelectCountWidget] then
            self:RemoveWidgetFromNode(self.SelectCountWidget)
        end
    end
    if self.bAllUseAsyncLoadWidget then
        self:AsyncLoadWidgetCommon("SelectCountWidget" , "SetSelectNumTask", Callback)
    else
        Callback()
    end
end

--- 显示武器的魅影装备标识
function M:SetWeaponPhantomIcon(Uuid)
    self:AsyncLoadWidgetCommon(nil , "SetWeaponPhantomIconTask", function(CoroutineObj)
        if self.WidgetMap[self.PhantomTagWidget] then
            self:RemoveWidgetFromNode(self.PhantomTagWidget)
        end
        if not Uuid then
            return
        end
        local Avatar = GWorld:GetAvatar()
        if (Uuid and type(Uuid) == "string" and not CommonUtils.IsObjId(Uuid)) then
            Uuid = CommonUtils.Str2ObjId(Uuid)
        end
        local Weapon = Uuid and Avatar.Weapons[Uuid]
        local AssisterId = Weapon and Weapon.AssisterId
        if (AssisterId and DataMgr.Resource[AssisterId]) then
            self.PhantomTagWidget = self:CreateWidgetAsync("ComItemPhantomTag",CoroutineObj)
            self.PhantomTagWidget.Switch_Type:SetActiveWidgetIndex(1)
            local CharId = DataMgr.Resource[AssisterId].UseParam
            self:LoadTextureAsync(UIUtils.GetCharMiniIconPath(CharId),function(Texture)
                self.PhantomTagWidget.Img_Role:SetBrushFromTexture(Texture)
            end, "SetWeaponPhantomIcon_LoadIcon")
            self:AddWidgetToNode(self.PhantomTagWidget)
        end
    end)
end

--- 显示武器临时装备的角色头像
function M:SetWeaponMiniPhantomIcon(CharId)
    self:AsyncLoadWidgetCommon(nil , "SetWeaponMiniPhantomIconTask", function(CoroutineObj)
        if self.WidgetMap[self.PhantomTagWidget] then
            self:RemoveWidgetFromNode(self.PhantomTagWidget)
        end

        if CharId then
            self.PhantomTagWidget = self:CreateWidgetAsync("ComItemPhantomTag",CoroutineObj)
            self.PhantomTagWidget.Switch_Type:SetActiveWidgetIndex(1)
            self:LoadTextureAsync(UIUtils.GetCharMiniIconPath(CharId),function(Texture)
                self.PhantomTagWidget.Img_Role:SetBrushFromTexture(Texture)
            end, "SetWeaponMiniPhantomIcon_LoadIcon")
            self:AddWidgetToNode(self.PhantomTagWidget)
        end
    end)
end

--- 设置道具框透明度
function M:SetItemGreyStyle(NumWidget, bShowGrey)
    if (bShowGrey) then
        NumWidget:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self:SetRenderOpacity(0.6)
    else
        NumWidget:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self:SetRenderOpacity(1.0)
    end
end

--- 设置冲突标识
function M:SetItemConflict(bConflict)
    self:_SetItemConflictImpl(bConflict, GText("UI_Armory_Conflict"))
end

function M:_SetItemConflictImpl(bConflict, Text)
    local Callback = function(CoroutineObj)
        if bConflict then
            if not self.WidgetMap[self.ConflictWidget] and not IsValid(self.ConflictWidget)  then
                self.ConflictWidget = self:CreateWidgetAsync("ComItemConflict", CoroutineObj)
            end
            self.ConflictWidget.Text_SoldOut:SetText(Text)
            self:AddWidgetToNode(self.ConflictWidget)
        elseif self.WidgetMap[self.ConflictWidget] then
            self:RemoveWidgetFromNode(self.ConflictWidget)
        end
        -- 将右上角的红点移动到最上层 此时是只移动普通样式的红点，之后有需要再加上其他的
        self:CheckWidgetIsTop(self.ComItemReddot)
    end
    if self.bAllUseAsyncLoadWidget then
        self:AsyncLoadWidgetCommon("ConflictWidget" , "SetItemConflictTask", Callback)
    else
        Callback()
    end
end

function M:SetItemSold(bSold)
    self:AsyncLoadWidgetCommon("SoldWidget" , "SetItemSoldTask", function(CoroutineObj)
        if bSold then
            if not self.WidgetMap[self.SoldWidget] and not IsValid(self.SoldWidget) then
                self.SoldWidget = self:CreateWidgetAsync("ComItemConflict", CoroutineObj)
            end
            self.SoldWidget.Text_SoldOut:SetText(GText("UI_Fishing_BuyFishingLure"))
            self:AddWidgetToNode(self.SoldWidget)
        elseif self.WidgetMap[self.SoldWidget] then
            self:RemoveWidgetFromNode(self.SoldWidget)
        end
    end)
end

--- 设置减少标识
function M:SetItemMinus(bMinus)
    local Callback = function(CoroutineObj)
        if bMinus then
            if not self.WidgetMap[self.MinusWidget] and not IsValid(self.MinusWidget) then
                self.MinusWidget = self:CreateWidgetAsync("ComItemMinus", CoroutineObj)
            end
            self:AddWidgetToNode(self.MinusWidget)
        elseif self.WidgetMap[self.MinusWidget] then
            self:RemoveWidgetFromNode(self.MinusWidget, true)
        end
    end
    if self.bAllUseAsyncLoadWidget then
        self:AsyncLoadWidgetCommon("MinusWidget" , "SetItemMinusTask", Callback)
    else
        Callback()
    end
end

--- 设置货币和价格标识
function M:SetItemMoney(CurrencyId, CurrencyNum, bShowAfterLoadComplete, CurrencyIcon)
    local Callback = function(CoroutineObj)
        if (CurrencyId or CurrencyIcon) and CurrencyNum then
            self.MoneyWidget = self:GetOrCreateGroupWidget("ComItemMoney", CoroutineObj)
            if (bShowAfterLoadComplete) then
                self.MoneyWidget.Img_Coin:SetVisibility(ESlateVisibility.Collapsed)
                self.MoneyWidget.Text_Cost:SetVisibility(ESlateVisibility.Collapsed)
            end
            local IconPath = nil
            if CurrencyIcon then
                IconPath = CurrencyIcon
            else
                IconPath = DataMgr.Resource[CurrencyId].Icon
            end
            self:LoadTextureAsync(IconPath,function(Texture)
                self.MoneyWidget.Img_Coin:SetBrushResourceObject(Texture)
                self.MoneyWidget.Text_Cost:SetText(CurrencyNum)
                if (bShowAfterLoadComplete) then
                    self.MoneyWidget.Img_Coin:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
                    self.MoneyWidget.Text_Cost:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
                end
            end, "SetItemMoney_LoadIcon")
        else
            self:RemoveGroupWidget("ComItemMoney")
        end
    end
    if self.bAllUseAsyncLoadWidget then
        self:AsyncLoadWidgetCommon("MoneyWidget" , "SetItemMoneyTask", Callback)
    else
        Callback()
    end
end


--- 设置选择标识
function M:SetItemSelect(bSelect)
    local Callback = function(CoroutineObj)
        if bSelect then
            if not self.WidgetMap[self.SelectWidget] and not IsValid(self.SelectWidget) then
                self.SelectWidget = self:CreateWidgetAsync("ComItemSelect",CoroutineObj)
            end
            self:AddWidgetToNode(self.SelectWidget)
        elseif self.WidgetMap[self.SelectWidget] then
            self:RemoveWidgetFromNode(self.SelectWidget)
        end
    end
    if self.bAllUseAsyncLoadWidget then
        self:AsyncLoadWidgetCommon("SelectWidget" , "SetItemSelectTask", Callback)
    else
        Callback()
    end
end

--- 设置放置标识
function M:SetItemSet(bSet, TipText)
    self:AsyncLoadWidgetCommon("SetWidget" , "SetItemSetTask", function(CoroutineObj)
        if bSet then
            if not self.WidgetMap[self.SetWidget] and not IsValid(self.SetWidget) then 
                self.SetWidget = self:CreateWidgetAsync("ComItemSet",CoroutineObj)
            end
            self:AddWidgetToNode(self.SetWidget)
            self.SetWidget.TipText:SetText(TipText or GText("UI_SHOWNPC_SETTLED"))
        elseif self.WidgetMap[self.SetWidget] then
            self:RemoveWidgetFromNode(self.SetWidget)
        end
    end)
end

--- 设置未揭示标识
function M:SetItemUnrevealed(bUnrevealed)
    self:AsyncLoadWidgetCommon("UnrevealedWidget" , "SetItemUnrevealedTask", function(CoroutineObj)
        if bUnrevealed then
            if not self.WidgetMap[self.UnrevealedWidget] and not IsValid(self.UnrevealedWidget) then 
                self.UnrevealedWidget = self:CreateWidgetAsync("ComItemUnreveal",CoroutineObj)
            end
            self:AddWidgetToNode(self.UnrevealedWidget)
        elseif self.WidgetMap[self.UnrevealedWidget] then
            self:RemoveWidgetFromNode(self.UnrevealedWidget)
        end
    end)
end

--- 设置同卡等级
function M:SetItemLevelCard(LevelCardNum)
    self:AsyncLoadWidgetCommon("LevelCardWidget" , "SetItemLevelCardTask", function(CoroutineObj)
        if LevelCardNum then
            self.LevelCardWidget = self:GetOrCreateGroupWidget("ComItemCardLevel", CoroutineObj)
            self.LevelCardWidget.Text_Level:SetText(LevelCardNum)
            local CardLevelData = DataMgr.WeaponCardLevel[self.Id]
            if (CardLevelData and LevelCardNum >= CardLevelData.CardLevelMax) then
                self.LevelCardWidget:SetMaxGradeLevelColor()
            else
                self.LevelCardWidget:SetNormalGradeLevelColor()
            end
        else
            self:RemoveGroupWidget("ComItemCardLevel")
        end
    end)
end

function M:SetItemStartLevel(StartLevelNum)
    self:AsyncLoadWidgetCommon("StartLevelWidget" , "SetItemStartLevelTask", function(CoroutineObj)
        if StartLevelNum then
            self.StartLevelWidget = self:GetOrCreateGroupWidget("ComItemStartLevel", CoroutineObj)
            self.StartLevelWidget.Text_StarLevel:SetText(StartLevelNum)
        else
            self:RemoveGroupWidget("ComItemStartLevel")
        end
    end)
end

---设置魅影装备标记
function M:SetPhantomWeaponIcon(UnitId, IsPhantom)
    local Callback = function(CoroutineObj)
        if IsPhantom then
            if not self.WidgetMap[self.PhantomWidget] and not IsValid(self.PhantomWidget) then
                self.PhantomWidget = self:CreateWidgetAsync("ComItemPhantomTag",CoroutineObj)
            end
            local Avatar = GWorld:GetAvatar()
            local resource = Avatar.Resources[UnitId]
            local WeaponUuid = resource and resource.WeaponUuid
            local IconPath = '/Game/UI/Texture/Static/Atlas/Armory/T_Armory_ArmedPhantom.T_Armory_ArmedPhantom'
            if(WeaponUuid)then
                local Weapon = Avatar.Weapons[WeaponUuid]
                if(Weapon)then
                    IconPath = DataMgr.Weapon[Weapon.WeaponId].Icon
                end
            end
            self:LoadTextureAsync(IconPath, function(IconImage)
                self.PhantomWidget.Img_Phantom_On:SetBrushResourceObject(IconImage)
            end, "SetPhantomWeaponIcon_LoadIcon")
            self:AddWidgetToNode(self.PhantomWidget)
        elseif self.WidgetMap[self.PhantomWidget] then
            self:RemoveWidgetFromNode(self.PhantomWidget)
        end
    end
    if self.bAllUseAsyncLoadWidget then
        self:AsyncLoadWidgetCommon("PhantomWidget" , "SetPhantomWeaponIconTask", Callback)
    else
        Callback()
    end
end

-- 设置右上角属性图标
function M:SetAttrIcon(AttrIcon)
    self:AsyncLoadWidgetCommon("AttrIconWidget" , "SetAttrIconTask", function(CoroutineObj)
        if AttrIcon then
            if not self.WidgetMap[self.AttrIconWidget] and not IsValid(self.AttrIconWidget) then
                self.AttrIconWidget = self:CreateWidgetAsync("ComItemAttributeTag",CoroutineObj)
            end
            if(type(AttrIcon) == "string")then
                self:LoadTextureAsync(AttrIcon, function(Texture)
                    self.AttrIconWidget.Attribute:SetBrushResourceObject(Texture)
                end, "SetAttrIcon_LoadIcon")
            else
                self.AttrIconWidget.Attribute:SetBrushResourceObject(AttrIcon)
            end
            self:AddWidgetToNode(self.AttrIconWidget)
        elseif self.WidgetMap[self.AttrIconWidget] then
            self:RemoveWidgetFromNode(self.AttrIconWidget)
        end
    end)
end

-- 设置队伍标识(大秘境)
function M:SetTeamIcon(TeamIdx, CharId)
    self:AsyncLoadWidgetCommon(nil , "SetTeamIconTask", function(CoroutineObj)
        if not TeamIdx then
            if self.WidgetMap[self.TeamWidget] then
                self:RemoveWidgetFromNode(self.TeamWidget)
            end
            if self.WidgetMap[self.TeamCharWidget] then
                self:RemoveWidgetFromNode(self.TeamCharWidget)
            end
            self.Content.TeamIdx = nil
            self.Content.TeamCharId = nil
            return
        end
        -- 若CharId不为空，左上角设置装备角色头像
        if not CharId then
            if self.WidgetMap[self.TeamCharWidget] then
                self:RemoveWidgetFromNode(self.TeamCharWidget)
            end
        else
            if not self.WidgetMap[self.TeamCharWidget] and not IsValid(self.TeamCharWidget) then
                self.TeamCharWidget = self:CreateWidgetAsync("ComItemPhantomTag", CoroutineObj)
            end
            self.TeamCharWidget.Switch_Type:SetActiveWidgetIndex(1)
            local MiniIconPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/Head/Mini/"
            local PhantomGuideIconImg = "T_Normal_"..DataMgr.BattleChar[CharId].GuideIconImg
            local IconPath = MiniIconPath..PhantomGuideIconImg.."."..PhantomGuideIconImg.."'"
            self:LoadTextureAsync(IconPath, function(Texture)
                self.TeamCharWidget.Img_Role:SetBrushResourceObject(Texture)
            end, "SetTeamIcon_LoadIcon")
            self:AddWidgetToNode(self.TeamCharWidget)
        end
        if not self.WidgetMap[self.TeamWidget] and not IsValid(self.TeamWidget) then
            self.TeamWidget = self:CreateWidgetAsync("ComItemAbyssTeam", CoroutineObj)
        end
        local Color = self.TeamWidget["Color_BG_"..TeamIdx]
        if Color then
            self.TeamWidget.BG:SetColorAndOpacity(Color)
        end
        self:AddWidgetToNode(self.TeamWidget)
    end)
end

function M:SetRareTag(bRare)
    self:AsyncLoadWidgetCommon("RareWidget" , "SetRareTagTask", function(CoroutineObj)
        if bRare then
            if not self.WidgetMap[self.RareWidget] and not IsValid(self.RareWidget) then
                self.RareWidget = self:CreateWidgetAsync("ComItemRareTag",CoroutineObj)
            end
            self:AddWidgetToNode(self.RareWidget)
        elseif self.WidgetMap[self.RareWidget] then
            self:RemoveWidgetFromNode(self.RareWidget)
        end
    end)
end

function M:SetInGear(bInGear)
    self:AsyncLoadWidgetCommon("InGearWidget" , "SetInGearTask", function(CoroutineObj)
        if bInGear then
            if not self.WidgetMap[self.InGearWidget] and not IsValid(self.InGearWidget) then
                self.InGearWidget = self:CreateWidgetAsync("ComItemInGear",CoroutineObj)
            end
            self:AddWidgetToNode(self.InGearWidget)
        elseif self.WidgetMap[self.InGearWidget] then
            self:RemoveWidgetFromNode(self.InGearWidget)
        end
    end)
end

function M:SetTryOutText(TryOutText)
    self:AsyncLoadWidgetCommon("TryOutWidget" , "SetTryOutTextTask", function(CoroutineObj)
        if TryOutText then
            if not self.WidgetMap[self.TryOutWidget] and not IsValid(self.TryOutWidget) then
                self.TryOutWidget = self:CreateWidgetAsync("ComItemTryOut",CoroutineObj)
            end
            self.TryOutWidget.TipText:SetTexT(GText(TryOutText))
            self:AddWidgetToNode(self.TryOutWidget)
        else
            self:RemoveWidgetFromNode(self.TryOutWidget)
        end
    end)
end

function M:SetSquadBuildTryOutText(SquadBuildTryOutText)
    self:AsyncLoadWidgetCommon("SquadBuildTryOutWidget" , "SetSquadBuildTryOutTextTask", function(CoroutineObj)
        if SquadBuildTryOutText then
            if not self.WidgetMap[self.SquadBuildTryOutWidget] and not IsValid(self.SquadBuildTryOutWidget) then
                self.SquadBuildTryOutWidget = self:CreateWidgetAsync("ComItemSquadBuildTryOut",CoroutineObj)
            end
            self.SquadBuildTryOutWidget.Text_TryOut:SetText(GText(SquadBuildTryOutText))
            self.SquadBuildTryOutWidget.SizeBox_TryOut:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
            self:AddWidgetToNode(self.SquadBuildTryOutWidget)
        else
            self:RemoveWidgetFromNode(self.SquadBuildTryOutWidget)
        end
    end)
end

--region 宠物相关
--宠物道具框的炫彩背景
function M:SetPetPremium(bPremium)
    local Callback = function(CoroutineObj)
        if not self.Item then 
            DebugPrint(ErrorTag, "SetPetPremium::没有Item控件不符合通用道具框结构")
            return 
        end
        local Item_BG = self.Item.Item_BGPanel or self.Item.Item_BG
        local DynamicMat = Item_BG:GetDynamicMaterial()
        if bPremium then
            DynamicMat:SetScalarParameterValue("Colorful_Alpha", self.Item.Colorful_Pet)
            if not self.WidgetMap[self.PetRareWidget] and not IsValid(self.PetRareWidget)  then
                self.PetRareWidget = self:CreateWidgetAsync("ComItemPetRare",CoroutineObj)
            end
            self:AddWidgetToNode(self.PetRareWidget)
        else 
            DynamicMat:SetScalarParameterValue("Colorful_Alpha", self.Item.Colorful_Normal)
        end
    end

    self:AsyncLoadWidgetCommon("PetRareWidget", "SetPetPremiumTask", Callback)
end

local USE_ASYNC = false  --- 一键退化为同步加载

---@param WidgetName string 如果Callback回调里面有防重复生成widget的逻辑，添加这个参数可以防止重复生成协程，节省一点性能
---@param TaskName string 协程任务Id，确保不要跟任何对象中的成员重名
---@param Callback fun 回调
function M:AsyncLoadWidgetCommon(WidgetName, TaskName, Callback)
    if not self.ComItemAsyncTasks then
        self.ComItemAsyncTasks = {}
    end
    if USE_ASYNC and (not WidgetName or not self.WidgetMap[self[WidgetName]] or not IsValid(self[WidgetName])) then
        self.ComItemAsyncTasks[TaskName] = 1
        ForceStopAsyncTask(self, TaskName)
        local CallbackWrapper = function(CoroutineObj)
            Callback(CoroutineObj)
            self.ComItemAsyncTasks[TaskName] = nil
        end
        RunAsyncTask(self, TaskName, CallbackWrapper)
    else
        Callback()
    end
end

function M:SetPetEntryId(PetEntries)
    local Callback = function(CoroutineObj)
        if(PetEntries)then
            if not self.WidgetMap[self.PetEntryIdWidget] and not IsValid(self.PetEntryIdWidget) then
                self.PetEntryIdWidget = self:CreateWidgetAsync("ComItemPetEntry",CoroutineObj)
            end
            self:AddWidgetToNode(self.PetEntryIdWidget)
            if(self.PetEntryIdWidget)then
                if type(PetEntries) == "number" then
                    self.PetEntryIdWidget.WBP_Armory_Pet_EntryTag:InitByPetEntryId(PetEntries)
                    for _, OtherWidget in pairs(self.PetEntryIdWidget.Panel_PetEntryTag:GetAllChildren()) do
                        if OtherWidget ~= self.PetEntryIdWidget.WBP_Armory_Pet_EntryTag then
                            OtherWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
                        end
                    end
                else
                    local Len = #PetEntries
                    for i, PetEntryId in pairs(PetEntries) do
                        if self.PetEntryIdWidget.Panel_PetEntryTag:GetChildrenCount() < i then
                            local NewEntryTag = self:CreateWidgetAsync(nil, CoroutineObj, '/Game/UI/WBP/Armory/Widget/Pet/WBP_Armory_Pet_EntryTag.WBP_Armory_Pet_EntryTag')
                            self.PetEntryIdWidget.Panel_PetEntryTag:AddChild(NewEntryTag)
                        end
                        local EntryTag = self.PetEntryIdWidget.Panel_PetEntryTag:GetChildAt(i-1)
                        EntryTag:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
                        EntryTag:InitByPetEntryId(PetEntryId, Len>1)
                    end
                    for i = Len, self.PetEntryIdWidget.Panel_PetEntryTag:GetChildrenCount()-1 do
                        local OtherWidget= self.PetEntryIdWidget.Panel_PetEntryTag:GetChildAt(i)
                        OtherWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
                    end
                end
            end
            if self:IsExistTimer(self.AdjustBGTimer) then
                self:RemoveTimer(self.AdjustBGTimer)
            end
            self:DefaultBackGroundHeight()
        else
            self:RemoveWidgetFromNode(self.PetEntryIdWidget)
            self:ClearBackGroundHeight(true)
        end
    end

    self:AsyncLoadWidgetCommon("PetEntryIdWidget", "SetPetEntryIdTask", Callback)
end

---设置宠物星级
function M:SetPetStarLevel(PetStarLevel)
    local Callback = function(CoroutineObj)
        if not self.Item then
            DebugPrint(ErrorTag, "SetPetStarLevel::没有Item控件不符合通用道具框结构")
            return
        end
        if PetStarLevel >0 then
            if not self.WidgetMap[self.PetStarLevelWidget] and not IsValid(self.PetStarLevelWidget) then
                self.PetStarLevelWidget = self:CreateWidgetAsync("ComItemPetStarLevel",CoroutineObj)
            end
            self:AddWidgetToNode(self.PetStarLevelWidget)
            for i=1, self.PetStarLevelWidget.Panel_PetStar:GetChildrenCount() do
                local PetStar = self.PetStarLevelWidget["PetStar_"..i]
                if i <=PetStarLevel then
                    PetStar.PetStar:SetActiveWidgetIndex(1)
                else
                    PetStar.PetStar:SetActiveWidgetIndex(0)
                end
            end
        else
            self:RemoveWidgetFromNode(self.PetStarLevelWidget)
        end
    end

    self:AsyncLoadWidgetCommon("PetStarLevelWidget", "SetPetStarLevelTask", Callback)
end
--endregion

--region Mod相关
--- 设置极性和极性值
function M:SetItemPolarity(Polarity, PolarityNum)
    local Callback = function(CoroutineObj)
        if Polarity and (Polarity~=CommonConst.NonePolarity or PolarityNum) then
            if not self.WidgetMap[self.PolarityWidget] and not IsValid(self.PolarityWidget) then
                self.PolarityWidget = self:CreateWidgetAsync("ComItemPolarity",CoroutineObj)
            end
            self.PolarityWidget:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
            local PolarityChar = DataMgr.ModPolarity[Polarity].Char
            if PolarityChar and Polarity ~= CommonConst.NonePolarity then
                self.PolarityWidget.Icon_Polarity:SetText(PolarityChar)
                self.PolarityWidget.Icon_Polarity:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            else
                self.PolarityWidget.Icon_Polarity:SetVisibility(ESlateVisibility.Collapsed)
            end
            self.PolarityWidget.Text_Polarity:SetText(PolarityNum)
            self:AddWidgetToNode(self.PolarityWidget)
        elseif self.WidgetMap[self.PolarityWidget] then
            self:RemoveWidgetFromNode(self.PolarityWidget)
        end
    end

    if self.bAllUseAsyncLoadWidget then
        self:AsyncLoadWidgetCommon("PolarityWidget", "SetItemPolarityTask", Callback)
    else
        Callback()
    end
end

function M:SetAura(bAura)
    local Callback = function(CoroutineObj)
        if self.ItemType == "Mod" and bAura == nil then
            local HaloMod = DataMgr.Mod[self.Id]
            if HaloMod and HaloMod.ApplySlot and #HaloMod.ApplySlot == 1 and HaloMod.ApplySlot[1] == 9 then
                bAura = true
            end
        end
        if bAura then
            if not self.WidgetMap[self.AuraWidget] and not IsValid(self.AuraWidget) then
                self.AuraWidget = self:CreateWidgetAsync("ComItemAura",CoroutineObj)
            end
            self:AddWidgetToNode(self.AuraWidget)
        else
            self:RemoveWidgetFromNode(self.AuraWidget)
        end
    end

    self:AsyncLoadWidgetCommon("AuraWidget", "SetAuraTask", Callback)
end

function M:GetOrCreateGroupWidget(WidgetName, CoroutineObj)
    if not self.ItemGroup or not IsValid(self.ItemGroup) then
        self.ItemGroup = self:CreateWidgetNew("ComItemGroup")
    end

    self:AddWidgetToNode(self.ItemGroup)
    return self.ItemGroup:CreateAndAddWidgetAsyc(WidgetName, CoroutineObj)
end

function M:RemoveGroupWidget(WidgetName)
    if not self.ItemGroup or not IsValid(self.ItemGroup) then
        return
    end

    self.ItemGroup:RemoveWidget(WidgetName)
    self[WidgetName] = nil

    if self.ItemGroup:GetWidgetCount() < 1 then
        self:RemoveWidgetFromNode(self.ItemGroup)
    end
end
--endregion

function M:SetTimeLimitData(TimeLimitData)
    local Callback = function(CoroutineObj)
        if self.ItemType == "Resource" and DataMgr.LimitedTimeResource[self.Id] then
            local LimitedData = ItemUtils.GetItemLimitedInfo(self.Id)
            if not LimitedData then
                self:RemoveWidgetFromNode(self.TimeLimitWidget)
                return
            end
            local EndTime = LimitedData.EndTime
            if type(EndTime) == "table" and EndTime.GetTime then
                EndTime = EndTime.GetTime()
            end
            local NowTime = TimeUtils.NowTime()
            if not self.WidgetMap[self.TimeLimitWidget] and not IsValid(self.TimeLimitWidget) then
                self.TimeLimitWidget = self:CreateWidgetAsync("ComItemTimeLimit", CoroutineObj)
            end
            self:AddWidgetToNode(self.TimeLimitWidget)
            if self.bSmall then
                self.TimeLimitWidget.Text_Time:SetVisibility(ESlateVisibility.Collapsed)
            else
                self.TimeLimitWidget.Text_Time:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            end
            local diff = os.difftime(EndTime, NowTime)
            if diff < (60 * 60 * 24)  then
                self.TimeLimitWidget.BG:SetColorAndOpacity(self.TimeLimitWidget.Color_Red)
            else
                self.TimeLimitWidget.BG:SetColorAndOpacity(self.TimeLimitWidget.Color_Orange)
            end
            local TimeText
            if diff >= (60 * 60 * 24) * 7 then
                self.TimeLimitWidget.Text_Time:SetVisibility(ESlateVisibility.Collapsed)
            elseif diff > (60 * 60 * 24) then
                TimeText = math.floor(diff / (60 * 60 * 24))
                self.TimeLimitWidget.Text_Time:SetText(TimeText..GText("UI_GameEvent_TimeRemain_Day"))
            elseif diff > 60 * 60 then
                TimeText = math.floor(diff / (60 * 60))
                self.TimeLimitWidget.Text_Time:SetText(TimeText..GText("UI_GameEvent_TimeRemain_Hour"))
            else
                TimeText = math.floor(diff / 60)
                self.TimeLimitWidget.Text_Time:SetText(TimeText..GText("UI_GameEvent_TimeRemain_Min"))
            end
        else
            self:RemoveWidgetFromNode(self.TimeLimitWidget)
        end
    end
    if self.bAllUseAsyncLoadWidget then
        self:AsyncLoadWidgetCommon("TimeLimitWidget", "SetTimeLimitDataTask", Callback)
    else
        Callback()
    end
end

function M:AdjustBackGroundHeight(TextWidget,Reason)
    if not IsValid(TextWidget) then return end
    DebugPrint(WarningTag, "AdjustBackGroundHeight::看看原因",Reason)
    if TextWidget:GetVisibility() == 1 or  TextWidget:GetVisibility() == 2 then return end
    if not TextWidget.GetTextWidget and not TextWidget.GetDesireWidget then 
        DebugPrint(ErrorTag, "AdjustBackGroundHeight::传入的TextWidget必须要有GetTextWidget和GetDesireWidget接口")
        return 
    end
    if not self.Item then 
        DebugPrint(ErrorTag, "AdjustBackGroundHeight::没有Item控件不符合通用道具框结构")
        return 
    end
    if self:IsExistTimer(self.AdjustBGTimer) then
        self:RemoveTimer(self.AdjustBGTimer)
    end
    self:DefaultBackGroundHeight()
    local Layout = TextWidget:GetDesireWidget()
    Layout:ForceLayoutPrePass()
    local Interval = 0.05 --self.Content and self.Content.AdjustBackGroundHeightDelay or 0.05
    -- if not self.FirstTimeAdjustBackGroundInterval then
    --     self.FirstTimeAdjustBackGroundInterval = 0.1
    -- end
    -- if self.FirstTimeAdjustBackGroundInterval >0 then
    --     Interval = 0.1
    -- end
    -- if self.Content then
    --     self.Content.AdjustBackGroundHeightDelay = nil
    -- end
    local _, TimerKey = self:AddTimer(Interval, function()
        --self.FirstTimeAdjustBackGroundInterval = -1
        if not IsValid(TextWidget) then return end
        local Text = TextWidget:GetTextWidget()
        local Layout = TextWidget:GetDesireWidget()
        if not Text or not Layout then 
            DebugPrint(ErrorTag, "AdjustBackGroundHeight::GetTextWidget和GetDesireWidget接口不能返回空的值")
            return 
        end
        ---@type materialinstance
        local DynamicMat = self.Item.Item_BG:GetDynamicMaterial()
        local OnelineDesireHeight = UIUtils.CalcOnelineTextDesireHeight(Text)
        local DesireHeight = Layout:GetDesiredSize().Y
        if DesireHeight == 0 then
            Layout:ForceLayoutPrepass()
            DesireHeight = Layout:GetDesiredSize().Y
        end
        if DesireHeight == 0 then
            DebugPrint(ErrorTag, "AdjustBackGroundHeight::文本显示区域的高度为0,不应该再调整背景了")
            self:ClearBackGroundHeight()
            return
        end
        if DesireHeight <= OnelineDesireHeight*(1.5) then
           self:DefaultBackGroundHeight()
        else
            if self.Item.ComItemType == 3 then
                self:_RealSetBottomBlackHeight(DynamicMat, self.Item.BottomBlack_Max)
                self.bMaxHeight = true
            end
        end
    end)
    self.AdjustBGTimer = TimerKey
end

function M:DefaultBackGroundHeight()
    if not self.Item then 
        DebugPrint(ErrorTag, "DefaultBackGroundHeight::没有Item控件不符合通用道具框结构")
        return 
    end
    if not self.Item.ComItemType then
        DebugPrint(ErrorTag, Traceback(ErrorTag, "DefaultBackGroundHeight::Item控件没有ComItemType变量枚举来描述道具框类型，需要找蓝图加一个", true))
        return 
    end
    local DynamicMat = self.Item.Item_BG:GetDynamicMaterial()
    if self.Item.ComItemType == 1 then
        self:_RealSetBottomBlackHeight(DynamicMat, self.Item.BottomBlack_S)
    elseif self.Item.ComItemType == 2 then
        self:_RealSetBottomBlackHeight(DynamicMat, self.Item.BottomBlack_M)
    elseif self.Item.ComItemType == 3 then
        self:_RealSetBottomBlackHeight(DynamicMat, self.Item.BottomBlack_L)
    end
end

function M:ClearBackGroundHeight(bForce)
    if not self.Item then 
        DebugPrint(ErrorTag, "ClearBackGroundHeight::没有Item控件不符合通用道具框结构")
        return 
    end
    if not self.bMaxHeight and not bForce then return end
    if self:IsExistTimer(self.AdjustBGTimer) then
        return
    end
    self.bMaxHeight = false
    local DynamicMat = self.Item.Item_BG:GetDynamicMaterial()
    self:_RealSetBottomBlackHeight(DynamicMat, self.Item.BottomBlack_None)
end

function M:_RealSetBottomBlackHeight(DynamicMat, Height)
    DynamicMat:SetScalarParameterValue("BottomBlackHeight", Height)
    if self.OnSetBottomBlackHeight then
        self:OnSetBottomBlackHeight(Height)
    end
end

-- 将指定的Widget设置为Overlay中的最上层，因为现在Node_Widget控件被复用。
-- 导致原本应该后创建排在后面的控件因为复用的老的导致排在新创建的子控件前面。手动调用这个函数置于最后，也就是视觉上的前面
function M:CheckWidgetIsTop(Widget)
    if not IsValid(Widget) then
        return
    end
    
    local ChildrenCount = self.Node_Widget:GetChildrenCount()
    if ChildrenCount <= 1 then
        return -- 只有一个或没有子控件，无需调整
    end
    
    -- 获取目标Widget的当前索引
    local CurrentIndex = self.Node_Widget:GetChildIndex(Widget)
    if CurrentIndex == -1 then
        return -- Widget不在容器中
    end
    
    -- 如果已经是最后一个（最上层），无需操作
    if CurrentIndex == ChildrenCount - 1 then
        return
    end
    
    self.Node_Widget:RemoveChild(Widget)
    local Slot = self.Node_Widget:AddChild(Widget)
    Slot:SetVerticalAlignment(EVerticalAlignment.HAlign_Fill)
    Slot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
end

return M
