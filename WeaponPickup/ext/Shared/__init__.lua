class 'WeaponPickupShared'


function WeaponPickupShared:__init()
	print("Initializing WeaponPickupShared")
	self:RegisterVars()
	self:RegisterEvents()
end


function WeaponPickupShared:RegisterVars()
	self.m_Weapon = nil
end


function WeaponPickupShared:RegisterEvents()
	self.m_PartitionLoadedEvent = Events:Subscribe('Partition:Loaded', self, self.OnPartitionLoaded)
	self.m_OnUpdateInputEvent = Events:Subscribe('Client:UpdateInput', self, self.OnUpdateInput)
	Events:Subscribe('Player:Chat', self, self.OnChat)
	self.m_LevelLoadEvent = Events:Subscribe("Level:LoadResources", self, self.OnLoadResources)

	Hooks:Install('ClientEntityFactory:Create',999, self, self.OnEntityCreate)
	Hooks:Install("ServerEntityFactory:Create", 999, self, self.OnEntityCreate)

end

function WeaponPickupShared:OnLoadResources(p_Dedicated)
	print("OnLoadResources")
	local settings = GameSettings(ResourceManager:GetSettings("GameSettings"))
	print(settings.defaultLayerInclusion)
	settings.hasUnlimitedMags = true
	settings.hasUnlimitedAmmo = true
end

function WeaponPickupShared:OnEngineUpdate(p_Delta, p_SimDelta)
	if self.m_loadHandle == nil then 
		return 
	end
	
	if not ResourceManager:PollBundleOperation(self.m_loadHandle) then 
		return 
	end
	
	self.m_loadHandle = nil
	
	if not ResourceManager:EndLoadData(self.m_loadHandle) then
		print("Bundles failed to load")
		return
	end
end

function WeaponPickupShared:OnChat(player, recipientMask, message) -- remove this. trigger should be through netevents
	
	wep.unlockWeaponAndSlot.weapon = ResourceManager:FindInstanceByGUID(Guid('0D71EDA7-4AF1-4491-992D-E6C28EFEFF3E'), Guid('A7278B05-8D76-4A40-B65D-4414490F6886'))
	wep.unlockWeaponAndSlot.slot = WeaponSlot.WeaponSlot_0


	local params = EntityCreationParams()
	params.transform = LinearTransform()
	params.variationNameHash = 0
	params.networked = true

	local s_Entity = EntityManager:CreateServerEntity(wu, LinearTransform)
	print(#s_Entity)
	for i, entity in pairs(s_Entity) do
		entity:Init(Realm.Realm_ClientAndServer, true)
		entity:FireEvent("Activate")
		print(i)
	end

end

function WeaponPickupShared:OnEntityCreate(p_Hook, p_Data, p_Transform)
	if(p_Data:Is("VehicleEntityData")) then
		local s_Data = VehicleEntityData(p_Data)
		if(s_Data.nameSid == "Humvee") then
			return
		end
	end
	local s_Entity = p_Hook:Call()
	if( s_Entity == nil) then
		return
	end
	print(s_Entity)
	if( s_Entity:Is("ServerVehicleEntity")) then
		local s_Data = VehicleEntityData(p_Data)
		print(p_Data.instanceGuid)
		print(s_Data.nameSid)
	end
end

function WeaponPickupShared:OnUpdateInput(p_Delta, p_SimulationDelta)

	if InputManager:WentKeyDown(InputDeviceKeys.IDK_F1) then



	end

	if InputManager:WentKeyDown(InputDeviceKeys.IDK_F2) then
		for i, s_Preset in pairs(self.m_Presets) do
			s_Preset["data"].visibility = s_Preset["data"].visibility - 0.1
			s_Preset["entity"]:FireEvent("Disable")
			s_Preset["entity"]:FireEvent("Enable")
		end
	end
	if InputManager:WentKeyDown(InputDeviceKeys.IDK_F3) then
		for i, s_Preset in pairs(self.m_Presets) do
			s_Preset["data"].visibility = s_Preset["data"].visibility + 0.1
			s_Preset["entity"]:FireEvent("Disable")
			s_Preset["entity"]:FireEvent("Enable")
		end
	end
end

function WeaponPickupShared:OnPartitionLoaded(p_Partition)
	if p_Partition == nil then
		return
	end
	
	local s_Instances = p_Partition.instances


	for _, l_Instance in ipairs(s_Instances) do
		if l_Instance == nil then
			print('Instance is null?')
			break
		end
		
		if(l_Instance.instanceGuid == Guid("8FE1F5F4-6C8F-4185-B478-2DDEA1CCA686")) then
			local s_Instance = SubWorldReferenceObjectData(l_Instance)
			s_Instance:MakeWritable()
			print("Found subworld reference!")

			--s_Instance.autoLoad = true
			s_Instance.bundleName = "Levels/MP_012/TutorialMP"
		end
		if(l_Instance:Is("FiringFunctionData")) then
			--local s_Instance = FiringFunctionData(l_Instance)
			--s_Instance:MakeWritable()
			--s_Instance.ammo.autoReplenishMagazine = true
			--s_Instance.ammo.autoReplenishDelay = 1 
		end
		if(l_Instance.typeInfo.name == "VehicleSpawnReferenceObjectData") then

			local s_Instance = VehicleSpawnReferenceObjectData(l_Instance)
			s_Instance:MakeWritable()

			
			--s_Instance.initialAutoSpawn = false
			--s_Instance.autoSpawn  = false
			--s_Instance.enabled = false
			--s_Instance.initialSpawnDelay = -1
			-- vehicleSpawnReferenceObjectData.blueprint = nil
			print(tostring(l_Instance.instanceGuid))

			if(s_Instance.blueprint ~= nil) then
				print("Found blueprint")
				local blueprint = _G[s_Instance.blueprint.typeInfo.name](s_Instance.blueprint) 
				print(tostring(blueprint.instanceGuid))
				if(blueprint.object ~= nil) then
					local entity = VehicleEntityData(blueprint.object)
					print( entity.nameSid )
					if(entity.nameSid == "f16" or entity.nameSid == "Humvee") then
						s_Instance.enabled = false
					end
				elseif(blueprint.objects ~= nil) then
					print("Objects")
					for _, object in ipars(blueprint.objects) do
						print(tostring(object.instanceGuid) .. " - " .. object.typeInfo.name)
					end
				else
					print("missing blueprint object")
					s_Instance.enabled = false
				end
			end			
		end

		if(l_Instance.typeInfo.name == "CharacterSpawnReferenceObjectData") then

			local s_Instance = CharacterSpawnReferenceObjectData(l_Instance)
			s_Instance:MakeWritable()

			if(s_Instance.playerType == PlayerSpawnType.PlayerSpawnType_Actor) then
				print("Character")
				print(tostring(s_Instance.instanceGuid))
				s_Instance.enabled = false
			end
			
		end

		if(l_Instance.instanceGuid == Guid("B8A8FC20-1D85-4037-9322-173FBA11D8CD")) then
			self.m_Weapon =  WeaponUnlockPickupEntityData(l_Instance)
			print("FOUND THE SHIT MAN!")
		end
	end
end

function dump(o)
	if(o == nil) then
		print("tried to load jack shit")
	end
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


g_WeaponPickupShared = WeaponPickupShared()

