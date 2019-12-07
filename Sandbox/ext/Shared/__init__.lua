class 'SandboxShared'


function SandboxShared:__init()
	print("Initializing SandboxShared")
	self:RegisterVars()
	self:RegisterEvents()
end


function SandboxShared:RegisterVars()
	--local m_this = that
end


function SandboxShared:RegisterEvents()
	self.m_ReadInstanceEvent = Events:Subscribe('Partition:ReadInstance', self, self.ReadInstance)
	self.m_LoadResourcesEvent = Events:Subscribe('Level:LoadResources', self, self.OnLoadResources)
	self.m_LoadBundleHook = Hooks:Install('ResourceManager:LoadBundle', 99, self, self.OnLoadBundle)
end
	


function SandboxShared:OnLoadBundle(p_Hook, p_Bundle)
	print(string.format("Loading bundle '%s'", p_Bundle))

  


end

function SandboxShared:OnLoadResources(p_Dedicated)
	print("Loading level resources!")
	--SharedUtils:MountSuperBundle('SpChunks')
	--SharedUtils:PrecacheBundle('levels/mp_012/mp_012_uiloadingsp')
	--SharedUtils:PrecacheBundle('levels/mp_012/tutorialmp')
	--SharedUtils:PrecacheBundle('levels/mp_012/tutorialmp_sandbox')
	--SharedUtils:PrecacheBundle('levels/mp_012/tutorialmp_shoothouse')
	--SharedUtils:PrecacheBundle('levels/mp_012/mp_012_gameconfiglight_win32')
	self.tutorialmp = nil
	self.m_Enable = true
end

function SandboxShared:ReadInstance(p_Instance, p_PartitionGuidp, p_Guid)
	if p_Instance == nil then
		return
	end
	if p_Guid == Guid('B8076525-768F-11E2-BEA4-BBB97FE088CE','D') then
		local s_Instance = SubWorldInclusionSetting (p_Instance)
		s_Instance:ClearEnabledOptions()
		s_Instance:AddEnabledOptions("ConquestLarge0")
	end

	if p_Guid == Guid('AD413546-DEAF-8115-B89C-D666E801C67A','D') then
		local s_Instance = GameModeSettings(p_Instance):GetInformationAt(1)
		print("facking found it ya cunt")
		 local s_Count = s_Instance:GetSizesCount()

		if s_Count == 0 then
		return
		end

		s_Count = s_Count - 1
		for i=s_Count,0,-1 do 
			local s_Member = s_Instance:GetSizesAt(i)
			s_Member.playerCount = 128

			local s_Count2 = s_Member:GetTeamsCount()

			if s_Count2 == 0 then
			return
			end

			s_Count2 = s_Count2 - 1
			for i2=s_Count2,0,-1 do 
				local s_Teams = s_Member:GetTeamsAt(i2)
				s_Teams.squadSize = 20
				s_Teams.playerCount = 64
			end
		end
	end
end


g_SandboxShared = SandboxShared()

return SandboxShared
