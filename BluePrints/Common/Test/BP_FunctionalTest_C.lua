--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

local BP_FunctionalTest_C = Class()

function BP_FunctionalTest_C:ReceivePrepareTest()
    self.bHasError = false
end

function BP_FunctionalTest_C:ReceiveStartTest()
    local ClassPath = self:GetCallClassPath()
    local FunctionName = self:GetCallFunctionName()
    local TestClass = require(ClassPath)
    self:_FinishIfClassInvalid(TestClass)

    local TestObj = TestClass.New()
    local TestFunc = TestObj[FunctionName]
    self:_FinishIfTestFuncInvalid(TestFunc)

    

    TestFunc(TestObj, self)
end

function BP_FunctionalTest_C:_GetTestPath(LabelArray)
    local TestPath = ""
    for i = 1, #LabelArray - 1 do
        TestPath = TestPath .. "." .. LabelArray[i]
    end

    return "Test" .. TestPath
end

function BP_FunctionalTest_C:_FinishIfLabelArrayInvalid(LabelArray)
    if LabelArray == nil or type(LabelArray) ~= "table" or #LabelArray < 2 then
        self:FinishTest(EFunctionalTestResult.Failed, "RunTest Failed! Error TestActor Label: " .. self:GetActorLabel())
    end
end

function BP_FunctionalTest_C:_FinishIfClassInvalid(TestClass)
    if TestClass == nil then
        self:FinishTest(EFunctionalTestResult.Failed, "RunTest Failed! Can't find target file: " .. self:GetActorLabel())
        return
    end

    if TestClass.New == nil or type(TestClass.New) ~= "function" then
        self:FinishTest(EFunctionalTestResult.Failed, "RunTest Failed! Can't create test object, New function not found: " .. self:GetActorLabel())
        return
    end
end

function BP_FunctionalTest_C:_FinishIfTestFuncInvalid(TestFunc)
    if TestFunc== nil or type(TestFunc) ~= "function" then
        self:FinishTest(EFunctionalTestResult.Failed, "Test function not found: ")
    end
end

function BP_FunctionalTest_C:ReceiveTick(DeltaSeconds)
    -- TODO Delay Test
end

function BP_FunctionalTest_C:Finish()
    if not self.bHasError then
        self:FinishTest(EFunctionalTestResult.Succeeded, "Test passed!")
    else
        self:FinishTest(EFunctionalTestResult.Failed, "Test failed!")
    end
end

function BP_FunctionalTest_C:Assert(Actual, Expect, Message)
    if Actual ~= Expect then
        self.bHasError = true
        self:AddError("Assertion failed! [" .. tostring(Actual) .. "] ~= [" .. tostring(Expect) .. "] Message: " .. Message)
        self:AddError(debug.traceback())
    end
end

function BP_FunctionalTest_C:SetTimeout(Timeout)
    self:SetTimeLimit(Timeout, EFunctionalTestResult.Failed)
end

-- TODO
-- 1.支持延迟测试
-- 2.lua调用报错会触发测试失败
-- 3.显示报错调用栈
-- 4.自动化驱动程序
-- 5.怎么获取一个UI(Slate) 的严格意义上的可见性
-- 6.等场景跟角色准备完再开始
-- 7.单元测试

return BP_FunctionalTest_C
