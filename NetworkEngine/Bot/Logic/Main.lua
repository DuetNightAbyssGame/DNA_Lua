local MainCo = {}

function MainCo:MainCo()
    --启动间隔控制并发
    self:CoSleep((self.ID-UE.URobotInstance.GetIntFromCMD("-LogicRobotStartID=")) * 0.1)

    self:MainCoNewAccountLoopLogin()

    -- self:MainCoBattle() -- 进地图成功
    -- self:MainCoSendRecorderRpc() -- 读取文件并发送rpc
    -- self:WaitMsg("EntityMessage".."BattleFinish")

    self:log("MainCo done")
end

function MainCo:MainCoNewAccountLoopLogin()
    while true do
        self:MainCoLogin() -- 登录 完成

        self:DisConnect() -- 断开连接

        self:CoSleep(2)
    end
end


return MainCo