--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local WBP_VideoPlayer_C = Class("BluePrints.UI.BP_UIState_C")

--function WBP_VideoPlayer_C:Initialize(Initializer)
--end

--function WBP_VideoPlayer_C:PreConstruct(IsDesignTime)
--end

function WBP_VideoPlayer_C:Construct()
    WBP_VideoPlayer_C.Super.Construct(self)
    --self.Button_Skip:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    
    -- 此界面继承了BP_UIState_C，但是却是组件，为了防止BP_UIState_C:Close()报错，手动设置IsInit
    self.IsInit = true
end

-- function WBP_VideoPlayer_C:Tick(MyGeometry, InDeltaTime)
-- end


function WBP_VideoPlayer_C:OnLoaded(...)
    self.Super.OnLoaded(self, ...)
    self.IsFullScreen,self.NeedAudio = ...
    if(self.IsFullScreen == nil)then
        self.IsFullScreen = true
    end
    if(self.NeedAudio == nil)then
        self.NeedAudio = true
    end
    self:SetIsNeedAudio(self.NeedAudio)
end

function WBP_VideoPlayer_C:SetIsNeedAudio(bIsNeedAudio)
    if(bIsNeedAudio)then
        self:CreateAudioActor()
        --TODO:避免重复创建
    else
        --TODO:销毁
    end
end

function WBP_VideoPlayer_C:Skip()
    self:Stop()
end

function WBP_VideoPlayer_C:BindEventToMediaPlayEnd(Obj,Event)
    if not Obj or not Event then
        return
    end
    self.Obj = Obj
    self.Event = Event
end

function WBP_VideoPlayer_C:OnMediaPlayEnd()
    if self.Obj and self.Event then
        self.Event(self.Obj)
    end
    if(self.IsFullScreen)then
        self:Stop()
    else
        self:FireCallback()
    end
end
function WBP_VideoPlayer_C:FireCallback()
    if self.OnPlayEnd:IsBound() then
        DebugPrint("CY@ OnMediaPlayEnd Broadcast")
        self.OnPlayEnd:Broadcast(self)
    end
end
function WBP_VideoPlayer_C:Stop()
    self:FireCallback()
    self:Close()
end

function WBP_VideoPlayer_C:IsPlaying()
    return self.MediaPlayer and self.MediaPlayer:IsPlaying()
end

function WBP_VideoPlayer_C:Pause()
    if(not self.MediaPlayer)then
        return
    end
    if(self.MediaPlayer:IsPlaying())then
        self.MediaPlayer:Pause()
    end
end

function WBP_VideoPlayer_C:Play()
    if(not self.MediaPlayer)then
        return
    end
    if(self.MediaPlayer:IsPreparing())then
        return false
    end
    self.MediaPlayer_VideoTexture:SetMediaPlayer(self.MediaPlayer)
    if(self.MediaPlayer:IsReady())then
        self.MediaPlayer:Play()
    elseif(self.MediaPlayer:CanPlayUrl(self.Url))then
        self.MediaPlayer:OpenUrl(self.Url)
        self.MediaPlayer:Play()
    else
        print(_G.LogTag,"Error: Failed to open url:" .. self.Url)
        return false
    end
    return true
end

function WBP_VideoPlayer_C:SetUrl(Url)
    self.Url = Url
end

function WBP_VideoPlayer_C:SetUrlByMediaSource(MediaSource)
    if(MediaSource)then
        self.Url = MediaSource:GetUrl()
    end
end

function WBP_VideoPlayer_C:HideSkipButton(IsHidden)
    if(IsHidden)then
        self.Button_Skip:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    else
        self.Button_Skip:SetVisibility(UIConst.VisibilityOp["Visible"])
    end
end

function WBP_VideoPlayer_C:SetLooping(Looping)
    self.bLooping = Looping
    if(self.MediaPlayer)then
        return self.MediaPlayer:SetLooping(Looping)
    end
    return false
end

function WBP_VideoPlayer_C:OnMediaPlayStart()
    self.Image_Mask:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    if(rawget(self,"bShouldPauseOnFirstFrame"))then
        self:AddTimer(0.1,function()
            self.MediaPlayer:Rewind()
            self:Pause()
        end)
    end
end

function WBP_VideoPlayer_C:PauseOnFirstFrame()
    rawset(self,"bShouldPauseOnFirstFrame",true)
    self:Play()
end

function WBP_VideoPlayer_C:Close()
    self.Super.Close(self)
    if(self.MediaPlayer)then
        self.MediaPlayer:Close()
    end
end

function WBP_VideoPlayer_C:Destruct()
    if(self.MediaPlayer)then
        self.MediaPlayer:Close()
    end
    self.Super.Destruct(self)
end

return WBP_VideoPlayer_C
