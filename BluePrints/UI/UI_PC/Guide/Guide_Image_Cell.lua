require "UnLua"
require "DataMgr"


local Guide_Image_Cell = Class(
    {
        "BluePrints.UI.BP_UIState_C",
    }
)

Guide_Image_Cell._components = {
    "BluePrints.UI.WidgetComponent.ChangeTextToKeyInfoComponent"
}

function Guide_Image_Cell:Construct()
    self.GuideType = "None"
    self.CurInputDeviceType = UIUtils.UtilsGetCurrentInputType()
    if self.CurInputDeviceType == ECommonInputType.Gamepad then
        self.CurrentInputDevice = {"GamepadKey"}
    else
        self.CurrentInputDevice = {"KeyboardKey","MouseButton"}
    end

    -- Dungeon
    --self.IsDungeonGuide = false
end

function Guide_Image_Cell:Destruct()
    if self.MediaPlayer and self.MediaPlayer:IsPlaying() then
        self.MediaPlayer:SetLooping(false)
        self.MediaPlayer:Close()
    end
end

-- 设置当前是第几个步骤
function Guide_Image_Cell:SetNumStep(i)
    self.num_index = i
    -- self.Num_Step:SetText("0"..i)
    self.MediaPlayer = LoadObject("MediaPlayer'/Game/UI/UI_PC/Guide/Guide_Image/MediaPlayer/MediaPlayer_Video"..i..".MediaPlayer_Video"..i.."'")
end

-- 设置当前显示类型,副标题,文本,图片放在下一个步骤去处理
function Guide_Image_Cell:SetGuideType(GuideType)
    self.GuideType = GuideType
    if self.GuideType == "ImageText" then
        self.WidgetSwitcher_State:SetActiveWidgetIndex(0)
        -- 隐藏步骤数字
        -- self.Num_Step:SetVisibility(UE4.ESlateVisibility.Collapsed)
    elseif self.GuideType == "ProcessNode" then
        self.WidgetSwitcher_State:SetActiveWidgetIndex(0)
        -- 显示步骤数字
        -- self.Num_Step:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    elseif self.GuideType == "Text" then
        self.WidgetSwitcher_State:SetActiveWidgetIndex(1)
    end
end

function Guide_Image_Cell:UpdateContent(ChildGuideId, i, isPC)
    -- if self.IsDungeonGuide then
    --     self.ChildInfo = DataMgr.DungeonUIChildGuide[ChildGuideId]["GuideInfo"..i]
    -- else
    --     self.ChildInfo = DataMgr.UIChildGuide[ChildGuideId]["GuideInfo"..i]
    -- end
    self.ChildInfo = DataMgr.UIChildGuide[ChildGuideId]["GuideInfo"..i]
    self:UpdateCellText(ChildGuideId, i, isPC)
    self:UpdateCellImgs(ChildGuideId, i, isPC)
    self:PlayAnimation(self.SwitchCell)
end

function Guide_Image_Cell:UpdateCellImgs(ChildGuideId, i, isPC)
    -- 指需要考虑当前Cell images的SrcollIn&ScrollOut即可
    self:GetChildeGuideUIInfoById(ChildGuideId, i, isPC)
end

-- 更新副标题和文本
function Guide_Image_Cell:UpdateCellText(ChildGuideId, i, isPC)
    local SubTitleText = self.ChildInfo.GuideSubTitle
    if SubTitleText then
        self.Guide_Title:SetText(GText(SubTitleText))
        self.Guide_Title:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self.Guide_Title:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end

    local ContentText = nil
    if isPC then
        ContentText = GText(self.ChildInfo.GuideContent.PC)
        if self.ChildInfo.GuideContent.GamePad and self.CurInputDeviceType == ECommonInputType.Gamepad then
            ContentText = GText(self.ChildInfo.GuideContent.GamePad)
        end
    else
        ContentText = GText(self.ChildInfo.GuideContent.Phone)
    end
    local ChildGuideDescValues = self.ChildInfo.GuideDescValues
    ContentText = self:AnalyzeGuideDesc(ContentText, ChildGuideDescValues)
    ContentText = self:GetFinalContentText(ContentText)

    self.Guide_Desc_Image:SetText(ContentText)
    self.Guide_Desc_Text:SetText(ContentText)
    self.Guide_Desc_Image:SetVisibility(UIConst.VisibilityOp["Hidden"])
    self.Guide_Desc_Text:SetVisibility(UIConst.VisibilityOp["Hidden"])
    local Time = 0.05
    if not self.bBeginIn  then
        Time = 0.1
        self.bBeginIn = true
    end
    self:AddTimer(Time, function()
        UIUtils.SetTextJustificationByLineCount(self.Guide_Desc_Image)
        UIUtils.SetTextJustificationByLineCount(self.Guide_Desc_Text)
        self.Guide_Desc_Image:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        self.Guide_Desc_Text:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        self.Guide_Desc_Image:SetWrapTextAt(UIManager():GetWidgetRenderSize(self.WidgetSwitcher_State).X-50)
        self.Guide_Desc_Text:SetWrapTextAt(UIManager():GetWidgetRenderSize(self.WidgetSwitcher_State).X-50)
    end)
end


-- get picture type and source from table
function Guide_Image_Cell:GetChildeGuideUIInfoById(ChildGuideId, i, isPC)
    local PictureList = self.ChildInfo.GuidePicture
    if not PictureList then
        return
    end
    if isPC then
        self.GuidePicture = PictureList.PC
        if PictureList.GamePad and self.CurInputDeviceType == ECommonInputType.Gamepad then
            self.GuidePicture = PictureList.GamePad
        end
    else
        self.GuidePicture = PictureList.Phone
    end
    if string.match(self.GuidePicture, "FileMediaSource") then
        self:ShowVideo(self.GuidePicture)
        self.MediaPlayer:Play()
    else
        self:ShowImg(self.GuidePicture)
    end
end

function Guide_Image_Cell:ShowImg(ImgPath)
    local img = LoadObject(ImgPath)
    -- self:ScaleImageSize(img)
    if self.ShowType ~= "Img" then
        self.ShowType = "Img"
        local CanvasSlot = UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Image_Guide)
        CanvasSlot:SetAutoSize(true)
        self.MediaPlayer:SetLooping(false)
        self.MediaPlayer:Close()
    end
    self.Image_Guide:SetBrushFromTexture(img,true)
end

function Guide_Image_Cell:ShowVideo(VideoPath)
    self:ScaleImageSize()
    local video = LoadObject(VideoPath)
    self.MediaPlayer:OpenSource(video)
    if self.ShowType ~= "Video" then
        self.ShowType = "Video"
        local CanvasSlot = UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Image_Guide)
        CanvasSlot:SetAutoSize(false)
        local media_material = LoadObject("/Game/UI/UI_PC/Guide/Guide_Image/MediaPlayer/Video_Material"..self.num_index..".Video_Material"..self.num_index)
        self.Image_Guide:SetBrushFromMaterial(media_material)
        -- self.Image_Guide:SetBrushSize(FVector2D(1240, 446))
        self.MediaPlayer:SetLooping(true)
    end
    self.VideoPath = VideoPath
end


function Guide_Image_Cell:ScaleImageSize(img)
    local Size = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Image_Guide):GetSize()
    local CellX = Size.X
    local CellY = Size.Y

    if img then
        local imgX = img:Blueprint_GetSizeX()
        local imgY = img:Blueprint_GetSizeY()
        self.SlotSize = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Image_Guide):SetSize(UE4.FVector2D(imgX,imgY))
    end

    self.SlotSize = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Image_Guide):GetSize()
    local SelfX = self.SlotSize.X
    local SelfY = self.SlotSize.Y

    local scalex = 1.0
    local scaley = 1.0

    -- 长/宽 > 面板的 长/宽
    if SelfX/SelfY > CellX/CellY then
        scaley = CellY/SelfY
        scalex = scaley
    else
        scalex = CellX/SelfX
        scaley = scalex
    end

    self.Image_Guide:SetRenderScale(UE4.FVector2D(scalex,scaley))
end

function Guide_Image_Cell:GetCurrentTextIsLong()
    if self.GuideType ~= "Text" then
        return false
    end
    if UIUtils.CheckScrollBoxCanScroll(self.EMScrollBox_Desc) then
        return true
    end
    return false
end

-- GamePad
function Guide_Image_Cell:UpdateTextOnInputDeviceChanged(NewInputDevice)
    self.CurInputDeviceType = NewInputDevice
    if self.CurInputDeviceType == ECommonInputType.Gamepad then
        self.CurrentInputDevice = {"GamepadKey"}
    else
        self.CurrentInputDevice = {"KeyboardKey","MouseButton"}
    end
    if not self.ChildInfo then
        return
    end
    self:UpdateCellText(nil, nil, true)
    self:UpdateCellImgs(nil, nil, true)
end

AssembleComponents(Guide_Image_Cell)
return Guide_Image_Cell