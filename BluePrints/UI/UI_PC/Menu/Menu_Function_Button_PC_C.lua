--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"
local EMCache = require "EMCache.EMCache"
local Menu_Function_Button_PC_C = Class({"BluePrints.UI.BP_EMUserWidget_C","BluePrints.UI.BP_EMUserWidgetUtils_C"})
Menu_Function_Button_PC_C._components = {
    "BluePrints.UI.UI_PC.Menu.Reddot.MainUIItem_ReddotTree_Component",
}

function Menu_Function_Button_PC_C:OnLoaded(...)
    self:InitButton()
    self.BtnId=1
end

function Menu_Function_Button_PC_C:Construct()
    self:AddDispatcher(EventID.ConditionComplete, self, self.OnConditionComplete)
    self.ConditionMap={}
end

function Menu_Function_Button_PC_C:OnConditionComplete(ConditionId)
    if self.ConditionMap[ConditionId] then
        self:UpdateGuidePoint()
    end

end

function Menu_Function_Button_PC_C:UpdateGuidePoint()
    if self.Type=="Small" then
        return
    end
    local GuidePointArray={}
    local Avatar = GWorld:GetAvatar()
    for _, GuidePointInfo in pairs(DataMgr.MainUIGuidePoint) do
        if GuidePointInfo.EnterId==self.EnterId then
           table.insert(GuidePointArray, GuidePointInfo)
        end
    end
    local CurrentPointShow=false
    for _, GuidePointInfo in pairs(GuidePointArray) do
        if GuidePointInfo then
            local TempShow=false
            if GuidePointInfo.ShowCondition then
                TempShow=ConditionUtils.CheckCondition(Avatar,GuidePointInfo.ShowCondition)
                DebugPrint("@@@Updateguidepoint Menu_Function_Button_P EnterId,ShowCondition",GuidePointInfo.EnterId,TempShow)
                self.ConditionMap[GuidePointInfo.ShowCondition]=true
            end
            if GuidePointInfo.HideCondition then
                local NotShowCondition=ConditionUtils.CheckCondition(Avatar,GuidePointInfo.HideCondition)
                DebugPrint("@@@Updateguidepoint Menu_Function_Button_P EnterId,HideCondition",GuidePointInfo.EnterId,NotShowCondition)
                if NotShowCondition then
                    TempShow=false
                end
                self.ConditionMap[GuidePointInfo.HideCondition]=true
            end
            if not CurrentPointShow then
                CurrentPointShow=TempShow
                DebugPrint("@@@Updateguidepoint Menu_Function_Button_P UpdateCurrentShow EnterId,CurrentPointShow",GuidePointInfo.EnterId,CurrentPointShow)
            end
        end
    end
    DebugPrint("@@@Updateguidepoint Menu_Function_Button_P Update Final Current Show,CurrentPointShow",CurrentPointShow)
    if CurrentPointShow then
        self.Icon_GuidePoint:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self.Icon_GuidePoint:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function Menu_Function_Button_PC_C:LoadImage(MainUIId,Type)
    if not  self.ConditionMap then
        self.ConditionMap={}
    end
    self.Type=Type
    local BtnInfo = DataMgr.MainUI
    local Id = MainUIId
    self.EnterId=Id
    local Icon = BtnInfo[Id].Icon
    if Icon == nil then
        Icon = "/Game/UI/Texture/Dynamic/Atlas/Entrance/T_Entrance_Armory.T_Entrance_Armory"
    end
    self:SetButtonStyle(Icon)
    if Id == CommonConst.ArmoryEnterId then
        self:UpdateArmoryIcon()
    end
    if Type=="Large" then
        self.Text_Entrance_World:SetText(EnText(BtnInfo[Id].Name))
    end
    if Type~="Small" then
        self.Text_Entrance:SetText(GText(BtnInfo[Id].Name))
    end
    if Type == "Small" then
        self.Pos_DownloadSign:SetVisibility(UE4.ESlateVisibility.Collapsed)
        if MainUIId == CommonConst.CommonSetId and CommonUtils.GetDeviceTypeByPlatformName() == "Mobile"then
            if not self.ListenEvent or not self.ListenEvent[EventID.DownloadTaskStart] then
                self:AddDispatcher(EventID.DownloadTaskStart, self, self.AddDownloadSignEffect)
            end
            if not self.ListenEvent or not self.ListenEvent[EventID.DownloadTaskFinish] then
                self:AddDispatcher(EventID.DownloadTaskFinish, self, self.RemoveDownloadSignEffect)
            end
            local HotUpdateSubsystem = USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, UHotUpdateSubsystem)
            if HotUpdateSubsystem and HotUpdateSubsystem:HasDownloadTask() then
                self:AddDownloadSignEffect()
            else
                self:RemoveDownloadSignEffect(false)
            end
        end
    end
    self:PlayAnimation(self.Normal)
    --- 红点树接入
    self:ReddotTreePlugIn(BtnInfo[Id],"Esc")
    self:UpdateGuidePoint()
end

function Menu_Function_Button_PC_C:Destruct()
	self:ReddotTreePlugOut()
    self:RemoveDispatcher(EventID.ConditionComplete, self, self.OnConditionComplete)
    self:RemoveDispatcher(EventID.DownloadTaskStart, self, self.AddDownloadSignEffect)
    self:RemoveDispatcher(EventID.DownloadTaskFinish, self, self.RemoveDownloadSignEffect)
end

----------------------- 手机端分包下载动效相关 -----------------------------------------------
--- 添加分包下载动效
function Menu_Function_Button_PC_C:AddDownloadSignEffect()
    if not self.Pos_DownloadSign:IsVisible() then
        self.Pos_DownloadSign:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
end

--- 移除分包下载动效
---@param bIsNeedRealRemove boolean 是否需要子节点，true表示需要移除动效节点，false表示只隐藏
function Menu_Function_Button_PC_C:RemoveDownloadSignEffect(bIsNeedRealRemove)
    if (bIsNeedRealRemove) then
        if self.DownloadSign_EffectWidget then
            self.Pos_DownloadSign:RemoveChild(self.DownloadSign_EffectWidget)
            self.DownloadSign_EffectWidget = nil
        end
    end
    self.Pos_DownloadSign:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

function Menu_Function_Button_PC_C:UpdateArmoryIcon()
    local Avatar = GWorld:GetAvatar()
    if(not Avatar)then
        return
    end
    local Char = Avatar.Chars[Avatar.CurrentChar]
    local CharId=Char.CharId
    local CharIconPath=DataMgr.Char[CharId].EscIcon
    self:SetButtonStyle(CharIconPath)
end

function Menu_Function_Button_PC_C:SetButtonStyle(Icon)
    local ImageResource = LoadObject(Icon)
    if ImageResource ~= nil then
        local Material =self.Icon_Entrance:GetDynamicMaterial()
        if Material then
            Material:SetTextureParameterValue("IconTex", ImageResource)
        else
            self.Icon_Entrance:SetBrushResourceObject(ImageResource)
        end
    end
end



function Menu_Function_Button_PC_C:BtnOnClick()
    if self.Type== "Small" then
        AudioManager(self):PlayUISound(nil,"event:/ui/common/click_btn_sort_tab", nil, nil)
    elseif self.Type=="Large" then
        AudioManager(self):PlayUISound(nil,"event:/ui/common/click_mid", nil, nil)
    else
        AudioManager(self):PlayUISound(nil,"event:/ui/common/click_mid", nil, nil)
    end
    local MainUIConf = DataMgr.MainUI[self.EnterId]
    if self.LinkName and MainUIConf and MainUIConf.IfNoUI then
        self.Link = GLink(self.LinkName)
        UE4.UKismetSystemLibrary.LaunchURL(self.Link)
    elseif self.LinkName then
        UIUtils.OpenSystem(self.BtnId,true,self.LinkName)
    else
        UIUtils.OpenSystem(self.BtnId,true)
    end
end



function Menu_Function_Button_PC_C:UpdateRedDot()
    
end

function Menu_Function_Button_PC_C:SetRedDot(IsNew,Upgradeable,OtherReddot,Count)
    self.New:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Reddot:SetVisibility(UE4.ESlateVisibility.Collapsed)
    if IsNew then
        self.New:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        return
    end
    if(Upgradeable)then
        self.Reddot:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
    if OtherReddot == 3 and Count > 0 then
        self.Reddot:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Reddot_Num:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Reddot_Num:SetNum(Count)
    else
        self.Reddot_Num:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function Menu_Function_Button_PC_C:InitButton(Owner,IsForbid,ForbidToast)
    self.Owner=Owner
    if IsForbid then
        self:SetRenderOpacity(0.6)
        if ForbidToast then
            local func = function(self)
                UIManager(self):ShowUITip("CommonToastMain",GText(ForbidToast))
            end
            self.Button_Area:SetForbidden(true);
            self:SetRedDot(false)
            --self.Button_Area.OnClicked:Clear()
            self.Button_Area.OnClicked:Add(self,func)
        end
        return 
    end
    self.Button_Area.OnClicked:Add(self,self.OnBtnClicked)
    self.Button_Area.OnPressed:Add(self,self.OnBtnPressed)
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        self.Button_Area.OnHovered:Add(self,self.OnBtnHovered)
        self.Button_Area.OnUnhovered:Add(self,self.OnBtnUnhovered)
    end
    self.Button_Area.OnReleased:Add(self,self.OnBtnReleased)
end

----------------------------------------- 按钮 Click -----------------------------------------------
function Menu_Function_Button_PC_C:PlayButtonClickSound()
    UIUtils.PlayCommonBtnSe(self)
end

function Menu_Function_Button_PC_C:PlayButtonClickAnimation()
    self:StopAllAnimations()
    self:PlayAnimation(self.Click)
end

function Menu_Function_Button_PC_C:OnBtnClicked()
    self:PlayButtonClickAnimation()
    if self.Owner then
        self.Owner:PlayAnimation(self.Owner.Normal)
    end
    if self.Owner and self.Owner.IsEditOpen then
        self.Owner.IsEditOpen=false
        local function PlayAnimFinished()
            self:BtnOnClick()
            self.Owner:UnbindAllFromAnimationFinished(self.Owner.Edit_List_Out)
        end
        self.Owner:BindToAnimationFinished(self.Owner.Edit_List_Out, {self.Owner, PlayAnimFinished})
        self.Owner:PlayAnimation( self.Owner.Edit_List_Out)
    else
        self:BtnOnClick()
    end
end
----------------------------------------- 按钮 Click -----------------------------------------------

----------------------------------------- 按钮 Press -----------------------------------------------
function Menu_Function_Button_PC_C:PlayButtonPressAnim()
    self:StopAllAnimations()
    --self:PlayAnimation(self.Normal)
    self:PlayAnimation(self.Press)
end

function Menu_Function_Button_PC_C:OnBtnPressed()
    self.IsPressing = true
    self:PlayButtonPressAnim()
end
----------------------------------------- 按钮 Press -----------------------------------------------

----------------------------------------- 按钮 Hover -----------------------------------------------
function Menu_Function_Button_PC_C:PlayButtonHoverAnim()
    self:StopAllAnimations()
    --self:PlayAnimation(self.Normal)
    self:PlayAnimation(self.Hover)
end

function Menu_Function_Button_PC_C:OnBtnHovered()
    self.IsHovering = true
    self:PlayButtonHoverAnim()
end

function Menu_Function_Button_PC_C:SetBtnHovered(IsHovered)
    if IsHovered then 
        self:OnBtnHovered()
    else 
        self:OnBtnUnhovered()
    end
end 

----------------------------------------- 按钮 Hover -----------------------------------------------

----------------------------------------- 按钮 Release -----------------------------------------------
function Menu_Function_Button_PC_C:PlayButtonReleaseButHoverAnim()
    self:StopAllAnimations()
    self:PlayButtonHoverAnim()
end

function Menu_Function_Button_PC_C:PlayButtonReleaseAndUnHoverAnim()
    self:StopAllAnimations()
    self:SwitchNormalAnimation()
end

function Menu_Function_Button_PC_C:OnBtnReleased()
    self.IsPressing = false
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        if  not self.IsHovering then
            self:PlayButtonReleaseAndUnHoverAnim()
        else
            self:PlayButtonReleaseButHoverAnim()
        end
    else
        self:PlayAnimation(self.Normal)
    end
end
----------------------------------------- 按钮 Release -----------------------------------------------

----------------------------------------- 按钮 UnHover -----------------------------------------------
function Menu_Function_Button_PC_C:PlayButtonUnHoverAnim()
    self:StopAllAnimations()
    self:SwitchNormalAnimation()
end

function Menu_Function_Button_PC_C:OnBtnUnhovered()
    self.IsHovering = false
    if not self.IsPressing then
        self:PlayButtonUnHoverAnim()
    end
end
----------------------------------------- 按钮  UnHover -----------------------------------------------

function Menu_Function_Button_PC_C:SwitchNormalAnimation()
    self:PlayAnimation(self.UnHover)
    --self:PlayAnimation(self.Normal)
end

AssembleComponents(Menu_Function_Button_PC_C)
return Menu_Function_Button_PC_C
