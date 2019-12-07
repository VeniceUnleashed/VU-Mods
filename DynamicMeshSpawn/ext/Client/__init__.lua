class 'DynamicMeshSpawnClient'


function DynamicMeshSpawnClient:__init()
	print("Initializing DynamicMeshSpawnClient")
	self:RegisterVars()
	self:RegisterEvents()
end


function DynamicMeshSpawnClient:RegisterVars()
	self.m_MeshAssets = {}
end


function DynamicMeshSpawnClient:RegisterEvents()
	self.m_ReadInstanceEvent = Events:Subscribe('Partition:ReadInstance', self, self.ReadInstance)

end


function DynamicMeshSpawnClient:ReadInstance(p_Instance,p_PartitionGuid, p_Guid)
	if p_Instance == nil then
		return
	end
	
	if p_Instance.typeName == "SomeType" then
		local s_Instance = SomeType(p_Instance)
		s_Instance.someThing = true
	end
	
	
	
end


g_DynamicMeshSpawnClient = DynamicMeshSpawnClient()

