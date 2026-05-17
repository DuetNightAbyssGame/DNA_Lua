local SecondaryPasswordController = require("BluePrints.UI.WBP.Common.Dialog_InputNum.SecondaryPasswordController")
local Component = {}

function Component:EnterWorld()
    SecondaryPasswordController:Init()
end

function Component:LeaveWorld()
    SecondaryPasswordController:Destroy()
end

---@param callback function             --回调。错误码 ErrorCode.RET_SECONDARY_PASSWORD_ERROR
---@param switch boolean                --二级密码总开关
---@param onlyvalidateonce boolean      --是否开启每次登录仅验证一次
---@param password string               --修改或设置二级密码
function Component:SecondaryPasswordSwitch(callback, switch, onlyvalidateonce, password)
    self:CallServer("OnSecondaryPasswordSwitch", callback, switch, onlyvalidateonce, password)
end


function Component:SecondaryPasswordFreeze(timestamp)
    print("SecondaryPasswordFreeze: " .. timestamp)
end

function Component:ClientSecondaryPasswordValidateOnce(callback, password)
    self:CallServer("ClientSecondaryPasswordValidateOnce", callback, password)
end


-- function Component:RpcValidateOnce(callback, password)
--     self:CallServer("RpcValidateOnce", callback, password)
-- end

-- function Component:SetPassword(switch, onlyvalidateonce, password)
--     self:SecondaryPasswordSwitch(function(ErrorCode)
--             print("二级密码设置：")
--             print("switch = ".. tostring(switch))
--             print("onlyvalidateonce = ".. tostring(onlyvalidateonce))
--             print("password = "..password)
--             print("ErrorCode = "..ErrorCode)
            
--         end, switch, onlyvalidateonce, password)
-- end

-- function Component:ValidatePassword(password)
--     self:RpcValidateOnce(function(ErrorCode)
--         print("二级密码验证：")
--         print("ErrorCode = "..ErrorCode)
--     end, password)
-- end




return Component