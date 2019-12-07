class 'SharedPatches'

local FlightCeiling = require '__shared/FlightCeiling'

function SharedPatches:__init()
	self:RegisterEvents()
	self:InitComponents()

	self.m_InvCol = Guid('8B71D173-8518-11E0-BB7A-DDA550615CAF', 'D')
	self.m_InvCol2 = Guid('C2E7889C-9CB2-11E0-A4B6-91A00ABC2528', 'D')
	self.m_InvCol3 = Guid('E05D532C-9CB2-11E0-A4B6-91A00ABC2528', 'D')

	self.m_InvCol4 = Guid('A75DADEA-BDC6-11E0-A4AD-D5BD8D209D9C', 'D')
	self.m_InvCol5 = Guid('743B1FF7-FCBE-41BD-B343-491C9A66BBA5', 'D')
	self.m_InvCol6 = Guid('1023699D-F571-4D7B-8CDF-2290541F8BBC', 'D')
	self.m_InvCol7 = Guid('D4650FCF-C9A5-11E0-928D-951B45190C6C', 'D')
	
	self.m_InvCol8 = Guid('1034FDAE-C9A4-11E0-928D-951B45190C6C', 'D')
	self.m_InvCol9 = Guid('21F3012F-C9A6-11E0-928D-951B45190C6C', 'D')
	self.m_InvCol10 = Guid('4B03F97E-C9A6-11E0-928D-951B45190C6C', 'D')
	self.m_InvCol11 = Guid('5658121F-C9A7-11E0-928D-951B45190C6C', 'D')
	self.m_InvCol12 = Guid('3F0FE56F-C9A7-11E0-928D-951B45190C6C', 'D')
	self.m_InvCol13 = Guid('25D585AF-C9A7-11E0-928D-951B45190C6C', 'D')

	self.emptyRefModel = StaticModelEntityData();

	self.m_m60ffd = Guid('1D44B441-7F16-46F3-9EFF-D0647D554EFE', 'D')
	self.m_mavpd = Guid('70BC2F3E-DCA5-4EDB-B6A4-0264B439556C', 'D')
	self.m_t90bp = Guid('60106975-DD7D-11DD-A030-B04E425BA11E', 'D')
	self.m_mortarmed = Guid('145C4108-7660-1329-4599-4402DA4801A0', 'D')
	self.g_c4pd = Guid('AA3BA4F5-2F8E-65FD-016A-D1E6F8C870FB', 'D')
	self.g_c4p = Guid('EB580047-B567-F95A-5057-BD42B132B8E4', 'D')
	
	self.m_c4p = nil
	self.m_c4pd = nil
	self.m_m60 = nil
	self.m_mav = nil
	self.m_t90 = nil
	self.m_mortar = nil
	self.modified = true
end

function SharedPatches:RegisterEvents()
	self.m_ReadInstanceEvent = Events:Subscribe('Partition:ReadInstance', self, self.ReadInstance)
end

function SharedPatches:InitComponents()
	self.m_FlightCeiling = FlightCeiling()
end


function SharedPatches:ReadInstance(p_Instance, p_Guid)
	if p_Instance == nil then
		return 
	end

	if p_Guid == self.m_m60ffd then
		self.m_m60 = p_Instance
	end

	if p_Guid == self.m_mavpd then
		self.m_mav = p_Instance
	end
	
	if p_Guid == self.m_t90bp then
		self.m_t90 = p_Instance
	end

	if p_Guid == self.m_mortarmed then
		self.m_mortar = p_Instance
	end
	if p_Guid == self.g_c4p then
		self.m_c4p = p_Instance
	end
	if p_Guid == self.g_c4pd then
		self.m_c4pd = p_Instance
	end
	if p_Instance.typeName == "MaterialRelationTerrainDestructionData" then
		local mrtdd = MaterialRelationTerrainDestructionData(p_Instance)
		mrtdd.depth = 20

	end

	if p_Instance.typeName == "LevelData" then
		local s_Instance = LevelData(p_Instance)
		local s_maxVehicleHeight = s_Instance.maxVehicleHeight
		s_vh = 100000000
	end
	if p_Instance.typeName == "VehicleEntityData" then
		local s_Instance = VehicleEntityData(p_Instance)
		local s_highAltitudeLockHeight = s_Instance.highAltitudeLockHeight
		s_highAltitudeLockHeight = 100000000
	end


	if p_Instance.typeName == "JumpStateData" then
		local s_Instance = JumpStateData(p_Instance)
		s_Instance.jumpHeight = 3
	end

	if p_Instance.typeName == "CharacterStatePoseInfo" then
		local s_Instance = CharacterStatePoseInfo(p_Instance)
		if s_Instance.sprintMultiplier ~= 0 then 
			s_Instance.sprintMultiplier = s_Instance.sprintMultiplier * 2
		
			print(tostring(s_Instance.sprintMultiplier))
		end		
	end

	if p_Instance.typeName == "ChassisComponentData" then
		local s_Instance = ChassisComponentData(p_Instance)
	--	s_Instance.transform = LinearTransform(
	--		 Vec3(4, 0, 0),
	--		 Vec3(0, 4, 0),
	--		 Vec3(0, 0, 4),
	--		 Vec3(0,0,0))
		
	end
	if p_Instance.typeName == "EmitterEntityData" then
		local s_Instance = EmitterEntityData(p_Instance)
		s_Instance.transform = LinearTransform(
			 Vec3(10, 0, 0),
			 Vec3(0, 10, 0),
			 Vec3(0, 0, 10),
			 Vec3(0,0,0))
		s_Instance.maxInstanceCount = 999999999
		
	end	
	if p_Instance.typeName == "EmitterTemplateData" then
		local s_Instance = EmitterTemplateData(p_Instance)
		s_Instance.DeployTime = 200000
		s_Instance.emissive = true
		
	end	
	if p_Instance.typeName == "ParachuteStateData" then
		local s_Instance = ParachuteStateData(p_Instance)
		s_Instance.deployTime = 0
		
	end	
	if p_Instance.typeName == "InAirStateData" then
		local s_Instance = InAirStateData(p_Instance)
		s_Instance.freeFallVelocity = 0
		
	end	



	if p_Instance.typeName == "WorldPartData" then
		local s_Instance = WorldPartData(p_Instance)
		print(s_Instance.name)
		if string.match(s_Instance.name, "Collision") then
			print(s_Instance.name)
			s_Instance:ClearObjects()
		end
		if string.match(s_Instance.name, "collision") then
			print(s_Instance.name)
			s_Instance:ClearObjects()
		end
		if string.match(s_Instance.name, "invisible") then
			print(s_Instance.name)
			s_Instance:ClearObjects()
		end
		if string.match(s_Instance.name, "Invisible") then
			print(s_Instance.name)
			s_Instance:ClearObjects()
		end
	end

	if p_Guid == self.m_InvCol then
		local s_Instance = StaticModelEntityData(p_Instance)
		print("FUCK YOU")
		s_Instance.enabled = false
		s_Instance:ClearComponents()
	end

	if p_Guid == self.m_InvCol2 then
		local s_Instance = StaticModelEntityData(p_Instance)
		print("FUCK YOU2")
		s_Instance.enabled = false
		s_Instance:ClearComponents()
	end
	if p_Guid == self.m_InvCol3 then
		local s_Instance = StaticModelEntityData(p_Instance)
		print("FUCK YOU3")
		s_Instance.enabled = false
		s_Instance:ClearComponents()
	end
	if p_Guid == self.m_InvCol4 then
		local s_Instance = StaticModelEntityData(p_Instance)
		print("FUCK YOU4")
		s_Instance.enabled = false
		s_Instance:ClearComponents()
	end
	if p_Guid == self.m_InvCol5 then
		local s_Instance = StaticModelEntityData(p_Instance)
		print("FUCK YOU5")
		s_Instance.enabled = false
		s_Instance:ClearComponents()
	end
	if p_Guid == self.m_InvCol6 then
		local s_Instance = StaticModelEntityData(p_Instance)
		print("FUCK YOU6")
		s_Instance.enabled = false
		s_Instance:ClearComponents()
	end
	if p_Guid == self.m_InvCol7 then
		local s_Instance = StaticModelEntityData(p_Instance)
		print("FUCK YOU7")
		s_Instance.enabled = false
		s_Instance:ClearComponents()
	end
	if p_Guid == self.m_InvCol8 then
		local s_Instance = StaticModelEntityData(p_Instance)
		print("FUCK YOU8")
		s_Instance.enabled = false
		s_Instance:ClearComponents()
	end
	if p_Guid == self.m_InvCol9 then
		local s_Instance = StaticModelEntityData(p_Instance)
		print("FUCK YOU9")
		s_Instance.enabled = false
		s_Instance:ClearComponents()
	end
	if p_Guid == self.m_InvCol10 then
		local s_Instance = StaticModelEntityData(p_Instance)
		print("FUCK YOU10")
		s_Instance.enabled = false
		s_Instance:ClearComponents()
	end
	if p_Guid == self.m_InvCol11 then
		local s_Instance = StaticModelEntityData(p_Instance)
		print("FUCK YOU11")
		s_Instance.enabled = false
		s_Instance:ClearComponents()
	end
	if p_Guid == self.m_InvCol12 then
		local s_Instance = StaticModelEntityData(p_Instance)
		print("FUCK YOU12")
		s_Instance.enabled = false
		s_Instance:ClearComponents()
	end
	if p_Guid == self.m_InvCol13 then
		local s_Instance = StaticModelEntityData(p_Instance)
		print("FUCK YOU13")
		s_Instance.enabled = false
		s_Instance:ClearComponents()
	end








	if self.m_m60 ~= nil and self.m_mav ~= nil and  self.m_t90 ~= nil and self.m_mortar ~= nil and self.m_c4p ~= nil and self.m_c4pd ~= nil and self.modified == false then

		local m60 = FiringFunctionData(self.m_m60)
		local mav = VehicleProjectileEntityData(self.m_mav)
		local t90 = VehicleBlueprint(self.m_t90)
		local mortar = MissileEntityData(self.m_mortar)
		local c4pd = ExplosionPackEntityData(self.m_c4pd)
		local c4p = ProjectileBlueprint(self.m_c4p)
		c4pd.maxCount = 0
		mav.vehicle = t90
		mav.alignWithGround = false
		mav.checkGroundWhenSpawned = false
		mav.timeToLive = 30
		mav.maxCount = 0

		print("[M60  PROJECTILE] Setting M60 to spawn (hopefully)")
		mortar.maxCount = 0
		m60.shot.projectileData = c4pd
		m60.shot.projectile = c4p
		m60.shot.initialSpeed = Vec3(0.0, 0.0, 50.0)
		m60.shot.initialPosition = Vec3(0.0, 0.0, 5.0)
		self.modified = true
	end

end

function SharedPatches:OnLoaded()
	self.m_FlightCeiling:OnLoaded()

end



return SharedPatches