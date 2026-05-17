--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Guide_GuideBook_Cell_C
local M = Class(
        {
            "BluePrints.UI.BP_UIState_C",
        }
)

M._components = {
    "BluePrints.UI.WidgetComponent.ChangeTextToKeyInfoComponent"
}

function M:Construct()
    self.GuideType = "None"
    self.CurrentInputDevice = {"KeyboardKey","MouseButton"}
    self.CurInputDeviceType = UIUtils.UtilsGetCurrentInputType()
    -- Dungeon
    --self.IsDungeonGuide = false
end

function M:Destruct()
    if self.MediaPlayer and self.MediaPlayer:IsPlaying() then
        self.MediaPlayer:SetLooping(false)
        self.MediaPlayer:Close()
    end
end

-- 设置当前是第几个步骤
function M:SetNumStep(i)
    self.num_index = i
    self.Text_Index:SetText(i)
    self.MediaPlayer = LoadObject("MediaPlayer'/Game/UI/UI_PC/Guide/Guide_Image/MediaPlayer/MediaPlayer_Video"..i..".MediaPlayer_Video"..i.."'")
end

-- 设置当前显示类型,副标题,文本,图片放在下一个步骤去处理
function M:SetGuideType(GuideType)
    self.GuideType = GuideType
    if self.GuideType == "ImageText" then
        -- 隐藏步骤数字
        self.Group_Index:SetVisibility(UE4.ESlateVisibility.Collapsed)
    elseif self.GuideType == "ProcessNode" then
        --self.WidgetSwitcher_State:SetActiveWidgetIndex(0)
        -- 显示步骤数字
        self.Group_Index:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    elseif self.GuideType == "Text" then
        --self.WidgetSwitcher_State:SetActiveWidgetIndex(1)
    end
end

function M:UpdateContent(ChildGuideId, i, isPC)
    -- if self.IsDungeonGuide then
    --     self.ChildInfo = DataMgr.DungeonUIChildGuide[ChildGuideId]["GuideInfo"..i]
    -- else
    --     self.ChildInfo = DataMgr.UIChildGuide[ChildGuideId]["GuideInfo"..i]
    -- end
    self.ChildInfo = DataMgr.UIChildGuide[ChildGuideId]["GuideInfo"..i]
    --self:UpdateCellText(ChildGuideId, i, isPC)
    self:UpdateCellImgs(ChildGuideId, i, isPC)
    self:PlayAnimation(self.SwitchCell)
end

function M:UpdateCellImgs(ChildGuideId, i, isPC)
    -- 指需要考虑当前Cell images的SrcollIn&ScrollOut即可
    self:GetChildeGuideUIInfoById(ChildGuideId, i, isPC)
end

-- 更新副标题和文本
--function M:UpdateCellText(ChildGuideId, i, isPC)
--    local SubTitleText = self.ChildInfo.GuideSubTitle
--    --if SubTitleText then
--    --    self.Guide_Title:SetText(GText(SubTitleText))
--    --    self.Guide_Title:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
--    --else
--    --    self.Guide_Title:SetVisibility(UE4.ESlateVisibility.Collapsed)
--    --end
--
--    local ContentText = nil
--    if isPC then
--        ContentText = GText(self.ChildInfo.GuideContent.PC)
--    else
--        ContentText = GText(self.ChildInfo.GuideContent.Phone)
--    end
--    local ChildGuideDescValues = self.ChildInfo.GuideDescValues
--    ContentText = self:AnalyzeGuideDesc(ContentText, ChildGuideDescValues)
--    ContentText = self:GetFinalContentText(ContentText)
--    DebugPrint("@zyh111", ContentText)
--    --self.Guide_Desc_Image:SetText(ContentText)
--    self.Guide_Desc_Text:SetText(ContentText)
--end

-- &Attack&
--function M:GetFinalContentText(ContentText)
--    local strs = self:AnalyzeText(ContentText, "&")
--    local final_str = ""
--    for i,v in pairs(strs) do
--        if string.find(v,"&") then
--            local KeyType = nil
--            local ActionName = string.sub(v, 2, -2)
--            local Key = nil
--            Key, KeyType = self:GetKeyName(ActionName)
--            if KeyType == "KeyboardKey" then
--                Key = GText(Key) ~= "" and GText(Key) or Key
--                final_str = final_str.."<Highlight>"..Key.."</>"
--            elseif KeyType == "MouseButton" or KeyType == "GamepadKey" then
--                final_str = final_str..'<img id="'..Key..'"></>'
--            end
--        else
--            final_str = final_str..v
--        end
--    end
--    return final_str
--end

-- get picture type and source from table
function M:GetChildeGuideUIInfoById(ChildGuideId, i, isPC)
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

function M:ShowImg(ImgPath)
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

function M:ShowVideo(VideoPath)
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


function M:ScaleImageSize(img)
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

-- GamePad
function M:UpdateTextOnInputDeviceChanged(NewInputDevice)
    self.CurInputDeviceType = NewInputDevice
    if not self.ChildInfo then
        return
    end
    self:UpdateCellImgs(nil, nil, true)
end

AssembleComponents(M)
return M
