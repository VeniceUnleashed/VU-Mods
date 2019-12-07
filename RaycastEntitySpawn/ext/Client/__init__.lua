class 'RaycastEntitySpawnClient'


function RaycastEntitySpawnClient:__init()
	print("Initializing RaycastEntitySpawnClient")
	self:RegisterVars()
	self:RegisterEvents()
end


function RaycastEntitySpawnClient:RegisterVars()
	self.m_DynamicModels = {}
	self.m_spawned = {}
end


function RaycastEntitySpawnClient:RegisterEvents()
	Events:Subscribe('Partition:Loaded', self, self.OnPartitionLoaded)
	Events:Subscribe('Engine:Update', self, self.OnEngineUpdate)

end

function RaycastEntitySpawnClient:OnPartitionLoaded(p_Partition)
	if p_Partition == nil then
		error('p_Partition was nil')
		return
	end
 
	local instances = p_Partition.instances
   
	for _, instance in ipairs(instances) do
		if instance == nil then
			print("Instance is null wtf")
			break
		end

		if instance.typeName == "DynamicModelEntityData" then
			local s_Instance = DynamicModelEntityData(instance)
			local s_Mesh = Asset(s_Instance.mesh)
			table.insert(self.m_DynamicModels, s_Instance)
		end
	end
end

function RaycastEntitySpawnClient:OnEngineUpdate(p_Delta, p_SimDelta)
	local s_LocalPlayer = PlayerManager:GetLocalPlayer()
    if(s_LocalPlayer == nil) then
    	return
    end
	if s_LocalPlayer.soldier == nil then
		return
	end
	if InputManager:WentKeyDown(InputDeviceKeys.IDK_F1) then
		-- WebUI:ExecuteJS('document.location.reload()')
		self:SpawnDyn(s_LocalPlayer.soldier.transform)
	end

	if InputManager:WentKeyDown(InputDeviceKeys.IDK_F2) then
		-- WebUI:ExecuteJS('document.location.reload()')
		self:MoveDyn(s_LocalPlayer.soldier.transform)
	end
end


function RaycastEntitySpawnClient:SpawnDyn( p_Transform )
	p_Transform.trans.y = p_Transform.trans.y + 10
	self.m_spawned[1] = EntityManager:CreateClientEntity(self.m_DynamicModels[1], p_Transform)
	--print("so far so good")

	if self.m_spawned[1] == nil then
		--print("Could not spawn explosion")
		return
	end
	self.m_spawned[1]:Init(Realm.Realm_Client, true)

	--print("spawned explosion")
end

function RaycastEntitySpawnClient:MoveDyn( p_Transform )
	print(tostring(self.m_spawned[1]))
	local s_Spatial = SpatialEntity.new(self.m_spawned[1])
	s_Spatial.transform = p_Transform
end




g_RaycastEntitySpawnClient = RaycastEntitySpawnClient()

