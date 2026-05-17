
local Component = {}

function Component:GetAttr(AttrName)
	--local AttributeSet = self:K2_GetAttributesSet()
	--if AttributeSet and AttributeSet.DirtyAttrs:Contains(AttrName) then
	--	self:CalcAttr(AttrName)
	--end

	local IntValue = 0
	local IsInt = false
	local FloatValue = 0.0
	local IsFloat = false
	local StringValue = ""
	local IsString = false
	IntValue, IsInt, FloatValue, IsFloat, StringValue, IsString = self:GetAttrFromLua(AttrName)
	if IsInt then
		-- print('GetAttr',AttrName,IntValue)
		return IntValue
	elseif IsFloat then
		-- print('GetAttr',AttrName,FloatValue)
		return FloatValue
	elseif IsString then
		-- print('GetAttr',AttrName,StringValue)
		return StringValue
	else
		-- print('GetAttr',AttrName,nil)
		return nil
	end
end

function Component:SetAttr(AttrName, Value)
	if type(Value) == 'string' then
		self:SetAttrStringFromLua(AttrName, Value)
	elseif type(Value) == 'number' then
		self:SetAttrNumberFromLua(AttrName, Value)
	end
end

return Component
