class 'DogfightServer'


function DogfightServer:__init()
	print("Initializing DogfightServer")
	self:RegisterVars()
	self:RegisterEvents()
end


function DogfightServer:RegisterVars()
	self.SU34 = nil
	self.F18 = nil
end


function DogfightServer:RegisterEvents()
	self.m_ReadInstanceEvent = Events:Subscribe('Partition:ReadInstance', self, self.ReadInstance)
end


function DogfightServer:ReadInstance(p_Instance, p_Guid)
	if p_Instance == nil then
		return
	end
	
	if p_Instance.typeName == "SomeType" then
		local s_Instance = SomeType(p_Instance)
		s_Instance.someThing = true
	end
	

	if p_Instance.typeName == "ReferenceObjectData" then
		local s_Instance = ReferenceObjectData(p_Instance)
		local s_blueprint = SpatialPrefabBlueprint(s_Instance.s_blueprint)
			if(s_blueprint.name == "Gameplay/Level_Setups/Dynamic_VehicleSpawners/DynamicSpawn_F18") then
				self.F18 = s_blueprint
			else if (s_blueprint.name == "Gameplay/Level_Setups/Dynamic_VehicleSpawners/DynamicSpawn_SU35") then

			end
		end
	end
end


g_DogfightServer = DogfightServer()

return DogfightServer
