local ModModel = require "BluePrints.UI.WBP.Armory.Mod.Utils.ModModel"
local ModDatas =  require("BluePrints.UI.WBP.Armory.Mod.Utils.ModDatas")
local SelectedStuff = ModDatas.SelectedStuff

---@class ModController:Controller
local M=Class("BluePrints.Common.MVC.Controller")

M._components = {
    "BluePrints.UI.WBP.Armory.Mod.Utils.ModController_CopyModeComp",
}

--region 生命周期
function M:Init()
    M.Super.Init(self)
    self.CurrUIName = nil
    self.GM_RecommendLimit = true
end

function M:GetModel()
    return ModModel
end

function M:GetEventName()
    return EventID.ModControllerEvent
end

function M:Destory()
    self:StopPolarityEditTimer()
    self:TryAbortAutoEquip()
    self:TryAbortImport()
    self.CurrUIName = nil
    M.Super.Destory(self)
end
--endregion

--region UI操作
function M:TryOpenOverCostWarningDialog(Mod,PreviewLevel,Callback, DialogOwner)
    local Res = ModModel:GetOtherModUserOverCostMsg(Mod, PreviewLevel)
    if not table.isempty(Res) then
        local MsgLines = {}
        for _, Msg in ipairs(Res) do
            local Msg1 = string.format("<H>%s</>",Msg[1])
            local Msg2 = string.format("<H>%s</>",Msg[2])
            table.insert(MsgLines, string.format(GText("UI_MOD_Limit_Exceed_SubText"),Msg1,Msg2))
        end
        local DialogId = ModCommon.LevelUpWarningDialog
        local ConfLongText = GText(DataMgr.CommonPopupUIContext[DialogId].PopoverText) or ""
        local Params = {
            LongText = string.format("%s\n%s", ConfLongText,table.concat(MsgLines, "\n")),
            RightCallbackFunction = Callback,
            bTextCenter = true,
        }
        UIManager(self):ShowCommonPopupUI(DialogId, Params, DialogOwner)
    else Callback() end
end

function M:OpenSeconderyPassword(ModUuid, View)
    local Callback={
        OnSuccess = function(Password)
            if View then
                View:BlockAllUIInput(true)
            end
            self:GetAvatar():UnLockResourceInBag(CommonConst.AllType.Mod, ModUuid)
        end,
    }
    SecondaryPasswordController:RequestSecPasswordValidation(Callback)
end

function M:OpenView(UIName, ...)
    self.CurrUIName = UIName
    return M.Super.OpenView(self, self:GetUIMgr(), UIName,...)
end

function M:OpenModIntensify()
    local SelectedMod = ModModel:GetCurrSelectMod()
    local SelectStuff = ModModel:GetSelectStuff()
    if not SelectedMod or not SelectStuff then 
        DebugPrint(ErrorTag, LXYTag, "没有Mod被选中，无法打开升级界面")
        return 
    end
    if SelectedMod:IsFinalMaxLevel() then 
        DebugPrint(ErrorTag, LXYTag, "Mod满级了，无法打开升级界面")
        return
    end
    local Params = {BehaviourType = ModCommon.Enhance}
    if not SelectedMod:IsOriginalMaxLevel() then
        Params.BehaviourType = ModCommon.LevelUp
    end
    return M.Super.OpenView(self, nil, ModCommon.ModIntensifyMain, 
        SelectedMod:GetTypeName(),  SelectedMod, nil, Params)
end

function M:GetView(WorldContext, UIName)
    if not UIName then UIName = self.CurrUIName end
    return M.Super.GetView(self, WorldContext, UIName)
end

function M:OnCloseView()
    self:NotifyEvent(ModCommon.EventId.OnModMainUIClose, self.CurrUIName)
    self:SetSelectedStuff(nil, nil)
    ModModel:ResetUIData()
    self.CurrUIName = nil
end

function M:CreateDragUI(ModUuid)
    local DragUI = self:GetUIMgr():_CreateWidgetNew(ModCommon.DragUIName)
    DragUI:InitAsDragUI(ModUuid)
    return DragUI
end

function M:WarningTipsWhileSlotLock(SlotUIData)
    if not ModModel:IsModUINormal() then return end
    local Target = ModModel:GetTarget()
    if not Target then return end
    local ConfInfo = Target:Data()
    local UnlockLevel = ConfInfo.ModSlotUnlock and ConfInfo.ModSlotUnlock[SlotUIData.SlotId] or nil
    local Tips = GText("UI_MOD_SLOT_LOCK_REMINDER")
    if UnlockLevel and UnlockLevel ~= Const.InVaildModUnlockLevel then
        Tips = string.format(GText("UI_MOD_SLOT_UNLOCK_CONDITION"),UnlockLevel)
    end
    self:ShowToast(Tips)
end

function M:SetUICamera(Offset)
    local ArmoryUI = self:GetUIMgr():GetArmoryUIObj()
    if not IsValid(ArmoryUI) then return end
    if Offset then
        ArmoryUI.ActorController:SetExCameraOffset(Offset)
    end
    local Target = ModModel:GetTarget()
    local Tag = Target:GetTypeName()
    local Type = Tag
    if Type == CommonConst.DataType.Weapon then
        if Target:IsMelee() then
            Tag = CommonConst.ArmoryTag.Melee 
        elseif Target:IsRanged() then
            Tag = CommonConst.ArmoryTag.Ranged
        end
    elseif Type == CommonConst.ArmoryTag.UWeapon then
        Type = CommonConst.DataType.Weapon
    end
    ArmoryUI.ActorController:SetMontageAndCamera(Type, Tag, CommonConst.ArmoryType.Mod)
end

function M:GetModAttachBoneVPos()
    ---@type APlayerCharacter
    local ArmoryPlayer = self:GetUIMgr():CreateOrGetArmoryPlayerActor()
    if not IsValid(ArmoryPlayer) then return end
    if not ArmoryPlayer.Mesh:DoesSocketExist("spine_03") then
        return
    end
    local BonePos = ArmoryPlayer.Mesh:GetSocketLocation("spine_03")
    if not self.BoneVPos then
        self.BoneVPos = FVector2D(0,0)
    else
        self.BoneVPos.X, self.BoneVPos.Y  = 0, 0
    end
    local Controller = UE4.UGameplayStatics.GetPlayerController(ArmoryPlayer, 0)
    UGameplayStatics.ProjectWorldToScreen(Controller, BonePos, self.BoneVPos)
    local VPScale = UWidgetLayoutLibrary.GetViewportScale(self)
    self.BoneVPos.X = self.BoneVPos.X-4*VPScale
    self.BoneVPos.Y = self.BoneVPos.Y-5*VPScale
    return self.BoneVPos
end
--endregion

--region 与Avatar通信
function M:_ParseFuncName(FuncNameFormat,Target)
    local TargetClsName = Target:GetTypeName()
    if TargetClsName == "UWeapon" then
        TargetClsName = "Weapon"
    end
    return string.format(FuncNameFormat,TargetClsName)
end

function M:_RecvCommon(Ret, TargetUuid, SuitIndex)
    if Ret == ErrorCode.RET_MOD_APPLY_SLOT_ERROR then
        self:ShowToast(GText("UI_Toast_ModType_Wrong"))
        return false
    end
    if not self:CheckError(Ret) then
        return false
    end
    local Target = ModModel:GetTarget()
    if not Target then
        Utils.Traceback(ErrorTag, "这个时候的Target不可能为空")
        return false
    end
    if Target.Uuid ~=TargetUuid then
        Utils.Traceback(ErrorTag, "回调的Uuid和当前Target不一致")
        return false
    end
    self:SyncTarget(TargetUuid, SuitIndex)

    return true
end

--切换魔之楔套装
function M:SendChangeSuit(Target,ModSuitIndex)
    if ModModel:GetTarget().ModSuitIndex == ModSuitIndex then 
        return 
    end
    if ModModel:IsInImport() then
        ModModel.ImportData.bTakeOff = true
    end
    local FuncName = self:_ParseFuncName("Change%sModSuit",Target)
    local CallbackInfo = {Func=self.RecvChangeSuit, Obj=self}
    self:GetAvatar()[FuncName](self:GetAvatar(), CallbackInfo, Target.Uuid, ModSuitIndex)
end
function M:RecvChangeSuit(Ret, TargetUuid, ModSuitIndex)
    if not self:_RecvCommon(Ret, TargetUuid, ModSuitIndex) then
        return
    end
    if not ModModel:IsInImport() then
        self:NotifyEvent(ModCommon.EventId.OnChangeModSuit, TargetUuid, ModSuitIndex)
    else
        ModModel.ImportData.bTakeOff = false
        ModModel.ImportData:ResumeImport()
    end
end

--魔之楔槽位互换装配
function M:SendExchangeMod(Target, OldSlotId, NowSlotId)
    local FuncName = self:_ParseFuncName("Exchange%sMod", Target)
    local CallbackInfo = {Func = self.RecvExchangeMod, Obj=self}
    self:GetAvatar()[FuncName](self:GetAvatar(), CallbackInfo, Target.Uuid, Target.ModSuitIndex,OldSlotId,NowSlotId)
end
function M:RecvExchangeMod(Ret, TargetUuid, SuitIndex, OldSlotId, NowSlotId)
    if not self:_RecvCommon(Ret, TargetUuid, SuitIndex) then
        return
    end
    local SlotUIData1 = ModModel:GetSlotUIData(OldSlotId)
    if SlotUIData1 then
        SlotUIData1:SetModEid(SlotUIData1:GetSlot().ModEid)
    end
    local SlotUIData2 = ModModel:GetSlotUIData(NowSlotId)
    if SlotUIData2 then
        SlotUIData2:SetModEid(SlotUIData2:GetSlot().ModEid)
    end
    self:NotifyEvent(ModCommon.EventId.OnExchangeMod, TargetUuid, SuitIndex, OldSlotId, NowSlotId)
end

--魔之楔普通装配
function M:SendChangeMod(Target, SlotId, ModUuid)
    if not ModModel:IsInImport() and not self:CheckSpecificSlot(ModUuid, SlotId, true) then
        self:TryAbortAutoEquip()
        return
    end
    local FuncName = self:_ParseFuncName("Change%sMod", Target)
    local Avatar = self:GetAvatar()
    local TakeOffModUuid = ModModel:GetModSlot(Target,SlotId).ModEid
    TakeOffModUuid = ModModel:IsModUuidValid(TakeOffModUuid) and TakeOffModUuid
    local CallbackInfo = {Func = self.RecvChangeMod, Obj=self, ExParams={TakeOffModUuid}}
    Avatar[FuncName](Avatar, CallbackInfo, Target.Uuid, Target.ModSuitIndex, SlotId, ModUuid)
end
function M:RecvChangeMod(Ret, TargetUuid, SuitIndex, ModSlotId, ModUuid, TakeOffModUuid)
    if Ret == ErrorCode.RET_MOD_IS_REPEAT then
        self:CheckModRepeat(ModUuid)
        self:TryAbortAutoEquip()
        return
    end
    if not self:_RecvCommon(Ret, TargetUuid, SuitIndex) then
        self:TryAbortAutoEquip()
        self:TryAbortImport()
        return
    end
    if not ModModel:IsInImport() then
        local SlotUIData = ModModel:GetSlotUIData(ModSlotId)
        if SlotUIData then
            SlotUIData:SetModEid(ModUuid)
        end
        self:TryForceCalcSlotsCost(ModUuid, false)
        self:TryForceCalcSlotsCost(TakeOffModUuid, true)
        ModModel:GenerateModRepeatData(TakeOffModUuid)
        local SelectedStuff = ModModel:GetSelectStuff()
        if SelectedStuff and SelectedStuff.SlotId == ModSlotId then
            SelectedStuff.ModUuid = ModUuid
        end
        self:NotifyEvent(ModCommon.EventId.OnChangeMod, TargetUuid, SuitIndex, ModSlotId, ModUuid,TakeOffModUuid)
        if ModModel:IsInAutoEquip() then
            ModModel.AutoEquipData:ResumeAutoEquip()
        end
    else
        ModModel.ImportData:ResumeImport()
    end
end

--卸下魔之楔
function M:SendTakeOffMod(Target, SlotId)
    local SlotUIData = ModModel:GetSlotUIData(SlotId)
    if SlotUIData:IsPendingTakeOff() then return end
    SlotUIData:MarkPendingTakeOff(true)
    local FuncName = self:_ParseFuncName("TakeOff%sMod", Target)
    local TakeOffModUuid = ModModel:GetModSlot(Target,SlotId).ModEid
    TakeOffModUuid = ModModel:IsModUuidValid(TakeOffModUuid) and TakeOffModUuid
    local CallbackInfo = {Func = self.RecvTakeOffMod, Obj=self, ExParams={TakeOffModUuid}}
    self:GetAvatar()[FuncName](self:GetAvatar(), CallbackInfo, Target.Uuid, Target.ModSuitIndex,SlotId)
end
function M:RecvTakeOffMod(Ret, TargetUuid, SuitIndex, SlotId, TakeOffModUuid)
    local SlotUIData = ModModel:GetSlotUIData(SlotId)
    SlotUIData:MarkPendingTakeOff(false)
    if not self:_RecvCommon(Ret, TargetUuid, SuitIndex) then
        return
    end
    if SlotUIData then
        SlotUIData:SetModEid(nil)
    end
    self:TryForceCalcSlotsCost(TakeOffModUuid, true)
    local SelectedStuff = ModModel:GetSelectStuff()
    if SelectedStuff and SelectedStuff.SlotId == SlotId then
        SelectedStuff.ModUuid = nil
    end
    self:NotifyEvent(ModCommon.EventId.OnTakeOffMod, TargetUuid, SuitIndex, SlotId,TakeOffModUuid)
end

function M:SendTakeOffAllMod(Target)
    local FuncName = self:_ParseFuncName("TakeOffAll%sMod", Target)
    local CallbackInfo = {Func = self.RecvTakeOffAllMod, Obj=self}
    local Avatar = self:GetAvatar()
    Avatar[FuncName](Avatar, CallbackInfo, Target.Uuid, Target.ModSuitIndex)
end
function M:RecvTakeOffAllMod(Ret ,TargetUuid, SuitIndex)
    if not self:_RecvCommon(Ret, TargetUuid, SuitIndex) then
        self:TryAbortAutoEquip()
        self:TryAbortImport()
        return
    end
    ModModel:GenerateSlotUIDatas(SuitIndex)
    self:NotifyEvent(ModCommon.EventId.OnTakeOffSuitMod, TargetUuid, SuitIndex)
    if ModModel:IsInAutoEquip() then
        ModModel.AutoEquipData.bTakeOff = false
        ModModel.AutoEquipData:ResumeAutoEquip()
    end
    if ModModel:IsInImport() then
        ModModel.ImportData.bTakeOff = false
        ModModel.ImportData:ResumeImport()
    end
end

--槽位极性变更
function M:SendPolarityEdit(Target)
    if not ModModel:IsInPolarityEditMode() then
        DebugPrint(ErrorTag, "SendPolarityEdit 没有极性编辑数据时不执行该操作")
        return
    end
    local ModSlotList,PolarityList = {},{}
    for i=1, #ModModel.PolarityEditModeData.DirtySlots do
        local SlotUIData = ModModel.PolarityEditModeData.DirtySlots[i]
        table.insert(ModSlotList, SlotUIData.SlotId)
        table.insert(PolarityList, SlotUIData:GetPolarity())
    end
    local FuncName = self:_ParseFuncName("Change%sModSlotListPolarity", Target)
    local CallbackInfo = {Func = self.RecvPolarityEdit, Obj=self}
    self:GetAvatar()[FuncName](self:GetAvatar(), CallbackInfo, Target.Uuid, ModSlotList, PolarityList)
    self.PolarityEditTimer= self:AddTimer(5, function()
        self.PolarityEditTimer = nil
        self:ShowToast(GText("UI_Toast_NetDelay"))
        self:NotifyEvent(ModCommon.EventId.OnPolarityEditFailed)
    end)
end
function M:RecvPolarityEdit(Ret, TargetUuid, ModSlotList, PolarityList)
    if not self:IsExistTimer(self.PolarityEditTimer) then
        return
    end
    if not self:_RecvCommon(Ret, TargetUuid) then
        self:StopPolarityEditTimer()
        self:NotifyEvent(ModCommon.EventId.OnPolarityEditFailed)
        return
    end
    for _, SlotUIData in ipairs(ModModel.PolarityEditModeData.DirtySlots) do
        if SlotUIData.bOverCost then
            self:TryForceCalcSlotsCost(SlotUIData.ModEid, true)
        end
    end
    ModModel.PolarityEditModeData:ApplyAllEditPolarity()
    self:StopPolarityEditTimer()
    self:NotifyEvent(ModCommon.EventId.OnPolarityEditDone, TargetUuid, nil)
end

function M:SendEditSuitName(Target, NewName)
    local FuncName = self:_ParseFuncName("Update%sModSuitName", Target)
    local CallbackInfo = {Func = self.RecvEditSuitName, Obj=self}
    self:GetAvatar()[FuncName](self:GetAvatar(), CallbackInfo, Target.Uuid, Target.ModSuitIndex, NewName)
end
function M:RecvEditSuitName(Ret, TargetUuid, ModSuitIndex, NewName)
    if not self:_RecvCommon(Ret,TargetUuid, ModSuitIndex) then
        return
    end
    self:NotifyEvent(ModCommon.EventId.OnSuitNameEdited, TargetUuid, ModSuitIndex, NewName)
end

---魔之楔升级
function M:SendModLevelUp(Mod, ExpectLevel, bTakeOff)
    local CallbackInfo = {Func=self.RecvModLevelUp, Obj=self, ExParams={bTakeOff}}
    self:GetAvatar():ModLevelUp(CallbackInfo, Mod.Uuid, Mod.Level,ExpectLevel)
end
function M:RecvModLevelUp(Ret, OldModUuid, NewModUuid, bTakeOff)
    if not self:_RecvCommon(Ret, ModModel:GetTarget().Uuid) then
        return
    end
    local OldSelectedStuff = ModModel:GetSelectStuff()
    assert(OldSelectedStuff)
    local NewSelectedStuff = nil
    if NewModUuid ~= OldModUuid then
        NewSelectedStuff = SelectedStuff.New()
        NewSelectedStuff.ModUuid = NewModUuid
        local OldMod = ModModel:GetMod(OldModUuid)
        if not OldMod or OldMod.Count ==0 then
            ModModel:RemoveMod(OldModUuid)
        end
        ModModel:AddMod(NewModUuid)
    end
    if OldSelectedStuff:IsSlot() then
        local SlotUIData = ModModel:GetSlotUIData(OldSelectedStuff.SlotId)
        if bTakeOff then
            SlotUIData:SetModEid(nil)
            self:TryForceCalcSlotsCost(NewModUuid, true)
            if not NewSelectedStuff then
                NewSelectedStuff = SelectedStuff.New()
                NewSelectedStuff.ModUuid=NewModUuid
            end
        else
            SlotUIData:SetModEid(NewModUuid)
            ---@todo 万一Mod升级之后减耗的效果增强了呢... 先留着，后面可能用的上
            --self:TryForceCalcSlotsCost(NewModUuid, false)
            if NewSelectedStuff then
                NewSelectedStuff.SlotId = OldSelectedStuff.SlotId
                OldSelectedStuff.SlotId = nil 
                -- NewSelectedStuff存在，说明升级产生新Mod，那在槽位上升级产生的老Mod得计算一下冲突关系
                if NewSelectedStuff:IsSlot() and OldModUuid then
                    ModModel:GenerateModRepeatData(OldModUuid)
                end
            end
        end
    end
    if NewSelectedStuff then
        ModModel:SetSelectedStuff(NewSelectedStuff.ModUuid, NewSelectedStuff.SlotId)
    end
    self:NotifyEvent(ModCommon.EventId.OnModLevelUp, OldModUuid, NewModUuid, bTakeOff, NewSelectedStuff, OldSelectedStuff)
end

---魔之楔增幅
function M:SendModCardLevelUp(Mod, Comsumers, bTakeOff)
    local CallbackInfo = {Func=self.RecvModCardLevelUp, Obj=self, ExParams={bTakeOff}}
    self:GetAvatar():ModCardLevelUp(CallbackInfo, Mod.Uuid, Comsumers)
end
function M:RecvModCardLevelUp(Ret, ModUuid, Consumers, bTakeOff)
    if not self:_RecvCommon(Ret, ModModel:GetTarget().Uuid) then
        return
    end
    local RemoveUuids= {}
    local TakeOffSlotIds = {}
    for ModId, Value in pairs(Consumers) do
        for Uuid, Count in pairs(Value) do
            if not ModModel:GetMod(Uuid) then
                local SlotIds = ModModel:GetSlotIdsWhichEquiped(Uuid) or {}
                for _,SlotId in ipairs(SlotIds) do
                    local SlotUIData = ModModel:GetSlotUIData(SlotId)
                    SlotUIData:SetModEid(nil)
                    table.insert(TakeOffSlotIds, SlotId)
                end
                ModModel:RemoveMod(Uuid)
                table.insert(RemoveUuids, Uuid)
            end
        end
    end
   
    self:NotifyEvent(ModCommon.EventId.OnModCardLevelUp, ModUuid, Consumers,TakeOffSlotIds,RemoveUuids)
    self:RecvModLevelUp(Ret, ModUuid ,ModUuid, bTakeOff)
end
--endregion

--region 极性编辑模式
function M:EditSlotPolarity(Polarity)
    local SelectedStuff = ModModel:GetSelectStuff()
    if not SelectedStuff:IsSlot() then return end
    ModModel.PolarityEditModeData:EditSlotPolarity(Polarity)
    self:NotifyEvent(ModCommon.EventId.OnPendingEditSlotPolarity, SelectedStuff.SlotId)
end

function M:StopPolarityEditTimer()
    if self:IsExistTimer(self.PolarityEditTimer) then
        self:StopTimer(self.PolarityEditTimer)
        self.PolarityEditTimer = nil
    end
end

function M:RevertAllSlotPolarity()
    ModModel.PolarityEditModeData:RevertAllSlotPolarity()
    self:NotifyEvent(ModCommon.EventId.OnRevertEditSlotPolarity)
end

function M:StartPolarityEditMode()
    ModModel:StartPolarityEditMode()
    self:NotifyEvent(ModCommon.EventId.OnStartPolarityMode)
end

function M:StopPolarityEditMode()
    ModModel:StopPolarityEditMode()
    self:NotifyEvent(ModCommon.EventId.OnStopPolarityMode)
end
--endregion

--region 自动装配
function M:StopAutoEquipTimer()
    if self:IsExistTimer(self.AutoEquipTimeOutKey) then
        self:StopTimer(self.AutoEquipTimeOutKey)
        self.AutoEquipTimeOutKey = nil
    end
end

function M:LaunchAutoEquipMod(ModSuitCopyInfo)
    self:StopAutoEquipTimer()
    if ModSuitCopyInfo then
        local TargetType = ModModel.TargetType
        local Target = ModModel:GetTarget()
        if TargetType ~= ModSuitCopyInfo.TargetInfo[1] then
            ModController:ShowToast(GText("UI_Mod_ImportError_WrongType"))
            self:NotifyEvent(ModCommon.EventId.OnModSuitCopyFaild)
            return
        end
        if Target[TargetType.."Id"] ~= ModSuitCopyInfo.TargetInfo[2] then
            ModController:ShowToast(GText("UI_Mod_ImportError_WrongTarget"))
            self:NotifyEvent(ModCommon.EventId.OnModSuitCopyFaild)
            return
        end
        self.ModSuitCopyInfo = ModSuitCopyInfo
    end
    self.AutoEquipTimeOutKey = self:AddTimer(500000, function()
        ModModel:StopAutoEquip()
        self.AutoEquipTimeOutKey = nil
        ForceStopAsyncTask(self, "AutoEquipModTask")
        self:CheckError(ErrorCode.RET_MOD_AUTOPUTON_FAILD)
        self:NotifyEvent(ModCommon.EventId.OnAutoEquipTimeOut)
    end)
    RunAsyncTask(self, "AutoEquipModTask", self.AutoEquipModTaskFunc)
end

---@param self ModController
function M.AutoEquipModTaskFunc(CoroutineObj, self)
    ModModel:StartAutoEquip(CoroutineObj, self.ModSuitCopyInfo)
    self:TakeOffSuitMod()
    if ModModel.AutoEquipData.bTakeOff then
        coroutine.yield()
    end
    local SlotIds = {}
    local AllowConflictSlots = {}
    for SlotId , _ in pairs(ModModel.CurSlots) do
        table.insert(SlotIds,SlotId)
    end
    table.sort(SlotIds, ModModel.SortSlotForAutoEquip)
    ---@param SlotUIData ModSlotUIData
    for _, SlotId in ipairs(SlotIds) do
        local SlotUIData = ModModel.CurSlots[SlotId]
        if SlotUIData:InState(ModCommon.SlotState.Lock) then
            goto continue
        end
        local bFilterAll = ModModel.AutoEquipData.bAllSlotPolarized or SlotUIData:IsAura()
        local Mod = ModModel:PickSuitableModForSlot(SlotUIData, bFilterAll)
        if Mod == 0 then
            table.insert(AllowConflictSlots, SlotId)
            goto continue
        end
        if not Mod then
            if SlotUIData:GetPolarity() ~= CommonConst.NonePolarity or self.ModSuitCopyInfo then
                goto continue
            else break end
        end
        self:SendChangeMod(ModModel:GetTarget(), SlotId, Mod.Uuid)
        coroutine.yield()
        ::continue::
    end
    table.sort(AllowConflictSlots, ModModel.SortSlotForAutoEquip)
    for _, SlotId in ipairs(AllowConflictSlots) do
        local SlotUIData = ModModel.CurSlots[SlotId]
        local Mod = ModModel:PickSuitableModForSlot(SlotUIData, true)
        if not Mod or Mod ==0 then
            if SlotUIData:GetPolarity() ~= CommonConst.NonePolarity or self.ModSuitCopyInfo then
                goto continue2
            else break end
        end
        self:SendChangeMod(ModModel:GetTarget(), SlotId, Mod.Uuid)
        coroutine.yield()
        ::continue2::
    end
    ModModel:StopAutoEquip()
    self:StopAutoEquipTimer()
    self.ModSuitCopyInfo = nil
    self:NotifyEvent(ModCommon.EventId.OnAutoEquipFinished)
end

function M:TryAbortAutoEquip()
    if ModModel:IsInAutoEquip() then
        ModModel:StopAutoEquip()
        self:StopAutoEquipTimer()
        ForceStopAsyncTask(self, "AutoEquipModTask")
        self:NotifyEvent(ModCommon.EventId.OnAutoEquipAbort)
    end
end
--endregion

--region 其他
function M:TryForceCalcSlotsCost(ExcludeModUuid, bTakeOff)
    if not ModModel:IsModUuidValid(ExcludeModUuid) then return end
    local ExcludeMod = ModModel:GetMod(ExcludeModUuid)
    if not ExcludeMod then return end
    --槽位上变更的Mod是有减耗效果时，需要强制计算其他槽位的耐受值
    if not ExcludeMod.ReducePolarityEffect and not ExcludeMod.AddCharModCost then return end
    local DirtySlotIds = ModModel:ForceCalcSlotsCost(ExcludeModUuid, bTakeOff)
    if not table.isempty(DirtySlotIds) then
        self:NotifyEvent(ModCommon.EventId.OnForceCalcSlotsCost, DirtySlotIds)
    end
end

function M:SetSelectedStuff(ModUuid, SlotId)
    --DebugPrint(LXYTag, "ModController:SetSelectedStuff",CommonUtils.ObjId2Str(ModUuid),SlotId)
    local LastSelectedStuff = ModModel:GetSelectStuff()
    if LastSelectedStuff
         and (ModModel:IsInPolarityEditMode() or ModUuid == LastSelectedStuff.ModUuid)
         and SlotId == LastSelectedStuff.SlotId then
        return
    end
    ModModel:SetSelectedStuff(ModUuid, SlotId)
    local NowSelectedStuff = ModModel:GetSelectStuff()
    if NowSelectedStuff or LastSelectedStuff then
        if ModModel:IsInPolarityEditMode() then
            self:NotifyEvent(ModCommon.EventId.OnPolarityModSelectedChanged,  NowSelectedStuff, LastSelectedStuff)
        else
            self:NotifyEvent(ModCommon.EventId.OnSelectStuffChanged, NowSelectedStuff, LastSelectedStuff)
        end
    end
end

function M:CheckSpecificSlot(ModUuid, SlotId, bShowError)
    if bShowError==nil then bShowError = true end
    if not ModModel:IsSpecificSlot(ModUuid, SlotId) then
        if bShowError then
            self:ShowToast(GText("UI_Toast_ModType_Wrong"))
        end
        return false
    end
    return true
end

function M:CheckModRepeat(ModUuid, bWarning)
    if bWarning == nil then bWarning = true end
    local Mod = ModModel:GetMod(ModUuid)
    if Mod.ConflictUuids:Length()>0 then
        local ModNames = {}
        local ConflictSlotIds = {}
        for _, ConflictUuid in ipairs(Mod.ConflictUuids) do
            local ConflictMod = ModModel:GetMod(ConflictUuid)
            assert(ConflictMod, "ModController:CheckModRepeat 发现了一个致命错误",ConflictUuid)
            local Name = string.format("<H>%s</>",GText(ConflictMod:Data().Name))
            ModNames[Name] = 1
            local SlotIds = ModModel:GetSlotIdsWhichEquiped(ConflictUuid) or {}
            for _,SlotId in ipairs(SlotIds) do
                table.insert(ConflictSlotIds, SlotId)
            end
        end
        if bWarning then
            local ModMsg = {}
            for Name, _ in pairs(ModNames) do
                table.insert(ModMsg, Name)
            end
            self:CheckError(ErrorCode.RET_MOD_IS_REPEAT,true,table.concat(ModMsg, "|"))
            self:NotifyEvent(ModCommon.EventId.OnFoundModRepeat, ConflictSlotIds)
        end
        return false
    end
    return true
end
--endregion

--region 快速装配和卸载
function M:QuickEquipMod(ModUuid)
    if ModModel:IsBugMod(ModUuid) then return end
    self:SetSelectedStuff(nil,nil)
    local SortedSlotList = ModModel:CalcQuickEquipSlotsList(ModUuid)
    if not next(SortedSlotList) then
        self:ShowToast(GText("UI_Mod_Toast_NoMatchedSlot"))
        return
    end
    if not self:CheckModRepeat(ModUuid) then
        return
    end
    local Case = ModCommon.CalcVolumeDiffCase.Change
    local Target = ModModel:GetTarget()
    for _, SlotUIData in ipairs(SortedSlotList) do
        local Res = ModModel:CalcModVolumeDiff(Case, Target, SlotUIData.SlotId, ModUuid)
        if Res then
            self:SendChangeMod(Target, SlotUIData.SlotId, ModUuid)
            return
        end
    end
    self:CheckError(ErrorCode.RET_MOD_OVER_CHAR_MODVOLUME)
end

function M:TakeOffSuitMod(Target)
    self:SetSelectedStuff(nil, nil)
    local bAnyModEquiped = ModModel:IsAnyModEquiped()
    ---@param SlotUIData ModSlotUIData
    if ModModel:IsInAutoEquip() then
        for SlotId, SlotUIData in pairs(ModModel.CurSlots) do
            if SlotUIData:InState(ModCommon.SlotState.Lock) then
                goto continue1
            end
            if SlotUIData:GetPolarity() == CommonConst.NonePolarity then
                ModModel.AutoEquipData.bAllSlotPolarized = false
            end
            ::continue1::
        end
        ModModel.AutoEquipData.bTakeOff = bAnyModEquiped
    end
    if ModModel:IsInImport() then
        ModModel.ImportData.bTakeOff = bAnyModEquiped
    end
    if bAnyModEquiped then
        self:SendTakeOffAllMod(Target or ModModel:GetTarget())
    end
end
--endregion

--region 同步target
function M:_SyncTargetImpl(OldTarget, NewTarget, SuitIndex)
    if OldTarget and OldTarget.Uuid==NewTarget.Uuid then
        if SuitIndex and NewTarget.ModSuitIndex ~= SuitIndex then
            DebugPrint(ErrorTag, LXYTag, "ModTarget的ModSuitIndex不一致，我认为这是服务端bug，打印一个报错日志保留现场")
        end
        NewTarget.ModSuitsCostMap = OldTarget.ModSuitsCostMap
        NewTarget.ModSuitIndex = SuitIndex or OldTarget.ModSuitIndex
    end
    ModModel:SetTarget(NewTarget)
    return
end

---Target数据引用可能会随rpc方法调用而发生变化，需要手动同步一下
function M:SyncTarget(TargetUuid,SuitIndex)
    local OldTarget = ModModel:GetTarget()
    local Char = self:GetAvatar().Chars[TargetUuid]
    if Char then
        self:_SyncTargetImpl(OldTarget, Char, SuitIndex)
        return
    end
    local Weapon = self:GetAvatar().UWeapons[TargetUuid] or self:GetAvatar().Weapons[TargetUuid]
    if Weapon then
        self:_SyncTargetImpl(OldTarget, Weapon, SuitIndex)
        return
    end
end
--endregion

_G.ModController = M
AssembleComponents(M)
return M