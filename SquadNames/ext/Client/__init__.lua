class 'SquadNamesClient'


function SquadNamesClient:__init()
	print("Initializing SquadNamesClient")
	self:RegisterVars()
	self:RegisterEvents()
end


function SquadNamesClient:RegisterVars()
	--self.m_this = that
end


function SquadNamesClient:RegisterEvents()
	self.m_ReadInstanceEvent = Events:Subscribe('Partition:ReadInstance', self, self.ReadInstance)
end


function SquadNamesClient:ReadInstance(p_Instance,p_PartitionGuid, p_Guid)
	if p_Instance == nil then
		return
	end
	
	if p_Guid == Guid("538F9596-5BED-84BC-92E6-99595A9A69E5", "D") then
		local s_Instance = UISquadCompData(p_Instance)

	end
end


g_SquadNamesClient = SquadNamesClient()

