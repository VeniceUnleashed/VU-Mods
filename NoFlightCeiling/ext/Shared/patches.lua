class 'SharedPatches'

local FlightCeiling = require '__shared/FlightCeiling'
local InstanceFinder = require('__shared/util/instancefinder')

function SharedPatches:__init()
	self.m_Finder = InstanceFinder()
	self:RegisterEvents()
	self:InitComponents()
	
	self.m_InvCol1 = Guid('8B71D173-8518-11E0-BB7A-DDA550615CAF', 'D')
	self.m_InvCol2 = Guid('C2E7889C-9CB2-11E0-A4B6-91A00ABC2528', 'D')
	self.m_InvCol3 = Guid('E05D532C-9CB2-11E0-A4B6-91A00ABC2528', 'D')

	self.m_InvCol4 = Guid('A75DADEA-BDC6-11E0-A4AD-D5BD8D209D9C', 'D')
	self.m_InvCol5 = Guid('743B1FF7-FCBE-41BD-B343-491C9A66BBA5', 'D')
	self.m_InvCol6 = Guid('1023699D-F571-4D7B-8CDF-2290541F8BBC', 'D')
	self.m_InvCol7 = Guid('D4650FCF-C9A5-11E0-928D-951B45190C6C', 'D')
	
	self.m_InvCol8 = Guid('1034FDAE-C9A4-11E0-928D-951B45190C6C', 'D')
	self.m_InvCol9 = Guid('21F3012F-C9A6-11E0-928D-951B45190C6C', 'D')
	self.m_InvCol10 = Guid('4B03F97E-C9A6-11E0-928D-951B45190C6C', 'D')
	self.m_InvCol11 = Guid('5658121F-C9A7-11E0-928D-951B45190C6C', 'D')
	self.m_InvCol12 = Guid('3F0FE56F-C9A7-11E0-928D-951B45190C6C', 'D')
	self.m_InvCol13 = Guid('25D585AF-C9A7-11E0-928D-951B45190C6C', 'D')

	self.emptyRefModel = StaticModelEntityData();

	self.m_m60ffd = Guid('1D44B441-7F16-46F3-9EFF-D0647D554EFE', 'D')
	self.m_mavpd = Guid('70BC2F3E-DCA5-4EDB-B6A4-0264B439556C', 'D')
	self.m_t90bp = Guid('60106975-DD7D-11DD-A030-B04E425BA11E', 'D')
	self.m_mortarmed = Guid('145C4108-7660-1329-4599-4402DA4801A0', 'D')
	self.g_c4pd = Guid('AA3BA4F5-2F8E-65FD-016A-D1E6F8C870FB', 'D')
	self.g_c4p = Guid('EB580047-B567-F95A-5057-BD42B132B8E4', 'D')
	
	self.m_c4p = nil
	self.m_c4pd = nil
	self.m_m60 = nil
	self.m_mav = nil
	self.m_t90 = nil
	self.m_mortar = nil
	self.modified = true

	self.g_nuke = Guid('64AA8847-BB88-171F-1DA8-7CC3825E0D63', 'D')
	self.g_c4effect = Guid('F88F469B-E075-4770-AC03-42D9320CF000', 'D')
	self.g_reg = Guid('EEBC7D5F-B8BA-A2C8-7C14-CE53212537EE', 'D')
	self.reg = nil

	self.g_machete1 = Guid('F88F2307-EFC4-9FD8-C8F1-0C3F9CDA46B3', 'D') --EntityRegistry
	self.g_machete2 = Guid('40A84898-626F-4976-9D6A-CF8158C68C68', 'D') --AssetRegistry
	self.g_machete3 = Guid('1D83D193-C17A-3906-8A26-81037E0AE6C7', 'D') --BlueprintRegistry
	self.g_acb = Guid('8FE660AE-141C-48BD-A919-4BCDE998FE60', 'D')
	self.machete1 = nil
	self.machete2 = nil
	self.machete3 = nil
	self.acb = nil
	

	self.nuke = nil
	self.c4effect = nil

	self.isnuke = false
	self.ismachete = false


	self.g_health1 = Guid('8FD9D09B-9D63-07C3-FE8A-F677F421C51C', 'D')
	self.g_health0 = Guid('2AF36364-9F4B-41CF-9665-A544AB767DB4', 'D')
	self.health1 = nil 
	self.health0 = nil 

end



function SharedPatches:OnLoadResources(p_Dedicated)
	print("Loading level resources!")
	--SharedUtils:MountSuperBundle('SpChunks')
	--SharedUtils:MountSuperBundle('levels/sp_paris/sp_paris')
	-- SharedUtils:PrecacheBundle("levels/sp_paris/sp_paris")
	-- SharedUtils:PrecacheBundle("levels/sp_paris/chase")
	-- SharedUtils:PrecacheBundle("levels/sp_paris/loweroffice")
	 --SharedUtils:PrecacheBundle("levels/sp_paris/loweroffice_pc")


end

function SharedPatches:OnLoadBundle(p_Hook, p_Bundle)
	print(string.format("Loading bundle '%s'", p_Bundle))

	local s_Name = p_Bundle:lower()
	return p_Hook:CallOriginal(p_Bundle)
end

function SharedPatches:RegisterEvents()
	print("Registering events")
	Events:Subscribe('Level:LoadResources', self, self.OnLoadResources)
	self.m_ReadInstanceEvent = Events:Subscribe('Partition:ReadInstance', self, self.ReadInstance)
	Hooks:Install('ResourceManager:LoadBundle', self, self.OnLoadBundle)
end

function SharedPatches:InitComponents()
	self.m_FlightCeiling = FlightCeiling()
end


function SharedPatches:ReadInstance(p_Instance, p_Guid)
	--self.m_Finder:OnReadInstance(p_Instance, p_Guid)


	if p_Instance == nil then
		return 
	end


	if p_Instance.typeName == "MaterialRelationTerrainDestructionData" then
		local s_Instance = MaterialRelationTerrainDestructionData(p_Instance)
		s_Instance.depth = 255
		--s_Instance.width = 255
	end
	if p_Instance.typeName == "BangerEntityData" then
		local s_Instance = BangerEntityData(p_Instance)
		s_Instance.timeToLive = 20000
	end

	if p_Instance.typeName == "ObjectBlueprint" then
		local s_Instance = ObjectBlueprint(p_Instance)
		if string.match(s_Instance.name:lower(), "invisible") then
			print("Removed " .. s_Instance.name)
			s_Instance.object = nil
		end
	end


	if p_Guid == Guid('8B71D173-8518-11E0-BB7A-DDA550615CAF', 'D') or
		p_Guid == Guid('C2E7889C-9CB2-11E0-A4B6-91A00ABC2528', 'D') or
		p_Guid == Guid('E05D532C-9CB2-11E0-A4B6-91A00ABC2528', 'D') or
		p_Guid == Guid('A75DADEA-BDC6-11E0-A4AD-D5BD8D209D9C', 'D') or
		p_Guid == Guid('743B1FF7-FCBE-41BD-B343-491C9A66BBA5', 'D') or
		p_Guid == Guid('1023699D-F571-4D7B-8CDF-2290541F8BBC', 'D') or
		p_Guid == Guid('D4650FCF-C9A5-11E0-928D-951B45190C6C', 'D') or
		p_Guid == Guid('1034FDAE-C9A4-11E0-928D-951B45190C6C', 'D') or
		p_Guid == Guid('21F3012F-C9A6-11E0-928D-951B45190C6C', 'D') or
		p_Guid == Guid('4B03F97E-C9A6-11E0-928D-951B45190C6C', 'D') or
		p_Guid == Guid('1034FDAE-C9A4-11E0-928D-951B45190C6C', 'D') or
		p_Guid == Guid('5658121F-C9A7-11E0-928D-951B45190C6C', 'D') or
		p_Guid == Guid('3F0FE56F-C9A7-11E0-928D-951B45190C6C', 'D') or
		p_Guid == Guid('25D585AF-C9A7-11E0-928D-951B45190C6C', 'D') then
			local s_Instance = StaticModelEntityData(p_Instance)
			s_Instance.enabled = false
			print("Disabled " .. tostring(p_Guid))
	end

	if p_Guid == Guid('C707F8FE-C1CE-4AFE-809A-A8096FBF21BD', 'D') then
		local s_Instance = PhysicsEntityData(p_Instance)
		s_Instance:ClearScaledAssets()
		s_Instance:ClearRigidBodies()
	end


	if p_Instance.typeName == "PhysicsEntityData" then
	--	local s_Instance = PhysicsEntityData(p_Instance)
	--	local havok = HavokAsset(s_Instance.GetScaledAssetsAt(1))
	--	if string.match(havok.name:lower(), "invisible") or string.match(havok.name:lower(), "collision") then
		--	s_Instance:ClearScaledAssets()
		--	s_Instance:ClearRigidBodies()
		--	print("Cleared collision")
	--	end
	end




	


	if p_Instance.typeName == "VehicleEntityData" then
		local s_Instance = VehicleEntityData(p_Instance)
		s_Instance.explosionPacksAttachable = true
	end
	if p_Instance.typeName == "SupplySphereEntityData" then
		local s_Instance = SupplySphereEntityData(p_Instance)
		s_Instance.maxAttachableInclination = 360
	end

	if p_Guid == self.g_health1 then
		self.health1 = HealthStateData(p_Instance)
		self.health1.partIndex = 1
		self.health1.physicsEnabled = false
	end
	if p_Guid == self.g_health0 then
		print("Found health0")
		self.health0 = HealthStateData(p_Instance)
		self.health0.partIndex = 2
		self.health0.physicsEnabled = false
	end

	if self.health0 ~= nil then
		if p_Instance.typeName == "PartComponentData" then
			local s_Instance = PartComponentData(p_Instance)
			--print("Added health0")
			--s_Instance.AddHealthStates(self.health1)
		--	s_Instance:ClearHealthStates()
		--	s_Instance:AddHealthStates(self.health1)
		--	s_Instance:AddHealthStates(self.health0)
		---	s_Instance.isFragile = true

		end
	end
	--nuke thing


	if p_Guid == self.g_reg then
		--self.reg = RegistryContainer(p_Instance)

		print("found reg")
		--self.reg:AddEntityRegistry(self.machete1)
		--self.reg:AddAssetRegistry(self.machete2)
		--self.reg:AddBlueprintRegistry(self.machete3)

		print("making ")
	--	local acb = SoldierWeaponBlueprint(self.acb)
	--	local machete = SoldierWeaponBlueprint(self.machete3)
	--	acb.object = SoldierWeaponData(machete.object)
		print("maked")

		self.ismachete = true
	end

	if p_Guid == self.g_machete1 then
		print("Found machete1")
		self.machete1 = p_Instance
	end
	if p_Guid == self.g_machete2 then
		print("Found machete2")
		self.machete2 = p_Instance
		
	end
	if p_Guid == self.g_machete3 then
		print("Found machete3")
		self.machete3 = p_Instance
	end

	if p_Guid == self.g_acb then
		self.acb = p_Instance
		
	end

	if p_Guid == self.g_nuke then
		print("Found Nuke!!!!!!!!!!")
		self.nuke = p_Instance
	end
	if p_Guid == self.g_c4effect then
		print("Found c4")
		self.c4effect = VeniceExplosionEntityData(p_Instance)
	end

	if self.c4effect ~= nil and self.nuke ~= nil and self.isnuke == false and self.reg ~= nil then
		print("Setting c4 to nuke")
		self.reg:AddBlueprintRegistry(self.nuke)
		self.c4effect.detonationEffect = EffectBlueprint(self.nuke)
		self.isnuke = true
	end


	if p_Instance.typeName == "LevelData" then
		local s_Instance = LevelData(p_Instance)
		local s_maxVehicleHeight = s_Instance.maxVehicleHeight
		s_vh = 100000000
	end
	if p_Instance.typeName == "VehicleEntityData" then
		local s_Instance = VehicleEntityData(p_Instance)
		local s_highAltitudeLockHeight = s_Instance.highAltitudeLockHeight
		s_highAltitudeLockHeight = 100000000
	end








	if p_Guid ==  Guid('9C51D42E-94F9-424A-89D2-CBBCA32F1BCE', 'D') then
		local s_Instance = EntityInteractionComponentData(p_Instance)
	--	s_Instance.allowInteractionWithSoldiers = true
		--s_Instance.onlyAllowInteractionWithManDownSoldiers = false

	end



	if p_Instance.typeName == "VeniceSoldierHealthModuleData" then
		local s_Instance = VeniceSoldierHealthModuleData(p_Instance)
		--s_Instance.interactiveManDown = true
		--s_Instance.immortalTimeAfterSpawn = 0
	end


	if p_Instance.typeName == 'VehicleEntityData' then
		local s_Instance = VehicleEntityData(p_Instance)

		local s_Chassis = ChassisComponentData(s_Instance:GetComponentsAt(0))
		--s_Chassis.transform = LinearTransform(
	--	 Vec3(0.5, 0, 0),
	--	 Vec3(0, 0.5, 0),
	--	 Vec3(0, 0, 0.5),
	--	 Vec3(0,0,0))
		
		local s_Physics = PhysicsEntityData(s_Instance.physicsData)
		local s_Scaled = s_Physics.scaledAssets
		local s_Havok = HavokAsset(s_Physics:GetScaledAssetsAt(0))
		if s_Havok == nil then
			return
		end
		--print(tostring(s_Havok.scale))
	--	s_Havok.scale = 0.2
		


	end


	if p_Instance.typeName == "HealthStateData" then 
		local s_Instance = HealthStateData(p_Instance)
		s_Instance.canSupportOtherParts = true

	end

	if p_Instance.typeName == "EnlightenRuntimeSettings" then 
		local s_Instance = EnlightenRuntimeSettings(p_Instance)
		s_Instance.drawDebugEntities = true
		s_Instance.drawDebugSystemsEnable = true
		s_Instance.drawDebugLightProbes = true
		s_Instance.drawDebugLightProbeOcclusion = true
		s_Instance.drawDebugLightProbeStats = true
		s_Instance.drawDebugLightProbeBoundingBoxes = true
		s_Instance.drawDebugColoringEnable = true
		s_Instance.drawDebugTextures = true
		s_Instance.drawDebugBackFaces = true
		s_Instance.drawDebugBackFaces = true
	end

	if p_Instance.typeName == "DxDisplaySettings" then 
		local s_Instance = DxDisplaySettings(p_Instance)
		s_Instance.debugInfoEnable = true
		s_Instance.debugBreakOnErrorEnable = true
		s_Instance.debugBreakOnWarningEnable = true
		s_Instance.debugBreakOnInfoEnable = true
		s_Instance.drawDebugLightProbeStats = true
		s_Instance.drawDebugLightProbeBoundingBoxes = true
		s_Instance.drawDebugColoringEnable = true
		s_Instance.drawDebugTextures = true
		s_Instance.drawDebugBackFaces = true
		s_Instance.drawDebugBackFaces = true
	end

	if p_Instance.typeName == "PrintDebugTextEntityData" then 
		local s_Instance = PrintDebugTextEntityData(p_Instance)
		s_Instance.enabled = true
	end

	if p_Instance.typeName == "ClientSettings" then 
		local s_Instance = ClientSettings(p_Instance)
		s_Instance.debugMenuOnLThumb = true
	end
	
	if p_Instance.typeName == "ModelAnimationEntityData" then 
		local s_Instance = ModelAnimationEntityData(p_Instance)
		s_Instance.showDebugTransforms = true
	end

	
	if p_Instance.typeName == "UnlockAsset" then 
		local s_Instance = UnlockAsset(p_Instance)
		s_Instance.autoAvailable = true
	end
end

function SharedPatches:OnLoaded()
	self.m_FlightCeiling:OnLoaded()

end



return SharedPatches