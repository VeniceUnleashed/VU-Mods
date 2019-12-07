class 'EmitterTweaksClient'


function EmitterTweaksClient:__init()
	print("Initializing EmitterTweaksClient")
	self:RegisterVars()
	self:RegisterEvents()
end


function EmitterTweaksClient:RegisterVars()
	--self.m_this = that
end


function EmitterTweaksClient:RegisterEvents()
	self.m_ReadInstanceEvent = Events:Subscribe('Partition:ReadInstance', self, self.ReadInstance)
end


function EmitterTweaksClient:ReadInstance(p_Instance,p_PartitionGuid, p_Guid)
	if p_Instance == nil then
		return
	end
	
	if p_Instance.typeName == "EmitterTemplateData" then
		local s_Instance = EmitterTemplateData(p_Instance)

	end
	
	
	if p_Guid == Guid("Some-Guid", "D") then
		local s_Instance = SomeClass(p_Instance)
		s_Instance.someThing = true
	end
end


g_EmitterTweaksClient = EmitterTweaksClient()

