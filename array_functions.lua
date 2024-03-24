
local _, core = ...;
core.Array = {}; -- adds Array table to addon namespace

local Array = core.Array;

function Array:PrintArray(tbl, indent)
    if not indent then indent = 0 end
    for k, v in pairs(tbl) do
        formatting = string.rep("  ", indent) .. k .. ": "
        if type(v) == "table" then
            print(formatting)
            Array:PrintArray(v, indent+1)
        elseif type(v) == 'boolean' then
            print(formatting .. tostring(v))      
        else
            print(formatting .. v)
        end
    end
end

function Array:PrintArraytoString(tbl, indent, output_string)
    if not indent then indent = 0 end
    for k, v in pairs(tbl) do
        formatting = string.rep("  ", indent) .. k .. ": "
        if type(v) == "table" then
            output_string = output_string .. formatting .. string.char(10)
            output_string =  Array:PrintArraytoString(v, indent+1, output_string)
        elseif type(v) == 'boolean' then
            output_string = output_string .. formatting .. tostring(v) .. string.char(10) 
        else
            output_string = output_string .. formatting .. v .. string.char(10) 
        end
    end
    return output_string
end

function Array:SortArray(array, col) 

    local function compare_col(col)
        function compare(a,b)
           return a[col] < b[col] 
        end
        return compare
    end
    table.sort(array, compare_col(col))
end