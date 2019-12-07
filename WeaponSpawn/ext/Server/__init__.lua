class 'WeaponSpawnServer'


function WeaponSpawnServer:__init()
	print("Initializing WeaponSpawnServer")
	self:RegisterVars()
	self:RegisterEvents()
end


function WeaponSpawnServer:RegisterVars()
	--self.m_this = that
end


function WeaponSpawnServer:RegisterEvents()
	self.m_ChatEvent = Events:Subscribe("Player:Chat", self, self.OnChat)
	Hooks:Install('ResourceManager:LoadBundle',1, self, self.OnLoadBundle)
	self.m_ReadInstanceEvent = Events:Subscribe('Partition:ReadInstance', self, self.ReadInstance)
end

function WeaponSpawnServer:OnLoadBundle(p_Hook, p_Bundle)
	print("Loading some bundle")
	
end

function WeaponSpawnServer:ReadInstance(p_Instance,p_PartitionGuid, p_Guid)
	if p_Instance == nil then
		return
	end
	
	if(p_Instance.typeName == "WeaponUnlockPickupEntityData") then
		print(p_PartitionGuid:ToString('D') .. " | " ..  p_Guid:ToString('D'))
	end
end

function WeaponSpawnServer:OnChat(p_Player, p_Mask, p_Message)
	--print("[kBot] " .. p_Player.name .. ": " .. p_Message)
	if p_Player == nil then
		return
	end


	
	local s_Commands = split(p_Message, " ")
	
	local s_Command = s_Commands[1]
	if s_Command == nil then
		return
	end
	
	if s_Command == "go" then
		self:SpawnWeapon(p_Player)
	end
end

function WeaponSpawnServer:SpawnWeapon(p_Player) 
	if (p_Player == nil or p_Player.soldier == nil) then
		print("Tried to spawn weapons without a player")
		return
	end

	local s_Transform = p_Player.soldier.transform

	local s_Blueprint = SpatialPrefabBlueprint()
	print("NO CRASH YET WOOO")
	s_Blueprint.needNetworkId = true

	local s_Weapon = WeaponUnlockPickupEntityData()
	print("Weapon created.....")

	s_Blueprint:AddObjects(s_Weapon)
	s_Weapon.isEventConnectionTarget = 3
	s_Weapon.isPropertyConnectionTarget = 3
	s_Weapon.indexInBlueprint = 0
	s_Weapon.enabled = true
	s_Weapon.useWeaponMesh = true
	s_Weapon.preferredWeaponSlot = 0
	s_Weapon.timeToLive = 0.0
	s_Weapon.unspawnOnPickup = false
	s_Weapon.unspawnOnAmmoPickup = false
	s_Weapon.contentIsStatic = false
	s_Weapon.positionIsStatic = false
	s_Weapon.allowPickup = true
	s_Weapon.ignoreNullWeaponSlots = false
	s_Weapon.forceWeaponSlotSelection = true
	s_Weapon.displayInMiniMap = true
	s_Weapon.hasAutomaticAmmoPickup = true
	s_Weapon.minRandomSpareAmmoPercent = 0
	s_Weapon.maxRandomSpareAmmoPercent = 0
	s_Weapon.minRandomClipAmmoPercent = 0
	s_Weapon.maxRandomClipAmmoPercent = 0
	s_Weapon.interactionRadius = 2.5
	s_Weapon.replaceAllContent = false
	s_Weapon.removeWeaponOnDrop = false
	s_Weapon.sendPlayerInEventOnPickup = false

	s_Weapon.useForPersistence = true 

	local s_Unlock = WeaponUnlockPickupData()

	s_Weapon:AddWeapons(s_Unlock)

	print(s_Blueprint:GetObjectsCount())
	local s_WeaponUnlockAsset = ResourceManager:FindInstanceByGUID(Guid('BC5E0140-2D3A-11E0-9BC3-840F57499EC0', 'D'), Guid('93CC5226-4381-7458-509E-B2D6F4498164','D'))

	if s_WeaponUnlockAsset == nil then
		print("Failed to get the weaponunlock")
		return
	end
	s_Unlock.unlockWeaponAndSlot.weapon = SoldierWeaponUnlockAsset(s_WeaponUnlockAsset)
	s_Unlock.unlockWeaponAndSlot.slot = 0
	s_Unlock.altWeaponSlot = 1
	s_Unlock.linkedToWeaponSlot = -1
	s_Unlock.minAmmo = 100
	s_Unlock.maxAmmo = 150
	s_Unlock.defaultToFullAmmo = true

	print("Everything is set and ready. Spawning...")

	local objectEntities = EntityManager:CreateServerEntity(s_Weapon, s_Transform)
	if(objectEntities == nil) then
		print("Failed to spawn blueprint")
		return
	end
    print("Spawned. Initializing")

	objectEntities:Init(Realm.Realm_ClientAndServer, true)
    print("SPAWNED!")
    --NetEvents:BroadcastLocal('SpawnWeapon')
end

function split(pString, pPattern)
   local Table = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pPattern
   local last_end = 1
   local s, e, cap = pString:find(fpat, 1)
   while s do
	  if s ~= 1 or cap ~= "" then
	 table.insert(Table,cap)
	  end
	  last_end = e+1
	  s, e, cap = pString:find(fpat, last_end)
   end
   if last_end <= #pString then
	  cap = pString:sub(last_end)
	  table.insert(Table, cap)
   end
   return Table
end

function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

g_WeaponSpawnServer = WeaponSpawnServer()

