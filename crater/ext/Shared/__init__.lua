class 'craterShared'


function craterShared:__init()
	print("Initializing craterShared")
	self:RegisterVars()
	self:RegisterEvents()
end


function craterShared:RegisterVars()
	--self.m_this = that
end


function craterShared:RegisterEvents()
	self.m_PartitionLoadedEvent = Events:Subscribe('Partition:Loaded', self, self.OnPartitionLoaded)
	Events:Subscribe('Server:LevelLoaded', self, self.OnLevelLoaded)
end

function craterShared:OnLevelLoaded(p_Map, p_GameMode, p_Round)

end
function craterShared:OnPartitionLoaded(p_Partition)
	if p_Partition == nil then
		return
	end
	
	local s_Instances = p_Partition.instances


	for _, l_Instance in ipairs(s_Instances) do
		if l_Instance == nil then
			print('Instance is null?')
			break
		end
		if(l_Instance.typeInfo.name == "VeniceExplosionEntityData") then
			local s_Instance = VeniceExplosionEntityData(l_Instance:Clone(l_Instance.instanceGuid))
			s_Instance.blastDamage = 100000
			p_Partition:ReplaceInstance(l_Instance, s_Instance, true)
		end

		if(l_Instance.typeInfo.name == "MaterialRelationTerrainDestructionData") then
			local s_Instance = MaterialRelationTerrainDestructionData(l_Instance:Clone(l_Instance.instanceGuid))
			s_Instance.width = s_Instance.width * -10
			s_Instance.depth = s_Instance.depth * -10

			p_Partition:ReplaceInstance(l_Instance, s_Instance, true)
		end

		 
	end
	local s_SyncedBFSettings = ResourceManager:GetSettings("TerrainSettings")

	if s_SyncedBFSettings ~= nil then
		local s_Settings = TerrainSettings(s_SyncedBFSettings)
		s_Settings.heightQueryCacheSize = 32.000000
		s_Settings.modifiersCapacity = 5000.000000
		s_Settings.intersectingModifiersMax = 500
		s_Settings.modifierDepthFactor = 20
		s_Settings.modifierSlopeMax = 50
		s_Settings.modifiersEnable = true
	end
end


g_craterShared = craterShared()

