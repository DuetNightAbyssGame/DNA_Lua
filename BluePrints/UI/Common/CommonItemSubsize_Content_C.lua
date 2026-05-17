--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@class Common_Item_subsize_PC_Content : Common_Item_subsize_PC_Content_C
local M = Class()

---@type Uuid ObjectId
---@type Id number
---@type UnitId number
---@type UnitName string
---@type Rarity number
---@type IsSelected bool
---@type IsLocked bool
---@type IsNew bool
---@type Type string
---@type Count number
---@type Level number
---@type Polarity number
---@type Star number
---@type GradeLevel number
---@type Cost number
---@type DetailsButtonClickCallback function 设定Item细节弹窗的按钮回调
---@type DetailsButtonText string Item细节弹窗的按钮文本

return M