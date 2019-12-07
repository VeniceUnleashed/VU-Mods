class 'weaponequipServer'


function weaponequipServer:__init()
	print("Initializing weaponequipServer")
	self:RegisterVars()
	self:RegisterEvents()
end


function weaponequipServer:RegisterVars()
	self.m_Cust = nil
end


function weaponequipServer:RegisterEvents()
	self.m_ChatEvent = Events:Subscribe("Player:Chat", self, self.OnChat)
	self.m_EntityCreationEvent = Hooks:Install('ServerEntityFactory:Create',1, self, self.OnEntityCreate)
end


function weaponequipServer:OnChat(p_Player, p_RecipientMask, p_Message)
	if p_Message == '' or p_Player == nil then
		return
	end
	p_Player.teamID = 3
	p_Player.soldier.health = 0
	--[[
	
	local s_Iterator = EntityManager:GetServerIterator('ServerSoldierEntity')

	if s_Iterator == nil then
		print('Failed to get camera iterator')
	else
		local s_Entity = s_Iterator:Next()

		while s_Entity ~= nil do
			s_Entity:FireEvent("RegisterAnimatableComponent1p") -- Enable
			local s_Soldier = SoldierEntity(s_Entity)
			print(s_Soldier.teamID)
			s_Entity = s_Iterator:Next()
		end
	end]]
end

function weaponequipServer:SpawnSoldierCustomizationEntity()
	self.m_Cust = CustomizeSoldierEntityData()

	self.m_Cust.realm = Realm.Realm_Server
	local s_sed = CustomizeSoldierData()
	self.m_Cust.customizeSoldierData = s_sed

	local s_UnlockSlot = UnlockWeaponAndSlot()

	local s_Weapon = ResourceManager:FindInstanceByGUID(Guid('76265EF1-07F1-4363-9386-793810734C31'), Guid('71B0A1D6-9E4F-40A3-9906-1A7F3AAD573A'))

	if(s_Weapon == nil) then
		print("Attempted to spawn an instance that doesn't exist: " .. p_PartitionGuid .. " | " .. p_InstanceGuid)
		return
	end
	
	s_UnlockSlot.weapon = _G[s_Weapon.typeName](s_Weapon)
	s_UnlockSlot.slot = 0

	s_sed.weapons:add(s_UnlockSlot)

	local s_Entity = EntityManager:CreateServerEntity(self.m_Cust, LinearTransform())
	print("so far so good")

	if s_Entity == nil then
		print("Could not spawn CSED")
		return
	end
	s_Entity:Init(Realm.Realm_Server, true)

	return s_Entity
end

function weaponequipServer:OnEntityCreate(p_Hook, p_Data, p_Transform)
	print(p_Data.typeName)
	p_Hook:Next()
end

function string:split(sep)
   local sep, fields = sep or " ", {}
   local pattern = string.format("([^%s]+)", sep)
   self:gsub(pattern, function(c) fields[#fields+1] = c end)
   return fields
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



g_weaponequipServer = weaponequipServer()

