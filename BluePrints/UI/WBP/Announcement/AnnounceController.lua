local AnnounceCommon = require "BluePrints.UI.WBP.Announcement.AnnounceCommon"
local CdnTool = require "BluePrints.UI.GameLogin.CdnTool"
local AnnounceModel = require "BluePrints.UI.WBP.Announcement.AnnounceModel"
local Utils = require "Utils"
local EMCache = require "EMCache.EMCache"

---@class AnnounceController:Controller
local M = Class("BluePrints.Common.MVC.Controller")

function M:Init()
    if not Utils then 
        Utils = require "Utils"
    end
    self:Destory()
    M.Super.Init(self)
    self.bInit = false
    self.PendingCo = nil
    self.bFontLoading = false
    DebugPrint("AnnounceController:Init!!!!!!!!!!")
    self:GetModel():LoadResource(true)  
end


---@return AnnounceModel
function M:GetModel()
    return AnnounceModel
end

function M:GetEventName()
    return EventID.AnnounceControllerEvent
end

function M:ResetConf()
    self.bInit = false
    self:GetModel():ResetConf()
end


function M:GetAnnouncementDataAsync(ShowTag, Coroutine, HostId)
    local Avatar = self:GetAvatar()
    if Avatar then
        if not self:GetModel():IsDirty() then
            return
        end
        self:GetModel():MarkDirty()
    end
    if HostId == nil then
        if Avatar and Avatar.Hostnum then
            HostId = tonumber(PlayerAvatar.Hostnum)
        else
            Utils.Traceback(ErrorTag, LXYTag.."HostId不存在，不知道你选了什么服...")
            return
        end
    end
    ForceStopAsyncTask(M, "PendingCo")
    self.PendingCo = Coroutine
    self:GetModel():CacheLastConf()
    self:GetModel().bInit = true
    self:GetModel():ResetConf()
    self:GetModel():_ResetReddot()
    DebugPrint("[Laixiaoyang] self:GetAnnoucementDataAsync 拉取后台游戏公告数据...")
    CdnTool:GetGameNotice(HostId,function (Infos)
        try ({
            exec = function() 
                if IsEmptyTable(Infos) then 
                    DebugPrint(WarningTag, LXYTag, "公告Json解析不出内容")
                    return 
                end
                for Key,Info in pairs(Infos) do
                    self:GetModel():_AddNewConf(Info,ShowTag)
                end
            end,
            catch = function(e)
			    print(ErrorTag, e.."\n"..debug.traceback())
            end,
            final = function ()
                self:GetModel():_SortConfs()
                self:GetModel():_SyncReddotCache()
                if (self.PendingCo) then
                    coroutine.resume(self.PendingCo)
                end
            end
        })
    end)
    if self.PendingCo then 
        coroutine.yield() 
    end
    self.PendingCo = nil
end


function M:UpdateAnnouncementDataInGame()
    local Avatar = self:GetAvatar()
    local Node = ReddotManager.GetTreeNode(DataMgr.ReddotNode.AnnouncementItems.Name)
    local OldCount = Node and Node.Count or 0
    if Avatar then
        self:GetAnnouncementDataAsync(AnnounceCommon.ShowTag.InGame, nil,Avatar.Hostnum)  -- 1.需要时拉取公告
    end
    self:GetModel():_ActivateScheduledNotices()
    local NewCount = Node and Node.Count or 0
    if NewCount > OldCount then
        ReddotManager.IncreaseLeafNodeCount("AnnouncementDirty")
    end
end

M.bNewUI = true
M.AnnounceMainUI = nil
function M:OpenAnnouncementMain(ShowTag, bNeedRequest, HostId, ParentWidget, Coroutine)
    if self.bFontLoading then
        UIManager(GWorld.GameInstance):ShowUITip(UIConst.Tip_CommonToast ,GText("UI_Toast_NetDelay"))
        return
    end
    ReddotManager.ClearLeafNodeCount("AnnouncementDirty")
    if not M.bNewUI then
        self:OpenAnnouncementMain_Old(ShowTag, bNeedRequest, HostId, ParentWidget, Coroutine)
        return
    end
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
    if IsValid(Player) then
        UIUtils.OpenSystem(AnnounceCommon.MainUIId,true,bNeedRequest, HostId, ShowTag, 1)
    else
        self:OpenView(nil,"AnnouncementMain",bNeedRequest, HostId, ShowTag, 1)
    end
    self:_TryHideLoginUI()
    M.AnnounceMainUI = self:GetUIMgr():GetUIObj("AnnouncementMain")
end

function M:OpenAnnouncementMain_Old(ShowTag, bNeedRequest, HostId, ParentWidget, Coroutine)
    local CurMode =  UIUtils.UtilsGetCurrentInputType()
    local PlatformName = CommonUtils.GetDeviceTypeByPlatformName(GWorld.GameInstance)
    if CurMode == ECommonInputType.Gamepad then
        PlatformName = "GamePad"
    end
    local Params = {
        bNeedRequest = bNeedRequest,
        HostId = HostId,
        ShowTag = ShowTag,
        CurrTabIdx = 1,
        TabConfigData = {
            PlatformName = PlatformName,
            Tabs = {
                {
                    Text = GText(DataMgr["NoticeTab"][1]["Text"]),
                    TabId = 1,
                    Icon = DataMgr["NoticeTab"][1]["IconPath"]
                },
                {
                    Text = GText(DataMgr["NoticeTab"][2]["Text"]),
                    TabId = 2,
                    Icon = DataMgr["NoticeTab"][2]["IconPath"]
                },
                {
                    Text = GText(DataMgr["NoticeTab"][3]["Text"]),
                    TabId = 3,
                    Icon = DataMgr["NoticeTab"][3]["IconPath"]
                }
            },
            ChildWidgetBPPath = "WidgetBlueprint'/Game/UI/WBP/Announcement/Widget/WBP_Announcement_TabItem.WBP_Announcement_TabItem'"
        }
    }
    M.AnnounceMainUI = UIManager(GWorld.GameInstance):ShowCommonPopupUI(100134, Params, ParentWidget, Coroutine)
end

function M:_TryHideLoginUI()
    local LoginUI = self:GetUIMgr():GetUIObj("LoginMainPage")
    if LoginUI then
        LoginUI:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

function M:_TryShowLoginUI()
    local LoginUI = self:GetUIMgr():GetUIObj("LoginMainPage")
    if LoginUI then
        LoginUI:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
end

function M:OnCloseAnnounceMainUI()
    self:_TryShowLoginUI()
end

function M:TryCloseAnnounceMainUI()
    if IsValid(M.AnnounceMainUI) then
        M.AnnounceMainUI:Close()
        self:ClearAnnounceMainUI()
    end
end

function M:ClearAnnounceMainUI()
    M.AnnounceMainUI = nil
end

_G.AnnounceController = M
return M