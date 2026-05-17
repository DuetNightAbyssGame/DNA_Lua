--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_MountsMain_Item02_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.Btn_Dye.Button_Area.OnClicked:Add(self, self.OnDyeClicked)
end

function M:OnDyeClicked()
    -- 直接从自身获取MountId（在InitMountInfoUI中设置）
    local MountId = self.MountId
    if not MountId then
        -- 如果MountId不存在，尝试从父组件获取
        local MountsMain = self.MountsMain
        if MountsMain then
            MountId = MountsMain:GetDisplayMountId()
        end
    end
    
    if not MountId then
        return
    end
    
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    
    local Mount = Avatar.Mounts[MountId]
    if not Mount then
        return
    end
    
    -- 获取当前使用的皮肤ID，如果没有则使用默认皮肤ID（MountId）
    local CurrentSkin = Mount:GetAppearance()
    local SkinId = CurrentSkin and CurrentSkin.SkinId or MountId
    
    local Params = {
        Target = Mount,
        Type = CommonConst.ArmoryType.Mount,
        SkinId = SkinId,
        IsPreviewMode = false,
        Parent = self.MountsMain,
        OnCloseCallback = function()
            -- 关闭回调
        end
    }
    
    local UIConfig = DataMgr.SystemUI.ArmoryDye
    if UIConfig then
        UIManager(self):LoadUI(UIConst.LoadInConfig, UIConfig.UIName, 0, Params)
    end
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end


return M
