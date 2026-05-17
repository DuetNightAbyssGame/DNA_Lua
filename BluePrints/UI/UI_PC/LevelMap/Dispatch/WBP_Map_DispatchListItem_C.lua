--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local TimeUtils = require "Utils.TimeUtils"

---@type WBP_Map_DispatchListItem_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

local DispatchStateEnum = {
    Finished = 0, -- 0 派遣已完成
    Doing = 1, -- 1 任务进行中
    Dispatching = 2, -- 2 代理人派遣中
    Unlock = 3, -- 3 未解锁
    CanDispatch = 4, -- 4 可派遣
}

function M:Initialize(Initializer)
    M.Super.Initialize(self)
    self.DispatchId = 0  --派遣id
    self.Dispatch = nil  --派遣实例
    self.DispatchState = nil  --派遣状态
    self.Owner = nil    --父Widget
    --self.IsClick = false    --是否被点击
end

function M:Construct()
    self.Super.Construct(self)
    self.Btn_Click.OnHovered:Add(self, self.OnHovered)
    self.Btn_Click.OnPressed:Add(self, self.OnPressed)
    self.Btn_Click.OnUnhovered:Add(self, self.OnUnhovered)
    self.Btn_Click.OnClicked:Add(self, self.OnDispatchItemClick)
    self.Btn_Click.OnReleased:Add(self, self.OnReleased)

end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:Destruct()
    self.Btn_Click.OnHovered:Remove(self, self.OnHovered)
    self.Btn_Click.OnPressed:Remove(self, self.OnPressed)
    self.Btn_Click.OnUnhovered:Remove(self, self.OnUnhovered)
    self.Btn_Click.OnClicked:Remove(self, self.OnDispatchItemClick)
    self.Btn_Click.OnReleased:Remove(self, self.OnReleased)
    if (self.Owner) then
        if (self.Owner.Owner.DispatchItem == self) then
            self.Owner.Owner.DispatchItem = nil
        end       
    end
    self.Super.Destruct(self)
end

function M:BP_OnEntryReleased()
    DebugPrint("lkkkkBP_OnEntryReleased")
    self:RemoveTimer("RemaingTimeTimer")
    self:RemoveTimer("LockTimeTimer")
    self:RemoveTimer("SuccessTimeTimer")

end
--生成item
function M:OnListItemObjectSet(Content)
    self.Content = Content
    self.DispatchId = Content.DispatchId
    self.Owner = Content.Owner
    Content.UI = self
    self.Reddot:SetVisibility(ESlateVisibility.Collapsed)
    if self.DispatchId == -1 then
        self.Switch_Type:SetActiveWidgetIndex(1)     
        return
    end
    self.Switch_Type:SetActiveWidgetIndex(0)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    self.Dispatch = Avatar.Dispatches[self.DispatchId]
    if self.Dispatch == nil then
        return
    end
    self:StopAllAnimations()
    self.BG:StopAllAnimations()
    if self.Content.IsClick == true then
        self.Owner.Owner.DispatchItem = self
        DebugPrint("lkkkkkkkkkkkkkkclick",self.DispatchId)
        self.BG:PlayAnimation(self.BG.Click)
    else
        self.BG:OnCellReleased()
    end
    self:SetDispatchState(self.Dispatch)
    self:SetDispatchDetail()
    self:SetReddot(self.Dispatch)
    self:SetNavigationRuleBase(EUINavigation.Right,EUINavigationRule.Stop)
    self:SetNavigationRuleBase(EUINavigation.Left,EUINavigationRule.Stop)

end

function M:RefreshDispatchItem(Dispatch)
    self:RemoveTimer("RemaingTimeTimer")
    self:RemoveTimer("LockTimeTimer")
    self:RemoveTimer("SuccessTimeTimer")

    self.Dispatch = Dispatch
    self:SetDispatchState(self.Dispatch)
    self:SetReddot(self.Dispatch)


end

function M:SetReddot(Dispatch)
    if (Dispatch.State == CommonConst.DispatchState.Success or Dispatch.State == CommonConst.DispatchState.Perfect or Dispatch.State == CommonConst.DispatchState.Qualified
        or Dispatch.State == CommonConst.DispatchState.Disqualified) then
        self.Reddot:SetVisibility(ESlateVisibility.Visible)
    else
        self.Reddot:SetVisibility(ESlateVisibility.Collapsed)
    end
    
end

--设置派遣状态
function M:SetDispatchState(Dispatch)
    --self:StopAllAnimations()
    if (Dispatch.State == CommonConst.DispatchState.Success or Dispatch.State == CommonConst.DispatchState.Perfect or Dispatch.State == CommonConst.DispatchState.Qualified
        or Dispatch.State == CommonConst.DispatchState.Disqualified) then
        self.DispatchState = DispatchStateEnum.Finished
        self:StopAnimation(self.Dispatching)
        self:PlayAnimation(self.Finish)
        self.Text_Finish:SetText(GText("UI_Disptach_State_Done"))
        self:RemoveTimer("SuccessTimeTimer")
    elseif Dispatch.State == CommonConst.DispatchState.Unlock then
        self.DispatchState = DispatchStateEnum.Unlock
        self:PlayAnimation(self.Lock)
        self.Text_Lock:SetText(GText("UI_Disptach_State_Lock"))
        self:SetLockTimeRemaining(Dispatch)
    elseif Dispatch.State == CommonConst.DispatchState.Doing then
        if Dispatch.DispatchCharsList:Length() > 0 then --派遣中
            self.DispatchState = DispatchStateEnum.Dispatching
            self:PlayAnimation(self.Dispatching, 0 ,0)
            self.Text_Status:SetText(GText("UI_Disptach_State_Doing"))
            self:SetSuccessTime(Dispatch)
        else
            self.DispatchState = DispatchStateEnum.Doing
            self:PlayAnimation(self.Progressing)
            self.Text_Progressing:SetText(GText("UI_Disptach_State_ManualDoing"))
        end      
    elseif Dispatch.State == CommonConst.DispatchState.CanDispatch then       
        self.DispatchState = DispatchStateEnum.CanDispatch
        --self:PlayAnimation(self.Normal)
        self:PlayAnimation(self.Nodispatch)
        self:SetTimeRemaining(Dispatch)
    end
end

--设置可派遣失效时间
function M:SetTimeRemaining(Dispatch)
    self.ExpireTime.Text_TimeTitle:SetVisibility(ESlateVisibility.Collapsed)
    self.ExpireTime.Image_ClockIcon:SetVisibility(ESlateVisibility.Collapsed)
    self.Text_Expire:SetText(GText("UI_Disptach_State_Vanish"))
    local RemainTime = function()
        local StartTime = Dispatch.RegisterTime
        local EndTime = StartTime + (Dispatch.Ttk * 60)
        local RemainTimeDict, TimeCount = UIUtils.GetLeftTimeStrStyle2(EndTime)
        self.ExpireTime:SetTimeText(GText("UI_Disptach_State_Vanish"), RemainTimeDict)
    end
    RemainTime()
    self:AddTimer(1, RemainTime, true, 0, "RemaingTimeTimer")
end

--设置Lock失效时间
function M:SetLockTimeRemaining(Dispatch)
    self.Time_Lock.Text_TimeTitle:SetVisibility(ESlateVisibility.Collapsed)
    self.Time_Lock.Image_ClockIcon:SetVisibility(ESlateVisibility.Collapsed)
    self.Text_LockTime:SetText(GText("UI_Disptach_State_Vanish"))
    local LockTime = function()
        local StartTime = Dispatch.RegisterTime
        local EndTime = StartTime + (Dispatch.Ttk * 60)
        local RemainTimeDict, TimeCount = UIUtils.GetLeftTimeStrStyle2(EndTime)
        self.Time_Lock:SetTimeText(GText("UI_Disptach_State_Vanish"), RemainTimeDict)
    end
    LockTime()
    self:AddTimer(1, LockTime, true, 0, "LockTimeTimer")
end
--设置完成时间
function M:SetSuccessTime(Dispatch)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    self.Text_FinishTime:SetText(GText("UI_Dispatch_TimeToDone"))
    local BaseTime = Dispatch:GetDispatchTime()
    self.FinishTime.Text_TimeTitle:SetVisibility(ESlateVisibility.Collapsed)
    local Effect = (DataMgr.CharDispatchTag["Workaholic"].DispatchEffectParam) / 10000
    local Count = 0
    for _, Uuid in pairs(Dispatch.DispatchCharsList) do
        local Char = Avatar.Chars[CommonUtils.Str2ObjId(CommonUtils.ObjId2Str(Uuid))]
        local Tag = Char:GetCurrentUnlockDispatchTag()
        for Tag, Number in pairs(Tag) do
            if Tag == "Workaholic" then
                Count = Count + Number
            end
        end
    end
    local Res
    if Count == 0 then
        Res = (BaseTime) * 60
    else
        Res = math.floor((BaseTime - (BaseTime * Count * Effect)) * 60)
    end
    local SuccessTime = function()
        local StartTime = Dispatch.StartTime
        local BaseTime = Dispatch:GetDispatchTime()
        local EndTime = StartTime + Res
        local NowTime = TimeUtils.NowTime()
        local RemainTimeDict, TimeCount = UIUtils.GetLeftTimeStrStyle2(EndTime)
        self.FinishTime:SetTimeText(GText("UI_Disptach_RemainTime"), RemainTimeDict)
    end
    SuccessTime()
    self:AddTimer(1, SuccessTime, true, 0, "SuccessTimeTimer")
end
--设置Item详情
function M:SetDispatchDetail()
    local DispatchData = DataMgr.Dispatch[self.DispatchId]
    local DispatchName = DataMgr.DispatchUI[DispatchData.DispatchUIId].DispatchName
    local DispatchRarity = DispatchData.Rarity
    local DispatchType = DispatchData.DispatchType
    self.Text_Name:SetText(GText(DispatchName))
    self:SetDispatchRarity(DispatchRarity)
    self:SetDispatchType(DispatchType)

end

--设置稀有度
function M:SetDispatchRarity(DispatchRarity)
    if DispatchRarity == 1 then
        local IconDynaMaterial = self.Icon_Type:GetDynamicMaterial()
        if(IconDynaMaterial)then
            IconDynaMaterial:SetTextureParameterValue("MainTex",self.Img_Color_2)    
        end
        local FontMaterial = self.Text_Name:GetDynamicFontMaterial()
        if FontMaterial then
            FontMaterial:SetTextureParameterValue("DecalTex", self.Img_Color_2)
        end
    elseif DispatchRarity == 2 then
        local IconDynaMaterial = self.Icon_Type:GetDynamicMaterial()
        if(IconDynaMaterial)then
            IconDynaMaterial:SetTextureParameterValue("MainTex",self.Img_Color_3) 
        end
        local FontMaterial = self.Text_Name:GetDynamicFontMaterial()
        if FontMaterial then
            FontMaterial:SetTextureParameterValue("DecalTex", self.Img_Color_3)
        end
    elseif DispatchRarity == 3 then
        local IconDynaMaterial = self.Icon_Type:GetDynamicMaterial()
        if(IconDynaMaterial)then
            IconDynaMaterial:SetTextureParameterValue("MainTex",self.Img_Color_4)   
        end
        local FontMaterial = self.Text_Name:GetDynamicFontMaterial()
        if FontMaterial then
            FontMaterial:SetTextureParameterValue("DecalTex", self.Img_Color_4)
        end
    end      
end

--设置派遣类型
function M:SetDispatchType(DispatchType)
    if DispatchType == "Battle" then
        local Icon = LoadObject("/Game/UI/Texture/Dynamic/Atlas/Map/T_Map_IconBattle.T_Map_IconBattle")
        local IconDynaMaterial = self.Icon_Type:GetDynamicMaterial()
        if(IconDynaMaterial)then
            IconDynaMaterial:SetTextureParameterValue("Mask",Icon)    
        end
    elseif DispatchType == "Collect" then
        local Icon = LoadObject("/Game/UI/Texture/Dynamic/Atlas/Map/T_Map_IconProduce.T_Map_IconProduce")
        local IconDynaMaterial = self.Icon_Type:GetDynamicMaterial()
        if(IconDynaMaterial)then
            IconDynaMaterial:SetTextureParameterValue("Mask",Icon)    
        end
    elseif DispatchType == "Social" then
        local Icon = LoadObject("/Game/UI/Texture/Dynamic/Atlas/Map/T_Map_IconSocial.T_Map_IconSocial")
        local IconDynaMaterial = self.Icon_Type:GetDynamicMaterial()
        if(IconDynaMaterial)then
            IconDynaMaterial:SetTextureParameterValue("Mask",Icon)    
        end
    end
end

--点击派遣Item
function M:OnDispatchItemClick()
    if(self.DispatchId == -1) then
        return
    end
    if self.Owner == nil then
        DebugPrint("ItemOwner不存在")
        return
    end
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_mid", nil, nil)
    self.Owner.DispatchId = self.DispatchId  
    if(self.Owner.Owner.DispatchItem ~= nil) then
        self.Owner.Owner.DispatchItem:PlayNormal()
        self.Owner.Owner.DispatchItem.Content.IsClick = false     
    end
    self.Content.IsClick = true 
    self.Owner.Owner.DispatchId = self.DispatchId
    self.Owner.Owner.DispatchItem = self
    self:AddTimer(0.01, function()
        DebugPrint("lkkkkkkkkkkkkOnDispatchItemClick",self.DispatchId)
        self.BG:PlayAnimation(self.BG.Click)
    end)
    self.Owner.Owner:CreateOrRefreshDispatchDetail(self.Dispatch)
    self.Owner.Owner.RealWildMap:RefreshDispatchMap(self.Dispatch.RegionId, self.DispatchId)
end

--动效相关
function M:OnPressed()
    if self.Content.IsClick == false then
        self.BG:OnCellPressed()
    end  
end

function M:OnHovered()
    if self.Owner and self.Owner.UsingGamepad then
        self:OnDispatchItemClick()
        return
    end
    if self.Content.IsClick == false then
        self.BG:OnCellHovered()
        if self.Owner and self.Owner.UsingGamepad then
            self:OnDispatchItemClick()
        end
    end
end

function M:OnUnhovered()
    if self.Content.IsClick == false then
        self.BG:OnCellUnhovered()
    end
end

function M:OnReleased()
    if self.Content.IsClick == false then
        self.BG:OnCellReleased()
    end
end

function M:PlayNormal()
    self.BG:StopAllAnimations()
    self.BG:OnCellReleased()
end


function M:GetIdByUuid(Uuid)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    for _, Char in pairs(Avatar.Chars) do
        if CommonUtils.ObjId2Str(Char.Uuid) == Uuid then
            return Char.CharId
        end
    end
end


function M:OnKeyDown(MyGeometry, InKeyEvent)

    return UE4.UWidgetBlueprintLibrary.UnHandled()

end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    
end

return M
