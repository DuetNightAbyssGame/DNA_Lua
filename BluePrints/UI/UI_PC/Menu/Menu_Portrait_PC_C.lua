--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local Menu_Portrait_PC_C = Class({"Blueprints.UI.BP_UIState_C"})

function Menu_Portrait_PC_C:Initialize(Initializer)
    self.Super.Initialize(self)
end

function Menu_Portrait_PC_C:OnLoaded(...)
end

function Menu_Portrait_PC_C:SetImage(Path,Id,IsHeadFrame)
    if Path == nil then
        Path = "/Game/UI/Texture/Dynamic/Atlas/Entrance/T_Entrance_Armory.T_Entrance_Armory"
    end
    local ImageResource = LoadObject(Path)
    if ImageResource ~= nil then
        local Material = self.Img_Item:GetDynamicMaterial()
        if self.IsHeadFrame then
            self.Img_Item:SetBrushResourceObject(ImageResource)
        else
            Material:SetTextureParameterValue("IconMap", ImageResource)
        end
    end
    self.Icon_Empty:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.IsSelect =false
    local Avatar = GWorld:GetAvatar()
    if Avatar then

        if not IsHeadFrame then
            if Id==Avatar.HeadIconId then
                
                self:PlayAnimation(self.Select_Normal)
                --self:PlayAnimation(self.Click)
                self.IsSelect=true
            end
        else
            if Id==Avatar.HeadFrameId then
                self:PlayAnimation(self.Select_Normal)
                --self:PlayAnimation(self.Click)
                self.IsSelect=true
            end
            if Id== -1 then
                self.Icon_Empty:SetVisibility(UIConst.VisibilityOp.Visible)
            end
        end
    end
    if self.IsSelect then
        self:SetGamePadFocus()
    else
        self:PlayAnimation(self.UnSelect)
    end
end

function Menu_Portrait_PC_C:SetGamePadFocus()
    if UIUtils.UtilsGetCurrentInputType()==ECommonInputType.Gamepad then
        if  self.GameInputModeSubsystem then
            self.GameInputModeSubsystem:SetTargetUIFocusWidget(self)
            self.GameInputModeSubsystem:UpdateCurrentFocusWidgetPos()
            --self:SetFocus()
        end
    end
end


function Menu_Portrait_PC_C:OnListItemObjectSet(Content)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
    self.Owner=Content.Owner
    self.Content=Content
    self:StopAllAnimations()
    --self:PlayAnimation(self.Normal)
    --self:PlayAnimation(self.UnSelect)
    if not Content.IsEmpty and Content.IsLocked then
        self:PlayAnimation(self.HaveNot_Normal)
    else
        self:PlayAnimation(self.Normal)
    end
    -- if not Content.IsLocked then
    --     self:PlayAnimation(self.UnSelect)
    -- end
    self.Img_Item:SetVisibility(UIConst.VisibilityOp.Visible)
    self.Btn_Click:SetVisibility(UIConst.VisibilityOp.Visible)
    self:SetVisibility(UIConst.VisibilityOp.Visible)
    self.New:SetEnable(false)
    self.Icon_Empty:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.IsSelect=false
    if Content.IsEmpty then
        self.IsEmpty=true
        Content.SelfWidget=self
        self:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        --self.Btn_Click:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        --self.Img_Item:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Switch_Type:SetActiveWidgetIndex(1)
        return
    end
    self.Switch_Type:SetActiveWidgetIndex(0)
    Content.SelfWidget=self
    self.IsHeadFrame=Content.IsHeadFrame
    self.PortraitId=Content.PortraitId
    if Content.PortraitId ==-1 then
        self.Img_Item:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    self:SetImage(Content.PortraitPath, Content.PortraitId,Content.IsHeadFrame)
    if Content.IsHeadFrame then
        self:AddReddotListener("PortraitFrame",self.OnPortraitFrameReddotChange)
    else
        self:AddReddotListener("Portrait",self.OnPortraitReddotChange)
    end
    self.Btn_Click.OnClicked:Add(self,self.OnClicked)
    self.Btn_Click.OnPressed:Add(self,self.OnPressed)
    self.Btn_Click.OnHovered:Add(self,self.OnHovered)
    self.Btn_Click.OnUnHovered:Add(self,self.OnUnHovered)
    self.Btn_Click.OnReleased:Add(self, self.OnBtnReleased)
end

function Menu_Portrait_PC_C:OnHovered()
    self.IsHover=true
    if not self.IsSelect then
        if self.Content.IsLocked then
            self:PlayAnimation(self.HaveNot_Hover)
        else
            self:PlayAnimation(self.Hover)
        end
    end
end

function Menu_Portrait_PC_C:OnFocusReceived(MyGeometry, InFocusEvent)
    if  self.GameInputModeSubsystem and UIUtils.UtilsGetCurrentInputType()==ECommonInputType.Gamepad then
        if not self.Owner then
            return Menu_Portrait_PC_C.Super.OnFocusReceived(self, MyGeometry, InFocusEvent)
        end
        self.GameInputModeSubsystem:SetTargetUIFocusWidget(self)
        self.GameInputModeSubsystem:UpdateCurrentFocusWidgetPos()
        self:AddTimer(0.01,function ()
            self.Owner:OnListItemClicked(self.Content)
        end,false,0,nil,true)
    end
    return Menu_Portrait_PC_C.Super.OnFocusReceived(self, MyGeometry, InFocusEvent)
end

function Menu_Portrait_PC_C:OnUnHovered()
    self.IsHover=false
    if not self.IsSelect then
        self:StopAnimation(self.Hover)
        self:StopAnimation(self.HaveNot_Hover)
        if self.Content.IsLocked then
            self:PlayAnimation(self.HaveNot_UnHover)
        else
            self:PlayAnimation(self.UnHover)
        end
    end
end

function Menu_Portrait_PC_C:OnPressed()
    if UIUtils.UtilsGetCurrentInputType()==ECommonInputType.Gamepad then
        return
    end
    if self.Content.IsLocked then
        self:PlayAnimation(self.HaveNot_Press)
    else
        self:PlayAnimation(self.Press)
    end
end

function Menu_Portrait_PC_C:OnBtnReleased()
    if UIUtils.UtilsGetCurrentInputType()==ECommonInputType.Gamepad then
        return
    end
    self:StopAllAnimations()
    if self.Content.IsLocked then
        self:PlayAnimation(self.HaveNot_Normal)
    else
        self:PlayAnimation(self.Normal)
    end
    -- if not self.Content.IsLocked then
    --     if self.IsHover then
    --         self:PlayAnimation(self.Click)
    --     end
    -- else
    --         self:PlayAnimation(self.HaveNot)
    -- end
    if self.IsHover then
        if self.Content.IsLocked then
            self:PlayAnimation(self.HaveNot_Click)
        else
            self:PlayAnimation(self.Click)
        end
    end
end

function Menu_Portrait_PC_C:OnClicked()
    if UIUtils.UtilsGetCurrentInputType()==ECommonInputType.Gamepad then
        -- local Avatar = GWorld:GetAvatar()
        -- if Content.PortraitId== Avatar.HeadIconId or (Content.PortraitId== Avatar.HeadFrameId and Content.IsHeadFrame) then
        --     return
        -- end
        -- if  self.SelectId==Content.PortraitId then
        --     self:ConfirmChange()
        --     self.GameInputModeSubsystem:SetTargetUIFocusWidget(Content.SelfWidget)
        --     self.GameInputModeSubsystem:UpdateCurrentFocusWidgetPos()
        --     return
        -- end
        if self.Owner.Switcher_Btn:GetActiveWidgetIndex()==0 then
            self.Owner:ConfirmChange()
        end
    else
        self.Owner:OnListItemClicked(self.Content)
    end
end

-- function Menu_Portrait_PC_C:BP_OnItemSelectionChanged(IsSelected)
--     if not IsSelected then
--         self:PlayAnimation(self.Normal)
--         self.IsSelect=false
--     end
-- end

function Menu_Portrait_PC_C:AddReddotListener(ReddotNodeName,func)
    if self.ListenedReddot then
        local RootNode = ReddotManager.GetTreeNode(ReddotNodeName)
        func(self,RootNode.Count)
        return
    end
    self:RemoveReddotListener(ReddotNodeName)
    ReddotManager.AddListener(ReddotNodeName,self, func)
    self.ListenedReddot = true
end

function Menu_Portrait_PC_C:RemoveReddotListener(ReddotNodeName)
    if(self.ListenedReddot) then
        ReddotManager.RemoveListener(ReddotNodeName,self)
        self.New:SetEnable(false)
        self.ListenedReddot = false
    end
end

function Menu_Portrait_PC_C:OnPortraitReddotChange(Count)
    local CacheKey = self.Content.PortraitId
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("Portrait")
    self.New:SetEnable(CacheDetail[CacheKey] and Count>0)
end

function Menu_Portrait_PC_C:OnPortraitFrameReddotChange(Count)
    local CacheKey = self.Content.PortraitId
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("PortraitFrame")
    self.New:SetEnable(CacheDetail[CacheKey] and Count>0)
end

function Menu_Portrait_PC_C:Destruct()
    self:PlayAnimation(self.UnSelect)
    self:PlayAnimation(self.Normal)
    if self.IsHeadFrame then
        self:RemoveReddotListener("PortraitFrame",self.OnPortraitFrameReddotChange)
    else
        self:RemoveReddotListener("Portrait",self.OnPortraitReddotChange)
    end
    self.Super.Destruct(self)
end

function Menu_Portrait_PC_C:OnKeyDown(MyGeometry, InKeyEvent)
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    -- 处理手柄相关的交互事件
    if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
        if (InKeyName == "Gamepad_FaceButton_Bottom") then
            --   IsEventHandled=true
            --   self.Common_Item_Icon:OnMouseButtonUp()
        elseif InKeyName == "Gamepad_FaceButton_Right" then
                IsEventHandled=true
                -- self.Common_Item_Icon:OnMouseButtonUp()
        end
    end
    return IsEventHandled
end

function Menu_Portrait_PC_C:ClearData()
    if self.IsHeadFrame then
        self:RemoveReddotListener("PortraitFrame",self.OnPortraitFrameReddotChange)
    else
        self:RemoveReddotListener("Portrait",self.OnPortraitReddotChange)
    end
    self.IsHeadFrame=nil
    self.PortraitId=nil
    self.New:SetEnable(false)
    self.IsEmpty=false
end


return  Menu_Portrait_PC_C
