class 'VehicleSizeClient'


function VehicleSizeClient:__init()
	print("Initializing VehicleSizeClient")
	self:RegisterVars()
	self:RegisterEvents()
end


function VehicleSizeClient:RegisterVars()
	--local m_this = that
end


function VehicleSizeClient:RegisterEvents()
	self.m_ReadInstanceEvent = Events:Subscribe('Partition:ReadInstance', self, self.ReadInstance)
end


function VehicleSizeClient:ReadInstance(p_Instance, p_Guid)
	if p_Instance == nil then
		return
	end
	
	if p_Instance.typeName == "RigidBodyData" then
		local s_Instance = RigidBodyData(p_Instance)
		--s_Instance.collisionLayer = RigidBodyCollisionLayer.RigidBodyCollisionLayer_Size
	end

	if p_Instance.typeName == "ChassisComponentData" then
		local s_Instance = ChassisComponentData(p_Instance)

	end

end


g_VehicleSizeClient = VehicleSizeClient()

return VehicleSizeClient
