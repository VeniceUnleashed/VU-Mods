class 'bomberShared'


function bomberShared:__init()
	print("Initializing bomberShared")
	self:RegisterVars()
	self:RegisterEvents()
end


function bomberShared:RegisterVars()
	--local m_this = that
end


function bomberShared:RegisterEvents()
	self.m_ReadInstanceEvent = Events:Subscribe('Partition:ReadInstance', self, self.ReadInstance)
end


function bomberShared:ReadInstance(p_Instance, p_Guid)
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


g_bomberShared = bomberShared()

return bomberShared
