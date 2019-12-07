class 'WeaponSpawnShared'


function WeaponSpawnShared:__init()
	print("Initializing WeaponSpawnShared")
	self:RegisterVars()
	self:RegisterEvents()
end


function WeaponSpawnShared:RegisterVars()
	--self.m_this = that
end


function WeaponSpawnShared:RegisterEvents()
	self.m_ReadInstanceEvent = Events:Subscribe('Partition:ReadInstance', self, self.ReadInstance)
end


function WeaponSpawnShared:ReadInstance(p_Instance,p_PartitionGuid, p_Guid)
	if p_Instance == nil then
		return
	end
	
	if p_Instance.typeName == "SomeType" then
		local s_Instance = SomeType(p_Instance)
		s_Instance.someThing = true
	end
	
	
	if p_Guid == Guid("Some-Guid", "D") then
		local s_Instance = SomeClass(p_Instance)
		s_Instance.someThing = true
	end
end


g_WeaponSpawnShared = WeaponSpawnShared()

