class 'norecoilresetShared'


function norecoilresetShared:__init()
	print("Initializing norecoilresetShared")
	self:RegisterVars()
	self:RegisterEvents()
end


function norecoilresetShared:RegisterVars()
	--self.m_this = that
end


function norecoilresetShared:RegisterEvents()
	self.m_ReadInstanceEvent = Events:Subscribe('Partition:ReadInstance', self, self.ReadInstance)
end


function norecoilresetShared:ReadInstance(p_Instance,p_PartitionGuid, p_Guid)
	if p_Instance == nil then
		return
	end
	
	if p_Instance.typeName == "CameraRecoilData" then
		local s_Instance = CameraRecoilData(p_Instance)
		s_Instance.springConstant = 0
	end

	if p_Instance.typeName == "FirstPersonCameraData" then
		print(tostring(p_Guid))

		local s_Instance = FirstPersonCameraData(p_Instance)
		if(s_Instance.weaponSpringEffect == nil) then
			return
		end
		local s_Weapon = WeaponLagSpringEffectData(s_Instance.weaponSpringEffect)
		local s_Camera = WeaponLagSpringEffectData(s_Instance.cameraSpringEffect )

		s_Instance.releaseModifier = 0 
		s_Instance.releaseModifierPitch = 0
		s_Instance.releaseModifierYaw = 0
		s_Instance.releaseModifierRoll = 0
		s_Instance.offsetReleaseModifier = 0


		s_Weapon.offsetSprings.springX.constant = 0
		s_Weapon.offsetSprings.springY.constant = 0
		s_Weapon.offsetSprings.springZ.constant = 0

		

	end
	 
end


g_norecoilresetShared = norecoilresetShared()

