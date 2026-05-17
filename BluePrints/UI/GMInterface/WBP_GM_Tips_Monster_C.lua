--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"
local GMFunctionLibrary = require "BluePrints.UI.GMInterface.GMFunctionLibrary"
local GMObjectUtils = require "BluePrints.UI.GMInterface.GMObjectUtils"
local WBP_GM_Tips_Monster_C = Class("BluePrints.UI.GMInterface.WBP_GM_Menu_Base_C")

function WBP_GM_Tips_Monster_C:OnLoaded(Command)
    self.Super.OnLoaded(self,Command)
    self:InitMenu(Command)
end

function WBP_GM_Tips_Monster_C:InitMenu(Command)
    self.Super.InitMenu(self,Command)
    self.List:ClearListItems()
    Command.Commands:Clear()
    local Objs = GMObjectUtils.GetMonsterCmdObjs()
    for _,obj in ipairs(Objs) do
        obj.ParentWidget = self
        Command.Commands:Add(obj)
        self.List:AddItem(obj)
    end
    self:ChangeCMCommand(self.CheckBox_CTM:IsChecked())
    self.Input_Search:SetHintText("请输入怪物ID或名称")
    self:ChangeTotalMonsterNum()
end

--遍历List中的所有怪物，计算总数量, 输入是否成功改变总数
function WBP_GM_Tips_Monster_C:ChangeTotalMonsterNum()
    local sum = 0
    local monster_cmds = self.List:GetListItems()
    local len = self.List:GetNumItems()
    for i=1,len,1  do
        local num = tonumber(monster_cmds[i].Parameters[2])
        if(num)then
            if(num <= 0)then
                UIManager(self):ShowUITip("CommonToastMain", "1 ≤ 怪物数量 ≤ " .. self.MaxMonsterNum .. " ！",1.0)
                return false
            end
            sum =  sum + num
            if(sum > self.MaxMonsterNum)then
                UIManager(self):ShowUITip("CommonToastMain", "不建议同时生成" .. self.MaxMonsterNum .. "个怪！",1.0)
                return false
            end
        end
    end
    self.Denominator = sum
    self.Text_Numerator:SetText(self.Denominator)
    return true
end

function WBP_GM_Tips_Monster_C:CreateMonsters()
    if(self.Denominator <= 0 or self.Denominator > 20)then
        UIManager(self):ShowUITip("CommonToastMain", "不建议同时生成" .. self.MaxMonsterNum .. "个怪！",1.0)
        return
    end
    local monster_cmds = self.List:GetListItems()
    local len = self.List:GetNumItems()
    for i=1,len,1  do
        if(tonumber(monster_cmds[i].Parameters[2]))then
            GMFunctionLibrary.Exec(self,monster_cmds[i])
        end
    end
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManager = GameInstance:GetGameUIManager()
    local GMPanel =  UIManager:GetUIObj("GMCommandpanel")
    GMPanel:CloseAllMenus()
    GMPanel:Close()
end

function WBP_GM_Tips_Monster_C:SearchCommandByText(text)
    if(not text or not self.Command.Commands or not self.List)then
        return
    end
    local entryArr = self.List:GetDisplayedEntryWidgets()
    for i=1,entryArr:Length(),1 do
        entryArr[i].EditText_Para:SetText("")
    end
    local commands = self.Command.Commands
    self.List:ClearListItems()
    local len = self.Command.Commands:Length()
    for i=1,len,1 do
        if commands[i].Text ~= nil and string.find(commands[i].Text,text) ~= nil then
            commands[i].Parameters[2] = ""
            self.List:AddItem(commands[i])
        end
    end
    self:ChangeTotalMonsterNum()
end

function WBP_GM_Tips_Monster_C:ChangeCMCommand(IsCTM)
    local monster_cmds = self.List:GetListItems()
    local len = self.List:GetNumItems()
    if(IsCTM)then
        for i=1,len,1  do
            monster_cmds[i].Parameters[3] = "CTM"
        end
    else
        for i=1,len,1  do
            monster_cmds[i].Parameters[3] = "CM"
        end
    end
end

return WBP_GM_Tips_Monster_C
