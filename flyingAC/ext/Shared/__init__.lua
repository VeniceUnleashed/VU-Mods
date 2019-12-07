class 'flyingACShared'


function flyingACShared:__init()
	print("Initializing flyingACShared")
	self:RegisterVars()
	self:RegisterEvents()

end


function flyingACShared:RegisterVars()
	self.inputConceptDefinition = nil
	self.linkConnections = {}
	self.Engine = {}
	self.changed = false
end


function flyingACShared:RegisterEvents()
	self.m_ReadInstanceEvent = Events:Subscribe('Partition:ReadInstance', self, self.ReadInstance)
end


function flyingACShared:ReadInstance(p_Instance,p_PartitionGuid, p_Guid)
	if p_Instance == nil then
		return
	end
	
	if p_Instance.typeName == "CapturePointEntityData" then
		local s_Instance = CapturePointEntityData(p_Instance)
		s_Instance.minNrToTakeControl = 1
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

	if p_Guid == Guid('4CD8344D-325B-4F0E-831F-7956FFA02B86', 'D') then
		local s_Instance = EngineComponentData(p_Instance)
		local s_JetEngine = JetEngineConfigData()
		s_JetEngine.position = Vec3(0.0,0.0,-5.0)
		s_JetEngine.rpmMin = 0.0
		s_JetEngine.rpmMax = 1000.0
		s_JetEngine.rpmCut = 9500.0
		s_JetEngine.enginePowerMultiplier = 1.4
		s_JetEngine.internalAccelerationFactor = 0.65
		s_JetEngine.internalDeaccelerationFactor = 0.5
		s_JetEngine.boost.forwardStrength = 1.5
		s_JetEngine.boost.reverseStrength = 1.0
		s_JetEngine.boost.dissipationTime = 9999.0
		s_JetEngine.boost.recoveryTime = 1.0
		s_JetEngine.boost.crawlStrength = 0.78
		s_JetEngine.boost.accelerationScale = 1.0
		s_JetEngine.directionVectorIndex = 2
		s_JetEngine.forceMagnitudeMultiplier = 270.0
		s_JetEngine.angleInputYMultiplier = 0.0
		s_JetEngine.angleInputPitchMultiplier = 0.0
		s_JetEngine.maxVelocity = 0.0
		s_JetEngine.isTurnable = false
		s_JetEngine.isWaterJetEngine = false
		s_JetEngine.powerFadeOutRange = Vec2(1000.0,1500.0)
		s_JetEngine:ClearRpmCurvePoints()
		s_JetEngine:ClearTorqueCurvePoints()
		s_JetEngine:AddRpmCurvePoints(0.0)
		s_JetEngine:AddRpmCurvePoints(250.0)
		s_JetEngine:AddRpmCurvePoints(500.0)
		s_JetEngine:AddRpmCurvePoints(750.0)
		s_JetEngine:AddRpmCurvePoints(1000.0)
		s_JetEngine:AddTorqueCurvePoints(0.0)
		s_JetEngine:AddTorqueCurvePoints(5.0)
		s_JetEngine:AddTorqueCurvePoints(15.0)
		s_JetEngine:AddTorqueCurvePoints(50.0)
		s_JetEngine:AddTorqueCurvePoints(150.0)
		
		s_Instance.config = s_JetEngine
	end


	if p_Guid == Guid("122670EA-AD0E-414B-B2C6-6C88772A3C7D", 'D') then
		local s_Instance = AeroDynamicPhysicsData(p_Instance)
		s_Instance.bodyDrag = Vec3(0.035, 0.08, 0.0042)
		s_Instance.bodyDragOffsetYZ = Vec3(0,0,-0.2)

	end


	if p_Guid == Guid('5426CEA4-D2E7-431F-9FD3-98D0F13885B6', 'D') then
		local s_Instance = VehicleConfigData(p_Instance)
		--s_Instance.bodyMass = 1
		s_Instance.centerOfMass = Vec3(0.0, -2.0, 0.0)
    	s_Instance.centerOfMassHandlingOffset = Vec3(0.0,2.0,0.0)
    	s_Instance.inertiaModifier = Vec3(1.04, 2.1, 0.8)


		s_Instance:ClearConstantForce()
		s_Instance.input.yawDeadzone = 0
		s_Instance.input.pitchDeadzone = 0
		s_Instance.input.rollDeadzone = 0
		s_Instance.input.throttleInertiaOutDuration = 1.2 
		s_Instance.input.throttleInertiaInDuration = 1.2
		s_Instance.input.yawInertiaOutDuration = 0.2
		s_Instance.input.yawInertiaInDuration = 0.2
		s_Instance.vehicleModeChangeEnteringTime = 0.0
		s_Instance.vehicleModeChangeStartingTime = 0.0
	end

	if p_Guid == Guid('B93C94B0-3639-4104-B796-B6209F1CB8C7', 'D') then
		print("Found inputConceptDefinition")
		print(tostring(p_PartitionGuid))
		self.inputConceptDefinition = p_Instance
	end
	if p_Guid == Guid('E700C81E-1AEC-4D76-AB3B-7F3F3E93FFFF', 'D') then
		self.InputCurves1 = p_Instance
		print("Found InputCurves1")
	end
	if p_Guid == Guid('73F75413-E331-495C-8947-BD19E9280649', 'D') then
		self.InputCurves2 = p_Instance
		print("Found InputCurves2")
	end
	if p_Guid == Guid('B1AE4D88-E1AB-46A2-8F37-210F50EDC142', 'D') then
		self.InputCurves3 = p_Instance
		print("Found InputCurves3")
	end
	if p_Guid == Guid('52CE08E2-BA19-4C45-9106-59E6E5C64A85', 'D') then
		self.InputCurves4 = p_Instance
		print("Found InputCurves4")
	end


	if p_Guid == Guid('561E82B1-FDB8-CE19-B9B5-79CB5B57E94F', 'D') then -- AC130 blueprint
		local s_Instance = VehicleBlueprint(p_Instance)
		print("Found AC130 Blueprint")
	end

	if p_Guid == Guid('03F37192-B626-9E7F-B42A-F964B1F261DA', 'D') then
		local s_Instance = ChassisComponentData(p_Instance)
		s_Instance.alwaysFullThrottle = false 
		print("Found AC130 Blueprint")
	end
	


	if p_Guid == Guid('16908E3C-7860-425E-A0D4-130D4FCDB2AF', 'D') then
		local s_Instance = PlayerEntryComponentData(p_Instance)
		s_Instance.entryOrderNumber = 1
		s_Instance.lockSoldierAimingToEntry = false 
		self.ac130 = PlayerEntryComponentData(p_Instance)
		print("Found AC130")
	end
	if p_Guid == Guid('1A942135-B32F-41B1-9D90-07014C1BA1A3', 'D') then
		local s_Instance = PlayerEntryComponentData(p_Instance)
		s_Instance.entryOrderNumber = 2
	end
	if p_Guid == Guid('FBD3FD1A-A5C0-4EB5-9104-1A3F7FB2F341', 'D') then
		local s_Instance = PlayerEntryComponentData(p_Instance)
		s_Instance.entryOrderNumber = 3
	end




	 
	 if(
	self.InputCurves1 ~= nil and
	self.InputCurves2 ~= nil and
	self.InputCurves3 ~= nil and
	self.InputCurves4 ~= nil and
	self.ac130 ~= nil and
	self.changed == false) then

	 	print("AC130 preparing for liftoff")
	 	self.ac130.inputConceptDefinition = EntryInputActionMapsData(ResourceManager:FindInstanceByGUID(Guid('BB0CD60B-9EA8-4AE0-B46A-047B07C7D4F3', "D"), Guid('B93C94B0-3639-4104-B796-B6209F1CB8C7', "D")))
	 	self.ac130:AddInputCurves(InputCurveData(self.InputCurves1))
	 	self.ac130:AddInputCurves(InputCurveData(self.InputCurves2))
	 	self.ac130:AddInputCurves(InputCurveData(self.InputCurves3))
	 	self.ac130:AddInputCurves(InputCurveData(self.InputCurves4))
	 	self.changed = true
	 	print("AC130 ready for liftoff")

	 end


	
end


g_flyingACShared = flyingACShared()

