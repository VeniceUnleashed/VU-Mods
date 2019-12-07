class 'bomberClient'


function bomberClient:__init()
	print("Initializing bomberClient")

	self.explosion = nil
	self.smoke = nil
	self.sound = nil

	self:RegisterEvents()


end

function bomberClient:RegisterEvents()
	self.m_ClientUpdateInputEvent = Events:Subscribe('Client:UpdateInput', self, self.OnUpdateInput)
		self.m_ReadInstanceEvent = Events:Subscribe('Partition:ReadInstance', self, self.ReadInstance)
end

function bomberClient:OnUpdateInput(p_Hook, p_Cache, p_DeltaTime)
	if InputManager:WentKeyDown(InputDeviceKeys.IDK_F1) then
       NetEvents:SendLocal('bomber:explode')
       print("Spawning explosion")
       local p_Player = PlayerManager:GetLocalPlayer()

		if p_Player == nil then
			return
		end
		if p_Player.soldier == nil then
			return
		end
		local s_Soldier = p_Player.soldier
		local params = EffectParams()
		EffectManager:PlayEffect(self.effect, s_Soldier.transform, params, false)
		--[[
		print(tostring(s_Soldier.transform))

		print("Here we go")
		local spawnedExplosion = EntityManager:CreateClientEntity(GrenadeEntityData(self.explosion), LinearTransform(
		 Vec3(1, 0, 0),
		 Vec3(0, 1, 0),
		 Vec3(0, 0, 1),
		 Vec3(0,0,0)))
		print("so far so good")

		if spawnedExplosion == nil then
			print("Could not spawn explosion")
			return
		end
		spawnedExplosion:Init(Realm.Realm_Client, true)

		print("spawned explosion")
		--]]
    end
end

function bomberClient:ReadInstance(p_Instance, p_PartitionGuid, p_Guid)
	if p_Instance == nil then
		return
	end

	if p_Guid == Guid("326152E6-0F84-430D-D2E3-19EBDA8266C4", 'D') then --nade
			--local s_Instance = PhysicsEntityData(p_Instance)
		print("Found explosion")
		self.explosion = p_Instance
	end
	if p_Guid == Guid('612F8BDD-F648-4F72-917F-5EB7E1486CEE', 'D') then
		print("Found smoke")
		self.effect = EffectBlueprint(p_Instance)
	end

end


g_bomberClient = bomberClient()
