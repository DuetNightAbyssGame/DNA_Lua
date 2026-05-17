--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local WikiCommon = require "BluePrints.UI.WBP.Wiki.WikiCommon"
local WikiController = require "BluePrints.UI.WBP.Wiki.WikiController"

---@type WBP_Encyclopedia_Entrance_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

function M:Construct()
    self.WBP_Encyclopedia_Culture.Culture_Title:SetText(GText("MainType_Civilization"))
    self.WBP_Encyclopedia_Influence.Influence_Title:SetText(GText("MainType_Faction"))
    self.WBP_Encyclopedia_Personage.Personage_Title:SetText(GText("MainType_Character"))
    self.WBP_Encyclopedia_Terroir.Terroir_Title_1:SetText(GText("MainType_Customs"))
    self.Btn_Award.OnClicked:Add(self, self.OnAwardClicked)
    self.LockedStates = {}
    
    -- 先解绑之前可能存在的事件，防止重复绑定
    self:UnbindAllEvents()
    self:BindAllEvents()
    
    self:UpdateLockState()
    self:UpdateEntranceNewState()
    WikiController:GetModel():AddNewStateListener(self, function()
        self:UpdateEntranceNewState()
    end)
    for i = 2, 5 do
        self:UpdateTextNum(i)
    end
    self:UpdateRedDot()
    self:RegisterRewardStateChange()
    self:InitListenEvent()
    self:RefreshBaseInfo()
    self.Key_NumBtn:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "View"
            }
        }
    })
end

function M:Initialize(Parent)
    self.Parent = Parent
end

function M:OnAwardClicked()
    AudioManager(self):PlayUISound(self, "event:/ui/common/tip_show_click", nil, nil)
    WikiController:OpenAwardPopup(self)
end

function M:OnButtonClicked(buttonType)
    if self.Parent.IsCloseSelf or self:IsAnimationPlaying(self.Auto_Out) or self.IsHide then return end
    local NumNow, NumAll = WikiController:GetModel():GetTextNum(buttonType)
    local config
    for _, btnConfig in ipairs(WikiCommon.ButtonConfig) do
        if btnConfig.type == buttonType then
            config = btnConfig
            break
        end
    end
    if NumNow == 0 then
		-- 此处为未解锁，播放对应widget的Lock动画
        if config and self[config.widget] then
            self[config.widget]:PlayAnimation(self[config.widget][config.animations.lock])
            UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_Wiki_Tab_Locked"))
        end
        return
    else
        self[config.widget]:PlayAnimation(self[config.widget][config.animations.Click])
        AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_pic_large", nil, nil)
    end
    WikiController:HandleButtonClick(buttonType, self)
    -- self.Parent.BookActor:UIBook_Out()
end

function M:UpdateLockState(type)
    self.LockedStates = {}
    for _, config in ipairs(WikiCommon.ButtonConfig) do
        local widget = self[config.widget]
        if widget then
            local NumNow, NumAll = WikiController:GetModel():GetTextNum(config.type)
            -- 记录锁定状态
            self.LockedStates[config.type] = (NumNow == 0)
            
            -- 根据解锁状态播放对应动画
            if NumNow == 0 then
                widget:PlayAnimation(widget[config.animations.lock])
            else
                widget:PlayAnimation(widget[config.animations.normal])
            end
        end
    end
end

function M:UpdateEntranceNewState()
    -- 检查各个分类的新内容状态
    local categoryConfigs = {
        { widget = "WBP_Encyclopedia_Culture", type = WikiCommon.CategoryType.Civilization },
        { widget = "WBP_Encyclopedia_Influence", type = WikiCommon.CategoryType.Faction },
        { widget = "WBP_Encyclopedia_Personage", type = WikiCommon.CategoryType.Character },
        { widget = "WBP_Encyclopedia_Terroir", type = WikiCommon.CategoryType.Customs },
    }
    
    for _, config in pairs(categoryConfigs) do
        local widget = self[config.widget]
        if widget then
            -- 检查该分类是否有新内容
            local isNew = WikiController:GetModel():IsTabNew(config.type)
            -- 更新New标记的显示状态
            if widget.New and IsValid(widget.New) then
                local Visible = isNew and UIConst.VisibilityOp.Visible or UIConst.VisibilityOp.Hidden
                widget.New:SetVisibility(Visible)
            end
        end
    end
end
--region 奖励

function M:UpdateRedDot()
    -- 使用红点树来获取状态
    local WikiRewardReddotName = DataMgr.ReddotNode.WikiReward.Name
    local reddotNode = ReddotManager.GetTreeNode(WikiRewardReddotName)
    
    if IsValid(self) and IsValid(self.Reddot) then
        if reddotNode and reddotNode.Count > 0 then
            self.Reddot:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        else
            self.Reddot:SetVisibility(UIConst.VisibilityOp.Hidden)
        end
    end
end
-- 添加奖励状态变化的监听
function M:RegisterRewardStateChange()
    -- 使用AddListener方法注册红点树监听
    local WikiRewardReddotName = DataMgr.ReddotNode.WikiReward.Name
    ReddotManager.AddListener(WikiRewardReddotName, self, function(NodeName, Count)
        self:UpdateRedDot()
    end)
end
--endregion
function M:UpdateTextNum(categoryType)
    local config = WikiCommon.CategoryConfig[categoryType]
    if not config then return end
    
    local widget = self[config.widget]
    if not widget then return end
    
    local NumNow, NumAll = WikiController:GetModel():GetTextNum(categoryType)
    if widget[config.numField] then
        widget[config.numField]:SetText(tostring(NumNow))
    end
    if widget[config.maxField] then
        widget[config.maxField]:SetText("/" .. tostring(NumAll))
    end
end

function M:BindAllEvents()
    -- 初始化事件函数存储表
    if not self.EventFunctions then
        self.EventFunctions = {}
    end
    
    for _, config in pairs(WikiCommon.ButtonConfig) do
        local widget = self[config.widget]
        if widget and widget[config.button] then
            local button = widget[config.button]
            local configType = config.type
            
            -- 创建并存储事件函数，避免每次都创建新的匿名函数
            if not self.EventFunctions[configType] then
                self.EventFunctions[configType] = {
                    OnClicked = function() self:OnButtonClicked(configType) end,
                    OnHovered = function() self:OnButtonHovered(configType) end,
                    OnUnhovered = function() self:OnButtonUnhovered(configType) end,
                    OnPressed = function() self:OnButtonPressed(configType) end,
                    OnReleased = function() self:OnButtonReleased(configType) end,
                }
            end
            
            -- 绑定事件
            button.OnClicked:Add(self, self.EventFunctions[configType].OnClicked)
            button.OnHovered:Add(self, self.EventFunctions[configType].OnHovered)
            button.OnUnhovered:Add(self, self.EventFunctions[configType].OnUnhovered)
            button.OnPressed:Add(self, self.EventFunctions[configType].OnPressed)
            button.OnReleased:Add(self, self.EventFunctions[configType].OnReleased)
        end
    end
end

function M:UnbindAllEvents()
    if not self.EventFunctions then
        return
    end
    
    for _, config in pairs(WikiCommon.ButtonConfig) do
        local widget = self[config.widget]
        if widget and widget[config.button] then
            local button = widget[config.button]
            local configType = config.type
            
            -- 使用存储的函数引用来解绑事件
            if self.EventFunctions[configType] then
                button.OnClicked:Remove(self, self.EventFunctions[configType].OnClicked)
                button.OnHovered:Remove(self, self.EventFunctions[configType].OnHovered)
                button.OnUnhovered:Remove(self, self.EventFunctions[configType].OnUnhovered)
                button.OnPressed:Remove(self, self.EventFunctions[configType].OnPressed)
                button.OnReleased:Remove(self, self.EventFunctions[configType].OnReleased)
            end
        end
    end
end

function M:IsLocked(buttonType)
    return self.LockedStates[buttonType] == true
end
-- 辅助方法：根据类型获取配置
function M:GetConfigByType(buttonType)
    for _, config in ipairs(WikiCommon.ButtonConfig) do
        if config.type == buttonType then
            return config
        end
    end
    return nil
end

function M:HideSelf()
    self.IsHide = true
    self:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Parent:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:ShowSelf()
    self.IsHide = false
    self:SetVisibility(UIConst.VisibilityOp.Visible)
    self.Parent:SetVisibility(UIConst.VisibilityOp.Visible)
end

function M:Destruct()
    self:UnbindAllEvents()
    WikiController:GetModel():RemoveNewStateListener(self)

    -- 使用RemoveListener方法取消红点监听
    local WikiRewardReddotName = DataMgr.ReddotNode.WikiReward.Name
    ReddotManager.RemoveListener(WikiRewardReddotName, self)
end

function M:OnButtonHovered(buttonType)
    if self:IsLocked(buttonType) then return end
    
    local config = self:GetConfigByType(buttonType)
    if config and self[config.widget] then
        self[config.widget]:PlayAnimation(self[config.widget][config.animations.hover])
    end
end

function M:OnButtonUnhovered(buttonType)
    if self:IsLocked(buttonType) then return end
    
    local config = self:GetConfigByType(buttonType)
    if config and self[config.widget] then
        self[config.widget]:PlayAnimation(self[config.widget][config.animations.unhover])
    end
end

function M:OnButtonPressed(buttonType)
    if self:IsLocked(buttonType) then return end
    
    local config = self:GetConfigByType(buttonType)
    if config and self[config.widget] then
        self[config.widget]:PlayAnimation(self[config.widget][config.animations.pressed])
    end
end

function M:OnButtonReleased(buttonType)
    if self:IsLocked(buttonType) then return end
    
    local config = self:GetConfigByType(buttonType)
    if config and self[config.widget] then
        self[config.widget]:PlayAnimation(self[config.widget][config.animations.normal])
    end
end

--region 手柄
function M:OnFocusReceived(MyGeometry, InFocusEvent)
    self:InitNavigationRules()
    if self:HasAnyUserFocus() then
        self.WBP_Encyclopedia_Influence:SetFocus()
    end
    return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:InitListenEvent()
    local PlayerController = self:GetOwningPlayer()
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self,self.RefreshOpInfoByInputDevice)
    end
end

function M:RefreshBaseInfo()
    if (IsValid(self.GameInputModeSubsystem)) then
        self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    self.CurGamepadName = CurGamepadName
    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    local ActiveWidgetIndex = IsUseKeyAndMouse and 0 or 1
    if (IsUseKeyAndMouse) then
        --键鼠
        self.Key_NumBtn:SetVisibility(UIConst.VisibilityOp.Collapsed)
    else
        --手柄
        self.Key_NumBtn:SetVisibility(UIConst.VisibilityOp.Visible)
        if self:HasAnyUserFocus() then
            self.WBP_Encyclopedia_Influence:SetFocus()
        end
    end
end

function M:InitNavigationRules()
    self.WBP_Encyclopedia_Influence:SetNavigationRuleExplicit(EUINavigation.Right, self.WBP_Encyclopedia_Terroir)
    self.WBP_Encyclopedia_Influence:SetNavigationRuleExplicit(EUINavigation.Down, self.WBP_Encyclopedia_Personage)
    self.WBP_Encyclopedia_Terroir:SetNavigationRuleExplicit(EUINavigation.Left, self.WBP_Encyclopedia_Influence)
    self.WBP_Encyclopedia_Terroir:SetNavigationRuleExplicit(EUINavigation.Down, self.WBP_Encyclopedia_Culture)
    self.WBP_Encyclopedia_Personage:SetNavigationRuleExplicit(EUINavigation.Right, self.WBP_Encyclopedia_Culture)
    self.WBP_Encyclopedia_Personage:SetNavigationRuleExplicit(EUINavigation.Up, self.WBP_Encyclopedia_Influence)
    self.WBP_Encyclopedia_Culture:SetNavigationRuleExplicit(EUINavigation.Left, self.WBP_Encyclopedia_Personage)
    self.WBP_Encyclopedia_Culture:SetNavigationRuleExplicit(EUINavigation.Up, self.WBP_Encyclopedia_Terroir)
end

--endregion

return M
