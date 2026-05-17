require "UnLua"

---@type Common_Button_Image_PC_C|WBP_Com_BtnImg_C|Common_Button_PC
local Common_Button_Image_PC = Class("BluePrints.UI.UI_PC.Common.Common_Button.Common_Button_PC")

function Common_Button_Image_PC:Construct()
    -- 设置 红点 隐藏
    self.Reddot:SetVisibility(UE4.ESlateVisibility.Collapsed)
 
    self.Super.Construct(self, self.Button_Area)
end

-- 设置红点是否显示
function Common_Button_Image_PC:SetReddotVisibility(Op)
    self.Reddot:SetVisibility(Op)
end

-- 设置Block控件文本
function Common_Button_Image_PC:SetCurrentTextBlock(TextMapId)
    self.Text_Function:SetText(GText(TextMapId))
end

-- 设置红点的样式, 传入图片路径
function Common_Button_Image_PC:SetReddotStyle(ImgPath)
    self:SetReddotVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    UE4.UResourceLibrary.LoadObjectAsync(self, ImgPath,
    {self, function(_, Image)
        self.Reddot.Img_Light:SetBrushResourceObject(Image)
        self.Reddot.WS_Icon:SetActiveWidgetIndex(0)
     end})
end

---设置红点图标
function Common_Button_Image_PC:SetReddot(IsNew,Upgradeable,OhterReddot)
    if(IsNew)then
        self.New:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        self.Reddot:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        return
    end
    self.New:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    if(OhterReddot)then
        self.Reddot:SetReddotStyle(1)
        self.Reddot:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    elseif(Upgradeable)then
        self.Reddot:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    else
        self.Reddot:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end
end

function Common_Button_Image_PC:BindEventOnHover(obj, func)
    self.OnHoverObj = obj
    self.OnHoverFunc = func
end

function Common_Button_Image_PC:BindEventOnUnhover(obj, func)
    self.OnUnhoverObj = obj
    self.OnUnhoverFunc = func
end

function Common_Button_Image_PC:UnbindEventOnHover()
    self.OnHoverFunc = nil
    self.OnHoverObj = nil
end

function Common_Button_Image_PC:UnbindEventOnUnhover()
    self.OnUnhoverFunc = nil
    self.OnUnhoverObj = nil
end

function Common_Button_Image_PC:BindEventOnAddedToFocusPath(Obj,Event)
    self.Obj_OnAddedToFocusPath = Obj
    self.Event_OnAddedToFocusPath = Event
end

function Common_Button_Image_PC:BindEventOnRemovedFromFocusPath(Obj,Event)
    self.Obj_OnRemovedFromFocusPath = Obj
    self.Event_OnRemovedFromFocusPath = Event
end

function Common_Button_Image_PC:OnBtnHovered()
    if self.bHoldUp then 
        return
    end
    if(self.OnHoverFunc and self.OnHoverObj) then
        self.OnHoverFunc(self.OnHoverObj)
    end
    Common_Button_Image_PC.Super.OnBtnHovered(self)
end

function Common_Button_Image_PC:OnBtnUnhovered()
    if self.bHoldUp then 
        return
    end
    if(self.OnUnhoverFunc and self.OnUnhoverObj) then
        self.OnUnhoverFunc(self.OnUnhoverObj)
    end 
    Common_Button_Image_PC.Super.OnBtnUnhovered(self)
end
--是否保持按下状态
function Common_Button_Image_PC:SetHoldUp(bHoldUp)
    self.bHoldUp = bHoldUp
end
function Common_Button_Image_PC:SetHoldUpAnim(bHoldUp)
    self.bHoldUp = bHoldUp
    self:StopAllAnimations()
    self:PlayAnimation(bHoldUp and self.Hover or self.UnHover)
end

function Common_Button_Image_PC:OnAddedToFocusPath(MyGeometry, InFocusEvent)
    if(self.Event_OnAddedToFocusPath)then
        self.Event_OnAddedToFocusPath(self.Obj_OnAddedToFocusPath,self)
    end
end

function Common_Button_Image_PC:OnRemovedFromFocusPath(InFocusEvent)
    if(self.Event_OnRemovedFromFocusPath)then
        self.Event_OnRemovedFromFocusPath(self.Obj_OnRemovedFromFocusPath,self)
    end
end
-- 重写点击音效
---@param SoundPath string 点击音效路径 不传默认用小按钮的event:/ui/common/click_btn_small
function Common_Button_Image_PC:OverriddenSoundFunc(SoundPath)
    self:TryOverrideSoundFunc(function()
        AudioManager(self):PlayUISound(self, SoundPath or "event:/ui/common/click_btn_small","",nil)
    end)
end
return Common_Button_Image_PC