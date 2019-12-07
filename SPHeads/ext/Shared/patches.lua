class 'SPHeadsShared'


function SPHeadsShared:__init()
	print("Initializing SPHeadsShared")
	self:RegisterVars()
	self:RegisterEvents()
end


function SPHeadsShared:RegisterVars()
	self.levelName = "Levels/MP_001/MP_001"
	self.head = {}
	self.unlockAsset = {}
	self.registryContainer = {}
	self.meshVariationDatabase = {}
	self.meshVariationDatabaseEntry = {}
	self.skinnedMeshAsset = {}
end


function SPHeadsShared:RegisterEvents()
	self.m_ReadInstanceEvent = Events:Subscribe('Partition:ReadInstance', self, self.ReadInstance)
	Hooks:Install('ResourceManager:LoadBundle', self, self.OnLoadBundle)
	Events:Subscribe('Level:LoadResources', self, self.OnLoadResources)
	self.m_EngineMessageEvent = Events:Subscribe('Engine:Message', self, self.OnEngineMessage)
end

function SPHeadsShared:OnEngineMessage(p_Message)
	if p_Message == nil then
		return
	end

	if p_Message.type == MessageType.ServerLevelLoadedMessage or p_Message.type == MessageType.ClientLevelLoadedMessage then
			self:Replace()
		return
	end
	return
end

function SPHeadsShared:ReadInstance(p_Instance, p_Guid)
	if p_Instance == nil then
		return
	end
	if p_Instance.typeName == "LevelData" then
		local s_Instance = LevelData(p_Instance)
		print("LevelData: " .. s_Instance.name)
		self.registryContainer[s_Instance.name] = RegistryContainer(s_Instance.registryContainer)
	end

	if p_Instance.typeName == "SubWorldData" then
		local s_Instance = SubWorldData(p_Instance)
		print("SubWorldData: " .. s_Instance.name)
		self.registryContainer[s_Instance.name] = RegistryContainer(s_Instance.registryContainer)
		if(string.match(s_Instance.name, "MP_001")) then
			self:AddToRegistryContainer(RegistryContainer(s_Instance.registryContainer))
		end
	end

	 
	
	if p_Instance.typeName == "MeshVariationDatabase" then
		local s_Instance = MeshVariationDatabase(p_Instance)
		if(string.match(s_Instance.name, "Weapon_ShaderStateAssets")) then
			return
		end
		print("MeshVariationDatabase: " .. s_Instance.name)
		self.meshVariationDatabase[s_Instance.name] = s_Instance
		if(string.match(s_Instance.name, "MP_001")) then
			self:AddToMeshVariationDatabase(s_Instance)
			self:CombineDB(s_Instance)
		end
	end



	if p_Instance.typeName == "MeshVariationDatabaseEntry" then
		local s_Instance = MeshVariationDatabaseEntry(p_Instance)
		table.insert(self.meshVariationDatabaseEntry, s_Instance)
		print(p_Guid:ToString('D'))
	end

	if p_Instance.typeName == "UnlockAsset" then
		local s_Instance = UnlockAsset(p_Instance)
		if(string.match(s_Instance.name, "Weapons")) then
			return
		end
		--print("UnlockAsset: " .. s_Instance.name)
		self.unlockAsset[s_Instance.name] = p_Instance
	end
	if p_Instance.typeName == "SkinnedMeshAsset" then
		table.insert(self.skinnedMeshAsset, p_Instance)
	end
	
end
function SPHeadsShared:CombineDB(s_Instance)
	for index, DB in pairs(self.meshVariationDB) do
		local s_EntryCount = DB:GetEntriesCount()
		print(tostring(s_EntryCount))	 
	    for i = 0, s_EntryCount -1, 1 do
	        local s_Node = DB:GetLinkedToAt(i)
	        s_Instance:AddLinkedTo(s_Node)   
	    end

	    local s_RedirectedCount = DB:GetRedirectEntriesCount()
		print(tostring(s_RedirectedCount))	 
	    for i = 0, s_RedirectedCount -1, 1 do
	        local s_Node = DB:GetRedirectEntriesAt(i)
	        s_Instance:AddRedirectEntries(s_Node)   
	    end
	end
end
function SPHeadsShared:AddToRegistryContainer(s_Instance)
	print("HERE WE GO BOI")
	print(self.levelName)
	for index, skinnedMeshAsset in pairs(self.skinnedMeshAsset) do
		s_Instance:AddAssetRegistry(SkinnedMeshAsset(skinnedMeshAsset))
		
		print("Added " .. SkinnedMeshAsset(skinnedMeshAsset).name)
	end
	for index, unlockAsset in pairs(self.unlockAsset) do
		s_Instance:AddAssetRegistry(UnlockAsset(unlockAsset))
		print("Added " .. UnlockAsset(unlockAsset).name)
	end
end

function SPHeadsShared:AddToMeshVariationDatabase(s_Instance)
	for index, meshVariationDatabaseEntry in pairs(self.meshVariationDatabaseEntry) do
		s_Instance:AddEntries(meshVariationDatabaseEntry)
	end
end

function SPHeadsShared:Replace()
	print("u r gay")
	local assault = UnlockAsset(self.unlockAsset['Persistence/Unlocks/Soldiers/Visual/MP/Us/MP_US_Assault_Appearance01'])
	local helmet = UnlockAsset(self.unlockAsset['Persistence/Unlocks/Soldiers/Visual/MP/Us/Headgear/MP_US_Engi_Cap01'])
	local head = UnlockAsset(self.unlockAsset['Persistence/Unlocks/Soldiers/Visual/Heads/Head04_Enemy'])
	local body = UnlockAsset(self.unlockAsset['Persistence/Unlocks/Soldiers/Visual/MP/Us/UpperBody/MP_US_Engi_UpperBody01'])
	local lower = UnlockAsset(self.unlockAsset['Persistence/Unlocks/Soldiers/Visual/MP/Us/LowerBody/MP_US_Engi_LowerBody01'])

	--assault:AddLinkedTo(helmet)
	local newHead = UnlockAsset()
	newHead:AddLinkedTo(UnlockAsset(head:GetLinkedToAt(0)))
	head.debugUnlockId = "MP_US_Assault_Head01"
	head.identifier  = 2053996672
	print("Replaced head")
	assault:RemoveLinkedToAt(1)
	assault:AddLinkedTo(newHead)
	local s_NodeCount = assault:GetLinkedToCount()
	print(tostring(s_NodeCount))
 
    for i = 0, 3, 1 do
    	print(tostring(i))
        local s_Node = assault:GetLinkedToAt(i)
        print(UnlockAsset(s_Node).name)     
    end


end

function SPHeadsShared:OnLoadResources(p_Dedicated)
	print("Loading level resources!")
	SharedUtils:MountSuperBundle('SpChunks')
	SharedUtils:MountSuperBundle('levels/sp_paris/sp_paris')
	SharedUtils:PrecacheBundle("levels/sp_paris/sp_paris")
	SharedUtils:PrecacheBundle("levels/sp_paris/corridorsluice")

	SharedUtils:MountSuperBundle('levels/sp_villa/sp_villa')
	SharedUtils:PrecacheBundle("levels/sp_villa/sp_villa")
	SharedUtils:PrecacheBundle("levels/sp_villa/basement")
	SharedUtils:PrecacheBundle("levels/sp_villa/landing")
end
function SPHeadsShared:OnLoadBundle(p_Hook, p_Bundle)
	print(string.format("Loading bundle '%s'", p_Bundle))


	local s_Name = p_Bundle:lower()
		if(string.match(s_Name, "mp_")) then
		self.loadingMP = true
	end
	return p_Hook:CallOriginal(p_Bundle)
end

g_SPHeadsShared = SPHeadsShared()

return SPHeadsShared
