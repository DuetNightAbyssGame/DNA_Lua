require "UnLua"

local GameFlowUtils = require "Utils.GameFlowUtils"
local HeroUSDKUtils = require "Utils.HeroUSDKUtils"

local M = {}

------------------------------------定义所有的自定义跳转逻辑---------------------------------------------
---函数的命名需要和InterfaceJump.xlsx之中的JumpParameter1保持一致
-- function M.RougeMainJump()
--     -- 执行对应的打开逻辑
-- end

-- 跳转到任务界面，并指定对应的QuestChainId
function M.JumpToTaskPanelByQuestChainId(QuestChainId)
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    local PlayerAvatar = GWorld:GetAvatar()

    -- 是否满足开启条件
    -- SelfDefinedJump不会走JumpToTargetPageByJumpId的判断 这里补一下
    local SystemUI = DataMgr.SystemUI["TaskPanel"]
    if (SystemUI and SystemUI.System) then
        local UIUnlockRuleInfo = DataMgr.UIUnlockRule[SystemUI.System]
        if (UIUnlockRuleInfo and UIUnlockRuleInfo.OpenConditionId) then
            local IsCanOpen, FailedIdIndex = PlayerAvatar:CheckSystemUICanOpen(UIUnlockRuleInfo.UIUnlockRuleId)
            if (not IsCanOpen) then
                local OpenConditionId = UIUnlockRuleInfo.OpenConditionId
                local OpenDescs = UIUnlockRuleInfo.OpenSystemDesc
                if #OpenConditionId == #OpenDescs then
                    for _, Value in pairs(FailedIdIndex) do
                        UIManager:ShowUITip(UIConst.Tip_CommonToast, OpenDescs[Value])
                    end
                else
                    UIManager:ShowUITip(UIConst.Tip_CommonToast, OpenDescs[1])
                end
                return
            end
        end
    end

    -- 跳转对应界面
    local JumpToPageUIName = "TaskPanel"
    local TargetUIPage = UIManager:GetUIObj(JumpToPageUIName)
    if (not TargetUIPage) then
        TargetUIPage = UIManager:LoadUINew(JumpToPageUIName, QuestChainId)
        UIManager:AddToJumpPageDeque(TargetUIPage)
    else
        -- 已经存在的界面
        UIManager:PlaceJumpUIToTop(TargetUIPage, JumpToPageUIName)
    end
end

function M.JumpToRegionMapByTeleportId(_TeleportId)
    local TeleportId = tonumber(_TeleportId)
    DebugPrint("JumpToRegionMapByTeleportId, TeleportId", TeleportId)
    if not TeleportId then
        return
    end
    local SubRegionId = DataMgr.TeleportPoint[TeleportId].TeleportPointSubRegion
    local RegionId = DataMgr.SubRegion[SubRegionId].RegionId
    if RegionId then
        local UIManager = GWorld.GameInstance:GetGameUIManager()
        UIManager:LoadUINew("LevelMapMain", false, RegionId, "TeleportPoint", TeleportId)
    end
end

function M.JumpToRegionMapByRegionPointId(_RegionPointId)
    local RegionPointId = tonumber(_RegionPointId)
    DebugPrint("JumpToRegionMapByRegionPointId, RegionPointId", RegionPointId)
    if not RegionPointId then
        return
    end
    local SubRegionId = DataMgr.RegionPoint[RegionPointId].SubRegion
    local RegionId = DataMgr.SubRegion[SubRegionId].RegionId
    if RegionId then
        local UIManager = GWorld.GameInstance:GetGameUIManager()
        UIManager:LoadUINew("LevelMapMain", false, RegionId, "RegionPoint", RegionPointId)
    end
end

---根据读表数据跳转到整备
---@param MainTab string 主tab名称
---@param SubTab string 子tab名称
---@param Id number CharId/WeaponId/PetId
function M.JumpToArmory(MainTab,SubTab,Id)
    local Params = {}
    local ArmoryUtils = require "BluePrints.UI.WBP.Armory.ArmoryUtils"
    if(MainTab == "Character")then
        Params.MainTabName = ArmoryUtils.ArmoryMainTabNames.Char
    elseif(MainTab == "MeeleWeapon")then
        Params.MainTabName = ArmoryUtils.ArmoryMainTabNames.Melee
    elseif(MainTab == "RangedWeapon")then
        Params.MainTabName = ArmoryUtils.ArmoryMainTabNames.Ranged
    elseif(MainTab == "UWeapon")then
        Params.MainTabName = ArmoryUtils.ArmoryMainTabNames.UWeapon
    elseif(MainTab == "Pet")then
        Params.MainTabName = ArmoryUtils.ArmoryMainTabNames.Pet
    elseif(MainTab == "BattleWheel")then
        Params.MainTabName = ArmoryUtils.ArmoryMainTabNames.BattleWheel
    end
    if(SubTab == "Attr")then
        Params.SubTabName = ArmoryUtils.ArmorySubTabNames.Attribute
    elseif(SubTab == "Skill")then
        Params.SubTabName = ArmoryUtils.ArmorySubTabNames.Skill
    elseif(SubTab == "CardLevelUp")then
        Params.SubTabName = ArmoryUtils.ArmorySubTabNames.Grade
    elseif(SubTab == "Accessory")then
        Params.SubTabName = ArmoryUtils.ArmorySubTabNames.Appearance
    elseif(SubTab == "Info")then
        Params.SubTabName = ArmoryUtils.ArmorySubTabNames.Files
    elseif(SubTab == "Mod")then
        Params.SubTabName = ArmoryUtils.ArmorySubTabNames.Attribute
        Params.SubPageName = ArmoryUtils.ArmorySubPageName.Mod
    elseif(SubTab == "Entry")then
        Params.SubTabName = ArmoryUtils.ArmorySubTabNames.Entry
    elseif(SubTab == "Wheel1")then
        Params.BattleWheelIndex = 1
    elseif(SubTab == "Wheel2")then
        Params.BattleWheelIndex = 2
    elseif(SubTab == "Wheel3")then
        Params.BattleWheelIndex = 3
    end
    Params.SelectedTargetId = tonumber(Id)
    local UIName = "ArmoryMain"

    GameFlowUtils:AddFlow("OpenSystemUI", {
        GWorld.GameInstance, function(_, Flow)
            local UIManager = GWorld.GameInstance:GetGameUIManager()
            local TargetUIPage = UIManager:GetUIObj(UIName)
            if (not TargetUIPage) then
                TargetUIPage = UIManager:LoadUINew(UIName, Params)
                UIManager:AddToJumpPageDeque(TargetUIPage)
                UIManager:AddFlow(UIName, Flow)
            else
                UIManager:PlaceJumpUIToTop(TargetUIPage, UIName)
                GameFlowUtils:RemoveFlow(Flow)
            end
        end
    })
    --gm (require "Utils.PageJumpFunctionConfig").JumpToArmory("BattleWheel","Wheel2",1101)
end

function M.JumpToInviteCode()
    local SdkUserInfo = HeroUSDKUtils.GetUserInfo()
    local AccessToken = SdkUserInfo.accessToken
    local SdkUserId = SdkUserInfo.sdkUserId
    local UserName = SdkUserInfo.userName
    local Url = GLink("InviteCode")
    Url = Url .. "&accessToken="..AccessToken .. "&cUid="..SdkUserId .. "&cName="..UserName
    UE4.UKismetSystemLibrary.LaunchURL(Url)
    --[[
    -- local AccessToken = 000000000
    -- local SdkUserId = 11111
    -- local UserName = "test"
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    local TargetUIPage = UIManager:GetUIObj("GlobalWebBrowser")
    if (not TargetUIPage) then
        TargetUIPage = UIManager:LoadUINew("GlobalWebBrowser", "InviteCode", true, "&accessToken="..AccessToken, "&cUid="..SdkUserId, "&cName="..UserName)
        UIManager:AddToJumpPageDeque(TargetUIPage)
    else
        UIManager:PlaceJumpUIToTop(TargetUIPage, "GlobalWebBrowser")
    end
    --]]
end

return M