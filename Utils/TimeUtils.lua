local CommonConst = require "CommonConst"

local TimeUtils = {}

TimeUtils.StandardTimestamp = 0
TimeUtils.RemoveStandardOffset = 0
TimeUtils.TimeOffset = 0
-- TimeUtils.ServerTimeZone = nil
TimeUtils.RefreshHMS = {5,0,0}
TimeUtils.BeijingTimeZone = 8

local now = os.time()
TimeUtils.CurrentTimeZone = os.difftime(now, os.time(os.date("!*t", now))) / 3600


function TimeUtils.NowTime()
	if GWorld:GetAvatar() and TimeUtils.StandardTimestamp > 0 then
		return TimeUtils.StandardTimestamp + TimeUtils.GetStandardOffset()
	else
		return os.time() + TimeUtils.TimeOffset
	end
end

-- 获取当前时间戳（毫秒）
function TimeUtils.NowTimeMs()
	if GWorld:GetAvatar() and TimeUtils.StandardTimestamp > 0 then
		local Elapsed = UE4.UGameplayStatics.GetRealTimeSeconds(GWorld.GameInstance) - TimeUtils.RemoveStandardOffset
		if Elapsed < 0 then Elapsed = 0 end
		return math.floor((TimeUtils.StandardTimestamp + Elapsed) * 1000)
	else
		return (os.time() + TimeUtils.TimeOffset) * 1000
	end
end

function TimeUtils.RealTime()
	return os.time()
end

------------------------------------服务器时间戳同步 Begin------------------------------------------
-- 设置world标准时间戳 的基准值（与服务器一致）
function TimeUtils.SetStandardTimestamp(Timestamp)
	TimeUtils.StandardTimestamp = Timestamp or 0
end

-- 获取world下当前经过的时间偏移
function TimeUtils.GetStandardOffset()
	return math.floor(math.max(UE4.UGameplayStatics.GetRealTimeSeconds(GWorld.GameInstance) - TimeUtils.RemoveStandardOffset, 0))
end

-- 同步服务器时间戳时的world经过的时间偏移
function TimeUtils.SetStandardOffset()
	TimeUtils.RemoveStandardOffset = UE4.UGameplayStatics.GetRealTimeSeconds(GWorld.GameInstance)
end

-- World收到服务器消息重置本地时间
function TimeUtils.OnRequestSetNowTime(Timestamp)
	TimeUtils.SetStandardOffset()
	TimeUtils.SetStandardTimestamp(Timestamp)
end

-- World发起请求重置当前时间
function TimeUtils.RequestSetNowTime()
	local Avatar = GWorld:GetAvatar()
	local CheckTime = -1
	if Avatar then
		if TimeUtils.StandardTimestamp > 0 then
			CheckTime = TimeUtils.NowTime()
		end
		Avatar:RequestSetNowTime(CheckTime)
	end
end
------------------------------------服务器时间戳同步 End------------------------------------------


function TimeUtils.GetTimeOffset()
	return TimeUtils.TimeOffset
end

function TimeUtils.SetTimeOffset(offset)
	TimeUtils.TimeOffset = offset
end

function TimeUtils.SetServerTimeZone(TimeZone)
	DebugPrint("CZC,SetServerTimeZone",TimeZone)
	TimeUtils.ServerTimeZone = TimeZone
end

function TimeUtils.GetServerTimeZone()
	return TimeUtils.ServerTimeZone or 0
end

function TimeUtils.GetCurrentTimeZone()
	return TimeUtils.CurrentTimeZone
end

function TimeUtils.TimestampNextClock(next_clock)
	-- 获取当前时间
	local now = TimeUtils.NowTime()
	
	-- 设置为今天的上午X点
	local dateTable = os.date("*t", now)
	dateTable.hour = next_clock
	dateTable.min = 0
	dateTable.sec = 0
	-- 获取 next_clock 的时间戳
	local next_clock_timestamp = os.time(dateTable)

	-- 如果现在时间超过了上午X点，则设置为明天的上午X点
	if now > next_clock_timestamp then
		-- 增加一天的秒数来设置为明天
		next_clock_timestamp = next_clock_timestamp + 86400
	end
	return next_clock_timestamp
end

function TimeUtils.TimestampLastClock(last_clock)
	return TimeUtils.TimestampNextClock(last_clock) - 86400
end

-- 时间戳转换为日期
function TimeUtils.TimeToStr(Timestamp, UserServerTimezone)
	Timestamp = Timestamp or TimeUtils.NowTime()
	if type(Timestamp) == "table" and Timestamp.GetTime then
		Timestamp = Timestamp:GetTime()
	end
	if UserServerTimezone == nil then
		UserServerTimezone = true
	end
	if UserServerTimezone then
		Timestamp = os.time(os.date("!*t", Timestamp)) + TimeUtils.GetServerTimeZone() * 3600
	end
	return os.date("%y-%m-%d, %H:%M:%S", Timestamp)
end

-- 北京时间戳转换为服务器时间戳
function TimeUtils.TimestampToServerTimestamp(current_time)
	if TimeUtils.ServerTimeZone == nil then
		ScreenPrint('czc 禁止在服务器时区未设置的情况下访问服务器时区',debug.traceback())
	end
	local timezone = TimeUtils.GetServerTimeZone()
	current_time = current_time + (TimeUtils.BeijingTimeZone - timezone) * 3600
	return math.floor(current_time)
end

-- 日期转换为时间戳
function TimeUtils.DataToTimestamp(year, month, day, hour, minute, second, use_timezone)
	if use_timezone ~= false then
		use_timezone = true
	end
	local timezone = TimeUtils.GetServerTimeZone()
	local current_timezone = TimeUtils.GetCurrentTimeZone()
	local current_time = os.time({
		year = year, month = month, day = day, hour = hour, min = minute, sec = second
	})
	local result = current_time
	if use_timezone then
		result = current_time + (current_timezone - timezone) * 3600
	end
	return result
end

function TimeUtils.DataToTimestampForArea(year, month, day, hour, minute, second, area)
	area = area or "China"
	local timezone = CommonConst.SERVER_AREA_TO_TIMEZONE[area]
	local current_timezone = TimeUtils.GetCurrentTimeZone()
	local current_time = os.time({
		year = year, month = month, day = day, hour = hour, min = minute, sec = second
	})
	return current_time + (current_timezone - timezone) * 3600
end

-- 时间戳转换为日期
function TimeUtils.TimestampToData(time, use_timezone)
	local d = TimeUtils.TimestampToDataObj(time ,use_timezone)
	return d.year, d.month, d.day, d.hour, d.min, d.sec
end

-- 时间戳转换为日期
function TimeUtils.TimestampToDataObj(time, use_timezone)
	if use_timezone ~= false then
		use_timezone = true
	end
	local timezone = TimeUtils.GetServerTimeZone()
	local current_timezone = TimeUtils.GetCurrentTimeZone()
	local d
	if use_timezone then
		d = os.date("*t", time + (timezone - current_timezone) * 3600)
	else
		d = os.date("*t", time)
	end
	return d
end

--获取时间戳的年月日时分
function TimeUtils.TimeToYMDHMSStr(Timestamp, UserServerTimezone,Joiner1,Joiner2)
	Timestamp = Timestamp or TimeUtils.NowTime()
	if type(Timestamp) == "table" and Timestamp.GetTime then
		Timestamp = Timestamp:GetTime()
	end
	Joiner1 = Joiner1 or "-"
	Joiner2 = Joiner2 or ":"
	if UserServerTimezone == nil then
		UserServerTimezone = true
	end
	if UserServerTimezone then
		Timestamp = os.time(os.date("!*t", Timestamp)) + TimeUtils.GetServerTimeZone() * 3600
	end
	return os.date("%Y"..Joiner1.."%m"..Joiner1.."%d"..' '.."%H"..Joiner2.."%M"..Joiner2.."%S", Timestamp)
end

--获取时间戳的年月日时分
function TimeUtils.TimeToYMDHMStr(Timestamp, UserServerTimezone,Joiner1,Joiner2)
	Timestamp = Timestamp or TimeUtils.NowTime()
	if type(Timestamp) == "table" and Timestamp.GetTime then
		Timestamp = Timestamp:GetTime()
	end
	Joiner1 = Joiner1 or "-"
	Joiner2 = Joiner2 or ":"
	if UserServerTimezone == nil then
		UserServerTimezone = true
	end
	if UserServerTimezone then
		Timestamp = os.time(os.date("!*t", Timestamp)) + TimeUtils.GetServerTimeZone() * 3600
	end
	return os.date("%Y"..Joiner1.."%m"..Joiner1.."%d"..' '.."%H"..Joiner2.."%M", Timestamp)
end

--获取时间戳的年月日
function TimeUtils.TimeToYMDStr(Timestamp, UserServerTimezone,Joiner)
	Timestamp = Timestamp or TimeUtils.NowTime()
	if type(Timestamp) == "table" and Timestamp.GetTime then
		Timestamp = Timestamp:GetTime()
	end
	Joiner = Joiner or "-"
	if UserServerTimezone == nil then
		UserServerTimezone = true
	end
	if UserServerTimezone then
		Timestamp = os.time(os.date("!*t", Timestamp)) + TimeUtils.GetServerTimeZone() * 3600
	end
	return os.date("%Y"..Joiner.."%m"..Joiner.."%d", Timestamp)
end

--获取时间戳的时分秒
function TimeUtils.TimeToHMSStr(Timestamp, UserServerTimezone,Joiner)
	Timestamp = Timestamp or TimeUtils.NowTime()
	if type(Timestamp) == "table" and Timestamp.GetTime then
		Timestamp = Timestamp:GetTime()
	end
	Joiner = Joiner or ":"
	if UserServerTimezone == nil then
		UserServerTimezone = true
	end
	if UserServerTimezone then
		Timestamp = os.time(os.date("!*t", Timestamp)) + TimeUtils.GetServerTimeZone() * 3600
	end
	return os.date("%H"..Joiner.."%M"..Joiner.."%S", Timestamp)
end

function TimeUtils.NextDailyRefreshTime(now, refresh_hms, interval)
	now = now or TimeUtils.NowTime()
	refresh_hms = refresh_hms or TimeUtils.RefreshHMS
	interval = interval or 1
	local year, month, day, hour, min, sec = TimeUtils.TimestampToData(now)
	local t = TimeUtils.DataToTimestamp(year, month, day, table.unpack(refresh_hms))
	if TimeUtils.GetSec(hour, min, sec) < TimeUtils.GetSec(table.unpack(refresh_hms)) then
		return t
	else
		return t + 24*3600*interval
	end
end

function TimeUtils.NextWeeklyRefreshTime(now, refresh_hms)
	now = now or TimeUtils.NowTime()
	refresh_hms = refresh_hms or TimeUtils.RefreshHMS
	local data = TimeUtils.TimestampToDataObj(now)
	local hms = {data.hour, data.min, data.sec}
	local weekday = 2
	if data.wday == weekday and TimeUtils.GetSec(table.unpack(hms)) < TimeUtils.GetSec(table.unpack(refresh_hms)) then
		return TimeUtils.DataToTimestamp(data.year, data.month, data.day, table.unpack(refresh_hms))
	else
		data.day = data.day + (7 - (data.wday - weekday + 7) % 7)
		local d1 = os.date("*t", os.time(data))
		return TimeUtils.DataToTimestamp(d1.year, d1.month, d1.day, table.unpack(refresh_hms))
	end
end

function TimeUtils.GetSec(hour, min, sec)
	return hour*3600 + min*60 + sec
end

function TimeUtils.GetDaySec(Day)
	Day = Day or 1
	return 24*3600 * Day
end


function TimeUtils.ExcelTimestampToLuaData(time)
	local d = os.date("*t", (time - 25569) * 3600 * 24)
	return d.year, d.month, d.day, d.hour, d.min, d.sec
end

--获得时间戳所在周的周一时间戳
function TimeUtils.GetWeekMonday(Timestamp)
    -- 获取时间戳的日期信息（wday: 1=周日，2=周一，...7=周六）
	if type(Timestamp) == "table" and Timestamp.GetTime then
		Timestamp = Timestamp:GetTime()
	end
    local date = os.date("*t", Timestamp)
    local wday = date.wday
    
    -- 计算需要减去的天数，得到当周的周一
    -- 公式：(wday - 2 + 7) % 7
    local daysToSubtract = (wday - 2 + 7) % 7
    
    -- 计算当周周一的日期
    local monday = os.time({
        year = date.year,
        month = date.month,
        day = date.day - daysToSubtract
    })
    
    return monday
end

--判断传入的时间戳是否在当前周
function TimeUtils.IsTimestampInCurrentWeek(timestamp)
    -- 当前时间戳
    local currentTimestamp = os.time()
    
    -- 获取时间戳和当前时间的周起始日（周一）
    local preMonday = TimeUtils.GetWeekMonday(timestamp)
    local currentMonday = TimeUtils.GetWeekMonday(currentTimestamp)
    
    -- 比较：时间戳的周一 = 当前周的周一  属于当前周
    return preMonday >= currentMonday
end

--- 获取时间戳t2相对t1间隔的天数，两个时间戳在同一天时，间隔为0, t2在t1前面时，结果为负数
---@param t1 integer
---@param t2 integer
---@param day_gap_hms table 以哪个时间点作为一天的分隔，实际生活中是0点，我们游戏默认是早上5点
---@return integer
function TimeUtils.GetIntervalDay(t1, t2, day_gap_hms)
	day_gap_hms = day_gap_hms or TimeUtils.RefreshHMS
	local gap = TimeUtils.GetSec(table.unpack(day_gap_hms))
	t1 = t1 - gap
	t2 = t2 - gap
	local d1 = TimeUtils.TimestampToDataObj(t1)
	local d2 = TimeUtils.TimestampToDataObj(t2)
	local sd1 = TimeUtils.DataToTimestamp(d1.year, d1.month, d1.day, 12, 0, 0)
	local sd2 = TimeUtils.DataToTimestamp(d2.year, d2.month, d2.day, 12, 0, 0)
	return math.floor((sd2 - sd1)/86400)
end

return TimeUtils
