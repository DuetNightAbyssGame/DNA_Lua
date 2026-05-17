require "UnLua"

local WBP_DungeonExcavationToast_C = Class("BluePrints.UI.BP_UIState_C")

function WBP_DungeonExcavationToast_C:OnLoaded(...)
    self.Super.OnLoaded(self, ...)
    local LastTime,Content,Level,OrderText = ...
    self:InitInfo(Content, Level, OrderText)
    if(LastTime > 0) then self:AddTimer(LastTime, self.PlayOutAnim) end
    self:PlayAnimation(self.In)
end

function WBP_DungeonExcavationToast_C:InitInfo(Content, Level, OrderText)
    self.Text_Dig:SetText(Content)

    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    if GameInstance == nil then
        DebugPrint("OnExcavationItemChange: GameInstance 不存在")
        return
    end

    local SceneManager = GameInstance:GetSceneManager()
    if SceneManager == nil then
        DebugPrint("OnExcavationItemChange: SceneManager 不存在")
        return
    end

    local ImageResource = LoadObject(SceneManager:GetExcavationABCIconPath(OrderText))
    self.Img_Letter:SetBrushResourceObject(ImageResource)

    local Material = self.Img_Level:GetDynamicMaterial()
    if Material then
        Material:SetScalarParameterValue("LevelNum", Level)
    end
end

function WBP_DungeonExcavationToast_C:PlayOutAnim()
    if (self:IsAnimationPlaying(self.Out)) then
        -- 正在播放Out动画
        return
    end
    self:UnbindAllFromAnimationFinished(self.Out)
    self:BindToAnimationFinished(self.Out, {self, self.Close})
    self:PlayAnimation(self.Out)
end

function WBP_DungeonExcavationToast_C:Close()
    local UITipList = UIManager(self):GetUI("CommonTopToastList")
    if (UITipList ~= nil) then
        UITipList.VerticalBox_Toast:RemoveChild(self)
    end
    --self.Super.Close(self)        -- 历史遗留问题 参考通用toast的做法注释掉 否则会报错（注释后实际不影响逻辑）
end

return WBP_DungeonExcavationToast_C
