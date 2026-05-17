--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Armory_SkinVideo_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

function M:Construct()
    M.Super.Construct(self)
    rawset(self,"IsPC",CommonUtils.GetDeviceTypeByPlatformName(self) == "PC")
end

function M:OnBackKeyDown()
    self:Close()
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if(InKeyName == UE4.EKeys.Escape.KeyName or InKeyName == UIConst.GamePadKey.FaceButtonRight)then
        self:OnBackKeyDown()
        return UIUtils.Handled
    end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    self:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
    M.Super.OnUpdateUIStyleByInputTypeChange(self,CurInputDevice, CurGamepadName)
    self.IsGamepadInput = CurInputDevice == ECommonInputType.Gamepad
    if(self.IsPC)then
        self.Key_Esc:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.Btn_Close:SetVisibility(UIConst.VisibilityOp.Collapsed)
        if(self.IsGamepadInput)then
            self.Key_Esc:CreateCommonKey({
                KeyInfoList={
                    {
                        Type = "Img",
                        ImgShortPath = "B",
                        ClickCallback=self.OnBackKeyDown,
                        Owner=self
                    }
                },
                Desc = GText("UI_BACK"),
            })
        else
            self.Key_Esc:CreateCommonKey({
                KeyInfoList = {
                    {Type="Text", Text=CommonUtils:GetKeyText("Escape"), ClickCallback=self.OnBackKeyDown, Owner=self},
                },
                Desc = GText("UI_BACK"),
            })
        end
    else
        self.Key_Esc:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Btn_Close:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.Btn_Close:Init("Close",self,self.OnBackKeyDown)
    end
end


function M:InitUIInfo(Name, IsInUIMode, EventList, Params)
    M.Super.InitUIInfo(self, Name, IsInUIMode, EventList, Params)
    self:RefreshOpInfoByInputDevice(UIUtils.UtilsGetCurrentInputType())
    self.VideoPlayer:BindEventToMediaPlayEnd(self,self.OnVideoPlayEnd)
    self.VideoPlayer:SetIsNeedAudio(true)
    Params = Params or {}
    rawset(self,"DestructCB",Params.DestructCB)
    if(Params.MediaSource)then
        self.VideoPlayer:SetUrlByMediaSource(Params.MediaSource)
    elseif(Params.Url)then
        self.VideoPlayer:SetUrl(Params.Url)
    elseif(Params.Path)then
        local MediaSource = LoadObject(Params.Path)
        if(MediaSource)then
            self.VideoPlayer:SetUrlByMediaSource(MediaSource)
        end
    end
    if(Params.SoundPath)then
        AudioManager(self):PlayUISound(self, "event:/ui/common/gacha_amb", "GachaAmb", nil)
        AudioManager(self):PlayUISound(self, Params.SoundPath, "SkinVideoSound", nil)
    end
    self.VideoPlayer:Play()
end

function M:OnVideoPlayEnd()
    self:Close()
end

function M:Destruct()
    if(rawget(self,"bDestructed"))then
        return
    end
    rawset(self,"bDestructed",true)
    AudioManager(self):StopSound(self, "SkinVideoSound")
    AudioManager(self):SetEventSoundParam(self, "GachaAmb", {ToEnd=1})
    M.Super.Destruct(self)
    if(rawget(self,"DestructCB"))then
        self.DestructCB()
    end
end

return M
