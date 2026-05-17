require "UnLua"
local UIUtils = require "Utils.UIUtils"
local SkillUtils = require "Utils.SkillUtils"
local ArmoryUtils = require "BluePrints.UI.WBP.Armory.ArmoryUtils"

---@field RetainerBox URetainerBox
local Component = {}
function Component:RegisterListAttrBtn(ListView)
    if not self.List_Attr then self.List_Attr = ListView end
    if self.Btn_Info then
        self.Btn_Info:UnBindEventOnClickedByObj(self)
        self.Btn_Info:BindEventOnClicked(self,self.OnBtnDetailsClick)
        self.Btn_Info:SetText(GText("UI_Armory_View"))
        self.Btn_Info:SetGamepadIconVisibility(false)
        -- self.Btn_Info:SetDefaultGamePadImg("RS")
    end
    ---底边黑影处理
    --if self.RetainerBox then
        --self.ShadowMat = self.RetainerBox:GetEffectMaterial()
        --self.OriginBlur = self.ShadowMat :K2_GetScalarParameterValue("Blur")
        self.OnListScrolled = function(self,OffsetInItem, DistanceRemaining)
            if not self.MaxScrollOffset then return end
            --DebugPrint(OffsetInItem..":::".. DistanceRemaining..":::".. self.LastOffsetInItem)
            --local CurrBlur = self.ShadowMat :K2_GetScalarParameterValue("Blur")
            -- local CurScrollOffset = self.List_Attr:GetScrollOffset()
            -- if(math.abs(CurScrollOffset-self.MaxScrollOffset)>0.001)then
            --     --if CurrBlur ~= self.OriginBlur then
            --         --self.ShadowMat :SetScalarParameterValue("Blur", self.OriginBlur)
            --     end
            -- elseif CurrBlur ~= 0 then
            --     --self.ShadowMat :SetScalarParameterValue("Blur", 0)
            -- end
        end
        self.List_Attr.OnListViewScrolled:Add(self, self.OnListScrolled)
    --end
end

function Component:UnRegisterListAttrBtn()
    ---还原材质
    if self.RetainerBox and self.OriginBlur then
        self.ShadowMat:SetScalarParameterValue("Blur", self.OriginBlur)
        self.List_Attr.OnListViewScrolled:Clear()
    end
end

function Component:OnBtnDetailsClick()
    if(not self.AttrDetails or #self.AttrDetails < 1)then
        return
    end
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_mid", nil, nil)
    local TitleAndTexts = {}
    for i, Obj in ipairs(self.AttrDetails) do
        table.insert(TitleAndTexts, {Title = Obj.AttrName, Text = Obj.AttrDesc,bShowLine = i ~= #self.AttrDetails})
    end
    local OnAttrDetailsClosed = function()
        if(self.Parent)then
            self.Parent:SetFocus()
        end
    end
    local Params = {
        Text03_ListView = TitleAndTexts,
        LeftCallbackObj = self,
        LeftCallbackFunction = OnAttrDetailsClosed,
        CloseBtnCallbackObj = self,
        CloseBtnCallbackFunction = OnAttrDetailsClosed,
        DontFocusParentWidget = true,
    }
    UIManager(self):ShowCommonPopupUI(100043,Params,self)
end

function Component:PlayAttrListFramingIn(ListView)
    self._ListAttrAnimTimerKeys = UIUtils.PlayListViewFramingInAnimation(self, ListView, {Visibility=UIConst.VisibilityOp.HitTestInvisible, Callback=function()
        self.MaxScrollOffset = UIUtils.GetMaxScrollOffsetOfListView(ListView)
        if self.OnListScrolled then
            self:OnListScrolled()
        end
    end})
end

function Component:StopAttrListFramingIn(ListView)
    UIUtils.StopListViewFramingInAnimation(ListView, {UIState=self, TimerKeys=self._ListAttrAnimTimerKeys, Visibility=UIConst.VisibilityOp.Collapsed})
end
    
function Component:UpdateAttrListView(IsMod,ListView,bShowSign)
    if not self.List_Attr then self.List_Attr = ListView end
    self.AttrDetails = {}
    self.List_Attr:ClearListItems()
    local Obj
    for i, Key in ipairs(self.Index2AttrKey) do
        local Data = DataMgr.AttrConfig[Key]
        local attr = self.Attrs[Key] or 0
        Obj = NewObject(UIUtils.GetCommonItemContentClass())
        Obj.AttrName = GText(Data.Name)
        Obj.AttrDesc = GText(Data.AttrDesc)
        if(Obj.AttrDesc and Obj.AttrDesc ~="")then
            table.insert(self.AttrDetails,Obj)
        end
        if (self.Attrs[Key] and type(self.Attrs[Key]) == "string")
        or (self.ComparedAttrs and type(self.ComparedAttrs[Key]) == "string") then
            Obj.AttrValue = (self.Attrs and self.Attrs[Key]) or ""
            Obj.CmpValue = (self.ComparedAttrs and self.ComparedAttrs[Key]) or ""
            Obj.Style = "Normal"
        else
            attr = self:TryLimitAttr(Data, attr)
            Obj.AttrValue = CommonUtils.AttrValueToString(Data,attr)
            if bShowSign then
                Obj.AttrValue = (attr>0 and "+" or "")..Obj.AttrValue
            end
            if(not self.ComparedTarget)then
                Obj.Style = "None"
            else
                local cmp_attr = self.ComparedAttrs[Key] or 0
                ---属性不超过上限值
                cmp_attr = self:TryLimitAttr(Data, cmp_attr)
                Obj.CmpValue = CommonUtils.AttrValueToString(Data, cmp_attr)
                if bShowSign then
                    Obj.CmpValue = (cmp_attr>0 and "+" or "")..Obj.CmpValue
                end
                if(cmp_attr > attr)then
                    Obj.Style = "Positive"
                elseif(cmp_attr < attr)then
                    Obj.Style = "Negative"
                else
                    Obj.AttrValue = ""
                    Obj.Style = "Normal"
                end
            end
        end
        Obj.Idx = i
        if IsMod then
            Obj.ShowType = "Mod"
        end
        if self.IsRecommendAttr then
            Obj.bHightlight, Obj.bNoBg = self:IsRecommendAttr(Key)
        end
        self.List_Attr:AddItem(Obj)
    end
    if(self.ScrollBox_0)then
        self.ScrollBox_0:ScrollToStart()
    else
        self.List_Attr:ScrollToTop()
    end
    self.List_Attr:RequestPlayEntriesAnim()
end

function Component:TryLimitAttr(Data, Attr)
    if Data.AttrLimit then
        local AttrLimitData = DataMgr.AttrLimit[Data.AttrLimit]
        return math.min(AttrLimitData.LimitValue, Attr)
    end
    return Attr
end

function Component:UpdateSkillPanel(Target, Type)
    Type = Type or self.Type
    if(Type == "Weapon")then
        --武器被动
        self.Text_Describe_Title:SetText(GText("UI_WEAPON_PASSIVE"))
        local SkillDesc = SkillUtils.CalcWeaponPassiveEffectsDesc(Target)
        if(SkillDesc and SkillDesc ~= "")then
            self.SizeBox_Detail:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
            self.Text_Describe:SetText(SkillDesc)
        else
            self.SizeBox_Detail:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        end
        if(self.Describe)then
            if(Target:HasTag("Ultra"))then
                self.Describe:SetVisibility(UIConst.VisibilityOp["Collapsed"])
            else
                self.Describe:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
            end
        end
    else
        if(self.Describe)then
            self.Describe:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        end
    end
end

---插入武器类型属性
function Component:InsertWeaponType(WeaponId,AttrTable)
    ArmoryUtils:InsertWeaponTypeImpl(WeaponId, AttrTable)
end

---插入擅长武器属性
function Component:InsertExcelWeaponTag(CharId,AttrTable)
    AttrTable["ExcelWeaponTag"] = UIUtils.GetExcelWeaponTagString(CharId)
end


return Component