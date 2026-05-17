require "UnLua"

---@class CommonKeyData  
---@field KeyText string Key对应文本
---@field DescText string Desc对应文本
---@field bLongPress boolean 是否长按激活
---@field CallbackObj any 回调触发的对象
---@field CallbackFunc function 回调触发的函数

---@type WBP_Com_KeyDescList_C
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

---@param CommonKeyDatas CommonKeyData[] 通用按键数据
function M:InitKey(CommonKeyDatas)
    self.List_KeyDesc:ClearListItems()
    if not CommonKeyDatas then return end
    
    self.List_KeyDesc:SetVisibility(UE4.ESlateVisibility.Visible)
    self.CommonKeyDatas = CommonKeyDatas
    for Index, Data in ipairs(CommonKeyDatas) do 
        local RightKeyTextDescData = NewObject(UE4.LoadClass(UIConst.DUNGEONCOMRIGHTKEYTEXTDESCDATA))
        RightKeyTextDescData.Owner = self
        RightKeyTextDescData.Index = Index
        self.List_KeyDesc:AddItem(RightKeyTextDescData)
    end
end

function M:InitCommonKey(CommonKey, Index)
    local CommonKeyData = self.CommonKeyDatas[Index]
    if not CommonKeyData then return end
    local IsAddType = false -- 是否为组合键形式
    local KeyInfoList = {}
    if CommonKeyData.ImgShortPath and #CommonKeyData.ImgShortPath > 1 then 
        for i, v in ipairs(CommonKeyData.ImgShortPath) do 
            table.insert(KeyInfoList, {
                Type = "Img",
                ImgShortPath = v
            })
        end
        IsAddType = true
    elseif CommonKeyData.ImgShortPath and #CommonKeyData.ImgShortPath == 1 then 
        KeyInfoList = {{
            Type = CommonKeyData.Type,
            Text = CommonKeyData.Text,
            ImgShortPath = CommonKeyData.ImgShortPath[1],
        }}
    else 
        KeyInfoList = {{
            Type = CommonKeyData.Type,
            Text = CommonKeyData.Text,
        }}
    end

    local KeyData = {
        KeyInfoList = KeyInfoList,
        bLongPress = CommonKeyData.bLongPress,
        Desc = CommonKeyData.DescText,
    }
    if IsAddType then 
        KeyData.Type = "Add" 
        CommonKey:CreateSubKeyDesc(KeyData)
    else
        CommonKey:CreateCommonKey(KeyData)
    end 
    if CommonKeyData.GamemodeType and CommonKeyData.GamemodeType == "Temple" then
        CommonKey:ShowBanImg()
        CommonKey:DisableKey()
        if CommonKeyData.UIModePlatform == "Mobile" then
            CommonKey:MobileBanTextImg()
        end
    else
        CommonKey:AddExecuteLogic(CommonKeyData.CallbackObj, CommonKeyData.CallbackFunc)
    end
end

-- function M:InitCommonKey(CommonKey, Index)
--     local GameMode = UE4.UGameplayStatics.GetGameMode(self)
--     local GameState = UE4.UGameplayStatics.GetGameState(self)
--     if GameMode ~= nil and GameState ~= nil and GameState.GameModeType == "Training" then
--         local DescTest = ""
--         if Index == 1 then
--             DescTest = "F4"
--         elseif Index == 2 then
--             DescTest = "F1"
--         elseif Index == 3 then
--             DescTest = "F5"
--         end
--         CommonKey:CreateCommonKey({
--             KeyInfoList={{
--                              Type = "Text",
--                              Text = DescTest,
--                          }},
--             bLongPress = false,
--             Desc = GText("UI_DUNGEON_DES_TRAINING_"..Index)
--         })
--         CommonKey:AddExecuteLogic(self, function() self:OnTrainingRightKeyClicked(Index) end)
--     end
--     if GameMode ~= nil and GameState ~= nil and GameState.GameModeType == "Temple" then
--         CommonKey:CreateCommonKey({
--             KeyInfoList={{
--                              Type = self.ForbidInfo[Index][2],
--                              Text = self.ForbidInfo[Index][3],
--                              ImgShortPath = self.ForbidInfo[Index][3],
--                          }},
--             bLongPress = false,
--             Desc = GText(self.ForbidInfo[Index][1])
--         })
--         CommonKey:ShowBanImg()
--         CommonKey:DisableKey()
--         local Player = UE4.UGameplayStatics.GetPlayerCharacter(self,0)
--         if Player.UIModePlatform == "Mobile" then
--             CommonKey:MobileBanTextImg()
--         end
--     end
-- end

return M
