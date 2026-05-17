local ClassMgr = require "NetworkEngine.Common.ClassManager"

local InstanceMeta = {}
local DictInstanceMeta = {}

local function new(t)
	local obj = {
		Super = t.Super,
		__IsClass__ = false,
		__Class__ = t,
		__Name__ = t.__Name__,
		Props = {},
	}
	setmetatable(obj, InstanceMeta)
	return obj
end

local function call(t, ...)
	local obj = {
		Super = t.Super,
		__IsClass__ = false,
		__Class__ = t,
		__Name__ = t.__Name__,
		Props = {},
	}
	setmetatable(obj, InstanceMeta)
	local InitFunc = t.Init
	if InitFunc then
		InitFunc(obj, ...)
	end
	return obj
end

local function Class(class_name, parent_class)
	local NewClass = {
		__IsClass__ = true,
		__Name__ = class_name,
		__New__ = new,
		Super = parent_class,
		Props = {},
		Getters = {},
	}

	if type(parent_class) == "table" then
		setmetatable(NewClass, {
			__index = parent_class,
			__call = call,
		})
	else
		setmetatable(NewClass, {
			__call = call,
		})
	end

	ClassMgr:RegisterClass(class_name, NewClass)
	return NewClass
end

local function IsClass(c)
	if rawget(c, "__IsClass__") == true then
		return true
	end
	return false
end

local function IsInstance(obj, class)
	if obj.__Class__ == class then
		return true
	end
	return false
end

local function IsSubClass(subclass, parent_class)
	if not subclass then
		return false
	end
	if rawget(subclass, "__IsClass__") == false then
		return false
	end
	if subclass.Super == parent_class then
		return true
	end
	return IsSubClass(subclass.Super, parent_class)
end

--------------------------------------------------------------------------------
-- Instance metatable
--------------------------------------------------------------------------------
function InstanceMeta:__index(key)
	if key == nil then
		return nil
	end
	local result = self.Props[key]
	if result ~= nil then
		return result
	end

	local prop = self.__Class__.Props[key]
	if prop then
		local _value = prop:GetDefault()
		self.Props[key] = _value
		return _value
	end

	local getter = self.__Class__.Getters[key]
	if getter then
		local attr = self.__Class__[getter.attr]
		if type(attr) == "table" then
			return attr[getter.name]
		elseif type(attr) == "function" then
			local funcVal = attr(self)
			if funcVal then
				return funcVal[getter.name]
			else
				if getter.attr == "Data" and not skynet and GWorld.GameInstance then
					local avatar = GWorld:GetAvatar()
					if avatar.bAccountBroken then
						return nil
					end
					avatar.bAccountBroken = true
					local account = avatar and avatar.Account or ""
					local log =string.format("::Error::  CustomType类Index错误 %s类的Data函数得到的结果是空的，%s 这个号废了，尝试换个新号，还是不行就更新你的客户端",self.__Class__.__Name__, account)
					ScreenPrint(log)
				end
				return nil
			end
		end
	end

	result = self.__Class__[key]
	rawset(self, key, result)
	return result
end

function InstanceMeta:__newindex(key, value)
	-- 属性
	local prop = self.__Class__.Props[key]
	if prop then
		local _value = prop:GetTypeInstance(value)
		self.Props[key] = _value
		-- if self._OnPropChange then
		-- 	self:_OnPropChange(prop, _value)
		-- end
		return
	end

	-- 其他
	rawset(self, key, value)
end


--------------------------------------------------------------------------------
-- Instance metatable
--------------------------------------------------------------------------------
function DictInstanceMeta:__index(key)
	if key == nil then
		return nil
	end
	local result = self._inner[key]
	if result ~= nil then
		return result
	end

	result = self.__Class__[key]
	rawset(self, key, result)
	return result
end

function DictInstanceMeta:__newindex(key, value)
	local KeyType = self.KeyType
	local ValueType = self.ValueType
	self._inner[KeyType:convert(key)] = ValueType:convert(value)
end

local function DictNext(table, key)
	return next(table._inner, key)
end

function DictInstanceMeta:__pairs(key)
	return DictNext, self, key
end



return {
	Class = Class,
	IsClass = IsClass,
	IsInstance = IsInstance,
	IsSubClass = IsSubClass,
	InstanceMeta = InstanceMeta,
	DictInstanceMeta = DictInstanceMeta,
}