--
-- EFCReport by Cubenicke aka Yrrol@vanaillagaming
-- Thx for the Inspiration lanevegame (p.s. send me the graphics)
-- 
EFCReport = CreateFrame('Frame', "EFCReport", UIParent)
EFCReport.enabled = false
EFCReport.created = false
EFCReport:RegisterEvent("ADDON_LOADED")
EFCReport:RegisterEvent("PLAYER_ENTERING_WORLD")
EFCReport:RegisterEvent("ZONE_CHANGED_NEW_AREA")
SLASH_EFCReport1 = '/efcr'
SLASH_EFCReport2 = '/EFCR'

if not EFCRSaves then
	EFCRSaves = { scale = 0, x = 0, y = 0 }
end

local buttons = {
	{ x=10, y=-10, w=32, h=32, tex = "repic28", text="Repick", bkg = "neutral"},
	{ x=42, y=-10, w=64, h=32, tex = "roof56", text="EFC @ ARoof", bkg = "alliance"},
	{ x=106, y=-10, w=32, h=32, tex = "cap28", text="Cap", bkg = "neutral"},
	{ x=10, y=-42, w=32, h=32, tex = "gy28", text="EFC @ AGY", bkg = "alliance"},
	{ x=42, y=-42, w=32, h=32, tex = "fr28", text="EFC @ AFR", bkg = "alliance"},
	{ x=74, y=-42, w=32, h=32, tex = "balc28", text="EFC @ ABalc", bkg = "alliance"},
	{ x=106, y=-42, w=32, h=32, tex = "ramp28", text="EFC @ ARamp", bkg = "alliance"},
	{ x=10, y=-74, w=32, h=32, tex = "resto28", text="EFC @ AResto", bkg = "alliance"},
	{ x=42, y=-74, w=32, h=32, tex = "tun28", text="EFC @ ATunnel", bkg = "alliance"},
	{ x=74, y=-74, w=32, h=32, tex = "fence28", text="EFC @ AFence", bkg = "alliance"},
	{ x=106, y=-74, w=32, h=32, tex = "zerk28", text="EFC @ AZerk", bkg = "alliance"},
	{ x=26, y=-106, w=32, h=32, tex = "west28", text="EFC West", bkg = "neutral"},
	{ x=58, y=-106, w=32, h=32, tex = "mid28", text="EFC Mid", bkg = "neutral"},
	{ x=90, y=-106, w=32, h=32, tex = "east28", text="EFC East", bkg = "neutral"},
	{ x=10, y=-138, w=32, h=32, tex = "zerk28", text="EFC @ HZerk", bkg = "horde"},
	{ x=42, y=-138, w=32, h=32, tex = "tun28", text="EFC @ HTunnel", bkg = "horde"},
	{ x=74, y=-138, w=32, h=32, tex = "fence28", text="EFC @ HFence", bkg = "horde"},
	{ x=106, y=-138, w=32, h=32, tex = "resto28", text="EFC @ HResto", bkg = "horde"},
	{ x=10, y=-170, w=32, h=32, tex = "ramp28", text="EFC @ HRamp", bkg = "horde"},
	{ x=42, y=-170, w=32, h=32, tex = "fr28", text="EFC @ HFR", bkg = "horde"},
	{ x=74, y=-170, w=32, h=32, tex = "balc28", text="EFC @ HBalc", bkg = "horde"},
	{ x=106, y=-170, w=32, h=32, tex = "gy28", text="EFC @ HGY", bkg = "horde"},
	{ x=42, y=-202, w=64, h=32, tex = "roof56", text="EFC @ HRoof", bkg = "horde"},
}
local iconPath = "Interface\\Addons\\EFCReport\\Icons\\"


function Print(arg1)
	DEFAULT_CHAT_FRAME:AddMessage("|cffCC121D EFCR|r "..(arg1 or ""))
end

-- Show the dialog when entering WSG
function EFCReport:OnEvent()
	if event == "ADDON_LOADED" and arg1 == "EFCReport" then
		Print("Loaded")
	elseif event == 'PLAYER_ENTERING_WORLD' or event == 'ZONE_CHANGED_NEW_AREA' then
		if GetRealZoneText() == "Warsong Gulch" then
			if EFCReport.created == false then
				EFCReport.create()
			end
			EFCReport.EFCFrame:Show()
			EFCReport.enabled = true
		elseif EFCReport.enabled then
			EFCReport.enabled = false
			EFCReport.EFCFrame:Hide()
		end
	end	
end
EFCReport:SetScript("OnEvent", EFCReport.OnEvent)

-- Hanlde slash commands
-- /efcr
-- /efcr scale <0 - 1>
-- /efcr xy <x> <Y>
-- /efcr x <x>
-- /efcr y <y>
SlashCmdList['EFCReport'] = function (msg)
	local _, _, cmd, args = string.find(msg or "", "([%w%p]+)%s*(.*)$")
	if cmd == "" or cmd == nil then
		if EFCReport.enabled then
			EFCReport.enabled = false
			EFCReport.EFCFrame:Hide()
		else
			if EFCReport.created == false then
				EFCReport.create()
			end
			EFCReport.EFCFrame:Show()
			EFCReport.enabled = true
		end
	elseif cmd == "scale" then
		EFCRSaves.scale = tonumber(args)
		Print("Setting Scale "..args)
		if EFCReport.EFCFrame then
			EFCReport.EFCFrame:SetScale(EFCRSaves.scale)
		end
	elseif cmd == "xy" or cmd == "pos" then
		local x, y = string.find(args,"(.*)%s*(.*)")
		EFCRSaves.x = x or 0
		EFCRSaves.y = y or 0
		EFCReport.EFCFrame:SetPoint("TOPLEFT", nil, "TOPLEFT", EFCRSaves.x, -EFCRSaves.y) 
	elseif cmd == "x" then
		EFCRSaves.x = tonumber(args) or 0
		EFCReport.EFCFrame:SetPoint("TOPLEFT", nil, "TOPLEFT", EFCRSaves.x, -EFCRSaves.y) 
	elseif cmd == "y" then
		EFCRSaves.y = tonumber(args) or 0
		EFCReport.EFCFrame:SetPoint("TOPLEFT", nil, "TOPLEFT", EFCRSaves.x, -EFCRSaves.y) 
	else
		Print("Unknown command "..cmd)
	end
end

function EFCReport_OnEnter()
	EFCReport.EFCFrame:SetAlpha(1)
end

function EFCReport_OnLeave()
	EFCReport.EFCFrame:SetAlpha(0.4)
end

-- Create the EFCReport dialog
function EFCReport:create()
	-- Option Frame
	local frame = CreateFrame("Frame", "EFCRFrame")
	EFCReport.EFCFrame = frame

	tinsert(UISpecialFrames,"EFCReport")

	-- Set scale, size and position
	frame:SetWidth(148)
	frame:SetHeight(244)
	if EFCRSaves.scale > 0 then
		frame:SetScale(EFCRSaves.scale)
	end
	if not (EFCRSaves.x > 0 and EFCRSaves.y > 0) then
		EFCRSaves.x = 400
		EFCRSaves.y = 50
	end

	-- Background on entire frame
	frame:SetPoint("TOPLEFT", nil, "TOPLEFT", EFCRSaves.x, -EFCRSaves.y)
	frame:SetBackdrop( {
			bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", 
			edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", 
			tile = true, 
			tileSize = 32, 
			edgeSize = 32, 
			insets = { left = 11, right = 12, top = 12, bottom = 11 }
		} );
	frame:SetBackdropColor(.01, .01, .01, .91)

	-- Make it moveable
	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:SetClampedToScreen(false)
	frame:SetAlpha(0.4)
	frame:Hide()

	-- Handle drag of window
	frame:SetScript("OnMouseDown", function()
		if arg1 == "LeftButton" and not this.isMoving then
			this:StartMoving();
			this.isMoving = true;
		end
	end)
	frame:SetScript("OnMouseUp", function()
		if arg1 == "LeftButton" and this.isMoving then
			local _,_,_,x,y = this:GetPoint()
			EFCRSaves.x = x
			EFCRSaves.y = -y
			this:StopMovingOrSizing();
			this.isMoving = false;
		end
	end)
	frame:SetScript("OnHide", function()
		if this.isMoving then
			this:StopMovingOrSizing();
			this.isMoving = false;
		end
	end)
	frame:SetScript("OnEnter", EFCReport_OnEnter)
	frame:SetScript("OnLeave", EFCReport_OnLeave)

	-- Create the buttons
	for i,btn in pairs(buttons) do
		local btn_frame = CreateFrame("Button", btn.text, frame)
		btn_frame:SetPoint("TOPLEFT", frame, "TOPLEFT", btn.x, btn.y)
		btn_frame.id = i
		btn_frame:SetWidth(btn.w)
		btn_frame:SetHeight(btn.h)
		-- Handle clicks
		btn_frame:SetScript("OnClick", function()
			Print(buttons[this.id].text)
			SendChatMessage(buttons[this.id].text ,"Battleground" ,"common")
		end)
		btn_frame:SetBackdrop( {
				bgFile = iconPath..btn.bkg,
				edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
				tile = true,
				tileSize = 32,
				edgeSize = 1,
				insets = { left = 1, right = 1, top = 1, bottom = 1 }
			} );
		btn_frame:SetNormalTexture(iconPath..btn.tex)
		btn_frame:SetHighlightTexture(iconPath..btn.tex)
		btn_frame:SetPushedTexture(iconPath..btn.tex)
		btn_frame:GetHighlightTexture():SetTexture(0.4,0.3,0.3,0.2)
		btn_frame:GetPushedTexture():SetTexture(0.4,0.3,0.3,0.5)
		btn_frame:SetScript("OnEnter", EFCReport_OnEnter)
		btn_frame:SetScript("OnLeave", EFCReport_OnLeave)
	end
	EFCReport.created = true
end