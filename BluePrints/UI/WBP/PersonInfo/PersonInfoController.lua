--- 个人主页Controller
local PersonInfoModel = require "BluePrints.UI.WBP.PersonInfo.PersonInfoModel"
local PersonInfoCommon = require "BluePrints.UI.WBP.PersonInfo.PersonInfoCommon"
local PersonInfoEditModel = require "BluePrints.UI.WBP.PersonInfo.Edit.PersonInfoEditModel"
local PersonInfoDataModel= require "BluePrints.UI.WBP.PersonInfo.Data.PersonInfoDataModel"
local M = Class("BluePrints.Common.MVC.Controller")

M.PageEnum = {
    MainPage = 1,
    EditPage = 2,
    DataPage = 3
}
function M:GetPageEnum()
    return M.PageEnum
end
function M:Init()
    M.Super.Init(self)
    PersonInfoEditModel:Init()
    self.CurPage = nil
end

function M:Destory()
    M.Super.Destory(self)
end

function M:GetModel()
    return PersonInfoModel
end
function M:GetEdirModel()
    return PersonInfoEditModel
end
function M:GetEventName()
    return EventID.PersonInfoControllerEvent
end

--[[
打开自己主页
gm showpersonalinfopage
打开自己主页，使用服务端数据
gm showpersonalinfopage 1
]]
-- region 界面操作
--- func desc
---@param PlayerInfo 服务端数据，打开自己的不用传
---@param ForceServerData 强制使用服务端数据，默认false
function M:OpenView(PlayerInfo,ForceServerData)
    if PlayerInfo and PlayerInfo.Uuid == PersonInfoModel._Avatar.Uid and (ForceServerData~=true) then
       PlayerInfo=nil ---如果是当前角色，就直接使用当前角色信息,取消注释这行，可以以查看他人样式查看自己主页
    end
    if PlayerInfo then
        PersonInfoModel:SetPersonID(PlayerInfo.Uid)
    end
    self.CurPage = M.PageEnum.MainPage
    PersonInfoModel:InitData(PlayerInfo)
    self.bReturnMain = false -- 此变量用于返回主界面没有角色时不再移动镜头
    self.MainPage = M.Super.OpenView(self, nil, PersonInfoCommon.UIName)
    self.MainPage:SetFocus()
    self.CurPage = M.PageEnum.MainPage
    return self.MainPage
end
function M:OpenEditView(TabName, BoxIndex)
    if self.CurPage == M.PageEnum.EditPage then
        return
    end
    self.CurPage = M.PageEnum.EditPage
    self:ExitMainPage()
    if   self.MainPage.PersonInfoMainPage.ActorController and self.MainPage.PersonInfoMainPage.ActorController.ArmoryPlayer then
        self.MainPage.PersonInfoMainPage.ActorController:HidePlayerActor("PersonInfoEdit", true)
    end
    local Platform = CommonUtils.GetDeviceTypeByPlatformName(self)
    local PCBluePrint
    if (Platform == "PC") then
        PCBluePrint = " WidgetBlueprint'/Game/UI/WBP/PersonalInfo/PC/WBP_PersonalInfo_Edit_P.WBP_PersonalInfo_Edit_P'"
    else
        PCBluePrint = "WidgetBlueprint'/Game/UI/WBP/PersonalInfo/Mobile/WBP_PersonalInfo_Edit_M.WBP_PersonalInfo_Edit_M'"
    end
    self.EditPage = UIManager(self):CreateWidget(PCBluePrint)
    if (self.EditPage == nil) then
        return
    end
    self.EditPage.Root = self.MainPage
    self.MainPage.Content:AddChildToOverlay(self.EditPage)
    local ContentOverlaySlot = UE4.UWidgetLayoutLibrary.SlotAsOverlaySlot(self.EditPage)
    ContentOverlaySlot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
    ContentOverlaySlot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
    self.EditPage:InitBaseView(TabName, BoxIndex)
    self.EditPage:SetFocus()
    self.EditPage:PlayAnimation(self.EditPage.In)

end
---打开数据统计界面
function M:OpenDataView()
    if self.DataPage and self.DataPage.IsClosing then
        DebugPrint("数据统计界面正在关闭中")
        return
    end
    self.CurPage = M.PageEnum.DataPage
    --
    self:ExitMainPageWithoutTab()

    -- 如果是他人的主页，传递服务端拉来的信息
    PersonInfoDataModel:Init(PersonInfoModel.OtherPersonInfo)
    -- 界面加载
    self:CreatDataPage()
    -- 初始化
    self.DataPage.Root = self.MainPage
    self.DataPage:InitBaseView()
    -- 镜头控制
    local ActorController = self.MainPage.PersonInfoMainPage.ActorController
    if self.MainPage.PersonInfoMainPage.SelectCharIndex ~= -1 then
        ActorController:SetMontageAndCamera("Char", nil, "Personal", "Data")
    end
    -- local t1, t2, t3, t4 = ActorController:CalcArmoryCameraTag("Char", nil, "Personal", "Data")
    -- ActorController:SetArmoryCameraTag(t1, t2, t3, t4)
    -- if self.MainPage.Com_BtnVisible then -- 隐藏移动端的按钮
    --     self.MainPage.Com_BtnVisible:SetVisibility(UIConst.VisibilityOp.Collapsed)
    -- end

end

function M:CreatDataPage()
    local Platform = CommonUtils.GetDeviceTypeByPlatformName(self)
    local PCBluePrint
    if (Platform == "PC") then
        PCBluePrint = "WidgetBlueprint'/Game/UI/WBP/PersonalInfo/PC/WBP_PersonalInfo_Data_P.WBP_PersonalInfo_Data_P'"
    else
        PCBluePrint = "WidgetBlueprint'/Game/UI/WBP/PersonalInfo/Mobile/WBP_PersonalInfo_Data_M.WBP_PersonalInfo_Data_M'"
    end
    self.DataPage = UIManager(self):CreateWidget(PCBluePrint)
    if (self.DataPage == nil) then
        ScreenPrint("--------------数据统计界面加载失败-----------------")
        return
    end
    self.MainPage.Content:AddChildToOverlay(self.DataPage)
    local ContentOverlaySlot = UE4.UWidgetLayoutLibrary.SlotAsOverlaySlot(self.DataPage)
    ContentOverlaySlot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
    ContentOverlaySlot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
    self.DataPage:SetFocus()
    self.DataPage.IsClosing=false
end
function M:OnCloseDateView()
    self.CurPage = M.PageEnum.MainPage
    ---镜头控制
    self.MainPage.PersonInfoMainPage:FreshCamera()
    ---页面恢复
    self.MainPage.PersonInfoMainPage:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.MainPage:InitTabInfo()
    self.MainPage.PersonInfoMainPage:PlayAnimation(self.MainPage.PersonInfoMainPage.In)
    self.DataPage:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.DataPage.IsClosing=true
    self.MainPage.PersonInfoMainPage:SetOriginFocus()
    if  self.MainPage.Com_BtnVisible then--恢复隐藏移动端的按钮
        self.MainPage.PersonInfoMainPage:FreshHideButton()
    end
end
function M:ReallyCloseDateView(Page)--把page通过参数传递是为了防止在真正关闭时，界面又被打开了
    if  not self.DataPage or    not self.DataPage.IsClosing then--如果关闭后重新打开了界面，就不关闭
        DebugPrint("没有数据统计界面，应该是打开时失败")
        return
    end
    --self.MainPage.HideUI_Key:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    if Page then
        Page:RemovefromParent()
    else
        DebugPrint("没有编辑界面，应该是打开时失败")
    end
    self.DataPage = nil

end
function M:CloseEditView()
    PersonInfoEditModel.Handler = nil
    if self.EditPage then
        self.EditPage:RemovefromParent()
        self.EditPage:PlayAnimation(self.EditPage.Out)
    else
        DebugPrint("没有编辑界面，应该是打开时失败")
    end
    self.bReturnMain = true -- 此变量用于主界面没有角色时不再移动镜头
    self:ReturnMainPage()
    self.CurPage = M.PageEnum.MainPage
end

function M:ExitMainPage()
    self.MainPage.MainPageItem:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.MainPage.PersonInfoMainPage:SetVisibility(UIConst.VisibilityOp.Collapsed)
end
function M:ExitMainPageWithoutTab()
    self.MainPage.PersonInfoMainPage:SetVisibility(UIConst.VisibilityOp.Collapsed)
    --self.MainPage.WBP_Com_BgSwitch:SetVisibility(UIConst.VisibilityOp.Collapsed)
end
function M:ReturnMainPage()
    self.CurPage = M.PageEnum.MainPage
    self.MainPage.MainPageItem:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    if    self.MainPage.PersonInfoMainPage.ActorController and self.MainPage.PersonInfoMainPage.ActorController.ArmoryPlayer then
        self.MainPage.PersonInfoMainPage.ActorController:HidePlayerActor("PersonInfoEdit", false)
    end
    self.MainPage.PersonInfoMainPage:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.MainPage.PersonInfoMainPage:InitDisplayBoxView(true)
    self.MainPage.PersonInfoMainPage:SetOriginFocus()
end

function M:GetView(WorldContex)
    return M.Super.GetView(self, WorldContex, PersonInfoCommon.UIName)
end
function M:GetPersonInfo(PlayerInfo)
    UIManager(self):ShowUITip("CommonToastMain", GText("TOAST_DUNGEON_CANCEL_LEAVETEAM"), 1.5)
    self:OpenView(PlayerInfo.Uid)
end
-- endregion
function M:RestoreHistoryRankTab()
    if self.DataPage then
        if self.DataPage.InitNormalBottonKey then
            self.DataPage:InitNormalBottonKey()
        elseif self.DataPage.InitTab then
            self.DataPage:InitTab()
        end
    elseif self.MainPage and self.MainPage.InitTabInfo then
        self.MainPage:InitTabInfo()
    end
end

function M:OnCloseGuildWarHistoryRank()
    if not self.HistoryRankPage then
        return
    end
    
    -- AudioManager(self):SetEventSoundParam(self.HistoryRankPage, "GuildWarHistoryRankOpen", {ToEnd = 1})

    if self.DataPage then
        self.DataPage:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.DataPage.IsClosing = false
    end
    self:RestoreHistoryRankTab()
    if self.DataPage and self.DataPage.SetFocus then
        self.DataPage:SetFocus()
    end
    
    self.HistoryRankPage.IsClosing = true
end

function M:ReallyCloseGuildWarHistoryRank(Page)
    if not self.HistoryRankPage or not self.HistoryRankPage.IsClosing then
        return
    end
    
    if Page then
        Page:RemovefromParent()
    end
    self.HistoryRankPage = nil
end

function M:CloseGuildWarHistoryRank()
   self:OnCloseGuildWarHistoryRank()
   self:ReallyCloseGuildWarHistoryRank(self.HistoryRankPage)
end

function M:OpenGuildWarHistoryRank()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local BaseInfo = PersonInfoModel:GetGuildWarHistoryBaseInfo()
    local function OpenWithRecord(RankRecord)
        -- if self.HistoryRankPage then
        --     self.HistoryRankPage:RemovefromParent()
        --     self.HistoryRankPage = nil
        -- end
        -- if self.DataPage then
        --     self.DataPage:SetVisibility(UIConst.VisibilityOp.Collapsed)
        --     self.DataPage.IsClosing = false
        -- end
        local TopNInfo = PersonInfoModel:BuildGuildWarHistoryTopN(BaseInfo, RankRecord or {})
        local SelfRankInfo = PersonInfoModel:BuildGuildWarHistorySelfRank(TopNInfo)
        local HistoryContext = {
            HistoryMode = true,
            BaseInfo = BaseInfo
        }
        
        UIManager(self):LoadUINew("PersonalInfoDataRanking", SelfRankInfo, TopNInfo, HistoryContext)
    end
    
    if PersonInfoModel.DebugCachedRankData then
        OpenWithRecord(PersonInfoModel.DebugCachedRankData)
        return
    end

    if PersonInfoModel:IsOwener() then
        Avatar:GetRaidSeasonRankRecord(function(ErrCode, Ret)
            if ErrorCode:Check(ErrCode) then
                OpenWithRecord(Ret)
            else
                OpenWithRecord({})
            end
        end)
        return
    end
    OpenWithRecord(PersonInfoModel.OtherRaidSeasonRankRecord or {})
end

function M:OnClose()
    local FocusWidget= UIManager(self):GetLastestAndFocusableUIWidgetObj()
    if FocusWidget and FocusWidget.SetFocus_Lua and type(FocusWidget.SetFocus_Lua)=="function"  then
        FocusWidget:SetFocus_Lua()
    end
    self.CurPage = nil
    self.MainPage = nil
    self.EditPage = nil
    self.DataPage = nil
    if self.HistoryRankPage then
        self.HistoryRankPage:RemovefromParent()
        self.HistoryRankPage = nil
    end
    PersonInfoModel:ClearModel()
    PersonInfoDataModel:ClearModel()
end
_G.PersonInfoController = M
return M

