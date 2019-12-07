class 'KitSpawnUIServer'


function KitSpawnUIServer:__init()
	print("Initializing KitSpawnUIServer")
	self:RegisterVars()
	self:RegisterEvents()
end


function KitSpawnUIServer:RegisterVars()
	self.soldierAsset = nil
	self.soldierBlueprint = nil
	self.weapon = nil
	self.weaponAtt0 = nil
	self.weaponAtt01 = nil
	self.weaponAtt1 = nil
	self.drPepper = nil
end


function KitSpawnUIServer:RegisterEvents()
	self.m_ReadInstanceEvent = Events:Subscribe('Partition:ReadInstance', self, self.ReadInstance)
    self.m_SpawnSoldierEvent =  NetEvents:Subscribe('RealityModUI:SpawnSoldier', self, self.SpawnSoldier)

	self.m_LoadLevelEvent = Events:Subscribe('Level:LoadResources', self.OnLoadLevel)
end

function KitSpawnUIServer:ReadInstance(p_Instance,p_PartitionGuid, p_Guid)

	if p_Instance.typeName == 'VeniceSoldierCustomizationAsset' then
		local asset = VeniceSoldierCustomizationAsset(p_Instance)

		if asset.name == 'Gameplay/Kits/RURecon' then
			print('Found soldier customization asset ' .. asset.name)
			self.soldierAsset = asset
		end
	end

	if p_Instance.typeName == 'SoldierBlueprint' then
		self.soldierBlueprint = SoldierBlueprint(p_Instance)
		print('Found soldier blueprint ' .. self.soldierBlueprint.name)
	end

	if p_Instance.typeName == 'SoldierWeaponUnlockAsset' then
		local asset = SoldierWeaponUnlockAsset(p_Instance)

		if asset.name == 'Weapons/M416/U_M416' then
			print('Found soldier weapon unlock asset ' .. asset.name)
			self.weapon = asset
		end
	end
	if p_Instance.typeName == 'UnlockAsset' then
		local asset = UnlockAsset(p_Instance)

		if asset.name == 'Weapons/M416/U_M416_ACOG' then
			print('Found weapon unlock asset ' .. asset.name)
			self.weaponAtt0 = asset
		end

		if asset.name == 'Weapons/M416/U_M416_IRNV' then
			print('Found weapon unlock asset ' .. asset.name)
			self.weaponAtt01 = asset
		end

		if asset.name == 'Weapons/M416/U_M416_Silencer' then
			print('Found weapon unlock asset ' .. asset.name)
			self.weaponAtt1 = asset
		end

		if asset.name == 'Persistence/Unlocks/Soldiers/Visual/MP/RU/MP_RU_Recon_Appearance_DrPepper' then
			print('Found appearance asset ' .. asset.name)
			self.drPepper = asset
		end
	end
end




function KitSpawnUIServer:SpawnSoldier(p_Player, p_SelectedKit)
	player = p_Player
	if player == nil or player.soldier ~= nil then
		print('Player must be dead to spawn')
		return
	end

	local transform = LinearTransform(
		Vec3(1, 0, 0),
		Vec3(0, 1, 0),
		Vec3(0, 0, 1),
		Vec3(0, 200, 0)
	)

	--Selects attachment based on kit
	-- In the future, this must be better.
	local s_SelectedAttachment = self.weaponAtt0
	if p_SelectedKit == 1 then
		print("Spawning with IRNV")
		s_SelectedAttachment = self.weaponAtt01
	end

	if p_SelectedKit == "1" then
		print("Spawning with IRNV but as a string")
		s_SelectedAttachment = self.weaponAtt01
	end
	print("Spawning " .. p_Player.name .. " with kit: " .. p_SelectedKit)

	---


	print('Setting soldier primary weapon')
	player:SelectWeapon(WeaponSlot.WeaponSlot_0, self.weapon, { s_SelectedAttachment, self.weaponAtt1 })

	print('Setting soldier class and appearance')
	player:SelectUnlockAssets(self.soldierAsset, { self.drPepper })

	print('Creating soldier')
	local soldier = player:CreateSoldier(self.soldierBlueprint, transform)

	if soldier == nil then
		print('Failed to create player soldier')
		return
	end

	print('Spawning soldier')
	player:SpawnSoldierAt(soldier, transform, CharacterPoseType.CharacterPoseType_Stand)

	print('Soldier spawned')
end

function KitSpawnUIServer:OnLoadLevel()
	soldierAsset = nil
	soldierBlueprint = nil
	weapon = nil
	weaponAtt0 = nil
	weaponAtt01 = nil
	weaponAtt1 = nil
	drPepper = nil
end

g_KitSpawnUIServer = KitSpawnUIServer()

