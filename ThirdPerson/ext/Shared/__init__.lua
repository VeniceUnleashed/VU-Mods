class 'ThirdPersonShared'


function ThirdPersonShared:__init()
	print("Initializing ThirdPersonShared")
	self:RegisterVars()
	self:RegisterEvents()
end


function ThirdPersonShared:RegisterVars()
	--self.m_this = that
end


function ThirdPersonShared:RegisterEvents()
	self.m_ReadInstanceEvent = Events:Subscribe('Partition:ReadInstance', self, self.ReadInstance)
end


function ThirdPersonShared:ReadInstance(p_Instance,p_PartitionGuid, p_Guid)
	if p_Instance == nil then
		return
	end
	
	if p_Instance.typeName == "SomeType" then
		local s_Instance = SomeType(p_Instance)
		s_Instance.someThing = true
	end
	
	
	if p_Guid == Guid("Some-Guid", "D") then
		local s_Instance = SomeClass(p_Instance)
		s_Instance.someThing = true
	end
end


g_ThirdPersonShared = ThirdPersonShared()

