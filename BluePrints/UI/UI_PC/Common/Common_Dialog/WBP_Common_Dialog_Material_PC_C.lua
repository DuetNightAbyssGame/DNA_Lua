require "UnLua"
local ControllerFSM = require("Blueprints.UI.ControllerFSM")

local ModModel = ModController:GetModel()

---@class Common_Dialog_ItemSubsize:Common_Dialog_ItemSubsize_PC_C
local WBP_Common_Dialog_ItemSubsize_PC_C = Class("BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase")

local FSMState = {
    Normal = 1,     -- 普通状态
    CheckItem = 2,  -- 检查图标
    ShowTip = 3,    -- 显示Tip
}

function WBP_Common_Dialog_ItemSubsize_PC_C:PreInitContent(Params, PopupData, Ownwer)
    self.Super.PreInitContent(self,Params,PopupData,Ownwer)
    self:BindDialogEvent("UpdateItemSubSize", self.UpdateView)
end

function WBP_Common_Dialog_ItemSubsize_PC_C:InitContent(Params, PopupData, Owner)
    self.Super.InitContent(self, Params, PopupData, Owner)
    self:UpdateView(Params)
end

function WBP_Common_Dialog_ItemSubsize_PC_C:InitGamepadView()
    if self.IsShowingTip then
        self.ControllerFSM:Enter(FSMState.ShowTip)
    else
        self.ControllerFSM:Enter(FSMState.Normal)
    end
end

function WBP_Common_Dialog_ItemSubsize_PC_C:InitKeyboardView()
    self.ControllerFSM:Reset()
    self:HideAllGamepadShortcut()
end

---@param Params Common_Dialog_Params
function WBP_Common_Dialog_ItemSubsize_PC_C:UpdateView(Params)
    self.Item:ClearChildren()
    local PadX = Params.ItemPadX and Params.ItemPadX or self.Item.InnerSlotPadding.X
    self.Item:SetInnerSlotPadding(FVector2D(PadX,0))
    if not Params.ItemList then return end

    for _, ResInfo in ipairs(Params.ItemList) do      
        local Icon, Rarity, Num, Need = nil,nil,nil,nil
        local ItemDatas = DataMgr[ResInfo.ItemType]
        if ItemDatas then
            local ItemData = ItemDatas[ResInfo.ItemId]
            if ItemData.Icon then
                Icon = ItemData.Icon
            end
            Rarity = ItemData.Rarity
            Num = ResInfo.ItemNum
            Need = ResInfo.ItemNeed
        end

        if ResInfo.ItemType == "Weapon" then 
            local WeaponData = DataMgr.Weapon[ResInfo.ItemId]  
            Icon = Icon or WeaponData.Icon
            Rarity = WeaponData.WeaponRarity
            Num = ResInfo.ItemNum
        elseif ResInfo.ItemType == "Mod" then 
            local ModData = DataMgr.Mod[ResInfo.ItemId]
            Icon = Icon or ModData.Icon
            Rarity = ModData.Rarity 
            Num = ResInfo.ItemNum
        elseif ResInfo.ItemType == "CharAccessory" then 
            local CharAccessoryData = DataMgr.CharAccessory[ResInfo.ItemId]
            Icon = Icon or CharAccessoryData.Icon
            Num = ResInfo.ItemNum
        elseif ResInfo.ItemType == "Resource" then 
            local ResourceData = DataMgr.Resource[ResInfo.ItemId]
            Icon = Icon or ResourceData.Icon
            Rarity = ResourceData.Rarity
            Num = ResInfo.ItemNum
            Need = ResInfo.ItemNeed
        end

        local Content = {
            Id = ResInfo.ItemId,
            Icon = Icon,
            Count = Num,
            NeedCount = Need,
            ItemType = ResInfo.ItemType,
            Rarity = Rarity,
            IsShowDetails = true,
        }

        -- Mod使用新接口了，做一下替换
        if ResInfo.ItemType == "Mod" then
            local ModContent = ModModel:CreateModContent(ResInfo.ItemInstance, nil ,true)
            Content = ModContent
            Content.StartLevelNum = Content.Level
            Content.ItemType = ModContent.Type
            Content.Level = nil
            Content.IsShowDetails = true
        end

        Content.OnMenuOpenChangedEvents = {Obj = self, Callback = self.OnMenuOpenChange}
        
        if Params.LargeSizeItem then  -- 大尺寸 
            self:ShowLargeItem(Params, Content)
        else 
            self:ShowNormalItem(Params, Content)
        end
    end

    self.ControllerFSM = ControllerFSM.New(self, {
        [FSMState.Normal] = {
            OnEnter = self.OnEnterState_Normal,
        },
        [FSMState.CheckItem] = {
            OnEnter = self.OnEnterState_CheckItem,
        },
        [FSMState.ShowTip] = {
            OnEnter = self.OnEnterState_ShowTip,
        },
    })

    local CurInputDeviceType = UIUtils.UtilsGetCurrentInputType()
    if CurInputDeviceType == UE4.ECommonInputType.Gamepad then 
        self.ControllerFSM:Enter(FSMState.Normal)
    end
end

function WBP_Common_Dialog_ItemSubsize_PC_C:ShowModItem(Content)
    local ResWidget = UIManager():CreateWidget('/Game/UI/WBP/Armory/Widget/Unit/WBP_Armory_Item_L_Mod.WBP_Armory_Item_L_Mod')
    self.Item:AddChild(ResWidget)
    ResWidget:OnListItemObjectSet(Content)
end

function WBP_Common_Dialog_ItemSubsize_PC_C:ShowLargeItem(Params, Content)
    local ResWidget = self:CreateWidgetNew("ComItemUniversalL")
    self.Item:AddChild(ResWidget)
    ResWidget:OnListItemObjectSet(Content)
end

function WBP_Common_Dialog_ItemSubsize_PC_C:ShowNormalItem(Params, Content)
    local ResWidget = self:CreateWidgetNew("ComItemUniversalM")
    self.Item:AddChild(ResWidget)
    ResWidget:Init(Content)        
end

function WBP_Common_Dialog_ItemSubsize_PC_C:SetText(Text)
    self.Text_Details:SetText(Text)
end

function WBP_Common_Dialog_ItemSubsize_PC_C:OnEnterState_ShowTip()
    self:HideAllGamepadShortcut()
end

function WBP_Common_Dialog_ItemSubsize_PC_C:OnEnterState_CheckItem()
    self:HideGamepadShortcut(self.GamepadCheckItemKeyInfo)
    self.GamepadBackKeyInfo = self:ShowGamepadShortcutBtn({
        KeyInfoList = {
        {
            Type = "Img",
            ImgShortPath = UIConst.GamePadImgKey.FaceButtonRight
        }},
        Desc = GText("UI_BACK")
    })
    

    self.GamepadCheckDetailsKeyInfo = self:ShowGamepadShortcutBtn({        
        KeyInfoList = {
        {
            Type = "Img",
            ImgShortPath = UIConst.GamePadImgKey.FaceButtonBottom
        }},
        Desc = GText("UI_Controller_CheckDetails")
    })

    self:SetGamepadBtnKeyVisibility(false)
end

function WBP_Common_Dialog_ItemSubsize_PC_C:OnEnterState_Normal()
    -- 初始阶段显示手柄查看物品提示
    self:HideGamepadShortcut(self.GamepadBackKeyInfo)
    self:HideGamepadShortcut(self.GamepadCheckDetailsKeyInfo)
    self.GamepadCheckItemKeyInfo = self:ShowGamepadShortcutBtn({        
        KeyInfoList = {
        {
            Type = "Img",
            ImgShortPath = UIConst.GamePadImgKey.LeftThumb
        }},
        Desc = GText("UI_Controller_CheckItems")
    })
    self.Owner:SetFocus()
    self:SetGamepadBtnKeyVisibility(true)
end

function WBP_Common_Dialog_ItemSubsize_PC_C:OnContentKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false

    if InKeyName == Const.GamepadLeftThumbstick then 
        if self.ControllerFSM:Current() == FSMState.Normal then 
            self.ControllerFSM:Enter(FSMState.CheckItem)
            self.Item:SetFocus()
        end
        IsEventHandled = true
    elseif InKeyName == Const.GamepadFaceButtonRight then 
        if self.ControllerFSM:Current() == FSMState.CheckItem then 
            self.ControllerFSM:Enter(FSMState.Normal)
            IsEventHandled = true
        end
    elseif InKeyName == Const.GamepadFaceButtonBottom then 
        if self.ControllerFSM:Current() == FSMState.CheckItem then 
            self.ControllerFSM:Enter(FSMState.ShowTip)
        end
    end

    return IsEventHandled
end

function WBP_Common_Dialog_ItemSubsize_PC_C:OnMenuOpenChange(IsOpen)
    if UIUtils.IsGamepadInput() then
        if IsOpen then 
            self.ControllerFSM:Enter(FSMState.ShowTip)
        else 
            self.ControllerFSM:Enter(FSMState.CheckItem)
        end
    end

    self.IsShowingTip = IsOpen
end


return WBP_Common_Dialog_ItemSubsize_PC_C