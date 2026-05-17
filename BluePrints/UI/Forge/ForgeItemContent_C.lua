require "UnLua"
local ForgeConst = require "Blueprints.UI.Forge.ForgeConst"

--- @class ForgeItemContent
local ForgeItemContent = Class()

---@type Id @设计稿ID
ForgeItemContent.Id = nil

---@type Count @设计稿数量 
ForgeItemContent.Count = nil

---@type StartTime @设计稿开始时间
ForgeItemContent.StartTime = nil

---@type TotalTime @设计稿开始时间
ForgeItemContent.TotalTime = nil

---@type State @设计稿目前状态
ForgeItemContent.State = 0

---@type ProductCount @设计稿产物持有数量
ForgeItemContent.ProductCount = nil

---@type ProductNum @设计稿产物产出数量
ForgeItemContent.ProductNum = nil

---@type ResourcesNeed @需要的资源列表
ForgeItemContent.ResourcesNeed = {}

---@type CanProduce @设计稿能否制造
ForgeItemContent.CanProduce = false

---@type IsEmptyWidget @空的占位组件
ForgeItemContent.IsEmptyWidget = false


return ForgeItemContent