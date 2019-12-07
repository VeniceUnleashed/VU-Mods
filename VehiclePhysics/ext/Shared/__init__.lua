class 'VehiclePhysicsShared'


function VehiclePhysicsShared:__init()
	print("Initializing VehiclePhysicsShared")
	self:RegisterVars()
	self:RegisterEvents()
end


function VehiclePhysicsShared:RegisterVars()
	--self.m_this = that
end


function VehiclePhysicsShared:RegisterEvents()
	self.m_ReadInstanceEvent = Events:Subscribe('Partition:ReadInstance', self, self.ReadInstance)
end


function VehiclePhysicsShared:ReadInstance(p_Instance,p_PartitionGuid, p_Guid)
	if p_Instance == nil then
		return
	end
	
	if p_Instance.typeName == "ChildRotationBodyData" then
		local s_Instance = ChildRotationBodyData(p_Instance)
		s_Instance.usePostSatisfyConstraints = false
		s_Instance.angularConstraintMin = -360
		s_Instance.angularConstraintMax = 360
	end

	if p_Instance.typeName == "VehicleConfigData" then
		local s_Instance = VehicleConfigData(p_Instance)
		s_Instance.useMotorcycleControl = true 
	end

	if p_Instance.typeName == "VehicleEntityData" then
		local s_Instance = VehicleEntityData(p_Instance)
		s_Instance.maxPlayersInVehicle  = -1
	end

	if p_Instance.typeName == "PlayerEntryComponentData" then
		local s_Instance = PlayerEntryComponentData(p_Instance)
		s_Instance.forbiddenForHuman = false
		s_Instance.entryRadius = 20 
		s_Instance.isAllowedToExitInAir = true 

	end
	if p_Instance.typeName == "CameraComponentData" then
		local s_Instance = CameraComponentData(p_Instance)
		s_Instance.regularView.allowFieldOfViewScaling  = true  

	end

	 
	if p_Guid == Guid("Some-Guid", "D") then
		local s_Instance = SomeClass(p_Instance)
		s_Instance.someThing = true
		s_Instance.sPAllowed = true 
	end

end


g_VehiclePhysicsShared = VehiclePhysicsShared()

