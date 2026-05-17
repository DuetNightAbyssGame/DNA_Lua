local FriendCommon = {}

FriendCommon.UIName = "FriendMain"
FriendCommon.DialogName = "FriendDialog"
FriendCommon.ReddotName = "NewFriendRequest"

--region 好友弹窗和页签枚举
FriendCommon.FriendDialogType = {
    FriendRequest= -1, --好友申请
    BlackList = -2, --黑名单
}

FriendCommon.FriendTabType = {
    MyFriend = 1, --我的好友
    AddFriend = 2, --添加好友
    RecentMatch = 3, --最近匹配
    RegionFriend = 4, --区域可添加好友
}
FriendCommon.EmptyItem = 0
--endregion

FriendCommon.MainUIId = 14

--region 公共弹窗枚举
FriendCommon.DeleteDialog = 100078
FriendCommon.PullBlackDialog = 100076
FriendCommon.RejectAllDialog = 100077

FriendCommon.RemarkDialogNotInput = 100085

FriendCommon.RequestDialogNotInput = 100086
--endregion

--region 请求/事件定义
FriendCommon.EventId = {
    RefreshFriend = "RefreshFriend",
    AddFriend = "AddFriend",
    AgreeAdd = "AgreeAdd",
    RefuseAdd = "RefuseAdd",
    DeleteFriend = "DeleteFriend",
    SetRemark = "SetRemark",
    SetStar = "SetStar",
    Search = "Search",
    AddBlackList = "AddBlackList",
    CancelBlackList = "CancelBlackList",
    AgreeAll = "AgreeAll",
    RefuseAll = "RefuseAll",
    GetRecommandList = "GetRecommandList",
    RecommandCdUpdate = "RecommandCdUpdate",
    UpdateMatchList = "UpdateMatchList",
    BlockUI = "BlockUI",
    UnblockUI = "UnblockUI",
    UpdateOneFriend = "UpdateOneFriend",
    RefreshMatchFriend = "RefreshMatchFriend",
    RefreshMatchFriendUI = "RefreshMatchFriendUI",
}
--endregion

_G.FriendCommon = FriendCommon
return FriendCommon