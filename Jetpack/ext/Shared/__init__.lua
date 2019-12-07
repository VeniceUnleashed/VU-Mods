class 'JetpackShared'


function JetpackShared:__init()
	print("Initializing JetpackShared")
	self:RegisterVars()
	self:RegisterEvents()
end


function JetpackShared:RegisterVars()
	self.m_JetEngine = VehicleComponentData()
	self.m_EntryComponent = nil
	self.m_Soldier = nil
	self.m_Partiton = nil
end


function JetpackShared:RegisterEvents()
	self.m_PartitionLoadedEvent = Events:Subscribe('Partition:Loaded', self, self.OnPartitionLoaded)
    self.m_Whatever = Hooks:Install('ClientEntityFactory:Create',999, self, self.OnEntityCreate)
    self.m_Whatever = Hooks:Install('ServerEntityFactory:Create',999, self, self.OnEntityCreate)
end


function JetpackShared:OnPartitionLoaded(p_Partition)
	if p_Partition == nil then
		return
	end
	
	local s_Instances = p_Partition.instances


	for _, l_Instance in ipairs(s_Instances) do
		if l_Instance == nil then
			print('Instance is null?')
			break
		end
		if(l_Instance.typeInfo.name == "SomeType") then
			local s_Instance = SomeType(l_Instance:Clone(l_Instance.instanceGuid))
			s_Instance.someThing = 1
			p_Partition:ReplaceInstance(l_Instance, s_Instance, true)
		end

		if(l_Instance.typeInfo.name == "HavokAsset") then
			local s_Instance = HavokAsset(l_Instance:Clone(l_Instance.instanceGuid))
			--s_Instance.scale = 5
			p_Partition:ReplaceInstance(l_Instance, s_Instance, true)
		end

	end
end

function JetpackShared:AddEngine()
	--s_Body.components:set(7, self.m_EntryComponent)
	self.m_Soldier.components:set(1,self.m_JetEngine)
	print("Added engine")

end

function JetpackShared:OnEntityCreate(p_Hook, p_Data, p_Transform)
	if p_Data == nil then
		print("Didnt get no data")
	else
		if(p_Data.typeInfo.name == "SoldierWeaponData") then
		end
		if(p_Data.typeInfo.name == "KitPickupEntityData") then
			local s_Instance = KitPickupEntityData(p_Data)
			s_Instance.removeWeaponOnDrop = true
			s_Instance.keepAdditionalWeapons = false
			s_Instance.keepAmmoState = false
			print("fuck")
			local x = p_Hook:Call(s_Instance)
			return
		end
		local x = p_Hook:Call(p_Data)

		print("data :  " .. p_Data.typeInfo.name)
		print("entity: " ..x.typeName)
		print(tostring(p_Data.instanceGuid))
	end	 
end

g_JetpackShared = JetpackShared()

