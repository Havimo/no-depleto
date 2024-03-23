local EventFrame = CreateFrame("frame", "EventFrame")
EventFrame:RegisterEvent("LFG_LIST_APPLICANT_LIST_UPDATED")
EventFrame:RegisterEvent("LFG_LIST_APPLICANT_UPDATED")
EventFrame:RegisterEvent("LFG_LIST_APPLICATION_STATUS_UPDATED")

local function PrintArray(tbl,indent)
    if not indent then indent = 0 end
    for k, v in pairs(tbl) do
        formatting = string.rep("  ", indent) .. k .. ": "
        if type(v) == "table" then
            print(formatting)
            PrintArray(v, indent+1)
        elseif type(v) == 'boolean' then
            print(formatting .. tostring(v))      
        else
            print(formatting .. v)
        end
    end
end

local function PrintArraytoString(tbl,indent,output_string)
    if not indent then indent = 0 end
    for k, v in pairs(tbl) do
        formatting = string.rep("  ", indent) .. k .. ": "
        if type(v) == "table" then
            output_string = output_string .. formatting .. string.char(10)
            output_string = PrintArraytoString(v, indent+1, output_string)
        elseif type(v) == 'boolean' then
            output_string = output_string .. formatting .. tostring(v) .. string.char(10) 
        else
            output_string = output_string .. formatting .. v .. string.char(10) 
        end
    end
    return output_string
end

local function SortArray(array, col) 

    local function compare_col(col)
        function compare(a,b)
           return a[col] < b[col] 
        end
        return compare
    end
     
    table.sort(array, compare_col(col))
    PrintArray(array)
end

local UIConfig = CreateFrame("Frame", "NoDepleto_UIConfig", UIParent, "BasicFrameTemplatewithInset")

UIConfig:SetSize(500, 600)
UIConfig:SetPoint("CENTER", UIParent, "CENTER")
UIConfig.title = UIConfig:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
UIConfig.title:SetPoint("LEFT", UIConfig.TitleBg, "LEFT", 5, 0)
UIConfig.title:SetText("No Depleto - M+ List Filter")

UIConfig.body = UIConfig:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
UIConfig.body:SetPoint("CENTER", UIConfig, "CENTER")

EventFrame:SetScript("OnEvent", function(self, event, ...)
    if(event == "LFG_LIST_APPLICANT_LIST_UPDATED" or event == "LFG_LIST_APPLICATION_STATUS_UPDATED" or event == "LFG_LIST_APPLICANT_UPDATED") then

        local applicants_list = C_LFGList.GetApplicants()
        local player_list = {}
        for i = 1,#applicants_list,1 do
            local name, _, localizedClass, _, itemLevel, _, _, _, _, assignedRole, _, dungeonScore, _ = C_LFGList.GetApplicantMemberInfo(applicants_list[i],1)
            local player = {
                ["name"] = name,
                ["localizedClass"] = localizedClass,
                ["itemLevel"] = itemLevel,
                ["assignedRole"] = assignedRole,
                ["dungeonScore"]  = dungeonScore
            }
            table.insert(player_list, player)
        end 
        SortArray(player_list, 'dungeonScore')

        UIConfig.body:SetText(PrintArraytoString(player_list, 0, ""))  
    end
end)





