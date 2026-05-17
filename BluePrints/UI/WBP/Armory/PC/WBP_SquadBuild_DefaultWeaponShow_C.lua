--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Build_DefaultWeaponShow_C
local WBP_Build_DefaultWeaponShow_C = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function WBP_Build_DefaultWeaponShow_C:InitInfo(ItemId)
    self.ItemId = ItemId
    self:UpdateIcon()
end


--设置图标
function WBP_Build_DefaultWeaponShow_C:UpdateIcon()

    if self.ItemId then
        self.WS_Icon:SetActiveWidgetIndex(0)
    else
        self.WS_Icon:SetActiveWidgetIndex(1)
        return
    end

    local IconPath = nil
    IconPath = DataMgr.Weapon[self.ItemId].GUIPathVariableName
    --还是不存在说明策划那边没有配置地址
    if not IconPath then
        DebugPrint("thy 预设阵容列表有策划没配置GUI地址的武器,ItemId = ", self.ItemId)
        self.WS_Icon:SetActiveWidgetIndex(1)
        return
    end
    IconPath = DataMgr.Weapon[self.ItemId].GUIPathVariableType.."_"..IconPath
    local Result = false
    if IconPath then
        Result = self:SetImage(IconPath)
    end
    if not Result then
        DebugPrint("thy 预设阵容列表武器Icon设置失败, ItemId = ", self.ItemId)
    end
end


--设置图标
function WBP_Build_DefaultWeaponShow_C:SetImage(ImgShortPath, ImgLongPath)
    local ImgPath, Img = nil, nil
    local FixPath  = ""
    if (ImgShortPath) then
        FixPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/Head/Weapon/T_Head_%s.T_Head_%s'"
        local ReplaceKey = string.gsub(ImgShortPath, " ", "_")
        ImgPath = string.format(FixPath, ReplaceKey, ReplaceKey)
        Img = LoadObject(ImgPath)
    else
        Img = LoadObject(ImgLongPath)
    end
    if (not IsValid(Img)) then
        DebugPrint("缺少图片资源: ImgPath = " .. ImgPath)
        return false
    end
    local IconDynaMaterial = self.Icon:GetDynamicMaterial()
    if IconDynaMaterial then
        IconDynaMaterial:SetTextureParameterValue("IconMap",Img)
        IconDynaMaterial:SetScalarParameterValue("IconMapOpacity",1)
        return true
    end

    DebugPrint("@thy 找不到动态材质")
    return false
end


return WBP_Build_DefaultWeaponShow_C
