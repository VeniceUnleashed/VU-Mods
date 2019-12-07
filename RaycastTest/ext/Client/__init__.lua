class 'RaycastTestClient'


function RaycastTestClient:__init()
	
	self:RegisterVars()
	self:RegisterEvents()
end


function RaycastTestClient:RegisterVars()

	
	
	self.m_MeleeTime = 0.0
	self.m_ReloadTime = 0.0
	self.currentEntity = nil
end


function RaycastTestClient:RegisterEvents()
	self.m_UpdateEvent = Events:Subscribe("Engine:Update", self, self.OnUpdate)
	self.m_UpdateEvent = Events:Subscribe("UI:DrawHud", self, self.OnDrawHud)

	self.m_ClientUpdateInputEvent = Events:Subscribe('Client:UpdateInput', self, self.OnUpdateInput)
	--self.m_EntityCreationEvent = Hooks:Install('ClientEntityFactory:Create',1, self, self.OnEntityCreate)
	Hooks:Install('ClientEntityFactory:CreateFromBlueprint', 999, self, self.OnEntityCreateFromBlueprint)

end

function RaycastTestClient:OnEntityCreateFromBlueprint(p_Hook, p_Blueprint, p_Transform, p_Variation, p_Parent )
	local s_Blueprint = Blueprint(p_Blueprint)
	print("Creating blueprint: " .. s_Blueprint.name)

	local s_Entities = p_Hook:Call()
	for k,v in ipairs(s_Entities) do
		v:Init(Realm.Realm_Client, true)
	end
end

function RaycastTestClient:OnDrawHud(a,b,c)

	local s_Player = PlayerManager:GetLocalPlayer()
	if s_Player == nil then
		return
	end

	local s_Soldier = s_Player.soldier
	if s_Soldier == nil then
		return
	end

	if(self.m_Entities ~= nil and #self.m_Entities > 0) then
		for k, v in pairs(self.m_Entities) do
			if(v:Is("SpatialEntity")) then
				local s_Entity = SpatialEntity(v)
				DebugRenderer:DrawLine(s_Entity.transform.trans, s_Soldier.transform.trans, Vec4(1,0,0,1), Vec4(0,1,0,1))
			end
		end
	else
		return
	end


end
function RaycastTestClient:OnUpdateInput(p_Delta)

	local s_Player = PlayerManager:GetLocalPlayer()
	if s_Player == nil then
		return
	end

	local s_Soldier = s_Player.soldier
	if s_Soldier == nil then
		return
	end


	if InputManager:WentKeyDown(InputDeviceKeys.IDK_F) then
		local s_Transform = ClientUtils:GetCameraTransform()

		s_Transform = Vec3(s_Transform.forward.x * -1, s_Transform.forward.y * -1, s_Transform.forward.z * -1)

		local newTransform = s_Soldier.transform
		newTransform.forward = s_Transform
		newTransform.up = ClientUtils:GetCameraTransform().up
		newTransform.left = ClientUtils:GetCameraTransform().left

		local newX = (s_Transform.x * 100) + s_Soldier.transform.trans.x
		local newY = (s_Transform.y * 100) + s_Soldier.transform.trans.y
		local newZ = (s_Transform.z * 100) + s_Soldier.transform.trans.z
		newTransform.trans = Vec3(newX,newY,newZ)


		self.m_Entities = {}
		-- Get all entities in view
		local s_Entities = RaycastManager:SpatialRaycast(ClientUtils:GetCameraTransform().trans, newTransform.trans, SpatialQueryFlags.AllGrids)
		
		-- Do a raycast to find our object's transform
		local hit = RaycastManager:Raycast(ClientUtils:GetCameraTransform().trans, newTransform.trans, 2)
		if(hit.rigidBody == nil and not hit.rigidBody:Is("SpatialEntity")) then
			return
		end
		print("________________")
		for k, v in pairs(s_Entities) do
			if(v:Is("ClientStaticModelEntity")) then
				local s_Data = StaticModelEntityData(v.data)
				print(Asset(s_Data.mesh).name)
				print(v.typeInfo.name)
			end
		end
		print("________________")

		local s_RigidBodyHitTransform = SpatialEntity(hit.rigidBody).transform

		if( s_Entities ~= nil and #s_Entities > 0) then
			for k, v in pairs(s_Entities) do
				if(v:Is("SpatialEntity") and 
					not v:Is("StaticPhysicsEntity") and 
					not v:Is("GroupPhysicsEntity") and 
					not v:Is("ClientWaterEntity") and
					not v:Is("WaterPhysicsEntity") and
					not v:Is("ClientSoldierEntity") and
					not v:Is("DebrisClusterContainerEntity") and
					not v:Is("CharacterPhysicsEntity")
					) then
					local s_Entity = SpatialEntity(v)
					if(s_RigidBodyHitTransform.trans == s_Entity.transform.trans ) then
						table.insert(self.m_Entities, SpatialEntity(v))

						print("Match: " .. k .. ": " .. v.typeInfo.name)
						if(v.data ~= nil) then
							local s_Data = StaticModelEntityData(v.data)
							print(Asset(s_Data.mesh).name)
						end
					end
				end
			end

			print("_________")
		else
			return
		end


		
		
	end

	if InputManager:WentKeyDown(InputDeviceKeys.IDK_V) then
		
		
		local s_Transform = ClientUtils:GetCameraTransform()

		s_Transform = Vec3(s_Transform.forward.x * -1, s_Transform.forward.y * -1, s_Transform.forward.z * -1)

		local newTransform = s_Soldier.transform
		newTransform.forward = s_Transform
		newTransform.up = ClientUtils:GetCameraTransform().up
		newTransform.left = ClientUtils:GetCameraTransform().left

		newTransform.left.x = newTransform.left.x * 2
		newTransform.up.y = newTransform.up.y * 2
		newTransform.forward.z = newTransform.forward.z * 2


		local newX = (s_Transform.x * 10) + s_Soldier.transform.trans.x
		local newY = (s_Transform.y * 10) + s_Soldier.transform.trans.y
		local newZ = (s_Transform.z * 10) + s_Soldier.transform.trans.z
		newTransform.trans = Vec3(newX,newY,newZ)
		local s_EntityTrans = LinearTransform()
		local hit = RaycastManager:Raycast(ClientUtils:GetCameraTransform().trans, newTransform.trans, 2)
		if(hit == nil) then
			return
		end
		s_EntityTrans.trans = hit.position

		if(self.m_Entities ~= nil and #self.m_Entities > 0) then
			local v = self.m_Entities[1]
			if(v:Is("SpatialEntity")) then
				local s_Entity = SpatialEntity(v)
				s_Entity.transform = s_EntityTrans
                s_Entity:FireEvent("Disable")
                s_Entity:FireEvent("Enable")

			end
		end

	end
end

function RaycastTestClient:OnEntityCreate(p_Hook, p_Data, p_Transform)
	local x = p_Hook:Call(p_Data, p_Transform)
	if(x:Is("PhysicsEntity")) then
			local s_Entity = PhysicsEntityBase(x)
			print("Entity Type:" .. s_Entity.typeInfo.name)
			print("UserData   :" .. s_Entity:GetUserDataType())
	end
end

function RaycastTestClient:OnUpdate(p_Delta, p_SimulationDelta)
	--
end
function RaycastTestClient:ReadInstance(p_Instance, p_PartitionGuid, p_Guid)

end


g_RaycastTestClient = RaycastTestClient()

return RaycastTestClient

