local Class = _G.TypeClass
local PropUtils = require "BluePrints.Client.PropUtils"

---@class BaseType
local BaseType = Class("BaseType")
	BaseType.default = nil
	BaseType.IsBaseType = true
	BaseType.IsCustomType = false
	BaseType.IsMeta = 0

	function BaseType:GetDefault()
		return PropUtils.DeepCopy(self.default)
	end

	function BaseType:Init(...) end

	function BaseType:_Init() end

	function BaseType:tostring(value)
		return tostring(value)
	end

	function BaseType:GetTypeName()
		return self.__Name__
	end

	function BaseType:convert(data)
		if data == nil then
			return data
		end
		return self:load(data)
	end

	function BaseType:load(value)
		return value
	end

	function BaseType:save_dump(value)
		return value
	end

	function BaseType:client_dump(value)
		return value
	end

	function BaseType:cross_dump(value)
		return value
	end

	function BaseType:all_dump(value)
		return value
	end
	function BaseType:binary_dump(value)
		return value
	end

	function BaseType:proto_convert(data)
		if data == nil then
			return data
		end
		return self:proto_load(data)
	end

	function BaseType:proto_load(value)
		return self:load(value)
	end

	function BaseType:proto_save_dump(value)
		return self:save_dump(value)
	end

	function BaseType:proto_client_dump(value)
		return self:client_dump(value)
	end

	function BaseType:proto_all_dump(value)
		return self:all_dump(value)
	end

	function BaseType:SetOwnerInfo(value, owner, prop)
	end

local ObjId = Class("ObjId", BaseType)
	ObjId.default = ""
	function ObjId:load(value)
		if type(value) == "string" and PropUtils.IsObjIdStr(value) then
			return GWorld.IdManager.Str2ObjId(value)
		end
		return value
	end

	function ObjId:client_dump(value)
		if type(value) == "string" and PropUtils.IsObjId(value) then
			return PropUtils.ObjId2Str(value)
		end
		return value
	end

	function ObjId:cross_dump(value)
		return self:client_dump(value)
	end

	function ObjId:tostring(value)
		return PropUtils.ObjId2Str(value)
	end

local Str = Class("Str", BaseType)
	Str.default = ""
	function Str:load(value)
		return tostring(value)
	end

local Int = Class("Int", BaseType)
	Int.default = 0
	function Int:load(value)
		return math.ceil(tonumber(value))
	end

local Float = Class("Float", BaseType)
	Float.default = 0
	function Float:load(value)
		return tonumber(value)
	end

local Bool = Class("Bool", BaseType)
	Bool.default = false
	function Bool:load(value)
		return value == true
	end

local Bytes = Class("Bytes", BaseType)
	Bytes.default = ""
	function Bytes:load(value)
		if type(value) ~= "string" then
			assert(false, "Bytes:load value must be string")
		end

		if #value < 4 then
			assert(false, "Bytes:load value length must be greater than 4")
		end

		return string.sub(value, 4)
	end

	function Bytes:save_dump(value)
		local bson = require "bson"
		return bson.binary(value)
	end


local List = Class("List", BaseType)
	List.default = {}
	function List:load(value)
		if type(value) == "table" then
			return value
		end
	end

local Dict = Class("Dict", BaseType)
	Dict.default = {}
	function Dict:load(value)
		if type(value) == "table" then
			return value
		end
	end

---@class BaseTypes
local BaseTypes = {
	BaseType = BaseType,
	ObjId = ObjId,
	Str = Str,
	Int = Int,
	Float = Float,
	Bool = Bool,
	Bytes = Bytes,
	List = List,
	Dict = Dict,
}

return BaseTypes
