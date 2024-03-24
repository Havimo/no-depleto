local _, core = ...;
core.Config = {}; -- adds Config table to addon namespace

local Config = core.Config;
local UIConfig;

function Config:Toggle()
	local menu = UIConfig or Config:CreateMenu();
	menu:SetShown(not menu:IsShown());
end

local function ScrollFrame_OnMouseWheel(self, delta)
	local newValue = self:GetVerticalScroll() - (50 * 20);
	
	if (newValue < 0) then
		newValue = 0;
	elseif (newValue > self:GetVerticalScrollRange()) then
		newValue = self:GetVerticalScrollRange();
	end
	
	self:SetVerticalScroll(newValue);
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

function DungeonClick(self)
    print('clicking score button')
    core.variables.sort_variable = 'dungeonScore'
    core.Array.SortArray(self, core.variables.player_list, "dungeonScore")
    UIConfig.body.text:SetText(core.Array.PrintArraytoString(self, core.variables.player_list, 0, ""))
end

function iLvlClick(self)
    print('clicking ilvl button')
    core.variables.sort_variable = 'itemLevel'
    core.Array.SortArray(self, core.variables.player_list, "itemLevel")
    UIConfig.body.text:SetText(core.Array.PrintArraytoString(self, core.variables.player_list, 0, ""))
end

function Config:CreateMenu()
    
    UIConfig = CreateFrame("Frame", "NoDepleto_UIConfig", UIParent, "BasicFrameTemplatewithInset")

    UIConfig:SetSize(500, 600)
    UIConfig:SetPoint("CENTER", UIParent, "CENTER")

    
    UIConfig.title = UIConfig:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    UIConfig.title:SetPoint("LEFT", UIConfig.TitleBg, "LEFT", 5, 0)
    UIConfig.title:SetText("No Depleto - M+ List Filter")	

    UIConfig.ScrollFrame = CreateFrame("ScrollFrame", nil, UIConfig, "UIPanelScrollFrameTemplate");
	UIConfig.ScrollFrame:SetPoint("TOPLEFT", UIConfig.Bg, "TOPLEFT", 4, -8);
	UIConfig.ScrollFrame:SetPoint("BOTTOMRIGHT", UIConfig.Bg, "BOTTOMRIGHT", -3, 4);
	UIConfig.ScrollFrame:SetClipsChildren(true);
	--UIConfig.ScrollFrame:SetScript("OnMouseWheel", ScrollFrame_OnMouseWheel);
	
	UIConfig.ScrollFrame.ScrollBar:ClearAllPoints();
    UIConfig.ScrollFrame.ScrollBar:SetPoint("TOPLEFT", UIConfig.ScrollFrame, "TOPRIGHT", -12, -18);
    UIConfig.ScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", UIConfig.ScrollFrame, "BOTTOMRIGHT", -7, 18);

    UIConfig.body = CreateFrame("Frame", nil, UIConfig.ScrollFrame)
    UIConfig.body:SetSize(308,500)
        
    UIConfig.ScrollFrame:SetScrollChild(UIConfig.body)

    UIConfig.body.text = UIConfig.body:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    UIConfig.body.text:SetPoint("TOP", UIConfig.body, "TOP")

    -- SortDungeonScore Button:
    UIConfig.sortScoreBtn =  self:CreateButton("TOPLEFT", UIConfig, "TOP", 0,"Sort Score"); 
    -- Sortilvl Button:
    UIConfig.sortiLvlBtn =  self:CreateButton("RIGHT", UIConfig.sortScoreBtn, "RIGHT", 50,"Sort iLvl"); 

    UIConfig.sortScoreBtn:SetScript("OnClick",  DungeonClick)
    UIConfig.sortiLvlBtn:SetScript("OnClick",  iLvlClick)

	UIConfig:Hide();
	return UIConfig;
end