
local M = Class("BluePrints.Common.MVC.Model")

local DefaultBatchSize = 10

ERankType = {
    Hot = 0,
    Fresh = 1,
    MyLike = 2,
}

function M:Init()
    M.Super.Init(self)
    self.BatchSize = nil         
    self.FetchIdx = 1
    self.FetchType = nil
    self.CachedContentMap = {}
end

function M:Destory()
    M.Super.Destory(self)
    self.BatchSize = nil
    self.FetchIdx = nil
    self.FetchType = nil
    self.CachedContentMap = nil
end

---@param BatchSize int 一次拉取的图片数量
function M:SetBatchSize(size)
    if type(size) ~= "number" or size < 0 then return end
    self.BatchSize = size
end

function M:GetPhotoData(PhotoId)
    return self.CachedContentMap and self.CachedContentMap[PhotoId]
end

function M:SavePhotoData(PhotoId, Content)
    if self.CachedContentMap then
        self.CachedContentMap[PhotoId] = Content
    end
end

function M:DeletePhotoData(PhotoId)
    if self.CachedContentMap then
        self.CachedContentMap[PhotoId] = nil
    end
end

function M:GetMyFoolsDayPhotoIds()
    return self:GetAvatar():GetMyFoolsDayPhotoIds()
end

function M:FetchPhotoDocs(PhotoIds, Callback, TotalCallback)
    self:GetAvatar():FoolsDayGetPhotoData(PhotoIds, function(PhotoDocs)
        if TotalCallback then
            TotalCallback(PhotoDocs)
        end
        if not PhotoDocs then return end
        self.CachedContentMap = self.CachedContentMap or {}
        for _, PhotoDoc in ipairs(PhotoDocs) do
            local PhotoId = PhotoDoc.PhotoId
            local Content = self.CachedContentMap[PhotoId]
            if Content then
                if PhotoDoc then
                    PhotoDoc.LikeCountDetails = PhotoDoc.LikeCountDetails or {}
                end
                Content.PhotoDoc = PhotoDoc
                if Callback then
                    Callback(Content, PhotoDoc)
                end
            end
        end
    end)
end

function M:UpdatePhotoDoc(PhotoId, PhotoDoc)
    self.CachedContentMap = self.CachedContentMap or {}
    if not self.CachedContentMap[PhotoId] then return end
    PhotoDoc.LikeCountDetails = PhotoDoc.LikeCountDetails or {}
    self.CachedContentMap[PhotoId].PhotoDoc = PhotoDoc
end

function M:StartFetchHottest(BatchSize)
    self.FetchType = ERankType.Hot
    self.FetchIdx = 1
    self:SetBatchSize(BatchSize)
end

function M:StartFetchFreshest(BatchSize)
    self.FetchType = ERankType.Fresh
    self.FetchIdx = 1
    self:SetBatchSize(BatchSize)
end

function M:FetchMyLikeFoolsDayPhotoIds()
    local MyFoolsDayLikePhotosDict = self:GetAvatar().FoolsDayLikeRecord
    local LikedPhotoIds = MyFoolsDayLikePhotosDict:Keys()
    return LikedPhotoIds
end

function M:FetchBatch(Callback)
    if not self.FetchType or not self.FetchIdx then return nil end
    local FetchIdx = self.FetchIdx
    local BatchSize = self.BatchSize or DefaultBatchSize
    if self.FetchType == ERankType.Fresh then
        self.FetchIdx = self.FetchIdx + BatchSize
        return self:GetAvatar():FoolsDayGetFreshestRankList(FetchIdx, BatchSize, Callback)
    elseif self.FetchType == ERankType.Hot then
        self.FetchIdx = self.FetchIdx + BatchSize
        return self:GetAvatar():FoolsDayGetLikeRankList(FetchIdx, BatchSize, Callback)
    end
    return nil
end


return M