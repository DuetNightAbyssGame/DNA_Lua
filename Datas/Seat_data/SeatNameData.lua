local function make_read_only(t)
	return setmetatable({}, {
		__index = t,
		__newindex = function() error('Attempt to modify read-only table') end,
	})
end

return make_read_only({
	"1011",
	"1011_Mobile",
	"1019",
	"1019_Mobile",
	"1041",
	"1041_Mobile",
	"1045",
	"1045_Mobile",
	"1049",
	"1049_Mobile",
	"9997",
	"Huaxu_Haojing_Reb_Main",
	"Huaxu_Haojing_Reb_Main_Mobile",
	"Huaxu_Haojing_YLX_Main",
	"Huaxu_Haojing_YLX_Main_Mobile",
	"RegionProfTest_Main",
	"SeatName2UniqueId",
	"SeatNameData",
	"SeatUniqueIdData",
})