require "UnLua"

---@class Common_Item_Subsize_Small_Base_C
local M = Class({"BluePrints.UI.BP_UIState_C"})
----------------------开发规范----------------------
--- 通用道具框，可分为两个部分：
--- 1、通用道具框代码 (初始化Item信息功能函数 和 响应事件函数)
--- 2、各个系统中道具框特殊处理的代码 (特定功能函数)
--- 在1中尽量只做Item信息的初始化以及一些公共的初始化，即通用操作

---通用XSmall道具框Content所需数据
---Item信息 加载道具框所需的数据
---略
---可选属性 用于某些系统特定的功能
---@class SmallContent
---@field IsPlayAnim boolean 是否播放In动画 默认不播放
---@field NotInteractive boolean 是否可交互(Hover UnHover Click Select) 默认可交互
---@field IsShowDetails boolean 是否显示通用Tips弹窗 默认不显示
---@field IsCantItemSelection boolean 是否使用OnItemSelectionChanged 默认使用

---@param Content SmallContent 
function M:Init(Content)
    self:OnListItemObjectSet(Content)
end

---@param Content SmallContent
function M:OnListItemObjectSet(Content)
    ---- Item信息
    Content.SelfWidget = self
    self:InitData(Content)
    self:InitView(Content)
    self.ItemDetails_MenuAnchor:CloseItemDetailsWidget()
    if self.IsPlayAnim then
        self:PlayInAnimation()
    end
    if self.AfterInitCallback then 
        self.AfterInitCallback(self)
    end
end

function M:BP_OnEntryReleased()
    if (self.Content) then
        self.Content.SelfWidget = nil
    end
end

-- 初始化数据，不建议子类重载该方法
function M:InitData(Content)
    -- 通用道具框属性
    self.Content = Content
    self.ParentWidget = Content.ParentWidget
    self.CommonType = Content.CommonType
    self.ItemType = Content.ItemType
    -- duck type, 兼容军械库Mod(Common_Item_subsize_PC_Content_C)的UnitId
    self.Id = Content.Id or Content.UnitId
    self.Uuid = Content.Uuid
    self.Count = Content.Count  
    self.NeedCount = Content.NeedCount  -- 所需数量，如果有，数字采用 Count / NeedCount 的形式 
    self.MaxCount = Content.MaxCount    -- 最大数量，如果有，采取 Count ~ MaxCount 的形式 
    self.Icon = Content.Icon
    self.Rarity = Content.Rarity
    self.UIName = Content.UIName        -- item所在页面的在SystemUI中的UIName(选填)
    self.IsSpecial = Content.IsSpecial -- 是否显示特殊动效 VX_MOD_In
    self.NotInteractive = Content.NotInteractive -- 是否可交互(Hover UnHover Click Select)
    self.ShowRedDot = Content.ShowRedDot -- 是否显示红点
    self.ShowNewDot = Content.ShowNewDot -- 是否显示New标记

    -- 通用Tips弹窗菜单锚设置
    self.IsShowDetails = Content.IsShowDetails -- 是否显示通用Tips弹窗
    self.MenuPlacement = Content.MenuPlacement -- 菜单锚出现位置
    self.Content.IsShowTips = false            -- 当前是否显示Tips
    self.ItemDetails_MenuAnchor.ParentWidget = self
    self.IsCantItemSelection = Content.IsCantItemSelection -- 是否使用OnItemSelectionChanged
    self.HandleKeyDown = Content.HandleKeyDown     -- 是否消耗KeyDown事件
    
    -- 其他属性
    self.IsPlayAnim = Content.IsPlayAnim or false  -- 可选属性, 是否播放In动画 默认不播放
    self.bCanGet = Content.bCanGet --是否可以领取 (In时播放Receive_On动效，需打开IsPlayAnim)
    self.HandleMouseDown = Content.HandleMouseDown -- 点击后是否Handle点击事件
    self.IsGotState = Content.IsGot or false -- 设置已领取状态    
    self.IsBonus = Content.IsBonus or false -- 设置额外奖励显示
    self.FirstRewardFlag = Content.FirstRewardFlag or false -- 可选属性, 设置首通奖励标识 默认不显示
    self.IsWalnutBonus = Content.IsWalnutBonus or false  -- 可选属性, 是否显示核桃奖励标记 默认不显示
    self.NotCountFormat = Content.NotCountFormat or false -- 是否关闭数量缩写
    self.IsSold = Content.IsSold or false                 --可选属性，是否显示购入标识
    self.IsShadowEnabled = Content.IsShadowEnabled or false -- 可选属性，是否显示阴影
    -- 回调函数
    self.AfterInitCallback = Content.AfterInitCallback  -- 通用初始化结束后回调

    -- 点击事件回调方法
    -- {Obj = , Callback = , Params =}
    self.OnMouseButtonUpEvents = Content.OnMouseButtonUpEvents
    if self.OnMouseButtonUpEvents then
        self:BindEventOnMouseButtonUp(self.OnMouseButtonUpEvents.Obj, self.OnMouseButtonUpEvents.Callback, self.OnMouseButtonUpEvents.Params)
    end

    self._OnAddedToFocusPathEvent = Content.OnAddedToFocusPathEvent
    self._OnRemovedFromFocusPathEvent = Content.OnRemovedFromFocusPathEvent
end

-- 针对大中小不同的框，这个方法支持重载
function M:InitView(Content)
    self:StopAllAnimations()
    if self.Normal then
        self:PlayAnimation(self.Normal)
    end
    --- Id为0时，显示空道具框
    if not self.Id or self.Id == 0 then
        self.Switch_Type:SetActiveWidgetIndex(1)
        return
    else
        self.Switch_Type:SetActiveWidgetIndex(0)
    end

    self:BP_OnItemSelectionChanged(false)
    self:SetIcon(self.Icon)
    self:SetRarity(self.Rarity)
    self:SetIsGotState(self.IsGotState)
    self:SetRedDot(self.ShowRedDot)
    self:SetNewDot(self.ShowNewDot)
    self:SetBonus(self.IsBonus)
    self:SetWalnutBonus(self.IsWalnutBonus)
    if self.NeedCount and self.NeedCount > 0 then 
        self:ShowFactionText(self.Count, self.NeedCount)
    else
        self:SetCount(self.Count, self.NotCountFormat)
    end
    --- 如果是武器类型，需判断是否被协战伙伴装备，显示协战伙伴头像
    if self.ItemType == "Weapon" then
        self:SetWeaponPhantomIcon(Content.Uuid)
    end

    --- 如果是核桃类型，需显示核桃编号
    if self.ItemType == "Walnut" then
        self:SetWalnutNum(self.Id)
    end

    if self.IsSold then
        self.Panel_Lock:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Text_Lock:SetText(GText("UI_Fishing_BuyFishingLure"))
    else
        self.Panel_Lock:SetVisibility(ESlateVisibility.Collapsed)
    end
    if not self.GameInputModeSubsystem then
        self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
    end
end


function M:BindEventOnMouseButtonUp(Obj, Callback, Params)
    if not self.OnMouseButtonUpDel then 
        self.OnMouseButtonUpDel = {}
        self.OnMouseButtonUpDelParam = {}
    end

    self.OnMouseButtonUpDel[Obj] = Callback
    self.OnMouseButtonUpDelParam[Obj] = Params
end

function M:ClearEventOnMouseButtonUp(Obj)
    if not self.OnMouseButtonUpDel then return end 
    self.OnMouseButtonUpDel[Obj] = nil
    self.OnMouseButtonUpDelParam[Obj] = nil
end

function M:RemoveAllEvent()

end


----------------------初始化Item信息功能函数----------------------

local _RealSetIcon = function(self,Icon)
    local IconDynaMaterial = self.Img_Item:GetDynamicMaterial()
    if(IsValid(IconDynaMaterial))then
        if not IsValid(Icon) then
            DebugPrint("ZDX_请对应系统检查Icon是否正确")
        else
            IconDynaMaterial:SetTextureParameterValue("IconMap",Icon)
        end
    else
        DebugPrint("ZDX_IconDynaMaterial不合法")
    end
end

---设置ItemIcon
---@param Icon UObject @需要从Icon的路径加载为Object
function M:SetIcon(Icon)
    if self.IsShadowEnabled then
        self.Img_Item:SetColorAndOpacity(UE4.UUIFunctionLibrary.StringToLinearColor("000000FF"))
    else
        self.Img_Item:SetColorAndOpacity(UE4.UUIFunctionLibrary.StringToLinearColor("FFFFFFFF"))
    end

    if self.ItemType == "Walnut" then
        assert(DataMgr.Walnut[self.Id])
        -- local IconPath = DataMgr.WalnutType[DataMgr.Walnut[self.Id].WalnutType].Icon
        local IconPath = DataMgr.Walnut[self.Id].Icon
        self:LoadTextureAsync(IconPath,function(Texture)
            _RealSetIcon(self,Texture)
        end,"LoadIcon")
        return
    end
    if not Icon then
        DebugPrint("ZDX_道具框缺少Icon")
        return
    end

    if(type(Icon) == "string")then
        self:LoadTextureAsync(Icon,function(Texture)
            _RealSetIcon(self,Texture)
        end,"LoadIcon")
    else
        _RealSetIcon(self,Icon)
    end
end

function M:LoadTextureAsync(TexturePath, cb, TaskName)
    rawset(self, "LoadResourceID", nil)
    local Handle = UE.UResourceLibrary.LoadObjectAsyncWithId(self, TexturePath, {self, function (self, Texture, ResourceID)
            if not IsValid(self) or (ResourceID ~= nil and rawget(self, "LoadResourceID") ~= ResourceID) then
                return
            end
            cb(Texture)
        end})
    if Handle then
        rawset(self, "LoadResourceID", Handle.ResourceID)
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

---设置Item数量
---@param Count number @数量
function M:SetCount(Count, NotCountFormat)
    self.Text_Switch:SetActiveWidgetIndex(0)
    if Count and Count >= 0 then
        self.Panel_Num:SetVisibility(ESlateVisibility.Visible)
        local NumStr
        if NotCountFormat then
            NumStr = FormatNumber(Count, false)
            if self.MaxCount and self.MaxCount > 0 then 
                NumStr = NumStr.."~"
                NumStr = NumStr..CommonUtils.GetCountStr(self.MaxCount, 3)
            end
        else
            NumStr = FormatNumber(Count, true)
            if self.MaxCount and self.MaxCount > 0 then 
                NumStr = NumStr.."~"
                NumStr = NumStr..FormatNumber(self.MaxCount, true)
            end
        end
        self.Text_Num:SetText(NumStr)
    else
        self.Panel_Num:SetVisibility(ESlateVisibility.Collapsed)
    end
end

---设置Item稀有度
---@param Rarity number @稀有度
function M:SetRarity(Rarity)
    if not Rarity or Rarity < 1 or Rarity > 5 then
        self.Switch_Style:SetActiveWidgetIndex(1)
        self.Panel_QualityLine:SetVisibility(ESlateVisibility.Collapsed)
        self.Spacer_Switch:SetVisibility(ESlateVisibility.Visible)
        -- self.Img_Line:SetBrushResourceObject(LoadObject('/Game/UI/UI_PNG/Common/Deco/Deco_Quality_'
        --     .. UIConst.RarityColorName[6] .. '.Deco_Quality_' .. UIConst.RarityColorName[6]))
        -- self.Quality:SetVisibility(UE4.ESlateVisibility.Collapsed)
        return
    end
    self.Switch_Style:SetActiveWidgetIndex(0)
    self.Panel_QualityLine:SetVisibility(ESlateVisibility.Visible)
    self.Spacer_Switch:SetVisibility(ESlateVisibility.Collapsed)
    self.Img_Line:SetBrushResourceObject(LoadObject('/Game/UI/UI_PNG/Common/Deco/Deco_Quality_'
        .. UIConst.RarityColorName[Rarity] .. '.Deco_Quality_' .. UIConst.RarityColorName[Rarity]))
    self.Quality:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)

    self.Quality.Img_Quality:SetBrushTintColor(self.Quality["Color_"..Rarity])

    -- self.Quality.Img_Quality:SetBrushTintColor(UE4.UUIFunctionLibrary.StringToSlateColor(UIConst.RarityColor[Rarity]))
end

---设置领取状态
---@param IsGot boolean @是否已领取
function M:SetIsGotState(IsGot)
    if not self.Group_Got then 
        -- DebugPrint("Tianyi@ 当前控件没有Group_Got节点!")
        return
    end

    self.IsGotState = IsGot
    if IsGot then
        self:PlayAnimation(self.IsGot)
        self.Group_Got:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self:PlayAnimation(self.IsNormal)
        self.Group_Got:SetVisibility(ESlateVisibility.Collapsed)
    end 
end

---设置红点
---@param ShowRedDot boolean @是否显示红点
function M:SetRedDot(ShowRedDot)
    if ShowRedDot then
        self.Reddot:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self.Reddot:SetVisibility(ESlateVisibility.Collapsed)
    end
end

---设置New标记
---@param ShowNewDot boolean @是否显示New标记
function M:SetNewDot(ShowNewDot)
    if not self.New then return end
    if ShowNewDot then 
        self.New:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else 
        self.New:SetVisibility(ESlateVisibility.Collapsed)
    end
end

---设置额外奖励显示状态
function M:SetBonus(IsBonus)
    if IsBonus or self.FirstRewardFlag then
        self.Bonus:SetVisibility(ESlateVisibility.Visible)
        if self.FirstRewardFlag then
            self.Bonus.Text_Bonus:SetText(GText("UI_Dungeon_First_Reward_Tag"))
        elseif IsBonus then
            self.Bonus.Text_Bonus:SetText(GText("UI_Reward_Bonus"))
        end
    else
        self.Bonus:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function M:SetWalnutBonus(IsWalnutBonus)
    if not self.Walnut then
        return
    end
    if IsWalnutBonus then
        local Widget = UIManager(self):_CreateWidgetNew("ItemWalnutTag")
        self.Walnut:AddChild(Widget)
        self.Walnut:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
        self.Walnut:SetVisibility(ESlateVisibility.Collapsed)
    end
end

--- 播放In动画
function M:PlayInAnimation()
    if self.bCanGet then
        self:PlayAnimation(self.Receive_On)
    elseif self.IsSpecial then
        if self.ItemType == "Mod" then
            self:PlayAnimation(self.VX_MOD_In)
        elseif self.ItemType == "Resource" and DataMgr.Resource[self.Id].ResourceSType == "Coin" then
            self:PlayAnimation(self.VX_COIN_In)
        else
            self:PlayAnimation(self.VX_MAT_In)
        end
        -- self:PlayAnimation(self.VX_MOD_In)
        self.NotInteractive = true
        AudioManager(self):PlayUISound(self, "event:/ui/common/level_end_item_unlock", nil, nil)
    elseif self.Rarity == 5 then
        self:PlayAnimation(self.Orange_In)
    elseif self.Rarity == 4 then
        self:PlayAnimation(self.purple_In)
    else
        self:PlayAnimation(self.Normal_In)
    end
end

function M:IsInAnimationPlaying()
    if self:IsAnimationPlaying(self.Orange_In) or
    self:IsAnimationPlaying(self.purple_In) or
    self:IsAnimationPlaying(self.Normal_In) or
    self:IsAnimationPlaying(self.VX_MOD_In) or
    self:IsAnimationPlaying(self.VX_COIN_In) or
    self:IsAnimationPlaying(self.VX_MAT_In) or
    self:IsAnimationPlaying(self.Gacha_In) then
        return true
    end
    return false
end


----------------------------------------------------------------

-------------------------响应事件函数-----------------kl-------
------@param IsSelected boolean
function M:SetSelected(IsSelected)
    if self.NotInteractive then
        return
    end
    if self.Content then 
        self.Content.IsSelect = IsSelected
    end

    if IsSelected then
        self.VX_Loop:SetVisibility(ESlateVisibility.Visible)
        self:PlayAnimation(self.Selected_Loop, 0, 0)
    else
        self:StopAllAnimations()
        self.VX_Loop:SetVisibility(ESlateVisibility.Collapsed)
        self:PlayAnimation(self.Normal)
    end 
end

function M:OnMouseEnter(MyGeometry, MouseEvent)
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
        return
    end
    if not self.Content or self.NotInteractive or self.Content.IsSelect or self.Content.IsShowTips or self:IsInAnimationPlaying() then
        return 
    end
    self:StopAllAnimations()
    self:PlayAnimationForward(self.Hovered)
end

function M:OnMouseLeave(MyGeometry, MouseEvent)
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
        return
    end
    if not self.Content or  self.NotInteractive or self.Content.IsSelect or self.Content.IsShowTips or self:IsInAnimationPlaying() then
        return
    end
    self:StopAllAnimations()
    self:PlayAnimation(self.Normal)
    -- self:PlayAnimationReverse(self.Hovered)
end

function M:OnMouseButtonDown(MyGeometry, MouseEvent)
    -- 点击显示Tips，且Tips已经显示时
    if self.NotInteractive or (self.IsShowDetails and self.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor:IsOpen()) or self:IsInAnimationPlaying() then
        return UWidgetBlueprintLibrary.Handled()
    end
    self:StopAllAnimations()
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        self:PlayAnimation(self.Pressed)
    end
    if self.HandleMouseDown then 
        return UWidgetBlueprintLibrary.Handled()
    end
    return UWidgetBlueprintLibrary.Handled()  
end
function M:OnTouchEnded(MyGeometry, TouchEvent)
    return self:OnMouseButtonUp(MyGeometry, TouchEvent)
end

function M:OnTouchStarted(MyGeometry, TouchEvent)
    return self:OnMouseButtonDown(MyGeometry, TouchEvent)
end

function M:OnMouseButtonUp(MyGeometry, MouseEvent)
    if self.NotInteractive or self:IsInAnimationPlaying() then
        return UWidgetBlueprintLibrary.Unhandled()
    end
    if not self.bCanGet and self.ItemType == "Walnut" then
        UIManager(self):LoadUINew("WalnutRewardDialog", self.Id)
        return UWidgetBlueprintLibrary.Unhandled()
    end
    if self.IsShowDetails then
        -- 点击显示Tips，且Tips已经显示时
        if self.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor:IsOpen() then
            return UWidgetBlueprintLibrary.Unhandled()
        end
        local Content = {ItemType = self.ItemType, ItemId = self.Id, Uuid = self.Uuid, MenuPlacement = self.MenuPlacement, UIName = self.UIName, HandleKeyDown = self.HandleKeyDown}
        self.ItemDetails_MenuAnchor:OpenItemDetailsWidget(false, Content)
        self.Content.IsShowTips = true
        self.Content.IsSelect = true
    end
    AudioManager(self):PlayItemSound(self,self.Id,"Click",self.ItemType)
    if self.bCanGet then
        self:PlayAnimationReverse(self.Receive_On)
    end
    self:PlayAnimation(self.Click)
    if self.OnMouseButtonUpDel then 
        for Obj, Callback in pairs(self.OnMouseButtonUpDel) do 
            if self.OnMouseButtonUpDelParam[Obj] then
                Callback(Obj, table.unpack(self.OnMouseButtonUpDelParam[Obj]))
            else
                Callback(Obj)
            end
        end
    end

    return UWidgetBlueprintLibrary.Unhandled()
end

function M:OnAnimationFinished(InAnimation)
    -- Click动画结束 and 可以被交互 and 未使用OnItemSelectionChanged时 播放选中动画
    if InAnimation == self.Click and not self.NotInteractive then
        self.VX_Loop:SetVisibility(ESlateVisibility.Visible)
        self:PlayAnimation(self.Selected_Loop, 0, 0)
    elseif (self.VX_MOD_In and InAnimation == self.VX_MOD_In) or
    self.VX_MAT_In and InAnimation == self.VX_MAT_In or
    self.VX_COIN_In and InAnimation == self.VX_COIN_In then
        self.NotInteractive = false
    end
end

----------------------------------------------------------------

--------------------------------------------------分界线-------------------------------------------------
--- 以上内容为道具框内通用内容，以下内容为各个系统中道具框特殊处理的内容
--- 如果有新的系统需要特殊处理，考虑是否足够通用，如果足够通用，应该抽象出需求在上面添加通用功能
--- 如果不够通用，可以在下面添加处理函数，供各个系统调用

-------------------------特定功能函数------------------------

--- 协战伙伴装备该武器时，显示协战伙伴头像
function M:SetWeaponPhantomIcon(_Uuid)
    local Avatar = GWorld:GetAvatar()
    local Uuid = _Uuid
    if (_Uuid and not CommonUtils.IsObjId(_Uuid)) then
        Uuid = CommonUtils.Str2ObjId(_Uuid)
    end
    local Weapon = Uuid and Avatar.Weapons[Uuid]
    local AssisterId = Weapon and Weapon.AssisterId
    if(AssisterId and DataMgr.Resource[AssisterId])then
        self.Phantom:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        if(not self.PhantomWidget)then
            self.PhantomWidget = Utils.UIManager(self):CreateWidget('/Game/UI/UI_PC/Common/Item_Subsize_Widget/Common_Item_Subsize_Phantom_PC.Common_Item_Subsize_Phantom_PC',false)
            self.Phantom:ClearChildren()
            self.Phantom:AddChild(self.PhantomWidget)
        end
        local CharId = DataMgr.Resource[AssisterId].UseParam
        if(CharId and DataMgr.BattleChar[CharId])then
            self.PhantomWidget.Switch_Type:SetActiveWidgetIndex(2)
            local MiniIconPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/Head/Mini/"
            local PhantomGuideIconImg = "T_Normal_" .. DataMgr.BattleChar[CharId].GuideIconImg
            local IconImage = LoadObject(MiniIconPath..PhantomGuideIconImg.."."..PhantomGuideIconImg.."'")
            self.PhantomWidget:SetCharIcon(IconImage)
        else
            self.Phantom:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
    else
        self.Phantom:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function M:SetWalnutNum(ItemId)
    assert(DataMgr.Walnut[ItemId], "核桃不存在：", ItemId)
    local WalnutNum = DataMgr.Walnut[ItemId].WalnutNumber
    if self.Walnut_Num then
        local NumWidget = UIManager(self):_CreateWidgetNew("ItemWalnutNum")
        for i = 3, 1, -1 do
            local Num = math.floor(WalnutNum % 10)
            WalnutNum = WalnutNum / 10
            NumWidget["Num_"..i]:SetText(Num)
        end
        self.Walnut_Num:AddChild(NumWidget)
    end
end

---@param Hold number
---@param Need number
function M:ShowFactionText(Hold, Need)
    self.Text_Switch:SetActiveWidgetIndex(1) 
    self.Text_Hold:SetText(FormatNumber(Hold, true))
    self.Text_Need:SetText("/" .. tostring(FormatNumber(Need,true)))
    if (Hold>=Need) then 
        self.Text_Hold:SetColorAndOpacity(UE4.UUIFunctionLibrary.StringToSlateColor("FFFFFFFF"))
    else 
        self.Text_Hold:SetColorAndOpacity(UE4.UUIFunctionLibrary.StringToSlateColor("D82E30FF")) 
    end

end

function M:Construct()
    M.Super.Construct(self)
    self.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor.OnMenuOpenChanged:Add(self,self.OnMenuOpenChanged)
end

function M:Destruct()
    self.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor.OnMenuOpenChanged:Remove(self,self.OnMenuOpenChanged)
    M.Super.Destruct(self)
end

function M:OnMenuOpenChanged(bIsOpen)
    if(self.Event_OnMenuOpenChanged)then
        self.Event_OnMenuOpenChanged(self.Obj,bIsOpen)
    end
end

function M:BindEvents(Obj,Events)
    Events = Events or {}
    self.Obj = Obj
    self.Event_OnMenuOpenChanged = Events.OnMenuOpenChanged
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    if  self.GameInputModeSubsystem and UIUtils.UtilsGetCurrentInputType()==ECommonInputType.Gamepad then
        self.GameInputModeSubsystem:SetTargetUIFocusWidget(self)
        self.GameInputModeSubsystem:UpdateCurrentFocusWidgetPos()
    end
    return  M.Super.OnFocusReceived(self, MyGeometry, InFocusEvent)
end

function M:OnAddedToFocusPath(InFocusEvent)
    if(self._OnAddedToFocusPathEvent)then
        self._OnAddedToFocusPathEvent(self.ParentWidget, self)
    end
end

function M:OnRemovedFromFocusPath(InFocusEvent)
    if(self._OnRemovedFromFocusPathEvent)then
        self._OnRemovedFromFocusPathEvent(self.ParentWidget, self)
    end
end

return M
