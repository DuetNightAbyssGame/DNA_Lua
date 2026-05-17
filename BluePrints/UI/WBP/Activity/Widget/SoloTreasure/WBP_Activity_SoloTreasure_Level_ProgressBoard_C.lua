require "UnLua"

local SoloTreasureTaskProgressBoard = Class({"BluePrints.UI.BP_EMUserWidget_C"})
local SoloTreasureDataModel = require "BluePrints.UI.WBP.Activity.Widget.SoloTreasure.SoloTreasureDataModel"

SoloTreasureTaskProgressBoard.BoardStateTextMap = {
    [1] = "UI_SoloTreasure_NextProgress", -- 积分未达标
    [2] = "UI_SoloTreasure_HaveStoryToFinish", -- 积分达成，等待完成剧情
    [3] = "UI_SoloTreasure_FinalProgress", -- 已进行至最终赛程
    [4] = "UI_SoloTreasure_ProgressFinished" -- 比赛已结束
}

------------------------------------------------
-- 外部调用：加载数据
------------------------------------------------
function SoloTreasureTaskProgressBoard:LoadDataToBoard(EventId, OldResult, NewResult)
    self.EventId = EventId
    self.OldResult = OldResult
    self.NewResult = NewResult
end

------------------------------------------------
-- 静态刷新（刷任意Result）
------------------------------------------------
-- UI显示：完全独立，不写任何判断逻辑（只读取Result）
function SoloTreasureTaskProgressBoard:RefreshProgressBoard(Result)
    if not Result then
        return
    end

    -- ===== 静态UI初始化 =====
    -- 标题
    if self.Text_TaskProgress then
        self.Text_TaskProgress:SetText(GText("UI_SoloTreasure_EventProgress"))
    end

    -- 阶段名
    if self.Text_Contest and Result.CurRow then
        self.Text_Contest:SetText(GText(Result.CurRow.EventProgressText))
    end

    -- 当前阶段数字
    if self.Num_Now then
        self.Num_Now:SetText(tostring(Result.CurStageIndex or 1))
    end

    -- 总阶段数
    if self.Num_Total then
        self.Num_Total:SetText(tostring(Result.TotalStageCount or 0))
    end

    local ResourceId = DataMgr.GlobalConstant["SoloTreasureCurrent"].ConstantValue
    local CoinIconPath = DataMgr.Resource[ResourceId].Icon
    local CoinObj = LoadObject(CoinIconPath)
    if CoinObj then
        self.Icon_Coin:SetBrushFromTexture(CoinObj)
    end

    -- ===== WidgetSwitcher 控制区域切换 =====
    local IDX_SCORE = 0 -- Panel_ShowScore
    local IDX_TEXT = 1 -- Panel_ShowText

    if self.WS_Type then
        if Result.BoardState == 1 then
            self.WS_Type:SetActiveWidgetIndex(IDX_SCORE)
        else
            self.WS_Type:SetActiveWidgetIndex(IDX_TEXT)
        end
    end

    -- ===== 填充内容 =====
    local TextKey = self.BoardStateTextMap and self.BoardStateTextMap[Result.BoardState] or nil

    if Result.BoardState == 1 then
        -- 进度积分
        if self.Num_Coin_Now then
            self.Num_Coin_Now:SetText(tostring(Result.CurScore or 0))
        end
        if self.Num_Coin_Total then
            self.Num_Coin_Total:SetText(tostring(Result.NextNeedScore or 0))
        end

        -- 进度态提示
        if self.Text_Hint and TextKey then
            self.Text_Hint:SetText(GText(TextKey))
        end
    else
        -- 非进度态
        if self.Text_Desc and TextKey then
            self.Text_Desc:SetText(GText(TextKey))
        end
    end
end

------------------------------------------------
-- 播“加分”动画
------------------------------------------------
function SoloTreasureTaskProgressBoard:PlayScoreAnim()
    if not self.Score_Add then
        return
    end
    self:PlayAnimation(self.Score_Add)
end

------------------------------------------------
-- 播“晋级”动画
------------------------------------------------
function SoloTreasureTaskProgressBoard:PlayStageAnim()
    if not self.Text_Refresh then
        return
    end
    self:PlayAnimation(self.Text_Refresh)
end

------------------------------------------------
-- 动画回调：Score_Add
------------------------------------------------
function SoloTreasureTaskProgressBoard:SequenceEvent_0()
    if not self.NewResult then
        return
    end

    -- 刷到新值
    if self.Num_Coin_Now then
        self.Num_Coin_Now:SetText(tostring(self.NewResult.CurScore or 0))
    end
    if self.Num_Coin_Total then
        self.Num_Coin_Total:SetText(tostring(self.NewResult.NextNeedScore or 0))
    end

    if self.bPendingPlayStage then
        return
    end

    -- 提交缓存
    SoloTreasureDataModel:CommitBoardSnapshotByResult(self.EventId, self.NewResult)
end

------------------------------------------------
-- 动画回调：Text_Refresh
------------------------------------------------
function SoloTreasureTaskProgressBoard:SequenceEvent_1()
    if not self.NewResult then
        return
    end

    -- 局部更新：阶段名 + 阶段数字
    if self.Text_Contest and self.NewResult.CurRow then
        self.Text_Contest:SetText(GText(self.NewResult.CurRow.EventProgressText))
    end
    if self.Num_Now then
        self.Num_Now:SetText(tostring(self.NewResult.CurStageIndex or 1))
    end

    -- 提交缓存
    SoloTreasureDataModel:CommitBoardSnapshotByResult(self.EventId, self.NewResult)
end

function SoloTreasureTaskProgressBoard:OnAnimationFinished(Animation)
    if Animation == self.Score_Add then
        local IDX_SCORE = 0 -- Panel_ShowScore
        local IDX_TEXT = 1 -- Panel_ShowText
        if self.WS_Type then
            if self.NewResult.BoardState == 1 then
                self.WS_Type:SetActiveWidgetIndex(IDX_SCORE)
                DebugPrint("----------------显示积分面板！")
            else
                self.WS_Type:SetActiveWidgetIndex(IDX_TEXT)

                local TextKey = self.BoardStateTextMap and self.BoardStateTextMap[self.NewResult.BoardState]
                if self.Text_Desc and TextKey then
                    self.Text_Desc:SetText(GText(TextKey))
                end
                DebugPrint("----------------显示文字面板！")
            end
        end

        -- 加分结束 -> 播晋级
        if self.bPendingPlayStage then
            self.bPendingPlayStage = false
            if self.PlayStageAnim then
                self:PlayStageAnim()
            end
        end
    end
end

return SoloTreasureTaskProgressBoard
