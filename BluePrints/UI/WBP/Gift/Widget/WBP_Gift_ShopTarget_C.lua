--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Gift_ShopTarget_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})
local GiftController = require "BluePrints.UI.WBP.Gift.GiftController"

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end
function M:Init(FriendUid, FriendChangeCallBack)
    self.FriendUid = FriendUid
    self.FriendChangeCallBack = FriendChangeCallBack
    self:FreshFriend(FriendUid)
    if self.Com_ItemHead and self.Com_ItemHead.SetVisibility then
        self.Com_ItemHead:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    end
    self.Btn_Change:SetGamePadImg("X")  
end

function M:FreshFriend(FriendUid)
    local uid = FriendUid or self.FriendUid
    local Avatar = GWorld:GetAvatar()
    local FriendDict = Avatar and Avatar.Friends or nil
    local Friend = FriendDict and FriendDict[uid] or nil

    if Friend and Friend.Info then
        local Info = Friend.Info
        if self.Com_ItemHead and self.Com_ItemHead.SetHeadFrame then
            self.Com_ItemHead:SetHeadFrame(Info.HeadFrameId)
        end
        if self.Com_ItemHead and self.Com_ItemHead.SetHeadIconById then
            self.Com_ItemHead:SetHeadIconById(Info.HeadIconId or 10001)
        end
        if self.Text_TargetName and self.Text_TargetName.SetText then
            self.Text_TargetName:SetText(Info.Nickname)
        end
    else
        -- if self.Com_ItemHead and self.Com_ItemHead.SetHeadIconEmpty then
        --     self.Com_ItemHead:SetHeadIconEmpty(true)
        -- end
    end
end

function M:Construct()
    self.Text_TargetTitle:SetText(GText("UI_SendGift_SendTo"))
    if self.Btn_Change and self.Btn_Change.Button_Area and self.Btn_Change.Button_Area.OnClicked then
        self.Btn_Change.Button_Area.OnClicked:Add(self, self.OnClick_Change)
    end
    self.Btn_Change.Text_Button:SetText(GText("UI_SendGift_ChooseFriendEntry"))
end

function M:OnClick_Change()
    GiftController:OpenChangeFriendPopup(self.FriendUid, function (FriendUid)
        self.FriendUid = FriendUid
        self:FreshFriend(FriendUid)
        if self.FriendChangeCallBack then
            self.FriendChangeCallBack(self.Parent,FriendUid)
        end
    end,self.Parent)
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end


return M
