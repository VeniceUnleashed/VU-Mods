class 'CrossTalkShared'


function CrossTalkShared:__init()
	print("Initializing CrossTalkShared")
	self:RegisterVars()
	self:RegisterEvents()
end


function CrossTalkShared:RegisterVars()
	--self.m_this = that
end


function CrossTalkShared:RegisterEvents()
	self.m_ReadInstanceEvent = Events:Subscribe('Partition:ReadInstance', self, self.ReadInstance)
end


function CrossTalkShared:ReadInstance(p_Instance,p_PartitionGuid, p_Guid)
	if p_Instance == nil then
		return
	end
	
	if p_Instance.typeName == "LevelData" then
		print("Sending message")
		Events:Dispatch('CrossTalk:LevelData', "Hello from the other siiiiideeee")
	end
end


g_CrossTalkShared = CrossTalkShared()

