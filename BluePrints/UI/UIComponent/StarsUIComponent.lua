--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

-- 通用星图标显示
---@field self.StarsInAnimDelay number 首个星星动画延迟
---@field self.IntervalPerStar number 每个星星动画的间隔

require "UnLua"
---@type UEMUserWidget
local Component = {}

---设置星星数量
---@param NeedStarLoopAnim 是否需要播放最后一颗星的Loop动效
function Component:SetStars(StarCount,MaxStarCount,NeedStarLoopAnim)
    if(not self.Star)then
        return
    end
    local len = self.Star:GetChildrenCount()
    if(len < MaxStarCount)then
        for i = len + 1,MaxStarCount,1 do
            local Widget = Utils.UIManager(self):CreateWidget('/Game/UI/WBP/Armory/Widget/Unit/WBP_Armory_Star.WBP_Armory_Star', false)
            if(Widget)then
                self.Star:AddChildToHorizontalBox(Widget)
            end
        end
    end
    local Stars = self.Star:GetAllChildren()
    len = self.Star:GetChildrenCount()
    for i=1,len do
        if(i > MaxStarCount)then
            Stars[i]:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        else
            Stars[i]:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
            Stars[i]:On( i <= StarCount )
        end
        Stars[i].NeedStarLoopAnim = false
    end
    if(NeedStarLoopAnim)then
        if(StarCount + 1 <= len)then
            Stars[StarCount + 1].NeedStarLoopAnim = true
            --StarWidget:PlayAnimation(StarWidget.Loop)
        end
    end
end

function Component:PlayStarLoopAnim(Idx)
    local Stars = self.Star:GetAllChildren()
    if(Stars[Idx])then
        Stars[Idx]:PlayAnimation(Stars[Idx].Loop)
    end
end

function Component:PlayStarsInAnim(SoundEventPath)
    self.StarsInAnimDelay = self.StarsInAnimDelay or 0
    if(self.StarsInAnimDelay > 0)then
        self:AddTimer(self.StarsInAnimDelay,self.RealPlayStarsInAnim,false,0,"DelayPlayStarsInAnim",true,SoundEventPath)
    else
        self:RealPlayStarsInAnim(SoundEventPath)
    end
end

function Component:RealPlayStarsInAnim(SoundEventPath)
    if(not self.Star)then
        return
    end
    self.IntervalPerStar = self.IntervalPerStar or 0.1
    local len = self.Star:GetChildrenCount()
    local Stars = self.Star:GetAllChildren()
    for i=1,len do
        local StarWidget = Stars[i]
        if(StarWidget:GetVisibility() ~= ESlateVisibility.Collapsed)then
            StarWidget:SetRenderOpacity(0)
            local func = function()
                StarWidget:SetRenderOpacity(1)
                StarWidget:PlayAnimation(StarWidget.In)
                if(SoundEventPath) then
                    AudioManager(self):PlayUISound(self,SoundEventPath,nil,nil)
                end
            end
            if(i == 1)then
                self:AddTimer(0,func,false,0,"StarIn"..i,true)
            else
                self:AddTimer(i * self.IntervalPerStar,func,false,0,"StarIn"..i,true)
            end
        end
    end
end

function Component:PlayStarGoldenInAnim(idx)
    local len = self.Star:GetChildrenCount()
    local Stars = self.Star:GetAllChildren()
    if(idx <= len)then
        Stars[idx]:PlayAnimation(Stars[idx].Golden_In)
    end
end



return Component
