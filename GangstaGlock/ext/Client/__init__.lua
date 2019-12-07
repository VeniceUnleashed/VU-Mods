class 'GangstaGlockClient'


function GangstaGlockClient:__init()
	print("Initializing GangstaGlockClient")
	self:RegisterVars()
	self:RegisterEvents()
end


function GangstaGlockClient:RegisterVars()
	--self.m_this = that
end


function GangstaGlockClient:RegisterEvents()
	self.m_ReadInstanceEvent = Hooks:Install('Partition:ReadInstance', 100, self, self.ReadInstance)
end


function GangstaGlockClient:ReadInstance(p_Hook, p_Instance, p_PartitionGuid, p_Guid)
	if p_Instance == nil then
		return
	end
	
	if p_Guid == Guid('3EC4D98C-E7A2-3679-2C2D-9E6C16F126A9','D') then
		local s_Instance = SoldierWeaponData(p_Instance)
		s_Instance.transform =
	end
	
end


g_GangstaGlockClient = GangstaGlockClient()

