class 'worldtoscreendemoClient'


function worldtoscreendemoClient:__init()
	print("Initializing worldtoscreendemoClient")
	self:RegisterVars()
	self:RegisterEvents()
end


function worldtoscreendemoClient:RegisterVars()
	--self.m_this = that
end


function worldtoscreendemoClient:RegisterEvents()
	self.m_ReadInstanceEvent = Events:Subscribe('Partition:ReadInstance', self, self.ReadInstance)
	self.m_UpdateEvent = Events:Subscribe("Engine:Update", self, self.OnUpdate)
end

function worldtoscreendemoClient:OnUpdate(p_Delta, p_SimulationDelta)
	local s_Transform = Vec3(100, 100, 100)
	--local s_Player = PlayerManager:GetLocalPlayer()
	if s_Player == nil then
		return
	end
	if s_Player.soldier == nil then
		return
	end
	local s_Soldier = s_Player.soldier

	--local trans = string.format("SetWorld(%s)", tostring(SharedUtils:WorldToScreen(s_Transform)))
	--print(trans)
	--WebUI:ExecuteJS(trans)
end

function worldtoscreendemoClient:ReadInstance(p_Instance, p_Guid)
	

end


g_worldtoscreendemoClient = worldtoscreendemoClient()

return worldtoscreendemoClient