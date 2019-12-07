class 'metrobikesShared'


function metrobikesShared:__init()
	print("Initializing metrobikesShared")
	self:RegisterVars()
	self:RegisterEvents()
end


function metrobikesShared:RegisterVars()
	self.registry = nil
	self.lav = nil
end


function metrobikesShared:RegisterEvents()
	self.m_PartitionLoadedEvent = Events:Subscribe('Partition:Loaded', self, self.OnPartitionLoaded)
	self.m_LevelLoadEvent = Events:Subscribe("Level:LoadResources", self, self.OnLoadResources)

end


function metrobikesShared:OnPartitionLoaded(p_Partition)
	if p_Partition == nil then
		return
	end
	
	local s_Instances = p_Partition.instances


	for _, l_Instance in ipairs(s_Instances) do
		if l_Instance == nil then
			print('Instance is null?')
			break
		end
		if l_Instance.instanceGuid == Guid('ADF563C9-28B1-C42B-993E-B2FD40F36078') then
			print("Found LAV")
			--local s_Instance = VehicleBlueprint(l_Instance)
			--self.lav = s_Instance
		end	

		if l_Instance.instanceGuid == Guid('EEBC7D5F-B8BA-A2C8-7C14-CE53212537EE') then
			print("Found registry")
			--self.registry = RegistryContainer(l_Instance:Clone())
			--p_Partition:ReplaceInstance(l_Instance, self.registry, true)
		end
	end
end

function metrobikesShared:OnLoadResources(p_Dedicated)
	print("Mounting bundles")
	ResourceManager:MountSuperBundle("Levels/MP_007/MP_007")
	ResourceManager:BeginLoadData(3, {
		'levels/mp_007/conquest_large'
	})
end


g_metrobikesShared = metrobikesShared()


