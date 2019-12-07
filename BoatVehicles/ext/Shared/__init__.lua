class 'BoatVehiclesShared'


function BoatVehiclesShared:__init()
	print("Initializing BoatVehiclesShared")
	self:RegisterVars()
	self:RegisterEvents()
end


function BoatVehiclesShared:RegisterVars()
	self.m_BoatFloatPhysics = nil
end

function BoatVehiclesShared:CreatePhysics()
end

function BoatVehiclesShared:RegisterEvents()
	self.m_ReadInstanceEvent = Events:Subscribe('Partition:ReadInstance', self, self.ReadInstance)
end


function BoatVehiclesShared:ReadInstance(p_Instance,p_PartitionGuid, p_Guid)
	if p_Instance == nil then
		return
	end

	if p_Instance.typeName == "VehicleEntityData" then
		local s_Instance = VehicleEntityData(p_Instance)
		s_Instance.throwOutSoldierInsideOnWaterDamage = false 
		s_Instance.waterDamage = 0 
		s_Instance.belowWaterDamageDelay = 2.0
		s_Instance.waterDamageOffset = 0 

	end

	if p_Instance.typeName == "EngineComponentData" then
		local s_Instance = EngineComponentData(p_Instance)
		s_Instance.outputIsEngineInWater = false 
	end

	if p_Instance.typeName == "JetEngineConfigData" then
		local s_Instance = JetEngineConfigData(p_Instance)
		s_Instance.isWaterJetEngine  = false 
	end

	if p_Instance.typeName == "VehicleBlueprint" then
		local s_Instance = VehicleBlueprint(p_Instance)

		local s_PropertyCount = s_Instance:GetPropertyConnectionsCount()
		for i = 0, s_PropertyCount - 1, 1 do
			local s_Property = PropertyConnection(s_Instance:GetPropertyConnectionsAt(i))
			if(s_Property.sourceFieldId == 1713942477) then
				print("Found propertyconnection")
				s_Property.source = nil
				s_Property.target = nil
				s_Property.sourceFieldId = 0
				s_Property.targetFieldId = 0
			end
		end 

		
			
	
	end


	if p_Instance.typeName == "VehicleConfigData" then
		local s_Instance = VehicleConfigData(p_Instance)

		local s_BoatFloatPhysics = BoatFloatPhysicsData()
		s_BoatFloatPhysics.density = 0.5
		s_BoatFloatPhysics.filledDensity = 1.2
		s_BoatFloatPhysics.subSurfaceSplits = 10
		s_BoatFloatPhysics.depth = 0
		s_BoatFloatPhysics.width = 0.0
		s_BoatFloatPhysics.length = 0.0
		s_BoatFloatPhysics.frontCurveDegree = 3.0
		s_BoatFloatPhysics.sideCurveDegree = 2.0
		s_BoatFloatPhysics.nonEngineSteer = 3.5
		s_BoatFloatPhysics.nonEngineSteerMinSpeed = 0.0
		s_BoatFloatPhysics.nonEngineSteerMaxSpeed = 0.0
		s_BoatFloatPhysics.waterDampeningMod = 2.0
		s_BoatFloatPhysics.liftModifier = 0.5
		s_BoatFloatPhysics.supportSizeMod = 1.0
		s_BoatFloatPhysics.angularDampening = 0.01
		s_BoatFloatPhysics.frictionThrottleModifier = 0.0
		s_BoatFloatPhysics.frontRatio = 0.6
		s_BoatFloatPhysics.waterResistanceAxisMod = Vec3(1,1,1)
		s_BoatFloatPhysics.waterFrictionAxisMod = Vec3(8,1,0.25)
		s_BoatFloatPhysics.offset = Vec3(0,0,0)

		s_Instance.floatPhysics  = s_BoatFloatPhysics

	end
	
end


g_BoatVehiclesShared = BoatVehiclesShared()

