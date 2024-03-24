
local _, core = ...; -- Namespace

--------------------------------------------------------
-- Main UI Frame
--------------------------------------------------------

local UIConfig = core.Config:CreateMenu()
UIConfig:SetShown(true)

core.variables = {}
local var = core.variables
var.player_list = {}
var.sort_variable = 'dungeonScore'

--------------------------------------------------------
-- Event Handler
--------------------------------------------------------
local EventFrame = CreateFrame("frame", "EventFrame")
EventFrame:RegisterEvent("LFG_LIST_APPLICANT_LIST_UPDATED")
EventFrame:RegisterEvent("LFG_LIST_APPLICANT_UPDATED")
EventFrame:RegisterEvent("LFG_LIST_APPLICATION_STATUS_UPDATED")

EventFrame:SetScript("OnEvent", function(self, event, ...)
    if(event == "LFG_LIST_APPLICANT_LIST_UPDATED" or event == "LFG_LIST_APPLICATION_STATUS_UPDATED" or event == "LFG_LIST_APPLICANT_UPDATED") then

        local applicants_list = C_LFGList.GetApplicants()
        var.player_list = {}
        for i = 1,#applicants_list,1 do
            local name, _, localizedClass, _, itemLevel, _, _, _, _, assignedRole, _, dungeonScore, _ = C_LFGList.GetApplicantMemberInfo(applicants_list[i],1)
            local player = {
                ["name"] = name,
                ["localizedClass"] = localizedClass,
                ["itemLevel"] = itemLevel,
                ["assignedRole"] = assignedRole,
                ["dungeonScore"]  = dungeonScore
            }
            table.insert(var.player_list, player)
        end 
        core.Array.SortArray(self, var.player_list, var.sort_variable)
        UIConfig.body.text:SetText(core.Array.PrintArraytoString(self, var.player_list, 0, ""))  
  
    end
end)





