class 'patches'


function patches:__init()
	self:RegisterVars()
	self:RegisterEvents()
end

function patches:RegisterVars()
	self.jumpHeight = 10
	self.moveVelocityMultiplier = 2
	self.sprintMultiplier = 5
	self.freeFallVelocity = 10000000
	self.fallingMultiplier = 0

	self.cpp = nil
end
function patches:RegisterEvents()
	self.m_ReadInstanceEvent = Events:Subscribe('Partition:ReadInstance', self, self.ReadInstance)
end

function patches:ReadInstance(p_Instance, p_PartitionGuid, p_Guid)


	if p_Instance == nil then
		return
	end
	if p_Instance.typeName == "JumpStateData" then
		local s_Instance = JumpStateData(p_Instance)
		s_Instance.jumpHeight = self.jumpHeight
		print("BOI!")
	end

	if p_Instance.typeName == "CharacterStatePoseInfo" then
		local s_Instance = CharacterStatePoseInfo(p_Instance)
		if s_Instance.sprintMultiplier ~= 0 then 
			s_Instance.sprintMultiplier = s_Instance.sprintMultiplier * self.sprintMultiplier
		end
		s_Instance.velocity = s_Instance.velocity * self.moveVelocityMultiplier
	end
	if p_Instance.typeName == "ParachuteStateData" then
		local s_Instance = ParachuteStateData(p_Instance)
		s_Instance.deployTime = 0
		
	end	
	if p_Instance.typeName == "InAirStateData" then 
		local s_Instance = InAirStateData(p_Instance)
		s_Instance.freeFallVelocity = self.freeFallVelocity
	end

	if p_Guid == Guid("5917C5BE-142C-498F-9EA0-CCC6211746D2", 'D') then
		local s_Instance = CollisionData(p_Instance)
		s_Instance:GetDamageAtVerticalVelocityAt(0).value = s_Instance:GetDamageAtVerticalVelocityAt(0).value * self.fallingMultiplier
		s_Instance:GetDamageAtVerticalVelocityAt(1).value = s_Instance:GetDamageAtVerticalVelocityAt(1).value * self.fallingMultiplier
		s_Instance:GetDamageAtVerticalVelocityAt(2).value = s_Instance:GetDamageAtVerticalVelocityAt(2).value * self.fallingMultiplier
		s_Instance:GetDamageAtVerticalVelocityAt(3).value = s_Instance:GetDamageAtVerticalVelocityAt(3).value * self.fallingMultiplier
		s_Instance:GetDamageAtVerticalVelocityAt(4).value = s_Instance:GetDamageAtVerticalVelocityAt(4).value * self.fallingMultiplier

		s_Instance:GetDamageAtHorizVelocityAt(0).value = s_Instance:GetDamageAtVerticalVelocityAt(0).value * self.fallingMultiplier
		s_Instance:GetDamageAtHorizVelocityAt(1).value = s_Instance:GetDamageAtVerticalVelocityAt(1).value * self.fallingMultiplier
		s_Instance:GetDamageAtHorizVelocityAt(2).value = s_Instance:GetDamageAtVerticalVelocityAt(2).value * self.fallingMultiplier
		s_Instance:GetDamageAtHorizVelocityAt(3).value = s_Instance:GetDamageAtVerticalVelocityAt(3).value * self.fallingMultiplier
		s_Instance:GetDamageAtHorizVelocityAt(4).value = s_Instance:GetDamageAtVerticalVelocityAt(4).value * self.fallingMultiplier
	end

	if p_Guid == Guid('A10FF2AA-F3CF-416B-A79B-E8C5416A9EBC', 'D') then
		local s_Instance = CharacterPhysicsData(p_Instance)
		s_Instance.jumpPenaltyTime = 0
		s_Instance.jumpPenaltyFactor = 0

	end

end

g_patches = patches()

return patches