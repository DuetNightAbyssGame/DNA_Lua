--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"
local GMFunctionLibrary = require "BluePrints.UI.GMInterface.GMFunctionLibrary"
local WBP_GM_Tips_MultiInput_C = Class("BluePrints.UI.GMInterface.WBP_GM_Menu_Base_C")

function WBP_GM_Tips_MultiInput_C:InitMenu(Command)
    self.Super.InitMenu(self,Command)
    self.List:ClearListItems()
    local Commands = Command.Commands
    local Length = Commands:Length() - 1
    if(Length >= 0)then
        for i=1,Length,1 do
            if(Commands[i].Mode == "edit")then
                if(Commands[i].Parameters:Length() == 0)then
                    Commands[i].Parameters:Add("")
                end
            end
            Commands[i].ParentWidget = self
            self.List:AddItem(Commands[i])
        end
        Commands[Length + 1].ParentWidget = self
        if(self.Text_Exec)then
            self.Text_Exec:SetText(Commands[Length + 1].Text)
        end
    end
end

function WBP_GM_Tips_MultiInput_C:ExecCommand()
    local Commands = self.Command.Commands
    local Length = Commands:Length()
    Commands[Length].Parameters:Clear()
    for i=1,Length,1 do
        if(Commands[i].Mode == "edit")then
            Commands[Length].Parameters:Add(Commands[i].Parameters[1])
        end
    end
    GMFunctionLibrary.Exec(self,Commands[Length])
end

return WBP_GM_Tips_MultiInput_C
