--
-- EFCReport by Cubenicke aka Yrrol@vanillagaming
-- Thx for the good looking graphics lanevegame!
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
	EFCRSaves = { scale = 0, x = 0, y = 0, dim = false }
end

local buttons = {
	{ x={2,2}, y={-2,-2}, w=32, h=32, tex = "repic28", text="Get ready to repick!"},
	{ x={34,34}, y={-2,-194}, w=64, h=32, tex = "aroof.blp", text="EFC Alliance roof!"},
	{ x={98,98}, y={-2,-2}, w=32, h=32, tex = "cap28", text="Get ready to cap!"},
	{ x={2,98}, y={-34,-162}, w=32, h=32, tex = "agy.blp", text="EFC Alliance graveyard!"},
	{ x={34,66}, y={-34,-162}, w=32, h=32, tex = "afr.blp", text="EFC Alliance flag room!"},
	{ x={66,34}, y={-34,-162}, w=32, h=32, tex = "abalc.blp", text="EFC Alliance balcony!"},
	{ x={98,2}, y={-34,-162}, w=32, h=32, tex = "aramp.blp", text="EFC Alliance ramp!"},
	{ x={2,98}, y={-66,-130}, w=32, h=32, tex = "aresto.blp", text="EFC Alliance resto hut!"},
	{ x={34,66}, y={-66,-130}, w=32, h=32, tex = "afence.blp", text="EFC Alliance fence!"},
	{ x={66,34}, y={-66,-130}, w=32, h=32, tex = "atun.blp", text="EFC Alliance tunnel!"},
	{ x={98,2}, y={-66,-130}, w=32, h=32, tex = "azerk.blp", text="EFC Alliance zerker hut!"},
	{ x={18,18}, y={-98,-98}, w=32, h=32, tex = "west.blp", text="EFC west!"},
	{ x={50,50}, y={-98,-98}, w=32, h=32, tex = "mid.blp", text="EFC midfield!"},
	{ x={82,82}, y={-98,-98}, w=32, h=32, tex = "east.blp", text="EFC east!"},
	{ x={2,98}, y={-130,-66}, w=32, h=32, tex = "hzerk.blp", text="EFC Horde zerker hut!"},
	{ x={34,66}, y={-130,-66}, w=32, h=32, tex = "htun.blp", text="EFC Horde tunnel!"},
	{ x={66,34}, y={-130,-66}, w=32, h=32, tex = "hfence.blp", text="EFC Horde fence!"},
	{ x={98,2}, y={-130,-66}, w=32, h=32, tex = "hresto.blp", text="EFC Horde resto hut!"},
	{ x={2,98}, y={-162,-34}, w=32, h=32, tex = "hramp.blp", text="EFC Horde ramp!"},
	{ x={34,66}, y={-162,-34}, w=32, h=32, tex = "hbalc.blp", text="EFC Horde balcony!"},
	{ x={66,34}, y={-162,-34}, w=32, h=32, tex = "hfr.blp", text="EFC Horde flag room!"},
	{ x={98,2}, y={-162,-34}, w=32, h=32, tex = "hgy.blp", text="EFC Horde graveyard!"},
	{ x={34,34}, y={-194,-2}, w=64, h=32, tex = "hroof.blp", text="EFC Horde roof!"},
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
	elseif cmd == "dim" then
		if EFCRSaves.dim then
			EFCReport.EFCFrame:SetAlpha(1)
			EFCRSaves.dim = false
		else
			EFCReport.EFCFrame:SetAlpha(0.4)
			EFCRSaves.dim = true
		end
	else
		Print("Unknown command "..cmd)
	end
end

function EFCReport_OnEnter()
	if EFCRSaves.dim then
		EFCReport.EFCFrame:SetAlpha(1)
	end
end

function EFCReport_OnLeave()
	if EFCRSaves.dim then
		EFCReport.EFCFrame:SetAlpha(0.4)
	end
end

-- Create the EFCReport dialog
function EFCReport:create()
	-- Option Frame
	local frame = CreateFrame("Frame", "EFCRFrame")
	local ix

	EFCReport.EFCFrame = frame

	tinsert(UISpecialFrames,"EFCReport")

	if UnitFactionGroup("player") == "Horde" then
		ix = 1
		EFCReport.Language = "Orcish"
	else
		ix = 2
		EFCReport.Language = "Common"
	end

	-- Set scale, size and position
	frame:SetWidth(132)
	frame:SetHeight(228)
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
	  edgeFile = "Interface\\Tooltips\\UI-Tooltip-Background",
	  tile = true, 
	  tileSize = 32, 
	  edgeSize = 2, 
	  insets = { left = 2, right = 2, top = 2, bottom = 2 }
	} );
	frame:SetBackdropColor(0, 0, 0, .91)
	frame:SetBackdropBorderColor(0.3, 0.3, 0.3, 1)

	-- Make it moveable
	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:SetClampedToScreen(false)
	if EFCRSaves.dim then
		frame:SetAlpha(0.4)
	end
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
		btn_frame:SetPoint("TOPLEFT", frame, "TOPLEFT", btn.x[ix], btn.y[ix])
		btn_frame.id = i
		btn_frame:SetWidth(btn.w)
		btn_frame:SetHeight(btn.h)
		-- Handle clicks
		btn_frame:SetScript("OnClick", function()
			Print(buttons[this.id].text)
			SendChatMessage(buttons[this.id].text ,"Battleground" , EFCReport.Language)
		end)
		btn_frame:SetBackdrop( {
			bgFile = iconPath..btn.tex,
		} );
		btn_frame:SetScript("OnEnter", EFCReport_OnEnter)
		btn_frame:SetScript("OnLeave", EFCReport_OnLeave)
	end
	EFCReport.created = true
end