class 'ThirdPersonClient'


function ThirdPersonClient:__init()
	print("Initializing ThirdPersonClient")
	self:RegisterVars()
	self:RegisterEvents()
end


function ThirdPersonClient:RegisterVars()
	--self.m_this = that
end


function ThirdPersonClient:RegisterEvents()
	self.m_ReadInstanceEvent = Events:Subscribe('Partition:ReadInstance', self, self.ReadInstance)
end


function ThirdPersonClient:ReadInstance(p_Instance,p_PartitionGuid, p_Guid)
	if p_Instance == nil then
		return
	end
	--[[
	if p_Guid == Guid("EFA6711B-E934-4F22-BE14-536373EC5BEA", "D") then
		local s_Instance = SoldierCameraComponentData(p_Instance)
		local s_ChaseCam = s_Instance:GetCamerasAt(1)

		s_Instance:ClearCameras()
		s_Instance:AddCameras(s_ChaseCam)

		s_ChaseCam = ChaseCameraData(s_ChaseCam)
		s_ChaseCam.targetOffset = Vec3(0,0,0)
		s_ChaseCam.wantedAngleDeg = 0
		s_ChaseCam.maxViewRotationAngleDeg = 0
		s_ChaseCam.updateRate = 120

		print("Successfully removed camera")
	end

	--]]
	
	if p_Instance.typeName == "PlayerCameraEntityData" then
		local s_Instance = PlayerCameraEntityData(p_Instance)
		s_Instance.soldierTargetMode = TargetMode.TargetMode_ThirdPerson
		s_Instance.releaseControlIfTargetLost = false 
		s_Instance.shouldTargetControllable = true 

		print("Successfully removed camera")
	end
	if p_Instance.typeName == "FadeEntityData" then
		local s_Instance = FadeEntityData(p_Instance)
		s_Instance.startFaded = false
		print("Successfully removed camera")
	end

end


g_ThirdPersonClient = ThirdPersonClient()

