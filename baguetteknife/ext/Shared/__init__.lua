class 'baguetteknifeShared'


function baguetteknifeShared:__init()
	print("Initializing baguetteknifeShared")
	self:RegisterVars()
	self:RegisterEvents()
end


function baguetteknifeShared:RegisterVars()
	self.compartment = nil
	self.loadHandle = nil
	self.loaded = false
end


function baguetteknifeShared:RegisterEvents()
	Hooks:Install('ResourceManager:LoadBundles',999, self, self.OnLoadBundles)
	Events:Subscribe('Partition:Loaded', self, self.OnPartitionLoaded)
	Events:Subscribe('Engine:Update', self, self.OnEngineUpdate)
	Events:Subscribe('Level:LoadResources', self, self.OnLoadResources)
end

function baguetteknifeShared:OnLoadResources( p_Dedicated )
    if SharedUtils:IsServerModule() then
        self.compartment = ResourceManager:AllocateDynamicCompartment('BundleCrash', ResourceCompartment.ResourceCompartment_Game, false)
    else
        self.compartment = ResourceManager:AllocateDynamicCompartment('BundleCrash', ResourceCompartment.ResourceCompartment_Game, true)
    end
    print('Created compartment: ' .. tostring(self.compartment))
end


function baguetteknifeShared:OnLoadBundles(p_Hook, p_Bundles, p_Compartment)
	print(p_Bundles)
	print(p_Compartment)
	if(p_Bundles[1] == "Levels/XP2_Skybar/TeamDM") then

		self.loadHandle = ResourceManager:BeginLoadData(self.compartment, {
	        'levels/sp_paris/parkingdeck',
	    })
	end

	if(p_Bundles[1] == "gameconfigurations/game" or p_Bundles[1] == "UI/Flow/Bundle/LoadingBundleMp") then
		Events:Dispatch('BundleMounter:LoadBundle', 'levels/sp_paris/sp_paris', {
			'levels/sp_paris/sp_paris',
			'levels/sp_paris/heat_pc_only',
			'levels/sp_paris/chase'
		})
		print("Sent!")
		
	end
end


function baguetteknifeShared:OnEngineUpdate(delta, simDelta)
    if self.loadHandle == nil and self.clearHandle == nil then
        return
    end
   
    if self.loadHandle ~= nil and ResourceManager:PollBundleOperation(self.loadHandle) then
        if not ResourceManager:EndLoadData(self.loadHandle) then
            print('Bundles failed to load')
            self.loadHandle = nil
            return
        end
 
        print('Bundles successfully loaded')
        self.loadHandle = nil
        self.loaded = true
    elseif self.clearHandle ~= nil and ResourceManager:PollBundleOperation(self.clearHandle) then
        self:Cleanup()
    end
end


function baguetteknifeShared:OnPartitionLoaded(p_Partition)
	if p_Partition == nil then
		return
	end
	
	local s_Instances = p_Partition.instances


	for _, l_Instance in ipairs(s_Instances) do
		if l_Instance == nil then
			print('Instance is null?')
			break
		end
		if(l_Instance.typeInfo.name == "StaticUnlockList") then
			local s_Instance = StaticUnlockList(l_Instance)
			s_Instance:MakeWritable()
			for k,v in pairs(s_Instance.unlockInfos) do
				v.licenses:clear()
			end
		end
	end
end


g_baguetteknifeShared = baguetteknifeShared()

