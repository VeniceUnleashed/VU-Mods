class 'patches'


function patches:__init()
	self:RegisterEvents()
	self.sizeMultiplier = 10
end

function patches:RegisterEvents()
	self.m_ReadInstanceEvent = Events:Subscribe('Partition:ReadInstance', self, self.ReadInstance)
end

function patches:ReadInstance(p_Instance, p_Guid)

	if p_Instance == nil then
		return
	end

	if p_Instance.typeName == "SoldierBodyComponentData" then
		local s_Instance = SoldierBodyComponentData(p_Instance)
		s_Instance.transform = LinearTransform(
		 Vec3(self.sizeMultiplier, 0, 0),
		 Vec3(0, self.sizeMultiplier, 0),
		 Vec3(0, 0, self.sizeMultiplier),
		 Vec3(0,0,0))
	end
--[[
	if p_Instance.typeName == "SoldierWeaponsComponentData" then
		local s_Instance = SoldierWeaponsComponentData(p_Instance)
		s_Instance.transform = LinearTransform(
		 Vec3(self.sizeMultiplier, 0, 0),
		 Vec3(0, self.sizeMultiplier, 0),
		 Vec3(0, 0, self.sizeMultiplier),
		 Vec3(0,0,0))
	end
	--]]
	if p_Instance.typeName == "CharacterCustomizationComponentData" then
		local s_Instance = CharacterCustomizationComponentData(p_Instance)
		s_Instance.transform = LinearTransform(
		 Vec3(self.sizeMultiplier, 0, 0),
		 Vec3(0, self.sizeMultiplier, 0),
		 Vec3(0, 0, self.sizeMultiplier),
		 Vec3(0,0,0))
	end
--[[
	if p_Instance.typeName == "PlayerEntryComponentData" then
		local s_Instance = PlayerEntryComponentData(p_Instance)
		s_Instance.transform = LinearTransform(
		 Vec3(self.sizeMultiplier, 0, 0),
		 Vec3(0, self.sizeMultiplier, 0),
		 Vec3(0, 0, self.sizeMultiplier),
		 Vec3(0,0,0))
	end
--]]
	if p_Instance.typeName == "RagdollComponentData" then
		local s_Instance = RagdollComponentData(p_Instance)
		s_Instance.transform = LinearTransform(
		 Vec3(self.sizeMultiplier, 0, 0),
		 Vec3(0, self.sizeMultiplier, 0),
		 Vec3(0, 0, self.sizeMultiplier),
		 Vec3(0,0,0))
	end
	--[[
	if p_Instance.typeName == "CameraComponentData" then -- Bugged for Vehicles, need to assign the actual camera
		local s_Instance = CameraComponentData(p_Instance)
		s_Instance.transform = LinearTransform(
		 Vec3(self.sizeMultiplier, 0, 0),
		 Vec3(0, self.sizeMultiplier, 0),
		 Vec3(0, 0, self.sizeMultiplier),
		 Vec3(0,0,0))
	end
	--]]

	if p_Instance.typeName == "SoldierCameraComponentData" then
		self.s_cam = SoldierCameraComponentData(p_Instance)
		self.s_cam.authoritativeEyePosition = false
	end

	if p_Instance.typeName == "CharacterPoseData" then
		local s_Instance = CharacterPoseData(p_Instance)
		s_Instance.stepHeight = s_Instance.stepHeight * self.sizeMultiplier
		s_Instance.eyePosition = Vec3(0,s_Instance.eyePosition.y * self.sizeMultiplier,0)
		s_Instance.height = s_Instance.height * self.sizeMultiplier
		s_Instance.collisionBoxMinExpand = Vec3(s_Instance.collisionBoxMinExpand.x * self.sizeMultiplier, s_Instance.collisionBoxMinExpand.y * self.sizeMultiplier, s_Instance.collisionBoxMinExpand.z * self.sizeMultiplier)
		s_Instance.collisionBoxMaxExpand = Vec3(s_Instance.collisionBoxMaxExpand.x * self.sizeMultiplier, s_Instance.collisionBoxMaxExpand.y * self.sizeMultiplier, s_Instance.collisionBoxMaxExpand.z * self.sizeMultiplier)
	end

	--Physics

	if p_Instance.typeName == "CharacterPhysicsData" then
		local s_Instance = CharacterPhysicsData(p_Instance)
		s_Instance.physicalRadius  			= 	s_Instance.physicalRadius * self.sizeMultiplier
		s_Instance.pushableObjectWeight     = 	s_Instance.pushableObjectWeight * self.sizeMultiplier
		s_Instance.mass  					= 	s_Instance.mass * self.sizeMultiplier		
	end	

	if p_Instance.typeName == "InAirStateData" then -- no freefall
		local s_Instance = InAirStateData(p_Instance)
		--s_Instance.freeFallVelocity = 	s_Instance.freeFallVelocity * self.sizeMultiplier
	end

	if p_Instance.typeName == "CharacterStatePoseInfo" then
		local s_Instance = CharacterStatePoseInfo(p_Instance)
		--s_Instance.velocity = s_Instance.velocity * 10 * self.sizeMultiplier
		--s_Instance.accelerationGain = 	s_Instance.accelerationGain * self.sizeMultiplier
		--s_Instance.decelerationGain = 	s_Instance.decelerationGain  * self.sizeMultiplier
		--s_Instance.sprintGain  		= 	s_Instance.sprintGain  * self.sizeMultiplier
		--s_Instance.sprintMultiplier =	s_Instance.sprintMultiplier  * self.sizeMultiplier
	end

		

	 

	if p_Guid == Guid("5917C5BE-142C-498F-9EA0-CCC6211746D2", 'D') then -- No fall damage
		local s_Instance = CollisionData(p_Instance)
		s_Instance:GetDamageAtVerticalVelocityAt(0).value = s_Instance:GetDamageAtVerticalVelocityAt(0).value * self.sizeMultiplier
		s_Instance:GetDamageAtVerticalVelocityAt(1).value = s_Instance:GetDamageAtVerticalVelocityAt(1).value * self.sizeMultiplier
		s_Instance:GetDamageAtVerticalVelocityAt(2).value = s_Instance:GetDamageAtVerticalVelocityAt(2).value * self.sizeMultiplier
		s_Instance:GetDamageAtVerticalVelocityAt(3).value = s_Instance:GetDamageAtVerticalVelocityAt(3).value * self.sizeMultiplier
		s_Instance:GetDamageAtVerticalVelocityAt(4).value = s_Instance:GetDamageAtVerticalVelocityAt(4).value * self.sizeMultiplier

		s_Instance:GetDamageAtHorizVelocityAt(0).value = s_Instance:GetDamageAtVerticalVelocityAt(0).value * self.sizeMultiplier
		s_Instance:GetDamageAtHorizVelocityAt(1).value = s_Instance:GetDamageAtVerticalVelocityAt(1).value * self.sizeMultiplier
		s_Instance:GetDamageAtHorizVelocityAt(2).value = s_Instance:GetDamageAtVerticalVelocityAt(2).value * self.sizeMultiplier
		s_Instance:GetDamageAtHorizVelocityAt(3).value = s_Instance:GetDamageAtVerticalVelocityAt(3).value * self.sizeMultiplier
		s_Instance:GetDamageAtHorizVelocityAt(4).value = s_Instance:GetDamageAtVerticalVelocityAt(4).value * self.sizeMultiplier
	end

	if p_Guid == Guid('34256E97-1049-FC24-90D8-4D551517E3AC', 'D') then

		local s_Instance = SkeletonAsset(p_Instance)
		local s_Count = s_Instance:GetLocalPoseCount()
        if s_Count == 0 then
            return
        end
        
        for i=s_Count,0,-1 do 
            local s_Pose = s_Instance:GetLocalPoseAt(i)
			s_Pose = LinearTransform(
							Vec3(self.sizeMultiplier, 0, 0),
							Vec3(0, self.sizeMultiplier, 0),
							Vec3(0, 0, self.sizeMultiplier),
							Vec3(0,0,0))
			local s_mPose = s_Instance:GetModelPoseAt(i)
			s_mPose = LinearTransform(
							Vec3(self.sizeMultiplier, 0, 0),
							Vec3(0, self.sizeMultiplier, 0),
							Vec3(0, 0, self.sizeMultiplier),
							Vec3(0,0,0))
         end
		print("Modified 1p model")
	end
end

g_patches = patches()

return patches