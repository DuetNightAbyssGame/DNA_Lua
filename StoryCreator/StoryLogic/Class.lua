--------------------------------------------------------------------------------
--
--        Partial implementation of the Python Class model for Lua
--
--                   Copyright (c) 2012, Jonathan Zrake
--					https://gist.github.com/jzrake/4410474
--------------------------------------------------------------------------------
--
-- Exports the following functions:
-- 
-- + Class
-- + Super 
-- + IsClass
-- + IsInstance
-- + IsSubClass
-- + GetAttrib
-- + SetAttrib
-- + ClassName
-- + Mro (method resolution order)
-- + GetAttrib
-- + SetAttrib
-- 
-- and the following Classes:
--
-- + Object
--
-- Classes support multiple inheritance and casting via super to any Base
-- Class. The method resolution order is depth-first. All Classes inherit from
-- Object.
--------------------------------------------------------------------------------

local ClassMeta = { }
local InstanceMeta = { }
local ClassModule = { }

--------------------------------------------------------------------------------
-- Private utility functions
--------------------------------------------------------------------------------
local function Deque()
--
-- Return an Object which acts as a minimal double-ended queue. That is, it
-- may be used as a queue or a stack by appropriate calls to the
-- [push|pop]_[front|back] functions. This function is only here to aid the
-- building of MRO's.
--
	local self = { }
	self._Items = { }
	self._Front = 0
	self._Back = 0
	function self:PushFront(Item)
		if Item == nil then
			error('cannot push nil onto the deque')
		end
		self._Front = self._Front - 1
		self._Items[self._Front] = Item
	end
	function self:PopFront()
		local Item = self._Items[self._Front]
		self._Items[self._Front] = nil
		if Item then
			self._Front = self._Front + 1
		end
		return Item
	end
	function self:PushBack(Item)
		if Item == nil then
		error('cannot push nil onto the deque')
		end
		self._Items[self._Back] = Item
		self._Back = self._Back + 1
	end
	function self:PopBack()
		local Item = self._Items[self._Back-1]
		self._Items[self._Back-1] = nil
		if Item then
			self._Back = self._Back - 1
		end
		return Item
	end
	function self:Size()
		return self._Back - self._Front
	end
	function self:Items()
		return pairs(self._Items)
	end
	function self:Empty()
		return not (next(self._Items) and true or false)
	end
	return self
end



--------------------------------------------------------------------------------
-- Module functions
--------------------------------------------------------------------------------
local function Class(Name, ...)
	local Base = {...}
	if #Base == 0 and Name ~= 'Object' then
		Base[1] = ClassModule.Object
	end
	
	local MroVec = { }
	local MroSet = { }
	local _NewClass = {}
	local Q = Deque()
	for i,b in ipairs(Base) do Q:PushBack(b) end
	
	table.insert(MroVec, _NewClass)
	while not Q:Empty() do
		local c = Q:PopFront()
		for _,b in ipairs(c.__Base__) do
			Q:PushBack(b)
		end
		if not MroSet[c] then
			MroSet[c] = c
			table.insert(MroVec, c)
		end
	end
	_NewClass.__Name__ = Name
	_NewClass.__ShortName__ = string.sub(Name, 1, -5)
	_NewClass.__Base__ = Base
	_NewClass.__Mro__ = MroVec
	_NewClass.__Dict__ = {}
	_NewClass.__Class__ = { __Dict__={}, __Mro__={}}

	setmetatable(_NewClass, ClassMeta)
	return _NewClass
end
local function NewClass(Super)
	if not Super then
		Super = ClassModule.Object
	end
	local Base = {Super}
	
	local MroVec = { }
	local MroSet = { }
	local _NewClass = {}
	local Q = Deque()
	for i,b in ipairs(Base) do Q:PushBack(b) end
	
	table.insert(MroVec, _NewClass)
	while not Q:Empty() do
		local c = Q:PopFront()
		for _,b in ipairs(c.__Base__) do
			Q:PushBack(b)
		end
		if not MroSet[c] then
			MroSet[c] = c
			table.insert(MroVec, c)
		end
	end
	-- _NewClass.__Name__ = Name
	-- _NewClass.__ShortName__ = string.sub(Name, 1, -5)
	_NewClass.__Base__ = Base
	_NewClass.__Mro__ = MroVec
	_NewClass.__Dict__ = {}
	_NewClass.__Class__ = { __Dict__={}, __Mro__={}}

	setmetatable(_NewClass, ClassMeta)
	return _NewClass
end
local function Super(Base, Instance)
	local Mro = Instance.__Class__.__Mro__
	local index = nil
	for i,v in ipairs(Mro) do
		if v == Base then
			index = i
			break
		end
	end
	if index and index < #Mro then
		return Mro[index+1]
	end
	-- returns nil if super call cannot be made
end
local function IsClass(c)
	return getmetatable(c) == ClassMeta
end

local function Resolve(obj, key)
	--
	-- Attempt to resolve attribute `key` of `obj` which may be a Class or
	-- instance. Recurse through __Base__ table breadth-first using the MRO, and
	-- return nil if attribute is not found. Do not invoke the __index__
	-- meta-method in doing so.
	--
	local val = obj.__Dict__[key] 
	if val == nil then
		val = obj.__Class__.__Dict__[key]
	end
	if val~=nil then return val end
	local Mro = obj.__Class__.__Mro__
	if IsClass(obj) then Mro = obj.__Mro__ end
	for _,b in ipairs(Mro) do
		val = b.__Dict__[key]
		if val~=nil then return val end
	end
	return nil
end

local function IsInstance(instance, Class)
	for _, c in ipairs(instance.__Class__.__Mro__) do
		if c == Class then return true end
	end
	return false
end
local function IsSubClass(instance, Base)
	return Super(Base, instance) and true or false
end
local function GetAttrib(instance, key)
	return Resolve(instance, key)
end
local function SetAttrib(instance, key, value)
	instance.__Dict__[key] = value
end
local function ClassName(A)
	return IsClass(A) and A.__Name__ or A.__Class__.__Name__
end
local function Mro(A)
	return A.__Mro__
end

--------------------------------------------------------------------------------
-- Class metatable
--------------------------------------------------------------------------------
function ClassMeta:__call(...)
	local Dict = { }
	local Base = { }
	for k,v in pairs(self.__Base__) do Base[k] = v end
	local new = setmetatable({__Name__=self.__Name__,
				 __ShortName__ = self.__ShortName__,
			     __Dict__=Dict,
			     __Class__=self,
			     __Base__=self.__Base__}, InstanceMeta)
	if GetAttrib(new, '__init__') then
		GetAttrib(new, '__init__')(new, ...)
	end
	return new
end
function ClassMeta:__index(key)
	return Resolve(self, key)
end
function ClassMeta:__newindex(key, value)
	self.__Dict__[key] = value
end
function ClassMeta:__tostring(key, value)
	return string.format('<Class: %s @ %s>', ClassName(self),
			string.sub(tostring(self.__Dict__), 8))
end

--------------------------------------------------------------------------------
-- Instance metatable
--------------------------------------------------------------------------------
function InstanceMeta:__index(key)
	local index = Resolve(self, '__index__')
	local def = Resolve(self, key)
	if type(index) == 'function' then return def or index(self, key)
	else return def or index[key]
	end
end
function InstanceMeta:__newindex(key, value)
	if self.__Dict__[key] then
		self.__Dict__[key] = value
	else
		Resolve(self, '__newindex__')(self, key, value)
	end
end
function InstanceMeta:__tostring()
	return Resolve(self, '__tostring__')(self)
end
function InstanceMeta:__pairs()
	return Resolve(self, '__pairs__')(self)
end
function InstanceMeta:__gc()
	return Resolve(self, '__gc__')(self)
end

--------------------------------------------------------------------------------
-- Object Class definition
--------------------------------------------------------------------------------
local Object = Class('Object')
function Object:__index__(key)
	return Resolve(self, key)
end
function Object:__newindex__(key, value)
	self.__Dict__[key] = value
end
function Object:__tostring__()
	return string.format('<Class instance: %s @ %s>', ClassName(self),
			string.sub(tostring(self.__Dict__), 8))
end
function Object:__pairs__()
	error('Object does not support iteration')
end
function Object:__call__()
	error('Object does not support call')
end
function Object:__gc__()
	-- warning! __gc__ is only triggered for the first resolved __gc__ method in
	-- the hierarchy.
end

--------------------------------------------------------------------------------
-- Class module definition
--------------------------------------------------------------------------------
ClassModule.Class = Class
ClassModule.NewClass = NewClass
ClassModule.Super = Super
ClassModule.IsClass = IsClass
ClassModule.IsInstance = IsInstance
ClassModule.IsSubClass = IsSubClass
ClassModule.GetAttrib = GetAttrib
ClassModule.SetAttrib = SetAttrib
ClassModule.ClassName = ClassName
ClassModule.Mro = Mro
ClassModule.Object = Object

return ClassModule
