--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Com_PageTurner_C
local WBP_Com_PageTurner_PC = Class({"BluePrints.UI.BP_EMUserWidget_C","BluePrints.Common.DelayFrameComponent"})

--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

--调入接口 初始化翻页指示器
--2025.7.31 BeginIndex 有值则初始化页面索引为该索引 nil则为1
function WBP_Com_PageTurner_PC:InitPageTurner(GuideMessageNum, UserWidget, HandleIndexFunc, BeginIndex)
    self.StartPageIndex = 1--第一页
    self.EndPageIndex = GuideMessageNum--最后一页 也是 信息的数量
    self.PrePageIndex = BeginIndex or 1-- 前一次记录的索引
    self.CurrentPageIndex = BeginIndex or 1--当前记录的索引
    self.UserWidget = UserWidget--调用这个翻页器的组件
    self.Callback = HandleIndexFunc--回调函数
    self:InitPagePoint()--初始化翻页点
end

--切换点击前后两个按钮的动画
function WBP_Com_PageTurner_PC:SwtichPagePointAnimation(CurrentPageIndex)
    self.PrePageIndex = self.CurrentPageIndex
    self.CurrentPageIndex = CurrentPageIndex
    local PagePoint = self.Root:GetChildAt(self.PrePageIndex - 1)
    if not PagePoint then
        Utils.ScreenPrint("翻页器索引获取PagePoint异常，建议检查下方法InitPageTurner传入的参数GuideMessageNum，或者检查下调用组件显示信息的Excel配置表")
        return
    end
    PagePoint:StopAllAnimations()
    PagePoint:PlayAnimation(PagePoint.Normal)
    PagePoint = self.Root:GetChildAt(self.CurrentPageIndex - 1)
    if not PagePoint then
        Utils.ScreenPrint("翻页器索引获取PagePoint异常，建议检查下方法InitPageTurner传入的参数GuideMessageNum，或者检查下调用组件显示信息的Excel配置表")
        return
    end
    PagePoint:StopAllAnimations()
    --最后一个参数为bRestoreState，传入true 播放完动效后会重置会原来的状态。先这么处理
    PagePoint:PlayAnimation(PagePoint.Click,0,1,0,1,true)
end

--左翻页 可循环翻页
function WBP_Com_PageTurner_PC:PageLeft(IsNeedLoop)
    local CurrentPageIndex = 1
    if IsNeedLoop then
        CurrentPageIndex = (self.CurrentPageIndex - 1 > 1 or self.CurrentPageIndex - 1 == 1) and self.CurrentPageIndex - 1 or self.EndPageIndex
    else
        CurrentPageIndex = self.CurrentPageIndex - 1 > 1 and self.CurrentPageIndex - 1 or 1
    end
    self:SwtichPagePointAnimation(CurrentPageIndex)
    -- 回调参数true表示这次滚动是向左滚动
    self.Callback(self.UserWidget, self.CurrentPageIndex, true)
end

--右翻页 可循环翻页
function WBP_Com_PageTurner_PC:PageRight(IsNeedLoop)
    local CurrentPageIndex = 1
    if IsNeedLoop then
        CurrentPageIndex = (self.CurrentPageIndex + 1 < self.EndPageIndex or self.CurrentPageIndex + 1 == self.EndPageIndex) and self.CurrentPageIndex + 1 or 1
    else
        CurrentPageIndex = self.CurrentPageIndex + 1 < self.EndPageIndex and self.CurrentPageIndex + 1 or self.EndPageIndex
    end
    self:SwtichPagePointAnimation(CurrentPageIndex)
    self.Callback(self.UserWidget, self.CurrentPageIndex)
end

-- --左翻页 不可循环翻页
-- function WBP_Com_PageTurner_PC:PageLeft()
--     local CurrentPageIndex = self.CurrentPageIndex - 1 > 1 and self.CurrentPageIndex - 1 or 1
--     self:SwtichPagePointAnimation(CurrentPageIndex)
--     self.Callback(self.UserWidget, self.CurrentPageIndex)
-- end

-- --右翻页 不可循环翻页
-- function WBP_Com_PageTurner_PC:PageRight()
--     local CurrentPageIndex = self.CurrentPageIndex + 1 < self.EndPageIndex and self.CurrentPageIndex + 1 or self.EndPageIndex
--     self:SwtichPagePointAnimation(CurrentPageIndex)
--     self.Callback(self.UserWidget, self.CurrentPageIndex)
-- end

--直达第一页
function WBP_Com_PageTurner_PC:PageStart()
    self:SwtichPagePointAnimation(self.StartPageIndex)
    self.Callback(self.UserWidget, self.CurrentPageIndex)
end

--直达最后一页
function WBP_Com_PageTurner_PC:PageEnd()
    self:SwtichPagePointAnimation(self.EndPageIndex)
    self.Callback(self.UserWidget, self.CurrentPageIndex)
end

function WBP_Com_PageTurner_PC:CheckCurDeviceIsPC()
    return CommonUtils.GetDeviceTypeByPlatformName(self) == "PC"
end

--处理点击按钮事件
function WBP_Com_PageTurner_PC:HandleClickPointIndex(PagePoint)
    local index = self.Root:GetChildIndex(PagePoint)
    self:SwtichPagePointAnimation(index + 1)
    self.Callback(self.UserWidget, self.CurrentPageIndex)
end

--检查点击的按钮是否就是当前按钮
function WBP_Com_PageTurner_PC:CheckIsCurrentPage(PagePoint)
    return self.Root:GetChildIndex(PagePoint) + 1 == self.CurrentPageIndex
end

--绑定的按钮点击事件
function WBP_Com_PageTurner_PC:OnPagePointClicked(PagePoint)
    if not self:CheckCurDeviceIsPC() then return end -- 手机不允许与翻页器有交互
    if not self:CheckIsCurrentPage(PagePoint) then
        self:HandleClickPointIndex(PagePoint)
    end
end

--绑定的按钮按下事件
function WBP_Com_PageTurner_PC:OnPagePointPressed(PagePoint)
    if not self:CheckCurDeviceIsPC() then return end -- 手机不允许与翻页器有交互
    AudioManager(self):PlayUISound(nil, "event:/ui/common/click_btn_small", nil, nil)
    if not self:CheckIsCurrentPage(PagePoint) then
        PagePoint:PlayAnimation(PagePoint.Press)
    end
    --UIUtils.PlayCommonBtnSe(self)--播放翻页音效
end

--绑定的按钮覆盖事件
function WBP_Com_PageTurner_PC:OnPagePointHovered(PagePoint)
    if not self:CheckCurDeviceIsPC() then return end -- 手机不允许与翻页器有交互
    if not self:CheckIsCurrentPage(PagePoint) then
        PagePoint:PlayAnimation(PagePoint.Hover)
    end
end

--绑定的按钮移开事件
function WBP_Com_PageTurner_PC:OnPagePointUnhovered(PagePoint)
    if not self:CheckCurDeviceIsPC() then return end -- 手机不允许与翻页器有交互
    if not self:CheckIsCurrentPage(PagePoint) then
        PagePoint:PlayAnimation(PagePoint.UnHover)
    end
end

--初始化翻页点
function WBP_Com_PageTurner_PC:InitPagePoint()
    self.Root:ClearChildren()
    for i=1,self.EndPageIndex do
        local NowPoint = UIManager(self):_CreateWidgetNew("PagePoint")
        if not NowPoint then
            Utils.ScreenPrint("翻页点创建异常，请检查WidgetUI配置表中的PagePoint的配置信息是否正确")
            return
        end
        NowPoint.Button_Area.OnClicked:Add(self, function() self:OnPagePointClicked(NowPoint) end)
        NowPoint.Button_Area.OnPressed:Add(self, function() self:OnPagePointPressed(NowPoint) end)
        NowPoint.Button_Area.OnHovered:Add(self, function() self:OnPagePointHovered(NowPoint) end)
        NowPoint.Button_Area.OnUnhovered:Add(self, function() self:OnPagePointUnhovered(NowPoint) end)
        self.Root:AddChildToWrapBox(NowPoint)
        NowPoint:PlayAnimation(NowPoint.Normal)
    end
    local CurPoint = self.Root:GetChildAt(self.CurrentPageIndex-1)
    if not CurPoint then
        Utils.ScreenPrint("翻页器索引获取PagePoint异常，建议检查下方法InitPageTurner传入的参数GuideMessageNum，或者检查下调用组件显示信息的Excel配置表")
        return
    end
    self:AddDelayFrameFunc(function()
        CurPoint:PlayAnimation(CurPoint.Click)
    end, 3, "DelayClick")

end

-- 禁用/启用所有翻页点的点击事件
function WBP_Com_PageTurner_PC:ForbidPointBtns(bForbid)
    for i=1,self.EndPageIndex do
        local NowPoint = self.Root:GetChildAt(i-1)
        if not NowPoint then
            return
        end
        NowPoint:StopAllAnimations()
        NowPoint.Button_Area:SetIsEnabled(not bForbid)
    end
end

--解绑翻页点点击事件并添加新的点击事件，适用如有些页面还未解锁不能点，需要点了后弹Toast等情况
function WBP_Com_PageTurner_PC:ReBindClickEvent(PageIndex, Func)
    if not Func then return end
    local Point = self.Root:GetChildAt(PageIndex - 1)
    if not Point then return end
    -- Point.Button_Area.OnPressed:Clear()
    -- Point.Button_Area.OnHovered:Clear()
    -- Point.Button_Area.OnUnhovered:Clear()
    Point.Button_Area.OnClicked:Clear()
    Point.Button_Area.OnClicked:Add(self, Func)
end

return WBP_Com_PageTurner_PC
