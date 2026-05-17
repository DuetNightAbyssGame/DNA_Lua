local ETalkType = {}

if (not next(ETalkType)) then
	local TalkTypes = DataMgr.TalkType or {}
	for Type, _ in pairs(TalkTypes) do
		ETalkType[Type] = Type
	end
end

return ETalkType
