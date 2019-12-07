class('InstanceFinder')

function InstanceFinder:__init()
	self:Reset()
end

function InstanceFinder:ClearInstances()
	self.m_FoundInstances = {}
end

function InstanceFinder:Reset()
	self.m_Instances = {}
	self.m_ReverseInstances = {}
	self.m_FoundInstances = {}
	self.m_InstanceCallbacks = {}
	self.m_ObjectInstanceCallbacks = {}
end

function InstanceFinder:RegisterInstance(p_Name, p_InstanceGuid)
	local s_Guid = p_InstanceGuid:ToString('N')

	self.m_Instances[p_Name] = s_Guid
	self.m_ReverseInstances[s_Guid] = p_Name

	local s_Instance = EntityManager:SearchForInstanceByGUID(p_InstanceGuid)

	if s_Instance ~= nil then
		self:OnReadInstance(s_Instance, p_InstanceGuid)
	end
end

function InstanceFinder:RegisterInstance(p_Name, p_InstanceGuid, p_Callback)
	local s_Guid = p_InstanceGuid:ToString('N')

	self.m_Instances[p_Name] = s_Guid
	self.m_ReverseInstances[s_Guid] = p_Name
	self.m_InstanceCallbacks[s_Guid] = p_Callback

	local s_Instance = EntityManager:SearchForInstanceByGUID(p_InstanceGuid)

	if s_Instance ~= nil then
		self:OnReadInstance(s_Instance, p_InstanceGuid)
	end
end

function InstanceFinder:RegisterInstance(p_Name, p_InstanceGuid, p_Object, p_Callback)
	local s_Guid = p_InstanceGuid:ToString('N')
	
	self.m_Instances[p_Name] = s_Guid
	self.m_ReverseInstances[s_Guid] = p_Name
	self.m_ObjectInstanceCallbacks[s_Guid] = p_Object
	self.m_InstanceCallbacks[s_Guid] = p_Callback

	local s_Instance = EntityManager:SearchForInstanceByGUID(p_InstanceGuid)

	if s_Instance ~= nil then
		self:OnReadInstance(s_Instance, p_InstanceGuid)
	end
end

function InstanceFinder:OnReadInstance(p_Instance, p_Guid)
	if p_Instance == nil then
		return
	end

	local s_Guid = p_Guid:ToString('N')

	if self.m_ReverseInstances[s_Guid] ~= nil then
		self.m_FoundInstances[s_Guid] = p_Instance

		if self.m_InstanceCallbacks[s_Guid] ~= nil then
			if self.m_ObjectInstanceCallbacks[s_Guid] ~= nil then
				self.m_InstanceCallbacks[s_Guid](self.m_ObjectInstanceCallbacks[s_Guid], p_Instance)
			else
				self.m_InstanceCallbacks[s_Guid](p_Instance)
			end
		end
	end
end

function InstanceFinder:GetInstance(p_Name)
	if self.m_Instances[p_Name] == nil then
		return nil
	end

	return self.m_FoundInstances[self.m_Instances[p_Name]]
end

function InstanceFinder:GetInstanceByGuid(p_Guid)
	return self.m_FoundInstances[p_Guid:ToString('N')]
end

return InstanceFinder