--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local EMCache = require "EMCache.EMCache"
local MiscUtils = require "Utils.MiscUtils"

---@type WBP_Abyss_Settle_P_C
local WBP_Abyss_Settle_P_C = Class("BluePrints.UI.BP_UIState_C")

--function WBP_Abyss_Settle_P_C:Initialize(Initializer)
--end

-- function WBP_Abyss_Settle_P_C:Construct()

-- end

--function WBP_Abyss_Settle_P_C:Tick(MyGeometry, InDeltaTime)
--end

function WBP_Abyss_Settle_P_C:Destruct()
    WBP_Abyss_Settle_P_C.Super.Destruct(self)
    -- for i = 1, 5 do
    --     self:RemoveTimer("AddItemInListView"..i)
    -- end
end

--初始化大秘境结算界面需要的所有信息
function WBP_Abyss_Settle_P_C:InitAllAbyssInfo()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then 
        DebugPrint("WBP_Abyss_Settle_P_C:AbyssSettlement can not get Avatar!!!")
        return 
    end 
    --赛季名称
    self.AbyssName = GText(DataMgr.AbyssSeason[self.AbyssId].AbyssIdName)
    --赛季信息
    self.AbyssInfo = Avatar.Abysses[self.AbyssId]
    if not self.AbyssInfo then
        DebugPrint("WBP_Abyss_Settle_P_C:self.AbyssInfo is nil")
        return
    end
    --本关信息
    self.AbyssLevelInfo = self.AbyssInfo.AbyssLevelList[self.AbyssLevelId]
    if not self.AbyssLevelInfo then 
        DebugPrint("WBP_Abyss_Settle_P_C:self.AbyssLevelInfo is nil")
        return 
    end
    --获取关卡类型 1常驻 2轮换 3无尽 其中12会显示双关卡记录 3显示单关卡记录
    self.AbyssLevelType = self.AbyssLevelInfo.AbyssType
    --本次通过房间数 AbyssProgress当前进度/PassARoomNum通过A关的房间数/PassBRoomNum通过B关的房间数
    self.AbyssProgress = self.AbyssLevelInfo.AbyssLevelProgress
    self.PassARoomNum = self.AbyssProgress[1] or 0
    self.PassBRoomNum = self.AbyssProgress[2] or 0
    DebugPrint("WBP_Abyss_Settle_P_C:self.PassARoomNum", self.PassARoomNum)
    DebugPrint("WBP_Abyss_Settle_P_C:self.PassBRoomNum", self.PassBRoomNum)
    --上一次最佳通过房间数
    self.PreAbyssLevelProgress = GWorld.GameInstance.PreAbyssLevelProgress or 0
    --赛季最佳通过房间数
    self.MaxAbyssLevelProgress = self.AbyssLevelInfo.MaxAbyssLevelProgress
    DebugPrint("WBP_Abyss_Settle_P_C:self.MaxAbyssLevelProgress", self.MaxAbyssLevelProgress)
    --当前锁定阵容期间的最佳通过房间数
    self.MaxLockedTeamProgress = self.AbyssLevelInfo.MaxLockedTeamProgress
    DebugPrint("WBP_Abyss_Settle_P_C:self.MaxLockedTeamProgress", self.MaxLockedTeamProgress)
    --当前锁定阵容期间的A房间通过数
    self.MaxPassARoomNumInCurLocked = self.MaxLockedTeamProgress[1] or 0
    DebugPrint("WBP_Abyss_Settle_P_C:self.MaxPassARoomNumInCurLocked", self.MaxPassARoomNumInCurLocked)
    --当前锁定阵容期间的B房间通过数
    self.MaxPassBRoomNumInCurLocked = self.MaxLockedTeamProgress[2] or 0
    DebugPrint("WBP_Abyss_Settle_P_C:self.MaxPassBRoomNumInCurLocked", self.MaxPassBRoomNumInCurLocked)
    --总共房间数
    self.ARoomNum = self.AbyssLevelInfo.DungeonReward1 or 5
    self.BRoomNum = self.AbyssLevelInfo.DungeonReward2 or 5
    DebugPrint("WBP_Abyss_Settle_P_C:self.ARoomNum, self.BRoomNum", self.ARoomNum, self.BRoomNum)
    --本层阵容
    self.AbyssTeamInfo = self.AbyssLevelInfo.AbyssLockedTeamList
    self.ATeamInfo = self.AbyssTeamInfo[1] or nil
    self.BTeamInfo = self.AbyssTeamInfo[2] or nil
end

function WBP_Abyss_Settle_P_C:InitTimeText()
    local Minute = math.floor(self.PassTime / 60)
    local Second = math.floor(self.PassTime % 60)  -- 服务端有概率CostTime传浮点数，强制转换一下
    self.TimeDict = {}
    table.insert(self.TimeDict, 1, {TimeType="Min", TimeValue=Minute})
    table.insert(self.TimeDict, 2, {TimeType="Sec", TimeValue=Second})
end
------------------------------------------------------------星星栏相关------------------------------------------------------------
function WBP_Abyss_Settle_P_C:InitRoomStarList()
    -- --获胜时 当前关的星星列表需要进入动画事件，另一栏则直接初始化
    -- if self.IsWin then
    --     if self.AbyssDungeonIndex == 1 then
    --         self:InitRoomRightStarList()
    --     else
    --         self:InitRoomLeftStarList()
    --     end
    -- else
    --     self:InitRoomLeftStarList()
    --     self:InitRoomRightStarList()
    -- end
    if self.AbyssLevelType == 3 then
        self.WS_Num:SetActiveWidgetIndex(1)
        local Name = self.AbyssDungeonIndex == 1 and GText("Abyss_DungeonA") or GText("Abyss_DungeonB")
        self.Text_Title_M:SetText(Name)
        --self:InitRoomSingleStarList()
    else
        self.WS_Num:SetActiveWidgetIndex(0)
        --当前关的星星列表需要进入动画事件，另一栏则直接初始化
        if self.AbyssDungeonIndex == 1 then
            self.Icon_Fight_L:SetVisibility(ESlateVisibility.Visible)
            self:InitRoomRightStarList()
        else
            self.Icon_Fight_R:SetVisibility(ESlateVisibility.Visible)
            self:InitRoomLeftStarList()
        end
    end

end

function WBP_Abyss_Settle_P_C:InitRoomLeftStarList()
    local CountDown = self.MaxPassARoomNumInCurLocked
    for i = 1, self.ARoomNum do
        local Content =  NewObject(UIUtils.GetCommonItemContentClass())
        Content.RoomIndex = i
        Content.CountDown = CountDown
        Content.ItemIndex = i
        self.List_Progress_L:AddItem(Content)
        CountDown = CountDown - 1
    end
end

function WBP_Abyss_Settle_P_C:InitRoomRightStarList()
    local CountDown = self.MaxPassBRoomNumInCurLocked
    for i = 1, self.BRoomNum do
        local Content =  NewObject(UIUtils.GetCommonItemContentClass())
        Content.RoomIndex = i
        Content.CountDown = CountDown
        Content.ItemIndex = i
        self.List_Progress_R:AddItem(Content)
        CountDown = CountDown - 1
    end
end

function WBP_Abyss_Settle_P_C:InitRoomStartListInAnimation()
    AudioManager(self):PlayUISound(nil, "event:/ui/activity/drama_challenge_finish_goal_list_expand", nil, nil)
    --单排走这个逻辑
    if self.AbyssLevelType == 3 then
        self.List_Progress_M:SetScrollBarVisibility(ESlateVisibility.Collapsed)  -- 暂时隐藏滚动条 
        self.List_Progress_M:ClearListItems()
        local CountDown = self.PassARoomNum
        for i = 1, self.ARoomNum do
            self:AddTimer(self.StarAnimationTickTime * i , self.AddItemInListView, false, 0, nil, true, i, CountDown)
            CountDown = CountDown - 1
        end
        return
    end
    --双排走这个
    if self.AbyssDungeonIndex == 1 then
        self.List_Progress_L:SetScrollBarVisibility(ESlateVisibility.Collapsed)  -- 暂时隐藏滚动条 
        self.List_Progress_L:ClearListItems()
        local CountDown = self.PassARoomNum
        for i = 1, self.ARoomNum do
            self:AddTimer(self.StarAnimationTickTime * i , self.AddItemInListView, false, 0, nil, true, i, CountDown)
            CountDown = CountDown - 1
        end
    else
        self.List_Progress_R:SetScrollBarVisibility(ESlateVisibility.Collapsed)  -- 暂时隐藏滚动条 
        self.List_Progress_R:ClearListItems()
        local CountDown = self.PassBRoomNum
        for i = 1, self.BRoomNum do
            self:AddTimer(self.StarAnimationTickTime * i , self.AddItemInListView, false, 0, nil, true, i, CountDown)
            CountDown = CountDown - 1
        end
    end
end

function WBP_Abyss_Settle_P_C:AddItemInListView(Index, CountDown)
    AudioManager(self):PlayUISound(nil, "event:/ui/activity/drama_challenge_finish_star_add_start", nil, nil)
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.RoomIndex = Index
    Content.CountDown = CountDown
    Content.ItemIndex = Index
    if self.AbyssLevelType == 3 then
        self.List_Progress_M:AddItem(Content)
    else
        if self.AbyssDungeonIndex == 1 then
            self.List_Progress_L:AddItem(Content)
        else
            self.List_Progress_R:AddItem(Content)
        end
    end
    --self:RemoveTimer("AddItemInListView"..Content.ItemIndex)
end

------------------------------------------------------------星星栏相关------------------------------------------------------------

function WBP_Abyss_Settle_P_C:InitTeamListView(TeamMemberIconPath, ListViewWidget, IsPlayerInfo)
    if not TeamMemberIconPath then return end
    for Index, IconPath in pairs(TeamMemberIconPath) do
        DebugPrint("WBP_Abyss_Settle_P_C:InitTeamListView", Index, IconPath)
        --local Icon = LoadObject(IconPath)
        local Content =  NewObject(UIUtils.GetCommonItemContentClass())
        Content.IconPath = IconPath
        Content.Index = Index
        Content = self:AddContentInfo(Content, IsPlayerInfo)
        ListViewWidget:AddItem(Content)
    end
    --显示栏不够4个用空态补足
    if #TeamMemberIconPath < 4 then
        for i = 1, 4 - #TeamMemberIconPath do
            local Content =  NewObject(UIUtils.GetCommonItemContentClass())
            Content.Index = #TeamMemberIconPath + i
            ListViewWidget:AddItem(Content)
        end
    end
end

function WBP_Abyss_Settle_P_C:AddContentInfo(Content, IsPlayerInfo)
    if IsPlayerInfo then
        if Content.Index == 1 then
            Content.Type = "Role"
        elseif Content.Index == 4 then
            Content.Type = "Pet"
        else
            Content.Type = "Weapon"
        end
    else
        if Content.Index == 1 or Content.Index == 3 then
            Content.Type = "Role"
        else
            Content.Type = "Weapon"
        end
    end
    return Content
end

function WBP_Abyss_Settle_P_C:InitTeamListInfo(TeamInfo)
    --DebugPrint(string.format("thy     self.ATeamInfo.Char is %s", CommonUtils.ObjId2Str2(self.ATeamInfo.Char)))
    if not TeamInfo then return end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    --TeamInfo.Char是uuid
    --Char.CharId
    --MeleeWeapon.WeaponId
    local CharInfo = DataMgr.Char
    local WeaponInfo = DataMgr.Weapon
    local PetInfo = DataMgr.Pet
    if not (CharInfo and WeaponInfo and PetInfo) then
        DebugPrint("WBP_Abyss_Settle_P_C:CharInfo or WeaponInfo or PetInfo is nil")
        return
    end
    --玩家图标信息
    local PlayerIconPathArr = {}
    local Char = Avatar.Chars[TeamInfo.Char]
    local MeleeWeapon = Avatar.Weapons[TeamInfo.MeleeWeapon]
    local RangedWeapon = Avatar.Weapons[TeamInfo.RangedWeapon]
    local Pet = Avatar.Pets[TeamInfo.Pet]
    table.insert(PlayerIconPathArr, CharInfo[Char.CharId].Icon)
    table.insert(PlayerIconPathArr, MeleeWeapon and WeaponInfo[MeleeWeapon.WeaponId].Icon or "")
    table.insert(PlayerIconPathArr, RangedWeapon and WeaponInfo[RangedWeapon.WeaponId].Icon or "")
    table.insert(PlayerIconPathArr, Pet and PetInfo[Pet.PetId].Icon or "")

    --魅影图标信息
    local PhantomIconPathArr = {}
    local Phantom1 = Avatar.Chars[TeamInfo.Phantom1]
    local PhantomWeapon1 = Phantom1 and Avatar.Weapons[TeamInfo.PhantomWeapon1]
    local Phantom2 = Avatar.Chars[TeamInfo.Phantom2]
    local PhantomWeapon2 = Phantom2 and Avatar.Weapons[TeamInfo.PhantomWeapon2]
    if Phantom1 then 
        table.insert(PhantomIconPathArr, CharInfo[Phantom1.CharId].Icon)
        if PhantomWeapon1 and PhantomWeapon1.WeaponId then
            table.insert(PhantomIconPathArr, WeaponInfo[PhantomWeapon1.WeaponId].Icon)
        else
            table.insert(PhantomIconPathArr, "")
        end
    end
    if Phantom2 then
        table.insert(PhantomIconPathArr, CharInfo[Phantom2.CharId].Icon)
        if PhantomWeapon2 and PhantomWeapon2.WeaponId then
            table.insert(PhantomIconPathArr, WeaponInfo[PhantomWeapon2.WeaponId].Icon)
        else
            table.insert(PhantomIconPathArr, "")
        end
    end
    if #PhantomIconPathArr < 4 then
    end
    self:InitTeamListView(PlayerIconPathArr, self.List_Item_L, true)
    self:InitTeamListView(PhantomIconPathArr, self.List_Item_R)
end

function WBP_Abyss_Settle_P_C:InitNextLevelInfo()
    --非跳关UI，仅为下一关按钮的信息
    local Text = ""
    --无尽模式
    if self.AbyssLevelType == 3 then
        local NextLevelInfo = self.AbyssInfo.AbyssLevelList[self.AbyssLevelId + 1]
        --存在下一层的情况
        if NextLevelInfo then
            Text = string.format(GText("Abyss_LevelName"), self.AbyssLevelId + 1)
            self.DungeonName = self.AbyssDungeonIndex == 1 and GText("Abyss_DungeonA") or GText("Abyss_DungeonB")
            Text = Text..self.DungeonName
            self.Text_NextFloor:SetText(Text)
        else
            self.CanvasPanel_1:SetVisibility(ESlateVisibility.Collapsed)
            self:AdjustWSTypeSize()
        end
    --其他模式
    else
        --能进下一层的情况 AB拿满星 存在下一关
        if (self.MaxAbyssLevelProgress == self.ARoomNum + self.BRoomNum) then
            local NextLevelInfo = self.AbyssInfo.AbyssLevelList[self.AbyssLevelId + 1]
            if NextLevelInfo then--存在下一层的情况
                Text = string.format(GText("Abyss_LevelName"), self.AbyssLevelId + 1)
                self.DungeonName = self.AbyssDungeonIndex == 1 and GText("Abyss_DungeonA") or GText("Abyss_DungeonB")
                Text = Text..self.DungeonName
                self.Text_NextFloor:SetText(Text)
            else--不存在下一层的情况
                self.CanvasPanel_1:SetVisibility(ESlateVisibility.Collapsed)
                self:AdjustWSTypeSize()
            end
        else --没满星，如果当前关没满星但是另一关满星了，这个时候隐藏下一关
            if (self.AbyssDungeonIndex == 1 and self.PassBRoomNum == 5) or (self.AbyssDungeonIndex == 2 and self.PassARoomNum == 5) then
                self.CanvasPanel_1:SetVisibility(ESlateVisibility.Collapsed)
                self:AdjustWSTypeSize()
            else
                Text = string.format(GText("Abyss_LevelName"), self.AbyssLevelId)
                self.DungeonName = self.AbyssDungeonIndex == 1 and GText("Abyss_DungeonB") or GText("Abyss_DungeonA")
                Text = Text..self.DungeonName
                self.Text_NextFloor:SetText(Text)
            end
        end
    end
end

function WBP_Abyss_Settle_P_C:AdjustWSTypeSize()
    local Rule = FSlateChildSize()
    Rule.SizeRule = UE.ESlateSizeRule.Fill
    self.WS_Type:SetActiveWidgetIndex(1)
    local Slot = UWidgetLayoutLibrary.SlotAsHorizontalBoxSlot(self.WS_Type)
    Slot:SetSize(Rule)

    
end

function WBP_Abyss_Settle_P_C:OnReplay()
    self.NextLevelIndex = self.AbyssLevelId
    self.BeginDungeonId = self.AbyssDungeonIndex
    AudioManager(self):PlayUISound(nil, "event:/ui/common/click_btn_small", nil, nil)
    self:EnterDungeon()
end

function WBP_Abyss_Settle_P_C:OnNextLevel()
    AudioManager(self):PlayUISound(nil, "event:/ui/common/click_btn_confirm", nil, nil)
    GWorld.GameInstance.PreAbyssLevelProgress = self.MaxAbyssLevelProgress
    --下一关的逻辑： 同层A通关 检查同层B是否满星，未满星进入同层B,已满星进入下一层的A(有的话)
    --同层B通关 检查同层A是否满星，未满星进入同层A.已满星进入下一层的B
    if self.AbyssLevelType == 3 then
        self.NextLevelIndex = self.AbyssLevelId + 1
        self.BeginDungeonId = 1
    else
        if self.AbyssDungeonIndex == 1 then
            if self.PassBRoomNum < 5 then
                self.NextLevelIndex = self.AbyssLevelId
                self.BeginDungeonId = 2
            else
                self.NextLevelIndex = self.AbyssLevelId + 1
                self.BeginDungeonId = 1
            end
        else
            if self.PassARoomNum < 5 then
                self.NextLevelIndex = self.AbyssLevelId
                self.BeginDungeonId = 1
            else
                self.NextLevelIndex = self.AbyssLevelId + 1
                self.BeginDungeonId = 2
            end
        end
    end
    
    self:EnterDungeon()
end

local TeamErrorCodes = {
    [ErrorCode.RET_ABYSS_TEAM_NO_CHAR] = true,
    [ErrorCode.RET_ABYSS_TEAM_NO_MELEEWEAPON] = true,
    [ErrorCode.RET_ABYSS_TEAM_NO_RANGEDWEAPON] = true,
    [ErrorCode.RET_ABYSS_TEAM_PHANTOM_NO_WEAPON] = true,
    [ErrorCode.RET_ABYSS_TEAM_PET_NOT_OWNED] = true,
}

function WBP_Abyss_Settle_P_C:EnterDungeon()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        DebugPrint("WBP_Abyss_Settle_P_C:关卡详情界面进入关卡失败，Avatar获取失败")
        return
    end

    --处理进入副本服务器返回值
    local Callback = function(RetCode)
        if RetCode == ErrorCode.RET_SUCCESS then
            UIManager(self):ShowUITip(UIConst.Tip_CommonTop,"成功进入".. self.DungeonName)
        else
            if DataMgr.ErrorCode[RetCode] then
                local ErrorContent = DataMgr.ErrorCode[RetCode].ErrorCodeContent
                if TeamErrorCodes[RetCode] then
                    UIManager(self):ShowUITip(UIConst.Tip_CommonTop,GText("Abyss_PartySetup_ConditionsAreNot"))
                else
                    UIManager(self):ShowUITip(UIConst.Tip_CommonTop,ErrorContent.."(Debug用)")
                end
            end
        end
    end
    
    Avatar:TriggerEnterAbyss(Callback, self.AbyssId, self.NextLevelIndex, self.BeginDungeonId)
    self:SetCharDirLight(false)
end

--失败需要隐藏的UI
function WBP_Abyss_Settle_P_C:HideNextStageBtn()
    -- self.VB_Btn:SetVisibility(ESlateVisibility.Collapsed)
    -- self.Btn_NextStage:SetVisibility(ESlateVisibility.Collapsed)
    -- self.Text_ExitTime:SetVisibility(ESlateVisibility.Collapsed)
    -- self.Text_Next_Stage:SetVisibility(ESlateVisibility.Collapsed)
    -- self.Text_Tier:SetVisibility(ESlateVisibility.Collapsed)
    -- self.Text_Tier_Name:SetVisibility(ESlateVisibility.Collapsed)
    self.CanvasPanel_1:SetVisibility(ESlateVisibility.Collapsed)
    self:AdjustWSTypeSize()
end

function WBP_Abyss_Settle_P_C:UpdateNextStageBtnVisble()
    --关于隐藏下一关 三个情况 第一个是 没有下一关了 第二是玩家的下一关已经十颗星了  还有是没赢
    if not self.IsWin then
        self:HideNextStageBtn()
        return
    end

    --没通过完全 按照下一关按键的逻辑会进入未完全通关的一层中
    if self.PassARoomNum + self.PassBRoomNum ~= self.ARoomNum + self.BRoomNum then
        return
    end

    --是否有下一关
    local NextLevelInfo = self.AbyssInfo.AbyssLevelList[self.AbyssLevelId + 1]
    if not NextLevelInfo then
        self:HideNextStageBtn()
        return 
    end

    --有下一关 是否全部通关
    local ARoomNum = self.AbyssLevelInfo.DungeonReward1
    local BRoomNum = self.AbyssLevelInfo.DungeonReward2
    local PassARoomNum = NextLevelInfo.AbyssLevelProgress[1]
    local PassBRoomNum = NextLevelInfo.AbyssLevelProgress[2]
    if PassARoomNum + PassBRoomNum == ARoomNum + BRoomNum then
        self:HideNextStageBtn()
    end
end

function WBP_Abyss_Settle_P_C:HideRestartBtn()
    self.WS_Type:SetVisibility(ESlateVisibility.Collapsed)
end

function WBP_Abyss_Settle_P_C:UpdateBtnVisbleOnSeasonEnd()
    -- 结算时如果当前赛季已结束
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    if not DataMgr.AbyssSeason[self.AbyssId] then
        return
    end
    local AbyssSeasonId = DataMgr.AbyssSeason[self.AbyssId].AbyssSeasonId
    if not AbyssSeasonId then
        return
    end
    if AbyssSeasonId == Avatar.CurrentAbyssSeasonId then
        return
    end

    self.IsAbyssSeasonEnd = true
    self:HideNextStageBtn()
    self:HideRestartBtn()
end

function WBP_Abyss_Settle_P_C:AddStarNum()
    DebugPrint("WBP_Abyss_Settle_P_C:self.PreAbyssLevelProgress", self.PreAbyssLevelProgress)
    self.PreAbyssLevelProgress = self.PreAbyssLevelProgress + 1
    if not (self.PreAbyssLevelProgress > self.MaxAbyssLevelProgress) then
        AudioManager(self):PlayUISound(nil, "event:/ui/activity/drama_challenge_finish_star_add", nil, nil)
        self.Text_Now:SetText(self.PreAbyssLevelProgress)
    else
        self:RemoveTimer("AddStarNum")
    end 
end

function WBP_Abyss_Settle_P_C:IncreasingStarNum()
    self:AddTimer(0.2, self.AddStarNum, true, 0, "AddStarNum")
end

function WBP_Abyss_Settle_P_C:CheckPlayBreakAnimationCondition()
    DebugPrint("WBP_Abyss_Settle_P_C:CheckPlayBreakAnimationCondition", self.IsNeedPlayBreak)
    if self.IsNeedPlayBreak then
        self:PlayAnimation(self.Break)
    end
end

function WBP_Abyss_Settle_P_C:InitUIConcent()
    --关卡完成
    self.VX_Text_Title:SetText(GText("Abyss_Battle_Win"))
    self.VX_Text_Title_Mid:SetText(GText("Abyss_Battle_Win"))
    --层数  叫 第几幕 交互文档里的显示不对
    local LevelIndex = string.format(GText("Abyss_LevelName"), tostring(self.AbyssLevelId))
    --宣叙调为1，咏叹调为2   关卡叫布景几 交互文档里的显示不对
    self.DungeonName = self.AbyssDungeonIndex == 1 and GText("Abyss_DungeonA") or GText("Abyss_DungeonB")
    local TextTips = self.AbyssName.."/"..LevelIndex.."/"..self.DungeonName
    self.Text_Tips:SetText(TextTips)
    --通关时间
    self:InitTimeText()
    self.Com_Time:SetTimeText("", self.TimeDict)
    --战斗进度
    self.Text_Battle_Progress:SetText(GText("Abyss_FightProgress"))
    --隐藏战斗数据
    self.Img_Data:SetVisibility(ESlateVisibility.Collapsed)
    self.Text_PanelData:SetVisibility(ESlateVisibility.Collapsed)
    --宣叙调 和  咏叹调
    self.Text_Title_L:SetText(GText("Abyss_DungeonA"))
    self.Text_Title_R:SetText(GText("Abyss_DungeonB"))
    --宣叙调 和 宣叙调 的 布景列表 星星栏作为动画事件插入到动画中
    self:InitRoomStarList()
    --奖励进度文本
    self.Text_Reward_Progress:SetText(GText("Abyss_RewardProgress"))
    --奖励进度
    self.IsNeedPlayBreak = false
    if self.PreAbyssLevelProgress < self.MaxAbyssLevelProgress then
        self.Text_Now:SetText(self.PreAbyssLevelProgress)
        self.IsNeedPlayBreak = true
        --self:PlayAnimation(self.Break) --break动画播放转为在动画中的事件
    else
        self.Text_Now:SetText(self.MaxAbyssLevelProgress)
    end
    if self.AbyssLevelType == 3 then
        self.Text_All:SetText(tostring(self.ARoomNum))
    else
        self.Text_All:SetText(tostring(self.ARoomNum + self.BRoomNum))
    end
    --本关阵容文本
    self.Text_lineup:SetText(GText("Abyss_PartySetup"))
    --阵容列表
    if self.AbyssDungeonIndex == 1 then
        self:InitTeamListInfo(self.ATeamInfo)
    else
        self:InitTeamListInfo(self.BTeamInfo)
    end
    --下一关的具体信息文本
    self:InitNextLevelInfo()
    --重新挑战按钮
    --文本
    --self.Btn_Anew:SetText(GText("Abyss_Battle_Again"))
    --绑定
    self.Btn_Anew.Button_Area.OnClicked:Add(self, self.OnReplay)
    self.Btn_Anew_L:SetText(GText("Abyss_Battle_Again"))
    self.Btn_Anew_L.Button_Area.OnClicked:Add(self, self.OnReplay)
    self.Btn_Anew_L:SetGamePadImg("X")
    --战斗数据统计按钮
    self.Btn_CombatData.OnClicked:Add(self, self.OnBtnChangePanelClicked)
    self.Img_Data:SetVisibility(ESlateVisibility.Visible)
    self.Text_PanelData:SetText(GText("UI_BATTLE_DATA"))
    self.Text_PanelData:SetVisibility(ESlateVisibility.Visible)
    --下一关按钮
    --推荐等级文本
    -- local AbyssLevelList = DataMgr.AbyssSeason[self.AbyssId].AbyssLevelId
    -- local LevelId = AbyssLevelList[self.AbyssLevelId]
    -- local AbyssLevelInfo = DataMgr.AbyssLevel[LevelId]
    -- local RecommandLevel = AbyssLevelInfo.RecLevel
    -- DebugPrint("thy     RecommandLevel", RecommandLevel)
    -- self.Text_ExitTime:SetText(GText("Abyss_RecLevel") .. tostring(RecommandLevel))
    --按钮文本
    self.Btn_NextStage:SetText(string.format(GText("Abyss_GoNextDungeon"), GText("Abyss_NextDungeon")))
    --绑定
    self.Btn_NextStage:SetDefaultGamePadImg("Y")
    self.Btn_NextStage.Button_Area.OnClicked:Add(self, self.OnNextLevel)
    --控件下一关按钮的显隐
    self:UpdateNextStageBtnVisble()
    --赛季结束时大秘境结算，隐藏下一关按钮和再次挑战按钮
    self:UpdateBtnVisbleOnSeasonEnd()
    --退出按钮绑定
    self.Btn_Quit:SetDefaultGamePadImg("B")
    self.Btn_Quit:SetText(GText("UI_BACK"))
    self.Btn_Quit.Button_Area.OnClicked:Add(self, self.ReturnLevelInfoUI)
    --是否可以跳转关卡UI
    self:InitJumpUI()
end

function WBP_Abyss_Settle_P_C:InitJumpUI()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        self.Panel_UnlockNode:SetVisibility(ESlateVisibility.Collapsed)
        return
    end

    --2026.1.9 不需要跳关ui了 直接不执行显示逻辑
    --self.CanJump = Avatar:CheckAbyssCanJump(self.AbyssId, self.AbyssLevelId)
    if false then
        self.Key_Controller_Node:CreateCommonKey({
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "Menu"
                }
            }
        })
        self.Text_Next_Stage:SetText(GText("Abyss_InfiniteNode_UNLOCKED"))
        local InfiniteNodeList = DataMgr.AbyssSeason[self.AbyssId].InfiniteNode
        local AddLevel = InfiniteNodeList and InfiniteNodeList[1] or 1
        local JumpAbyssId = self.AbyssLevelId + AddLevel
        self.Text_Tier:SetText(string.format(GText("Abyss_LevelName"), JumpAbyssId))
        local Name = self.AbyssDungeonIndex == 1 and GText("Abyss_DungeonA") or GText("Abyss_DungeonB")
        self.Text_Tier_Name:SetText(Name)--先这么写着
        self.Panel_UnlockNode:SetVisibility(ESlateVisibility.Visible)
        self:PlayAnimation(self.Unlock)
        --self.Btn_Node.OnClicked:Add(self, self.JumpToDungeon)
    else
        self.Panel_UnlockNode:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function WBP_Abyss_Settle_P_C:JumpToDungeon()
    --self.AbyssId, self.NextLevelIndex, self.BeginDungeonId
    local InfiniteNodeList = DataMgr.AbyssSeason[self.AbyssId].InfiniteNode
    local AddLevel = InfiniteNodeList and InfiniteNodeList[1] or 1

    self.NextLevelIndex = self.AbyssLevelId + AddLevel
    self.BeginDungeonId = 1
        self.NameEditDialog = UIManager(self):ShowCommonPopupUI(100189, {
        -- RightCallbackObj = self,
        -- RightCallbackFunction = self.EnterDungeon,
        LeftCallbackObj = self,
        LeftCallbackFunction = function ()
            self:PlayAnimation(self.Normal_Cancel)
            self.NameEditDialog = nil
        end,
        }, self)
    end

function WBP_Abyss_Settle_P_C:OnLoaded(...)
    --显示鼠标  接入手柄后要改判断
    local PlayerController = UGameplayStatics.GetPlayerController(self, 0)
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        PlayerController.bShowMouseCursor = true
    else
        PlayerController.bShowMouseCursor = false
    end
    --设备切换监听
    self:InitDeviceInfo()
    self:InitListenEvent()
    --获取服务器传来的大秘境结算信息 isWin副本胜利/AbyssId赛季id/AbyssLevelId当前赛季的层数（LevelIdnex）/AbyssDungeonIndexAB关（1或者2）
    local LogicServerInfo = ...
    self.IsWin, self.AbyssId, self.AbyssLevelId, self.AbyssDungeonIndex, self.PassTime = table.unpack(LogicServerInfo)
    DebugPrint("WBP_Abyss_Settle_P_C:OnLoaded AbyssSettlement", self.IsWin, self.AbyssId, self.AbyssLevelId, self.AbyssDungeonIndex, self.PassTime)
    --初始化大秘境结算界面需要的所有信息
    self:InitAllAbyssInfo()
    --增加星星的特效绑定回调
    self:BindToAnimationFinished(self.Break, {self, self.IncreasingStarNum})
    --初始化UI
    self:InitUIConcent()
    --缓存副本id信息
    self:UpdateDungeonProgress()
    --播放胜利或者失败动画
    if self.IsWin then
        self:UnbindAllFromAnimationFinished(self.Victory_In)
        self:BindToAnimationFinished(self.Victory_In, {self, function()
            local Avatar = GWorld:GetAvatar()
            if Avatar then
                local JumeLevelIndex = Avatar:GetJumpLevelIndex(self.AbyssId)
                DebugPrint("WBP_Abyss_Settle_P_C:AbyssSettle", JumeLevelIndex, self.AbyssLevelId, self.MaxAbyssLevelProgress, self.PreAbyssLevelProgress, self.ARoomNum, self.MaxLockedTeamProgress[1])
                --无尽关卡才有跳关
                if JumeLevelIndex and JumeLevelIndex == self.AbyssLevelId and self.PreAbyssLevelProgress < self.ARoomNum and self.MaxLockedTeamProgress[1] == self.ARoomNum then
                    self.NameEditDialog = UIManager(self):ShowCommonPopupUI(100189, {
                        ShortTextParams = {string.format("%d", self.ARoomNum * JumeLevelIndex)}}, self)
                end
            end
        end})
        self:PlayAnimation(self.Victory_In)
        AudioManager(self):PlayUISound(nil, "event:/ui/activity/drama_challenge_finish_fx", nil, nil)
    else
        self:PlayAnimation(self.Defeat_In)
        AudioManager(self):PlayUISound(nil, "event:/ui/activity/drama_challenge_unfinish_fx", nil, nil)
    end

    self:SetCharDirLight(true)
    self:InitListenEventMgr()
end

function WBP_Abyss_Settle_P_C:InitListenEventMgr()
    self:AddDispatcher(EventID.OnAbyssSeasonEnd, self, self.OnAbyssSeasonEnd)
end

function WBP_Abyss_Settle_P_C:Exit()
    self:BlockAllUIInput(true)
    local Avatar = GWorld:GetAvatar()
    Avatar:ExitDungeonSettlement()
    EventManager:AddEvent(EventID.OnExitDungeon, self, self.DefaultExit)
end

function WBP_Abyss_Settle_P_C:DefaultExit()
    EventManager:RemoveEvent(EventID.OnExitDungeon, self)
    self:BlockAllUIInput(false)
    self:Close()
    --self:OnCloseSettlementUI()
end

function WBP_Abyss_Settle_P_C:ReturnLevelInfoUI()
    -- local Avatar = GWorld:GetAvatar()
    -- DebugPrint("thy   ReturnLevelInfoUI  Avatar", Avatar)
    -- if Avatar then
    --     GWorld.GameInstance.AbyssId = self.AbyssId
    --     GWorld.GameInstance.AbyssLevelId = self.AbyssLevelId
    --     GWorld.GameInstance.AbyssDungeonIndex = self.AbyssDungeonIndex
    --     Avatar.ExitFromAbyss = true
    -- end
    AudioManager(self):PlayUISound(nil, "event:/ui/common/click_btn_confirm", nil, nil)
    self:Exit()
end


--本地缓存副本id，供退出副本时跳转使用
function WBP_Abyss_Settle_P_C:UpdateDungeonProgress()
    -- 策划要求，赛季结束时退出副本，不返回委托界面(注意时序 IsAbyssSeasonEnd在InitUIConcent)
    if self.IsAbyssSeasonEnd then
        GWorld.GameInstance:ClearExitDungeonData()
    else
        local ExitDungeonInfo = GWorld.GameInstance:GetExitDungeonData()
        if ExitDungeonInfo then
            ExitDungeonInfo.AbyssId = self.AbyssId
            ExitDungeonInfo.AbyssLevelId = self.AbyssLevelId
            ExitDungeonInfo.AbyssDungeonIndex = self.AbyssDungeonIndex
            GWorld.GameInstance:SetExitDungeonData(ExitDungeonInfo)
        end
    end
end

----------------------------统计数据相关-----------------------------
function WBP_Abyss_Settle_P_C:OnBtnChangePanelClicked()
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManger = GameInstance:GetGameUIManager()
    if UIManger then
        -- 构造弹窗参数
        local Params = {
            OnCloseCallbackObj = self,
            OnCloseCallbackFunction = self.OnCombatDataClosed
        }
        self.Popup_CombatData = UIManger:ShowCommonPopupUI(Const.Popup_CombatData, Params, self)
        self.Popup_CombatData:SetVisibility(ESlateVisibility.Collapsed)
        self.Popup_CombatData:ShowGamepadScrollBtn(true)
        self:CreateCombatData()
    end
end

function WBP_Abyss_Settle_P_C:CreateCombatData()
    for i = 0, self.Popup_CombatData.VB_Node:GetChildrenCount() - 1 do
        local Child = self.Popup_CombatData.VB_Node:GetChildAt(i)
        if Child.EMScrollBox_31 ~= nil then
            self.Panel_CombatData = Child
            break
        end
    end
    self:SetDetailsContent()
    self.Popup_CombatData:SetVisibility(ESlateVisibility.Visible)
    self.Panel_CombatData.EMScrollBox_31:SetScrollBarVisibility(ESlateVisibility.Collapsed)  -- 暂时隐藏滚动条
    self.Panel_CombatData.EMScrollBox_31:SetControlScrollbarInside(true)
    self.Panel_CombatData:SetFocus()
end

function WBP_Abyss_Settle_P_C:SetDetailsContent()
    self.Widget_DetailsTime = self:InitDataContent(GText("UI_STAT_Time"), self:GetTimeStr(self.PassTime))
    self.CombatData = GWorld.GameInstance.CombatData
    self:SetDamageDetails()
    --self:SetKillDetails()
    self:SetTakedDamageDetails()
    self:SetPhantomAttrsDetails()
    --self:SetOtherDetails()

    -- local DeadCount = self.CombatData.DeadCount or 0
    -- self.Widget_DeadCount = self:InitDataContent(GText("UI_STAT_DEAD"), tostring(DeadCount))
end

function WBP_Abyss_Settle_P_C:SetDamageDetails()
    local TotalDamagePercent = self.CombatData.DamagePercentage or 0
    local TotalDamage = self.CombatData.TotalDamage or 0
    local MeleeDamage = self.CombatData.MeleeDamage or 0
    local RangedDamage = self.CombatData.RangedDamage or 0
    local SkillDamage = self.CombatData.SkillDamage or 0
    local SupportDamage = self.CombatData.SupportDamage or 0

    local TotalDamageText = tostring(MiscUtils.Round(TotalDamage))
    if not IsStandAlone(self) then
        TotalDamageText = TotalDamageText .. "(" .. MiscUtils.Round(TotalDamagePercent * 100) .. "%)"
    end
    self.Widget_DamageDetail = self:InitDataContent(GText("UI_STAT_DAMAGE_TITLE"), TotalDamageText)

    -- 初始排序即为默认排序，后续的 sort 排序只有Value小于才会换位。
    local DamageDetails = {{
        Name = GText("UI_STAT_DAMAGE_MELEE"),
        Value = MeleeDamage
    }, {
        Name = GText("UI_STAT_DAMAGE_RANGE"),
        Value = RangedDamage
    }, {
        Name = GText("UI_STAT_DAMAGE_CHAR"),
        Value = SkillDamage
    }, {
        Name = GText("UI_STAT_DAMAGE_Pet"),
        Value = SupportDamage
    }}
    -- table.sort(DamageDetails, function(a, b)
    --     return a.Value > b.Value
    -- end)

    self:WrapedInitChildDetailContentFunc(self.Widget_DamageDetail, DamageDetails, 4)
end

function WBP_Abyss_Settle_P_C:SetKillDetails()
    local TotalKill = self.CombatData.TotalKill or 0
    local MeleeKill = self.CombatData.MeleeKill or 0
    local RangedKill = self.CombatData.RangedKill or 0
    local SkillKill = self.CombatData.SkillKill or 0
    local SupportKill = self.CombatData.SupportKill or 0

    self.Widget_KillDetail = self:InitDataContent(GText("UI_STAT_KILL_TITLE"), tostring(MiscUtils.Round(TotalKill)))

    -- 初始排序即为默认排序，后续的 sort 排序只有Value小于才会换位。
    local KillDetails = {{
        Name = GText("UI_STAT_KILL_MELEE"),
        Value = MeleeKill
    }, {
        Name = GText("UI_STAT_KILL_RANGE"),
        Value = RangedKill
    }, {
        Name = GText("UI_STAT_KILL_CHAR"),
        Value = SkillKill
    }, {
        Name = GText("UI_STAT_KILL_Pet"),
        Value = SupportKill
    }}
    table.sort(KillDetails, function(a, b)
        return a.Value > b.Value
    end)

    self:WrapedInitChildDetailContentFunc(self.Widget_KillDetail, KillDetails, 4)
end

function WBP_Abyss_Settle_P_C:SetTakedDamageDetails()
    local TakeDamagePercent = self.CombatData.TakeDamagePercentage
    local TakedDamage = MiscUtils.Round(self.CombatData.TakedDamage)
    local TakedShieldDamage = self.CombatData.TakedShieldDamage
    local TakedHeal = self.CombatData.TakedHeal

    local TakeDamageText = tostring(MiscUtils.Round(TakedDamage))
    if not IsStandAlone(self) then
        TakeDamageText = TakeDamageText .. "(" .. MiscUtils.Round(TakeDamagePercent * 100) .. "%)"
    end
    self.Widget_TotalDamage = self:InitDataContent(GText("UI_STAT_SUFFER"), TakeDamageText)

    local TakedDamageDetails = {{
        Name = GText("UI_STAT_Shield"),
        Value = TakedShieldDamage
    }, {
        Name = GText("UI_STAT_Healing"),
        Value = TakedHeal
    }}

    self:WrapedInitChildDetailContentFunc(self.Widget_TotalDamage, TakedDamageDetails, 2)
end

function WBP_Abyss_Settle_P_C:SetPhantomAttrsDetails()
    local PhantomAttrInfos = self.CombatData.PhantomAttrInfos
    local PhantomNum = self.CombatData.PhantomNum
    local Battle = GWorld.Battle
    if not Battle then 
        DebugPrint("WBP_Abyss_Settle_P_C:Battle为nil")
        return
    end
    --未使用魅影，不显示这行统计数据
    if PhantomNum == 0 then
        DebugPrint("WBP_Abyss_Settle_P_C:没有魅影")
        return
    end
    --生成标题
    local PhantomDetails = {}
    for PhantomNumber, PhantomAttrInfo in pairs(PhantomAttrInfos) do
        if PhantomAttrInfo and PhantomAttrInfo.PhantomRoleId and PhantomAttrInfo.PhantomRoleId > 999 then
            local PhantomName = DataMgr.Char[PhantomAttrInfo.PhantomRoleId].CharName
            self["Widget_PhantomDetails"..PhantomNumber] = self:InitDataContent(GText("UI_STAT_Sigil"), GText(PhantomName))
            PhantomDetails= 
            {
                {Name = GText("UI_STAT_Sigil_DAMAGE"), Value = PhantomAttrInfo.FinalDamage}, 
                {Name = GText("UI_STAT_Sigil_SUFFER"), Value = PhantomAttrInfo.TakedDamage},
                --{Name = GText("UI_STAT_Sigil_KILL"), Value = PhantomAttrInfo.TotalKillCount},
                --{Name = GText("UI_STAT_Sigil_DEAD"), Value = PhantomAttrInfo.DeathCount}
            }
            self:WrapedInitChildDetailContentFunc(self["Widget_PhantomDetails"..PhantomNumber], PhantomDetails, #PhantomDetails)
        end
        
    end

end

function WBP_Abyss_Settle_P_C:SetOtherDetails()
    local SpConsume = self.CombatData.SpConsume
    local BulletConsume = self.CombatData.BulletConsume
    local ChestOpenedCount = self.CombatData.ChestOpenedCount
    local BreakableItemCount = self.CombatData.BreakableItemCount
    local MaxComboCount = self.CombatData.MaxComboCount
    local MaxDamage = self.CombatData.MaxDamage

    self.Widget_Other = self:InitDataContent(GText("UI_STAT_Other"))

    local OtherDetails = {{
        Name = GText("UI_STAT_ActionPoint_Cost"),
        Value = SpConsume
    }, {
        Name = GText("UI_STAT_Bullets_Cost"),
        Value = BulletConsume
    }, {
        Name = GText("UI_STAT_Chest"),
        Value = ChestOpenedCount
    }, {
        Name = GText("UI_STAT_Destructible"),
        Value = BreakableItemCount
    }, {
        Name = GText("UI_STAT_Combo_Max"),
        Value = MaxComboCount
    }, {
        Name = GText("UI_STAT_Damage_Max"),
        Value = MaxDamage
    }}

    self:WrapedInitChildDetailContentFunc(self.Widget_Other, OtherDetails, 6)
end

function WBP_Abyss_Settle_P_C:InitDataContent(TextTarget, TextNumber)
    local Data_Widget = self:CreateWidgetNew("DungeonSettlementData")
    self:SetTitleContent(Data_Widget.Title, TextTarget, TextNumber)
    self.Panel_CombatData.EMScrollBox_31:AddChild(Data_Widget)
    return Data_Widget
end

function WBP_Abyss_Settle_P_C:SetTitleContent(Title, TextTarget, TextNumber)
    Title.Text_Main:SetText(TextTarget)
    Title.Text_Number:SetText(TextNumber)
end

function WBP_Abyss_Settle_P_C:WrapedInitChildDetailContentFunc(FatherWidget, ChildInfos, ChildInfoLength)
    local IsIntervalBg = true
    local ChildTargets = self:InitTargetContents(FatherWidget, ChildInfoLength)
    for i = 1, #ChildTargets do
        local ChildInfo = ChildInfos[i]
        self:SetTargetContent(ChildTargets[i], ChildInfo.Name, ChildInfo.Value, IsIntervalBg)
        IsIntervalBg = not IsIntervalBg
    end
end

function WBP_Abyss_Settle_P_C:InitTargetContents(Data_Widget, LenNum)
    local Targets = {}
    for i=1, LenNum do
        local Target_Widget = self:CreateWidgetNew("DungeonSettlementTarget")
        Data_Widget.SubTitle:AddChildToVerticalBox(Target_Widget)
        Targets[i] = Target_Widget
    end
    return Targets
end

function WBP_Abyss_Settle_P_C:SetTargetContent(Target, TextMain, TextNumber, IsHideBg)
    Target.Text_Main:SetText(TextMain)
    if TextNumber then
        Target.Text_Number:SetText(MiscUtils.Round(TextNumber))
    end
    if IsHideBg then
        Target.Bg:SetVisibility(ESlateVisibility.Collapsed)
    else
        Target.Bg:SetVisibility(ESlateVisibility.HitTestInvisible)
    end
end


------- 副本已到结算界面 赛季结束需要退出的逻辑
function WBP_Abyss_Settle_P_C:OnAbyssSeasonEnd(AbyssSeasonId)
    -- 策划要求，赛季结束时退出副本，不返回委托界面
    GWorld.GameInstance:ClearExitDungeonData()

    local Params = {}
	Params.RightCallbackFunction = function()
		self:Exit()
	end
	UIManager(self):ShowCommonPopupUI(100225, Params)
end


--------------------------------------------------------------- 手柄相关---------------------------------------------------------------

function WBP_Abyss_Settle_P_C:InitDeviceInfo()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(self.GameInputModeSubsystem)) then
        self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end
end

function WBP_Abyss_Settle_P_C:InitListenEvent()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self,self.RefreshOpInfoByInputDevice)
    end
end

function WBP_Abyss_Settle_P_C:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    --更新输入模式
    self.CurInputDeviceType = CurInputDevice
    self.CurGamepadName = CurGamepadName
    --更新UI
    self:UpdateBtnUI()
end

function WBP_Abyss_Settle_P_C:UpdateBtnUI()
    self:InitBtnUI()
    self:UpdateQuitIcon()
    self:UpdateBattleDataIcon()
    self:SetFocus()
end

--更新战斗数据手柄图标
function WBP_Abyss_Settle_P_C:UpdateBattleDataIcon()
    if self.CurInputDeviceType == ECommonInputType.MouseAndKeyboard or self.CurInputDeviceType == ECommonInputType.Touch then
        self.Controller_CombatData:SetVisibility(ESlateVisibility.Collapsed)
    else
        self.Controller_CombatData:SetVisibility(ESlateVisibility.Visibility)
        self.QuitKeyInfo = {
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "View",
                },
            },
        }
        self.Controller_CombatData:CreateCommonKey(self.QuitKeyInfo)
    end
end

--更新退出手柄图标
function WBP_Abyss_Settle_P_C:UpdateQuitIcon()
    if not self.Key_Controller_Quit then
        return
    end
    self.QuitKeyInfo = {
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "X",
            },
        },
    }
    self.Key_Controller_Quit:CreateCommonKey(self.QuitKeyInfo)
    if self.CurInputDeviceType == ECommonInputType.MouseAndKeyboard or self.CurInputDeviceType == ECommonInputType.Touch then
        self.Key_Controller_Quit:SetVisibility(ESlateVisibility.Collapsed)
    else
        self.Key_Controller_Quit:SetVisibility(ESlateVisibility.Visibility)
    end
end

--修改按钮图标
function WBP_Abyss_Settle_P_C:InitBtnUI()
    if self.CurInputDeviceType == ECommonInputType.Touch or self.CurInputDeviceType == ECommonInputType.MouseAndKeyboard then
        self.Key_Controller_Node:SetVisibility(ESlateVisibility.Collapsed)
    else
        self.Key_Controller_Node:SetVisibility(ESlateVisibility.Visible)
    end
end

--PC监听
function WBP_Abyss_Settle_P_C:Handle_OnPCDown(InKeyName)
    if (InKeyName == "Escape") then -- 防止呼出esc菜单
        return true
    end
    return false
end

--手柄监听
function WBP_Abyss_Settle_P_C:Handle_OnGamePadDown(InKeyName)
    if (InKeyName == "Gamepad_FaceButton_Top") then -- 下一关
        if self.Btn_NextStage:IsVisible() then
            self.Btn_NextStage:OnBtnClicked()
            self:OnNextLevel()
        end
        return true
    elseif (InKeyName == "Gamepad_FaceButton_Left") then --重新挑战
        self.Btn_Anew_L:OnBtnClicked()
        self.Btn_Anew:OnBtnClicked()
        self:OnReplay()
        return true
    elseif (InKeyName == "Gamepad_FaceButton_Right") then --退出到关卡信息界面
        self.Btn_Quit:OnBtnClicked()
        self:ReturnLevelInfoUI()
        return true
    elseif (InKeyName == "Gamepad_Special_Right") then --跳转关卡
        -- if self.CanJump then
        --     if not self.NameEditDialog then
        --         self.Btn_Node:SlateHandleClicked()
        --         self:JumpToDungeon()
        --     elseif self.NameEditDialog.IsClosing then
        --         self.Btn_Node:SlateHandleClicked()
        --         self:JumpToDungeon()
        --     end
        -- end
        return true
    elseif (InKeyName == "Gamepad_Special_Left") then
        self:OnBtnChangePanelClicked()
    end
    return false
end

--监听PC/手柄按键
function WBP_Abyss_Settle_P_C:OnKeyDown(MyGeometry, InKeyEvent)
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        DebugPrint("WBP_Abyss_Settle_P_C:Key_IsGamepadKey", InKeyName)
        IsEventHandled = self:Handle_OnGamePadDown(InKeyName)
    else
        DebugPrint("WBP_Abyss_Settle_P_C:Key_IsPC", InKeyName)
        IsEventHandled = self:Handle_OnPCDown(InKeyName) 
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()    
    end
end

return WBP_Abyss_Settle_P_C
