--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_SoloTreasure_HudTips01
local M = Class({"BluePrints.UI.BP_UIState_C", "BluePrints.Common.TimerMgr"})

---仅初始化lua变量时使用，千万不要有控件操作！！
function M:Initialize(Initializer)
    DebugPrint("yly test WBP_SoloTreasure_HudTips01 Initialize")
    
end

function M:Construct()
    DebugPrint("yly test WBP_SoloTreasure_HudTips01 Construct")
    self:BindToAnimationFinished(self.Out, {self, self.OnOutAnimationFinished})
end

function M:InitUIInfo(Name, IsInUIMode, EventList, ...)
    DebugPrint("yly test WBP_SoloTreasure_HudTips01 InitUIInfo")
    self.Super.InitUIInfo(self, Name, IsInUIMode, EventList, ...)
    self.showTime = DataMgr.GlobalConstant["SoloTreasureHudTips01ShowTime"].ConstantValue
    self.Text_Task:SetText(GText('UI_Extraction_TM_33'))
    self.Text_Task02:SetText(GText('UI_Extraction_TM_34'))
end

function M:OnLoaded(...)
    -- 接收并处理外部参数，一些通用的界面加载完成之后的统一逻辑可以放在这, 子类如有一些Load完成之后的逻辑可以重写该方法
    DebugPrint("yly test WBP_SoloTreasure_HudTips01 OnLoaded")

    local LogicServerInfo = ...
    self.gamePlayId = table.unpack(LogicServerInfo)
    DebugPrint("yly WBP_SoloTreasure_HudTips01:OnLoaded self.gameplayId =", self.gamePlayId)

    --初始化UI
    self:InitUIContent()

    self:UnbindAllFromAnimationFinished(self.In)
    self:BindToAnimationFinished(self.In, {self, function()
        self:StartCountDown()
    end})
    self:PlayAnimation(self.In)
end

function M:Destruct()
    DebugPrint("yly test WBP_SoloTreasure_HudTips01 Destruct")
    if self:IsExistTimer("STHudTips01CountDown") then
        self:RemoveTimer("STHudTips01CountDown")
    end
end

function M:InitUIContent()
    self.Text_Num_1:SetText(DataMgr.SoloTreasureGamePlay[self.gamePlayId].TaskGains)
end

function M:StartCountDown()
    self.timer = self:AddTimer(self.showTime, function()
        self:CloseSelf()
    end, false, 0, "STHudTips01CountDown", false)
end

-- 关闭UI
function M:CloseSelf()
    DebugPrint("yly test WBP_SoloTreasure_HudTips01 CloseSelf")
    if self:IsAnimationPlaying(self.Out) then
        return
    end
    self:PlayAnimation(self.Out)
end

function M:OnOutAnimationFinished()
    local BattleInfoItem = UIManager(self):_CreateWidgetNew("SoloTreasureGuardTaskHud")
    local TaskInfo = {GamePlayId = self.gamePlayId}
    BattleInfoItem:InitDungeonWidget(TaskInfo)
    self:Close()
end

return M