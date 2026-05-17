--
-- DESCRIPTION
-- 个人主页主界面通用View
-- @COMPANY **
-- @AUTHOR 叶轲
-- @DATE ${2025.2.26} ${2}
--
require "UnLua"
local PersonInfoCommon = require "BluePrints.UI.WBP.PersonInfo.PersonInfoCommon"
local PersonInfoController = require "BluePrints.UI.WBP.PersonInfo.PersonInfoController"
local ActorController = require "BluePrints.UI.WBP.Armory.ActorController.Armory_ActorController"
local PersonInfoModel = PersonInfoController:GetModel()
local M = Class {}

M._components = {"BluePrints.UI.WBP.PersonInfo.PersonInfoEditListCompoment",
                 "BluePrints.UI.WBP.Armory.MainComponent.Armory_PointerInputComponent" -- "BluePrints.Common.TimerMgr"
}

function M:Initialize()
    self.IsPersonInfoPage = true
    self.SelectCharIndex = -1
    self.SelectWeaponIndex = -1
    self.Events_BeforeClose = {}
end
-- 刷新主要页面
function M:InitBaseView(Personid)
    --  PersonInfoModel:SetPersonID(Personid) -- todo
    self.isfirst = true

    local PersonalBaseInfo = PersonInfoModel:GetPersonalBaseInfo()
    local PlayerName = PersonalBaseInfo.PlayerName

    local PlayerSignature = PersonalBaseInfo.PlayerSignature
    local CurrentLevel = PersonalBaseInfo.CurrentLevel
    local HeadIconId = PersonalBaseInfo.HeadIconId
    local HeadFrameId = PersonalBaseInfo.HeadFrameId
    local Uid = PersonalBaseInfo.Uid

    local TitleBefore=PersonalBaseInfo.TitleBefore or -1
    local TitleAfter=PersonalBaseInfo.TitleAfter or -1
    local TitleFrame=PersonalBaseInfo.TitleFrame or -1

    self.Text_LevelName:SetText(GText("UI_Player_Level"))
    self.Text_UIDTitle:SetText(GText("UI_UID"))

    self.Text_BrithdayTitle:SetText(GText("UI_Chardata_Char_Brithday"))
    local Avatar = GWorld:GetAvatar()
    local Month, Day = Avatar:GetAvatarBirthday()
    self.Text_Birth:SetText(GDate("Date_MD", {
        Month = Month,
        Day = Day
    }))
    if PlayerName then
        self.Text_PlayerName:SetText(GText(PlayerName))
    end
    if Uid then
        self.Text_UID:SetText(tostring(Uid))
    end
    if CurrentLevel then
        self.Text_Level:SetText(CurrentLevel)
    end

    self.Text_Empty:SetText(GText("UI_Menu_Sign_None"))
    self.Com_ItemHead:SetHeadIconById(HeadIconId, false)
    self.Com_ItemHead:SetHeadFrame(HeadFrameId)

    if PlayerSignature ~= "" then
        self.Switcher_Input:SetActiveWidgetIndex(1)
        self.Text_Input:SetText(PlayerSignature)
    else
        self.Switcher_Input:SetActiveWidgetIndex(0)
    end
    self.Text_EmptyDesc:SetText(GText("UI_PersonInfo_NoChar"))

    --称号相关
    self.TitleSetting:Init(PersonInfoModel:IsOwener())
    self.TitleSetting:Freshtitle(TitleBefore,TitleAfter,TitleFrame)
    --self:Freshtitle(TitleBefore,TitleAfter,TitleFrame)s

    -- 交互相关
    -- self.TitleSetting.Btn_SetTitle.OnClicked:Add(self,self.OnClickChangeTitle)

    self.Btn_UID.OnClicked:Add(self, function()
        AudioManager(self):PlayUISound(nil, "event:/ui/common/click_btn_small", nil, nil)
        self:StopPress()
        self:OnCopyUID()
    end)
    self.Btn_EditShow:SetGamePadImg("X")
    self.Btn_Data:SetGamePadImg("Menu")
    if (PersonInfoModel:IsOwener()) then
        self.Com_ItemHead.Button_Area.OnClicked:Add(self, self.OnClickChangePortrait)
        if (self.OnClickChangeSignature) then
            self.Btn_EditSign.OnClicked:Add(self, self.OnClickChangeSignature) -- OnClickChangeSignature来自PersonInfoEditListCompoment
        end
        self.Btn_EditShow:SetText(GText("UI_PersonInfo_ShowCase_Edit"))
        self.Btn_EditShow.Button_Area.OnClicked:Add(self, self.OnClickOpenEditPage)
        self.Com_ItemHead:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
        self.Com_ItemHead:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        self.Btn_EditSign:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        self.Button_Edit:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Btn_EditShow:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    self.Text_EmptyDesc:SetText(GText("UI_PersonInfo_NoChar"))
    -- 展览柜相关
    self:InitDisplayBoxView()
    self.Group_AvatarInfo:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Text_AvatarTitle:SetText(GText("UI_PersonInfo_ShowCase_Char"))
    self.Text_WeaponTitle:SetText(GText("UI_PersonInfo_ShowCase_Weapon"))

    -- 数据统计相关
    self.Btn_Data.Button_Area.OnClicked:Add(self, self.OnClickOpenDataPage)
    if PersonInfoModel:IsOwener() then
    else
        local Visible=PersonInfoModel:GetDataPageVisibility()
        if Visible then
        else
            self.Btn_Data:ForbidBtn(true)
        end
    end
    self.Btn_Data:SetText(GText("UI_PersonalPage_Recount_Name"))

    --红点相关
    self:AddReddotListener("EditBtn",self.OnPortraitReddotChange)
end


--- 展览柜相关，初始化展柜界面，同时调用刷新模型展示，从编辑页面回来会刷新一遍。
---@param IsChanegeModel 是否切换模型，从编辑页面返回时需要刷新模型
function M:InitDisplayBoxView(IsChanegeModel)

    if (PersonInfoModel:IsOwener() == false) then
        self.Btn_EditShow:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    local DisplayContent = PersonInfoModel:GetDisplayContent()
    local Birthday = DisplayContent.Birthday
    if Birthday then
        self.Text_Birth:SetText(GDate("Date_MD", {
            Month = Birthday[1],
            Day = Birthday[2]
        }))
    end
    -- local FirstValidCharId = -1
    -- local FirstValidWeaponId = -1
    local strings = {"Char", "Weapon"}
    local ItemNames = {"AvatarItem_", "WeaponItem_"}
    local Contents = {DisplayContent.CharContent, DisplayContent.WeaponContent}
    local indexes = {"SelectCharIndex", "SelectWeaponIndex"}
    local funcnames = {"OpenCharEditPage", "OpenWeaponEditPage"}
    local ChangeSelectfuncnames = {"OnClickChangeSelectChar", "OnClickChangeSelectWeapon"}

    -- 取消上次的选择 ,从编辑页面返回可能残留错误的选择
    if self.SelectCharIndex ~= -1 then
        self["AvatarItem_" .. self.SelectCharIndex]:Playanimation(self["AvatarItem_" .. self.SelectCharIndex].Hover)
        self:CancelSelectChar(self.SelectCharIndex)
    end
    if self.SelectWeaponIndex ~= -1 then
        self:CancelSelectWeapon(self.SelectWeaponIndex)
    end

    self.SelectCharIndex = -1
    self.SelectWeaponIndex = -1

    for j = 1, 2 do

        local string = strings[j] -- "Char" or "Weapon"
        local ItemName = ItemNames[j] -- "AvatarItem_" or "WeaponItem_"
        local Content = Contents[j] -- “从Model读来的组装好的数据” 如果ID==-1则为空
        local index = indexes[j] -- "SelectCharIndex" or "SelectWeaponIndex"
        local functionname = funcnames[j] -- 点击道具框的回调函数
        local ChangeSelectfuncname = ChangeSelectfuncnames[j] -- 点击选择框的回调函数

        if self[index] ~= -1 then
            self["CancelSelect" .. string](self, self[index])
        end

        for i = 1, 3 do

            -- 为了共用代码，把weapon和char不同之处整理起来

            self[ItemName .. i].Com_Item:SetVisibility(UIConst.VisibilityOp.Visible)
            Content[i].OnAddedToFocusPathEvent = {
                Obj = self[ItemName .. i].Com_Item,
                Callback = self.OnItemFocusForGamePad,
                Params = self[ItemName .. i].Com_Item
            }
            if Content[i].Id == -1 then -- 没有角色时
                Content[i].Id = 0 -- 换新道具框后空道具框需要ID为0或空，先临时处理一下，待优化
            end
            Content[i].HandleMouseDown = true
            self[ItemName .. i].Com_Item:OnListItemObjectSet(Content[i])

            -- 这个分支里的要注意，InitDisplayBoxView会在从编辑界面返回时调用，修改一个参数需要在另一个分支里recover
            -- and not(j==2 and self.SelectCharIndex==-1 )
            if Content[i].Id ~= 0 then
                if self[index] == -1 then -- 设置默认选中栏
                    self[index] = i
                end
                if (PersonInfoModel:IsOwener()) then
                    -- Content[i].MouseButtonDownEvent:Add(self, self[functionname])
                end
                self[ItemName .. i]:PlayAnimation(self[ItemName .. i].Normal)
                self[ItemName .. i].Button_Area:SetVisibility(UIConst.VisibilityOp.Visible)
                self[ItemName .. i].Com_Item:SetAdd(false)

            else
                self[ItemName .. i].Button_Area:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
                self[ItemName .. i]:PlayAnimation(self[ItemName .. i].Forbidden)
                self[ItemName .. i]:StopAllAnimations() -- 这行不能删，从编辑界面返回后原本的选择变成禁用后可能有按钮颜色不对

            end
        end

        -- 设置默认选择的item
        if self.SelectCharIndex ~= -1 and self[index] ~= -1 then -- 只有有角色时才选择item
            self[ItemName .. self[index]].Button_Area:SetChecked(true)
            -- self[ItemName .. self[index]].Button_Area:SetChecked(false)
            self[ItemName .. self[index]]:PlayAnimation(self[ItemName .. self[index]].Click)
            self[ItemName .. self[index]].Button_Area:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])

        end

        -- 交互
        for i = 1, 3 do
            local Item = self[ItemName .. i]

            -- 初始化选择框
            Item.Button_Area.OnClicked:Clear()
            Item.Button_Area.OnClicked:Add(self, function()
                self[ChangeSelectfuncname](self, i)
            end)
            if self.IsPC == true then
                Item.Button_Area.OnHovered:Add(self, function()
                    PersonInfoController.MainPage:OnCheckBoxFocus()
                end)
            end
            -- 初始化道具框
            local OnMouseButtonDownEvent
            if Content[i].Id ~= 0 and Content[i].Id ~= -1 then
                local bIsWeapon = (j == 2)
                OnMouseButtonDownEvent = self:GetDetialPageClickFunc(Item, i, string, bIsWeapon)
            else
                OnMouseButtonDownEvent = self:GetEditPageClickFunc(ItemName, i, string)
            end
            Item.Com_Item.OnMouseButtonDownEvent = OnMouseButtonDownEvent

        end
    end
    -- --    -- 展览模型相关
    --     M.super:AddTimer(1, function()
    --         self:ModelViewIni()
    --     end)

    if IsChanegeModel == true then -- 从编辑界面返回时需要刷新模型
        self:ModelViewIni()
    end
    -- self:ModelViewIni()
end
---
function M:GetEditPageClickFunc(ItemName, i, string)
    if (PersonInfoModel:IsOwener()) then
        self[ItemName .. i].Com_Item:SetAdd(true)
        local OnMouseButtonDownEvent = {
            Obj = self,
            Callback = function()
                AudioManager(self):PlayUISound(nil, "event:/ui/common/click_mid", nil, nil)
                PersonInfoController:OpenEditView(string, i)
            end,
            Params = nil
        }
        return OnMouseButtonDownEvent
    end

end
---获取已装配道具框点击回调函数，已组装成新版道具框的格式
function M:GetDetialPageClickFunc(Item, i, string, bIsWeapon)
    if bIsWeapon == nil then
        bIsWeapon = false
    end
    local OnMouseButtonDownEvent = {
        Obj = self,
        Callback = function()
            -- PersonInfoController:OpenDetialView()
            local CharInfos = {}
            local WeaponInfos = {}
            local SelectedTargetIndex = i
            -- 1 Char 2 Weapon
            if bIsWeapon == false then
                CharInfos = PersonInfoModel:GetDisplayCharInfos()
            else
                WeaponInfos = PersonInfoModel:GetDisplayWeaponInfos()
            end
            if CharInfos == nil and WeaponInfos == nil then
                return
            end
            if not bIsWeapon then
                AudioManager(self):PlayUISound(nil, "event:/ui/armory/click_select_role", nil, nil)
            else
                AudioManager(self):PlayUISound(nil, "event:/ui/armory/click_select_weapon", nil, nil)
            end
            local AppearanceIndex, ModSuitIndex = PersonInfoModel:GetAppearanceAndModPlan(bIsWeapon, i)
            UIManager(self):LoadUINew("ArmoryDetail", {
                -- PreviewCharIds = {4101}
                PreviewCharInfos = CharInfos,
                PreviewWeaponInfos = WeaponInfos,
                EPreviewSceneType = CommonConst.EPreviewSceneType.PreviewCommon,
                bHideCharFiles = true,
                bHideBoxBtn = true,
                bHideUltraTab = true,
                Title = GText("UI_PersonInfo_Detail_" .. string),
                SelectedTargetIndex = SelectedTargetIndex,
                DoNotSort = true,
                bNoEndCamera = true,
                bFormPersonalPage = true,
                AppearanceIndex = AppearanceIndex,
                -- ModSuitIndex = ModSuitIndex,
                OnCloseDelegate = {self, self.SetOriginFocus},
            })
        end

    }
    return OnMouseButtonDownEvent

end

-- 初始化模型展示相关界面000
function M:ModelViewIni()
    if self.SelectCharIndex == -1 then
        local Avatar = GWorld:GetAvatar()
        self:OnPersonalInfoOpened(Avatar.Chars[Avatar.CurrentChar])
        --self:OnPersonalInfoOpened()
        --不放角色会报错，先临时放一个角色，后续考虑流程优化不加载角色
    end
    if self.SelectCharIndex ~= -1 then -- 当前拥有可展览的角色
        ---初始化角色信息
        local CharBaseInfo = PersonInfoModel:GetShowCharBaseInfo(self.SelectCharIndex)
        self:ChanegeCharInfo(CharBaseInfo, nil, false)
        self.Com_EmptyBg:SetVisibility(UIConst.VisibilityOp.Collapsed)
        ---初始化Tab
        PersonInfoController.MainPage.bHideCharTab = false
        PersonInfoController.MainPage:InitTabInfo()
        self.Group_AvatarInfo:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)

        if PersonInfoModel:IsOwener() then
            local CharData = PersonInfoModel:GetShowCharData(self.SelectCharIndex)
            if self.ActorController == nil then -- 如果已经有初始化过就不需要再次初始化，否则有bug
                self:OnPersonalInfoOpened(CharData) --
            else
                self.ActorController:ChangeCharModel(CharData)
            end

            local uuid, AppearanceSuit = PersonInfoModel:GetCharSuitIndex(self.SelectCharIndex)
            if self.ActorController and self.ActorController.ArmoryPlayer then
                self.ActorController.ArmoryPlayer.CharacterFashion:InitAppearanceSuit(
                PersonInfoModel._Avatar.Chars[uuid]:DumpAppearanceSuit(PersonInfoModel._Avatar, AppearanceSuit))
            end
            self:AddTimer(0.01, function()--换完角色需要等一帧才能播SetArmoryCameraTag
                if (self.SelectWeaponIndex ~= -1) then
                    self:ChangeWeaponView()
                else
                    self.ActorController:SetMontageAndCamera("Char", "Char", "Char", nil)
                end
            end,nil,nil,nil,true)

        else

            local FakeAvatar = PersonInfoModel:GetFakeAvatar()
            -- self:OnPersonalInfoOpesned()
            self:OnPersonalInfoOpened(FakeAvatar.Chars[self.SelectCharIndex])
            if (self.SelectWeaponIndex ~= -1) then
                self:ChangeWeaponView()
            else
                self.ActorController:SetMontageAndCamera("Char", "Char", "Char", nil)
            end
        end

        self.ActorController:HidePlayerActor("PersonInfo", false)

    else
        self:ForbidenWeaponBox()
        PersonInfoController.MainPage.bHideCharTab = true -- 暂无角色展示时tab样式会需要修改
        PersonInfoController.MainPage:InitTabInfo()
        --
        self.Group_AvatarInfo:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Com_EmptyBg:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)

        if PersonInfoController.bReturnMain == true then -- 无角色且从编辑界面返回，不再需要移动镜头。
        else
            -- 只设置镜头，不动蒙太奇
            local t1, t2, t3, t4 = self.ActorController:CalcArmoryCameraTag("Char", "Char", "Char", nil)
            self.ActorController:SetArmoryCameraTag(t1, t2, t3, t4)
            PersonInfoController.bReturnMain = false
        end
        self.ActorController:HidePlayerActor("PersonInfo", true)
    end
end
---从数据统计界面回来后刷新
function M:FreshCamera()
    if not   self.ActorController  then
        return
    end

    if self.SelectCharIndex ~= -1 then
        --self.ActorController:SetMontageAndCamera("Char", "Char", "Char", nil)
        if (self.SelectWeaponIndex > 0) then
            local WeaponData = PersonInfoModel:GetShowWeaponData(self.SelectWeaponIndex)
            if WeaponData then
                local Tag = "Ranged"
                if (WeaponData:HasTag("Melee")) then
                    Tag = "Melee"
                end
                
                local PlayerCharacter = self.ActorController:GetPlayerActor()
                if PlayerCharacter then
                    if not PlayerCharacter:GetWeaponByWeaponTag(Tag, 1) then
                        self.ActorController:ChangePlayerWeapon(WeaponData, PlayerCharacter)
                    end
                end

                if (WeaponData:HasTag("Melee")) then
                    self.ActorController:SetMontageAndCamera("Weapon", "Melee", "Melee", nil)
                else
                    self.ActorController:SetMontageAndCamera("Weapon", "Ranged", "Ranged", nil)
                end
            end
        else
            self.ActorController:SetMontageAndCamera("Char", "Char", "Char", nil)
        end
    end
end
---没有角色时武器也要被禁止
function M:ForbidenWeaponBox()
    for i = 1, 3 do
        -- if Content[i].Id ~= -1 
        -- self["WeaponItem_" .. i].Com_Item:ShowAddIcon(false)
        self["WeaponItem_" .. i].Button_Area:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        -- self["WeaponItem_" .. i]:PlayAnimation(self["WeaponItem_" .. i].Normal)
        self["WeaponItem_" .. i]:StopAllAnimations()
        self["WeaponItem_" .. i]:PlayAnimation(self["WeaponItem_" .. i].Forbidden)

    end
end

---真正的模型初始化
function M:OnPersonalInfoOpened(CharData)
    if self.ActorController == nil then
        self.ActorController = ActorController:New({
            ViewUI = PersonInfoController.MainPage,
            -- UIName="PersonInfo",
            IsPreviewMode = true,
            -- EPreviewSceneType = Params.EPreviewSceneType,
            Char = CharData,
            -- Weapon = self[self.ComparedWeaponName or ""],
            -- Pet = self.ComparedPet,
            EPreviewSceneType = CommonConst.EPreviewSceneType.PreviewCommon,
            bNeedEndCamera = true,
            bPlayRoleChangedSound = self.SelectCharIndex ~= -1
        })
        self.ActorController:OnOpened()
        -- self.ActorController:SwitchArmoryCamera(true)
    end
end
-- 镜头切回主场景
function M:OnPersonalInfoClosed()
end

function M:Destruct()
    --EventManager:RemoveEvent(EventID.OnChangeTitle,self)
    self:RemoveReddotListener("EscPortrait",self.OnPortraitFrameReddotChange)
    self.ActorController:OnClosed()
    self.ActorController:OnDestruct()
    self.ActorController = nil
    --self.Super.Destruct(self)
end
-- 模型展示切换成当前选择的武器
function M:ChangeWeaponView()
    if self.ActorController == nil then
        return
    end
    self["WeaponItem_" .. self.SelectWeaponIndex].Button_Area:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    local WeaponData = PersonInfoModel:GetShowWeaponData(self.SelectWeaponIndex)
    if WeaponData then
        if (WeaponData:HasTag("Melee")) then
            self.ActorController:ChangeWeaponModel(WeaponData)
            self.ActorController:SetMontageAndCamera("Weapon", "Melee", "Melee", nil)
        else
            self.ActorController:ChangeWeaponModel(WeaponData)
            self.ActorController:SetMontageAndCamera("Weapon", "Ranged", "Ranged", nil)
        end
    end
end
-- 模型展示切换成当前选择的角色
function M:OnClickChangeSelectChar(index)
    ScreenPrint("OnClickChangeSelectChar")

    self["AvatarItem_" .. self.SelectCharIndex].Button_Area:SetForbidden(false)
    self:CancelSelectChar(self.SelectCharIndex)
    self.SelectCharIndex = index
    self["AvatarItem_" .. self.SelectCharIndex].Button_Area:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    local CharData
    CharData = PersonInfoModel:GetShowCharData(self.SelectCharIndex)
    self.ActorController:ChangeCharModel(CharData)
    if (self.SelectWeaponIndex > 0) then
        self:ChangeWeaponView()
    else
        self.ActorController:SetMontageAndCamera("Char", "Char", "Char", nil)
    end
    -- 切换配饰 只有是自己的主页才需要切换，查看他人主页传来的已经有角色数据
    if PersonInfoModel:IsOwener() then
        local uuid, AppearanceSuit = PersonInfoModel:GetCharSuitIndex(self.SelectCharIndex)
        self.ActorController.ArmoryPlayer.CharacterFashion:InitAppearanceSuit(
            PersonInfoModel._Avatar.Chars[uuid]:DumpAppearanceSuit(PersonInfoModel._Avatar, AppearanceSuit))
    end

    local CharBaseInfo = PersonInfoModel:GetShowCharBaseInfo(self.SelectCharIndex)
    self:ChanegeCharInfo(CharBaseInfo)

end
--- 模型展示切换
---@param index any
function M:OnClickChangeSelectWeapon(index)
    self:CancelSelectWeapon(self.SelectWeaponIndex)
    self.SelectWeaponIndex = index
    self:ChangeWeaponView()
end
-- 切换名字属性稀有度等角色信息
function M:ChanegeCharInfo(CharData)
    self.Image_CharType:SetBrushResourceObject(CharData.AttributeIcon)
    self.Text_CharName:SetText(GText(CharData.Name))
    if (CharData.Rarity == 5) then
        self.Gacha_Star_5:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
        self.Gacha_Star_5:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end
---取消之前的选择
function M:CancelSelectChar(index)
    self["AvatarItem_" .. self.SelectCharIndex].Button_Area:SetChecked(false)
    self["AvatarItem_" .. self.SelectCharIndex].Button_Area:SetVisibility(UIConst.VisibilityOp["Visible"])
end
---取消之前的选择
function M:CancelSelectWeapon(index)
    self["WeaponItem_" .. self.SelectWeaponIndex].Button_Area:SetChecked(false)
    self["WeaponItem_" .. self.SelectWeaponIndex].Button_Area:SetVisibility(UIConst.VisibilityOp["Visible"])
end

-- 用于设置完头像的回调函数
function M:FreshHeadAndFrames(IsFrame, HeadOrFrameId)

    if (IsFrame == true) then
        self.Com_ItemHead:SetHeadFrame(HeadOrFrameId)

    else
        self.Com_ItemHead:SetHeadIconById(HeadOrFrameId, false)
    end

end
function M:OnClose()
    -- 关闭界面时需要做的事情
    PersonInfoModel:DeleteFakeAvatar()

    for _, Events in pairs(self.Events_BeforeClose) do
        if (Events) then
            Events(self)
        end
    end

    self:OnPersonalInfoClosed()
end

function M:OnClickOpenEditPage()
    PersonInfoController:OpenEditView("Char", nil)
end

function M:OnClickOpenDataPage()
    if PersonInfoModel:IsOwener() then
        PersonInfoController:OpenDataView()
    else
        local Visible=PersonInfoModel:GetDataPageVisibility()
        if Visible then
            PersonInfoController:OpenDataView()
        else
            UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_PersonalPage_Recount_Hidden"))
        end
    end

end
---用于控制角色旋转
function M:On_Image_Click_MouseButtonDown(MyGeometry, MouseEvent)
    if self.IsEditOpen then
        self.IsEditOpen = false
        self:PlayAnimation(self.Edit_List_Out)
    end
    return self:OnPointerDown(MyGeometry, MouseEvent)
end

function M:OnMouseWheel(MyGeometry, MouseEvent)
    -- if(self.ComponentReceivedEvent["WheelScroll"])then
    --     return Unhandled
    -- end
    return self:OnMouseWheelScroll(MyGeometry, MouseEvent)

end

function M:OnMouseButtonUp(MyGeometry, MouseEvent)
    return self:OnPointerUp(MyGeometry, MouseEvent)
end

function M:OnMouseMove(MyGeometry, MouseEvent)
    return self:OnPointerMove(MyGeometry, MouseEvent)
end

function M:OnTouchEnded(MyGeometry, InTouchEvent)
    return self:OnPointerUp(MyGeometry, InTouchEvent)
end

function M:OnTouchMoved(MyGeometry, InTouchEvent)
    return self:OnPointerMove(MyGeometry, InTouchEvent)
end

function M:OnMouseCaptureLost()
    self:OnPointerCaptureLost()
end

-- 切换到手柄后默认选择第一个展柜
function M:SetOriginFocus()
    DebugPrint("聚焦到起点")
    if not PersonInfoModel:IsOwener() then
        PersonInfoController.MainPage:SetFocus()
        if  self.AvatarItem_1.Com_Item.Id~=1 then
            self.AvatarItem_1.Com_Item:SetFocus()
        end
        return
    end
    
    if self.IsEditOpen then
        self:GetFisrtEditItem():SetFocus()
    else
        if self.FreshFocusLeaveEditListView then
            self:FreshFocusLeaveEditListView()
        end
        self.AvatarItem_1.Com_Item:SetFocus()
    end
end
function M:RotateActorForGamePad(MoveDeltaX)
    if not self.ActorController then
        return
    end
    local CursorDelta = {
        X = 5,
        Y = 0
    }
    CursorDelta.X = MoveDeltaX * CursorDelta.X

    self.ActorController:OnDragViewActor(CursorDelta)
end

function M:ZoomCamare(Dalta)
    if not self.ActorController then
        return
    end
    self.ActorController:OnScrolling(Dalta)
end
function M:OnItemFocusForGamePad(ItemObj)
    if PersonInfoController.MainPage.CurInputDeviceType == ECommonInputType.Gamepad then
        if ItemObj.Content.Id ~= 0 then
            PersonInfoController.MainPage:UpdataGamePadBottomAInfo(2)
        else
            if PersonInfoModel:IsOwener() then
                PersonInfoController.MainPage:UpdataGamePadBottomAInfo(1)
            else
                PersonInfoController.MainPage:UpdataGamePadBottomAInfo()
            end
        end
    end
end
function M:OnPortraitReddotChange(Count)
    self.Button_Edit.New:SetEnable( Count>0)

end
function M:AddReddotListener(ReddotNodeName,func)

     self:RemoveReddotListener(ReddotNodeName)
     ReddotManager.AddListenerEx(ReddotNodeName,self, func)
     self.ListenedReddot = true
end

function M:RemoveReddotListener(ReddotNodeName)
    if(self.ListenedReddot) then
        ReddotManager.RemoveListener(ReddotNodeName,self)
        self.ListenedReddot = false
    end
end
AssembleComponents(M)
return M
