    --- 联机动作常量相关
local OnlineActionCommon = {


---------------策划相关---------------------
-- 附近可邀请的玩家距离 
NearbtPlayDistance=800,
--拒绝所有邀请的按键
RejectAllKey="N",
--刷新所有邀请的按键
RefreshAllKey="R",
--打开界面的快捷键
OpenOnlineActionPageKey="F5",
--自动拒绝的时间 单位S --服务端有限制时间30s，需要小于这个值不然显示会错误
AutoRejectTime=25,


-------------程序配置-----------------------
UIName = "ActionOnline",
OnlineActionBtnBPPath="WidgetBlueprint'/Game/UI/WBP/Battle/Widget/Online_Action/WBP_Battle_OnlineActionBtn.WBP_Battle_OnlineActionBtn'",
-- OnlineActionCommon.EditUIName="
RefreshAllCD=1, --刷新比较消耗性能，加个内置CD
NearbySearchCooldown=5, --如果打开界面时和做动作的间隔小于这个值，便不查询，因为做动作时已经查询了一次
MaxNearbyPlayers=50, --附近玩家最大数量,找到这个数便不再寻找
UseSyncNearbyPlayers=true, --是否使用多线程寻找可邀请玩家
----------- 服务器错误码
    -- 区域联机
    RET_ONLINE_REGION_NOT_EXIST = 52001, -- 区域联机位面不存在
    RET_ONLINE_REGION_STATUS_ERROR = 52002, -- 区域联机位面状态错误
    RET_ONLINE_REGION_NO_CURRENT_CHARACTER = 52003, -- 区域联机位面没有当前角色
    RET_ONLINE_REGION_LOCK = 52004, -- 区域联机位面未解锁
    RET_ONLINE_REGION_ALREADY_ENTER = 52005, -- 重复进入
    RET_ONLINE_REGION_ALREADY_LEAVE = 52006, -- 重复离开
    RET_ONLINE_REGION_CLOSE = 52007, -- 区域联机位面已关闭
    RET_ONLINE_REGION_SENDER_NOT_EXIST = 52008, -- 区域不存在该玩家
    RET_ONLINE_NOT_CREATE_ITEM = 52009, --区域不存在该创建的机关物品
    RET_ONLINE_NOT_CREATE_TARGET_ITEM = 52010, -- 当前区域玩家未创建目标物品
    RET_ONLINE_NOT_EXIST_INTERACTIVE_ID= 52011, -- 不存在该唯一ID机关
    RET_ONLINE_ITEM_READY_USE_PLAYER = 52012, ---该机关已经被他人占用
    RET_ONLINE_OWNER_NOT_USE_ITEM = 52013, -- 物品创建者不能使用机关
    RET_EXIST_USE_REGION_IETM_REQUEST = 52015, -- 存在物品使用请求
    RET_ONLINE_REQUEST_TIMEOUT = 52016, -- 请求超时
    RET_ONLINE_NOT_EXIST_USE_RESOURCE_ID = 52017, --- 不存在使用的资源ID
    RET_ONLINE_NOT_CREATE_MECHANISM = 52018, -- 不能创建机关
    RET_ONLINE_NOT_CREATE_TARGET_MOUNT = 52019, --- 没有创建该目标坐骑
    RET_ONLINE_GLOBAL_ITEM_NOT_EXIST = 52020, --- 不存在该索引的全局机关
    RET_ONLINE_OWNER_NOT_ONLINE = 52021, --- 主机玩家不在线
    RET_ONLINE_RECEIVE_ONT_ONLINE = 52022, --- 消息接收方不在线
    RET_ONLINE_LEAVE_ITEM_NOT_STATE_COMPONENT = 52023, --- 不存在交互信息

}


return OnlineActionCommon
