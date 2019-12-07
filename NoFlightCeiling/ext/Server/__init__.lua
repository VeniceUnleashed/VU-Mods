class 'NoFlightCeilingServer'

local SharedPatches = require '__shared/patches'
local Inspect = require('inspect')

function NoFlightCeilingServer:__init()
	self:InitComponents()
	self:RegisterEvents()
	self:InstallHooks()
end

function NoFlightCeilingServer:RegisterEvents()
	self.m_LoadedEvent = Events:Subscribe('ExtensionLoaded', self, self.Loaded)
	self.m_EngineMessageEvent = Events:Subscribe('Engine:Message', self, self.OnEngineMessage)
end

function NoFlightCeilingServer:OnEngineMessage(p_Message)

	if p_Message == nil then
		return
	end
	if p_Message.type == MessageType.ServerEntityOnDamageMessage then
		print("ServerEntityOnDamageMessage")
	end
	if p_Message.type == MessageType.ServerSoldierDamagedMessage then
		print("ServerSoldierDamagedMessage")
	end
	if p_Message.type == MessageType.ServerSoldierSoldierDamageMessage then
		print("ServerSoldierSoldierDamageMessage")
	end
	if p_Message.type == MessageType.ServerCollisionProjectileImpactMessage then
		print("ServerCollisionProjectileImpactMessage")
	end





end




function NoFlightCeilingServer:InstallHooks()

end

function NoFlightCeilingServer:InitComponents()
	self.m_SharedPatches = SharedPatches()
end

function NoFlightCeilingServer:Loaded()
	self.m_SharedPatches:OnLoaded()
end




g_NoFlightCeilingServer = NoFlightCeilingServer()