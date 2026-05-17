--
-- DESCRIPTION
-- 个人主要背景以及Tab View （PC、移动端公用）
-- @COMPANY **
-- @AUTHOR 叶轲
-- @DATE ${date} ${time}
--
require "UnLua"
local PersonInfoCommon = require "BluePrints.UI.WBP.PersonInfo.PersonInfoCommon"
local PersonInfoController = require "BluePrints.UI.WBP.PersonInfo.PersonInfoController"
local PersonInfoModel = PersonInfoController:GetModel()
local M = {}
M._components = {"BluePrints.UI.WBP.Armory.MainComponent.Armory_PointerInputComponent"}
function M:Construct()

    self:RefreshBaseInfo()
    if self.HideBegin and not self:IsAnimationPlaying(self.Bg_In) then
        self:SetRenderOpacity(0)
    end
    ---进入个人主页任务繁重，加载分帧处理
    self:AddTimer(0.231, function() -- 此时加载完UI，暂停
        self.PersonInfoMainPage:ModelViewIni()
    end)
end
function M:OnLoaded(...)
    self.Super.OnLoaded(self, ...)
    self.Platform = CommonUtils.GetDeviceTypeByPlatformName(self) -- 移动端还是PC端

    self:AddTimer(self.StartDelay or 0, function()
        if self.HideBegin then
            self:SetRenderOpacity(1)
        end
        DebugPrint("开始播动画")
        self.WBP_Com_BgSwitch:PlayAnimationForward(self.WBP_Com_BgSwitch.In, self.AniSpeed or 1)
        self:PlayInAnim()

    end)

end
function M:Close()
    DebugPrint("开始关闭")
    self.Content:ClearChildren()
    self.PersonInfoMainPage:OnClose()
    PersonInfoController:OnClose()
end
function M:PlayInAnim()
    AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "PersonInfoPageMain", nil)
    self:PlayAnimationForward(self.In)
end
function M:PlayOutAnim()
    AudioManager(self):SetEventSoundParam(self, "PersonInfoPageMain", {
        ToEnd = 1
    })
    self:UnbindAllFromAnimationFinished(self.Out)
    self:BindToAnimationFinished(self.Out, {self, self.Close})
    self.PersonInfoMainPage:PlayAnimationForward(self.PersonInfoMainPage.Out)
    -- self:BindToAnimationFinished(self.Out, {self, self.Close})
    self:PlayAnimationForward(self.Out)
end

function M:CheckIsCanCloseSelf()
    if self.PersonInfoMainPage.IsEditOpen then
        self.PersonInfoMainPage.IsEditOpen = false
        self.PersonInfoMainPage:PlayAnimation(self.PersonInfoMainPage.Edit_List_Out)
        return false
    end
    if (self:IsAnimationPlaying(self.In)) then
        return false
    end
    return true
end

function M:CreatePersonInfoMainPage(ConfigData)
    PersonInfoController.MainPage = self
    local PageMain = nil
    if (CommonUtils.GetDeviceTypeByPlatformName(self) == "PC") then
        PageMain = UIManager(self):CreateWidget(ConfigData.PCBluePrint)
    else
        PageMain = UIManager(self):CreateWidget(ConfigData.MobileBluePrint or ConfigData.PCBluePrint)
    end
    if (PageMain == nil) then
        return
    end

    self.Content:AddChildToOverlay(PageMain)
    local ContentOverlaySlot = UE4.UWidgetLayoutLibrary.SlotAsOverlaySlot(PageMain)
    ContentOverlaySlot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
    ContentOverlaySlot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
    return PageMain
end

return M
