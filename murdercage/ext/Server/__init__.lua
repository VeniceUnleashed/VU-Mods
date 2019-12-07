class 'MurderCage'

function MurderCage:__init()
	self.m_ReadInstanceEvent = Events:Subscribe('Partition:ReadInstance', self, self.OnReadInstance)
	
	self.M320SMK_GUID = Guid("2F200B5C-4958-467C-9E12-B99DDADE2332","D")
    self.M320SMK = nil
end

function MurderCage:OnReadInstance(p_Instance, p_Guid)
	if p_Instance == nil then
		return
	end
	
	local s_Container = DataContainer(p_Instance)
	
	 if s_Container.typeName == "AlternateSpawnEntityData" then
		 local s_RandomX = math.random(-186.882629, -181.067932)
		 local s_RandomY = 65.0
		 local s_RandomZ = math.random(-483.270477, -477.227875)
		
		 local s_SpawnData = AlternateSpawnEntityData(p_Instance)
		 s_SpawnData.transform = LinearTransform(
			 Vec3(0.5, 0, 0),
			 Vec3(0, 0.5, 0),
			 Vec3(0, 0, 0.5),
			 Vec3(s_RandomX, s_RandomY, s_RandomZ))
	end
	
	if p_Guid == self.M320SMK_GUID then 
		print("M320SMK_GUID Found") 
		self.M320SMK = p_Instance 
	end
	
	if p_Instance.typeName == "MeleeWeaponData" then
			local MeleeWeapon = MeleeWeaponData(p_Instance)
			MeleeWeapon.useCannedAnimation = false
	end
		
	 if p_Instance.typeName == "VeniceSoldierCustomizationAsset" then
         local SoldierAsset = VeniceSoldierCustomizationAsset(p_Instance)
         print(SoldierAsset.name)
         local WeaponTable = SoldierAsset.weaponTable
		
		 if WeaponTable == nil then
			 return
		 end
	
         local KnifeTable = WeaponTable:GetUnlockPartsAt(7)
		 if KnifeTable == nil then
			 print("KnifeTable is nil.")
		 end
		
         local PrimaryTable = WeaponTable:GetUnlockPartsAt(0)
		 if PrimaryTable == nil then
			 print("Primarytable is nil.")
		end
		
		 print("Got Unlock Parts")
         WeaponTable:ClearUnlockParts()
		 print("Cleared Unlock Parts")
         PrimaryTable:ClearSelectableUnlocks()
		 print("Cleared Primary Unlock Parts")
		 if self.M320SMK == nil then
			 print("M320SMK is null")
		 else
			 PrimaryTable:AddSelectableUnlocks(UnlockAsset(self.M320SMK))
			 print("M320SMK swapped")
		 end
		 print("Added Selectable Unlocks")
		
         WeaponTable:AddUnlockParts(PrimaryTable)
         WeaponTable:AddUnlockParts(KnifeTable)

     end
end
local m_MurderCage = MurderCage()

-- If external class use "return MyModName"