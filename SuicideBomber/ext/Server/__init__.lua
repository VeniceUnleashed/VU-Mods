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
	self.blueprint = nil
	self.weaponPickup = nil
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

	if p_Guid == Guid('C79AAC6E-566E-40E1-B373-3B0029530393','D') then
		self.weapon = SoldierWeaponUnlockAsset(p_Instance)
	end
	if p_Guid == Guid('48BBE4F8-6138-4EC0-9E6D-CF7C7CCBABB7', 'D') then
		self.pickup = WeaponUnlockPickupEntityData(p_Instance)
	end
end

function SuicideBomberServer:OnNade(p_Player, p_Mask, p_Message, p_Commands)
	local s_Player = SuicideBomberServer:FindPlayer(p_Player.name)
	if s_Player.hasSoldier then
		print("Found soldier")
		local soldier = s_Player.soldier
		local entity = PickupEntityData()
		local spawnedPickup = EntityManager:CreateServerEntity(entity, soldier.transform)
		if spawnedPickup == nil then
			print("Could not spawn pickup")
		end

		spawnedPickup:Init(Realm.Realm_ClientAndServer, true)
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
