--
-- DESCRIPTION
-- 免打扰功能弹窗蓝图绑定脚本
-- @COMPANY **
-- @AUTHOR 叶轲
-- @DATE 2025.4.8
--
require "UnLua"
local ChatModel = ChatController:GetModel()
---@type WBP_Chat_DontDisturbContent_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

--仅初始化lua变量时使用，千万不要有控件操作！！
-- function M:Initialize(Initializer)
--     elf.contents
--     M.Super.Initialize(self)
-- end

function M:Construct()
    self.ChatChannelMute = GWorld:GetAvatar().ChatChannelMute
    self.List_Channel.OnCreateEmptyContent:Bind(self,function(self)
        return NewObject(UIUtils.GetCommonItemContentClass())
    end)
    --self.ChannelsUINum=6;--频道Widget数量,如果实际频道数量小于6，就用空态补全
    self:InitItems()
    self.CommonDialogWindow= UIManager(self):GetUIObj("CommonDialog")
    self:AddTimer (0.1,function()self:LateInit()end)
    self.bHaveForbidden=true
    self:AddDispatcher("ComfirmDisturbClick", self, self.Save)
end
function M:LateInit()
    self:SetClickCallback()
    self.CommonDialogWindow:InitGamepadShortcut({
        KeyInfoList = {
        {
            Type = "Img",
            ImgShortPath="A"
        }},
        Desc = GText("UI_CTL_On/Off")
    }) 
    self:SetOriginFocus()
end
function M:InitItems()
    self.Items={}--拥有实际频道的widget的Item
    local ChannelDatas = DataMgr.Channel
    for index, Data in ipairs(ChannelDatas) do
        if index ~= ChatCommon.ChannelDef.SettlementOnline then
            local Content= NewObject(UIUtils.GetCommonItemContentClass())
            Content.Enable=  self.ChatChannelMute[index]==1
            Content.ChannelName = GText(Data["Name"])
            Content.ChannelId = Data["ChannelType"]
            Content.ChannelIcon = LoadObject(Data.Icon)
            Content.ClickCallback = self.UnLockSaveButton
            Content.ClickCallbackObj=self
            self.List_Channel:AddItem(Content)
            table.insert(self.Items, Content)
        end
    end
    -- local NUllWidgetCount=self.ChannelsUINum-#ChannelDatas
    -- while (NUllWidgetCount>0) do
    --     NUllWidgetCount=NUllWidgetCount-1;
    --     local NullContent= NewObject(UIUtils.GetCommonItemContentClass())
    --     self.List_Channel:AddItem(NullContent)
    -- end
    self.List_Channel:RequestFillEmptyContent()
end
--点击保存，真正修改数据
function M:Save()
   -- local ContentItems = self.Items
    local ItemsTable=self.Items 
    local Avatar = ChatModel:GetAvatar()
    for index, value in ipairs(ItemsTable) do

        if ( value.UI.EnableNotDisturb and 1 or 0) == Avatar.ChatChannelMute[index] then
        else
           if  value.UI.EnableNotDisturb then
            Avatar:SetChatChannelMute(index)
           else
            Avatar:CancelChatChannelMute(index)
           end
        end
    end
    UIManager(self):ShowUITip("CommonToastMain", GText("UI_PersonInfo_Saved"))

end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        if InKeyName==UIConst.GamePadKey.FaceButtonLeft then
            if  not  self.bHaveForbidden  then
           self:Save()
           self.CommonDialogWindow:OnCloseBtnClicked()
            else
                  self.CommonDialogWindow:OnForbiddenRightBtnClicked()
            end
           return UE4.UWidgetBlueprintLibrary.Handled()
        end
    else
    end
    return UE4.UWidgetBlueprintLibrary.UnHandled()
end
--设置点击回调
function M:SetClickCallback()
    for index, value in ipairs(self.Items) do
        if  value.UI then
        value.UI:SetClickCallback(self.CheckIsChange,self )
        else
            ScreenPrint("value.UI is nil")
        end
    end
end
---检查缓存的数据是否有变化，如果有变化，就解锁保存按钮，如果一样，就禁用保存按钮
function M:CheckIsChange()
    local bDifferent = false
    for index, value in ipairs(self.Items) do
        local UI=value.UI
        if UI.EnableNotDisturb  ~= (self.ChatChannelMute[index]==1)  then
            bDifferent=true
            break
        end
    end
    if bDifferent then
        self:LockOrUnLockSaveButton(false)
    else
        self:LockOrUnLockSaveButton(true)
    end
end
--- func 禁用按钮
---@param bLock 是否禁用右侧按钮
function M:LockOrUnLockSaveButton(bLock)
    local CommonDialogWindow= UIManager(self):GetUIObj("CommonDialog")
    self.bHaveForbidden = bLock
    CommonDialogWindow:ForbidRightBtn(bLock)
end
---开启Iten的Hover效果
function M:SetItemEnableHover(IsEnable)
    ScreenPrint("SetItemEnableHover"..(IsEnable and "true" or "false"))
    local ItemsTable=self.Items
    for index, value in ipairs(ItemsTable) do
        if  value.UI then
        value.UI:SetEnableHover(IsEnable)
        end
    end
end
function M:ClearHover()
    local ItemsTable = self.Items
    for index, value in ipairs(ItemsTable) do
        if value.UI then
            value.UI:PlayAnimation(value.UI.Normal)
        end
    end
end

--手柄相关
function M:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
    self.CurInputDeviceType = CurInputType
    if CurInputType == ECommonInputType.Gamepad then
        self:SetOriginFocus()
        self:SetItemEnableHover(true)
    else
        self:SetItemEnableHover(false)
    end
end
function M:InitGamepadView()
    self.CurInputDeviceType = ECommonInputType.Gamepad
    self:SetOriginFocus()
    self:SetItemEnableHover(true)
end
function M:InitKeyboardView()
    self.CurInputDeviceType =ECommonInputType.MouseAndKeyboard
    self:SetItemEnableHover(false)
    self:ClearHover()
    self:AddTimer (0.3,function()
        self:SetItemEnableHover(false)
        self:ClearHover()
    end)--进入界面时可能失效，延迟0.3s再设置

end
--手柄聚焦默认起点
function M:SetOriginFocus()
    if self.List_Channel:GetNumItems() > 0 then
        self.List_Channel:NavigateToIndex(0)
    end
end
-- function M:Destruct()
-- end

return M
