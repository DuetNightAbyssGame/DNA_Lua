require "Unlua"
require "Const"

local M = Class()

function M:Initialize_Lua()
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local IsTakeRecorder = nil
    if GameInstance then
        IsTakeRecorder = GameInstance.IsTakeRecorderCapturing or GameInstance.IsTakeRecorderRendering
    end
    if IsTakeRecorder == true then
         -- 全局数量和耗时控制的开关
         self.bEnableFXScalabilityOpt = false
         -- 特效缓存池开关
         self.bEnableFXPool = false
    else
        -- 全局数量和耗时控制的开关
        self.bEnableFXScalabilityOpt = true
        -- 单个特效数量控制开关
        self.bEnableFXMaxNumOpt = true
        self.bEnableMaxNumAtLocationOpt = true
        -- 联机客户端是否开启全局控制
        self.bEnableClientOpt = true
        -- 全局控制是否只在副本生效
        self.bOnlyDungeon = true
        -- 全局控制是否单独计算渲染线程耗时
        self.EnableRenderThreadBundget = true
        -- 全局控制的详细参数
        self.EMFXBudget_HistorySize = 60
        self.EMFXBudget_GameThread = 1
        self.EMFXBudget_GameThreadConcurrent = 1
        self.EMFXBudget_RenderThread = 1
        self.EMFXBudget_AdjustedUsageDecayRate = -1
        -- 打组间隔时间
        self.BindRemainingTime = 0.2
        -- 详细的debug信息
        self.bEnableDetailDebug = true
        -- 特效缓存池开关
        self.bEnableFXPool = true
        -- 创建默认特效
        self.EnableDefaultNiagaraInstance = true
    end
   
end


return M