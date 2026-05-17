--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

---@type WBP_AttrDebugPanel_C
local WBP_AttrDebugPanel = Class({"BluePrints.UI.BP_UIState_C", "BluePrints.Common.TimerMgr"})

function WBP_AttrDebugPanel:OnLoaded(...)
    local AttrName, Eid = ...
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    local UIManager = GameInstance:GetGameUIManager()
    self.AttrWatcher = {}
    self.RepeatTimer = self:AddTimer(0.1, self.RefreshPanel, true, 0, "RefreshPanel")
end

function WBP_AttrDebugPanel:SetEntity(Entity)
    if not Entity.BuffManager then
        return
    end
    self.Entity = Entity
end

function WBP_AttrDebugPanel:RefreshPanel()
    self.DebugStr = ""
    self.Prefix = ""

    for _, AttrWatcher in ipairs(self.AttrWatcher) do
        local Entity = Battle(self):GetEntity(AttrWatcher.Eid)
        if not Entity then
            self:RemoveAttrWatcher(AttrWatcher.AttrName, AttrWatcher.Eid)
        else
            local AttrName = AttrWatcher.AttrName

            -- Entity
            -- Entity
            if Entity.GetAttr then
                local EntityValue = Entity:GetAttr(AttrName)
                -- 1) nil 直接不显示
                if EntityValue ~= nil then
                    -- 2) 数值为 0 的过滤
                    if EntityValue ~= 0 then
                        local ValueStr = string.format("%.2f", EntityValue)
                        self:AppendStr(Entity:GetName() .. "  [Entity]  " .. AttrName .. " : " .. ValueStr)
                    end
                end
            end

            -- Weapon
            local Weapon = Entity:GetCurrentWeapon()
            if Weapon then
                local WeaponValue = nil

                if Weapon.GetAttr then
                    WeaponValue = Weapon:GetAttr(AttrName)
                end

                if WeaponValue == nil and Weapon.Data and Weapon.Data[AttrName] ~= nil then
                    WeaponValue = Weapon.Data[AttrName]
                end

                if WeaponValue ~= nil then
                    if WeaponValue ~= 0 then
                        local ValueStr = string.format("%.2f", WeaponValue)
                        self:AppendStr(
                            Entity:GetName() .. "  [" .. Weapon:GetName() .. "]  " .. AttrName .. " : " .. ValueStr
                        )
                    end
                end
            end
        end
    end

    self.TextInfo:SetText(self.DebugStr)
end

function WBP_AttrDebugPanel:AddAttrWatcher(AttrName, Eid)
    if not AttrName and not Eid then
        self:Clear()
        return
    end

    Eid = Eid or 1
    if Eid then
        Eid = tonumber(Eid)
    end

    local Entity = Battle(self):GetEntity(Eid)
    if not Entity then
        return
    end

    -- local AttributeSet = Entity:K2_GetAttributesSet()
    -- if not AttributeSet then return end

    local HasEntityAttr = false

    -- 查询角色本身属性
    if Entity.GetAttr then
        local Value = Entity:GetAttr(AttrName)
        if Value ~= nil then
            HasEntityAttr = true
        end
    end

    for i, v in ipairs(self.AttrWatcher) do
        if v.AttrName == AttrName and v.Eid == Eid then
            return
        end
    end

    table.insert(
        self.AttrWatcher,
        {
            AttrName = AttrName,
            Eid = Eid
        }
    )

    self:RefreshPanel()
end

function WBP_AttrDebugPanel:ShouldShow(Source, AttrName, Value)
    if Value == nil then
        return false
    end
    local RuleKey = string.lower(AttrName)
    local Rule = self.AttrShowRules and self.AttrShowRules[RuleKey]

    if Rule then
        if Source == "Entity" and Rule.showEntity == false then
            return false
        end
        if Source == "Weapon" and Rule.showWeapon == false then
            return false
        end
        if Rule.hideIfZero and type(Value) == "number" and Value == 0 then
            return false
        end
        return true
    end

    return true
end

function WBP_AttrDebugPanel:RemoveAttrWatcher(AttrName, Eid)
    for i, v in ipairs(self.AttrWatcher) do
        if v.AttrName == AttrName and v.Eid == Eid then
            table.remove(self.AttrWatcher, i)
            break
        end
    end
end

function WBP_AttrDebugPanel:Clear()
    self.AttrWatcher = {}
    self:RefreshPanel()
end

function WBP_AttrDebugPanel:AppendStr(InStr)
    self.DebugStr = self.DebugStr .. self.Prefix .. InStr .. "\n"
end

function WBP_AttrDebugPanel:AppendTab()
    self.Prefix = self.Prefix .. "    "
end

function WBP_AttrDebugPanel:RemoveTab()
    self.Prefix = self.Prefix:sub(1, -5)
end

function WBP_AttrDebugPanel:EMDestruct()
    self:Clear()
    self:RemoveTimer("RefreshPanel")
    DebugPrint("WBP_AttrDebugPanel Destruct")
end

return WBP_AttrDebugPanel
