class 'CustomVehicleShared'


function CustomVehicleShared:__init()
	print("Initializing CustomVehicleShared")
	self:RegisterVars()
	self:RegisterEvents()
end


function CustomVehicleShared:RegisterVars()

end


function CustomVehicleShared:RegisterEvents()
	self.m_PartitionLoadedEvent = Events:Subscribe('Partition:Loaded', self, self.OnPartitionLoaded)
   	Events:Subscribe('Engine:Message', self, self.OnEngineMessage)
end

function CustomVehicleShared:OnEngineMessage(p_Message)
	if p_Message.type == MessageType.ClientLevelFinalizedMessage or p_Message.type == MessageType.ServerLevelLoadedMessage then
		self:OnModify()
	end
end

function CustomVehicleShared:OnModify()
	print("OnModify")
	for k,v in ipairs(self.m_Instances) do
		local s_Instance = _G[v.instance.typeInfo.name](v.instance:Clone(v.instance.instanceGuid))
		if(s_Instance.typeInfo.name == "WeaponComponentData") then
			--s_Instance.reloadTimeMultiplier = 100
		end

		if(s_Instance.typeInfo.name == "FiringFunctionData") then
			s_Instance.fireLogic.reloadTime = 10
			s_Instance.fireLogic.reloadTimeBulletsLeft = 10
		end
		v.partition:ReplaceInstance(v.instance, s_Instance, true)
	end
end


function CustomVehicleShared:OnPartitionLoaded(p_Partition)
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
		if(l_Instance.instanceGuid == Guid("SomeGuid")) then
			local s_Instance = SomeType(l_Instance:Clone(l_Instance.instanceGuid))
			s_Instance.someThing = 1
			p_Partition:ReplaceInstance(l_Instance, s_Instance, true)
		end
	end
end


g_CustomVehicleShared = CustomVehicleShared()

