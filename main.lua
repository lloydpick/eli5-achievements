Eli5Achievements = {}
local Eli5Achievements = Eli5Achievements
Eli5Achievements.L = {}

Eli5Achievements.L = Eli5Achievements.L or setmetatable({}, {
    __index = function(t, k)
        rawset(t, k, k)
        return k
    end,
    __newindex = function(t, k, v)
        if v == true then
            rawset(t, k, k)
        else
            rawset(t, k, v)
        end
    end,
})

function Eli5Achievements.RegisterLocale(locale, tbl)
    if not tbl then return end
    if locale == "enUS" or locale == GetLocale() then
        for k,v in pairs(tbl) do
            if v == true then
                Eli5Achievements.L[k] = k
            elseif type(v) == "string" then
                Eli5Achievements.L[k] = v
            else
                Eli5Achievements.L[k] = k
            end
        end
    end
end

function Eli5Achievements.OnEvent(self, event, arg1, ...)
	-- print("[ELI5]", event, arg1, ...)

	if (event == "ADDON_LOADED" and arg1 == "Blizzard_AchievementUI") then
		Eli5Achievements.MainFrame:UnregisterEvent("ADDON_LOADED")
		Eli5Achievements.UI_HookAchButtons(AchievementFrameAchievementsContainer.buttons)
	end
end

function Eli5Achievements.UI_HookAchButtons(buttons)
	for i,button in ipairs(buttons) do
		button:HookScript("OnUpdate", Eli5Achievements.achOnUpdate)
		--button:HookScript("OnClick", achOnClick)
	end
end

function Eli5Achievements.achOnUpdate(self)
	--ViragDevTool_AddData(self, "ELI5")
	description = self.description:GetText()
  
	if description and Eli5Achievements.L[tostring(self.id)] then
		if not string.match(description, "ELI5") then
			text = description .. ' |r|cff007bfa' .. 'ELI5|r - '.. Eli5Achievements.L[tostring(self.id)] .. '    '
			self.description:SetText(text)
			self.hiddenDescription:SetText(text)
		end
	end
end

Eli5Achievements.MainFrame = CreateFrame("Frame")
Eli5Achievements.MainFrame:Hide()
Eli5Achievements.MainFrame:RegisterEvent("ADDON_LOADED")
Eli5Achievements.MainFrame:SetScript("OnEvent", Eli5Achievements.OnEvent)
