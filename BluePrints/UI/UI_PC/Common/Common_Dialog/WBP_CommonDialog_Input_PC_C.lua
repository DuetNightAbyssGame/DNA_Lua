--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

---@type Common_Dialog_Input_PC_C
---@field private Common_EditText Common_EditTextWithRichText_C
local Component = {}
local HeroUSDKUtils = require "Utils.HeroUSDKUtils"
local PlayerNameUtils = require "Utils.PlayerNameUtils"
function Component:Initialize(Initializer)
    self.Super.Initialize(self)
end

function Component:Construct(...)

    -- self.Text_Input.OnTextChanged:Add(self, self.OnNameChanged)
    -- self.Text_Show:SetText("")
    self.SpaceIndex = {}
end

function Component:GetCDKRewards(Items)
    local Rewards = {}
    for key,value in pairs(Items) do
        if Rewards[value.ItemType..'s'] then
            if Rewards[value.ItemType..'s'][value.ItemID] then
                Rewards[value.ItemType..'s'][value.ItemID] = Rewards[value.ItemType..'s'][value.ItemID] + value.ItemNum
            else
                Rewards[value.ItemType..'s'][value.ItemID] = value.ItemNum
            end
        else
            Rewards[value.ItemType..'s'] = {}
            Rewards[value.ItemType..'s'][value.ItemID] = value.ItemNum
        end
    end
    return Rewards
end

function Component:OnClickExchangeCode()
    local CDK = self.Text_Input:GetText()
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        Avatar:UseCDK(CDK,function(Ret,Items)
            if Ret == ErrorCode.RET_SUCCESS then
                self.Owner:OnClose()
                local Rewards = self:GetCDKRewards(Items or {})
                UIManager(self):LoadUINew("GetItemPage",  nil,nil,nil,Rewards)
            elseif Ret == ErrorCode.RET_CDK_CODE_INVALID then
                self:ShowTips(GText("UI_Exchange_Incorrect"),self.RedTip)
                AudioManager(self):PlayUISound(self, "event:/ui/common/input_err", "", nil)
                return
            elseif Ret == ErrorCode.RET_CDK_CHANNEL_CHECK_FAILED then
                self:ShowTips(GText("UI_Exchange_WrongChannel"),self.RedTip)
                AudioManager(self):PlayUISound(self, "event:/ui/common/input_err", "", nil)
                return
            elseif Ret == ErrorCode.RET_CDK_USED_BY_MINE then --您已使用过该兑换码
                self:ShowTips(GText("UI_Exchange_Used_Self"),self.RedTip)
                AudioManager(self):PlayUISound(self, "event:/ui/common/input_err", "", nil)
                return
            elseif Ret == ErrorCode.RET_CDK_USE_LIMIT then  --您已达到此类兑换码的可使用次数上限
                self:ShowTips(GText("UI_Exchange_Max"),self.RedTip)
                AudioManager(self):PlayUISound(self, "event:/ui/common/input_err", "", nil)
                return
            elseif Ret == ErrorCode.RET_CDK_USED_BY_OTHER then --该兑换码已被使用
                self:ShowTips(GText("UI_Exchange_Used_Other"),self.RedTip)
                AudioManager(self):PlayUISound(self, "event:/ui/common/input_err", "", nil)
                return
            else
                self:ShowTips(GText("UI_Exchange_Invalidity"),self.RedTip)
                AudioManager(self):PlayUISound(self, "event:/ui/common/input_err", "", nil)
                return
            end
        end)
    end
end

function Component:OnClickButtonContinue()
    local Nickname = self.Text_Input:GetText()
    if self.IsChangeName and PlayerNameUtils.CheckIsAllSpace(Nickname) then
        -- local Params={}
        -- Params.ForbidRightBtn=true
        -- Params.UseOldContent=true
        -- Params.ReturnToCommon=true
        -- Params.DialogItemIndex=self.YellowTip
        -- Params.Tips={}
        -- Params.Tips[self.YellowTip]=GText("UI_REGISTER_EMPTY")
        -- self:RealRefresh(Params)
        self:ShowTips(GText("UI_REGISTER_EMPTY"),self.YellowTip)
        self.Owner.DontCloseWhenRightBtnClicked=true
        return
    end
    HeroUSDKUtils.CheckStringSensitive(self, Nickname, self.OnNameSensitive, self.OnNameNotSensitive)
end

function  Component:OnNameSensitive(ReplaceName, Name, Words)
    -- local Params={}
    -- Params.HasSensitive=true
    -- Params.UseOldContent=true
    -- Params.Tips={}
    -- Params.Tips[self.RedTip]=GText("UI_REGISTER_BANNEDINPUT")
    AudioManager(self):PlayUISound(self, "event:/ui/common/input_err", nil, nil)
    -- self:Refresh(Params)
    self:ShowTips(GText("UI_REGISTER_BANNEDINPUT"),self.RedTip)
    self.Owner.DontCloseWhenRightBtnClicked=true
end

function Component:OnNameNotSensitive(Name)
    local NameLength, RealName, IllegalRange, ErrorType = PlayerNameUtils.CheckNameLegal(Name,self.MaxNum)
    -- print(_G.LogTag,"LXZ OnNameNotSensitive", NameLength, RealName, IllegalRange, ErrorType)
    -- if ErrorType == -2 then
    --     RealName = PlayerNameUtils.HighLightIllegal(RealName, IllegalRange)
    --     --self.Text_Rename:SetText(RealName)
    --     local Params={}
    --     Params.HasInvalid=true
    --     Params.UseOldContent=true
    --     self.Common_EditText:SetRichText(RealName)
    --     self:Refresh(Params)
    --     return
    -- elseif NameLength > self.MaxNum then
    --     self.Common_EditText:SetEditText(RealName)
    --     self.Content_Now:SetColorAndOpacity(UE4.UUIFunctionLibrary.StringToSlateColor("DD1C45CC"))
    --     local Params={}
    --     Params.ExceedLength=true
    --     Params.UseOldContent=true
    --     self:Refresh(Params)
    --     return
    -- end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    UIManager(self):ShowUITip("CommonToastMain", GText("UI_Change_Success"))
    local MenuWorld=UIManager(self):GetUIObj(UIConst.MenuWorld)
    RealName=PlayerNameUtils.DeleteHeadAndTailSpace(RealName)
    if  self.IsChangeName then
         Avatar:SetAvatarNickname(RealName,function() MenuWorld:SetPlayerInfo() end)
    else
        Avatar:SetAvatarSignature(RealName,function() MenuWorld:SetPlayerInfo() end)
    end
    if self.OnNotSensitiveCallbackFunction then
        self.OnNotSensitiveCallbackFunction(self, RealName)
    end
    self.Owner:OnClose()
end

function Component:OnNameChanged(NewName)
    -- if self.IsChangeName then
    -- if not  self.IsChangeName then
    --     local EnterNum = 0
    --     NewName, EnterNum = string.gsub(NewName, "\r\n", "")
    --     if EnterNum>0 then
    --         self.Common_EditText:SetEditText(NewName)
    --         return NewName
    --     end
    -- else
    --     local SpaceNum
    --     NewName, SpaceNum = string.gsub(NewName, "%s%s+", " ")
    --     if SpaceNum > 0 then
    --         self.Common_EditText:SetEditText(NewName)
    --         return NewName
    --     end
    -- end
    if NewName == "" then
        --self.Common_EditText:SetTextCount(0)
        --self.Common_EditText:SetRichText(NewName)
        self.IsEmpty=true
        self.Owner:GetButtonBar().Btn_Yes:ForbidBtn(true)
        -- if self.PreInputInvalid then
        --     local Params={}
        --     if self.IsChangeName then
        --         Params.Tips={}
        --         Params.Tips[self.BlackTip]=string.format(GText("UI_COMMONPOP_TEXT_100054_2"),DataMgr.GlobalConstant.PlayerNicknameCD.ConstantValue)
        --         self.Owner:HideDialogTip(self.YellowTip,true)
        --         self:BroadcastDialogEvent("UpdateDialogTipText",Params)
        --         self.Owner:ShowDialogTip(self.BlackTip,false)
        --     else
        --          self.Owner:HideDialogTip(self.YellowTip,true)
        --     end
        -- end
        self.PreInputInvalid=false
        return ""
    end
    -- --Length为为-2：含有不合法字符
    -- local NameLength, RealName, IllegalRange, ErrorType =PlayerNameUtils.CheckNameLegal(NewName,self.MaxNum)
    -- self.Common_EditText:SetTextCount(NameLength)
    -- if self.IsChangeName then
    --     RealName = string.gsub(RealName, "%s%s+", " ")
    -- end
    -- if ErrorType == -2 then
    --     RealName = PlayerNameUtils.HighLightIllegal(RealName, IllegalRange)
    --     self.Common_EditText:SetRichText(RealName)
    --     if not self.PreInputInvalid then
    --         local Params={}
    --         Params.Tips={}
    --         Params.Tips[self.RedTip]= GText("UI_REGISTER_ILLEGALINPUT")
    --         Params.HasInvalid=true
    --         Params.UseOldContent=true
    --         Params.ForbidRightBtn=true
    --         AudioManager(self):PlayUISound(self, "event:/ui/common/input_err", nil, nil)
    --         self:Refresh(Params)
    --     end
    --     self.NowInputInvalid=true
    --     --self.Owner:GetButtonBar().Btn_Yes:ForbidBtn(true)
    -- else
    --     self.NowInputInvalid=false
    -- end
    -- if NameLength >= self.MaxNum+1 then
    --     local Params={}
    --     Params.ExceedLength=true
    --     self.Common_EditText:SetEditText(RealName)
    --     self.Common_EditText:SetTextCount(self.MaxNum)
    --     Params.UseOldContent=true
    --     self:Refresh(Params)
    -- else
    --     self.Common_EditText:SetRichText(RealName)
    --     self.Common_EditText:SetTextCount(NameLength)
    -- end
    -- if self.PreInputInvalid and not self.NowInputInvalid then
    --     local Params={}
    --         if self.IsChangeName then
    --             Params.Tips={}
    --             Params.Tips[self.BlackTip]=string.format(GText("UI_COMMONPOP_TEXT_100054_2"),DataMgr.GlobalConstant.PlayerNicknameCD.ConstantValue)
    --             self.Owner:HideDialogTip(self.YellowTip,true)
    --             self:BroadcastDialogEvent("UpdateDialogTipText",Params)
    --             self.Owner:ShowDialogTip(self.BlackTip,false)
    --         else
    --              self.Owner:HideDialogTip(self.YellowTip,true)
    --         end
    -- end
    if not self.NowInputInvalid and UE4.UKismetSystemLibrary.IsValid(self.Owner) then
        if self.Owner and self.Owner:GetButtonBar().Btn_Yes then
            self.Owner:GetButtonBar().Btn_Yes:ForbidBtn(false)
        end
    end
        self.PreInputInvalid=self.NowInputInvalid
    return NewName
end


function Component:OnCodeChanged(NewCode)
    if NewCode == "" then
        self.Common_EditText:SetTextCount(0)
        self.Common_EditText:SetRichText(NewCode)
        --self.Text_Show:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.IsEmpty = true
        self.Owner:GetButtonBar().Btn_Yes:ForbidBtn(true)
        return ""
    end
    --self.Text_Show:SetVisibility(UE4.ESlateVisibility.Collapsed)
    if UE4.UKismetSystemLibrary.IsValid(self.Owner) then
        if self.Owner and self.Owner:GetButtonBar().Btn_Yes then
            self.Owner:GetButtonBar().Btn_Yes:ForbidBtn(false)
        end
    end
end

function Component:Tick(MyGeometry, InDeltaTime)
    local CurrentFocus = self.Text_Input:HasAnyUserFocus()
    if CurrentFocus == self.TextFocus then
        return
    end
    self.TextFocus = CurrentFocus
    if self.TextFocus then
        self.Common_EditText:SetHintText("")
    else
        -- if self.IsChangeName then
        --     self.Text_Input:SetHintText(GText("UI_REGISTER_NAME"))
        -- else
        --     self.Text_Input:SetHintText(GText("请输入签名"))
        -- end
    end
end

-- function Component:ContainsCJK(CharByte1, CharByte2, CharByte3, Range)
--     local ByteNum = CharByte1*16^4 + CharByte2*16^2 + CharByte3
--     -- print(_G.LogTag,"LXZ ContainsCJK", ByteNum, CharByte1, CharByte2, CharByte3, Range[1], Range[2])
--     -- 检查字符是否在范围内
--     if ByteNum >= Range[1] and ByteNum <= Range[2] then
--         return true
--     end

--     return false
-- end

-- function Component:GetWordLength(WordFirstByte)
--     if WordFirstByte >= 240 then
--         return 4
--     elseif WordFirstByte >= 224 then
--         return 3
--     elseif WordFirstByte >= 192 then
--         return 2
--     else
--         return 1
--     end
--     return 0
-- end

function Component:InitContent(Params, PopupData, Owner)
    self.Super.InitContent(self, Params, PopupData, Owner)
    -- if(Params.EditTextConfig)then
    --     Params.OwnerDialog = Owner
    --     if(Params.IsMultiLine)then
    --         self.WS_Input:SetActiveWidgetIndex(0)
    --         self.CurrentInputWidget = self.Input_Multiline
    --         self.Input_Multiline:Init(Params.EditTextConfig,Params)
    --     else
    --         self.WS_Input:SetActiveWidgetIndex(1)
    --         self.CurrentInputWidget = self.Input
    --         self.Input:Init(Params.EditTextConfig,Params)
    --     end
    -- end

    --初始化通用输入框
    Params.EditTextConfig=Params.EditTextConfig or{}
    if Params.ChangeName then
        Params.EditTextConfig.bLimitSpaces=true
    end
    Params.OwnerDialog=Owner
    Params.EditTextConfig.Owner=self
    Params.EditTextConfig.Events={
       OnTextChanged = self.OnNameChanged,
    }
    if(not Params.ChangeName) and (not Params.IsExchangeCode) then
        Params.EditTextConfig.bLimitBr=true
       self.WS_Input:SetActiveWidgetIndex(0)
       self.CurrentInputWidget = self.Input_Multiline
       self.Input_Multiline:Init(Params.EditTextConfig,Params)
   else
       self.WS_Input:SetActiveWidgetIndex(1)
       self.CurrentInputWidget = self.Input
       self.Input:Init(Params.EditTextConfig,Params)
   end
    self.BlackTip=3
    self.YellowTip=2
    self.RedTip=1
    if not Params.FirstInit then
        return
    end
    self.IsChangeName = Params.ChangeName
    if self.IsChangeName then
        self:SetResidentTips(string.format(GText("UI_COMMONPOP_TEXT_100054_2"),DataMgr.GlobalConstant.PlayerNicknameCD.ConstantValue))
    end
    self.IsExchangeCode = Params.IsExchangeCode --是否是CDK兑换码
    local Index = self.IsChangeName and 1 or 0
    if Params.IsExchangeCode then
        Index = 1
    end
    --self.Switcher_Input:SetActiveWidgetIndex(Index)
    ---@type Common_EditTextWithRichText_C
    --self.Common_EditText = self["Common_EditTextWithRichText_"..Index]
    self.Common_EditText=self.CurrentInputWidget
    self.Text_Input=self.Common_EditText
    --self.Text_Show=self.Common_EditText.Text_Show_Input
    --self.Content_Now=self.Common_EditText.NowCount
    self.Limit_Count = self.Common_EditText.LimitCount
    -- if Params.HideLimit then
    --     self.Common_EditText.LimitText:SetVisibility(UE4.ESlateVisibility.Collapsed)
    -- else
    --     self.Common_EditText.LimitText:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    -- end
    if Params.ChangeName then
        --self.Common_EditText:SetAutoWrap(false)
        self.MaxNum=DataMgr.GlobalConstant.NicknameMaxLen.ConstantValue
        self.Common_EditText:SetHintText(GText("UI_COMMONPOP_TEXT_100054_1"))
    elseif Params.IsExchangeCode then
        --self.Common_EditText:SetAutoWrap(false)
        self.Common_EditText:SetHintText(GText("UI_Exchange_Input"))
    else
        -- body
        --self.Common_EditText:SetAutoWrap(true)
        self.MaxNum=DataMgr.GlobalConstant.SignatureMaxLen.ConstantValue
        self.Common_EditText:SetHintText(GText("UI_COMMONPOP_TEXT_100055"))
    end
    if Params.IsExchangeCode then
        self.Common_EditText:SetTextLimit(CommonConst.MailMaxDueTime)
        -- self.Common_EditText:SetOnTextChanged(function(InText)
        --     return self:OnCodeChanged(InText)
        -- end)
        -- self.Common_EditText:SetEditText("")
    else
        self.Common_EditText:SetTextLimit(self.MaxNum)
        -- self.Common_EditText:SetOnTextChanged(function(InText)
        --     return self:OnNameChanged(InText)
        -- end)
        -- self.Common_EditText:SetOnTextComposing(function(InText)
        --     self.Common_EditText:SetRichText("")
        -- end)
        -- self.Common_EditText:SetEditText("")
    end
    if not self.IsChangeName then
        if Params.Signature then
            self.Common_EditText:SetText(Params.Signature)
        end
    end
    if self.IsExchangeCode then
        self:BindDialogEvent(DialogEvent.OnRightBtnClicked, function ()
            self.Owner.DontCloseWhenRightBtnClicked=true
            if not self.Owner:GetButtonBar().Btn_Yes.IsForbidden then
                self:OnClickExchangeCode()
            end
        end)
    else
        self:BindDialogEvent(DialogEvent.OnRightBtnClicked, function ()
            self.Owner.DontCloseWhenRightBtnClicked=true
            if not self.Owner:GetButtonBar().Btn_Yes.IsForbidden then
                self:OnClickButtonContinue()
            end
        end)
    end
     self.Owner.DontCloseWhenRightBtnClicked=true
     self.Text_Input.ClearKeyboardFocusOnCommit=true
     --self.Text_Show:SetVisibility(UE4.ESlateVisibility.Collapsed)
     self.OnNotSensitiveCallbackFunction = Params.OnNotSensitiveCallbackFunction
end

-- function Component:Refresh(Params)
--     local NewParams = {}
--     NewParams.UseOldContent=Params.UseOldContent
--     NewParams.ForbidRightBtn=Params.ForbidRightBtn
--     if Params.Tips then
--         NewParams.Tips=Params.Tips
--     end
--     if Params.ExceedLength then
--         AudioManager(self):PlayUISound(self, "event:/ui/common/err_action_warning", nil, nil)
--         NewParams.ReturnToCommon=true
--         NewParams.DialogItemIndex=self.YellowTip
--         NewParams.Tips={}
--         NewParams.Tips[NewParams.DialogItemIndex]= GText("UI_REGISTER_OVERLENGTH")
--         NewParams.ForbidRightBtn=false
--         self:RealRefresh(NewParams)
--     end
--     if Params.HasInvalid then
--         AudioManager(self):PlayUISound(self, "event:/ui/common/err_action_warning", nil, nil)
--         NewParams.DialogItemIndex=self.YellowTip
--         NewParams.Tips={}
--         NewParams.Tips[NewParams.DialogItemIndex]= GText("UI_REGISTER_ILLEGALINPUT")
--         NewParams.ForbidRightBtn=true
--         self:RealRefresh(NewParams)
--     end
--     if Params.HasSensitive then
--         NewParams.ReturnToCommon=true
--         AudioManager(self):PlayUISound(self, "event:/ui/common/input_err", nil, nil)
--         NewParams.DialogItemIndex=self.RedTip
--         NewParams.Tips={}
--         NewParams.Tips[NewParams.DialogItemIndex]= GText("UI_REGISTER_BANNEDINPUT")
--         NewParams.ForbidRightBtn=true
--         self:RealRefresh(NewParams)
--     end
-- end

-- function Component:RealRefresh(Params)
--     Params.DontCloseWhenRightBtnClicked=true
--     if Params.ForbidRightBtn then
--         self.Owner:GetButtonBar().Btn_Yes:ForbidBtn(true)
--     end
--     if Params.ReturnToCommon then
--         if self.NormalTimerKey and self:IsExistTimer(self.NormalTimerKey) then
--             return
--             -- self:RemoveTimer(self.NormalTimerKey)
--             -- self.NormalTimerKey = nil
--         end
--         local _,NormalTimerKey=self:AddTimer(1.5,function()
--             local NewParams = {}
--             if self.Text_Input:GetText() =="" then
--                 self.Owner:GetButtonBar().Btn_Yes:ForbidBtn(true)
--             else
--                 self.Owner:GetButtonBar().Btn_Yes:ForbidBtn(false)
--             end
--             NewParams.UseOldContent=Params.UseOldContent
--             if self.IsChangeName then
--                 NewParams.Tips={}
--                 NewParams.Tips[self.BlackTip]=string.format(GText("UI_COMMONPOP_TEXT_100054_2"),DataMgr.GlobalConstant.PlayerNicknameCD.ConstantValue)
--                 --self:RefreshView(100059,NewParams)
--                 self.Owner:HideDialogTip(Params.DialogItemIndex,true)
--                 self:BroadcastDialogEvent("UpdateDialogTipText",NewParams)
--                 self.Owner:ShowDialogTip(self.BlackTip,false)
--             else
--                  self.Owner:HideDialogTip(Params.DialogItemIndex,true)
--             end
--             self.Text_Input:SetFocus()
--         end,false,0,nil,true)
--         self.NormalTimerKey=NormalTimerKey
--     end
--     self:BroadcastDialogEvent("UpdateDialogTipText",Params)
--     if self.IsChangeName then
--         self.Owner:HideDialogTip(self.BlackTip,false)
--     end
--     self.Owner:ShowDialogTip(Params.DialogItemIndex,true)
--     self:BindDialogEvent(DialogEvent.OnRightBtnClicked, function ()
--         self.Owner.DontCloseWhenRightBtnClicked=true
--         if not self.Owner:GetButtonBar().Btn_Yes.IsForbidden then
--             self:OnClickButtonContinue()
--         end
--     end)
-- end

return Component
