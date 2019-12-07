class 'WebUITexturesClient'


function WebUITexturesClient:__init()
	print("Initializing WebUITexturesClient")
	self:RegisterVars()
	self:RegisterEvents()
end


function WebUITexturesClient:RegisterVars()
	--self.m_this = that
end


function WebUITexturesClient:RegisterEvents()
	self.m_ReadInstanceEvent = Events:Subscribe('Partition:ReadInstance', self, self.ReadInstance)
end


function WebUITexturesClient:ReadInstance(p_Instance,p_PartitionGuid, p_Guid)
	if p_Instance == nil then
		return
	end
	
	if p_Instance.typeName == "TextureAsset" then
		local s_Instance = TextureAsset(p_Instance)
		print(s_Instance.name)
	end
end


g_WebUITexturesClient = WebUITexturesClient()

