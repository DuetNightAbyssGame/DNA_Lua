---@class WBP_Battle_Version_C : UEMUserWidget
---@field public SafeZone USafeZone
---@field public Text_Version UTextBlock
local WBP_Battle_Version_C = Class({"BluePrints.UI.BP_UIState_C",})

function WBP_Battle_Version_C:Construct()
    self:InitVersionDisplay()
end

-- 检查是否为内部测试包
function WBP_Battle_Version_C:IsInternalBuild()
    -- 检查是否为Distribution构建（发布版本）
    if UE.URuntimeCommonFunctionLibrary.IsDistribution() then
        return false
    end
    
    -- 检查是否在编辑器中运行（开发环境）
    if UE.URuntimeCommonFunctionLibrary.IsPlayInEditor(self) then
        return true
    end
    
    -- 默认返回true以便开发调试
    return true
end

-- 初始化版本号显示
function WBP_Battle_Version_C:InitVersionDisplay()
    if not self:IsInternalBuild() then
        self:SetVisibility(UE.ESlateVisibility.Collapsed)
        return
    end

    local versionText = UE.AHotUpdateGameMode.GetTotalVersionNumber()
    if versionText == "" then versionText = "编辑器状态，未获取到版本号" end
    if self.Text_Version then
        self.Text_Version:SetText(GText(versionText))
    end

    self:SetVisibility(UE.ESlateVisibility.SelfHitTestInvisible)
end

-- 刷新版本信息（可供外部调用）
function WBP_Battle_Version_C:RefreshVersionInfo()
    self:InitVersionDisplay()
end

function WBP_Battle_Version_C:Show()
    self:SetVisibility(UE.ESlateVisibility.SelfHitTestInvisible)
end
function WBP_Battle_Version_C:Hide()
    self:SetVisibility(UE.ESlateVisibility.Collapsed)
end

return WBP_Battle_Version_C
