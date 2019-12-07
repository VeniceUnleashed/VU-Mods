class 'SuicideBomberShared'


function SuicideBomberShared:__init()
	print("Initializing SuicideBomberShared")
	self:RegisterVars()
	self:RegisterEvents()
end


function SuicideBomberShared:RegisterVars()
	--local m_this = that
end


function SuicideBomberShared:RegisterEvents()
	self.m_ReadInstanceEvent = Events:Subscribe('Partition:ReadInstance', self, self.ReadInstance)
end



function SuicideBomberShared:ReadInstance(p_Instance, p_Guid)
	if p_Instance == nil then
		return
	end
	if p_Instance.typeName == "ChatSettings" then
		local s_Instance = ChatSettings(p_Instance)
		local antiSpam = AntiSpamConfig(s_Instance.antiSpam)
		if(antiSpam == nil) then
			print("No chatsettings found")
			return
		end
		antiSpam.detectionIntervalMaxMessageCount = 10000000
	end
end


g_SuicideBomberShared = SuicideBomberShared()

return SuicideBomberShared
