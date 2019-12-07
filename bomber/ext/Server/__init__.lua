class 'bomberServer'


function bomberServer:__init()
	print("Initializing bomberServer")
	self:RegisterVars()
	self:RegisterEvents()
end


function bomberServer:RegisterVars()
	self.explosion = nil
	self.smoke = nil
	self.sound = nil
end


function bomberServer:RegisterEvents()
	self.m_ReadInstanceEvent = Events:Subscribe('Partition:ReadInstance', self, self.ReadInstance)
	self.m_ExplodeEvent = NetEvents:Subscribe('bomber:explode', self, self.OnExplode)
end


function bomberServer:ReadInstance(p_Instance, p_PartitionGuid, p_Guid)
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

function bomberServer:OnExplode(p_Player )
	print("Spawning explosion")
	if p_Player == nil then
		return
	end
	if p_Player.soldier == nil then
		return
	end

	local s_Soldier = p_Player.soldier
	print("Here we go")
	if self.explosion == nil then
		print("explosion doesnt exist")
		return
	end
	local spawnedExplosion = EntityManager:CreateServerEntity(GrenadeEntityData(self.explosion), s_Soldier.transform)
	print("so far so good")

	if spawnedExplosion == nil then
		print("Could not spawn explosion")
		return
	end
	spawnedExplosion:Init(Realm.Realm_ClientAndServer, true)

	print("spawned explosion")
	--local params = EffectParams()
	--spawnedPickup:Init(Realm.Realm_ClientAndServer, true)
	--EffectManager:PlayEffect(effect, soldier.transform, params, false)
end

g_bomberServer = bomberServer()

return bomberServer
