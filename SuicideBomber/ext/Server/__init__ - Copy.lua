class 'SuicideBomberServer'

--local fx = require '__shared/util/fx.lua'

function SuicideBomberServer:__init()
	print("Initializing SuicideBomberServer")
	self:RegisterVars()
	self:RegisterEvents()
end


function SuicideBomberServer:RegisterVars()
	self.m_Commands = {
		["Allahuakbar"] = self.OnNade
	}
	self.explosion = nil
	self.effect = nil
	self.weapon = nil
	self.pickup = nil
	self.WeaponUnlock1 = nil
end


function SuicideBomberServer:RegisterEvents()
	--self.m_ReadInstanceEvent = Events:Subscribe('Partition:ReadInstance', self, self.ReadInstance)
	self.m_ChatEvent = Events:Subscribe("Player:Chat", self, self.OnChat)
	self.m_ReadInstanceEvent = Events:Subscribe('Partition:ReadInstance', self, self.ReadInstance)
	self.m_EntityCreateEvent = Hooks:Install('ServerEntityFactory:Create', self, self.OnEntityCreate)
	self.m_Kill = Hooks:Install('Player:Killed', self, self.OnPlayerKilled)

end

function SuicideBomberServer:OnPlayerKilled(p_victim, p_inflictor, p_position, p_weapon, p_roadkill, p_headshot, p_victimInReviveState)
	print(string.format('%s %s %s %s %s %s %s', p_victim, p_inflictor, p_position, p_weapon, p_roadkill, p_headshot, p_victimInReviveState))
end

function SuicideBomberServer:OnEntityCreate(p_Hook, p_Data, p_Transform)
	print(string.format('Creating entity type "%s" (%f, %f, %f)', p_Data.typeName, p_Transform.trans.x, p_Transform.trans.y, p_Transform.trans.z))

	return p_Hook:CallOriginal(p_Data, p_Transform)
end

function SuicideBomberServer:ReadInstance(p_Instance, p_Guid)
	if p_Instance == nil then
		return
	end

	if p_Guid == Guid("5FE6E2AD-072E-4722-984A-5C52BC66D4C1", 'D') then --nade
		--local s_Instance = PhysicsEntityData(p_Instance)
		print("Found explosion")
		self.explosion = p_Instance
	end
	if p_Guid == Guid('4D5AE774-5017-463E-8C05-6699374FD480', 'D') then
		print("Found smoke")
		self.effect = p_Instance
	end
	if p_Guid == Guid('A9FFE6B4-257F-4FE8-A950-B323B50D2112', 'D') then
		--self.soldier = p_Instance
	end
	if p_Guid == Guid('48BBE4F8-6138-4EC0-9E6D-CF7C7CCBABB7', 'D') then
		self.pickup = WeaponUnlockPickupEntityData(p_Instance)
		--print(tostring(pickup:GetWeaponsAt(0). ))
	end
	if p_Guid == Guid('C79AAC6E-566E-40E1-B373-3B0029530393','D') then
		print("Found weapon")
		self.weapon = SoldierWeaponUnlockAsset(p_Instance)
	end

	if p_Guid == Guid('96EF016C-4246-27BF-E65F-D93E823EA96C', 'D') then
		local s_Instance = RegistryContainer(p_Instance)
		local spatial =  self:CreateSpatialBlueprint()
		if spatial == nil then
			print("No fucking spatial blueprint was created wtf")
			return
		end
		s_Instance:AddBlueprintRegistry(spatial)
		print("Added the damn blueprint or whatever fuck you")
	end
end

function SuicideBomberServer:OnNade(p_Player, p_Mask, p_Message, p_Commands)
	local s_Player = SuicideBomberServer:FindPlayer(p_Player.name)
	if s_Player.hasSoldier then
		print("Found soldier")
		local soldier = s_Player.soldier
		
		local spawnedPickup = EntityManager:CreateServerEntity(self.WeaponUnlock1, soldier.transform)
		if spawnedPickup == nil then
			print("Could not spawn pickup")
			return
		end
		print("Spawning")
		spawnedPickup:Init(Realm.Realm_Server, true)
		print("Spawned")

		--spawnedPickup:Init(Realm.Realm_ClientAndServer, true)
		--local nade = EntityManager:CreateServerEntity(VeniceExplosionEntityData(self.explosion), soldier.transform)
		--local effect = EntityManager:CreateServerEntity(EffectEntityData(self.effect), soldier.transform)
		
		--if nade == nil then
		-- 	print('Could not create explosion entity')
		-- 	return
		--end
		--if effect == nil then
		-- 	print('Could not create effect entity')
		-- 	return
		--end

		--mpSoldier:Init(Realm.Realm_ClientAndServer, true)
		--effect:Init(Realm.Realm_Client, true)<
	end
end

function SuicideBomberServer:CreateSpatialBlueprint()
	self.WeaponUnlock1 = WeaponUnlockPickupEntityData()
        self.WeaponUnlock1.isEventConnectionTarget = 2
        self.WeaponUnlock1.isPropertyConnectionTarget = 1
        self.WeaponUnlock1.indexInBlueprint = 0
        self.WeaponUnlock1.enabled = true
        self.WeaponUnlock1.runtimeComponentCount = 0
        self.WeaponUnlock1.useWeaponMesh = true
        self.WeaponUnlock1.preferredWeaponSlot = 0
        self.WeaponUnlock1.timeToLive = 0.0
        self.WeaponUnlock1.unspawnOnPickup = false
        self.WeaponUnlock1.unspawnOnAmmoPickup = false
        self.WeaponUnlock1.contentIsStatic = true
        self.WeaponUnlock1.positionIsStatic = true
        self.WeaponUnlock1.allowPickup = true
        self.WeaponUnlock1.ignoreNullWeaponSlots = false
        self.WeaponUnlock1.forceWeaponSlotSelection = true
        self.WeaponUnlock1.displayInMiniMap = true
        self.WeaponUnlock1.hasAutomaticAmmoPickup = false
        self.WeaponUnlock1.minRandomSpareAmmoPercent = 100
        self.WeaponUnlock1.maxRandomSpareAmmoPercent = 100
        self.WeaponUnlock1.minRandomClipAmmoPercent = 100
        self.WeaponUnlock1.maxRandomClipAmmoPercent = 100
        self.WeaponUnlock1.randomizeAmmoOnDropForPlayer = PickupPlayerEnum.PickupPlayerEnum_HumanOnly
        self.WeaponUnlock1.interactionRadius = 2.5
        self.WeaponUnlock1.replaceAllContent = false
        self.WeaponUnlock1.removeWeaponOnDrop = false
        self.WeaponUnlock1.sendPlayerInEventOnPickup = true
        self.WeaponUnlock1.useForPersistence = true
        self.WeaponUnlock1.randomlySelectOneWeapon = true

        local s_weapon = WeaponUnlockPickupData()
            local s_unlockAndSlot = UnlockWeaponAndSlot()
                s_unlockAndSlot.weapon = self.weapon
                s_unlockAndSlot.slot = WeaponSlot.WeaponSlot_0
            s_weapon.altWeaponSlot = -1
            s_weapon.linkedToWeaponSlot = -1
            s_weapon.minAmmo = 62
            s_weapon.maxAmmo = 62
            s_weapon.defaultToFullAmmo = false
            s_weapon.unlockWeaponAndSlot = s_unlockAndSlot
        self.WeaponUnlock1:AddWeapons(s_weapon)

	local s_BoolEntity1 = BoolEntityData()
	    s_BoolEntity1.isEventConnectionTargetType = 1
	    s_BoolEntity1.isPropertyConnectionTarget = 3
	    s_BoolEntity1.indexInBlueprint = 2
	    s_BoolEntity1.realm = Realm.Realm_Server
	    s_BoolEntity1.defaultValue = true

	local s_DelayEntity1 = DelayEntityData()
	    s_DelayEntity1.isEventConnectionTargetType = 1
	    s_DelayEntity1.isPropertyConnectionTarget = 3
	    s_DelayEntity1.indexInBlueprint = 1
	    s_DelayEntity1.delay = 15.0
	    s_DelayEntity1.realm = Realm.Realm_Server
	    s_DelayEntity1.autoStart = false
	    s_DelayEntity1.runOnce = false
	    s_DelayEntity1.removeDuplicateEvents = true

	local s_DelayEntity2 = DelayEntityData()
	    s_DelayEntity2.isEventConnectionTargetType = 2
	    s_DelayEntity2.isPropertyConnectionTarget = 3
	    s_DelayEntity2.indexInBlueprint = 4
	    s_DelayEntity2.delay = 1.0
	    s_DelayEntity2.realm = Realm.Realm_ClientAndServer
	    s_DelayEntity2.autoStart = false
	    s_DelayEntity2.runOnce = true
	    s_DelayEntity2.removeDuplicateEvents = true

	local s_DelayEntity3 = DelayEntityData()
	    s_DelayEntity3.isEventConnectionTargetType = 2
	    s_DelayEntity3.isPropertyConnectionTarget = 3
	    s_DelayEntity3.indexInBlueprint = 5
	    s_DelayEntity3.delay = 1.0
	    s_DelayEntity3.realm = Realm.Realm_ClientAndServer
	    s_DelayEntity3.autoStart = false
	    s_DelayEntity3.runOnce = true
	    s_DelayEntity3.removeDuplicateEvents = true

	local s_InterfaceDescriptor1 = InterfaceDescriptorData()
	    local s_de1 = DynamicEvent()
	    s_de1.id = -117303631

	    local s_de2 = DynamicEvent()
	    s_de2.id = -1952177180

	    s_InterfaceDescriptor1:AddInputEvents(s_de1)
	    s_InterfaceDescriptor1:AddInputEvents(s_de2)     

	local s_MapMarker1 = MapMarkerEntityData()
	    s_MapMarker1.isEventConnectionTargetType = 2
	    s_MapMarker1.isPropertyConnectionTarget = 3
	    s_MapMarker1.indexInBlueprint = 3
	    s_MapMarker1.enabled = true
	    s_MapMarker1.runtimeComponentCount = 0
	    s_MapMarker1.sid = "ID_H_SCAV_PICKUP_TIER1"
	    s_MapMarker1.nrOfPassengers = 0
	    s_MapMarker1.nrOfEntries = 0
	    s_MapMarker1.isVisible = true
	    s_MapMarker1.showRadius = 15.0
	    s_MapMarker1.hideRadius = 1.0
	    s_MapMarker1.blinkTime = 5.0
	    s_MapMarker1.markerType = MapMarkerType .MMTMissionObjective
	    s_MapMarker1.visibleForTeam = TeamId.TeamNeutral
	    s_MapMarker1.ownerTeam = TeamId.TeamNeutral
	    s_MapMarker1.hudIcon = UIHudIcon.UIHudIcon_WeaponPickupTier3
	    s_MapMarker1.verticalOffset = 0.0
	    s_MapMarker1.showAirTargetBox = true
	    s_MapMarker1.isFocusPoint = true
	    s_MapMarker1.focusPointRadius = 80.0
	    s_MapMarker1.snap = false
	    s_MapMarker1.onlyShowSnapped = false
	    s_MapMarker1.flagControlMarker = false
	    s_MapMarker1.useMarkerTransform = false
	    s_MapMarker1.progressTime = 80.0
	    s_MapMarker1.progress = 0.0
	    s_MapMarker1.trackedPlayersInRange = 0
	    s_MapMarker1.showProgress = false
	    s_MapMarker1.trackingPlayerRange = 10.0
	    s_MapMarker1.instantFlagReturnRadius = 0.0
	    s_MapMarker1.progressPlayerSpeedUpPercentage = 10.0
	    s_MapMarker1.progressTime1Player = 0.0
	    s_MapMarker1.progressMinTime = 15.0
	    s_MapMarker1.useForPersistence = true
	    s_MapMarker1.randomlySelectOneWeapon = true

	local s_StaticEventTrigger1 = StatEventTriggerEntityData()
	    s_StaticEventTrigger1.isEventConnectionTargetType = 1
	    s_StaticEventTrigger1.isPropertyConnectionTarget = 3
	    s_StaticEventTrigger1.indexInBlueprint = 6
	    s_StaticEventTrigger1.enabled = true
	    s_StaticEventTrigger1.runtimeComponentCount = 0
	    s_StaticEventTrigger1.statEvent = StatEvent.StatEvent_Misc_X_and_Y
	    s_StaticEventTrigger1.miscParamX = "XP4ACH02"
	    s_StaticEventTrigger1.sendToAll = false

	local s_Spatial = SpatialPrefabBlueprint() 
	    local s_PC1 = PropertyConnection()
	        s_PC1.source = s_BoolEntity1
	        s_PC1.target = self.WeaponUnlock1
	        s_PC1.sourceFieldId = 225375086
	        s_PC1.targetFieldId = -1355906264

	    s_Spatial:AddPropertyConnections(s_PC1)

	    local s_event1 = EventConnection()
	        s_event1.source = s_DelayEntity1
	        s_event1.target = s_BoolEntity1
	        s_event1.sourceEvent.id = 193453899
	        s_event1.targetEvent.id = -1541066415
	        s_event1.targetType = EventConnectionTargetType.EventConnectionTargetType_Server

	    local s_event2 = EventConnection()
	        s_event2.source = self.WeaponUnlock1
	        s_event2.target = s_BoolEntity1
	        s_event2.sourceEvent.id = -1836726032
	        s_event2.targetEvent.id = 668205626
	        s_event2.targetType = EventConnectionTargetType.EventConnectionTargetType_Server

	    local s_event3 = EventConnection()
	        s_event3.source = self.WeaponUnlock1
	        s_event3.target = s_DelayEntity1
	        s_event3.sourceEvent.id = -1836726032
	        s_event3.targetEvent.id = 1303794898
	        s_event3.targetType = EventConnectionTargetType.EventConnectionTargetType_Server

	    local s_event4 = EventConnection()
	        s_event4.source = self.WeaponUnlock1
	        s_event4.target = self.WeaponUnlock1
	        s_event4.sourceEvent.id = -1836726032
	        s_event4.targetEvent.id = -2099664573
	        s_event4.targetType = EventConnectionTargetType.EventConnectionTargetType_Server

	    local s_event5 = EventConnection()
	        s_event5.source = self.WeaponUnlock1
	        s_event5.target = self.WeaponUnlock1
	        s_event5.sourceEvent.id = -1836726032
	        s_event5.targetEvent.id = -117303631
	        s_event5.targetType = EventConnectionTargetType.EventConnectionTargetType_NetworkedClientAndServer

	    local s_event6 = EventConnection()
	        s_event6.source = s_DelayEntity1
	        s_event6.target = self.WeaponUnlock1
	        s_event6.sourceEvent.id = 193453899
	        s_event6.targetEvent.id = -1952177180
	        s_event6.targetType = EventConnectionTargetType.EventConnectionTargetType_NetworkedClientAndServer

	    local s_event7 = EventConnection()
	        s_event7.source = s_InterfaceDescriptor1
	        s_event7.target = s_MapMarker1
	        s_event7.sourceEvent.id = -1952177180
	        s_event7.targetEvent.id = -1952177180
	        s_event7.targetType = EventConnectionTargetType.EventConnectionTargetType_NetworkedClientAndServer

	    local s_event8 = EventConnection()
	        s_event8.source = s_InterfaceDescriptor1
	        s_event8.target = s_MapMarker1
	        s_event8.sourceEvent.id = -117303631
	        s_event8.targetEvent.id = -117303631
	        s_event8.targetType = EventConnectionTargetType.EventConnectionTargetType_NetworkedClientAndServer

	    local s_event9 = EventConnection()
	        s_event9.source = self.WeaponUnlock1
	        s_event9.target = s_MapMarker1
	        s_event9.sourceEvent.id = -1836726032
	        s_event9.targetEvent.id = -1643756729
	        s_event9.targetType = EventConnectionTargetType.EventConnectionTargetType_Server

	    local s_event10 = EventConnection()
	        s_event10.source = s_DelayEntity1
	        s_event10.target = s_MapMarker1
	        s_event10.sourceEvent.id = 193453899
	        s_event10.targetEvent.id = 2002318980
	        s_event10.targetType = EventConnectionTargetType.EventConnectionTargetType_Server

	    local s_event11 = EventConnection()
	        s_event11.source = s_InterfaceDescriptor1
	        s_event11.target = s_DelayEntity3
	        s_event11.sourceEvent.id = -1952177180
	        s_event11.targetEvent.id = 5862146
	        s_event11.targetType = EventConnectionTargetType.EventConnectionTargetType_NetworkedClientAndServer

	    local s_event12 = EventConnection()
	        s_event12.source = s_DelayEntity3
	        s_event12.target = self.WeaponUnlock1
	        s_event12.sourceEvent.id = 193453899
	        s_event12.targetEvent.id = -1952177180
	        s_event12.targetType = EventConnectionTargetType.EventConnectionTargetType_ClientAndServer

	    local s_event13 = EventConnection()
	        s_event13.source = s_DelayEntity3
	        s_event13.target = s_BoolEntity1
	        s_event13.sourceEvent.id = 193453899
	        s_event13.targetEvent.id = -1541066415
	        s_event13.targetType = EventConnectionTargetType.EventConnectionTargetType_Server

	    local s_event14 = EventConnection()
	        s_event14.source = s_InterfaceDescriptor1
	        s_event14.target = s_DelayEntity2
	        s_event14.sourceEvent.id = -117303631
	        s_event14.targetEvent.id = 5862146
	        s_event14.targetType = EventConnectionTargetType.EventConnectionTargetType_NetworkedClientAndServer

	    local s_event15 = EventConnection()
	        s_event15.source = s_DelayEntity2
	        s_event15.target = self.WeaponUnlock1
	        s_event15.sourceEvent.id = 193453899
	        s_event15.targetEvent.id = -117303631
	        s_event15.targetType = EventConnectionTargetType.EventConnectionTargetType_ClientAndServer

	    local s_event16 = EventConnection()
	        s_event16.source = s_DelayEntity2
	        s_event16.target = s_BoolEntity1
	        s_event16.sourceEvent.id = 193453899
	        s_event16.targetEvent.id = 668205626
	        s_event16.targetType = EventConnectionTargetType.EventConnectionTargetType_Server

	    local s_event17 = EventConnection()
	        s_event17.source = self.WeaponUnlock1
	        s_event17.target = s_StaticEventTrigger1
	        s_event17.sourceEvent.id = -1836726032
	        s_event17.targetEvent.id = -1688613187
	        s_event17.targetType = EventConnectionTargetType.EventConnectionTargetType_Server

	    s_Spatial:AddEventConnections(s_event1)
	    s_Spatial:AddEventConnections(s_event2)
	    s_Spatial:AddEventConnections(s_event3)
	    s_Spatial:AddEventConnections(s_event4)
	    s_Spatial:AddEventConnections(s_event5)
	    s_Spatial:AddEventConnections(s_event6)
	    s_Spatial:AddEventConnections(s_event7)
	    s_Spatial:AddEventConnections(s_event8)
	    s_Spatial:AddEventConnections(s_event9)
	    s_Spatial:AddEventConnections(s_event10)
	    s_Spatial:AddEventConnections(s_event11)
	    s_Spatial:AddEventConnections(s_event12)
	    s_Spatial:AddEventConnections(s_event13)
	    s_Spatial:AddEventConnections(s_event14)
	    s_Spatial:AddEventConnections(s_event15)
	    s_Spatial:AddEventConnections(s_event16)
	    s_Spatial:AddEventConnections(s_event17)

	    s_Spatial.descriptor = s_InterfaceDescriptor1
	    s_Spatial.needNetworkId = true
	    s_Spatial.interfaceHasConnections = true
	    s_Spatial.alwaysCreateEntityBusClient = true
	    s_Spatial.alwaysCreateEntityBusServer = true

	    s_Spatial:AddObjects(self.WeaponUnlock1)
	    s_Spatial:AddObjects(s_DelayEntity1)
	    s_Spatial:AddObjects(s_BoolEntity1)
	    s_Spatial:AddObjects(s_MapMarker1)
	    s_Spatial:AddObjects(s_DelayEntity2)
	    s_Spatial:AddObjects(s_DelayEntity3)
	    s_Spatial:AddObjects(s_StaticEventTrigger1)

	    return s_Spatial
end	

function SuicideBomberServer:OnChat(p_Player, p_Mask, p_Message)
	if p_Player == nil then
		return
	end
	
	local s_Commands = split(p_Message, " ")
	
	local s_Command = s_Commands[1]
	if s_Command == nil then
		return
	end
	
	s_Function = self.m_Commands[s_Command]
	if s_Function == nil then
		return
	end
	self.m_CalledByPlayer = p_Player
	s_Function(self, p_Player, p_Mask, p_Message, s_Commands)
end



function SuicideBomberServer:FindPlayer(p_Player) 
	local s_Players = PlayerManager:GetPlayers()
	local ret = nil
	for s_Index, s_Player in pairs(s_Players) do
		print(tostring(s_Player.name))
		if string.match(string.lower(s_Player.name), string.lower(p_Player)) then
			ret = s_Player
			print(s_Player.name)
			return ret
		end
	end
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

g_SuicideBomberServer = SuicideBomberServer()

return SuicideBomberServer
