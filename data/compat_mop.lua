--=====================================================================================
-- RGX | Simple Quest Plates! - compat_mop.lua
-- Version: 1.1.0
-- Author: DonnieDice
-- Description: MoP Classic nameplate compatibility layer
--=====================================================================================

local addonName, SQP = ...

-- Only load if modern nameplate API is not available
if C_NamePlate and C_NamePlate.GetNamePlateForUnit then return end

-- MoP nameplate tracking
local nameplateUpdateTimer = 0
local UPDATE_INTERVAL = 0.2  -- Update every 0.2 seconds (reduced frequency for better performance)
local COMBAT_UPDATE_INTERVAL = 0.5  -- Update less frequently in combat
local lastNameplateCount = 0
local nameplateCache = {}  -- Cache nameplate lookups

-- Store old nameplates
local oldNameplates = {}

-- Helper function to get nameplate children with caching
local function GetNameplateChildren()
    local frames = {}
    local worldFrame = WorldFrame
    
    for i = 1, worldFrame:GetNumChildren() do
        local frame = select(i, worldFrame:GetChildren())
        
        -- Use cache if we've seen this frame before
        if nameplateCache[frame] ~= nil then
            if nameplateCache[frame] then
                tinsert(frames, frame)
            end
        elseif frame and frame:GetObjectType() == "Frame" then
            -- Check if this is a nameplate (has specific regions)
            local regions = frame:GetNumRegions()
            if regions > 2 and regions < 10 then
                -- Additional checks to verify it's a nameplate
                local name = frame:GetName()
                if not name or not string.find(name, "NamePlate") then
                    -- Check for nameplate-like properties
                    local hasHealthBar = false
                    for j = 1, frame:GetNumChildren() do
                        local child = select(j, frame:GetChildren())
                        if child and child:GetObjectType() == "StatusBar" then
                            hasHealthBar = true
                            break
                        end
                    end
                    
                    if hasHealthBar then
                        nameplateCache[frame] = true
                        tinsert(frames, frame)
                    else
                        nameplateCache[frame] = false
                    end
                else
                    nameplateCache[frame] = false
                end
            else
                nameplateCache[frame] = false
            end
        end
    end
    
    return frames
end

-- Function to scan for nameplates
local function ScanNameplates()
    local currentNameplates = {}
    local nameplates = GetNameplateChildren()
    
    for _, nameplate in ipairs(nameplates) do
        currentNameplates[nameplate] = true
        
        -- Check if this is a new nameplate
        if not oldNameplates[nameplate] then
            -- New nameplate appeared
            if not SQP.QuestPlates[nameplate] then
                SQP:CreateQuestPlate(nameplate)
            end
            
            -- Try to get unit from nameplate
            local unitID = nil
            if nameplate.namePlateUnitToken then
                unitID = nameplate.namePlateUnitToken
            elseif nameplate.unit then
                unitID = nameplate.unit
            else
                -- Try to match by mouseover
                if UnitExists("mouseover") and nameplate:IsVisible() and nameplate:IsMouseOver() then
                    unitID = "mouseover"
                else
                    -- Try to match by target
                    if UnitExists("target") and nameplate:IsVisible() then
                        -- This is less reliable but better than nothing
                        unitID = "target"
                    end
                end
            end
            
            if unitID and nameplate:IsVisible() then
                SQP:OnPlateShow(nameplate, unitID)
            end
        elseif nameplate:IsVisible() then
            -- Existing nameplate, update it
            local unitID = nil
            if nameplate._unitID then
                unitID = nameplate._unitID
            elseif nameplate.namePlateUnitToken then
                unitID = nameplate.namePlateUnitToken
            elseif nameplate.unit then
                unitID = nameplate.unit
            end
            
            if unitID then
                SQP:UpdateQuestIcon(nameplate, unitID)
            end
        end
    end
    
    -- Check for removed nameplates
    for nameplate in pairs(oldNameplates) do
        if not currentNameplates[nameplate] or not nameplate:IsVisible() then
            -- Nameplate was removed or hidden
            SQP:OnPlateHide(nameplate, nameplate._unitID)
        end
    end
    
    -- Update the old nameplates list
    oldNameplates = currentNameplates
end

-- OnUpdate handler for scanning nameplates
local function OnUpdate(self, elapsed)
    nameplateUpdateTimer = nameplateUpdateTimer + elapsed
    
    -- Use longer interval in combat for better performance
    local interval = InCombatLockdown() and COMBAT_UPDATE_INTERVAL or UPDATE_INTERVAL
    
    if nameplateUpdateTimer >= interval then
        nameplateUpdateTimer = 0
        
        -- Only scan if addon is enabled
        if SQPSettings and SQPSettings.enabled then
            -- Skip scan if nothing has changed
            local currentCount = WorldFrame:GetNumChildren()
            if currentCount ~= lastNameplateCount then
                lastNameplateCount = currentCount
                ScanNameplates()
            else
                -- Just update existing visible nameplates
                for nameplate in pairs(oldNameplates) do
                    if nameplate:IsVisible() and nameplate._unitID then
                        SQP:UpdateQuestIcon(nameplate, nameplate._unitID)
                    end
                end
            end
        end
    end
end

-- Override GetNamePlateForUnit for MoP
SQP.Compat.GetNamePlateForUnit = function(unitID)
    -- MoP doesn't have C_NamePlate
    -- Try to find nameplate by matching unit
    local nameplates = GetNameplateChildren()
    
    for _, nameplate in ipairs(nameplates) do
        if nameplate._unitID == unitID or 
           nameplate.namePlateUnitToken == unitID or
           nameplate.unit == unitID then
            return nameplate
        end
    end
    
    -- Fallback: check if mouseover/target
    if unitID == "mouseover" then
        for _, nameplate in ipairs(nameplates) do
            if nameplate:IsVisible() and nameplate:IsMouseOver() then
                return nameplate
            end
        end
    elseif unitID == "target" then
        -- Less reliable but sometimes works
        for _, nameplate in ipairs(nameplates) do
            if nameplate:IsVisible() and nameplate:GetAlpha() == 1 then
                -- Target nameplates often have full alpha
                return nameplate
            end
        end
    end
    
    return nil
end

-- Override GetNamePlates for MoP
SQP.Compat.GetNamePlates = function()
    return GetNameplateChildren()
end

-- Set up the update frame for MoP
local updateFrame = CreateFrame("Frame")
updateFrame:SetScript("OnUpdate", OnUpdate)

-- Function to refresh all nameplates
function SQP:RefreshAllNameplates()
    if not SQP.isMoP then
        -- Use the regular version for non-MoP
        for plate in pairs(self.ActiveNameplates) do
            self:UpdateQuestIcon(plate)
        end
    else
        -- Force a rescan for MoP
        ScanNameplates()
    end
end

-- Hook into PLAYER_TARGET_CHANGED for better unit matching
local originalTargetChanged = SQP.PLAYER_TARGET_CHANGED
function SQP:PLAYER_TARGET_CHANGED()
    if originalTargetChanged then
        originalTargetChanged(self)
    end
    
    -- Update target nameplate
    if UnitExists("target") then
        local nameplate = SQP.Compat.GetNamePlateForUnit("target")
        if nameplate then
            nameplate._unitID = "target"
            self:UpdateQuestIcon(nameplate, "target")
        end
    end
end

-- Register the event
SQP.eventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")

-- Hook into UPDATE_MOUSEOVER_UNIT for better unit matching
local originalMouseoverUpdate = SQP.UPDATE_MOUSEOVER_UNIT
function SQP:UPDATE_MOUSEOVER_UNIT()
    if originalMouseoverUpdate then
        originalMouseoverUpdate(self)
    end
    
    -- Update mouseover nameplate
    if UnitExists("mouseover") then
        local nameplate = SQP.Compat.GetNamePlateForUnit("mouseover")
        if nameplate then
            nameplate._unitID = "mouseover"
            self:UpdateQuestIcon(nameplate, "mouseover")
        end
    end
end

-- Register the event
SQP.eventFrame:RegisterEvent("UPDATE_MOUSEOVER_UNIT")