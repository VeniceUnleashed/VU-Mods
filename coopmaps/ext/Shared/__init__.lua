class 'coopmapsShared'


function coopmapsShared:__init()
	print("Initializing coopmapsShared")
	self:RegisterVars()
	self:RegisterEvents()
end


function coopmapsShared:RegisterVars()
	self.mpsoldierBlueprint = nil
	self.mpsoldierEntity = nil
end


function coopmapsShared:RegisterEvents()
	self.m_PartitionLoadedEvent = Events:Subscribe('Partition:Loaded', self, self.OnPartitionLoaded)
	self.m_Whatever = Hooks:Install('ServerEntityFactory:Create',999, self, self.OnEntityCreate)
	self.m_LevelLoadEvent = Events:Subscribe("Level:LoadResources", self, self.OnLoadResources)
	Hooks:Install('ResourceManager:LoadBundle',999, self, self.OnLoadBundle)

end
function coopmapsShared:OnLoadBundle(p_Hook, p_Bundle)
	print(string.format("Loading bundle '%s'", p_Bundle))
end


function coopmapsShared:OnPartitionLoaded(p_Partition)
	if p_Partition == nil then
		return
	end
	
	local s_Instances = p_Partition.instances


	for _, l_Instance in ipairs(s_Instances) do
		if l_Instance == nil then
			print('Instance is null?')
			break
		end
				
		if(l_Instance.typeInfo.name == "LevelDescriptionAsset") then
			local s_Instance = LevelDescriptionAsset(l_Instance:Clone(l_Instance.instanceGuid))
			if(s_Instance.name == "Levels/Web_Loading/Web_Loading/Description_Win32") then
				return
			end
			s_Instance.description.isMultiplayer = true
	        s_Instance.description.isCoop = false
	        s_Instance.description.isMenu = false
	        --s_Instance.description.name = "ID_M_LEVELNAME_MP_SUBWAY"
	        --s_Instance.levelName = "Levels/MP_Subway/MP_Subway"

	    	--local s_Category = LevelDescriptionInclusionCategory()
			--s_Category.category = 'GameMode'
			--s_Category.mode:add('TeamDeathMatch0')

			--s_Instance.categories:add(s_Category)
		
			--s_Instance.startPoints:clear()
			p_Partition:ReplaceInstance(l_Instance, s_Instance, true)
		end
	end
end

function coopmapsShared:OnEntityCreate(p_Hook, p_Data, p_Transform)
	if p_Data == nil then
		print("Didnt get no data")
	else
		--print(p_Data.typeInfo.name)
		if(p_Data.typeInfo.name == "BreakableModelEntityData" or
			p_Data.typeInfo.name == "TeamFilterEntityData" or
			p_Data.typeInfo.name == "StaticModelGroupEntityData") then
			local s_Data = _G[p_Data.typeInfo.name]()
			--p_Hook:Return(s_Data)
		end
	end	 
end

function coopmapsShared:OnLoadResources(p_Dedicated)
	--ResourceManager:MountSuperBundle("mpchunks")
	--ResourceManager:MountSuperBundle('Levels/mp_subway/mp_subway')
	
	--ResourceManager:BeginLoadData(3, {
	--	"levels/mp_subway/mp_subway",
	--	"levels/mp_subway/teamdeathmatch"
	--})
	

end
g_coopmapsShared = coopmapsShared()

