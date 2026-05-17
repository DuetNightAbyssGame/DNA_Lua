local FTypingBrBlock = require "Blueprints.Story.Talk.Typing.TypingBrBlock"
local FTypingTextBlock = require "Blueprints.Story.Talk.Typing.TypingTextBlock"
local FTypingImgBlock = require "Blueprints.Story.Talk.Typing.TypingImgBlock"
local FTypingBook = require "Blueprints.Story.Talk.Typing.TypingBook"
local MiscUtils = require "Utils.MiscUtils"
---@type WBP_TypingUserWidget_C
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

local ETypingStates = {None = 1, FirstFrame = 2, Init = 3, Typing = 4, Error = 5}

function M:Construct()
    self.RichMatch = "<.-/>"
    self.TextRichMatch = "<.->.-</>"
    self.TipsMath = "/*.-/*/"
    self.TextTipsMath = "/*.-*/.-/*/"
    self.BrMatch = "<br/>"
    self.ImgRichMatch = "<[i|I][m|M][g|G]%s+[i|I][d|D]=\".-\"/>"
    self.TypingState = ETypingStates.None
    self.Dialogue = nil
    self.TypingBook = nil
    self.TypingBlocks = nil
    self.CurPageIdx = 0
    self.CalcRichTextBlockSize = function(RichText)
        self.RichTextBlock_Calc:SetText(RichText)
        self.RichTextBlock_Calc:ForceLayoutPrepass()
        return self.RichTextBlock_Calc:GetDesiredSize()
    end
    self.FinishedIconRichText = "<img id=\"Arrow01\"/>"
    self.FinishedIconSize = self.CalcRichTextBlockSize(self.FinishedIconRichText)
    self.BlurMIs = {}
    self.LineUIs = {}

    local AllChildren = self.Canvas:GetAllChildren():ToTable() or {}
    for index, value in ipairs(AllChildren) do
        if(value ~= self.RichTextBlock_Calc)then
            value:RemoveFromParent()
        end
    end
end

function M:Tick(MyGeometry, InDeltaTime)
    if(self.TypingState == ETypingStates.None or self.TypingState == ETypingStates.Error)then
        return
    elseif(self.TypingState == ETypingStates.FirstFrame)then
        --第一帧不能计算出正确的大小，所以等待一帧
        self.TypingState = ETypingStates.Init
        return
    elseif self.TypingState == ETypingStates.Init then
        self:Init()
    elseif self.TypingState == ETypingStates.Typing then
        self:RealTyping(InDeltaTime)
    end
end

--对外提供的接口

---两帧后开始打字
---@param Dialogue string 对话文本
function M:Typing(Dialogue)
    if Dialogue == nil then
        self:ToFinish()
        return
    end
    self:SetRenderOpacity(0)
    self.Dialogue = Dialogue
    self.bPrepareToPageEnd = false
    self.bPrepareToFinish = false
    self.TypingState = ETypingStates.FirstFrame
end

---@param Speed float 打字速度
function M:SetTypingSpeed(Speed)
    self.TypingSpeed = Speed or 2
end

---@param TransFactor float 透明因子，影响打字机透明范围，值越小透明范围越大
function M:SetTransFactor(TransFactor)
    self.TransFactor = TransFactor or 10
end

---获取当前对话的总打字时间
function M:GetDialogueTypingTime()
    if(self.TypingSpeed > 0)then
        if(self.TypingState == ETypingStates.Typing)then
            --计算准确的打字时间
            local TotalTime = 0
            local PageIdx = 1
            while(self.TypingBook:GetPage(PageIdx))do
                local Page = self.TypingBook:GetPage(PageIdx)
                if(Page)then
                    local LineIdx = 1
                    while(Page:GetLine(LineIdx))do
                        local Line = Page:GetLine(LineIdx)
                        if(Line)then
                            TotalTime = TotalTime + 1 / (1000 / (1 + Line:GetSize().X) * self.TypingSpeed)
                        end
                        LineIdx = LineIdx + 1
                    end
                end
                PageIdx = PageIdx + 1
            end
            return TotalTime
        else
            --计算预估的打字时间
            if(self.Dialogue)then
                local LineSizeX = UE4.UKismetStringLibrary.Len(self.Dialogue) * 23
                return 1 / (1000 / (1 + LineSizeX) * self.TypingSpeed)
            end
        end
    end
    return 0
end

function M:BindEventOnPageEnd(Obj,Event)
    self.OnPageEnd = {}
    self.OnPageEnd.Obj = Obj
    self.OnPageEnd.Event = Event
end

function M:UnBindEventOnPageEnd()
    self.OnPageEnd = nil
end

function M:BindEventOnFinished(Obj,Event)
    self.OnFinished = {}
    self.OnFinished.Obj = Obj
    self.OnFinished.Event = Event
end

function M:UnBindEventOnFinished()
    self.OnFinished = nil
end

---@param bPause bool 是否暂停
function M:Pause(bPause)
    self.bPause = bPause
end

function M:IsPause()
    return self.bPause or false
end

function M:IsPageEnd()
    return self.bPageEnd or false
end

function M:ToPageEnd()
    if(self.TypingState ~= ETypingStates.Typing)then
        self.bPrepareToPageEnd = true
        return false
    end
    local Page = self.TypingBook:GetPage(self.CurPageIdx)
    if(Page)then
        local LineCount = Page:GetLineCount()
        if(self.LineUIs)then
            for i=1,LineCount do
                self:SetLineUIProcess(self.LineUIs[i].Widget,1)
            end
        end
    end
    self:PageEnd()
    if(self.CurPageIdx == self.TypingBook:GetPageCount())then
        self:Finish(true)
    else
        self:Finish(false)
    end
    return true
end

function M:PrePage()
    local PrePageIdx = self.CurPageIdx - 1
    return self:InitPageTyping(PrePageIdx)
end

function M:NextPage()
    local NextPageIdx = self.CurPageIdx + 1
    return self:InitPageTyping(NextPageIdx)
end

function M:IsFinished()
    return self.bFinished or false
end

function M:ToFinish()
    if(self.TypingState ~= ETypingStates.Typing and self.TypingState ~= ETypingStates.Error)then
        self.bPrepareToFinish = true
        return false
    end
    if(self.TypingBook and self.TypingBook:GetPageCount() >= 1)then
        self.CurPageIdx = self.TypingBook:GetPageCount()
        self:InitPageTyping(self.CurPageIdx)
        local Page = self.TypingBook:GetPage(self.CurPageIdx)
        local LineCount = Page:GetLineCount()
        for i=1,LineCount do
            self:SetLineUIProcess(self.LineUIs[i].Widget,1)
        end
    end
    self:PageEnd()
    self:Finish(true)
    return true
end

---设置垂直对齐方式
---@param Alignment EVerticalAlignment
function M:SetVerticalAlignment(Alignment)
    self.VerticalAlignment = Alignment or 0
end

---设置水平对齐方式（已废弃）
---@param Alignment HorizontalAlignment
function M:SetHorizontalAlignment(Alignment)
    self.HorizontalAlignment = Alignment or 0
end

---显示页结束标记
function M:ShowPageEndIcon()
    if(self.TypingBook)then
        local Page = self.TypingBook:GetPage(self.CurPageIdx)
        if(Page)then
            local LineCount= Page:GetLineCount()
            local Line = Page:GetLine(LineCount)
            local LineUI = self.LineUIs[LineCount]
            if(Line and LineUI)then
                local Size = Line:GetSize()
                local RBSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(LineUI.Widget.RetainerBox)
                RBSlot:SetSize(FVector2D(Size.X + self.FinishedIconSize.X,Size.Y))
                LineUI.Widget.MainRichText:SetText(Line:GetRichText()..self.FinishedIconRichText)
            end
        end
    end
end
------------

function M:PageEnd()
    self.bPageEnd = true
    if(self.OnPageEnd)then
        self.OnPageEnd.Event(self.OnPageEnd.Obj)
    end
end

---@param FinishOrPageEnd bool true为Finish，false为PageEnd
function M:Finish(FinishOrPageEnd)
    self.bFinished = FinishOrPageEnd
    if(self.bFinished)then
        self.TypingState = ETypingStates.None
    end
    if(self.OnFinished)then
        self.OnFinished.Event(self.OnFinished.Obj,FinishOrPageEnd)
    end
end

function M:Init()
    self.TypingBlocks = self:SplitRich(self.Dialogue)
    if(self:CalculateSize() and self:InitPageTyping(1))then
        self:SetRenderOpacity(1)
        self.TypingState = ETypingStates.Typing
    else
        MiscUtils.Error("TypingUserWidget initialization failed or empty dialogue!")
        self.TypingState = ETypingStates.Error
        self:ToFinish()
    end
end

function M:CalculateSize()
    self.SelfSize = FVector2D(self.Root.WidthOverride,self.Root.MaxDesiredHeight)
    if(UE4.UKismetMathLibrary.IsZero2D(self.SelfSize))then
        return false
    end
    self.TypingBook = FTypingBook:New(self.SelfSize)

    for _, Block in ipairs(self.TypingBlocks) do
        if(Block:GetType() ~= "br")then
            local RichText = Block:GetRichText()
            local Size = self.CalcRichTextBlockSize(RichText)
            Block:SetSize(Size)
            local superscript = Block:GetAttr("note")
            if(superscript)then
                --上标
                local SText= superscript["text"]
                local SBlock = FTypingTextBlock:New(SText,superscript["style"] or "Note")
                local SRichText = SBlock:GetRichText()
                SBlock:SetSize(self.CalcRichTextBlockSize(SRichText))
                Block:SetAttr("superscript_block",SBlock)
            end
        end
        self.TypingBook:AddBlock(Block, self)
    end
    return true
end

function M:SplitRich(Text)
    local Blocks = {}
    --local TextLines = UE4.UKismetStringLibrary.ParseIntoArray(Text,self.BrMatch)
    local TextLines = UE4.UKismetStringLibrary.ParseIntoArray(Text,"\n")
    for _, TextLine in pairs(TextLines) do
        self:SplitBlock(Blocks, TextLine, self.RichMatch)
        table.insert(Blocks,FTypingBrBlock:New())
    end
    table.remove(Blocks,#Blocks)
    return Blocks
end

function M:SplitBlock(BlockArr, Text, Match)
    local InitIdx = 1; local StartIdx = 1; local EndIdx = 1
    while true do
        StartIdx, EndIdx = string.find(Text, Match, InitIdx)
        if StartIdx == nil then
            break
        end
        local LeftStr = string.sub(Text, InitIdx, StartIdx - 1)
        if LeftStr ~= nil and LeftStr ~= "" then
            table.insert(BlockArr, FTypingTextBlock:New(LeftStr,"Default"))
        end
        local RichStr = string.sub(Text, StartIdx, EndIdx)
        if RichStr ~= nil and RichStr ~= "" then
            self:CalcRich(BlockArr,RichStr)
        end
        InitIdx = EndIdx + 1
    end
    local RemainStr = string.sub(Text, InitIdx, #Text)
    if RemainStr ~= nil and RemainStr ~= "" then
        table.insert(BlockArr, FTypingTextBlock:New(RemainStr,"Default"))
    end
end

function M:_TryTransUpRichStyle(RichTagAndAttrs)
    if string.startswith(RichTagAndAttrs, "up") then
        local upList = string.split(RichTagAndAttrs," ")
        local NewAttrs = {}
        for i=2, #upList do
            local Attr = upList[i]
            local AttrName,Val = table.unpack(string.split(Attr, '='))
            local Val = string.sub(Val, 2, #Val-1)
            if AttrName == 'text' or AttrName=='style' then
                local NewAttr = string.format("%s:%s",AttrName, Val)
                table.insert(NewAttrs, NewAttr)
            end
        end
        return string.format("Default note=\"%s\"",table.concat(NewAttrs,','))
    end
    return RichTagAndAttrs
end

function M:CalcRich(BlockArr,RichStr)
    local IsMatch = string.match(RichStr, self.TextRichMatch)
    RichStr = self:RemoveSpaces(RichStr)
    if IsMatch then
        local T1 = string.find(RichStr, ">") + 1
        local RichTagAndAttrs = string.sub(RichStr, 2, T1 - 2)
        local T2 = string.find(RichStr, "<", T1) - 1
        local Text = string.sub(RichStr, T1, T2)
        RichTagAndAttrs = self:_TryTransUpRichStyle(RichTagAndAttrs)
        local Tag,Attrs = self:SplitTagAndAttrs(RichTagAndAttrs)
        table.insert(BlockArr, FTypingTextBlock:New(Text,Tag,Attrs))
    end
    IsMatch = string.match(RichStr, self.ImgRichMatch)
    if IsMatch then
        local T1 = string.find(RichStr, "<") + 1
        local T2 = string.find(RichStr, "/>", T1) - 1
        local RichTagAndAttrs = string.sub(RichStr, T1, T2)
        local Tag,Attrs = self:SplitTagAndAttrs(RichTagAndAttrs)
        table.insert(BlockArr, FTypingImgBlock:New(Tag,Attrs))
    end
end

function M:RemoveSpaces(RichStr)
    --删除多余的空格
    RichStr = string.gsub(RichStr,"%s+"," ")
    RichStr = string.gsub(RichStr,"%s*=%s*\"%s*","=\"")
    --RichStr = string.gsub(RichStr,"%s*[:|,]%s*",function(x) return MiscUtils.Trim(x) end)
    RichStr = string.gsub(RichStr,"%s*\"","\"" )
    return RichStr
end

function M:SplitTagAndAttrs(RichTagAndAttrs)
    local StartIdx = 1
    local EndIdx = string.find(RichTagAndAttrs, "%s", 1)
    if EndIdx == nil then
        return RichTagAndAttrs
    end
    local RichTag = string.sub(RichTagAndAttrs, StartIdx, EndIdx - 1)
    local Len = #RichTagAndAttrs
    local AttrTable = {}
    local AttrStr = string.sub(RichTagAndAttrs, EndIdx + 1, Len)
    while true do
        StartIdx, EndIdx = string.find(AttrStr, "%w+=\".-\"", StartIdx)
        if StartIdx == nil then
            break
        end
        local Attr = string.sub(AttrStr, StartIdx, EndIdx -1)
        local Mid = string.find(Attr,"=",StartIdx)
        local AttrName = string.sub(AttrStr,StartIdx,Mid-1)
        AttrName = string.lower(AttrName)
        local AttrContent = string.sub(AttrStr,Mid+2,EndIdx-1)
        local SubAttrs = Utils.Split(AttrContent,",")
        if(string.find(AttrContent,":",1))then
            local SubAttrTable = {}
            for _, value in ipairs(SubAttrs) do
                local SubAttr = Utils.Split(value,":")
                SubAttr[1] = string.lower(SubAttr[1])
                SubAttrTable[SubAttr[1]] = SubAttr[2]
            end
            AttrTable[AttrName] = SubAttrTable
        else
            AttrTable[AttrName] = AttrContent
        end
        AttrStr = string.sub(AttrStr,EndIdx + 2,Len)
    end
    return RichTag,AttrTable
end

function M:InitPageTyping(Index)
    if(self.TypingBook == nil)then
        return false
    end
    local Page = self.TypingBook:GetPage(Index)
    if(Page == nil)then
        return false
    end
    self.CurPageIdx = Index
    self.CurLineIdx = 1
    self.bPause = false
    self.bPageEnd = false
    self.bFinished = false
    self.TypingProcess = 0
    self.LineUIs = self.LineUIs or {}
    for _, LineUI in ipairs(self.LineUIs) do
        LineUI.Widget.MainRichText:SetText("")
        self:SetLineUIProcess(LineUI.Widget,0)
        for _, SuperscriptUI in ipairs(LineUI.SuperscriptUIs) do
            SuperscriptUI:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
    end
    local LineCount = Page:GetLineCount()
    self.LinePosX = (self.TypingBook:GetSize().X - Page:GetSize().X) / 2
    self.LinePosX = (self.LinePosX < 0 and 0) or self.LinePosX
    self.NextLinePosY = 0
    if(LineCount >=1 )then
        -- local Line1 = Page:GetLine(1)
        -- if(Line1:GetSuperscriptCount() >= 1)then
        --     self.NextLinePosY = self.NextLinePosY - Line1:GetSuperscriptSize().Y
        -- end
        for i=1,LineCount do
            self.NextLinePosY = self:InitLineTyping(Page,i,self.NextLinePosY)
        end
    end

    self.TypingState = ETypingStates.Typing
    return true
end

function M:InitLineTyping(Page,Index,LinePosY)
    local Line = Page:GetLine(Index)
    local LineUI = self.LineUIs[Index]
    if(LineUI == nil)then
        local Widget = UE4.UWidgetBlueprintLibrary.Create(self, self.TypingLineUIClass)
        self.Canvas:AddChild(Widget)
        Widget:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        LineUI = {Widget = Widget,SuperscriptUIs = {}}
        table.insert(self.LineUIs,LineUI)
        self:SetLineBGBlurProcess(Widget,0)
    end
    local Widget = LineUI.Widget
    --设置行控件大小、位置
    local LineSize = Line:GetSize()
    local PagePos = FVector2D(0,0)
    local LinePos
    local PageSize = Page:GetSize()
    local BookSize = self.TypingBook:GetSize()
    if(self.VerticalAlignment == EVerticalAlignment.VAlign_Center)then
        PagePos.Y = (BookSize.Y - PageSize.Y) / 2
        PagePos.Y = (PagePos.Y < 0 and 0) or PagePos.Y
    elseif(self.VerticalAlignment == EVerticalAlignment.VAlign_Bottom)then
        PagePos.Y = BookSize.Y - PageSize.Y
        PagePos.Y = (PagePos.Y < 0 and 0) or PagePos.Y
    else
        --Top
    end
    LinePos = FVector2D(self.LinePosX, PagePos.Y + LinePosY)

    Widget.Slot:SetPosition(LinePos)
    Widget.Slot:SetSize(LineSize)
    Widget.RetainerBox.Slot:SetSize(LineSize)
    -- Widget.CanvasPanel_Main.Slot:SetSize(LineSize)
    Widget.BackgroundBlurWithMask.Slot:SetSize(LineSize)
    --local BlurMaskPos = FVector2D(LinePos.X,LinePos.Y + LineSize.Y/2)
    --Widget.BackgroundBlurWithMask.Slot:SetPosition(BlurMaskPos)
    LinePosY = LinePosY + LineSize.Y

    --设置上标位置
    local SuperscriptCount = Line:GetSuperscriptCount()
    local MaxSuperscriptHeight = 0
    for j = 1,SuperscriptCount do
        local SuperscriptBlock = Line:GetSuperscript(j)
        local SuperscriptUI = LineUI.SuperscriptUIs[j]
        if(SuperscriptUI == nil)then
            SuperscriptUI = NewObject(self.SuperscriptUIClass,self)
            SuperscriptUI:SetTextStyleSet(self.TextStyleSet)
            Widget.Canvas_Line:AddChild(SuperscriptUI)
            table.insert(LineUI.SuperscriptUIs,SuperscriptUI)
        end
        SuperscriptUI:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        SuperscriptUI:SetText(SuperscriptBlock:GetRichText())
        local SSize = SuperscriptBlock:GetSize()
        MaxSuperscriptHeight = math.max(MaxSuperscriptHeight,SSize.Y)
        local SPos = FVector2D(SuperscriptBlock.RelativePosX,0)
        if(SPos.X < 0)then
            --上标位置超出最左侧
            SPos.X = 0--LinePos.X
        elseif(SPos.X + SSize.X > LineSize.X)then
            --上标末端超出最右侧
            SPos.X = LineSize.X - SSize.X
        end
        local SSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(SuperscriptUI)
        SSlot:SetPosition(SPos)
    end

    --主体文本位置
    Widget.MainRichText:SetText(Line:GetRichText())
    Widget.MainRichText.Slot:SetPosition(FVector2D(0,MaxSuperscriptHeight))
    --行打字速度
    Line.TypingSpeed = 1000 / (1 + LineSize.X) * self.TypingSpeed
    self:SetLineUITransFactor(LineUI.Widget,LineSize.X / 1000 * self.TransFactor)
    self:SetLineUIProcess(LineUI.Widget,0)
    return LinePosY
end

function M:SetLineUITransFactor(UI,Factor)
    local Meterial = UI.RetainerBox:GetEffectMaterial()
    Meterial:SetScalarParameterValue("Factor",Factor)
    local BlurMI = self:GetBGBlurMI(UI)
    BlurMI:SetScalarParameterValue("Factor",Factor)
end

function M:GetBGBlurMI(LineUI)
    self.BlurMIs = self.BlurMIs or {}
    if(not self.BlurMIs[LineUI])then
        self.BlurMIs[LineUI] = UKismetMaterialLibrary.CreateDynamicMaterialInstance(self,LineUI.BackgroundBlurWithMask.MaskMaterialSetting.MaskMaterial)
        local bfs = LineUI.BackgroundBlurWithMask.MaskMaterialSetting
        local MMSettings = FMaskMaterialSetting()
        MMSettings.ToTextureSize = bfs.ToTextureSize
        MMSettings.RedrawMethod = bfs.RedrawMethod
        MMSettings.MaskMaterial = self.BlurMIs[LineUI]
        LineUI.BackgroundBlurWithMask:SetMaskMaterialSetting(MMSettings)
    end
    return self.BlurMIs[LineUI]
end

function M:SetLineUIProcess(UI,Proess)
    local Meterial = UI.RetainerBox:GetEffectMaterial()
    Meterial:SetScalarParameterValue("Process",Proess)
    self:SetLineBGBlurProcess(UI,Proess)
end

function M:SetLineBGBlurProcess(UI,Proess)
    local BlurMI = self:GetBGBlurMI(UI)
    BlurMI:SetScalarParameterValue("Process",Proess)
end

function M:RealTyping(DeltaTime)
    if(self.bPrepareToFinish)then
        self:ToFinish()
        return
    end
    if(self.bPrepareToPageEnd)then
        self:ToPageEnd()
        return
    end
    if(self.bPause or self.bPageEnd)then
        return
    end
    if(self.TypingState ~= ETypingStates.Typing)then
        return
    end
    local Page = self.TypingBook:GetPage(self.CurPageIdx)
    local Line = Page:GetLine(self.CurLineIdx)
    self.TypingProcess = self.TypingProcess + DeltaTime * Line.TypingSpeed
    self:SetLineUIProcess(self.LineUIs[self.CurLineIdx].Widget,self.TypingProcess)
    if(self.TypingProcess >= 1)then
        self.TypingProcess = DeltaTime
        self.CurLineIdx = self.CurLineIdx + 1
        if(Page:GetLine(self.CurLineIdx) == nil)then
            self:PageEnd()
            if(self.TypingBook:GetPage(self.CurPageIdx + 1) == nil)then
                self:Finish(true)
            else
                self:Finish(false)
            end
        end
    end
end

return M
