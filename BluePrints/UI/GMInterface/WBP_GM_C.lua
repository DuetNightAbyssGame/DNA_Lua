--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"
local GameFlowUtils = require "Utils.GameFlowUtils"

local GMCommandConfig = require "BluePrints.UI.GMInterface.GMCommandConfig"
local GMVariable = require "BluePrints.UI.GMInterface.GMVariable"
local GMFunctionLibrary = require "BluePrints.UI.GMInterface.GMFunctionLibrary"
local GMObjectUtils = require "BluePrints.UI.GMInterface.GMObjectUtils"

local WBP_GM_C = Class("BluePrints.UI.BP_UIState_C")

local LastGMTabIndex = 0
local GMTabTotalNum = 0

function WBP_GM_C:Initialize(Initializer)
    self.Super.Initialize(self)
    local GMKeys = UE4.TArray(UE4.FInputActionKeyMapping)
    UE4.UInputSettings.GetInputSettings():GetActionMappingByName("OpenGM",GMKeys)
    self.GMKeys = GMKeys:ToTable()
end

function WBP_GM_C:Construct()
    WBP_GM_C.Super.Construct(self)
    self.Input_GM:SetText("")
    self.Input_Search:SetText("")
    self.Input_GM.OnTextCommitted:Add(self, self.ExecuteGMCommand)
    self.Btn_Clear.OnClicked:Add(self, self.ExecuteGMCommand)
    self.Input_Search.OnTextCommitted:Add(self, self.OnSearchGM)
    self.Btn_Search.OnPressed:Add(self, self.OnSearchBtn)
    self.HorizontalBox_0:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.SearchResTitle:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Text_Search:SetText("搜索")
end

function WBP_GM_C:OnSearchBtn()
    local BtnText = self.Text_Search:GetText()
    if BtnText == "搜索" then
        self:ExecuteSearchGM()
    elseif BtnText == "清空" then
        self.Input_Search:SetText("")
        self:OnSearchTextChange("")
    end
end

function WBP_GM_C:OnSearchTextChange(Text)
    if not self.IsInit then return end
    if Text == "" then
        self.List_Tab_Top:SetSelectedIndex(LastGMTabIndex)
        self.HorizontalBox_0:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.SearchResTitle:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Text_Search:SetText("搜索")
    end
end

function WBP_GM_C:ExecuteSearchGM()
    local SearchText = self.Input_Search:GetText()
    if string.isempty(SearchText) then
        return
    end

    local AllContentArray = TArray(UObject)
    for _,Command in pairs(self.GMPanelObj.Commands) do
        AllContentArray:Append(Command.Commands)
    end

    self:SearchCommandByName(SearchText, {Commands=AllContentArray})
    self.HorizontalBox_0:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.SearchResTitle:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.SearchResTitle:SetText(string.format('"%s"的搜索结果(%s个)',SearchText,self.List:GetNumItems()))
end

function WBP_GM_C:OnSearchGM()
    self:ExecuteSearchGM()
    local SearchText = self.Input_Search:GetText()
    if not string.isempty(SearchText) then
        self.Text_Search:SetText("清空")
    else
        self:OnSearchTextChange("")
    end
end

function WBP_GM_C:RegisterFlow()
    self.Flow = GameFlowUtils:AddFlow("OpenSystemUI")
end

function WBP_GM_C:UnregisterFlow()
    if(self.Flow)then
        GameFlowUtils:RemoveFlow(self.Flow)
    end
    self.Flow = nil
end

function WBP_GM_C:OnLoaded(...)
    self.Super.OnLoaded(self,...)
    self:RegisterFlow()
    if(not IsValid(self.GMPanelObj))then
        self:TryToGetCommandList()
        assert(self.GMPanelObj, "GM指令列表读取失败,请检查格式或路径！")
        --初始化Tab栏
        self.List_Tab_Top:ClearListItems()
        for k, v in pairs(self.GMPanelObj.Commands)do
            self.List_Tab_Top:AddItem(v)
        end
        self.List_Tab_Top:SetSelectedIndex(LastGMTabIndex)
    end

    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    if(Player)then
        local str = "沉浸模式"
        if(Player.IsImmersionModel)then
            str = str.."：开"
        else
            str = str.."：关"
        end
        self.Text_Immerse:SetText(str)
    end

    local str = "界面数据"
    if(GMVariable.EnableUIData)then
        str = str.."：开"
    else
        str = str.."：关"
    end
    self.Text_Data:SetText(str)
    self.Key_L:CreateCommonKey({KeyInfoList = {{Type = "Text",Text = UE4.EKeys.Q.KeyName,}},})
    self.Key_R:CreateCommonKey({KeyInfoList = {{Type = "Text",Text = UE4.EKeys.E.KeyName,}},})
    GMTabTotalNum = self.List_Tab_Top:GetNumItems()
end

function WBP_GM_C:TryToGetCommandList()
    self.GMPanelObj = GMObjectUtils.NewCommandObject(GMCommandConfig,self.CommandContentClass)
    if(IsValid(self.GMPanelObj))then
        local len1 = self.GMPanelObj.Commands:Length()
        for i=1,len1,1 do
            self.GMPanelObj.Commands[i].ParentWidget = self
            local len2 = self.GMPanelObj.Commands[i].Commands:Length()
            for j=1,len2,1 do
                self.GMPanelObj.Commands[i].Commands[j].ParentWidget = self
            end
        end
    end
    GMVariable.AllCommands = self.GMPanelObj
end

function WBP_GM_C:SearchCommandByName(text,Command)
    if text == nil or not Command or (type(Command)=="userdata" and not IsValid(Command)) then
        return
    end
    UE4.UWidgetBlueprintLibrary.DismissAllMenus()   --关闭所有子菜单
    local commands = Command.Commands
    self.List:ClearListItems()
    for _,v in pairs(commands) do
        local FindRes = UKismetStringLibrary.FindSubstring(v.Text,text, false)
        if v.Text ~= nil and (FindRes~=-1 or text=="") then
            self.List:AddItem(v)
            self.List:BP_SetItemSelection(v,v.IsEnable)
        end
    end
end

function WBP_GM_C:ExecuteGMCommand()
    -- local execute_str = self.Input_GM:GetText()
    -- print(_G.LogTag, execute_str)
    GMFunctionLibrary.ExecConsoleCommand(self,self.Input_GM:GetText())
    self.Input_GM:SetText("")
    self.Input_GM:SetHintText('请输入指令')
end

function WBP_GM_C:UIData()
    UIUtils.PlayCommonBtnSe(self)
    GMVariable.EnableUIData = not GMVariable.EnableUIData
    GMFunctionLibrary.ShowUIData(GMVariable.EnableUIData)
    local str = "界面数据"
    if(GMVariable.EnableUIData)then
        str = str.."：开"
    else
        str = str.."：关"
    end
    self.Text_Data:SetText(str)
end

function WBP_GM_C:Immerse()
    UIUtils.PlayCommonBtnSe(self)
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    if(Player and Player.ImmersionModel)then
        --在player的蓝图中会自动控制沉浸模式的开关
        Player:ImmersionModel()
        local str = "沉浸模式"
        if(Player.IsImmersionModel)then
            str = str.."：开"
            self:Close()
        else
            str = str.."：关"
        end
        self.Text_Immerse:SetText(str)
    end
end

function WBP_GM_C:TabClicked(Item)
    LastGMTabIndex =  self.List_Tab_Top:GetIndexForItem(Item)
    --换tab时搜索
    self:SearchCommandByName(self.Input_GM:GetText(),Item)
    self.List_Tab_Top:NavigateToIndex(LastGMTabIndex)
end

function WBP_GM_C:CloseAllMenus()
    UE4.UWidgetBlueprintLibrary.DismissAllMenus()
    if(IsValid(self.GMPanelObj))then
        local len1 = self.GMPanelObj.Commands:Length()
        for i=1,len1,1 do
            local len2 = self.GMPanelObj.Commands[i].Commands:Length()
            for j=1,len2,1 do
                local len3 = self.GMPanelObj.Commands[i].Commands[j].Commands:Length()
                for k=1,len3,1 do
                    self:CloseAllMenusDfs(self.GMPanelObj.Commands[i].Commands[j].Commands[k])
                end
            end
        end
    end
end

function WBP_GM_C:CloseAllMenusDfs(Command)
    local len = Command.Commands:Length()
    for i=1,len,1 do
        self:CloseAllMenusDfs(Command.Commands[i])
    end
    if(Command.ParentWidget)then
        Command.ParentWidget:Close()
    end
end

function WBP_GM_C:Close()
    UIUtils.PlayCommonBtnSe(self)
    self.Super.Close(self)
    --self:DestroyObject()
end


function WBP_GM_C:Destruct()
    self.Super.Destruct(self)
    self:UnregisterFlow()
end

function WBP_GM_C:GMTabToLeft()
    local CurGMTabIndex = LastGMTabIndex - 1
    if CurGMTabIndex < 0 then
        return
    end
    self.List_Tab_Top:SetSelectedIndex(CurGMTabIndex)
end

function WBP_GM_C:GMTabToRight()
    local CurGMTabIndex = LastGMTabIndex + 1
    if CurGMTabIndex >= GMTabTotalNum then
        return
    end
    self.List_Tab_Top:SetSelectedIndex(CurGMTabIndex)
end

function WBP_GM_C:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    
    if (InKeyName == "Escape") then
        self:Close()
    elseif (InKeyName == "Q") then
        self:GMTabToLeft()
    elseif (InKeyName == "E") then
        self:GMTabToRight()
    end
    for _, Mapping in pairs(self.GMKeys) do
        if (InKeyName == Mapping.Key.KeyName) then
            self:Close()
            break
        end
    end
    return UE4.UWidgetBlueprintLibrary.Handled()
end

return WBP_GM_C
