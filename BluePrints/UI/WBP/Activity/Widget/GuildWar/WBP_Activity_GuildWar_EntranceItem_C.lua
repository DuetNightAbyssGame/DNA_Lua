require "UnLua"

local M = Class("BluePrints.UI.BP_EMUserWidget_C")
M._components = {"BluePrints.UI.BP_EMUserWidgetUtils_C"}

function M:Construct()
    self.Btn_Click.OnClicked:Add(self, self.OnButonClicked)
    self.Btn_Click.OnPressed:Add(self, self.OnButonPressed)
    self.Btn_Click.OnHovered:Add(self, self.OnButonHovered)
    self.Btn_Click.OnUnhovered:Add(self, self.OnButonUnhovered)
end

function M:Destruct()
    self.Btn_Click.OnClicked:Remove(self, self.OnButonClicked)
    self.Btn_Click.OnPressed:Remove(self, self.OnButonPressed)
    self.Btn_Click.OnHovered:Remove(self, self.OnButonHovered)
    self.Btn_Click.OnUnhovered:Remove(self, self.OnButonUnhovered)
end

function M:Init(CallBackObj, CallBack, Text, GamepadKey)
    self.CallBackObj = CallBackObj
    self.CallBack = CallBack
    if Text then
        self.Text_Name:SetText(GText(Text))
    end
    if GamepadKey then
        self:SetGamepadKey(GamepadKey)
    end
end


function M:OnButonClicked()
    if not self.Forbbiden then
        self:PlayAnimation(self.Click)
    end

    if (self.CallBackObj and self.CallBack) then
        local RootWidget = self.CallBackObj.RootWidget
        if (RootWidget and type(RootWidget.CheckIsInCloseSelfState) == "function") then
            if (RootWidget:CheckIsInCloseSelfState()) then
                DebugPrint("GuildWar_EntranceItem OnButonClicked, RootWidget is in close self state, So return")
                return
            end
        end
        AudioManager(self):PlayUISound(self, "event:/ui/activity/gerengonghuizhan_small_btn_click","",nil)
        self.CallBack(self.CallBackObj)
    end
end

function M:OnButonPressed()
    if not self.Forbbiden then
        self:PlayAnimation(self.Press)
    end
end


function M:OnButonHovered()
    if not self.Forbbiden then
        self:PlayAnimation(self.Hover)
    end
end

function M:OnButonUnhovered()
    if not self.Forbbiden then
        self:PlayAnimation(self.UnHover)
    end
end

function M:SetCoinQuantity(Quantity)
    if type(Quantity) ~= "number" then
        return
    end
    self.Text_Coin:SetText(Quantity)
end

function M:SetCoinIconByShop(CoinId)
    local CoinData = DataMgr.Resource[CoinId]
    if not CoinData or not CoinData.Icon then
        return
    end
    local Texture = LoadObject(CoinData.Icon)
    if Texture then
        self.Icon_Coin:SetBrushResourceObject(Texture)
    end
end

function M:SetForbiddenState(Forbidden)
    -- self.Btn_Click:SetForbidden(Forbidden)
    self.Forbbiden = Forbidden
    if Forbidden then
        self:PlayAnimation(self.Forbidden)
    else
        self:PlayAnimation(self.Normal)
    end
end

function M:SetTimeText(EndTime)
    if not EndTime then
        return
    end
    local RemainTimeDict, _ = UIUtils.GetLeftTimeStrStyle2(EndTime)

    local _SetTimeText = function()
         self.Time:SetTimeText(GText("UI_Disptach_RemainTime"), RemainTimeDict)
    end
    _SetTimeText()
    -- 一分钟更新一下时间
    self:AddTimer(60.0, _SetTimeText, true, 0, "GuildWarShopRemainTime", true)
end

function M:SetGamepadKey(KeyName)
    self.Key_Controller:CreateCommonKey({KeyInfoList={{ Type = "Img", ImgShortPath = KeyName}}})
end

function M:SetGamepadVisibility(Visibility)
    self.Key_Controller:SetVisibility(UIConst.VisibilityOp[Visibility])
end

function M:SetReddotVisibility(Visibility)
    self.Reddot:SetVisibility(UIConst.VisibilityOp[Visibility])
end

AssembleComponents(M)

return M