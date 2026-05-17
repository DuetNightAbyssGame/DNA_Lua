require "UnLua"

-- 通用弹窗的辅助脚本基类，可以用来访问通用弹窗本身
-- 使用 self.Contents[i] 或者通用弹窗样式表中Content名称来访问弹窗的Content控件
-- 使用 self.Tips[i] 或者通用弹窗样式表中的Tip名称来访问弹窗的Tip控件

local Common_Dialog_LuaModel_Base = setmetatable({}, {
    __index = function(t, k) 
        local DialogWidget = rawget(t, "DialogWidget")
        local Result = nil
        if DialogWidget then
            if DialogWidget[k] then 
                Result = DialogWidget[k]
            end
            
            local ContentWidget = DialogWidget:GetContentWidgetByName(k)
            if ContentWidget then 
                Result = ContentWidget
            end

            -- rawset(t, k, Result)
            return Result
        end
    end,

    __newindex = function(t, k, v)
        local DialogWidget = rawget(t, "DialogWidget")
        if DialogWidget then
            DialogWidget[k] = v
        else
            rawset(t, k, v)
        end
    end
})

-- 可在子类重写此方法，当弹窗关闭时，会执行这个方法，并把返回值传入回调中，用于收集弹窗表单信息
function Common_Dialog_LuaModel_Base:PackageData()
    return nil
end

function Common_Dialog_LuaModel_Base:BindDialogWidget(PopupId, DialogWidget)
    self.DialogWidget = DialogWidget
    self.PopupId = PopupId
end

function Common_Dialog_LuaModel_Base:Initialize()
    DebugPrint("Tianyi@ 弹窗 " .. tostring(self.PopupId) .. " 未定义初始化方法!")
end

return Common_Dialog_LuaModel_Base
