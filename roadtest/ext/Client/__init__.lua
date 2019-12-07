class 'roadtestClient'
local VUExtensions = require "VUExtensions"

function roadtestClient:__init()
	print("Initializing roadtestClient")
	self:RegisterVars()
	self:RegisterEvents()
end


function roadtestClient:RegisterVars()
	self.m_Roads = {}
	self.m_Soldier = nil
	self.m_SoldierEntity = nil
	self.sizeMultiplier = 1
end


function roadtestClient:RegisterEvents()
	self.m_ClientUpdateInputEvent = Events:Subscribe('Client:UpdateInput', self, self.OnUpdateInput)
	self.m_PartitionLoadedEvent = Events:Subscribe('Partition:Loaded', self, self.OnPartitionLoaded)
	Hooks:Install('ClientEntityFactory:Create',999, self, self.OnEntityCreate)
end


function roadtestClient:OnPartitionLoaded(p_Partition)
	if p_Partition == nil then
		return
	end
	
	local s_Instances = p_Partition.instances


	for _, l_Instance in ipairs(s_Instances) do
		if l_Instance == nil then
			print('Instance is null?')
			break
		end


--[[
		if(l_Instance.instanceGuid == Guid("39B2C3CB-AF32-11DD-9860-EC99D6053928")) then

			local s_Instance = VUExtensions:PrepareInstanceForEdit(l_Instance, p_Partition, true)

			local s_OriginalLocal = s_Instance.localPose:get(46)
			s_OriginalLocal.trans.y = s_OriginalLocal.trans.y - 0.2 

			local s_OriginalModel = s_Instance.modelPose:get(46)
			s_OriginalModel.trans.y = s_OriginalModel.trans.y - 0.2

			s_Instance.localPose:set(46,s_OriginalLocal)

			s_Instance.modelPose:set(46, s_OriginalModel)
			
		
		end
		]]
	end
end

function roadtestClient:OnUpdateInput(p_Hook, p_Cache, p_DeltaTime)
	local p_Player = PlayerManager:GetLocalPlayer()

	if (p_Player == nil) then
		return
	end
	if( p_Player.soldier ~= nil) then
		print("head: " .. tostring(p_Player.soldier:GetHeadTransform()))
		print("cam : " .. tostring(ClientUtils:GetCameraTransform()))
		return
	end
	if(p_Player.corpse == nil) then
		if(self.camera ~= nil) then
			self.camera:FireEvent("ReleaseControl")
			self.camera:Destroy()
			self.camera = nil
		end
		return
	else
		if(self.camera ~= nil) then
			if(p_Player.corpse == nil) then
				return
			end
			local s_Corpse = p_Player.corpse
			local s_headPos = s_Corpse:GetHeadTransform()
			if(s_headPos == nil) then
				return
			else 
				s_headPos = s_headPos.trans
			end

						-- check if we're below the floor
			local from = Vec3(s_headPos.x, s_headPos.y, s_headPos.z)
			local to = Vec3(s_headPos.x, s_headPos.y - 30, s_headPos.z)
			local s_Raycast = RaycastManager:Raycast(to, from, 2)
			if(s_Raycast == nil) then
				return
			end


			self.camera:FireEvent("TakeControl")
			local transform = s_Corpse:GetHeadTransform()
			self.data.transform = transform

		else
			self.data = CameraEntityData()
			self.data.fov = 90
			print("creating camera")
			local s_Entity = EntityManager:CreateClientEntity(self.data, LinearTransform())

			if s_Entity == nil then
				print("Could not spawn camera")
				return
			end
			s_Entity:Init(Realm.Realm_Client, true)
			
			local s_Spatial = SpatialEntity(s_Entity)
			self.data.fov = 90
			self.camera = s_Spatial
		end

	end


	if InputManager:WentKeyDown(InputDeviceKeys.IDK_F3) then

		local p_Player = PlayerManager:GetLocalPlayer()

		if p_Player == nil then
			print("no player")
			return
		end
		--[[
		if(self.m_Soldier ~= nil) then

			if p_Player.soldier == nil then
				return
			end
			local s_Soldier = p_Player.soldier


			local s_BCD = self.m_Soldier.components:get(14)
			s_BCD = BoneCollisionComponentData(s_BCD)
			local s_Skeleton = s_BCD.skeletonCollisionData
			s_Skeleton = SkeletonCollisionData(s_Skeleton)
			local s_SkeleAsset =  s_Skeleton.skeletonAsset
			
			s_SkeleAsset = SkeletonAsset (s_SkeleAsset)
		end
]]
		if p_Player.corpse ~= nil then
			print("kek")

			local s_Corpse = p_Player.corpse
		else
			print("no corpse")
		end
	end
end

function roadtestClient:OnEntityCreate(p_Hook, p_Data, p_Transform)
	if p_Data == nil then
		print("Didnt get no data")
		return
	end
	if(p_Transform.trans.x ~= 0) then
		--print(tostring(p_Data.typeInfo.name))
		--print(tostring(p_Transform))
	end
	
	if(p_Data.typeInfo.name == "SoldierBodyComponentData") then


		--[[
		for i=1,#s_SkeleAsset.localPose,1 do 
			print(tostring(s_SkeleAsset.localPose:get(i)))
	
			s_SkeleAsset.localPose:set(i, LinearTransform(
							Vec3(self.sizeMultiplier, 0, 0),
							Vec3(0, self.sizeMultiplier, 0),
							Vec3(0, 0, self.sizeMultiplier),
							Vec3(0,0,0)))
			print(tostring(s_SkeleAsset.localPose:get(i)))

			s_SkeleAsset.modelPose:set(i, LinearTransform(
							Vec3(self.sizeMultiplier, 0, 0),
							Vec3(0, self.sizeMultiplier, 0),
							Vec3(0, 0, self.sizeMultiplier),
							Vec3(0,0,0)))
		 end]]
		--p_Hook:Pass(s_SBC, p_Transform)
	end
end

g_roadtestClient = roadtestClient()

