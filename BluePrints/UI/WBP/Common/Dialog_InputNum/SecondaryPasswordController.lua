local SecondaryPasswordModel = require("BluePrints.UI.WBP.Common.Dialog_InputNum.SecondaryPasswordModel")
local GMVariable = require "BluePrints.UI.GMInterface.GMVariable"

---@class SecondaryPasswordController:Controller
local M = Class("BluePrints.Common.MVC.Controller")

---生命周期相关

function M:Init()
    M.Super.Init(self)
end

function M:Destroy()
    M.Super.Destory(self)
end

---生命周期相关End

-- 安全执行回调
local function SafeExecute(CallbackData, ...)
    if not CallbackData then return end
    
    if type(CallbackData) == "table" and CallbackData.Func then
        if CallbackData.Obj then 
            CallbackData.Func(CallbackData.Obj, ...)
        else
            CallbackData.Func(...)
        end
    elseif type(CallbackData) == "function" then
        CallbackData(...)
    end
end

---打开界面相关

-- 请求进行一次二级密码验证
-- @param Callbacks: { OnSuccess = function, OnCancel = function }
function M:RequestSecPasswordValidation(Callbacks)
    Callbacks = Callbacks or {}
    local OnSuccess = Callbacks.OnSuccess
    local OnCancel = Callbacks.OnCancel

    if not self:CheckSecondaryPasswordEnabled() then
        SafeExecute(OnSuccess, "")
        return
    end

    if self:CheckPreLoginValidateOnce() and SecondaryPasswordModel:GetSecondaryPasswordIsValidateThisLogin() then
        SafeExecute(OnSuccess, "")
        return
    end

    return self:OpenSecondaryPasswordValidatePopup(
        -- ConfirmCB
        {
            Obj = self,
            Func = function(_, Password)
                SafeExecute(OnSuccess, Password)
            end
        },
        -- CancelCB
        {
            Obj = nil,
            Func = function()
                SafeExecute(OnCancel)
            end
        }
    )
end

--开启/关闭二级密码
--@param bTargetState: boolean 目标状态 (true=开, false=关)
--@param Callbacks: table { OnSuccess, OnCancel }
function M:RequestChangePasswordStatus(bTargetState, Callbacks)
    Callbacks = Callbacks or {}
    local function TriggerSuccess() SafeExecute(Callbacks.OnSuccess) end
    local function TriggerCancel()  SafeExecute(Callbacks.OnCancel) end

    if bTargetState then
        local Params = {}
        Params.LeftCallbackFunction = TriggerCancel
        Params.CloseBtnCallbackFunction = TriggerCancel
        Params.RightCallbackFunction = function()
            self:OpenSecondaryPasswordSetPopup(
                -- ConfirmCB
                {
                    Obj = self,
                    Func = function(_, Password)
                        self:EnableSecondaryPassword(function(Ret)
                            if Ret == ErrorCode.RET_SUCCESS then
                                TriggerSuccess()
                            else
                                TriggerCancel()
                            end
                        end, Password)
                    end
                },
                -- CancelCB
                { Obj = nil, Func = TriggerCancel }
            )
        end
        UIManager():ShowCommonPopupUI(100312, Params)

    else
        self:OpenSecondaryPasswordDisablePopup(
            -- ConfirmCB
            {
                Obj = self,
                Func = function(_, Password)
                    local ConfirmParams = {}
                    ConfirmParams.LeftCallbackFunction = TriggerCancel
                    ConfirmParams.CloseBtnCallbackFunction = TriggerCancel
                    ConfirmParams.RightCallbackFunction = function()
                        self:DisableSecondaryPassword(function(Ret)
                            if Ret == ErrorCode.RET_SUCCESS then
                                UIManager():ShowUITip(UIConst.Tip_CommonToast, GText("UI_SecPwd_TurnoffToast"))
                                TriggerSuccess()
                            else
                                TriggerCancel()
                            end
                        end, Password)
                    end
                    UIManager():ShowCommonPopupUI(100314, ConfirmParams)
                end
            },
            -- CancelCB
            { Obj = nil, Func = TriggerCancel }
        )
    end
end

--开启/关闭二级密码首次验证功能
function M:RequestChangeValidateOnceStatus(bTargetState, Callbacks)
    Callbacks = Callbacks or {}
    local function TriggerSuccess() SafeExecute(Callbacks.OnSuccess) end
    local function TriggerCancel()  SafeExecute(Callbacks.OnCancel) end

    self:OpenSecondaryPasswordValidatePopup(
        -- ConfirmCB
        {
            Obj = self,
            Func = function(_, Password)
                if bTargetState then
                    self:EnableSecondaryPasswordValidateOnce(function(Ret)
                        if Ret == ErrorCode.RET_SUCCESS then TriggerSuccess() else TriggerCancel() end
                    end, Password)
                else
                    self:DisableSecondaryPasswordValidateOnce(function(Ret)
                        if Ret == ErrorCode.RET_SUCCESS then TriggerSuccess() else TriggerCancel() end
                    end, Password)
                end
            end
        },
        -- CancelCB
        { Obj = nil, Func = TriggerCancel }
    )
end

--打开二级密码二次确认弹窗
function M:OpenSecondaryPasswordEnablePopup()
    UIManager():ShowCommonPopupUI(100312)
end

--打开二级密码冷却弹窗
function M:OpenSecondaryPasswordColdDownPopup(Callback)
    local TimeStr = TimeUtils.TimeToYMDHMStr(SecondaryPasswordModel:GetSecondaryPasswordFreezeTimeStamp())
    local ReplaceText = string.format(GText("UI_SecPwd_WrongPwdLock"), TimeStr)
    local Params = {}
    Params.ShortText = ReplaceText
    Params.RightCallbackFunction = function()
        if Callback and Callback.Func then
            if Callback.Obj then
                Callback.Func(Callback.Obj)
            else
                Callback.Func()
            end
        end
    end
    return UIManager():ShowCommonPopupUI(100315, Params)
end

--打开二级密码设置弹窗
function M:OpenSecondaryPasswordSetPopup(ConfirmCB, CancelCB)
    UIManager(self):LoadUINew("CommonNumInput", UIConst.InputNumMode.ENABLE_PWD, {
        ConfirmCB = ConfirmCB,
        CancelCB = CancelCB,
    })
end

--打开二级密码关闭弹窗
function M:OpenSecondaryPasswordDisablePopup(ConfirmCB, CancelCB)
    if self:CheckSecondaryPasswordFreeze() then
        self:OpenSecondaryPasswordColdDownPopup(CancelCB)
        return
    end
    UIManager(self):LoadUINew("CommonNumInput", UIConst.InputNumMode.DISABLE_PWD, {
        ConfirmCB = ConfirmCB,
        CancelCB = CancelCB,
    })
end

--打开二级密码验证弹窗
function M:OpenSecondaryPasswordValidatePopup(ConfirmCB, CancelCB)
    if self:CheckSecondaryPasswordFreeze() then
        return self:OpenSecondaryPasswordColdDownPopup(CancelCB)
    end
    return UIManager(self):LoadUINew("CommonNumInput", UIConst.InputNumMode.VERIFY_PWD, {
        ConfirmCB = ConfirmCB,
        CancelCB = CancelCB,
    })
end

---打开界面相关End

-- 检查二级密码是否开启
function M:CheckSecondaryPasswordEnabled()
    return SecondaryPasswordModel:GetSecondaryPasswordEnabled()
end

function M:CheckPreLoginValidateOnce()
    return SecondaryPasswordModel:GetSecondaryPasswordPreLoginValidateOnce()
end

function M:GetSecondaryPasswordErrorTimes()
    return SecondaryPasswordModel:GetSecondaryPasswordErrorTimes()
end

function M:CheckSecondaryPasswordFreeze()
    local FreezeTimeStamp = SecondaryPasswordModel:GetSecondaryPasswordFreezeTimeStamp()
    if FreezeTimeStamp == nil then
        return false
    end
    local CurrentTime = TimeUtils:NowTime()
    return CurrentTime <= FreezeTimeStamp
end

function M:GetModel()
    return SecondaryPasswordModel
end

function M:GetEventName()
    return ""
end

--region RPC

function M:EnableSecondaryPassword(Callback, Password)
    local Avatar = self:GetAvatar()
    if not Avatar then
        return
    end
    Avatar:SecondaryPasswordSwitch(Callback, true, false, Password)
end

function M:DisableSecondaryPassword(Callback, Password)
    local Avatar = self:GetAvatar()
    if not Avatar then
        return
    end
    Avatar:SecondaryPasswordSwitch(Callback, false, false, Password)
end

function M:DisableSecondaryPasswordValidateOnce(Callback, Password)
    local Avatar = self:GetAvatar()
    if not Avatar then
        return
    end
    Avatar:SecondaryPasswordSwitch(Callback, true, false, Password)
end

function M:EnableSecondaryPasswordValidateOnce(Callback, Password)
    local Avatar = self:GetAvatar()
    if not Avatar then
        return
    end
    Avatar:SecondaryPasswordSwitch(Callback, true, true, Password)
end

function M:ValidateSecondaryPasswordOnce(Callback, Password)
    local Avatar = self:GetAvatar()
    if not Avatar then
        return
    end
    Avatar:ClientSecondaryPasswordValidateOnce(Callback, Password)
end

--endregion

-- 武器解锁验证二级密码
function M:Weapon_OpenSeconderyPassword(WeaponUuid, View)
    local Callback={
        OnSuccess = function(Password)
            if View then
                View:SetFocus()
                View:BlockAllUIInput(true)
            end
            self:GetAvatar():UnLockResourceInBag(CommonConst.AllType.Weapon, WeaponUuid)
        end,
        OnCancel = function()
            if View then
                View:SetFocus()
            end
        end,
    }

    self:RequestSecPasswordValidation(Callback)
end

-- 宠物解锁验证二级密码
function M:Pet_OpenSeconderyPassword(PetUuid, View)
    local Callback={
        OnSuccess = function(Password)
            if View then
                View:SetFocus()
                View:BlockAllUIInput(true)
            end
            self:GetAvatar():UnLockPet(PetUuid)
        end,
        OnCancel = function()
            if View then
                View:SetFocus()
            end
        end,
    }

    self:RequestSecPasswordValidation(Callback)
end

_G.SecondaryPasswordController = M

return M
