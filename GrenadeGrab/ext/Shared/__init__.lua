class 'GrenadeGrabShared'


function GrenadeGrabShared:__init()
	print("Initializing GrenadeGrabShared")
	self:RegisterVars()
	self:RegisterEvents()
end


function GrenadeGrabShared:RegisterVars()
	self.m_ProjectileBlueprint = nil
	self.m_Interaction = nil
end


function GrenadeGrabShared:RegisterEvents()
	self.m_PartitionLoadedEvent = Events:Subscribe('Partition:Loaded', self, self.OnPartitionLoaded)
	Hooks:Install('ServerEntityFactory:CreateFromBlueprint', 999, self, self.OnBlueprintCreate)
	Hooks:Install('ClientEntityFactory:CreateFromBlueprint', 999, self, self.OnBlueprintCreate)
end

function GrenadeGrabShared:OnBlueprintCreate( p_Hook, p_Blueprint, p_Transform, p_Variation, p_Parent)
	if(p_Blueprint.typeInfo.name == "ProjectileBlueprint") then
		local s_Blueprint = _G[p_Blueprint.typeInfo.name](p_Blueprint)


	end
end

function GrenadeGrabShared:CreateData()
	local s_Data = EntityInteractionComponentData(Guid('19d6d8ac-7ef0-4557-99ed-0c25d7174426'))
	s_Data.isEventConnectionTarget = 3
	s_Data.isPropertyConnectionTarget = 3
	s_Data.indexInBlueprint = 1

	s_Data.transform = LinearTransform()

	s_Data.pickupRadius = 3.0
    s_Data.maxAmmoPickupTimer = 0.5
    s_Data.maxAmmoCrateTimer = 0.5
    s_Data.allowInteractionWithSoldiers = false
    s_Data.onlyAllowInteractionWithManDownSoldiers = true
    s_Data.soldierInteractRadius = 3.0
    s_Data.maxLookAtAngle = 20.0
    s_Data.soldierInteractInputAction = EntryInputActionEnum.EIAInteract
    s_Data.interactWithTypes = InteractionTypesData()
    s_Data.interactWithTypes.interactionEntity = true
    s_Data.interactWithTypes.pickupEntity = true
    s_Data.interactWithTypes.ammoCrateEntity = true
    s_Data.interactWithTypes.vehicleEntity = true
    s_Data.interactWithTypes.explosionPackEntity = true
    s_Data.interactWithTypes.soldierEntity = true

	return s_Data
end

function GrenadeGrabShared:OnPartitionLoaded(p_Partition)
	if p_Partition == nil then
		return
	end
	
	local s_Instances = p_Partition.instances


	for _, l_Instance in ipairs(s_Instances) do
		if l_Instance == nil then
			print('Instance is null?')
			break
		end
		if(l_Instance.instanceGuid == Guid('F39ED0C9-6A18-C1AE-1363-7F14B4A0F95A')) then
			local s_Blueprint = ProjectileBlueprint(l_Instance)
			if s_Blueprint.name == "Weapons/M67/M67_Projectile" then
				if s_Blueprint.isReadOnly then
					print("Read only")
				end

				local s_Object = _G[s_Blueprint.object.typeInfo.name](s_Blueprint.object)
				if s_Object.isReadOnly then
					print("Read only")
					s_Object:MakeWritable()
				end

				local s_Interaction = self:CreateData()
				s_Object.components:add(s_Interaction)
				s_Object.runtimeComponentCount = 1 
				s_Object.initialSpeed = 100
				s_Object.timeToLive = 20 
				p_Partition:AddInstance(s_Interaction)
			end
		end
	end
end


g_GrenadeGrabShared = GrenadeGrabShared()

