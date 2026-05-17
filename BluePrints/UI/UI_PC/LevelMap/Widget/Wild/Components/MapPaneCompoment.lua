require "UnLua"

local Component = {}

function Component:InitComponentCoroutine()
    self.SelectedBlock = {}
end

function Component:OnPaneButtonDown(PaneBtn)
    local PaneIndex = PaneBtn.PaneIndex
    local BtnIndex = PaneBtn.Index
    local BtnImage = PaneBtn.Choose
    local FloorId = PaneBtn.FloorId
    self.Selecting = true
    if not self.SelectedBlock[FloorId] then
        self.SelectedBlock[FloorId] = {}
    end
    if not self.SelectedBlock[FloorId][PaneIndex] then
        self.SelectedBlock[FloorId][PaneIndex] = {}
    end
    if not self.SelectedBlock[FloorId][PaneIndex][BtnIndex] then
        self.SelectedBlock[FloorId][PaneIndex][BtnIndex] = true
        self.AddSelecting = true
        BtnImage:SetRenderOpacity(1)
    else
        self.SelectedBlock[FloorId][PaneIndex][BtnIndex] = nil
        self.AddSelecting = false
        BtnImage:SetRenderOpacity(0)
    end
end

function Component:OnPaneButtonUp(PaneBtn)
    self.Selecting = false
    PrintTable(self.SelectedBlock,2)
end

function Component:OnPaneButtonEnter(PaneBtn)
    if not self.Selecting then
        return
    end
    if (self.AddSelecting and PaneBtn.Choose:GetRenderOpacity() == 0) or (not self.AddSelecting and PaneBtn.Choose:GetRenderOpacity() == 1) then
        self:OnPaneButtonDown(PaneBtn)
    end
end

function Component:OnPaneButtonLeave(PaneBtn)
    if not self.Selecting then
        return
    end
end

function Component:GetRegionMapBlock()
    if self.SelectedBlock then
        local JsonTable = {}
        for FloorId, T in pairs(self.SelectedBlock) do
            for PaneIndex, SmallTable in pairs(T) do
                local BigTable = {}
                BigTable["Big"] = PaneIndex
                BigTable["Small"] = CommonUtils.Keys(SmallTable)
                table.sort(BigTable["Small"])
                BigTable["FloorId"] = FloorId
                table.insert(JsonTable, BigTable)
            end
        end
        PrintTable(JsonTable,2)
        local json= require("rapidjson")
        return json.encode(JsonTable)
    end
    return ''
end

function Component:SetRegionMapBlock(Block)
    self:ClearRegionMapBlock()
    local json= require("rapidjson")
    local NewBlock = json.decode(Block)
    if not NewBlock then
        return
    end
    for _,Block in pairs(NewBlock) do
        for _,Index in pairs(Block.Small) do
            if self.PaneBtns and self.PaneBtns[Block.FloorId] and self.PaneBtns[Block.FloorId][Block.Big] and self.PaneBtns[Block.FloorId][Block.Big][Index] then
                self:OnPaneButtonDown(self.PaneBtns[Block.FloorId][Block.Big][Index])
            end
        end
    end
    self.Selecting = false
end

function Component:ClearRegionMapBlock()
    if not self.PaneBtns then
        return
    end
    self.SelectedBlock = {}
    for FloorId,T1 in pairs(self.PaneBtns) do
        for Big,T2 in pairs(T1) do
            for Small, Btn in pairs(T2) do
                if Btn then
                    Btn.Choose:SetRenderOpacity(0)
                end
            end
        end
    end
end

function Component:ClearData()
    self.PaneBtns = {}
end

return Component