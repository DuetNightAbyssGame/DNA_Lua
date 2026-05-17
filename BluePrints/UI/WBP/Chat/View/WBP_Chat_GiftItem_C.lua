--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local ChatController = require "BluePrints.UI.WBP.Chat.ChatController"

---@type WBP_Chat_GiftItem_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.Text_GiftTitle:SetText(GText("UI_SendGift_TalkTitle"))
    self.Text_GiftBtn:SetText(GText("UI_SendGift_GotoMail"))
    self.Btn_Click.OnClicked:Add(self, self.OnGiftBtnClicked)
end

function M:Destruct()
    self.Btn_Click.OnClicked:Remove(self, self.OnGiftBtnClicked)
end

---@param GiftInfo table
---@param bSelfMsg boolean
function M:InitChatGiftItem(GiftInfo, bSelfMsg)
    self.bSelfMsg = bSelfMsg
    self.GiftInfo = GiftInfo
    self.MailId = nil
    self:UpdateBtnState()
    self:UpdateGiftItem()
end

function M:UpdateGiftItem()
    local Avatar = GWorld:GetAvatar()
    if self.bSelfMsg then
        self:PlayAnimation(self.Received)
        local GiftRecords = nil
        if self.GiftInfo.bGiftReceived then
            self.Group_Got:SetVisibility(UIConst.VisibilityOp["Visible"])
            self.Text_GiftBtn:SetText(GText("UI_SendGift_GetSuccess"))
            GiftRecords = Avatar.RecvGiftRecords
        else
            self.Group_Got:SetVisibility(UIConst.VisibilityOp["Collapsed"])
            self.Text_GiftBtn:SetText(GText("UI_SendGift_SendSuccess"))
            GiftRecords = Avatar.SentGiftRecords
        end

        local GiftData = nil
        if GiftRecords and CommonUtils.Size(GiftRecords) > 0 then
            GiftData = GiftRecords[self.GiftInfo.Index or 1]
        end
        
        if GiftData then
            if GiftData.bGiftMailGot then
                self.Text_GiftBtn:SetText(GText("UI_SendGift_GetSuccess"))
            end

            self.Text_ItemDesc:SetText(GText(GiftData.Content))
            local ShopItemData = DataMgr.ShopItem[GiftData.ShopItemId]
            if ShopItemData == nil then
                ScreenPrint("ShopItem表没有对应的物品ID, ShopItemId: " .. tostring(GiftData.ShopItemId))
                return
            end
            local ResourceConfig = DataMgr[ShopItemData.ItemType] and DataMgr[ShopItemData.ItemType][ShopItemData.TypeId]
            if ResourceConfig then
                self:SetGiftItemImage(ResourceConfig.Icon)
                self.Text_ItemName:SetText(GText(ResourceConfig.Name or ResourceConfig.ResourceName))
            end
            local ItemType = DataMgr.ShopTabSub[ShopItemData.GiftSubTabId].SubName
            if ItemType then
                self.Text_ItemType:SetText(GText(ItemType))
            end
        end
    else
        local GiftRecords = nil
        if self.GiftInfo.bGiftReceived then
            self:PlayAnimation(self.Received)
            self.Group_Got:SetVisibility(UIConst.VisibilityOp["Visible"])
            self.Text_GiftBtn:SetText(GText("UI_SendGift_GetSuccess"))
            GiftRecords = Avatar.SentGiftRecords
        else
            self.Group_Got:SetVisibility(UIConst.VisibilityOp["Collapsed"])
            GiftRecords = Avatar.RecvGiftRecords
        end
        local GiftData = nil
        if GiftRecords and CommonUtils.Size(GiftRecords) > 0 then
            GiftData = GiftRecords[self.GiftInfo.Index or 1]
        end
        if GiftData then
            if not self.GiftInfo.bGiftReceived then
                self.MailId = GiftData.MailUniqueId or 0
                local bGiftCanGet = self:FindRecvGiftState()
                if bGiftCanGet then
                    self.Text_GiftBtn:SetText(GText("UI_SendGift_GotoMail"))
                else
                    self:PlayAnimation(self.Received)
                    self.Text_GiftBtn:SetText(GText("UI_SendGift_GetSuccess"))
                end
            end
            local ShopItemData = DataMgr.ShopItem[GiftData.ShopItemId]
            if ShopItemData == nil then
                ScreenPrint("ShopItem表没有对应的物品ID, ShopItemId: " .. tostring(GiftData.ShopItemId))
                return
            end
            local ResourceConfig = DataMgr[ShopItemData.ItemType] and DataMgr[ShopItemData.ItemType][ShopItemData.TypeId]
            if ResourceConfig then
                self:SetGiftItemImage(ResourceConfig.Icon)
                self.Text_ItemName:SetText(GText(ResourceConfig.Name or ResourceConfig.ResourceName))
            end
            local ItemType = DataMgr.ShopTabSub[ShopItemData.GiftSubTabId].SubName
            if ItemType then
                self.Text_ItemType:SetText(GText(ItemType))
            end
            self.Text_ItemDesc:SetText(GText(GiftData.Content))
        end
    end
end

function M:FindRecvGiftState()
    local Avatar = GWorld:GetAvatar()
    local starMail = Avatar.StarMails:FindMail(self.MailId)
    local nomalMail = Avatar.MailInbox:FindMail(self.MailId)
    if starMail then
        if starMail.RewardGot then
            if starMail.RewardGot == 0 then
                return true
            else
                return false
            end
        end
    end
    if nomalMail then
        if nomalMail.RewardGot then
            if nomalMail.RewardGot == 0 then
                return true
            else
                return false
            end
        end
    end
    -- return false
    return true
end

function M:OnGiftBtnClicked()
    ChatController:GetView():Close()
    UIUtils.OpenSystem(10,false,self.MailId)
end

function M:SetGiftItemImage(ImgPath)
    if not ImgPath then return end
    local Img = LoadObject(ImgPath)
    if not IsValid(Img) then return end
    local Material = self.Image_Item:GetDynamicMaterial()
    if Material then
        Material:SetTextureParameterValue("IconMap", Img)
    else
        self.Image_Item:SetBrushResourceObject(Img)
    end
end

function M:UpdateBtnState()
    if self.bSelfMsg or self.GiftInfo.bGiftReceived then
        self.Btn_Click:SetVisibility(UIConst.VisibilityOp["HitTestInvisible"])
    else
        self.Btn_Click:SetVisibility(UIConst.VisibilityOp["Visible"])
    end
end

return M
