
--DESCRIPTION

--@COMPANY **
--@AUTHOR **
--@DATE ${date} ${time}

require "UnLua"

--@type WBP_Chapter_CharChange_C
local M = Class({ "BluePrints.UI.BP_UIState_C" })

local FlowType = { ToEX = 1, ToMain = 2 }
-- 与两个 Switcher 的索引保持一致（0=男,1=女）
local SexType  = { Male = 0, Female = 1 }
local Side     = { Main = "Main", EX = "EX" }


M._components = {
    "BluePrints.UI.WidgetComponent.ChangeTextToKeyInfoComponent",
}
function M:Initialize(Initializer)
end

function M:Construct()
    M.Super.Construct(self)
    self:AddInputMethodChangedListen()
    self:Init()
    self.Button_461.OnClicked:Clear()
    self.Button_461.OnClicked:Add(self, self.SetXiaoBaiRandomTips)
    self:SetFocus()
    self.CurInputDeviceType = UIUtils.UtilsGetCurrentInputType()
    if self.CurInputDeviceType == ECommonInputType.Gamepad then
        self.CurrentInputDevice = { "GamepadKey" }
    else
        self.CurrentInputDevice = { "KeyboardKey", "MouseButton" }
    end
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then return end

    self:UpdateUIStyleInPlatform(UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad)
end
function M:Destruct()
    self:CleanTimer()
end

function M:Tick(MyGeometry, InDeltaTime)
    self.Spine_Male:Tick(InDeltaTime, true)
    self.Spine_Female:Tick(InDeltaTime, true)
    self.Spine_MaleEX:Tick(InDeltaTime, true)
    self.Spine_FemaleEX:Tick(InDeltaTime, true)
    self.Spine_Shalou:Tick(InDeltaTime, true)
    self.Spine_Bg:Tick(InDeltaTime, true)
    if not self.bUseFakeProgress or not self.IsProgressing then return end
    --更新进度条进度
    self.Progress = self.Progress + self.ProgressSpeed * InDeltaTime
    if self.Progress >= 99.0 then
        self.Progress = 99.0
        self.IsProgressing = false -- 停止进度更新
    end

    --更新进度条和文字显示
    self:UpdateProgress()
end

function M:UpdateProgress()
    --更新进度条和文字显示
    self.ProgressBar:SetPercent(self.Progress / 100)
    self.Text_Progress:SetText(string.format("%.0f", self.Progress))
    self.Text_Progress_Back:SetText(string.format("%.0f", self.Progress))
end

function M:Init()
    self.CurrentInputDevice = { "KeyboardKey", "MouseButton" }
    self:PrepareSpineForTransition()
    --初始化假进度条相关变量
    self.Progress = 0.0
    self.ProgressSpeed = 100.0
    self.bUseFakeProgress = false -- 默认不启用假进度条
    self.IsProgressing = true
    self:PlayAnimation(self.In)
    self:SetXiaoBaiRandomTips()
    self:UpdateProgress()
    -- 进入 loading：Prev=Open_Loading，Curr=Close_Loading
    self:Play_In_Loading()
end


--动画完成后的回调
function M:OnAnimationFinished(InAnimation)
    if InAnimation == self.Out then
        -- self:Close()
        self:RemoveFromParent()
        --UIManager(self):UnLoadUINew("BlackScreeCharChange")
    end
end


function M:IsValidSex(s) return s == SexType.Female or s == SexType.Male end

-- 切换 WidgetSwitcher 到指定性别
function M:SetActiveBySex(Switcher, SexVal)
    if not Switcher then return end
    local idx = (SexVal == SexType.Male) and 0 or 1
    Switcher:SetActiveWidgetIndex(idx)
end

-- 依据侧 + 性别拿对应 Spine 组件
function M:GetSpineBySideSex(side, sex)
    if side == Side.Main then
        return (sex == SexType.Male) and self.Spine_Male or self.Spine_Female
    else -- EX
        return (sex == SexType.Male) and self.Spine_MaleEX or self.Spine_FemaleEX
    end
end

function M:SafeSetAnim(side, sex, anim, loop)
    if not anim or anim == "" then return true end
    local comp = self:GetSpineBySideSex(side, sex)
    --DebugPrint(string.format("[Spine] FAIL GetName=%s 播放：  anim=%s", comp:GetName(),tostring(anim)))
    if not comp then return false end
    local entry = comp:SetAnimation(0, anim, loop or false)
    if not entry then
        DebugPrint(string.format("[Spine] FAIL side=%s sex=%s anim=%s", side, tostring(sex), tostring(anim)))
        return false
    end
    return true
end

------------------------------------------------------------
-- Avatar.Sex = Curr（当前的性别），Avatar.WeitaSex = Prev（之前的性别）
------------------------------------------------------------
function M:ComputeFlowAndSexSnapshot()
    local Avatar = GWorld:GetAvatar(); if not Avatar then return nil end

    local SceneId     = WorldTravelSubsystem():GetCurrentSceneId()
    local LastSceneId = WorldTravelSubsystem():GetLastSceneId()
    local Region      = DataMgr.Region[SceneId]
    local LastRegion  = DataMgr.Region[LastSceneId]
    if not Region or not LastRegion then return nil end

    local ToEX   = (Region.RegionType == Side.EX   and LastRegion.RegionType == Side.Main)
    local ToMain = (Region.RegionType == Side.Main and LastRegion.RegionType == Side.EX)
    if not (ToEX or ToMain) then return nil end

    local CurrSex = 0      -- 当前/目标（Curr）
    local PrevSex = 0 -- 之前/来源（Prev）
    if ToEX then
         CurrSex = Avatar.WeitaSex
         PrevSex = Avatar.Sex
    elseif ToMain then
        CurrSex = Avatar.Sex 
        PrevSex =  Avatar.WeitaSex 
    end
 
    -- DebugPrint("[Spine] ComputeFlowAndSexSnapshot CurrSex ",CurrSex)
    -- DebugPrint("[Spine] ComputeFlowAndSexSnapshot PrevSex ",PrevSex)
    --if not self:IsValidSex(CurrSex) or not self:IsValidSex(PrevSex) then return nil end

    local CurrSide = ToEX and Side.EX or Side.Main   -- ToEX: Curr 在 EX；ToMain: Curr 在 Main
    local PrevSide = ToEX and Side.Main or Side.EX   -- 对侧即 Prev

    self.SpSnapshot = {
        Flow     = ToEX and FlowType.ToEX or FlowType.ToMain,
        CurrSex  = CurrSex,
        PrevSex  = PrevSex,
        CurrSide = CurrSide,
        PrevSide = PrevSide,
    }
    return self.SpSnapshot
end


-- EX→Main 时两侧镜像反转
function M:ApplyFacingFromFlow()
    local S = self.SpSnapshot; if not S then return end

    -- EX -> Main 时需要镜像
    local FaceLeft = (S.Flow == FlowType.ToMain)

    -- 在 Spine 骨架层做水平翻转
    local function SetFace(Comp, Left)
        if not Comp then return end

        -- 用 ScaleX 的正负朝向
        if Comp.SetScaleX and Comp.GetScaleX then
            local V = math.abs(Comp:GetScaleX() or 1)
            Comp:SetScaleX(Left and -V or V)
            if Comp.UpdateWorldTransform then Comp:UpdateWorldTransform() end
            return
        end

    end

    -- 两侧四只都按同一规则翻转
    SetFace(self.Spine_Female, FaceLeft)
    SetFace(self.Spine_Male, FaceLeft)
    SetFace(self.Spine_FemaleEX, FaceLeft)
    SetFace(self.Spine_MaleEX, FaceLeft)
end

-- Switcher 显示正确性别：直接按各侧绑定
function M:ApplySwitchersFromSnapshot()
    local S = self.SpSnapshot; if not S then return end
    if S.CurrSide == Side.Main then
        self:SetActiveBySex(self.WS_Char, S.CurrSex)
        self:SetActiveBySex(self.WS_EXChar, S.PrevSex)
    else -- Curr 在 EX
        self:SetActiveBySex(self.WS_Char, S.PrevSex)
        self:SetActiveBySex(self.WS_EXChar, S.CurrSex)
    end
end

--设置Switcher和缩放
function M:PrepareSpineForTransition()
    if not self:ComputeFlowAndSexSnapshot() then
        DebugPrint("[Spine] ComputeFlowAndSexSnapshot failed")
        return
    end
    self:ApplySwitchersFromSnapshot()
    self:ApplyFacingFromFlow()
end


-- 进入 loading 时调用一次
-- 规则：前角色 Prev=Open_Loading（睁眼静帧），现角色 Curr=Close_Loading（闭眼静帧）
function M:Play_In_Loading()
    local S = self.SpSnapshot; if not S then return end
    self:SafeSetAnim(S.PrevSide, S.PrevSex, "Open_Loading",  false)
    self:SafeSetAnim(S.CurrSide, S.CurrSex, "Close_Loading", false)
end

-- Out ：Open 给 Curr（闭→睁）蓝图动画事件OpenEye调用
function M:OnUiAnimNotify_Open()
    local S = self.SpSnapshot; if not S then return end
    self:SafeSetAnim(S.CurrSide, S.CurrSex, "Open", false)
end

-- Out ：Close 给 Prev（睁→闭）蓝图动画事件CloseEye调用
function M:OnUiAnimNotify_Close()
    local S = self.SpSnapshot; if not S then return end
    self:SafeSetAnim(S.PrevSide, S.PrevSex, "Close", false)
end


function M:SetXiaoBaiRandomTips()
    local RandomTips = self:GetRandomLoadingTips()
    self.Text_Title:SetText(RandomTips.Title)
    local Messages = self:GetFinalContentText(RandomTips.Message,self.CurrentInputDevice)
    self.Text_Message:SetText(Messages)
end

function M:GetRandomLoadingTips()
    if not self.TipsPoolByPlatform then
        self.TipsPoolByPlatform = {
            PC = {},
            Mobile = {},
            Gamepad = {}
        }

        local TipsTable = DataMgr.Message

        for _, v in pairs(TipsTable) do
            if v.MessageType == "LoadingText" then
                --PC Tips
                if v.MessageContentPC then
                    table.insert(self.TipsPoolByPlatform.PC, {
                        Title = GText(v.MessageTitlePC or ""),
                        Message = GText(v.MessageContentPC)
                    })
                end

                --Mobile Tips
                if v.MessageContentPhone then
                    table.insert(self.TipsPoolByPlatform.Mobile, {
                        Title = GText(v.MessageTitlePC or ""),
                        Message = GText(v.MessageContentPhone)
                    })
                end

                --Gamepad Tips
                --Gamepad：优先使用 GamePad 字段，否则使用 PC 字段
                local gamepadMsg = v.MessageContentGamePad or v.MessageContentPC
                if gamepadMsg then
                    table.insert(self.TipsPoolByPlatform.Gamepad, {
                        Title =  GText(v.MessageTitlePC or ""),
                        Message = GText(gamepadMsg)
                    })
                end
            end
        end
    end

    --根据当前平台取对应 Tip 列表
    local TipsList = nil

    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        TipsList = self.TipsPoolByPlatform.Gamepad
    elseif CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        TipsList = self.TipsPoolByPlatform.PC
    elseif CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
        TipsList = self.TipsPoolByPlatform.Mobile
    end

    --防止空
    if not TipsList or #TipsList == 0 then
        return { Title = "", Message = "" }
    end

    local RandomIndex = math.random(1, #TipsList)
    return TipsList[RandomIndex]
end



function M:CloseUI()
    self.Progress = 100.0
    self:UpdateProgress()
    self:AddTimer(0.5, function()
        self:PlayAnimation(self.Out)
        self.Spine_Shalou:SetAnimation(0, "Change", false)
        self.Spine_Bg:SetAnimation(0, "Loop", true)
    end, false, 0, nil, true)
end


function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if (CurInputDevice == ECommonInputType.Touch) then
        --触控模式即默认样式，不需要刷新
        return
    end
    -- 输入设备切换通知
    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    self:UpdateUIStyleInPlatform(IsUseKeyAndMouse)
    self:SetXiaoBaiRandomTips()

end

function M:UpdateUIStyleInPlatform(IsUseKeyAndMouse)
    if IsUseKeyAndMouse then
        self.Com_KeyTitle:SetVisibility(ESlateVisibility.Collapsed)
        self.CurrentInputDevice = {"KeyboardKey","MouseButton"}
    else
        self.CurrentInputDevice = {"GamepadKey"}
        self.Com_KeyTitle:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Com_KeyTitle:CreateCommonKey({
            KeyInfoList = {
                {
                    Type = "Img",
                    ImgShortPath = "A",
                },
            },
            bLongPress = false,
            Desc = GText('UI_CTL_Loading_Next'),
        })
    end

end
AssembleComponents(M)
return M
