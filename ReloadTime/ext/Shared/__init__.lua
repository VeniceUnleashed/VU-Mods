class 'ReloadTimeShared'


function ReloadTimeShared:__init()
	print("Initializing ReloadTimeShared")
	self:RegisterVars()
	self:RegisterEvents()
end


function ReloadTimeShared:RegisterVars()
	self.m_Instances = {}
end


function ReloadTimeShared:RegisterEvents()
	Events:Subscribe('Partition:Loaded', self, self.OnPartitionLoaded)
	Events:Subscribe('Level:Destroy', self, self.RegisterVars)
   	Events:Subscribe('Engine:Message', self, self.OnEngineMessage)
end


function ReloadTimeShared:OnPartitionLoaded(p_Partition)
	if p_Partition == nil then
		return
	end
	
	local s_Instances = p_Partition.instances


	for _, l_Instance in ipairs(s_Instances) do
		if l_Instance == nil then
			print('Instance is null?')
			break
		end
		if(l_Instance.typeInfo.name == "WeaponComponentData") then
			table.insert(self.m_Instances, {instance = l_Instance, partition = p_Partition})
		end
		if(l_Instance.typeInfo.name == "FiringFunctionData") then
			table.insert(self.m_Instances, {instance = l_Instance, partition = p_Partition})
		end

	end
end

function ReloadTimeShared:OnEngineMessage(p_Message)
	if p_Message.type == MessageType.ClientLevelFinalizedMessage or p_Message.type == MessageType.ServerLevelLoadedMessage then
		self:OnModify()
	end
end

function ReloadTimeShared:OnModify()
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


g_ReloadTimeShared = ReloadTimeShared()

