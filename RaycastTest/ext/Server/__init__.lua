class 'RaycastTestServer'


function RaycastTestServer:__init()
	print("Initializing RaycastTestServer")
	self:RegisterVars()
	self:RegisterEvents()
end


function RaycastTestServer:RegisterVars()
	--local m_this = that
end


function RaycastTestServer:RegisterEvents()
	self.m_ReadInstanceEvent = Events:Subscribe('Partition:ReadInstance', self, self.ReadInstance)
end


function RaycastTestServer:ReadInstance(p_Instance, p_Guid)
	if p_Instance == nil then
		return
	end
	
	if p_Instance.typeName == "SomeType" then
		local s_Instance = SomeType(p_Instance)
		s_Instance.someThing = true
	end
	
	
	if p_Guid == Guid("WHATEVERJUSTSOMEGUIDTHATISDASHED", "D") then
		local s_Instance = SomeClass(p_Instance)
		s_Instance.someThing = true
	end
end


g_RaycastTestServer = RaycastTestServer()

return RaycastTestServer
