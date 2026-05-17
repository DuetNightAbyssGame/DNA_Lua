--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Fame_Reward_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

function M:Destruct()
    local EmptySlot = UWidgetLayoutLibrary.SlotAsCanvasSlot(self.BigReward_Img)
    local Offsets = EmptySlot:GetOffsets()
    Offsets.Bottom = self.OriginalBottomValue
    Offsets.Right = self.OriginalRightValue
    EmptySlot:SetOffsets(Offsets)
end

function M:Init(Content)
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.In)
    rawset(self, "CurRegionId", Content.CurRegionId)
    rawset(self, "OnMenuOpenChanged", Content.OnMenuOpenChanged)
    rawset(self, "Parent", Content.Parent)
    rawset(self, "CurrentFameLevel", Content.CurrentFameLevel)

    self:InitBigReward()
    self:InitRewardList()
end

-- 获取当前需要显示的大奖等级
function M:GetNeedShowBigRewardLevel()
    local ReputationBigRewardData = DataMgr.FameLevelBigReward[self.CurRegionId]
    if not ReputationBigRewardData then
        return
    end

    local CurrentBigRewardLevel = 0
    for _, Level in ipairs(ReputationBigRewardData) do
        if self.CurrentFameLevel <= Level then
            CurrentBigRewardLevel = Level
            break
        end
        -- 若没配更高级的大奖，则用当前最高的大奖
        CurrentBigRewardLevel = Level
    end

    return CurrentBigRewardLevel
end

function M:InitBigReward()
    local ReputationLevelData = DataMgr.ReputationLevel[self.CurRegionId]
    if not ReputationLevelData then
        return
    end

    -- 获取目前要显示的大奖
    local BigRewardLevel = self:GetNeedShowBigRewardLevel()
    local BigRewardData = ReputationLevelData[BigRewardLevel]
    if not BigRewardData then
        return
    end

    -- 设置图片
    local DefaultImgPath = "/Game/UI/Texture/Dynamic/Atlas/Prop/Item/T_Resource_Raid_Ticket.T_Resource_Raid_Ticket"
    local BigRewardImgPath = BigRewardData.CarouselContent and BigRewardData.CarouselContent or DefaultImgPath
    local ImgObj = LoadObject(BigRewardImgPath)
    if not ImgObj then
        ImgObj = LoadObject(DefaultImgPath)
        DebugPrint(ErrorTag, string.format("WBP_Fame_Reward_C 用错图标路径了！！！这里用默认的图标顶一下\n 错误的路径是：%s", BigRewardImgPath))
    end
    local ImgDynMaterial = self.BigReward_Img:GetDynamicMaterial()
    if ImgDynMaterial then
        ImgDynMaterial:SetTextureParameterValue("IconTex", ImgObj)
    end

    local TargetSize = self.ItemIcon
    if BigRewardData.IsHeadshot then
        TargetSize = self.ItemHead
    end
    local EmptySlot = UWidgetLayoutLibrary.SlotAsCanvasSlot(self.BigReward_Img)
    local Offsets = EmptySlot:GetOffsets()
    rawset(self, "OriginalBottomValue", Offsets.Bottom)
    rawset(self, "OriginalRightValue", Offsets.Right)
    Offsets.Bottom = Offsets.Bottom * TargetSize
    Offsets.Right = Offsets.Right * TargetSize
    EmptySlot:SetOffsets(Offsets)

    -- 设置文本
    local BigRewardName = BigRewardData.CarouselTitle and BigRewardData.CarouselTitle or "未配表 临时名称"
    self.TextRewardName:SetText(GText(BigRewardName))
    self.RichTextRewardLevel:SetText(string.format(GText("ReputationLevel_GrandReward_Title"), BigRewardLevel))
    self.Text01:SetText(GText("ReputationLevel_RewardPreview"))
end

function M:InitRewardList()
    local RegionReputationRewardsData = DataMgr.ReputationLevel[self.CurRegionId]
    if not RegionReputationRewardsData then
        return
    end
    -- 获取目前要显示的大奖等级
    local BigRewardLevel = self:GetNeedShowBigRewardLevel()
    local RewardData = RegionReputationRewardsData[BigRewardLevel]
    if not RewardData then
        return
    end
    local BigRewardView = RewardData.RewardView
    if not BigRewardView then
        DebugPrint(ErrorTag, "WBP_Fame_Reward_C 大奖预览数据不存在"..tostring(BigRewardLevel))
        return
    end

    local BigRewardViewData = DataMgr.RewardView[BigRewardView]
    if not BigRewardViewData then
        DebugPrint(ErrorTag, "WBP_Fame_Reward_C BigRewardView 配置的大奖预览数据不存在")
        return
    end
    self.List_Item:ClearListItems()
    for i = 1, #BigRewardViewData.Id do
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        local Id = BigRewardViewData.Id[i]
        local Type = BigRewardViewData.Type[i]
        local ResourceInfo
        if DataMgr[Type] and DataMgr[Type][Id] then
            ResourceInfo = DataMgr[Type][Id]
        else
            UEPrint(string.format("WBP_Fame_ListItem_C InitRewardList not find ResourceInfo Data Type:%s Id:%d", tostring(Type), tostring(Id)))
            ResourceInfo = {
                Rarity = 1,
                Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/Head/Monster/T_Head_Empty.T_Head_Empty'"
            }
        end
        Content.ItemType = Type
        Content.Id = Id
        Content.Rarity = ResourceInfo.Rarity
        Content.Icon = ResourceInfo.Icon
        Content.IsShowDetails = true
        Content.OnMenuOpenChangedEvents = {Obj = self.Parent, Callback = self.OnMenuOpenChanged}
        self.List_Item:AddItem(Content)
    end
end

--region 手柄相关

function M:UpdateUIStyleInPlatform()
    if not self.Parent then
        return
    end
    if self.Parent.CurInputDeviceType == ECommonInputType.Gamepad then
        if not rawget(self, "GamePadKeyInited") then
            rawset(self, "GamePadKeyInited", true)
            self.WBP_Com_KeyImg_13:CreateCommonKey({KeyInfoList = {{
                Type = "Img",
                ImgLongPath = UIUtils.UtilsGetKeyIconPathInGamepad("LS", self.Parent.CurGamepadName)}
            }})
        end
        self.WBP_Com_KeyImg_13:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
        self.WBP_Com_KeyImg_13:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

--endregion

return M
