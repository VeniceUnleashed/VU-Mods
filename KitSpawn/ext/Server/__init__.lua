class 'KitSpawnServer'

require "StringExtensions"
local m_DataContainerDebug = require "DataContainerDebug"

local m_AK74M_UnlockLookup = { uniqueName = 'Weapons/AK74M/U_AK74M', displayName = 'AK-74M', imageName = 'ak74m', partitionGuid = "1556281a-0f0b-4eb3-b280-661018f8d52f", instanceGuid = "3ba55147-6619-4697-8e2b-ac6b1d183c0e" }

function KitSpawnServer:__init()
	print("Initializing KitSpawnServer")
	self:RegisterVars()
	self:RegisterEvents()
end

function KitSpawnServer:RegisterVars()
	self.m_RandomSpatialPrefabBlueprint = nil -- TODO: this needs to be reset
end

function KitSpawnServer:RegisterEvents()
	Events:Subscribe('Player:Chat', self, self.OnChat)
	Events:Subscribe('Partition:Loaded', self, self.OnPartitionLoaded)
end

function KitSpawnServer:OnPartitionLoaded(partition)
	for _, instance in pairs(partition.instances) do
		if instance.typeInfo.name == "SpatialPrefabBlueprint" and self.m_RandomSpatialPrefabBlueprint == nil then
			self.m_RandomSpatialPrefabBlueprint = SpatialPrefabBlueprint(instance)
			print("Found random SpatialPrefabBlueprint")
        end
        
        -- handle the non-lazyloaded instances here
    end
end

function KitSpawnServer:OnChat(player, recipientMask, message)
	if message == '' then
		return
	end

	print(message)
	
	local parts = message:split(' ')

	if parts[1] == 'kit' then
		self:SpawnKit(player)
	end
end

function KitSpawnServer:SpawnKit(p_Player)
	-- print("RandomSpatialPrefabBlueprint: " .. tostring(self.m_RandomSpatialPrefabBlueprint.name))
	-- m_DataContainerDebug:PrintFields(self.m_RandomSpatialPrefabBlueprint)
	-- for _, object in pairs(self.m_RandomSpatialPrefabBlueprint.objects) do
	-- 	print("Found object in SpatialPrefabBlueprint - Type:" .. object.typeInfo.name)
	-- end

	-- -- local spatialPrefabBlueprint = self.m_RandomSpatialPrefabBlueprint:Clone()
	-- local spatialPrefabBlueprint = SpatialPrefabBlueprint()
	-- print("Successfully cloned SpatialPrefabBlueprint")
	-- spatialPrefabBlueprint.objects:clear()
	-- spatialPrefabBlueprint.name = "CustomSpatialPrefabBlueprint"
	-- spatialPrefabBlueprint.needNetworkId = true

	local weaponUnlockPickupEntityData = WeaponUnlockPickupEntityData()

	local unlockInstance = ResourceManager:FindInstanceByGUID(Guid(m_AK74M_UnlockLookup.partitionGuid), Guid(m_AK74M_UnlockLookup.instanceGuid))

	if unlockInstance == nil then
		error("ak74m unlock instance not found")
	end

	local ak74mUnlock = _G[unlockInstance.typeInfo.name](unlockInstance)

	local weaponUnlockPickupData = WeaponUnlockPickupData()
	weaponUnlockPickupData.unlockWeaponAndSlot.weapon = ak74mUnlock
	weaponUnlockPickupData.unlockWeaponAndSlot.slot = 1
	-- weaponUnlockPickupData.unlockWeaponAndSlot.unlockAssets:add() -- add attachments etc

	weaponUnlockPickupEntityData.timeToLive = 300
	weaponUnlockPickupEntityData.unspawnOnPickup = true
	weaponUnlockPickupEntityData.positionIsStatic  = true
	weaponUnlockPickupEntityData.allowPickup = true
	weaponUnlockPickupEntityData.ignoreNullWeaponSlots = true
	weaponUnlockPickupEntityData.forceWeaponSlotSelection  = true
	weaponUnlockPickupEntityData.hasAutomaticAmmoPickup = true
	weaponUnlockPickupEntityData.interactionRadius = 2.5
	weaponUnlockPickupEntityData.replaceAllContent = true
	weaponUnlockPickupEntityData.weapons:add(weaponUnlockPickupData)

	-- spatialPrefabBlueprint.objects:add(weaponUnlockPickupEntityData)

	local s_Params = EntityCreationParams()
	s_Params.transform = p_Player.soldier.transform
	s_Params.variationNameHash = 0
	s_Params.networked = true

	-- m_DataContainerDebug:PrintFields(spatialPrefabBlueprint)
	-- m_DataContainerDebug:PrintFields(weaponUnlockPickupEntityData)
	-- m_DataContainerDebug:PrintFields(weaponUnlockPickupData)

	-- local s_ObjectEntities = EntityManager:CreateEntitiesFromBlueprint(spatialPrefabBlueprint, s_Params)
	-- if #s_ObjectEntities == 0 then
	-- 	print("Spawning failed")
	-- 	return false
	-- end

	-- for i, l_Entity in pairs(s_ObjectEntities) do
	-- 	l_Entity:Init(Realm.Realm_ClientAndServer, true)
	-- end

	local entity = EntityManager:CreateEntity(weaponUnlockPickupEntityData, s_Params)
	entity:Init(Realm.Realm_Server, true)
end

return KitSpawnServer()

