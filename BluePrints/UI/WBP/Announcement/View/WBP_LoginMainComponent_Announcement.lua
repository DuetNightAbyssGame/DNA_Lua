require("UnLua")
local AnnouncementUtils = require("BluePrints.UI.WBP.Announcement.AnnounceUtils")
local Utils = require("Utils")
local ReddotNodeName = DataMgr.ReddotNode.AnnouncementItems.Name
local Component = {}

function Component:BindForAnnouncement()
  self.Btn_Announcement:Construct()
  self.Btn_Announcement:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.Btn_Announcement:BindEventOnReleased(self, self.OnClickAnnoucement)
  local HeroUSDKSubsystem = HeroUSDKSubsystem(self)
  local VisibilityTag = HeroUSDKSubsystem:IsHeroSDKEnable() and "Collapsed" or "SelfHitTestInvisible"
  self.Btn_Announcement:SetVisibility(UIConst.VisibilityOp[VisibilityTag])
  ReddotManager.AddListener(ReddotNodeName, self, self.UpdateAnnoucementReddot)
  if URuntimeCommonFunctionLibrary.IsPlayInEditor(self) then
    self:OpenAnnouncementOnce(true)
  end
end

function Component:UnbindForAnnouncement()
  self.Btn_Announcement:UnBindEventOnReleased(self, self.OnClickAnnoucement)
  ReddotManager.RemoveListener(ReddotNodeName, self)
end

function Component:UpdateAnnoucementReddot(Count)
  self.Btn_Announcement.New:SetEnable(Count > 0)
end

function Component:OpenAnnouncementOnce(bReset)
  self.Btn_Announcement:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  if self.Coroutine or UIManager(self):GetUIObj(DataMgr.SystemUI.AnnouncementMain.UIName) then
    return
  end
  if not self.ServerInfo then
    Utils.Traceback(ErrorTag, "公告自动弹出失败，登录模块提供的ServerInfo无效！！！")
    return
  end
  local HostId = self.ServerInfo.hostnum
  if bReset then
    AnnouncementUtils:ResetConf()
  end
  self.Coroutine = nil
  self.Coroutine = coroutine.create(function()
    DebugPrint("[Laixiaoyang]LoginMain::OpenAnnouncementOnce  自动弹出游戏公告")
    AnnouncementUtils:TrySetServerAreaNew(HostId)
    if not AnnouncementUtils.bInit then
      AnnouncementUtils:GetAnnouncementDataAsync(AnnounceCommon.ShowTag.InLogin, self.Coroutine, HostId)
    end
    if AnnouncementUtils.HasNewAdd then
      self:OnClickAnnoucement(false)
      AnnouncementUtils:ResetNew()
      HeroUSDKSubsystem(self):MSDKUploadCommonEventByEventName("game_anc")
    end
    self.Coroutine = nil
  end)
  coroutine.resume(self.Coroutine)
end

function Component:ClearOpenAnnouncementAsync()
  ForceStopAsyncTask(self, "OpenAnnouncementAsync")
end

function Component:OnClickAnnoucement(bNeedRequest)
  if nil == bNeedRequest then
    bNeedRequest = not AnnouncementUtils.bInit
  end
  self:ClearOpenAnnouncementAsync()
  RunAsyncTask(self, "OpenAnnouncementAsync", function(Coroutine)
    AnnouncementUtils:OpenAnnouncementMain(AnnounceCommon.ShowTag.InLogin, bNeedRequest, self.ServerInfo.hostnum, self, Coroutine)
  end)
end

return Component
