local sizeMultiplier = require("__shared/config")

Events:Subscribe('Partition:Loaded', function(partition)
	if partition == nil then
		return
	end

	local instances = partition.instances
	for _, instance in pairs(instances) do
		if instance ~= nil then
			if instance:Is("SoldierBodyComponentData") then
				local s_Instance = SoldierBodyComponentData(instance)
				s_Instance:MakeWritable()
				s_Instance.transform = LinearTransform(
				 Vec3(sizeMultiplier, 0, 0),
				 Vec3(0, sizeMultiplier, 0),
				 Vec3(0, 0, sizeMultiplier),
				 Vec3(0,0,0))
			end
		--[[
			if instance:Is("SoldierWeaponsComponentData") then
				local s_Instance = SoldierWeaponsComponentData(instance)
				s_Instance.transform = LinearTransform(
				 Vec3(sizeMultiplier, 0, 0),
				 Vec3(0, sizeMultiplier, 0),
				 Vec3(0, 0, sizeMultiplier),
				 Vec3(0,0,0))
			end
			--]]
			if instance:Is("CharacterCustomizationComponentData") then
				local s_Instance = CharacterCustomizationComponentData(instance)
				s_Instance:MakeWritable()
				s_Instance.transform = LinearTransform(
				 Vec3(sizeMultiplier, 0, 0),
				 Vec3(0, sizeMultiplier, 0),
				 Vec3(0, 0, sizeMultiplier),
				 Vec3(0,0,0))
			end
		--[[
			if instance:Is("PlayerEntryComponentData") then
				local s_Instance = PlayerEntryComponentData(instance)
				s_Instance.transform = LinearTransform(
				 Vec3(sizeMultiplier, 0, 0),
				 Vec3(0, sizeMultiplier, 0),
				 Vec3(0, 0, sizeMultiplier),
				 Vec3(0,0,0))
			end
		--]]
			if instance:Is("RagdollComponentData") then
				local s_Instance = RagdollComponentData(instance)
				s_Instance:MakeWritable()
				s_Instance.transform = LinearTransform(
				 Vec3(sizeMultiplier, 0, 0),
				 Vec3(0, sizeMultiplier, 0),
				 Vec3(0, 0, sizeMultiplier),
				 Vec3(0,0,0))
			end
			--[[
			if instance:Is("CameraComponentData") then -- Bugged for Vehicles, need to assign the actual camera
				local s_Instance = CameraComponentData(instance)
				s_Instance.transform = LinearTransform(
				 Vec3(sizeMultiplier, 0, 0),
				 Vec3(0, sizeMultiplier, 0),
				 Vec3(0, 0, sizeMultiplier),
				 Vec3(0,0,0))
			end
			--]]

			if instance:Is("SoldierCameraComponentData") then
				local s_Cam = SoldierCameraComponentData(instance)
				s_Cam:MakeWritable()
				s_Cam.authoritativeEyePosition = false
			end

			if instance:Is("CharacterPoseData") then
				local s_Instance = CharacterPoseData(instance)
				s_Instance:MakeWritable()

				s_Instance.stepHeight = s_Instance.stepHeight * sizeMultiplier
				s_Instance.eyePosition = Vec3(0,s_Instance.eyePosition.y * sizeMultiplier,0)
				s_Instance.height = s_Instance.height * sizeMultiplier
				s_Instance.collisionBoxMinExpand = Vec3(s_Instance.collisionBoxMinExpand.x * sizeMultiplier, s_Instance.collisionBoxMinExpand.y * sizeMultiplier, s_Instance.collisionBoxMinExpand.z * sizeMultiplier)
				s_Instance.collisionBoxMaxExpand = Vec3(s_Instance.collisionBoxMaxExpand.x * sizeMultiplier, s_Instance.collisionBoxMaxExpand.y * sizeMultiplier, s_Instance.collisionBoxMaxExpand.z * sizeMultiplier)
			end

			--Physics

			if instance:Is("CharacterPhysicsData") then
				local s_Instance = CharacterPhysicsData(instance)
				s_Instance:MakeWritable()
				s_Instance.physicalRadius  			= 	s_Instance.physicalRadius * sizeMultiplier
				s_Instance.pushableObjectWeight     = 	s_Instance.pushableObjectWeight * sizeMultiplier
				s_Instance.mass  					= 	s_Instance.mass * sizeMultiplier		
			end	

			if instance:Is("InAirStateData") then -- no freefall
				local s_Instance = InAirStateData(instance)
				--s_Instance.freeFallVelocity = 	s_Instance.freeFallVelocity * sizeMultiplier
			end

			if instance:Is("CharacterStatePoseInfo") then
				local s_Instance = CharacterStatePoseInfo(instance)
				s_Instance:MakeWritable()

				s_Instance.velocity = s_Instance.velocity * 10 * sizeMultiplier
				s_Instance.accelerationGain = 	s_Instance.accelerationGain * sizeMultiplier
				s_Instance.decelerationGain = 	s_Instance.decelerationGain  * sizeMultiplier
				s_Instance.sprintGain  		= 	s_Instance.sprintGain  * sizeMultiplier
				s_Instance.sprintMultiplier =	s_Instance.sprintMultiplier  * sizeMultiplier
			end

				

			 

			if p_Guid == Guid("5917C5BE-142C-498F-9EA0-CCC6211746D2", 'D') then -- No fall damage
				local s_Instance = CollisionData(instance)
				s_Instance:MakeWritable()

				s_Instance.damageAtVerticalVelocity:get(0).value = s_Instance.damageAtVerticalVelocity:get(0).value * sizeMultiplier
				s_Instance.damageAtVerticalVelocity:get(1).value = s_Instance.damageAtVerticalVelocity:get(1).value * sizeMultiplier
				s_Instance.damageAtVerticalVelocity:get(2).value = s_Instance.damageAtVerticalVelocity:get(2).value * sizeMultiplier
				s_Instance.damageAtVerticalVelocity:get(3).value = s_Instance.damageAtVerticalVelocity:get(3).value * sizeMultiplier
				s_Instance.damageAtVerticalVelocity:get(4).value = s_Instance.damageAtVerticalVelocity:get(4).value * sizeMultiplier

				s_Instance.damageAtHorizVelocity:get(0).value = s_Instance.damageAtVerticalVelocity:get(0).value * sizeMultiplier
				s_Instance.damageAtHorizVelocity:get(1).value = s_Instance.damageAtVerticalVelocity:get(1).value * sizeMultiplier
				s_Instance.damageAtHorizVelocity:get(2).value = s_Instance.damageAtVerticalVelocity:get(2).value * sizeMultiplier
				s_Instance.damageAtHorizVelocity:get(3).value = s_Instance.damageAtVerticalVelocity:get(3).value * sizeMultiplier
				s_Instance.damageAtHorizVelocity:get(4).value = s_Instance.damageAtVerticalVelocity:get(4).value * sizeMultiplier
			end
		end
	end
end)