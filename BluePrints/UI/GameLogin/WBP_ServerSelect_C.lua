--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"
require "DataMgr"
local DevServerList = require "BluePrints/UI/GameLogin/DevServerList"

local WBP_ServerSelect_C = Class("BluePrints.UI.BP_UIState_C")
--所有服务器（不分区）
local AllServers = nil
--所有服务器（分区）
local ServerList = nil
--当前选中区域包含的服务器
local CurrentServerList = nil
--当前选中区域编号
local CurrentArea = 0

function WBP_ServerSelect_C:Construct()
    self.Super.Construct(self)
end

function WBP_ServerSelect_C:CloseUI()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
    -- UIUtils.PlayCommonBtnSe(self)
    self:Show(UIConst.VisibilityOp["Collapsed"])
    self:Close()
end

function WBP_ServerSelect_C:Show(VisibilityOp)
    self:SetVisibility(VisibilityOp)
    if(VisibilityOp == UIConst.VisibilityOp["Visible"]) then
        self:PlayAnim("HideOrShow_Panel_Server")
        if(ServerList == nil) then
            self:RefreshSeverList()
        else
            self:VerifyListViewCallBack()
            --选定上次关闭前的选项
            --self.ListView_Area:BP_SetSelectedItem(self.SelectedArea)
            self.ListView_Area:SetSelectedIndex(CurrentArea)
        end
    end
end

--重新获取服务器列表
function WBP_ServerSelect_C:RefreshSeverList()
    self.CircularThrobber_1:SetVisibility(UIConst.VisibilityOp["Visible"])
    self:TryToGetServerList()
end

--尝试从网络获取服务器列表
function WBP_ServerSelect_C:TryToGetServerList()
    self:AddTimer(0.5, self.VerifyListViewCallBack, false, 0, "VerifyListView")
    --暂时读表，待完善
    -- AllServers = DevServerList
    AllServers = {}
    for k, v in pairs(DevServerList) do
        if k < 1000 or (k >= 7000 and k <= 7100) or (k >= 8000 and k <= 8100) then 
            AllServers[k] = v
        end
        
    end
end

function WBP_ServerSelect_C:VerifyListViewCallBack()
    if(AllServers)then
        self.ListView_Area:ClearListItems()
        local obj = self:NewAreaItemContent(nil)
        CurrentArea = 0
        obj.Area = CurrentArea
        obj.Name = "推荐"
        self.ListView_Area:AddItem(obj)

        ServerList={
            {area = 1,name="开发",servers=nil},
            {area = 2,name="开发2",servers=nil},
            {area = 3,name="QA",servers=nil},
            {area = 4,name="策划",servers=nil},
            {area = 5,name="其他",servers=nil},
        }
        
        for k, v in pairs(AllServers) do
            if(ServerList[v.area] == nil)then
                ServerList[v.area]={area=v.area,name="Area "..v.area,servers=nil}
            end
            if(ServerList[v.area].servers == nil)then
                ServerList[v.area].servers={}
            end
            ServerList[v.area].servers[k]=v
        end
        --DataMgr.Print_t(ServerList)

        for k, v in pairs(ServerList) do
            if(v.servers)then
                local AreaContent ={area=v.area,name=v.name}
                self.ListView_Area:AddItem(self:NewAreaItemContent(AreaContent))
            end
        end
        --ServerList生成后再选择0号Area
        self.ListView_Area:BP_SetSelectedItem(obj)
        self:RemoveTimer("VerifyListView")
        self.CircularThrobber_1:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    else
        print(_G.LogTag,"Failed to get server list, error code:")
    end
end

function WBP_ServerSelect_C:NewAreaItemContent(content)
    if(content == nil)then
        return NewObject(self.AreaItemContentClass,self.ListView_Area)
    end
    local obj = NewObject(self.AreaItemContentClass,self.ListView_Area)
    obj.Area = content.area
    obj.Name = content.name
    obj.IsSelected = false
    return obj
end

function WBP_ServerSelect_C:NewServerItemContent(content)
    if(content == nil)then
        return NewObject(self.ServerItemContentClass,self.List)
    end
    local obj = NewObject(self.ServerItemContentClass,self.List)
    obj.HostId=content.hostnum
    obj.Area = content.area
    obj.Name = content.name
    obj.IP = content.ip
    obj.Port = content.port
    obj.IsSelected = false
    return obj
end

--切换区域
function WBP_ServerSelect_C:SwitchArea(area)
    if not GWorld.IsDev then
        return 
    end
    if area ~= CurrentArea then
        UIUtils.PlayCommonBtnSe(self)
    end
    if(ServerList ~= nil) then
        CurrentArea = area
        self.SelectedArea = self.ListView_Area:BP_GetSelectedItem()
        --print(_G.LogTag,"SwitchArea:",self.SelectedArea.Name)
        self.List:ClearListItems()

        CurrentServerList = {}
        --第0号Area显示所有服务器
        if(area == 0)then
            for k,v in pairs(AllServers) do
                table.insert(CurrentServerList, v)
                --self.List:AddItem(self:NewServerItemContent(v))
            end
        else
            for k, v in pairs(ServerList) do
                if(v.area == area and v.servers)then
                    for k,v in pairs(v.servers) do
                        if(v.area == area) then
                            table.insert(CurrentServerList, v)
                            --self.List:AddItem(self:NewServerItemContent(v))
                        end
                    end
                    break
                end
            end
        end

        table.sort(CurrentServerList, function(a, b)
            return a.hostnum < b.hostnum
        end)
        --换区时搜索
        self:SearchServer(self.Input_Search_Server:GetText())

    end
end

function WBP_ServerSelect_C:SearchServer(text)
    if(CurrentServerList ~= nil) then
        self.List:ClearListItems()
        if(text ~= nil)then
            for k,v in pairs(CurrentServerList) do
                if string.find(v.name,text) ~= nil or string.find(v.hostnum,text) ~= nil then
                    self.List:AddItem(self:NewServerItemContent(v))
                end
            end
        else
            for k,v in pairs(CurrentServerList) do
                self.List:AddItem(self:NewServerItemContent(v))
            end
        end
    end
end

function WBP_ServerSelect_C:Confirm()
    local item = self.List:BP_GetSelectedItem()
    if(item ~= nil and self.SelectedServer ~= item) then
        self.SelectedServer = item
        self.IsSelectionChanged = true
    else
        self.IsSelectionChanged = false
    end
end

function WBP_ServerSelect_C:PlayUISound(EventPath)
    AudioManager(self):PlayUISound(self, EventPath, nil, nil)
end

return WBP_ServerSelect_C
