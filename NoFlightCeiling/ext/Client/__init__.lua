class 'NoFlightCeilingClient'

local SharedPatches = require '__shared/patches'

function NoFlightCeilingClient:__init()
	self:InitComponents()
	self:RegisterEvents()
	self:InstallHooks()
	self.s_pose = {}
	self.s_pose_org = {}
	self.s_cam = nil
	slef.posei = 1
end

function NoFlightCeilingClient:RegisterEvents()
	self.m_LoadedEvent = Events:Subscribe('ExtensionLoaded', self, self.Loaded)
	self.m_ReadInstanceEvent = Events:Subscribe('Partition:ReadInstance', self, self.ReadInstance)
	self.m_UpdateEvent = Events:Subscribe("Engine:Update", self, self.OnUpdate)
end

function NoFlightCeilingClient:InstallHooks()

end

function NoFlightCeilingClient:OnUpdate()
	print("something")
	local s_LocalPlayer = PlayerManager:GetLocalPlayer()
    if s_LocalPlayer == nil then
    	print("no player")
 		return
 	end


 	if s_LocalPlayer.soldier ~= nil and s_pose ~= nil and s_cam ~= nil then 
 		local s_health = s_LocalPlayer.soldier.health / 100
 		for posecount = 1, self.posei do
 			local pose = CharacterPoseData(s_pose[posecount])
 			local pose_org = CharacterPoseData(s_pose_org[posecount])
	 		pose[posecount].eyePosition = Vec3(0, pose_org[posecount].eyePosition.y / health,0)
			pose[posecount].height = pose_org[posecount].height / health

			pose[posecount].collisionBoxMinExpand = Vec3(pose_org[posecount].collisionBoxMinExpand.x / health, pose_org[posecount].collisionBoxMinExpand.y / health, pose_org[posecount].collisionBoxMinExpand.z / health)

			pose[posecount].collisionBoxMaxExpand = Vec3(pose_org[posecount].collisionBoxMaxExpand.x / health, pose_org[posecount].collisionBoxMaxExpand.y / health, pose_org[posecount].collisionBoxMaxExpand.z / health)

			print("Adjusted cam height")
		end
		print("should do something...")

 	else 
 		print("no soldier, pose or cam")
 	end

 	print("ping")

end

function NoFlightCeilingClient:InitComponents()
	self.m_SharedPatches = SharedPatches()
end

function NoFlightCeilingClient:Loaded()
	self.m_SharedPatches:OnLoaded()
end
function NoFlightCeilingClient:ReadInstance(p_Instance, p_Guid)
	if p_Instance.typeName == "SoldierCameraComponentData" then
		self.s_cam = SoldierCameraComponentData(p_Instance)
		self.s_cam.authoritativeEyePosition = false

	end

	if p_Instance.typeName == "CharacterPoseData" then
		self.s_pose[self.posei] = p_Instance
		self.s_pose_org[self.posei] = p_Instance
		self.posei = self.posei + 1
	end
end





g_NoFlightCeilingClient = NoFlightCeilingClient()