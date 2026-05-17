--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Com_Item_Shop_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

function M:Init(Content)
    self.ItemType = Content.ItemType
    self:OnListItemObjectSet(Content)
end

function M:OnListItemObjectSet(Content)
    if Content.ShopItemId == nil then
        self.WidgetSwitcher_State:SetActiveWidgetIndex(1)
        return
    end
    self.WidgetSwitcher_State:SetActiveWidgetIndex(0)
    self:SetIcon(Content.Icon)
    self:SetRarity(Content.Rarity)
end

function M:SetIcon(IconPath)
    --- 如果是核桃类型，需显示核桃表对应的Icon
    if self.ItemType == "Walnut" then
        IconPath = DataMgr.Walnut[self.Id].Icon
        self:SetWalnutNum(self.Id)
    end
    self:SetBgMaterialByItemType(self.ItemType, "HeadSculpture")

    -- 是否需要异步加载图标
    if(self.bAsyncLoadIcon)then
        self:LoadTextureAsync(IconPath,function(Texture)
            if not Texture then
                Texture = LoadObject("Texture2D'/Game/UI/Texture/Dynamic/Image/Head/Monster/T_Head_Empty.T_Head_Empty'")
                DebugPrint(ErrorTag,string.format("用错图标路径了！！！这里用默认的图标顶一下\n 错误的路径是：%s",IconPath))
            end
            if(Texture)then
                local __IconDynaMaterial = self.Item_BG:GetDynamicMaterial()
                if(__IconDynaMaterial)then
                    __IconDynaMaterial:SetTextureParameterValue("IconMap", Texture)
                end
            end
        end,"LoadIcon")
    else
        assert(IconPath, "道具框传入Icon路径为空")
        local Icon = LoadObject(IconPath)
        if not Icon then
            Icon = LoadObject("Texture2D'/Game/UI/Texture/Dynamic/Image/Head/Monster/T_Head_Empty.T_Head_Empty'")
            DebugPrint(ErrorTag,string.format("用错图标路径了！！！这里用默认的图标顶一下\n 错误的路径是：%s",IconPath))
        end
        local DynamicMaterial = self.Item_BG:GetDynamicMaterial()
        if not IsValid(DynamicMaterial) then
            DebugPrint("ZDX_DynamicMaterial不合法")
        end
        DynamicMaterial:SetTextureParameterValue("IconMap", Icon)
    end
end

function M:LoadTextureAsync(TexturePath, cb, TaskName)
    rawset(self, "LoadResourceID", nil)
    local Handle = UE.UResourceLibrary.LoadObjectAsyncWithId(self, TexturePath, {self, function (self, Texture, ResourceID)
            if not IsValid(self) or (ResourceID ~= nil and rawget(self, "LoadResourceID") ~= ResourceID) then
                return
            end
            cb(Texture)
        end})
    if Handle then
        rawset(self, "LoadResourceID", Handle.ResourceID)
    end
    -- self.CoTasks = self.CoTasks or {}
    -- if(self.CoTasks[TaskName])then
    --     coroutine.close(self.CoTasks[TaskName])
    -- end
    -- local Co_Handle = coroutine.create(function(co)
    --     local TextureObj
    --     UResourceLibrary.LoadObjectAsync(self, TexturePath, {self, function(self, Texture)
    --         TextureObj = Texture
    --         if(coroutine.status(co) == "suspended")then
    --             coroutine.resume(co,co)
    --         end
    --     end})
    --     coroutine.yield()
    --     cb(TextureObj)
    -- end)
    -- self.CoTasks[TaskName] = Co_Handle
    -- coroutine.resume(Co_Handle,Co_Handle)
end

function M:SetRarity(Rarity)
    local DynamicMaterial = self.Item_BG:GetDynamicMaterial()
    DynamicMaterial:SetScalarParameterValue("IconOpacity", 1)
    if not IsValid(DynamicMaterial) then
        DebugPrint("ZDX_DynamicMaterial不合法")
    end
    --- 无品质
    if not Rarity or Rarity < 1 or Rarity > 6 then
        DynamicMaterial:SetScalarParameterValue("Index",0)
        return
    end
    DynamicMaterial:SetScalarParameterValue("Index",Rarity)
    if Rarity == 6 then
        self.VX_Red:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        DynamicMaterial:SetScalarParameterValue("ColorfulSwitch",1) 
        DynamicMaterial:SetScalarParameterValue("AddOpacity",1)
        DynamicMaterial:SetScalarParameterValue("IconAddOpacity",1)
    else
        self.VX_Red:SetVisibility(UIConst.VisibilityOp.Collapsed)
        DynamicMaterial:SetScalarParameterValue("ColorfulSwitch",0) 
        DynamicMaterial:SetScalarParameterValue("AddOpacity",0)
        DynamicMaterial:SetScalarParameterValue("IconAddOpacity",0)
    end
end

function M:OnAnimationFinished(Anim)
    if Anim == self.UnHover then
        self:PlayAnimation(self.Normal)
    end
end
return M
