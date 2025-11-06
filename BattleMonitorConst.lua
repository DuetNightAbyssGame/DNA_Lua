local BattleMonitorConst = {}
BattleMonitorConst.ATK_Char = 8000
BattleMonitorConst.DEF = 8000
BattleMonitorConst.HP = 40000
BattleMonitorConst.SP = 40000
BattleMonitorConst.ATK_Weapon = 8000
BattleMonitorConst.SkillIntensity = 8
BattleMonitorConst.Strong = 8
BattleMonitorConst.Enmity = 4
BattleMonitorConst.CRI = 5
BattleMonitorConst.CRD = 20
BattleMonitorConst.Mul_Shoot = 5

function BattleMonitorConst:CheckAttributeValid(Player)
  if not Player then
    return false
  end
  local ATK = Player:GetAttr("ATK")
  local ATK_Char = Player:GetAttr("ATK_Char")
  if ATK_Char > BattleMonitorConst.ATK_Char then
    return true
  end
  local ATK_Wepon = ATK - ATK_Char
  if ATK_Wepon > BattleMonitorConst.ATK_Weapon then
    return true
  end
  local HP = Player:GetAttr("MaxHp")
  if HP > BattleMonitorConst.HP then
    return true
  end
  local DEF = Player:GetAttr("DEF")
  if DEF > BattleMonitorConst.DEF then
    return true
  end
  local MaxES = Player:GetAttr("MaxES")
  if MaxES > BattleMonitorConst.SP then
    return true
  end
  local StrongValue = Player:GetAttr("StrongValue") or 0
  if StrongValue > BattleMonitorConst.Strong then
    return true
  end
  local EnmityValue = Player:GetAttr("EnmityValue") or 0
  if EnmityValue > BattleMonitorConst.Enmity then
    return true
  end
  local SkillIntensity = Player:GetAttr("SkillIntensity")
  if SkillIntensity > BattleMonitorConst.SkillIntensity then
    return true
  end
  local Weapon = Player:GetCurrentWeapon()
  if Weapon then
    local CRI = Weapon:GetAttr("CRI")
    if CRI > BattleMonitorConst.CRI then
      return true
    end
    local CRD = Weapon:GetAttr("CRD")
    if CRD > BattleMonitorConst.CRD then
      return true
    end
    local MultiShoot = Weapon:GetAttr("MultiShoot")
    if MultiShoot > BattleMonitorConst.Mul_Shoot then
      return true
    end
  end
  return false
end

return BattleMonitorConst
