class 'deepholesShared'


function deepholesShared:__init()
	print("Initializing deepholesShared")
	self:RegisterVars()
	self:RegisterEvents()
end


function deepholesShared:RegisterVars()
	--self.m_this = that
end


function deepholesShared:RegisterEvents()
	self.m_PartitionLoadedEvent = Events:Subscribe('Partition:Loaded', self, self.OnPartitionLoaded)
end


function deepholesShared:OnPartitionLoaded(p_Partition)
	if p_Partition == nil then
		return
	end
	
	local s_Instances = p_Partition.instances


	for _, l_Instance in ipairs(s_Instances) do
		if l_Instance == nil then
			print('Instance is null?')
			break
		end
		if(l_Instance.typeInfo.Name == "MaterialRelationTerrainDestructionData") then
			local s_Instance = MaterialRelationTerrainDestructionData(l_Instance:Clone(l_Instance.instanceGuid))
			s_Instance.width = 255
			s_Instance.depth = 255

			p_Partiton:ReplaceInstance(l_Instance, s_Instance, true)
		end
	end
end


g_deepholesShared = deepholesShared()

