
--Option 文法: 
--Option -> OptionList
-- OptionList -> OptionList,OptionItem | OptionItem
-- OptionItem -> OptionContent(OptionOperator) | talk_id
-- OptionOperator -> talk_id|epsilon
-- OptionContent -> text
local PARSE_CODE={
    OK="OK",
    INVALID_VAL="INVALID_VAL",
    EXPECT_VAL="EXPECT_VAL",
    ROOT_NOT_REGULAR="ROOT_NOT_REGULAR",
}
local PARSE_OPTION_TYPE ={
    EPSILON="EPSILON",
    TALK_ID="TALK_ID",
}
local OptionParser      ={}
function OptionParser:ParseWhitespace(str,idx)
    while(1)do
        if(str[idx]) then
            if(str[idx]==' ' or str[idx]=='\n' or str[idx]=='\t' or str[idx]=='\r') then
                idx=idx+1
            else
                break
            end
        else
            break
        end
    end
    return idx
end

local function GetChar(str,idx)
    return string.sub(str,idx,idx)
end

local function EXPECT(str,idx,val)
    if(GetChar(str,idx)~=val) then
        error(string.format("Expect %s,Get %s",val,GetChar(str,idx)))
    end
    return idx+1
end

function OptionParser:ParseOptionList(str,idx)
    local option_list={}
    while(1)do
        local option_item_info= OptionParser:ParseOptionItem(str,idx)
        if(option_item_info.parse_code~=PARSE_CODE.OK) then
            return {
                option_list=option_list,
                parse_code = option_item_info.parse_code
            }
        end
        local option_item=option_item_info.option_item
        table.insert(option_list,option_item)
        idx= option_item_info.idx

        idx = OptionParser:ParseWhitespace(str,idx)
        local current_char = GetChar(str,idx)
        if(current_char==',')  then
            idx = idx + 1
            current_char=GetChar(str,idx)
            if(not current_char or current_char=="") then
                return {
                    option_list=option_list,
                    parse_code = PARSE_CODE.OK
                }
            end
        elseif(not current_char or current_char=="") then
            return {
                option_list=option_list,
                parse_code = PARSE_CODE.OK
            }
        else
            return {
                option_list=option_list,
                parse_code = PARSE_CODE.INVALID_VAL
            }
        end
    end

end

function OptionParser:ParseOptionItem(str,idx)
    idx = OptionParser:ParseWhitespace(str,idx)
    local option_item={}
    local option_operator={}
    
    -- Parse Content
    local option_content=""
    while(1)do
        local current_char=GetChar(str,idx)
        if(not current_char or current_char=="") then
            return {
                idx =idx,
                parse_code= PARSE_CODE.OK,
                option_item = tonumber(option_content)
            }
        end
        if(current_char=="(") then
            break
        end
        idx = idx +1
        option_content = option_content..current_char
    end
    option_item.option_content=option_content
    
    local option_operator_info= OptionParser:ParseOptionOperator(str,idx)

    option_operator.option_type=option_operator_info.option_type
    if(option_operator_info.option_type==PARSE_OPTION_TYPE.TALK_ID) then
        option_operator.num=option_operator_info.num
    elseif(1) then
    end

    option_item.option_operator=option_operator
    if(option_operator_info.parse_code~=PARSE_CODE.OK) then
        return {
            idx =idx,
            parse_code=option_operator_info.parse_code,
            option_item = option_item
        }
    end

    return {
        idx = option_operator_info.idx,
        parse_code=PARSE_CODE.OK,
        option_item = option_item
    }
end

--OptionParse:ParseOptionItem("你好",1)



function OptionParser:ParseNumber(str,idx)
    local char=GetChar(str,idx)
    if(not(char>='0' and char<='9')) then
        return nil,nil,PARSE_CODE.INVALID_VAL
    end
    local number_str=""
    while(1) do
        char=GetChar(str,idx)
        if(not(char>='0' and char<='9')) then
            break
        end
        number_str=number_str..char
        idx=idx+1
    end
    return idx,tonumber(number_str),PARSE_CODE.OK
end

function OptionParser:ParseOptionOperator(str,idx)
    idx=EXPECT(str,idx,'(')
    local current_char = GetChar(str,idx)
    local num=nil

    if(current_char>='0' and current_char<='9') then
        local parse_code
        idx,num,parse_code = OptionParser:ParseNumber(str,idx)
        if(parse_code==PARSE_CODE.INVALID_VAL) then
            return {
                idx = idx,
                parse_code = PARSE_CODE.INVALID_VAL,
                option_type=PARSE_OPTION_TYPE.TALK_ID,
                num=num
            }
        end
        idx=EXPECT(str,idx,')')
        return {
            idx = idx,
            parse_code = parse_code,
            option_type=PARSE_OPTION_TYPE.TALK_ID,
            num=num
        }
    elseif(current_char==')')then
        return {
            idx = idx +1,
            parse_code =PARSE_CODE.OK,
            option_type=PARSE_OPTION_TYPE.EPSILON
        }
    elseif(not current_char or current_char=="") then
        return {
            idx = idx,
            parse_code = PARSE_CODE.EXPECT_VAL
        }
    else
        return {
            idx = idx +1,
            parse_code = PARSE_CODE.INVALID_VAL
        }
    end
end

function OptionParser:Parse(str)
    return OptionParser:ParseOptionList(str,1)
    
end


return {OptionParser,PARSE_CODE,PARSE_OPTION_TYPE}