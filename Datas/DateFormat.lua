-- Source Excel file path: ..\datas\Date.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("DateFormat", {
	Date_MD = {
		FormatCN = "%m月%d日",
		FormatEN = "%B %e",
		FormatID = "Date_MD",
		FormatJP = "%m月%d日",
		FormatKR = "%m월%d일",
	},
	Date_MD_Raw = {
		FormatCN = "%m-%d",
		FormatEN = "%d-%m",
		FormatID = "Date_MD_Raw",
		FormatJP = "%m-%d",
		FormatKR = "%m-%d",
	},
	Date_YMD = {
		FormatCN = "%Y年%m月%d日",
		FormatEN = "%B %e, %Y",
		FormatID = "Date_YMD",
		FormatJP = "%Y年%m月%d日",
		FormatKR = "%Y년%m월%d일",
	},
	Date_YMD_Raw = {
		FormatCN = "%y-%m-%d",
		FormatEN = "%d-%m-%y",
		FormatID = "Date_YMD_Raw",
		FormatJP = "%y-%m-%d",
		FormatKR = "%y-%m-%d",
	},
})