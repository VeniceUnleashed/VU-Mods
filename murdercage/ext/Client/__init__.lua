class 'MurderCageShared'

function MurderCageShared:__init()
	self.m_ReadInstanceEvent = Events:Subscribe('Partition:ReadInstance', self, self.OnReadInstance)
	
	self.FuckGuid = Guid("296C4BE6-8C9E-46E4-98F6-59AA99AAF0EE", "D")
	self.M320SMK_GUID = Guid("2F200B5C-4958-467C-9E12-B99DDADE2332","D")
    self.M320SMK = nil
end

function MurderCageShared:OnReadInstance(p_Instance, p_Guid)
	if p_Instance == nil then
		return
	end
	
	if p_Guid == self.M320SMK_GUID then 
		print("M320SMK_GUID Found") 
		self.M320SMK = p_Instance 
	end
	
	if p_Instance.typeName == "MeleeWeaponData" then
			local MeleeWeapon = MeleeWeaponData(p_Instance)
			MeleeWeapon.useCannedAnimation = false
	end
		
	-- if p_Instance.typeName == "ZoomLevelData" then
		-- local s_Fuck = ZoomLevelData(p_Instance)
		-- s_Fuck.fieldOfView = 55
		-- s_Fuck.allowFieldOfViewScaling = false
		-- s_Fuck.useFovSpecialisation = false
	-- end
	
	-- if p_Instance.typeName == "VeniceSoldierCustomizationAsset" then
        -- local SoldierAsset = VeniceSoldierCustomizationAsset(p_Instance)
        -- print(SoldierAsset.name)
        -- local WeaponTable = SoldierAsset.weaponTable
		
		-- if WeaponTable == nil then
			-- return
		-- end
	
        -- local KnifeTable = WeaponTable:GetUnlockPartsAt(7)
		-- if KnifeTable == nil then
			-- print("KnifeTable is nil.")
		-- end
		
        -- local PrimaryTable = WeaponTable:GetUnlockPartsAt(0)
		-- if PrimaryTable == nil then
			-- print("Primarytable is nil.")
		-- end
		
		-- print("Got Unlock Parts")
        -- WeaponTable:ClearUnlockParts()
		-- print("Cleared Unlock Parts")
        -- PrimaryTable:ClearSelectableUnlocks()
		-- print("Cleared Primary Unlock Parts")
		-- if self.M320SMK == nil then
			-- print("M320SMK is null")
		-- else
			-- PrimaryTable:AddSelectableUnlocks(UnlockAsset(self.M320SMK))
			-- print("M320SMK swapped")
		-- end
		-- print("Added Selectable Unlocks")
		
        -- WeaponTable:AddUnlockParts(PrimaryTable)

        -- WeaponTable:AddUnlockParts(KnifeTable)

    -- end
end

local m_MurderCageShared = MurderCageShared()

-- If external class use "return MyModName"