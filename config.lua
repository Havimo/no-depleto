local _, core = ...;
core.Config = {}; -- adds Config table to addon namespace

local Config = core.Config;
local UIConfig;

function Config:Toggle()
	local menu = UIConfig or Config:CreateMenu();
	menu:SetShown(not menu:IsShown());
end

function Config:CreateButton(point, relativeFrame, relativePoint, yOffset, text)
	local btn = CreateFrame("Button", nil, UIConfig, "GameMenuButtonTemplate");
	btn:SetPoint(point, relativeFrame, relativePoint, 0, yOffset);
	btn:SetSize(140, 40);
	btn:SetText(text);
	btn:SetNormalFontObject("GameFontNormalLarge");
	btn:SetHighlightFontObject("GameFontHighlightLarge");
	return btn;
end

function Config:ButtonSortingHandler(col)
    function f()
        string_to_print = core.Array.PrintArraytoString(self, core.Array.SortArray(self, player_list, col),0,"")
        UIConfig.body:SetText(string_to_print)
        return 1
    end
    return(f)
end

function DungeonClick(self)
    print('clicking score button')
    core.variables.sort_variable = 'dungeonScore'
    core.Array.SortArray(self, core.variables.player_list, "dungeonScore")
    UIConfig.body:SetText(core.Array.PrintArraytoString(self, core.variables.player_list, 0, ""))
end

function iLvlClick(self)
    print('clicking ilvl button')
    core.variables.sort_variable = 'itemLevel'
    core.Array.SortArray(self, core.variables.player_list, "itemLevel")
    UIConfig.body:SetText(core.Array.PrintArraytoString(self, core.variables.player_list, 0, ""))
end

function Config:CreateMenu()
    
    UIConfig = CreateFrame("Frame", "NoDepleto_UIConfig", UIParent, "BasicFrameTemplatewithInset")

    UIConfig:SetSize(500, 600)
    UIConfig:SetPoint("CENTER", UIParent, "CENTER")
    UIConfig.title = UIConfig:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    UIConfig.title:SetPoint("LEFT", UIConfig.TitleBg, "LEFT", 5, 0)
    UIConfig.title:SetText("No Depleto - M+ List Filter")


    UIConfig.body = UIConfig:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    UIConfig.body:SetPoint("CENTER", UIConfig, "CENTER")

    -- SortDungeonScore Button:
    UIConfig.sortScoreBtn =  self:CreateButton("TOPLEFT", UIConfig, "TOP", 0,"Sort Score"); 
    -- Sortilvl Button:
    UIConfig.sortiLvlBtn =  self:CreateButton("RIGHT", UIConfig.sortScoreBtn, "RIGHT", 50,"Sort iLvl"); 

    UIConfig.sortScoreBtn:SetScript("OnClick",  DungeonClick)
    UIConfig.sortiLvlBtn:SetScript("OnClick",  iLvlClick)

	UIConfig:Hide();
	return UIConfig;
end