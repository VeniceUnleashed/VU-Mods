class 'DynamicLightsClient'


function DynamicLightsClient:__init()
	print("Initializing DynamicLightsClient")
	self:RegisterVars()
	self:RegisterEvents()
end


function DynamicLightsClient:RegisterVars()
	--self.m_this = that
end


function DynamicLightsClient:RegisterEvents()
	self.m_ReadInstanceEvent = Events:Subscribe('Partition:ReadInstance', self, self.ReadInstance)
end


function DynamicLightsClient:ReadInstance(p_Instance,p_PartitionGuid, p_Guid)
	if p_Instance == nil then
		return
	end
	
	if p_Instance.typeName == "SpotLightEntityData" then
		local s_Instance = SpotLightEntityData(p_Instance)
		s_Instance.castShadowsEnable = true
	end
	if p_Instance.typeName == "LocalLightEntityData" then
		local s_Instance = LocalLightEntityData(p_Instance)
		s_Instance.visible = true
		s_Instance.enlightenEnable = true
	end
	if p_Instance.typeName == "EmitterTemplateData" then
		local s_Instance = EmitterTemplateData(p_Instance)
		if(string.match(s_Instance.name:lower(), "smoke")) then
			if s_Instance.rootProcessor.typeName == "UpdateAgeData" then
				local s_AgeData = UpdateAgeData(s_Instance.rootProcessor)
				--s_AgeData.lifetime = s_AgeData.lifetime * 2 
			end
		end
		s_Instance.pointLightRandomIntensityMax  = 10
		s_Instance.timeScale = 0.7 
	end
	--[[
	if p_Instance.typeName == "UpdateAgeData" then
		local s_Instance = UpdateAgeData(p_Instance)
		s_Instance.lifetime = s_Instance.lifetime * 10
		s_Instance.timeScale = 0.7 
	end
]]

	 
end


g_DynamicLightsClient = DynamicLightsClient()

